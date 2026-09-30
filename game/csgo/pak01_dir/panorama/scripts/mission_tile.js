"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="segmented_progress_bar.ts" />
$.LogChannel("p.missions", "LV_OFF");
var MissionTile;
(function (MissionTile) {
    function IsTheInGamePanel() {
        return ($.GetContextPanel().id === 'HudMissionPanel');
    }
    function IsThePauseMenuPanel() {
        return ($.GetContextPanel().id === 'id-pausemenu-mission-panel');
    }
    function IsTheMainMenuPanel() {
        return ($.GetContextPanel().id === 'id-mainmenu-mission-panel');
    }
    function Init(srcText) {
        if (MyPersonaAPI.GetElevatedState() != "elevated")
            return;
        // Several mission tiles are live at once (main menu, pause menu, HUD), so the
        // caller tag and panel id are what tell their p.missions spew apart.
        const logPrefix = '[p.missions] ' + srcText + ': ' + $.GetContextPanel().id + ': ';
        $.Msg(logPrefix + "Init");
        let missionData = undefined;
        // in the pause menu we use the server's version if we have it so we can show live data.
        // otherwise we show global data
        if (IsThePauseMenuPanel()) {
            missionData = MissionsAPI.GetRecurringMission(false);
        }
        if (!missionData) {
            missionData = MissionsAPI.GetRecurringMission(!IsTheInGamePanel());
        }
        $.GetContextPanel().Data().m_oMissionData = missionData;
        // test
        // if ( missionData )
        // {
        // 	 missionData.progress_saved =10;
        // 	    missionData.progress_this_match = 50;
        // 	  missionData.goal_points = [ 100, 200, 400 ]; 
        // 	  missionData.xp_reward = [ 100, 100, 200 ];
        // }
        //	$.Msg( logPrefix + JSON.stringify( m_oMissionData ) );
        if (!$.GetContextPanel().Data().m_oMissionData) {
            $.Msg(logPrefix + "no GetRecurringMissions()");
            $.GetContextPanel().AddClass('hidden');
            return;
        }
        if (IsTheInGamePanel()) {
            if (!$.GetContextPanel().Data().m_livePointsCache) {
                $.GetContextPanel().Data().m_livePointsCache = -1;
            }
            if (FriendsListAPI.IsGameInWarmup()) {
                $.Msg(logPrefix + "warmup");
                $.GetContextPanel().AddClass('hidden');
                return;
            }
            if (GameStateAPI.GetMapBSPName() === 'lobby_mapveto') {
                $.Msg(logPrefix + "lobby_mapveto");
                $.GetContextPanel().AddClass('hidden');
                return;
            }
            if (!GameStateAPI.GetActiveQuestID()) {
                $.Msg(logPrefix + "NO QUEST ID");
                $.GetContextPanel().AddClass('hidden');
                return;
            }
            $.GetContextPanel().SetHasClass('stop-anims', missionData.progress_saved +
                $.GetContextPanel().Data().m_livePointsCache >= missionData.goal_points.slice(-1)[0]);
            if (missionData.progress_this_match &&
                missionData.progress_this_match > $.GetContextPanel().Data().m_livePointsCache) {
                $.GetContextPanel().TriggerClass('progress-pulse');
                $.GetContextPanel().Data().m_livePointsCache = missionData.progress_this_match;
                $.DispatchEvent('CSGOPlaySoundEffect', 'UI.Mission.QuotaUp', 'MOUSE');
                $.Msg(logPrefix + 'PULSE');
            }
        }
        else if (!IsTheInGamePanel()) {
            if (!MyPersonaAPI.IsConnectedToGC()) {
                $.Msg(logPrefix + "no gc");
                $.GetContextPanel().AddClass('hidden');
                return;
            }
            // map image
            let imagePath = 'undefined';
            if (missionData.hasOwnProperty('mapgroup') && missionData.mapgroup != '') {
                const cfg = GameTypesAPI.GetConfig();
                const mg = cfg.mapgroups[$.GetContextPanel().Data().m_oMissionData['mapgroup']];
                const keysList = Object.keys(mg.maps);
                imagePath = keysList[0];
            }
            else if (missionData.hasOwnProperty('map') && missionData.map && missionData.map != '') {
                imagePath = missionData.map;
            }
            const elBgArt = $.GetContextPanel().FindChildTraverse('missionArtBG');
            if (elBgArt) {
                elBgArt.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/720p/' + (imagePath) + '.png")';
                elBgArt.style.backgroundPosition = '50% 0%';
                elBgArt.style.backgroundSize = 'cover';
            }
            // set button
            SetButtonPlayMission();
            // force update of all styles 
            SessionUpdate();
        }
        $.GetContextPanel().SetHasClass('COMPLETE', missionData.progress_saved +
            (missionData.progress_this_match ? missionData.progress_this_match : 0) >= missionData.goal_points.slice(-1)[0]);
        $.Msg(logPrefix + "progress_this_match " + missionData.progress_this_match);
        $.GetContextPanel().RemoveClass('hidden');
        ConstructMissionStrings($.GetContextPanel());
        if (!$.GetContextPanel().Data().hasOwnProperty('id') ||
            $.GetContextPanel().Data().m_oMissionData.id != $.GetContextPanel().Data().id) {
            const elProg = $.GetContextPanel().FindChildTraverse('progressBaContainer');
            if (elProg) {
                SegmentedProgressBar.Init(elProg, missionData);
            }
            $.GetContextPanel().Data().id = missionData.id;
        }
        UpdateProgressBar(missionData);
    }
    MissionTile.Init = Init;
    function SetButtonPlayMission() {
        if (!GetButtonPanel())
            return;
        GetButtonPanel().SetPanelEvent("onactivate", () => PlayMission());
    }
    function SetButtonCancelSearch() {
        if (!GetButtonPanel())
            return;
        GetButtonPanel().SetPanelEvent("onactivate", () => LobbyAPI.StopMatchmaking());
    }
    function SetButtonEnabled(enabled) {
        if (!GetButtonPanel())
            return;
        GetButtonPanel().enabled = enabled;
        GetButtonPanel().SetHasClass('DISABLED', !enabled);
    }
    function GetButtonPanel() {
        return $.GetContextPanel().FindChildTraverse('missionButton');
    }
    function GetToolTip(elPanel) {
        return elPanel.Data().missionText;
    }
    MissionTile.GetToolTip = GetToolTip;
    function ConstructMissionStrings(elPanel) {
        const missionData = elPanel.Data().m_oMissionData;
        let progress = missionData.progress_saved;
        if (missionData.progress_this_match) {
            progress = missionData.progress_saved + missionData.progress_this_match;
            progress = Math.min(progress, missionData.goal_points.slice(-1)[0]);
        }
        let offsetProgress = progress;
        let nextXp = missionData.xp_reward.slice(0)[0];
        let goal = missionData.goal_points.slice(0)[0];
        for (let i = 0; i < missionData.goal_points.length; i++) {
            if ((progress < missionData.goal_points[i])) {
                if (i > 0) {
                    goal = missionData.goal_points[i] - missionData.goal_points[i - 1];
                    offsetProgress -= missionData.goal_points[i - 1];
                }
                nextXp = missionData.xp_reward[i];
                break;
            }
        }
        const totalXp = missionData.xp_reward.reduceRight((acc, cur) => acc + cur, 0);
        let missionPoints = missionData.goal_points.slice(-1)[0];
        elPanel.SetDialogVariableInt("mission-points", missionPoints);
        elPanel.SetDialogVariableInt("mission-progress", progress);
        elPanel.SetDialogVariableInt("mission-points-checkpoint", goal);
        elPanel.SetDialogVariable("mission-xp", totalXp);
        const elDirective = elPanel.FindChildTraverse('mission-main-label');
        if (elDirective) {
            const actionId = missionData.string_tokens?.action_id;
            const actionDirective = actionId ? $.Localize(`#mission_directive_${actionId}:f`, elPanel) : '';
            elPanel.SetDialogVariable('action_directive', actionDirective);
            const frame = progress > 0 ? '#mission_directive_progress:f' : '#mission_directive:f';
            elDirective.SetLocString(frame);
        }
        const timeRemaining = FormatText.SecondsToSignificantTimeString(missionData.seconds_remaining);
        elPanel.SetDialogVariable('mission-time-remaining', timeRemaining);
        elPanel.SetHasClass('hide-time', missionData.seconds_remaining <= 0);
        ExtractStringTokens(elPanel, missionData.string_tokens);
        const desc = $.Localize(missionData.loc_description, elPanel);
        elPanel.SetDialogVariable('mission_desc', desc);
        const partialToken = missionData.loc_description.replace("desc", "partial");
        const partial = $.Localize(partialToken, elPanel);
        elPanel.SetDialogVariable('mission_partial', partial);
        const ingameToken = missionData.loc_description.replace("desc", "ingame");
        const ingame = $.Localize(ingameToken, elPanel);
        elPanel.SetDialogVariable('mission_ingame', ingame);
        const elMapIcon = elPanel.FindChildTraverse('missionMapicon');
        if (elMapIcon) {
            if (missionData.map) {
                const iconPath = "file://{images}/map_icons/map_icon_" + missionData.map + ".svg";
                elMapIcon.SetImage(iconPath);
                elMapIcon.style.visibility = 'visible';
            }
            else {
                elMapIcon.style.visibility = 'collapse';
            }
        }
        const elModeIcon = elPanel.FindChildTraverse('missionModeicon');
        if (elModeIcon) {
            if (missionData.gamemode) {
                const iconPath = "file://{images}/icons/ui/" + missionData.gamemode + ".svg";
                elModeIcon.SetImage(iconPath);
                elModeIcon.style.visibility = 'visible';
            }
            else {
                elModeIcon.style.visibility = 'collapse';
            }
        }
    }
    function ExtractStringTokens(elPanel, strings) {
        for (const k in strings) {
            if (typeof strings[k] === 'object' && !Array.isArray(strings[k]) && strings[k] !== null) {
                ExtractStringTokens(elPanel, strings[k]);
            }
            else {
                let val = strings[k];
                val = $.Localize(val);
                switch (k) {
                    case 'gamemode':
                    case 'location':
                    case 'actions':
                    case 'action':
                        val = val.toUpperCase();
                }
                elPanel.SetDialogVariable(k, val);
                //	$.Msg( 'mission string: ' + k + ' = ' + val );
            }
        }
    }
    MissionTile.ExtractStringTokens = ExtractStringTokens;
    function UpdateProgressBar(missionData) {
        const elProg = $.GetContextPanel().FindChildTraverse('progressBaContainer');
        if (!elProg)
            return;
        SegmentedProgressBar.SetValue(elProg, missionData.progress_saved, 'Base');
        if (missionData.progress_this_match) {
            const liveValue = missionData.progress_saved + missionData.progress_this_match;
            SegmentedProgressBar.SetValue(elProg, liveValue, 'Live');
        }
        $.Msg('[p.missions] ' + $.GetContextPanel().id + ': ' + missionData.progress_saved + ' ' + missionData.progress_this_match);
    }
    function GetSearchStatus() {
        return LobbyAPI.GetMatchmakingStatusString();
    }
    ;
    function IsSearching() {
        let StatusString = GetSearchStatus();
        return (StatusString !== '' && StatusString !== null) ? true : false;
    }
    function SessionUpdate() {
        if (IsTheInGamePanel() || IsThePauseMenuPanel())
            return;
        $.GetContextPanel().Data().m_oMissionData = MissionsAPI.GetRecurringMission(true);
        if (!$.GetContextPanel().Data().m_oMissionData) {
            $.GetContextPanel().AddClass('hidden');
            return;
        }
        const xuid = MyPersonaAPI.GetXuid();
        const inParty = PartyListAPI.GetCount() > 1;
        const isLobbyLeader = LobbyAPI.GetHostSteamID() === xuid;
        let isSearchingForMission = false;
        const lobbySettings = LobbyAPI.GetSessionSettings();
        if (IsSearching() && lobbySettings && lobbySettings.game) {
            const lobbySettings = LobbyAPI.GetSessionSettings();
            isSearchingForMission = lobbySettings.game.mode == $.GetContextPanel().Data().m_oMissionData.gamemode &&
                (lobbySettings.game.mapgroupname == $.GetContextPanel().Data().m_oMissionData.mapgroup ||
                    lobbySettings.game.map == $.GetContextPanel().Data().m_oMissionData.map);
        }
        GetButtonPanel().SetHasClass('LOBBY_SUB', inParty && !isLobbyLeader);
        $.GetContextPanel().SetHasClass('SEARCHING', IsSearching());
        $.GetContextPanel().SetHasClass('SEARCHING_FOR_MISSION', isSearchingForMission);
        SetButtonEnabled((!inParty || (inParty && isLobbyLeader)) && !(IsSearching() && !isSearchingForMission));
        if (isSearchingForMission) {
            SetButtonCancelSearch();
        }
        else {
            SetButtonPlayMission();
        }
    }
    function PlayMission() {
        // Init();
        //  return;
        $.DispatchEvent('PlayMenu_SwitchGameModeTab', $.GetContextPanel().Data().m_oMissionData.gamemode);
        $.DispatchEvent('CSGOPlaySoundEffect', 'mainmenu_mission_start', 'MOUSE');
        LobbyAPI.CreateSession();
        const gameMode = $.GetContextPanel().Data().m_oMissionData.gamemode;
        let gameType = "classic";
        let gmFlags = 0;
        if (gameMode === "deathmatch") {
            gameType = "gungame";
            gmFlags = 32; // ffa
        }
        let mg = $.GetContextPanel().Data().m_oMissionData.mapgroup;
        if (gameMode == "competitive") {
            mg = "mg_" + $.GetContextPanel().Data().m_oMissionData.map; // singlemap only? 
            gmFlags = 16;
        }
        var settings = {
            update: {
                Options: {
                    action: "custommatch",
                    server: "official"
                },
                Game: {
                    mode: gameMode,
                    type: gameType,
                    mapgroupname: mg,
                    map: $.GetContextPanel().Data().m_oMissionData.map ? $.GetContextPanel().Data().m_oMissionData.map : "",
                    gamemodeflags: gmFlags,
                },
            },
            delete: {
                Options: {
                    challengekey: 1
                }
            }
        };
        LobbyAPI.UpdateSessionSettings(settings);
        LobbyAPI.StartMatchmaking('', '', '', '');
    }
    function OnRoundStart() {
        $.GetContextPanel().AddClass('FREEZETIME');
    }
    function OnFreezeTimeEnd() {
        $.GetContextPanel().RemoveClass('FREEZETIME');
    }
    function UpdateHud() {
        if (IsTheInGamePanel()) {
            Init("UpdateHud");
        }
    }
    function UpdatePauseMenu() {
        if (IsThePauseMenuPanel()) {
            Init("UpdatePauseMenu");
        }
    }
    function UpdateMainMenu() {
        if (IsTheMainMenuPanel()) {
            Init("UpdateMainMenu");
        }
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        Init('default');
        $.RegisterForUnhandledEvent('OnRecurringMissionsReceived', Init.bind(null, "OnRecurringMissionsReceived"));
        $.RegisterForUnhandledEvent('OnRecurringMissionsChanged', Init.bind(null, "OnRecurringMissionsChanged"));
        $.RegisterForUnhandledEvent("GameState_OnMatchStart", UpdateHud);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', Init.bind(null, "PanoramaComponent_MyPersona_UpdateConnectionToGC"));
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', Init.bind(null, "PanoramaComponent_MyPersona_GcLogonNotificationReceived"));
        $.RegisterForUnhandledEvent("CSGOShowPauseMenu", UpdatePauseMenu);
        $.RegisterForUnhandledEvent('OnQuestProgressMade', UpdateHud);
        $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', () => { UpdateMainMenu(); UpdatePauseMenu(); });
        $.RegisterForUnhandledEvent('OnRoundFreezeTimeEnd', OnFreezeTimeEnd);
        $.RegisterForUnhandledEvent('OnRoundStart', OnRoundStart);
        $.RegisterForUnhandledEvent('CSGOShowMainMenu', UpdateMainMenu);
    }
})(MissionTile || (MissionTile = {}));
