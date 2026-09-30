"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="mock_adapter.ts" />
$.LogChannel('p.matchstakes', "LV_OFF");
var MatchStakes;
(function (MatchStakes) {
    let m_elMatchStakes = undefined;
    function _GetRootPanel() {
        let parent = $.GetContextPanel().GetParent();
        let newParent = parent.GetParent();
        while (newParent) {
            parent = newParent;
            newParent = parent.GetParent();
        }
        return parent;
    }
    function _GetMatchStakesPanel() {
        if (!m_elMatchStakes) {
            let elHud = _GetRootPanel();
            m_elMatchStakes = elHud.FindChildTraverse('MatchStakes');
        }
        return m_elMatchStakes;
    }
    function EndTeamIntro() {
        const type = MockAdapter.GetPlayerCompetitiveRankType(GameStateAPI.GetLocalPlayerXuid());
        if (type !== 'Premier')
            return;
        let elMatchStakes = _GetMatchStakesPanel();
        elMatchStakes.style.visibility = 'collapse';
        elMatchStakes.Data().teamIntroInProgress = false;
    }
    MatchStakes.EndTeamIntro = EndTeamIntro;
    function StartTeamIntro() {
        const mysteamid = GameStateAPI.GetLocalPlayerXuid();
        let rankStats = MockAdapter.GetPlayerPremierRankStatsObject(mysteamid);
        if (!rankStats || rankStats.rankType !== 'Premier')
            return;
        let elMatchStakes = _GetMatchStakesPanel();
        elMatchStakes.style.visibility = 'visible';
        elMatchStakes.Data().teamIntroInProgress = true;
        elMatchStakes.SetHasClass('no-rating', rankStats.score === 0);
        let elWin = elMatchStakes.FindChildTraverse('jsMatchStakesWin');
        let elLoss = elMatchStakes.FindChildTraverse('jsMatchStakesLoss');
        let elPfx = elMatchStakes.FindChildTraverse('jsMatchStakes_pfx');
        const score = MockAdapter.GetPlayerCompetitiveRanking(mysteamid);
        const wins = MockAdapter.GetPlayerCompetitiveWins(mysteamid);
        let options = {
            root_panel: elMatchStakes,
            rating_type: 'Premier',
            do_fx: false,
            full_details: true,
            leaderboard_details: { score: score, matchesWon: wins },
            local_player: true
        };
        RatingEmblem.SetXuid(options);
        let introText = RatingEmblem.GetIntroText(elMatchStakes);
        elMatchStakes.SetHasClass('show-intro-text', introText !== '');
        elMatchStakes.SetDialogVariable('introtext', introText);
        elMatchStakes.TriggerClass('reveal-stakes');
        let promotionState = RatingEmblem.GetPromotionState(elMatchStakes);
        let ParticleEffect = '';
        let majorRating = '';
        let arrRating = RatingEmblem.SplitRating(rankStats.score);
        majorRating = arrRating[0];
        let tier = Math.floor(+majorRating / 5.0);
        let tierColor = RatingParticleControls.ColorConvert(tier);
        if (promotionState === 'relegation') {
            ParticleEffect = "particles/ui/premier_ratings_matchstakes_relegation.vpcf";
        }
        else if (promotionState === 'promotion') {
            ParticleEffect = "particles/ui/premier_ratings_matchstakes_promo.vpcf";
        }
        function _SetDelta(panel, prediction, score, promotionState, bLoss) {
            let delta = prediction - score;
            let deltaStr;
            let arrPrediction = RatingEmblem.SplitRating(prediction);
            if (arrPrediction[2] === '2') {
                deltaStr = $.Localize('#cs_rating_relegation_match');
            }
            else if (arrPrediction[2] === '1') {
                deltaStr = $.Localize('#cs_rating_promotion_match');
            }
            else if (delta === 0) {
                deltaStr = bLoss ? '-0' : '+0';
            }
            else if (delta < 0) {
                deltaStr = String(delta);
            }
            else {
                deltaStr = String('+' + delta);
            }
            panel.SetDialogVariable('delta', deltaStr);
            panel.SetHasClass('animate', true);
            panel.AddClass('reveal-stakes');
        }
        _SetDelta(elWin, rankStats.predictedRankingIfWin, rankStats.score, promotionState, false);
        _SetDelta(elLoss, rankStats.predictedRankingIfLoss, rankStats.score, promotionState, true);
        if (promotionState) {
            elPfx.SetParticleNameAndRefresh(ParticleEffect);
            elPfx.SetControlPoint(16, tierColor.R, tierColor.G, tierColor.B);
        }
    }
    MatchStakes.StartTeamIntro = StartTeamIntro;
})(MatchStakes || (MatchStakes = {}));
