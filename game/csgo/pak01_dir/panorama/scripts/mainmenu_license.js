"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
var MainMenulicense;
(function (MainMenulicense) {
    const _m_licensePanel = $.GetContextPanel();
    function Init() {
        CheckLicense();
    }
    function CheckLicense() {
        let restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
        if (restrictions) {
            _m_licensePanel.SetDialogVariable('restriction', $.Localize(restrictions.license_msg));
            _m_licensePanel.SetDialogVariable('restriction_act', $.Localize(restrictions.license_act));
        }
        _m_licensePanel.SetHasClass('hidden', !restrictions);
        SetStyleOnRootPanel(restrictions);
    }
    function ActionBuyLicense() {
        let restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
        LicenseUtil.BuyLicenseForRestrictions(restrictions);
    }
    MainMenulicense.ActionBuyLicense = ActionBuyLicense;
    function SetStyleOnRootPanel(restrictions) {
        let elMainMenuInput = _m_licensePanel;
        while (elMainMenuInput) {
            elMainMenuInput = elMainMenuInput.GetParent();
            if (elMainMenuInput.id === 'MainMenuInput')
                break;
        }
        if (elMainMenuInput) {
            elMainMenuInput.SetHasClass('steam-license-restricted', restrictions !== false);
        }
    }
    {
        Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', Init);
    }
})(MainMenulicense || (MainMenulicense = {}));
