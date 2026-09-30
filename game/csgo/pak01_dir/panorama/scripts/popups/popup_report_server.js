"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupReportServer;
(function (PopupReportServer) {
    function Init() {
        $.GetContextPanel().SetDialogVariable("server_name", GameStateAPI.GetServerName());
        UpdateSubmitButton();
    }
    PopupReportServer.Init = Init;
    function Submit() {
        let categories = "";
        $.GetContextPanel().FindChildInLayoutFile("id-report").Children().forEach(el => {
            if (el.checked)
                categories += el.GetAttributeString("data-category", "") + ",";
        });
        GameStateAPI.SubmitServerReport(categories);
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupReportServer.Submit = Submit;
    function UpdateSubmitButton() {
        let bCanSubmit = $.GetContextPanel().FindChildInLayoutFile("id-report").Children().some(function (el) {
            return el.checked;
        });
        $.GetContextPanel().FindChildInLayoutFile("SubmitButton").enabled = bCanSubmit;
    }
    PopupReportServer.UpdateSubmitButton = UpdateSubmitButton;
})(PopupReportServer || (PopupReportServer = {}));
