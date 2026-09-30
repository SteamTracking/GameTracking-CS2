"use strict";
/// <reference path="csgo.d.ts" />
var MatchmakingReconnect;
(function (MatchmakingReconnect) {
    const m_elOngoingMatch = $.GetContextPanel();
    let m_bAcceptIsShowing = false;
    let m_bOngoingMatchHasEnded = false;
    function Init() {
        const btnReconnect = m_elOngoingMatch.FindChildInLayoutFile('MatchmakingReconnect');
        btnReconnect.SetPanelEvent('onactivate', () => {
            CompetitiveMatchAPI.ActionReconnectToOngoingMatch();
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
            UpdateState();
        });
        const btnAbandon = m_elOngoingMatch.FindChildInLayoutFile('MatchmakingAbandon');
        btnAbandon.SetPanelEvent('onactivate', () => {
            CompetitiveMatchAPI.ActionAbandonOngoingMatch();
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
            UpdateState();
        });
        const btnCancel = m_elOngoingMatch.FindChildInLayoutFile('MatchmakingCancel');
        btnCancel.SetPanelEvent('onactivate', () => {
            LobbyAPI.StopMatchmaking();
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
            UpdateState();
        });
        UpdateState();
    }
    function UpdateState() {
        const bHasOngoingMatch = CompetitiveMatchAPI.HasOngoingMatch();
        if (!bHasOngoingMatch) {
            m_bOngoingMatchHasEnded = false;
        }
        const bCanReconnect = bHasOngoingMatch && !m_bOngoingMatchHasEnded;
        const sessionSettings = LobbyAPI.GetSessionSettings();
        const bIsReconnecting = sessionSettings?.game?.mapgroupname === "reconnect";
        m_elOngoingMatch.SetHasClass('show-actions', bCanReconnect && !bIsReconnecting && !m_bAcceptIsShowing);
        m_elOngoingMatch.SetHasClass('show-cancel', bCanReconnect && bIsReconnecting && !m_bAcceptIsShowing);
    }
    function ReadyUpForMatch(shouldShow) {
        m_bAcceptIsShowing = shouldShow;
        UpdateState();
    }
    function OnGamePhaseChange(nGamePhase) {
        m_bOngoingMatchHasEnded = nGamePhase === 5;
        UpdateState();
    }
    function OnSidebarIsCollapsed(bIsCollapsed) {
        m_elOngoingMatch.SetHasClass('sidebar-collapsed', bIsCollapsed);
    }
    {
        Init();
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", UpdateState);
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', UpdateState);
        $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ReadyUpForMatch', ReadyUpForMatch);
        $.RegisterForUnhandledEvent('GameState_OnGamePhaseChange', OnGamePhaseChange);
        $.RegisterForUnhandledEvent('SidebarIsCollapsed', OnSidebarIsCollapsed);
    }
})(MatchmakingReconnect || (MatchmakingReconnect = {}));
