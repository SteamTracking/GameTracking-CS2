"use strict";
/// <reference path="../csgo.d.ts" />
var PopupCustomLayout;
(function (PopupCustomLayout) {
    // This panel is created with useglobalcontext, so handlers registered via
    // $.RegisterForUnhandledEvent live on the global context and are not torn down when the popup
    // panel is destroyed. We remember the watch-event registration and clear it on every close path
    // (and before registering a new one) so a single handler exists at a time and a stale one can't
    // run against a destroyed popup.
    let g_sWatchEvent;
    let g_nWatchEventHandlerId;
    function CleanupWatchEvent() {
        if (g_sWatchEvent !== undefined && g_nWatchEventHandlerId !== undefined) {
            $.UnregisterForUnhandledEvent(g_sWatchEvent, g_nWatchEventHandlerId);
        }
        g_sWatchEvent = undefined;
        g_nWatchEventHandlerId = undefined;
    }
    function Init() {
        const oSettings = $.GetContextPanel().Data().oSettings;
        $.GetContextPanel().SetHasClass('HideTitle', oSettings.title === undefined || oSettings.title === null || oSettings.title === '');
        $.GetContextPanel().SetDialogVariable("title", oSettings.title);
        $.GetContextPanel().SetDialogVariable("message", oSettings.message);
        $.GetContextPanel().SetHasClass('NoMinWidth', oSettings.no_min_width);
        $("#popupimage").SetImage(oSettings.image);
        $("#Spinner").SetHasClass("SpinnerVisible", oSettings.show_spinner != 0);
        // Loading bar is visible if loadingBarCallback is set up
        if (oSettings.show_loading_bar) {
            $.Msg('Loading bar should be visible');
            let progressBar = $("#ProgressBar");
            progressBar.SetHasClass("ProgressBarVisible", true);
            // Min / Max could be passed as attributes as well
            progressBar.min = 0.0;
            progressBar.max = 1.0;
            progressBar.value = 0.0;
            // Set up first update of the progress bar
            $.Schedule(0.1, UpdateProgressBar);
        }
        if (oSettings.timeout > 0) {
            $.Schedule(oSettings.timeout, () => {
                CleanupWatchEvent();
                $.DispatchEvent('UIPopupButtonClicked', '');
            });
        }
        $.GetContextPanel().SetHasClass('HideButtons', oSettings.hide_buttons);
        if (oSettings.watch_event && oSettings.watch_event_callback) {
            const sWatchEvent = oSettings.watch_event;
            const nCallbackHandle = oSettings.watch_event_callback;
            // Drop any registration left behind by a previous popup before adding this one.
            CleanupWatchEvent();
            g_sWatchEvent = sWatchEvent;
            g_nWatchEventHandlerId = $.RegisterForUnhandledEvent(sWatchEvent, () => {
                // Unregister before doing any work so the one-shot handler can't re-enter if the
                // callback dispatches the same event again.
                CleanupWatchEvent();
                UiToolkitAPI.InvokeJSCallback(nCallbackHandle);
                OnOKPressed();
            });
        }
    }
    PopupCustomLayout.Init = Init;
    ;
    function OnOKPressed() {
        // Covers the case where the popup is closed via the OK button before the watched event fires.
        CleanupWatchEvent();
        // Run some js code
        $.Msg('OnComplexPressed: Running from \'popup custom layout\'\n');
        // Invoke callback set up in the parent panel (if set)
        let callbackHandle = $.GetContextPanel().GetAttributeInt("callback", -1);
        if (callbackHandle != -1) {
            UiToolkitAPI.InvokeJSCallback(callbackHandle, 'OK');
        }
        // Do not forget to dispatch the UIPopupButtonClicked() panorama event
        // responsible for closing the popup
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    function UpdateProgressBar() {
        let loadingBarCallbackHandle = $.GetContextPanel().GetAttributeInt("loadingBarCallback", -1);
        if (loadingBarCallbackHandle != -1) {
            $("#ProgressBar").value = UiToolkitAPI.InvokeJSCallback(loadingBarCallbackHandle);
            // Set up next update
            $.Schedule(0.1, UpdateProgressBar);
        }
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
    }
})(PopupCustomLayout || (PopupCustomLayout = {}));
