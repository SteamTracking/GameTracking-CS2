"use strict";
/// <reference path="../csgo.d.ts" />
function SetupPopup() {
    var strPopupValue = $.GetContextPanel().GetAttributeString("popupvalue", "(not found)");
    $.GetContextPanel().SetDialogVariable("popupvalue", strPopupValue);
}
function OnOKPressed() {
    // Run some js code
    $.Msg('OnComplexPressed: Running from \'popup custom layout\'\n');
    // Invoke callback set up in the parent panel (if set)
    var callbackHandle = $.GetContextPanel().GetAttributeInt("callback", -1);
    if (callbackHandle != -1) {
        UiToolkitAPI.InvokeJSCallback(callbackHandle, 'OK');
    }
    // Do not forget to dispatch the UIPopupButtonClicked() panorama event
    // responsible for closing the popup
    $.DispatchEvent('UIPopupButtonClicked', '');
}
