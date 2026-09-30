"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupLicenseRegister;
(function (PopupLicenseRegister) {
    let m_LicenseRegisterTimer = null;
    function SetupPopup() {
        let spinnerVisible = $.GetContextPanel().GetAttributeInt("spinner", 0);
        $("#Spinner").SetHasClass("SpinnerVisible", !!spinnerVisible);
        m_LicenseRegisterTimer = $.Schedule(11, PanelTimedOut);
        $.Schedule(1, () => { MyPersonaAPI.ActionStartAgreementSessionInGame(); });
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_StartAgreementSessionInGame', StartAgreementSessionInGame);
    }
    PopupLicenseRegister.SetupPopup = SetupPopup;
    function PanelTimedOut() {
        m_LicenseRegisterTimer = null;
        $.DispatchEvent('UIPopupButtonClicked', '');
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => { });
    }
    function _CancelLicenseRegisterTimer() {
        if (m_LicenseRegisterTimer) {
            $.CancelScheduled(m_LicenseRegisterTimer);
            m_LicenseRegisterTimer = null;
        }
    }
    function StartAgreementSessionInGame(url) {
        _CancelLicenseRegisterTimer();
        $.DispatchEvent('UIPopupButtonClicked', '');
        SteamOverlayAPI.OpenURL('!' + url);
    }
})(PopupLicenseRegister || (PopupLicenseRegister = {}));
