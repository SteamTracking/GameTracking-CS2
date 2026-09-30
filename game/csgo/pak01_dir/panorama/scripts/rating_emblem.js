"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="digitpanel.ts" />
/// <reference path="common/sessionutil.ts" />
$.LogChannel('p.rating', "LV_OFF");
var RatingEmblem;
(function (RatingEmblem) {
    function _GetMainPanel(root_panel) {
        if (root_panel &&
            root_panel.IsValid() &&
            root_panel.FindChildTraverse('jsPremierRating') &&
            root_panel.FindChildTraverse('jsPremierRating').IsValid()) {
            return root_panel.FindChildTraverse('jsPremierRating').GetParent();
        }
        else {
            return null;
        }
    }
    function GetRatingDesc(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().ratingDesc : '';
    }
    RatingEmblem.GetRatingDesc = GetRatingDesc;
    function GetTooltipText(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().tooltipText : '';
    }
    RatingEmblem.GetTooltipText = GetTooltipText;
    function GetTierColorClass(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().colorClassName : '';
    }
    RatingEmblem.GetTierColorClass = GetTierColorClass;
    function GetEomDescText(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().eomDescText : '';
    }
    RatingEmblem.GetEomDescText = GetEomDescText;
    function GetIntroText(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().introText : '';
    }
    RatingEmblem.GetIntroText = GetIntroText;
    function GetWinCountString(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().winCountText : '';
    }
    RatingEmblem.GetWinCountString = GetWinCountString;
    function GetPromotionState(root_panel) {
        let elMain = _GetMainPanel(root_panel);
        return elMain ? elMain.Data().promotionState : '';
    }
    RatingEmblem.GetPromotionState = GetPromotionState;
    function SetXuid(options) {
        let rating = undefined;
        let wins = undefined;
        let rank = undefined;
        let pct = undefined;
        let bFullDetails = options.hasOwnProperty('full_details') ? options.full_details : false;
        let do_fx = options.do_fx;
        let rating_type = options.rating_type;
        let root_panel = _GetMainPanel(options.root_panel);
        if (!root_panel)
            return false;
        let debug_wins = false;
        if (debug_wins) {
            wins = Math.floor(Math.random() * 20);
        }
        rating = options.leaderboard_details.score;
        wins = options.leaderboard_details.matchesWon;
        rank = options.leaderboard_details.rank;
        pct = options.leaderboard_details.pct;
        root_panel.SwitchClass('type', rating_type);
        if (bFullDetails) {
            root_panel.SetDialogVariable('rating_type', rating_type);
        }
        let elSkillGroupImage = null;
        let imagePath = '';
        let winsNeededForRank = SessionUtil ? SessionUtil.GetNumWinsNeededForRank(rating_type) : 10;
        let isloading = (rating === undefined || rating < 0);
        let bRatingExpired = !isloading && rating === 0;
        let bTooFewWins = wins === undefined || wins < winsNeededForRank;
        let bHasRating = !bRatingExpired && !bTooFewWins && !isloading;
        let ratingDesc = '';
        let tooltipText = '';
        let eomDescText = '';
        let tooltipExtraText = '';
        let colorClassName = '';
        let introText = '';
        let promotionState = '';
        let winCountText = '';
        if (!wins || wins < 0) {
            wins = 0;
        }
        if (isloading) {
            ratingDesc = $.Localize('#SFUI_LOADING');
        }
        root_panel.SetDialogVariableInt("wins", wins);
        if (rating_type === 'Wingman' || rating_type === 'Competitive') {
            elSkillGroupImage = root_panel.FindChildTraverse('jsRating-' + rating_type);
            let locTypeModifer = rating_type === 'Competitive' ? '' : rating_type.toLowerCase();
            imagePath = locTypeModifer !== '' ? locTypeModifer : 'skillgroup';
            const elCompWinsNeeded = root_panel.FindChildTraverse('jsRating-CompetitiveWinsNeeded');
            elCompWinsNeeded.visible = !isloading && bTooFewWins && options.local_player;
            if (bTooFewWins || isloading) {
                elSkillGroupImage.SetImage('file://{images}/icons/skillgroups/' + imagePath + '_none.svg');
                if (!isloading && options.local_player) {
                    const winsneeded = Math.max(0, winsNeededForRank - wins);
                    elSkillGroupImage.SetDialogVariableInt('wins', wins);
                    elSkillGroupImage.SetDialogVariableInt('wins-needed', winsneeded);
                    if (bFullDetails) {
                        ratingDesc = $.Localize('#skillgroup_0' + locTypeModifer);
                        root_panel.SetDialogVariableInt("winsneeded", winsneeded);
                        tooltipText = $.Localize('#tooltip_skill_group_none' + imagePath + ':f', root_panel);
                    }
                }
            }
            else if (bRatingExpired) {
                elSkillGroupImage.SetImage('file://{images}/icons/skillgroups/' + imagePath + '_expired.svg');
                if (bFullDetails) {
                    ratingDesc = $.Localize('#skillgroup_expired' + locTypeModifer);
                    tooltipText = $.Localize('#tooltip_skill_group_expired' + locTypeModifer);
                }
            }
            else {
                elSkillGroupImage.SetImage('file://{images}/icons/skillgroups/' + imagePath + rating + '.svg');
                if (bFullDetails) {
                    ratingDesc = $.Localize('#skillgroup_' + rating);
                    tooltipText = $.Localize('#tooltip_skill_group_generic' + locTypeModifer);
                }
            }
        }
        else if (rating_type === 'Premier') {
            let elPremierRating = root_panel.FindChildTraverse('jsPremierRating');
            let presentation = options.presentation ? options.presentation : 'simple';
            root_panel.FindChildTraverse('JsSimpleNumbers').visible = presentation === 'simple';
            root_panel.FindChildTraverse('JsDigitPanels').visible = presentation === 'digital';
            let majorRating = '';
            let minorRating = '';
            root_panel.SwitchClass('tier', 'tier-0');
            _SetPremierBackgroundImage(root_panel, rating);
            if (rating && rating > 0) {
                let clampedRating = GetClampedRating(rating);
                root_panel.SwitchClass('tier', 'tier-' + clampedRating);
                colorClassName = 'tier-' + clampedRating;
                let arrRating = SplitRating(rating);
                majorRating = arrRating[0];
                minorRating = arrRating[1];
                if (do_fx && rating) {
                    RatingParticleControls.UpdateRatingEffects(elPremierRating, majorRating, minorRating.slice(-3), parseInt(arrRating[2]));
                }
                if (bFullDetails) {
                    if (rank && rank <= LeaderboardsAPI.GetPremierLeaderboardTopBestCount()) {
                        root_panel.SetDialogVariableInt('rank', rank);
                        ratingDesc = $.Localize('#cs_rating_rank', root_panel);
                        eomDescText = ratingDesc;
                    }
                    else if (pct) {
                        root_panel.SetDialogVariable('percentile', pct.toFixed(2) + '');
                        ratingDesc = $.Localize('#cs_rating_percentile', root_panel);
                        eomDescText = ratingDesc;
                    }
                    else {
                        ratingDesc = $.Localize('#cs_rating_generic');
                    }
                    if (arrRating[2] === '2') {
                        tooltipExtraText = $.Localize('#cs_rating_relegation_nextmatch');
                        introText = $.Localize('#cs_rating_relegation_match');
                        eomDescText = $.Localize('#cs_rating_relegation_nextmatch');
                        ratingDesc = $.Localize('#cs_rating_relegation_nextmatch');
                        promotionState = 'relegation';
                    }
                    else if (arrRating[2] === '1') {
                        tooltipExtraText = $.Localize('#cs_rating_promotion_nextmatch');
                        introText = $.Localize('#cs_rating_promotion_match');
                        eomDescText = $.Localize('#cs_rating_promotion_nextmatch');
                        ratingDesc = $.Localize('#cs_rating_promotion_nextmatch');
                        promotionState = 'promotion';
                    }
                    tooltipText = $.Localize('#tooltip_cs_rating_generic');
                }
            }
            else {
                if (bFullDetails) {
                    if (isloading) {
                        ratingDesc = $.Localize('#skillgroup_loading');
                    }
                    else if (bTooFewWins) {
                        let winsneeded = (winsNeededForRank - wins);
                        root_panel.SetDialogVariableInt("winsneeded", winsneeded);
                        tooltipText = $.Localize('#tooltip_cs_rating_none:f', root_panel);
                        eomDescText = $.Localize('#cs_rating_wins_needed_verbose:f', root_panel);
                        introText = $.Localize('#cs_rating_wins_needed_verbose_intro:f', root_panel);
                        if (options.local_player) {
                            ratingDesc = $.Localize('#cs_rating_wins_needed:f', root_panel);
                        }
                        else {
                            ratingDesc = $.Localize('#cs_rating_none');
                        }
                    }
                    else if (bRatingExpired) {
                        ratingDesc = $.Localize('#cs_rating_expired');
                        tooltipText = $.Localize('#tooltip_cs_rating_expired');
                        eomDescText = $.Localize('#eom-skillgroup-expired-premier', root_panel);
                        introText = $.Localize('#eom-skillgroup-expired-premier', root_panel);
                    }
                }
            }
            _SetEomStyleOverrides(options, root_panel);
            _SetPremierRatingValue(root_panel, majorRating, minorRating, presentation);
        }
        if (bFullDetails) {
            if (tooltipExtraText !== '') {
                tooltipText = tooltipText + '<br><br>' + tooltipExtraText;
            }
            if (wins) {
                root_panel.SetDialogVariableInt('wins', wins);
                let winText = $.Localize('#tooltip_skill_group_wins:f', root_panel);
                tooltipText = (tooltipText !== '') ? tooltipText + '<br><br>' + winText : winText;
                winCountText = $.Localize('#wins_count:f', root_panel);
            }
            root_panel.Data().ratingDesc = ratingDesc;
            root_panel.Data().tooltipText = tooltipText;
            root_panel.Data().colorClassName = colorClassName;
            root_panel.Data().eomDescText = eomDescText;
            root_panel.Data().introText = introText;
            root_panel.Data().promotionState = promotionState;
            root_panel.Data().winCountText = winCountText;
        }
        root_panel.SwitchClass('rating_type', rating_type);
        return bHasRating;
    }
    RatingEmblem.SetXuid = SetXuid;
    function GetClampedRating(rating) {
        let remappedRating = Math.floor(rating / 1000.00 / 5);
        return Math.max(0, Math.min(remappedRating, 6));
    }
    RatingEmblem.GetClampedRating = GetClampedRating;
    function _SetPremierBackgroundImage(root_panel, rating) {
        let bgImage = (rating && rating > 0) ? 'premier_rating_bg_large.svg' : 'premier_rating_bg_large_none.svg';
        let elImage = root_panel.FindChildInLayoutFile('jsPremierRatingBg');
        elImage.SetImage('file://{images}/icons/ui/' + bgImage);
    }
    function _SetEomStyleOverrides(options, root_panel) {
        root_panel.FindChildInLayoutFile('JsDigitPanels').SwitchClass('emblemstyle', options.eom_digipanel_class_override ? options.eom_digipanel_class_override : '');
    }
    function _SetPremierRatingValue(root_panel, major, minor, premierPresentation) {
        root_panel.SetDialogVariable('rating-major', major);
        root_panel.SetDialogVariable('rating-minor', minor);
        if (premierPresentation === 'digital') {
            const elMajor = $.GetContextPanel().FindChildTraverse('jsPremierRatingMajor');
            const elMinor = $.GetContextPanel().FindChildTraverse('jsPremierRatingMinor');
            let bFastSet = false;
            if (!$.GetContextPanel().FindChildTraverse('DigitPanel')) {
                DigitPanelFactory.MakeDigitPanel(elMajor, 2, '', 1, "#digitpanel_digits_premier");
                DigitPanelFactory.MakeDigitPanel(elMinor, 4, '', 1, "#digitpanel_digits_premier");
                bFastSet = true;
            }
            DigitPanelFactory.SetDigitPanelString(elMajor, major, bFastSet);
            DigitPanelFactory.SetDigitPanelString(elMinor, minor, bFastSet);
        }
    }
    function SplitRating(rating) {
        let matchType = '0';
        if (rating === 5000 || rating === 10000 || rating === 15000 ||
            rating === 20000 || rating === 25000 || rating === 30000)
            matchType = '2';
        else if (rating === 5000 - 1 || rating === 10000 - 1 || rating === 15000 - 1 ||
            rating === 20000 - 1 || rating === 25000 - 1 || rating === 30000 - 1)
            matchType = '1';
        rating = rating / 1000.00;
        let strRating = (String((rating).toFixed(3))).padStart(6, '0');
        let major = strRating.slice(0, 2);
        let minor = strRating.slice(-3);
        major = major.replace(/^00/g, '  ');
        major = major.replace(/^0/g, ' ');
        if (major === '  ') {
            minor = minor.replace(/^00/g, '  ');
            minor = minor.replace(/^0/g, ' ');
        }
        else {
            minor = ',' + minor;
        }
        return [major, minor, matchType];
    }
    RatingEmblem.SplitRating = SplitRating;
})(RatingEmblem || (RatingEmblem = {}));
var RatingParticleControls;
(function (RatingParticleControls) {
    function GetAllChildren(panel) {
        const children = panel.Children();
        return [...children, ...children.flatMap(GetAllChildren)];
    }
    function IsParticleScenePanel(panel) {
        return panel.type === "ParticleScenePanel";
    }
    function ColorConvert(tier) {
        let rarityColors = [
            ["common", 176, 195, 217],
            ["uncommon", 94, 152, 217],
            ["rare", 75, 105, 255],
            ["mythical", 136, 71, 255],
            ["legendary", 211, 44, 230],
            ["ancient", 235, 75, 75],
            ["unusual", 255, 215, 0],
        ];
        if (tier < 0 || tier >= rarityColors.length)
            return { R: 0, G: 0, B: 0 };
        let R = rarityColors[tier][1];
        let G = rarityColors[tier][2];
        let B = rarityColors[tier][3];
        return { R, G, B };
    }
    RatingParticleControls.ColorConvert = ColorConvert;
    function UpdateRatingEffects(panelId, MajorRating, MinorRating, matchType) {
        const AllPanels = GetAllChildren(panelId);
        let ratingEffect = [
            "particles/ui/premier_ratings_bg.vpcf",
            "particles/ui/premier_ratings_promomatch.vpcf",
            "particles/ui/premier_ratings_relegation.vpcf"
        ];
        let tier = Math.floor(+MajorRating / 5.0);
        let tierColor = ColorConvert(tier);
        for (const panel of AllPanels) {
            if (IsParticleScenePanel(panel)) {
                if (+MajorRating > 0) {
                    panel.StartParticles();
                    panel.SetParticleNameAndRefresh(ratingEffect[matchType]);
                    panel.SetControlPoint(16, tierColor.R, tierColor.G, tierColor.B);
                }
                else {
                    panel.StopParticlesImmediately(true);
                }
            }
        }
    }
    RatingParticleControls.UpdateRatingEffects = UpdateRatingEffects;
})(RatingParticleControls || (RatingParticleControls = {}));
