"use strict";
/// <reference path="csgo.d.ts" />
var MatchmakingReconnect;
(function (MatchmakingReconnect) {
    const m_elOngoingMatch = $.GetContextPanel();
    let m_bAcceptIsShowing = false; // This should sync up with when popup_accept_match is visible.
    let m_bOngoingMatchHasEnded = false; // Set by OnGamePhaseChanged. Cleared by HasOngoingMatch() == false.
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
        m_bOngoingMatchHasEnded = nGamePhase === 5; // GAMEPHASE_MATCH_ENDED
        UpdateState();
    }
    function OnSidebarIsCollapsed(bIsCollapsed) {
        m_elOngoingMatch.SetHasClass('sidebar-collapsed', bIsCollapsed);
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        Init();
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", UpdateState);
        // PanoramaComponent_GC_Hello sets has_ongoingmatch. we should update the button state to show reconnect/abandon if necessary
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', UpdateState);
        $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ReadyUpForMatch', ReadyUpForMatch);
        $.RegisterForUnhandledEvent('GameState_OnGamePhaseChange', OnGamePhaseChange);
        $.RegisterForUnhandledEvent('SidebarIsCollapsed', OnSidebarIsCollapsed);
    }
})(MatchmakingReconnect || (MatchmakingReconnect = {}));
//DEVONLY{
function nextState(curState) {
    if (curState === "hidden") {
        curState = "actions";
    }
    else if (curState === "actions") {
        curState = "cancel";
    }
    else if (curState === "cancel") {
        curState = "hidden";
    }
    $.Msg("nextState " + curState);
    const cp = $.GetContextPanel();
    cp.SetHasClass('show-actions', curState === "actions");
    cp.SetHasClass('show-cancel', curState === "cancel");
    $.Schedule(2.0, () => nextState(curState));
}
// $.Schedule( 2.0, () => nextState( "hidden" ) );
//}DEVONLY
