"use strict";
/// <reference path="../csgo.d.ts" />
var PopupCrosshairCode;
(function (PopupCrosshairCode) {
    let elTextEntry = $('#Code');
    let elNotFoundLabel = $('#InvalidCode');
    let elApplyCode = $('#ApplyCode');
    function Init() {
        let elYourCodeBtn = $('#Copy');
        let code = MyPersonaAPI.GetCrosshairCode();
        elYourCodeBtn.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip('Copy', code));
        elYourCodeBtn.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
        elYourCodeBtn.SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.CopyTextToClipboard(code);
            UiToolkitAPI.ShowTextTooltip('Copy', 'Copied your code to clipboard');
            elTextEntry.text = code;
        });
        elApplyCode.enabled = false;
        elNotFoundLabel.visible = false;
    }
    PopupCrosshairCode.Init = Init;
    function ValidateCode() {
        let bCodeValid = MyPersonaAPI.BValidateCrosshairCode(elTextEntry.text);
        elNotFoundLabel.visible = !bCodeValid;
        elApplyCode.enabled = bCodeValid;
        return bCodeValid;
    }
    function OnTextEntryChange() {
        ValidateCode();
    }
    PopupCrosshairCode.OnTextEntryChange = OnTextEntryChange;
    function OnEntrySubmit() {
        let bSuccess = MyPersonaAPI.BApplyCrosshairCode(elTextEntry.text);
        if (bSuccess) {
            $.DispatchEvent('RefreshSettingsPanels');
            $.DispatchEvent('UIPopupButtonClicked', '');
        }
        else {
            ValidateCode();
        }
    }
    PopupCrosshairCode.OnEntrySubmit = OnEntrySubmit;
})(PopupCrosshairCode || (PopupCrosshairCode = {}));
