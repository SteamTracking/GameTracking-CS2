"use strict";
/// <reference path="../csgo.d.ts" />
var PopupCustomLayout;
(function (PopupCustomLayout) {
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
        if (oSettings.show_loading_bar) {
            let progressBar = $("#ProgressBar");
            progressBar.SetHasClass("ProgressBarVisible", true);
            progressBar.min = 0.0;
            progressBar.max = 1.0;
            progressBar.value = 0.0;
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
            CleanupWatchEvent();
            g_sWatchEvent = sWatchEvent;
            g_nWatchEventHandlerId = $.RegisterForUnhandledEvent(sWatchEvent, () => {
                CleanupWatchEvent();
                UiToolkitAPI.InvokeJSCallback(nCallbackHandle);
                OnOKPressed();
            });
        }
    }
    PopupCustomLayout.Init = Init;
    ;
    function OnOKPressed() {
        CleanupWatchEvent();
        let callbackHandle = $.GetContextPanel().GetAttributeInt("callback", -1);
        if (callbackHandle != -1) {
            UiToolkitAPI.InvokeJSCallback(callbackHandle, 'OK');
        }
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    function UpdateProgressBar() {
        let loadingBarCallbackHandle = $.GetContextPanel().GetAttributeInt("loadingBarCallback", -1);
        if (loadingBarCallbackHandle != -1) {
            $("#ProgressBar").value = UiToolkitAPI.InvokeJSCallback(loadingBarCallbackHandle);
            $.Schedule(0.1, UpdateProgressBar);
        }
    }
    {
    }
})(PopupCustomLayout || (PopupCustomLayout = {}));
