"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/async.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="mock_adapter.ts" />
var PlayerStatsCard;
(function (PlayerStatsCard) {
    const CARD_ID = 'card';
    function Init(elParent, xuid, index) {
        $.RegisterForUnhandledEvent("EndOfMatch_SkillGroupUpdated", _UpdateSkillGroup);
        let elCard = $.CreatePanel('Panel', elParent, CARD_ID);
        elCard.BLoadLayout("file://{resources}/layout/player_stats_card.xml", false, false);
        elCard.SetDialogVariableInt('playerslot', Number(MockAdapter.GetPlayerSlot(xuid)));
        elCard.SetDialogVariableInt('xuid', Number(xuid));
        elCard.SetHasClass('localplayer', xuid === MockAdapter.GetLocalPlayerXuid());
        let snippet = '';
        switch (MockAdapter.GetGameModeInternalName(false)) {
            case 'training':
            case 'deathmatch':
                snippet = 'snippet-banner-dm';
                break;
            case 'gungameprogressive':
                snippet = "snippet-banner-ar";
                break;
            default:
                snippet = 'snippet-banner-classic';
                break;
        }
        elCard.FindChildTraverse('JsBanner').BLoadLayoutSnippet(snippet);
        let elBannerBG = elCard.FindChildTraverse('JsBannerBG');
        elBannerBG.SetImage('file://{images}/stats_cards/stats_card_banner_' + index + '.png');
        let elCardBG = elCard.FindChildTraverse('JsCardBG');
        let maxCoord = 100;
        let minCoord = -100;
        let randX = Math.floor(Math.random() * (maxCoord - minCoord) + minCoord);
        let randY = Math.floor(Math.random() * (maxCoord - minCoord) + minCoord);
        elCardBG.style.backgroundPosition = randX + '% ' + randY + '%';
        _SetHonorIcon(elCard, xuid);
        return elCard;
    }
    PlayerStatsCard.Init = Init;
    function GetCard(elParent) {
        return elParent.FindChildTraverse(CARD_ID);
    }
    PlayerStatsCard.GetCard = GetCard;
    function SetAccolade(elCard, accValue, accName, accPosition) {
        if (!isNaN(Number(accValue))) {
            accValue = String(Math.floor(Number(accValue)));
        }
        elCard.SetDialogVariable('accolade-value-string', accValue);
        elCard.SetDialogVariableTime('accolade-value-time', Number(accValue));
        elCard.SetDialogVariableInt('accolade-value-int', Number(accValue));
        let secondPlaceSuffix = (accPosition != '1') ? '_2' : '';
        elCard.SetDialogVariable('accolade-the-title', $.Localize('#accolade_' + accName + secondPlaceSuffix));
        elCard.SetDialogVariable('accolade-desc', $.Localize('#accolade_' + accName + '_desc' + secondPlaceSuffix, elCard));
        let valueToken = '#accolade_' + accName + '_value';
        let valueLocalized = $.Localize('#accolade_' + accName + '_value', elCard);
        if (valueToken == valueLocalized)
            valueLocalized = '';
        elCard.SetDialogVariable('accolade-value', valueLocalized);
        elCard.SetHasClass('show-accolade', true);
    }
    PlayerStatsCard.SetAccolade = SetAccolade;
    function SetAvatar(elCard, xuid) {
        let elAvatarImage = elCard.FindChildTraverse('jsAvatar');
        elAvatarImage.PopulateFromPlayerSlot(MockAdapter.GetPlayerSlot(xuid));
        let team = MockAdapter.GetPlayerTeamName(xuid);
        elAvatarImage.SwitchClass('teamstyle', 'team--' + team);
    }
    PlayerStatsCard.SetAvatar = SetAvatar;
    function SetFlair(elCard, xuid) {
        let flairItemId = InventoryAPI.GetFlairItemId(xuid);
        if (flairItemId === "0" || !flairItemId) {
            const flairDefIdx = FriendsListAPI.GetFriendDisplayItemDefFeatured(xuid);
            flairItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(flairDefIdx, 0);
            if (flairItemId === "0" || !flairItemId || flairDefIdx == 65535)
                return false;
        }
        const imagePath = InventoryAPI.GetItemInventoryImage(flairItemId);
        let elFlairImage = elCard.FindChildTraverse('jsFlairImage');
        elFlairImage.SetImage('file://{images}' + imagePath + '_small.png');
        elCard.SetHasClass('show-flair', true);
    }
    PlayerStatsCard.SetFlair = SetFlair;
    function _UpdateSkillGroup(strSkillgroupData) {
        const oSkillgroupData = JSON.parse(strSkillgroupData);
        Object.keys(oSkillgroupData).forEach((xuid, i) => {
            const cardId = 'cardcontainer-' + xuid;
            const elCard = $.GetContextPanel().FindChildTraverse(cardId);
            if (elCard) {
                const newPlayerData = oSkillgroupData[xuid];
                if (newPlayerData && newPlayerData.hasOwnProperty('new_rank') &&
                    newPlayerData.hasOwnProperty('rank_type')) {
                    const wins = newPlayerData.hasOwnProperty('num_wins') ? newPlayerData.num_wins : 0;
                    const options = {
                        root_panel: elCard.FindChildTraverse('jsRatingEmblem'),
                        do_fx: true,
                        full_details: false,
                        leaderboard_details: { score: newPlayerData.new_rank, matchesWon: wins },
                        rating_type: newPlayerData.rank_type,
                        local_player: xuid === MyPersonaAPI.GetXuid()
                    };
                    $.Schedule(1.0 + 0.5 * i, () => {
                        if (elCard && elCard.IsValid()) {
                            RatingEmblem.SetXuid(options);
                            elCard.TriggerClass('skillgroup-update');
                        }
                    });
                }
            }
        });
    }
    function SetSkillGroup(elCard, xuid) {
        if (!elCard.FindChildTraverse('jsRatingEmblem'))
            return;
        const rating_type = MockAdapter.GetPlayerCompetitiveRankType(xuid);
        const score = MockAdapter.GetPlayerCompetitiveRanking(xuid);
        const wins = MockAdapter.GetPlayerCompetitiveWins(xuid);
        const options = {
            root_panel: elCard.FindChildTraverse('jsRatingEmblem'),
            do_fx: true,
            full_details: true,
            rating_type: rating_type,
            leaderboard_details: { score: score, matchesWon: wins },
            local_player: xuid === MyPersonaAPI.GetXuid()
        };
        const bShowSkillGroup = RatingEmblem.SetXuid(options);
        if (bShowSkillGroup) {
            elCard.RemoveClass('show-skillgroup');
            $.Schedule(0, () => elCard && elCard.IsValid() ? elCard.AddClass('show-skillgroup') : '');
        }
        else {
            elCard.RemoveClass('show-skillgroup');
        }
    }
    PlayerStatsCard.SetSkillGroup = SetSkillGroup;
    function _SetHonorIcon(elPanel, xuid) {
        const elHonorIcon = elPanel.FindChildTraverse('jsHonorIcon');
        elHonorIcon.Set(GameStateAPI.GetPlayerXpTrailLevel(xuid), false);
    }
    function SetStats(elCard, xuid, arrBestStats = null) {
        let oStats = MockAdapter.GetPlayerStatsJSO(xuid);
        let score = MockAdapter.GetPlayerScore(xuid);
        if (arrBestStats) {
            for (let oBest of arrBestStats) {
                let stat = oBest.stat;
                if (oStats[stat] > 0 && (!oBest.value || oStats[stat] > oBest.value)) {
                    oBest.value = oStats[stat];
                    oBest.elCard = elCard;
                }
            }
        }
        elCard.SetDialogVariableInt('playercardstats-kills', Number(oStats.kills));
        elCard.SetDialogVariableInt('playercardstats-deaths', Number(oStats.deaths));
        elCard.SetDialogVariableInt('playercardstats-assists', Number(oStats.assists));
        elCard.SetDialogVariableInt('playercardstats-adr', Number(oStats.adr));
        elCard.SetDialogVariableInt('playercardstats-hsp', Number(oStats.hsp));
        elCard.SetDialogVariableInt('playercardstats-ef', Number(oStats.enemiesflashed));
        elCard.SetDialogVariableInt('playercardstats-ud', Number(oStats.utilitydamage));
        elCard.SetDialogVariableInt('playercardstats-score', Number(score));
        elCard.SetDialogVariableInt('playercardstats-gglevel', Number(Math.floor(score / 2)));
        elCard.SetDialogVariableInt('playercardstats-knifekills', Number(oStats.knifekills));
        elCard.SetHasClass('show-stats', true);
    }
    PlayerStatsCard.SetStats = SetStats;
    function SetTeammateColor(elCard, xuid) {
        for (let elPlayerColor of elCard.FindChildrenWithClassTraverse('colorize-teammate-color')) {
            let teammateColor = MockAdapter.GetPlayerColor(xuid);
            let teamName = MockAdapter.GetPlayerTeamName(xuid);
            let teamColor = teammateColor ? teammateColor : teamName == 'CT' ? '#5ab8f4' : '#f0c941';
            elPlayerColor.style.washColor = (teamColor !== '') ? teamColor : 'black';
        }
    }
    PlayerStatsCard.SetTeammateColor = SetTeammateColor;
    async function RevealStats(elCard) {
        const DELAY_DELTA = 0.1;
        for (const elPanel of elCard.FindChildrenWithClassTraverse('sliding-panel')) {
            await Async.Delay(DELAY_DELTA);
            elPanel.AddClass('slide');
        }
    }
    PlayerStatsCard.RevealStats = RevealStats;
    function HighlightStat(elCard, stat) {
        elCard.AddClass('highlight-' + stat);
    }
    PlayerStatsCard.HighlightStat = HighlightStat;
})(PlayerStatsCard || (PlayerStatsCard = {}));
