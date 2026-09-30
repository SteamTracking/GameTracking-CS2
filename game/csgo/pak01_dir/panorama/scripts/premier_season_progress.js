"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="common/formattext.ts" />
var SeasonProgress;
(function (SeasonProgress) {
    const _m_nWinsForMedal = 25;
    function _Init() {
        SetRating();
    }
    function SetRating() {
        let elRatingEmblem = $.GetContextPanel().FindChildInLayoutFile('js-highest-rating');
        let rating = MyPersonaAPI.GetPipRankHighest("Premier");
        let options;
        options = {
            root_panel: elRatingEmblem,
            rating_type: 'Premier',
            leaderboard_details: { score: rating },
            do_fx: true,
            full_details: false,
            local_player: true
        };
        RatingEmblem.SetXuid(options);
        _SetProgressBar(rating);
    }
    SeasonProgress.SetRating = SetRating;
    function _SetProgressBar(rating) {
        let nWins = MyPersonaAPI.GetPipRankWins("Premier");
        let clampedRating = RatingEmblem.GetClampedRating(rating);
        let color = clampedRating;
        let nBars = nWins > 24 && nWins < 50 ? 1 :
            nWins > 49 && nWins < 75 ? 2 :
                nWins > 74 && nWins < 100 ? 3 :
                    nWins > 99 && nWins < 125 ? 4 :
                        nWins > 124 ? 5 :
                            0;
        nBars = nBars < 5 ? nBars + 1 : 5;
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-premier-season-bars');
        for (let i = 1; i <= nBars; i++) {
            let elBar = elParent.FindChild('bar-' + i);
            if (!elBar) {
                elBar = $.CreatePanel('Panel', elParent, 'bar-' + i);
                elBar.BLoadLayoutSnippet('one-bar');
            }
            let rangeOfMatchesInBar = { min: i == 1 ? 1 : ((i - 1) * _m_nWinsForMedal), max: (i * _m_nWinsForMedal) };
            let widthInnerBar = (nWins >= (rangeOfMatchesInBar.max - 1)) ? 1 : ((nWins - rangeOfMatchesInBar.min) / (_m_nWinsForMedal - 1));
            elBar.FindChildInLayoutFile('id-inner-bar').style.width = (widthInnerBar * 100) + '%';
            elBar.FindChildInLayoutFile('id-inner-bar').SwitchClass('tier', 'rank-tier-' + color);
            elBar.SwitchClass('num-bars', nBars + '-bars');
            elBar.FindChildInLayoutFile('id-inner-medal').SwitchClass('tier', nWins >= rangeOfMatchesInBar.max ? 'rank-tier-' + color : 'rank-tier-none');
        }
        const nSeasonNumberNow = LeaderboardsAPI.GetCurrentSeasonPremierLeaderboard().replace('official_leaderboard_premier_season', '');
        clampedRating = clampedRating < 1 ? 1 : clampedRating + 1;
        let itemDef = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('premier season coin s=' + nSeasonNumberNow + ' c=' + clampedRating + ' b=' + nBars);
        let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(itemDef, 0);
        $.GetContextPanel().FindChildInLayoutFile('id-medal-end').itemid = itemId;
        $.GetContextPanel().SetDialogVariableInt('wins', nWins);
        $.GetContextPanel().SetDialogVariableInt('threshold', nBars * 25);
        _ShowHideExpirationWarning();
        _SetInfoIconTooltip();
    }
    function _ShowHideExpirationWarning() {
        let nTime = MyPersonaAPI.GetPipRankExpiration("Premier");
        let nWins = MyPersonaAPI.GetPipRankWins("Premier");
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-premier-bar-container');
        if (nWins < _m_nWinsForMedal || nTime >= 0) {
            elParent.SetHasClass('show-warning', false);
            let elImages = elParent.FindChildInLayoutFile('id-premier-bar-icons');
            elImages.SetPanelEvent('onmouseover', () => {
                return;
            });
            elImages.SetPanelEvent('onmouseout', () => {
                return;
            });
            return;
        }
        if (nTime < 0) {
            elParent.SetHasClass('show-warning', true);
            let elImages = elParent.FindChildInLayoutFile('id-premier-bar-icons');
            elImages.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip('id-premier-bar-icons', '#season_progress_rating_expired');
            });
            elImages.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideTextTooltip();
            });
        }
    }
    function _SetInfoIconTooltip() {
        let nTime = MyPersonaAPI.GetPipRankExpiration("Premier");
        let nWins = MyPersonaAPI.GetPipRankWins("Premier");
        let elTooltip = $.GetContextPanel().FindChildInLayoutFile('id-season-progress-tooltip');
        let sTooltip = $.Localize('#season_progress_tooltip-body');
        if (nWins >= _m_nWinsForMedal && nTime > 0) {
            elTooltip.SetDialogVariable('time', FormatText.SecondsToSignificantTimeString(nTime));
            sTooltip = sTooltip + $.Localize('#season_progress_tooltip-expiration_time', elTooltip);
        }
        elTooltip.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTitleTextTooltip('id-season-progress-tooltip', '#season_progress_tooltip-title', sTooltip);
        });
        elTooltip.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTitleTextTooltip();
        });
    }
    function ReadyForDisplay() {
        SetRating();
    }
    SeasonProgress.ReadyForDisplay = ReadyForDisplay;
    function UnReadyForDisplay() {
    }
    SeasonProgress.UnReadyForDisplay = UnReadyForDisplay;
    function PipRankUpdate() {
        SetRating();
    }
    SeasonProgress.PipRankUpdate = PipRankUpdate;
    {
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), SeasonProgress.ReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), SeasonProgress.UnReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_PipRankUpdate', PipRankUpdate);
        _Init();
    }
})(SeasonProgress || (SeasonProgress = {}));
