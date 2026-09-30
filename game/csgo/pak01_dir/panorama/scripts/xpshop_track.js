"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/async.ts" />
/// <reference path="particle_controls.ts" />
var XpShopTrack;
(function (XpShopTrack) {
    let pieAnimDuration = 1;
    const nXPperStar = StoreAPI.GetXpShopStarXp();
    // a way to call setOptions from C++
    // function SetOptionsEventHandler ( elPanel: Panel_t, do_fx: boolean, xptrack_value: number, xptrack_final_value: number )
    // {
    // 	const settings =
    // 		{
    // 			xpshop_track_frame_panel: elPanel,
    // 			xpshop_track_value: xptrack_value,
    // 		} as XpShopTrackSettings_t;
    // 	$.Msg( elPanel.GetParent().id );
    // 	XpShopInit( settings );
    // }
    //$.RegisterEventHandler( "XpShopTrack_SetSettings", $.GetContextPanel(), SetOptionsEventHandler );
    function XpShopInit(settings) {
        const elRootPanel = settings.xpshop_track_frame_panel;
        if (!elRootPanel || !elRootPanel.IsValid())
            return;
        const elTrack = elRootPanel.FindChildTraverse('jsRadialTrack');
        if (!elTrack)
            return;
        const elTrackFx = elRootPanel.FindChildTraverse('jsRadialTrackInsideFx');
        const elTrackBGFx = elRootPanel.FindChildTraverse('jsRadialTrackBgFx');
        if (elTrackFx && elTrackBGFx) {
            elTrackBGFx.StopParticlesWithEndcaps();
            elTrackFx.StopParticlesWithEndcaps();
        }
        const nStarsEarned = settings.xpshop_track_value > 0 ? Math.floor(settings.xpshop_track_value / nXPperStar) : 0;
        const nXpProgressTowardsNextStar = settings.xpshop_track_value % nXPperStar;
        const nPercentProgressTowardsNextStar = nXpProgressTowardsNextStar / nXPperStar * 100;
        elRootPanel.SetDialogVariableInt('progress-to-next-star', nPercentProgressTowardsNextStar);
        elRootPanel.SetDialogVariableInt('stars-earned', nStarsEarned);
        elRootPanel.SetDialogVariableInt('max-stars', StoreAPI.GetXpShopMaxTrackLevel());
        elTrack.style.clip = 'radial(50% 50%, 0deg, ' + Math.floor(nPercentProgressTowardsNextStar / 100 * 360) + 'deg)';
        elTrack.style.transitionDuration = '0s';
        // cache value
        elRootPanel.Data().prev_xpshop_track_value = settings.xpshop_track_value;
        SetComplete(elRootPanel, nStarsEarned >= StoreAPI.GetXpShopMaxTrackLevel());
    }
    XpShopTrack.XpShopInit = XpShopInit;
    function PlayActivateParticles(settings) {
        const elRootPanel = settings.xpshop_track_frame_panel;
        if (!elRootPanel || !elRootPanel.IsValid())
            return;
        const elTrackFx = elRootPanel.FindChildTraverse('jsRadialTrackInsideFx');
        const elTrackBGFx = elRootPanel.FindChildTraverse('jsRadialTrackBgFx');
        elTrackBGFx.StartParticles();
        elTrackFx.StartParticles();
        elTrackBGFx.SetControlPoint(6, 1, 1, 1);
        elTrackFx.SetControlPoint(6, 30, 1, 1);
        elTrackFx.SetControlPoint(5, 0, 1, 1);
        elTrackFx.SetControlPoint(5, 1, 1, 1);
    }
    XpShopTrack.PlayActivateParticles = PlayActivateParticles;
    function SetComplete(elRoot, bSet = true) {
        elRoot.SetHasClass('complete', bSet);
        elRoot.SetDialogVariable('xpshop-track-tooltip', bSet ?
            $.Localize('#xpshop_track_complete_tooltip') :
            $.Localize('#xpshop_track_tooltip'));
    }
    async function XpShopUpdate(settings) {
        const elRootPanel = settings.xpshop_track_frame_panel;
        if (!elRootPanel || !elRootPanel.IsValid())
            return;
        const elTrack = elRootPanel.FindChildTraverse('jsRadialTrack');
        const elTrackFx = elRootPanel.FindChildTraverse('jsRadialTrackInsideFx');
        const elTrackBGFx = elRootPanel.FindChildTraverse('jsRadialTrackBgFx');
        let haveFx = false;
        if (elTrackFx && elTrackBGFx)
            haveFx = true;
        if (!elTrack)
            return;
        const prevTrackXp = elRootPanel.Data().prev_xpshop_track_value;
        if (prevTrackXp === undefined) {
            $.Msg('XpShopUpdate was called but there is no prev_xpshop_track_value. Did you forget to call XpShopInit?');
            return;
        }
        $.Msg("\n XpShopUpdate");
        $.Msg("panel: " + settings.xpshop_track_frame_panel.id);
        $.Msg("prevXp: " + prevTrackXp);
        $.Msg("NewXp: " + settings.xpshop_track_value);
        $.Msg("\n");
        const oldStars = Math.floor(prevTrackXp / nXPperStar);
        const newStars = Math.floor(settings.xpshop_track_value / nXPperStar);
        const starsEarned = newStars - oldStars;
        elRootPanel.SetDialogVariableInt('stars-earned', oldStars);
        if (oldStars >= StoreAPI.GetXpShopMaxTrackLevel()) {
            SetComplete(elRootPanel);
            return;
        }
        elTrack.style.transitionDuration = pieAnimDuration + 's';
        if (haveFx) {
            elTrackBGFx.StartParticles();
            elTrackFx.StartParticles();
            elTrackFx.SetControlPoint(6, 0, 1, 1);
            elTrackFx.SetControlPoint(5, 0, 1, 1);
            elTrackFx.SetControlPoint(5, 1, 1, 1);
        }
        // A. cycle through stars earned
        for (let i = 0; i < starsEarned; i++) {
            if (haveFx) {
                elTrackFx.SetControlPoint(6, 0, 1, 1);
                elTrackBGFx.SetControlPoint(6, 0, 1, 1);
            }
            // progress bar should glow up
            elRootPanel.AddClass("in-motion");
            // 1. animate to full circle
            elTrack.style.transitionDuration = pieAnimDuration + 's';
            elTrack.style.clip = 'radial(50% 50%, 0deg, 360deg)';
            elRootPanel.SetDialogVariableInt('progress-to-next-star', 100);
            UiToolkitAPI.PlaySoundEvent("UI.XP.Star.Filling");
            $.Msg("A1-------");
            $.Msg("stars-earned: " + (oldStars + i));
            $.Msg("circle: 360");
            $.Msg("%: 100");
            // hold full circle before fanfair
            await Async.Delay(pieAnimDuration);
            // 2. do some fanfair and update counter
            $.Msg("A2-------");
            $.Msg("stars-earned: " + (oldStars + i + 1));
            elRootPanel.SetDialogVariableInt('stars-earned', oldStars + i + 1);
            elRootPanel.AddClass("earned-star");
            elTrack.style.transitionDuration = '0s';
            elRootPanel.style.transitionProperty = 'brightness';
            elRootPanel.style.transitionDuration = '.1s';
            UiToolkitAPI.PlaySoundEvent("UI.XP.Star.Full");
            if (haveFx) {
                elTrackBGFx.SetControlPoint(6, 1, 1, 1);
                elTrackFx.SetControlPoint(6, 30, 1, 1);
                elTrackFx.SetControlPoint(5, 0, 1, 1);
                elTrackFx.SetControlPoint(5, 1, 1, 1);
            }
            elRootPanel.style.brightness = '2';
            await Async.Delay(0.2);
            elRootPanel.style.brightness = '1';
            await Async.Delay(0.2);
            // 3. reset track
            elTrack.style.clip = 'radial(50% 50%, 0deg, 0deg)';
            elRootPanel.SetDialogVariableInt('progress-to-next-star', 0);
            $.Msg("A3-------");
            $.Msg("circle: 0");
            $.Msg("%: 0");
            elTrack.style.transitionDuration = pieAnimDuration + 's';
        }
        const deltaXp = settings.xpshop_track_value % nXPperStar;
        if (newStars >= StoreAPI.GetXpShopMaxTrackLevel()) {
            SetComplete(elRootPanel);
            return;
        }
        $.Msg("delta remainder: " + deltaXp);
        // B. remaining partial star
        if (deltaXp > 0) {
            // progress bar should glow up
            elRootPanel.AddClass("in-motion");
            const nPercentProgressTowardsNextStar = deltaXp / nXPperStar * 100;
            const nDegrees = Math.floor(nPercentProgressTowardsNextStar / 100 * 360);
            elRootPanel.SetDialogVariableInt('progress-to-next-star', nPercentProgressTowardsNextStar);
            elRootPanel.SetDialogVariableInt('stars-earned', newStars);
            elTrack.style.clip = 'radial(50% 50%, 0deg, ' + nDegrees + 'deg)';
            UiToolkitAPI.PlaySoundEvent("UI.XP.Star.Filling");
            $.Msg("B1-------");
            $.Msg("prevXp: " + prevTrackXp);
            $.Msg("stars-earned: " + (newStars));
            $.Msg("circle: " + nDegrees);
            $.Msg("%: " + nPercentProgressTowardsNextStar);
            // cache value
            elRootPanel.Data().prev_xpshop_track_value = settings.xpshop_track_value;
        }
        if (haveFx) {
            elTrackFx.SetControlPoint(6, 0, 1, 1);
            //elTrackBGFx.SetControlPoint ( 6, 0, 1, 1 );
        }
        await Async.Delay(0.5);
        elRootPanel.RemoveClass("in-motion");
    }
    XpShopTrack.XpShopUpdate = XpShopUpdate;
})(XpShopTrack || (XpShopTrack = {}));
