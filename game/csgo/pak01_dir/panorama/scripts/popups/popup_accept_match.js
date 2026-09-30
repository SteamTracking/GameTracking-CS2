"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../util_gamemodeflags.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/sessionutil.ts" />
/// <reference path="../popups/popup_premier_pick_ban.ts" />
/// <reference path="../common/teamcolor.ts" />
/// <reference path="../rating_emblem.ts" />
/// <reference path="../avatar.ts" />
var PopupAcceptMatch;
(function (PopupAcceptMatch) {
    let m_hasPressedAccept = false;
    let m_numPlayersReady = 0;
    let m_numTotalClientsInReservation = 0;
    let m_numSecondsRemaining = 0;
    let m_isReconnect = false;
    let m_isNqmmAnnouncementOnly = false;
    let m_gsLocation = '';
    let m_gsPing = 0;
    let m_lobbySettings = null;
    const m_elTimer = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchCountdown');
    let m_jsTimerUpdateHandle = false;
    function Init() {
        const elPlayerSlots = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchSlots');
        elPlayerSlots.RemoveAndDeleteChildren();
        const settings = $.GetContextPanel().GetAttributeString('map_and_isreconnect', '');
        m_gsLocation = $.GetContextPanel().GetAttributeString('location', '');
        m_gsPing = parseInt($.GetContextPanel().GetAttributeString('ping', '0'));
        $.GetContextPanel().SetDialogVariable('region', m_gsLocation);
        $.GetContextPanel().SetDialogVariableInt('ping', m_gsPing);
        const settingsList = settings.split(',');
        let map = settingsList[0];
        if (map.charAt(0) === '@') {
            m_isNqmmAnnouncementOnly = true;
            m_hasPressedAccept = true;
            map = map.substr(1);
        }
        m_isReconnect = settingsList[1] === 'true' ? true : false;
        m_lobbySettings = LobbyAPI.GetSessionSettings();
        if (!m_isReconnect && m_lobbySettings && m_lobbySettings.game) {
            const elAgreement = $.GetContextPanel().FindChildInLayoutFile('Agreement');
            elAgreement.visible = true;
            const elAgreementComp = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchAgreementCompetitive');
            elAgreementComp.visible = m_lobbySettings.game.mode === "competitive";
        }
        $.DispatchEvent("ShowReadyUpPanel");
        _SetMatchData(map);
        _UpdateGameServerUi();
        if (m_isNqmmAnnouncementOnly) {
            $('#AcceptMatchDataContainer').SetHasClass('auto', true);
            _UpdateUiState();
            $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'popup_accept_match_confirmed_casual', 'MOUSE', 6.0);
            m_jsTimerUpdateHandle = $.Schedule(4.5, _OnNqmmAutoReadyUp);
        }
        _PopulatePlayerList();
        $.DispatchEvent('MuteStreamPanel');
    }
    PopupAcceptMatch.Init = Init;
    function _PopulatePlayerList() {
        let numPlayers = LobbyAPI.GetConfirmedMatchPlayerCount();
        if (!numPlayers || numPlayers <= 2)
            return;
        $.GetContextPanel().SetHasClass("accept-match-with-player-list", true);
        $.GetContextPanel().FindChildInLayoutFile('id-map-draft-phase-teams').RemoveClass('hidden');
        let iYourXuidTeamIdx = 0;
        const yourXuid = MyPersonaAPI.GetXuid();
        for (let i = 0; i < numPlayers; ++i) {
            const xuidPlayer = LobbyAPI.GetConfirmedMatchPlayerByIdx(i);
            if (xuidPlayer && xuidPlayer === yourXuid)
                iYourXuidTeamIdx = (i < (numPlayers / 2)) ? 0 : 1;
        }
        for (let i = 0; i < numPlayers; ++i) {
            let xuid = LobbyAPI.GetConfirmedMatchPlayerByIdx(i);
            if (!xuid) {
                continue;
            }
            const iThisPlayerTeamIdx = (i < (numPlayers / 2)) ? 0 : 1;
            const teamPanelId = (iYourXuidTeamIdx === iThisPlayerTeamIdx) ? 'id-map-draft-phase-your-team' : 'id-map-draft-phase-other-team';
            const elTeammates = $.GetContextPanel().FindChildInLayoutFile(teamPanelId).FindChild('id-map-draft-phase-avatars');
            _MakeAvatar(xuid, elTeammates, true);
        }
    }
    function _MakeAvatar(xuid, elTeammates, bisTeamLister = false) {
        const panelType = bisTeamLister ? 'Button' : 'Panel';
        const elAvatar = $.CreatePanel(panelType, elTeammates, xuid);
        elAvatar.BLoadLayoutSnippet('SmallAvatar');
        if (bisTeamLister) {
            _AddOpenPlayerCardAction(elAvatar, xuid);
        }
        elAvatar.FindChildTraverse('JsAvatarImage').PopulateFromSteamID(xuid);
        const elTeamColor = elAvatar.FindChildInLayoutFile('JsAvatarTeamColor');
        elTeamColor.visible = false;
        elAvatar.SetDialogVariable('xuid', xuid);
    }
    function _AddOpenPlayerCardAction(elAvatar, xuid) {
        elAvatar.SetPanelEvent("onactivate", () => {
            $.DispatchEvent('SidebarContextMenuActive', true);
            if (xuid !== "0") {
                const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => $.DispatchEvent('SidebarContextMenuActive', false));
                contextMenuPanel.AddClass("ContextMenu_NoArrow");
            }
        });
    }
    function _UpdateGameServerUi() {
        const elGameServer = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchGameServer');
        elGameServer.SetHasClass('hidden', m_hasPressedAccept || m_isReconnect || m_isNqmmAnnouncementOnly ||
            !(m_gsLocation && m_gsPing));
    }
    function _UpdateUiState() {
        _UpdateGameServerUi();
        const btnAccept = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchBtn');
        const elPlayerSlots = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchSlots');
        let bHideTimer = false;
        let bShowPlayerSlots = m_hasPressedAccept || m_isReconnect;
        if (m_isNqmmAnnouncementOnly) {
            bShowPlayerSlots = false;
            bHideTimer = true;
        }
        btnAccept.SetHasClass('hidden', m_hasPressedAccept || m_isReconnect);
        elPlayerSlots.SetHasClass('hidden', !bShowPlayerSlots);
        if (bShowPlayerSlots) {
            _UpdatePlayerSlots(elPlayerSlots);
            bHideTimer = true;
        }
        m_elTimer.GetChild(0).text = "0:" + ((m_numSecondsRemaining < 10) ? "0" : "") + m_numSecondsRemaining;
        m_elTimer.SetHasClass("hidden", bHideTimer || (m_numSecondsRemaining <= 0));
        CancelTimerSound();
    }
    function CancelTimerSound() {
        if (m_jsTimerUpdateHandle) {
            $.CancelScheduled(m_jsTimerUpdateHandle);
            m_jsTimerUpdateHandle = false;
        }
    }
    function _UpdateTimeRemainingSeconds() {
        m_numSecondsRemaining = LobbyAPI.GetReadyTimeRemainingSeconds();
    }
    function _OnTimerUpdate() {
        m_jsTimerUpdateHandle = false;
        _UpdateTimeRemainingSeconds();
        _UpdateUiState();
        if (m_numSecondsRemaining > 0) {
            if (m_hasPressedAccept) {
                $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'popup_accept_match_waitquiet', 'MOUSE', 1.0);
            }
            else {
                $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'popup_accept_match_beep', 'MOUSE', 1.0);
            }
            m_jsTimerUpdateHandle = $.Schedule(1.0, _OnTimerUpdate);
        }
    }
    function _ReadyForMatch(shouldShow, playersReadyCount, numTotalClientsInReservation) {
        if (!shouldShow) {
            if (m_jsTimerUpdateHandle) {
                $.CancelScheduled(m_jsTimerUpdateHandle);
                m_jsTimerUpdateHandle = false;
            }
            $.DispatchEvent("CloseAcceptPopup");
            $.DispatchEvent('UIPopupButtonClicked', '');
            return;
        }
        if (m_hasPressedAccept && m_numPlayersReady && (playersReadyCount > m_numPlayersReady)) {
            $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'popup_accept_match_person', 'MOUSE', 1.0);
        }
        if (playersReadyCount == 1 && numTotalClientsInReservation == 1 && (m_numTotalClientsInReservation > 1)) {
            numTotalClientsInReservation = m_numTotalClientsInReservation;
            playersReadyCount = m_numTotalClientsInReservation;
        }
        m_numPlayersReady = playersReadyCount;
        m_numTotalClientsInReservation = numTotalClientsInReservation;
        _UpdateTimeRemainingSeconds();
        _UpdateUiState();
        m_jsTimerUpdateHandle = $.Schedule(1.0, _OnTimerUpdate);
    }
    function _UpdatePlayerSlots(elPlayerSlots) {
        for (let i = 0; i < m_numTotalClientsInReservation; i++) {
            let Slot = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchSlot' + i);
            if (!Slot) {
                Slot = $.CreatePanel('Panel', elPlayerSlots, 'AcceptMatchSlot' + i);
                Slot.BLoadLayoutSnippet('AcceptMatchPlayerSlot');
            }
            Slot.SetHasClass('accept-match__slots__player--accepted', (i < m_numPlayersReady));
        }
        const labelPlayersAccepted = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchPlayersAccepted');
        labelPlayersAccepted.SetDialogVariableInt('accepted', m_numPlayersReady);
        labelPlayersAccepted.SetDialogVariableInt('slots', m_numTotalClientsInReservation);
        labelPlayersAccepted.text = $.Localize('#match_ready_players_accepted', labelPlayersAccepted);
    }
    function _SetMatchData(map) {
        if (!m_lobbySettings || !m_lobbySettings.game)
            return;
        let gameMode = m_lobbySettings.game.mode;
        if (gameMode === "skirmish")
            gameMode = "gungameprogressive";
        const labelData = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchModeMap');
        let strLocalize = '#match_ready_match_data';
        labelData.SetDialogVariable('mode', $.Localize('#SFUI_GameMode_' + gameMode));
        const flags = parseInt(m_lobbySettings.game.gamemodeflags);
        if (GameModeFlags.DoesModeUseFlags(gameMode) && flags &&
            GameModeFlags.DoesModeShowUserVisibleFlags(gameMode)) {
            labelData.SetDialogVariable('modifier', $.Localize('#play_setting_gamemodeflags_' + gameMode + '_' + flags));
            strLocalize = '#match_ready_match_data_modifier';
        }
        if (MyPersonaAPI.GetElevatedState() === 'elevated' && SessionUtil.DoesGameModeHavePrimeQueue(gameMode) && ((m_lobbySettings.game.prime !== 1) || !SessionUtil.AreLobbyPlayersPrime())) {
            $.GetContextPanel().FindChildInLayoutFile('AcceptMatchWarning').RemoveClass('hidden');
        }
        labelData.SetDialogVariable('map', $.Localize('#SFUI_Map_' + map));
        if ((gameMode === 'competitive') && (map === 'lobby_mapveto')) {
            $('#AcceptMatchModeIcon').SetImage("file://{images}/icons/ui/competitive_teams.svg");
            if (m_lobbySettings.options && m_lobbySettings.options.challengekey) {
                strLocalize = '#match_ready_match_data_map';
                labelData.SetDialogVariable('map', $.Localize('#SFUI_Lobby_LeaderMatchmaking_Type_PremierPrivateQueue'));
            }
        }
        labelData.text = $.Localize(strLocalize, labelData);
        const imgMap = $.GetContextPanel().FindChildInLayoutFile('AcceptMatchMapImage');
        imgMap.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/360p/' + map + '.png")';
    }
    function _OnNqmmAutoReadyUp() {
        m_jsTimerUpdateHandle = false;
        LobbyAPI.SetLocalPlayerReady('deferred');
        $.DispatchEvent("CloseAcceptPopup");
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    function OnAcceptMatchPressed() {
        m_hasPressedAccept = true;
        $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'popup_accept_match_person', 'MOUSE', 1.0);
        LobbyAPI.SetLocalPlayerReady('accept');
    }
    PopupAcceptMatch.OnAcceptMatchPressed = OnAcceptMatchPressed;
    function ShowPreMatchInterface() {
        PremierPickBan.Init();
        $.GetContextPanel().FindChildInLayoutFile('id-accept-match').AddClass('hide');
        CancelTimerSound();
    }
    PopupAcceptMatch.ShowPreMatchInterface = ShowPreMatchInterface;
    $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ReadyUpForMatch', _ReadyForMatch);
    $.RegisterForUnhandledEvent('MatchAssistedAccept', OnAcceptMatchPressed);
    $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ShowPreMatchInterface', ShowPreMatchInterface);
})(PopupAcceptMatch || (PopupAcceptMatch = {}));
