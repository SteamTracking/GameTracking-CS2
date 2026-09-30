"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupStoreStatus;
(function (PopupStoreStatus) {
    let _strStoreStatusOkCmd = null;
    let _strStoreProceedAfterCheckoutConfirmation = "StoreProceedAfterCheckoutConfirmation";
    function SetupPopup() {
        let ctx = $.GetContextPanel();
        let strMsg = ctx.GetAttributeString('text', '');
        let strClose = ctx.GetAttributeString('close', '0');
        let strCancel = ctx.GetAttributeString('cancel', '0');
        _strStoreStatusOkCmd = ctx.GetAttributeString('okcmd', '');
        ctx.SetDialogVariable("message", $.Localize(strMsg));
        let bClose = !!parseInt(strClose);
        let bCancel = !!parseInt(strCancel);
        if (!bClose && !bCancel) {
            $('#CancelButton').visible = false;
        }
        if (bCancel) {
            $('#OkButton').visible = false;
        }
        let bPurchaseConfirmation = _strStoreStatusOkCmd.startsWith(_strStoreProceedAfterCheckoutConfirmation);
        let elPurchaseConfirmation = $('#PurchaseConfirmation');
        elPurchaseConfirmation.visible = bPurchaseConfirmation;
        let sPurchaseConfirmation = bPurchaseConfirmation ? _strStoreStatusOkCmd.slice(1 + _strStoreProceedAfterCheckoutConfirmation.length) : '';
        elPurchaseConfirmation.text = sPurchaseConfirmation ? sPurchaseConfirmation : $.Localize('#SFUI_MBox_OKButton');
        if (bCancel && !bClose && !bPurchaseConfirmation) {
            $("#Spinner").AddClass("SpinnerVisible");
        }
    }
    PopupStoreStatus.SetupPopup = SetupPopup;
    function OnOKPressed() {
        if (_strStoreStatusOkCmd) {
            if (_strStoreStatusOkCmd.startsWith(_strStoreProceedAfterCheckoutConfirmation))
                StoreAPI.StoreProceedAfterCheckoutConfirmation();
            else
                GameInterfaceAPI.ConsoleCommand(_strStoreStatusOkCmd);
        }
        _strStoreStatusOkCmd = null;
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupStoreStatus.OnOKPressed = OnOKPressed;
})(PopupStoreStatus || (PopupStoreStatus = {}));
