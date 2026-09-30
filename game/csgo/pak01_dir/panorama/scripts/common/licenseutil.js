"use strict";
/// <reference path="../csgo.d.ts" />
var LicenseUtil;
(function (LicenseUtil) {
    function GetCurrentLicenseRestrictions() {
        let szButtonText = "#Store_Get_License";
        let szMessageText = "#SFUI_LoginLicenseAssist_NoOnlineLicense";
        switch (MyPersonaAPI.GetLicenseType()) {
            case "free_pw_needlink":
                szButtonText = "#Store_Link_Accounts";
                szMessageText = "#SFUI_LoginLicenseAssist_PW_NeedToLinkAccounts";
                break;
            case "free_pw_needupgrade":
                szMessageText = "#SFUI_LoginLicenseAssist_HasLicense_PW";
                break;
            case "free_pw":
                szMessageText = "#SFUI_LoginLicenseAssist_NoOnlineLicense_PW";
                break;
            case "free_sc":
                szMessageText = "#SFUI_LoginLicenseAssist_NoOnlineLicense_SC";
                szButtonText = "#Store_Register_License";
                break;
            case "purchased":
                return false;
        }
        return {
            license_msg: szMessageText,
            license_act: szButtonText
        };
    }
    LicenseUtil.GetCurrentLicenseRestrictions = GetCurrentLicenseRestrictions;
    function BuyLicenseForRestrictions(restrictions) {
        if (restrictions && restrictions.license_act === "#Store_Register_License") {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_license_register.xml', 'message=Store_Register_License' +
                '&' + 'spinner=1');
        }
        else {
            MyPersonaAPI.ActionBuyLicense();
        }
    }
    LicenseUtil.BuyLicenseForRestrictions = BuyLicenseForRestrictions;
    function ShowLicenseRestrictions(restrictions) {
        if (restrictions !== false) {
            UiToolkitAPI.ShowGenericPopupYesNo($.Localize(restrictions.license_act), $.Localize(restrictions.license_msg), '', () => BuyLicenseForRestrictions(restrictions), () => { });
        }
    }
    LicenseUtil.ShowLicenseRestrictions = ShowLicenseRestrictions;
})(LicenseUtil || (LicenseUtil = {}));
