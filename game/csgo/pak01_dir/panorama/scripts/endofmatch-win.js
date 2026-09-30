"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="endofmatch.ts" />
var EOM_Win;
(function (EOM_Win) {
    const _m_pauseBeforeEnd = 5.0;
    const _m_cP = $.GetContextPanel();
    let _m_oMatchEndData = undefined;
    let _m_oScoreData = undefined;
    const _m_nT = 2;
    function _SetVictoryStatement() {
        if (!_m_cP || !_m_cP.IsValid())
            return;
        if (!_m_oMatchEndData)
            return;
        if (!_m_oScoreData)
            return;
        const winningTeamNumber = _m_oMatchEndData.winning_team_number;
        let result = "#eom-result-tie3";
        const teamT = _m_oScoreData.teamdata.find(td => td.team_name === "TERRORIST");
        const teamCT = _m_oScoreData.teamdata.find(td => td.team_name === "CT");
        let localPlayerTeamScore = teamT.score;
        let otherTeamNumber = teamCT.score;
        _m_cP.RemoveClass('eom-win_won');
        _m_cP.RemoveClass('eom-win_lost');
        _m_cP.SetDialogVariable("teamname", "");
        if (winningTeamNumber) {
            const localPlayerTeamNumber = MockAdapter.GetPlayerTeamNumber(MockAdapter.GetLocalPlayerXuid());
            const mode = EOM_Characters.GetModeForEndOfMatchPurposes();
            const bForceShowWinningTeam = EOM_Characters.ShowWinningTeam(mode);
            if (GameStateAPI.IsDemoOrHltv() || (localPlayerTeamNumber != 2 && localPlayerTeamNumber != 3) || bForceShowWinningTeam) {
                localPlayerTeamScore = winningTeamNumber == _m_nT ? teamT.score : teamCT.score;
                otherTeamNumber = winningTeamNumber == _m_nT ? teamCT.score : teamT.score;
                result = "#eom-result-win3";
                _m_cP.SetHasClass('eom-win_won', true);
            }
            else {
                localPlayerTeamScore = localPlayerTeamNumber == _m_nT ? teamT.score : teamCT.score;
                otherTeamNumber = localPlayerTeamNumber == _m_nT ? teamCT.score : teamT.score;
                result = winningTeamNumber == localPlayerTeamNumber ? "#eom-result-win3" : "#eom-result-loss3";
                _m_cP.SetHasClass('eom-win_won', winningTeamNumber == localPlayerTeamNumber);
                _m_cP.SetHasClass('eom-win_lost', winningTeamNumber != localPlayerTeamNumber);
            }
        }
        if (_m_oMatchEndData.hasOwnProperty('match_cancelled') && _m_oMatchEndData.match_cancelled) {
            _m_cP.SetHasClass('eom-win_won', false);
            _m_cP.SetHasClass('eom-win_lost', false);
            result = '#SFUI_match_cancelled';
        }
        if (_m_oMatchEndData.hasOwnProperty('cancel_reason_code') && _m_oMatchEndData.cancel_reason_code) {
            _ShowMatchCancelledEarlyWithReasonExplanation(_m_oMatchEndData.cancel_reason_code);
        }
        _m_cP.SetDialogVariable("win-result", $.Localize(result));
        _m_cP.SetDialogVariableInt("score_local_player", localPlayerTeamScore);
        _m_cP.SetDialogVariableInt("score_other", otherTeamNumber);
        _AnimStart();
    }
    function _AnimStart() {
        const elPanel = $.GetContextPanel().FindChildTraverse('WinTeam');
        elPanel.TriggerClass('show');
    }
    function _ShowMatchCancelledEarlyWithReasonExplanation(cancel_reason_code) {
        const elPanel = $.GetContextPanel().FindChildTraverse('EomCancelReason' + cancel_reason_code);
        if (elPanel) {
            elPanel.AddClass('show');
        }
    }
    function _DisplayMe() {
        _m_oMatchEndData = MockAdapter.GetMatchEndWinDataJSO();
        _m_oScoreData = MockAdapter.GetScoreDataJSO();
        if (!_m_oMatchEndData)
            return false;
        if (!_m_oScoreData ||
            !_m_oScoreData.teamdata.some(td => td.team_name === "CT") ||
            !_m_oScoreData.teamdata.some(td => td.team_name === "TERRORIST"))
            return false;
        if (_m_oMatchEndData.hasOwnProperty('winning_player'))
            return false;
        if (GameStateAPI.GetGameModeInternalName(false) == 'deathmatch')
            return false;
        _SetVictoryStatement();
        return true;
    }
    function Start() {
        if (MockAdapter.GetMockData() && !MockAdapter.GetMockData().includes('EOM_WIN')) {
            _End();
            return;
        }
        if (_DisplayMe()) {
            EndOfMatch.SwitchToPanel('eom-win');
            EndOfMatch.StartDisplayTimer(_m_pauseBeforeEnd);
            $.Schedule(_m_pauseBeforeEnd, _End);
        }
        else {
            _End();
            return;
        }
    }
    function _End() {
        EndOfMatch.ShowNextPanel();
    }
    function Shutdown() {
    }
    {
        EndOfMatch.RegisterPanelObject({
            name: 'eom-win',
            Start: Start,
            Shutdown: Shutdown
        });
    }
})(EOM_Win || (EOM_Win = {}));
