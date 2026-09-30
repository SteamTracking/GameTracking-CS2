"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../popups/popup_major_hub.ts" />
var PredictionsTimer;
(function (PredictionsTimer) {
    function UpdateTimer() {
        let oPageData = PopupMajorHub.GetActivePageData();
        if (!oPageData || !oPageData.tournamentId)
            return;
        if (oPageData.panel.Data().handlerLockPicksTimerSch) {
            oPageData.panel.Data().handlerLockPicksTimerSch = null;
        }
        let elIcon = oPageData.panel.FindChildTraverse('id-predictions-timer-icon');
        let elParent = oPageData.panel.FindChildTraverse('id-predictions-timer');
        elParent.SwitchClass('state', '');
        let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, oPageData.groupId);
        let secRemaining = PredictionsAPI.GetGroupRemainingPredictionSeconds(oPageData.tournamentId, oPageData.groupId);
        let isActive = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
        if (!canPick) {
            //picks are locked so show locked message and stop timer.
            elIcon.SetImage('file://{images}/icons/ui/locked.svg');
            oPageData.panel.SetDialogVariable('lock_state', $.Localize('#pickem_timer_locked'));
        }
        // The day is not active , you can pick in the future
        else if (!isActive && canPick) {
            elParent.SwitchClass('state', 'not-active');
            elIcon.SetImage('file://{images}/icons/ui/locked.svg');
            oPageData.panel.SetDialogVariable('lock_state', $.Localize('#pickem_timer_inactive'));
        }
        else if (canPick && secRemaining > 0) {
            // day is active and you can make picks and we have a timer so update the time.
            elIcon.SetImage('file://{images}/icons/ui/clock.svg');
            oPageData.panel.SetDialogVariable('time', FormatText.SecondsToSignificantTimeString(secRemaining));
            oPageData.panel.SetDialogVariable('lock_state', $.Localize('#pickem_timer', oPageData.panel));
            if (!oPageData.panel.Data().handlerLockPicksTimerSch) {
                oPageData.panel.Data().handlerLockPicksTimerSch = $.Schedule(1, () => { UpdateTimer(); });
            }
        }
        else {
            //timer has run out but picks are not locked
            elIcon.SetImage('file://{images}/icons/ui/clock.svg');
            oPageData.panel.SetDialogVariable('time', FormatText.SecondsToSignificantTimeString(60));
            oPageData.panel.SetDialogVariable('lock_state', $.Localize('#pickem_timer', oPageData.panel));
        }
    }
    PredictionsTimer.UpdateTimer = UpdateTimer;
})(PredictionsTimer || (PredictionsTimer = {}));
