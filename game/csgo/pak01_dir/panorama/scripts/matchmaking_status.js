"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
var MatchmakingStatus;
(function (MatchmakingStatus) {
    let _m_searchTimeUpdateHandle = false;
    let _m_elStatusPanel = $.GetContextPanel();
    let _m_showMatchingMissions = true;
    function _BCanShow() {
        if (_m_elStatusPanel.GetAttributeString('data-type', '') === 'hud') {
            let mode = GameStateAPI.GetGameModeInternalName(false);
            if (mode === 'survival') {
                let teamCount = Number(GameInterfaceAPI.GetSettingString('sv_dz_team_count'));
                if (teamCount > 1)
                    return false;
                else
                    return true;
            }
            else {
                return false;
            }
        }
        return true;
    }
    function _SessionUpdate() {
        if (!_m_elStatusPanel || !_m_elStatusPanel.IsValid())
            return;
        _UpdateMatchmakingStatus();
    }
    function _UpdateMatchmakingStatus() {
        let lobbySettings = LobbyAPI.GetSessionSettings().game;
        if (!LobbyAPI.IsSessionActive() || !_BCanShow()) {
            _m_elStatusPanel.SetHasClass('hidden', true);
            return;
        }
        _m_elStatusPanel.SetHasClass('hidden', false);
        _UpdateStatusPanel(lobbySettings);
    }
    ;
    function _UpdateStatusPanel(lobbySettings) {
        _CancelSearchTimeUpdate();
        _UpdateSearchWaitPanel(lobbySettings);
        _SearchPanelSearching(lobbySettings);
        _ShowMatchmakingWarnings(lobbySettings);
        _CheckForMatchingMissions(lobbySettings);
    }
    function _UpdateSearchWaitPanel(lobbySettings) {
        let elStatusWait = _m_elStatusPanel.FindChildInLayoutFile('MatchStatusWait');
        if (!lobbySettings || _IsHost() || _IsSeaching()) {
            elStatusWait.AddClass('hidden');
            return;
        }
        elStatusWait.RemoveClass('hidden');
        elStatusWait.FindChildInLayoutFile('MatchStatusWaitLabel').text = $.Localize("#party_waiting_lobby_leader");
    }
    ;
    function _SearchPanelSearching(lobbySettings) {
        let elStatusSearching = _m_elStatusPanel.FindChildInLayoutFile('MatchStatusSearching');
        if (!lobbySettings || !_IsSeaching()) {
            elStatusSearching.AddClass('hidden');
            _m_showMatchingMissions = true;
            _CancelSearchTimeUpdate();
            return;
        }
        elStatusSearching.RemoveClass('hidden');
        let unavailableMatch = _GetSearchStatus().indexOf('unavailable') !== -1 ? true : false;
        let elWarningIcon = elStatusSearching.FindChildInLayoutFile('MatchStatusFailIcon');
        elWarningIcon.SetHasClass('hidden', !unavailableMatch);
        let elSearchTime = elStatusSearching.FindChildInLayoutFile('MatchStatusTime');
        elSearchTime.SetHasClass('hidden', unavailableMatch);
        let elLabel = elStatusSearching.FindChildInLayoutFile('MatchStatusSearchingLabel');
        elLabel.text = $.Localize(_GetSearchStatus());
        if (unavailableMatch)
            return;
        _UpdateSearchTime();
    }
    ;
    function _ShowMatchmakingWarnings(lobbySettings) {
        let elStatusWarnings = _m_elStatusPanel.FindChildInLayoutFile('MatchStatusWarning');
        if (!lobbySettings || !_IsSeaching()) {
            elStatusWarnings.AddClass('hidden');
            return;
        }
        elStatusWarnings.RemoveClass('hidden');
        let serverWarning = NewsAPI.GetCurrentActiveAlertForUser();
        let isWarning = serverWarning !== '' && serverWarning !== undefined ? true : false;
        elStatusWarnings.SetHasClass('hidden', !isWarning);
        if (isWarning)
            elStatusWarnings.FindChild('MatchStatusWarningLabel').text = $.Localize(serverWarning);
    }
    ;
    function _CheckForMatchingMissions(lobbySettings) {
        let nSeasonAccess = GameTypesAPI.GetActiveSeasionIndexValue();
        if (nSeasonAccess < 0 || nSeasonAccess === null) {
            return;
        }
        if (_IsSeaching() && lobbySettings && lobbySettings.mapgroupname && _m_showMatchingMissions) {
            // @ts-expect-error OperationUtil is still JS
            OperationUtil.MissionsThatMatchYourMatchMakingSettings(lobbySettings.mode, lobbySettings.mapgroupname.split(','), nSeasonAccess);
            _m_showMatchingMissions = false;
        }
    }
    function _IsHost() {
        return LobbyAPI.BIsHost();
    }
    function _GetSearchStatus() {
        return LobbyAPI.GetMatchmakingStatusString();
    }
    ;
    function _IsSeaching() {
        let StatusString = _GetSearchStatus();
        return (StatusString !== '' && StatusString !== null) ? true : false;
    }
    function _UpdateSearchTime() {
        let seconds = LobbyAPI.GetTimeSpentMatchmaking();
        let elSearchTime = _m_elStatusPanel.FindChildInLayoutFile('MatchStatusTime');
        elSearchTime.text = FormatText.SecondsToDDHHMMSSWithSymbolSeperator(seconds);
        _m_searchTimeUpdateHandle = $.Schedule(1.0, _UpdateSearchTime);
    }
    function _CancelSearchTimeUpdate() {
        if (_m_searchTimeUpdateHandle !== false) {
            $.CancelScheduled(_m_searchTimeUpdateHandle);
            _m_searchTimeUpdateHandle = false;
        }
    }
    function _OnHideMainMenu() {
        _CancelSearchTimeUpdate();
    }
    function _OnHidePauseMenu() {
        _CancelSearchTimeUpdate();
    }
    ;
    function _OnShowMenu() {
        _UpdateMatchmakingStatus();
    }
    {
        _UpdateMatchmakingStatus();
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _SessionUpdate);
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', _SessionUpdate);
        $.RegisterForUnhandledEvent("CSGOHideMainMenu", _OnHideMainMenu);
        $.RegisterForUnhandledEvent("CSGOHidePauseMenu", _OnHidePauseMenu);
        $.RegisterForUnhandledEvent("CSGOShowPauseMenu", _OnShowMenu);
        $.RegisterForUnhandledEvent("CSGOShowMainMenu", _OnShowMenu);
    }
})(MatchmakingStatus || (MatchmakingStatus = {}));
