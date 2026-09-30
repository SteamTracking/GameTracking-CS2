"use strict";
/// <reference path="../csgo.d.ts" />
function SetupPopup() {
    var strPopupValue = $.GetContextPanel().GetAttributeString("popupvalue", "(not found)");
    $.GetContextPanel().SetDialogVariable("popupvalue", strPopupValue);
}
function OnOKPressed() {
    var callbackHandle = $.GetContextPanel().GetAttributeInt("callback", -1);
    if (callbackHandle != -1) {
        UiToolkitAPI.InvokeJSCallback(callbackHandle, 'OK');
    }
    $.DispatchEvent('UIPopupButtonClicked', '');
}
