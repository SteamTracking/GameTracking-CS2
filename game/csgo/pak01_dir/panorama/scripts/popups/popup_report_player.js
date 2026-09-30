"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupReportPlayer;
(function (PopupReportPlayer) {
    function Init() {
        let xuid = $.GetContextPanel().GetAttributeString("xuid", "");
        $.GetContextPanel().SetDialogVariable("target_player", GameStateAPI.GetPlayerName(xuid));
        $.GetContextPanel().FindChildInLayoutFile("id-report").Children().forEach(el => {
            let category = el.GetAttributeString("data-category", "");
            el.enabled = GameStateAPI.IsReportCategoryEnabledForSelectedPlayer(xuid, category);
        });
    }
    PopupReportPlayer.Init = Init;
    function Submit() {
        let categories = "";
        $.GetContextPanel().FindChildInLayoutFile("id-report").Children().forEach(el => {
            if (el.checked)
                categories += el.GetAttributeString("data-category", "") + ",";
        });
        let xuid = $.GetContextPanel().GetAttributeString("xuid", "");
        GameStateAPI.SubmitPlayerReport(xuid, categories);
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupReportPlayer.Submit = Submit;
})(PopupReportPlayer || (PopupReportPlayer = {}));
