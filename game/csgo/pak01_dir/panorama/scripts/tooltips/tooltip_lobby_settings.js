"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/sessionutil.ts" />
/// <reference path="../util_gamemodeflags.ts" />
var TooltipLobby;
(function (TooltipLobby) {
    let m_GameSettings = {};
    let m_GameOptions = {};
    let m_RefreshStatsScheduleHandle = false;
    function Init() {
        if (LobbyAPI.IsSessionActive()) {
            _CancelStatsRefresh();
            _GetLobbySettings();
            _Permissions();
            _SetPrimeStatus();
            _SetMode();
            _SetMaps();
            _GetLobbyStatistics();
            _SetGameModeFlags();
            _SetDirectChallengeSettings();
        }
        else {
            UiToolkitAPI.HideCustomLayoutTooltip('LobbySettingsTooltip');
        }
    }
    TooltipLobby.Init = Init;
    function _CancelStatsRefresh() {
        if (m_RefreshStatsScheduleHandle !== false) {
            $.CancelScheduled(m_RefreshStatsScheduleHandle);
            m_RefreshStatsScheduleHandle = false;
        }
    }
    function _GetLobbyStatistics() {
        m_RefreshStatsScheduleHandle = $.Schedule(2, _GetLobbyStatistics);
        let searchingStatus = LobbyAPI.GetMatchmakingStatusString();
        let elMatchStats = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipStats');
        let isSearching = searchingStatus !== '' && searchingStatus !== undefined ? true : false;
        elMatchStats.SetHasClass('hidden', !isSearching);
        if (!isSearching)
            return;
        let elMatchStatsLabel = elMatchStats.FindChildInLayoutFile('LobbyTooltipStatsTitle');
        elMatchStatsLabel.text = $.Localize(searchingStatus);
        let matchmakeingStats = LobbyAPI.GetMatchmakingStatistics();
        let elStats = elMatchStats.FindChildInLayoutFile('LobbyTooltipStatsList');
        elStats.RemoveAndDeleteChildren();
        function MakeStatsRow(statType, iconName) {
            let p = $.CreatePanel('Panel', elStats, '');
            p.BLoadLayoutSnippet("SettingsEntry");
            if (statType === 'avgSearchTimeSeconds') {
                let time = FormatText.SecondsToDDHHMMSSWithSymbolSeperator(matchmakeingStats[statType]);
                p.SetDialogVariable('stat', time);
            }
            else {
                p.SetDialogVariableInt('stat', matchmakeingStats[statType]);
            }
            if (statType === 'playersLockedIn') {
                let totalPlayers = SessionUtil.GetMaxLobbySlotsForGameMode(m_GameSettings.mode);
                totalPlayers *= 2;
                p.SetDialogVariableInt('total_stat', totalPlayers);
            }
            p.FindChildInLayoutFile('SettingText').text = $.Localize('#matchmaking_stat_' + statType + ':f', p);
            p.FindChildInLayoutFile('SettingImage').SetImage('file://{images}/icons/ui/' + iconName + '.svg');
            p.FindChildInLayoutFile('SettingImage').AddClass('tint');
        }
        MakeStatsRow('avgSearchTimeSeconds', 'clock');
        MakeStatsRow('playersOnline', 'lobby');
        if (matchmakeingStats.hasOwnProperty('playersLockedIn') && matchmakeingStats.playersLockedIn
            && !["cooperative", "coopmission"].includes(m_GameSettings.mode)) {
            MakeStatsRow('playersLockedIn', 'find');
        }
        else {
            MakeStatsRow('playersSearching', 'find');
        }
        MakeStatsRow('serversOnline', 'servers');
    }
    function _GetLobbySettings() {
        let gss = LobbyAPI.GetSessionSettings();
        m_GameSettings = gss.game;
        m_GameOptions = gss.options;
    }
    function _SetPrimeStatus() {
        let isLocalPlayerPrime = MyPersonaAPI.GetElevatedState() === "elevated";
        let displayText = !isLocalPlayerPrime
            ? '#prime_not_enrolled_label'
            : (m_GameSettings.prime === 1 && SessionUtil.AreLobbyPlayersPrime())
                ? '#prime_only_label'
                : '#prime_priority_label';
        let elPrimeText = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipPrime');
        elPrimeText.text = $.Localize(displayText);
        _SetRankedStatus(isLocalPlayerPrime);
    }
    function _SetDirectChallengeSettings() {
        let elDirectChallengeText = $.GetContextPanel().FindChildInLayoutFile('LobbyDirectChallenge');
        let gss = LobbyAPI.GetSessionSettings();
        let bPrivate = gss.options.hasOwnProperty('challengekey') && gss.options.challengekey != '';
        elDirectChallengeText.text = bPrivate ? $.Localize('#DirectChallenge_lobbysettings_on2') : $.Localize('#DirectChallenge_lobbysettings_off');
        let elContainer = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipDirectChallengeContainer');
        elContainer.visible = bPrivate;
    }
    function _SetGameModeFlags() {
        let elContainer = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipGameModeFlagsContainer');
        let flags = parseInt(m_GameSettings.gamemodeflags);
        if (!flags || !GameModeFlags.DoesModeUseFlags(m_GameSettings.mode) ||
            !GameModeFlags.DoesModeShowUserVisibleFlags(m_GameSettings.mode)) {
            elContainer.visible = false;
            return;
        }
        elContainer.visible = true;
        let displayTextToken = '#play_setting_gamemodeflags_' + m_GameSettings.mode + '_' + m_GameSettings.gamemodeflags;
        elContainer.SetDialogVariable('gamemodeflags', $.Localize(displayTextToken));
        let elIcon = $.GetContextPanel().FindChildTraverse('LobbyTooltipGamdeModeFlagsImage');
        let icon = GameModeFlags.GetIcon(m_GameSettings.mode, flags);
        elIcon.SetImage(icon);
    }
    function _SetRankedStatus(isLocalPlayerPrime) {
        let elRankedText = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipRanked');
        if (!isLocalPlayerPrime || !SessionUtil.DoesGameModeHavePrimeQueue(m_GameSettings.mode)) {
            elRankedText.GetParent().visible = false;
            return;
        }
        elRankedText.GetParent().visible = true;
        let isRanked = m_GameSettings.prime === 1 && SessionUtil.AreLobbyPlayersPrime();
        elRankedText.text = isRanked ? $.Localize("#prime_ranked") : $.Localize("#prime_unranked");
    }
    function _Permissions() {
        let systemSettings = LobbyAPI.GetSessionSettings().system;
        if (!systemSettings)
            return;
        let systemAccess = systemSettings.access;
        let displayText = '';
        if (systemAccess === 'public') {
            displayText = '#permissions_' + systemAccess;
        }
        else {
            displayText = '#permissions_' + systemAccess;
        }
        $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipPermissions').text = $.Localize(displayText);
    }
    function _SetMode() {
        let elGameModeTitle = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipGameMode');
        elGameModeTitle.FindChild('SettingText').text = $.Localize('#SFUI_GameMode' + m_GameSettings.mode_ui);
        elGameModeTitle.FindChild('SettingImage').SetImage('file://{images}/icons/ui/' + m_GameSettings.mode + '.svg');
        elGameModeTitle.FindChild('SettingImage').SetHasClass('tint', m_GameSettings.mode !== "competitive");
    }
    function _SetMaps() {
        if (!m_GameSettings.mapgroupname)
            return;
        let mapsList;
        mapsList = m_GameSettings.mapgroupname.split(',');
        let elMapsSection = $.GetContextPanel().FindChildInLayoutFile('LobbyTooltipMapsList');
        elMapsSection.RemoveAndDeleteChildren();
        $.CreatePanel('Label', elMapsSection, 'LobbyMapsListTitle', {
            class: 'tooltip-player-xp__title--small',
            text: '#party_tooltip_maps'
        });
        for (let element of mapsList) {
            let p = $.CreatePanel('Panel', elMapsSection, element);
            p.BLoadLayoutSnippet("SettingsEntry");
            let strMapText = '';
            if (element === 'mg_lobby_mapveto' && m_GameOptions && m_GameOptions.challengekey) {
                strMapText = $.Localize("#SFUI_Lobby_LeaderMatchmaking_Type_PremierPrivateQueue");
            }
            else if (m_GameSettings.mode === "skirmish") {
                strMapText = $.Localize(GameTypesAPI.GetMapGroupAttribute('mg_' + m_GameSettings.map, 'nameID'));
            }
            else {
                strMapText = $.Localize(GameTypesAPI.GetMapGroupAttribute(element, 'nameID'));
            }
            p.FindChildInLayoutFile('SettingText').text = strMapText;
            let iconName;
            if (m_GameSettings.mode === "skirmish") {
                iconName = m_GameSettings.map;
            }
            else {
                iconName = GameTypesAPI.GetMapGroupAttributeSubKeys(element, 'maps').split(',')[0];
            }
            p.FindChildInLayoutFile('SettingImage').SetImage('file://{images}/map_icons/map_icon_' + iconName + '.svg');
        }
    }
    $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", Init);
    $.RegisterForUnhandledEvent("CSGOHideMainMenu", _CancelStatsRefresh);
    $.RegisterForUnhandledEvent("CSGOHidePauseMenu", _CancelStatsRefresh);
})(TooltipLobby || (TooltipLobby = {}));
