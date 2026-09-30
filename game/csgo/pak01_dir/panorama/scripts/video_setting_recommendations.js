"use strict";
/// <reference path="csgo.d.ts" />
var VideoSettingRecommendations;
(function (VideoSettingRecommendations) {
    function MaybeShowPopup() {
        let driverInfo = GameInterfaceAPI.GetGraphicsDriverInfo();
        if (MaybeShowGraphicsDriverPopup(driverInfo))
            return true;
        let vrrStatus = GameInterfaceAPI.GetVariableRefreshRateStatus();
        if (MaybeShowVariableRefreshRatePopup(driverInfo, vrrStatus))
            return true;
        let currDisplayMode = GameInterfaceAPI.GetCurrentDisplayMode();
        let allDisplayModes = GameInterfaceAPI.GetAllDisplayModes();
        if (MaybeShowRefreshRatePopup(currDisplayMode, allDisplayModes))
            return true;
        let lowLatencyType = GameInterfaceAPI.GetRenderLowLatencyType();
        let config = GameInterfaceAPI.GetVideoConfig();
        if (MaybeShowLowLatencyVSyncPopup(vrrStatus, lowLatencyType, config))
            return true;
        return false;
    }
    VideoSettingRecommendations.MaybeShowPopup = MaybeShowPopup;
    function MaybeShowGraphicsDriverPopup(driverInfo) {
        if (!driverInfo.driver_out_of_date)
            return false;
        if (GameInterfaceAPI.GetSettingString('cl_graphics_driver_warning_dont_show_again') !== '0')
            return false;
        switch (driverInfo.vendor_id) {
            case 0x1002:
                {
                    ShowGraphicsDriverPopup("AMD", 'https://amd.com/support');
                    return true;
                }
            case 0x10DE:
                {
                    ShowGraphicsDriverPopup("Nvidia", 'https://nvidia.com/drivers');
                    return true;
                }
            default:
                {
                    return false;
                }
        }
    }
    function ShowGraphicsDriverPopup(vendor, link) {
        UiToolkitAPI.ShowGenericPopupThreeOptions('#PlayMenu_GraphicsDriverWarning_Title', '#PlayMenu_GraphicsDriverWarning_' + vendor, '', '#PlayMenu_GraphicsDriverLink_' + vendor, () => {
            SteamOverlayAPI.OpenExternalBrowserURL(link);
        }, '#PlayMenu_GraphicsDriverWarning_DontShowAgain', () => {
            GameInterfaceAPI.SetSettingString('cl_graphics_driver_warning_dont_show_again', '1');
        }, '#OK', () => { });
    }
    function MaybeShowVariableRefreshRatePopup(driverInfo, vrrStatus) {
        if (vrrStatus !== 'inactive')
            return false;
        if (GameInterfaceAPI.GetSettingString('cl_vrr_recommendation_dont_show_again') !== '0')
            return false;
        switch (driverInfo.vendor_id) {
            case 0x10DE:
                {
                    if (GameInterfaceAPI.HasCommandLineParm("-tools"))
                        return false;
                    ShowVariableRefreshRatePopup("Nvidia", $.Localize('#GSyncHelpLinkURL'));
                    return true;
                }
            default:
                {
                    return false;
                }
        }
    }
    function ShowVariableRefreshRatePopup(vendor, link) {
        UiToolkitAPI.ShowGenericPopupThreeOptions('#SettingsRecommendation', '#VariableRefreshRateRecommendation_' + vendor, '', '#PlayMenu_GraphicsDriverLink_' + vendor, () => {
            SteamOverlayAPI.OpenExternalBrowserURL(link);
        }, '#PlayMenu_GraphicsDriverWarning_DontShowAgain', () => {
            GameInterfaceAPI.SetSettingString('cl_vrr_recommendation_dont_show_again', '1');
        }, '#OK', () => { });
    }
    function MaybeShowRefreshRatePopup(currDisplayMode, allDisplayModes) {
        if (!currDisplayMode)
            return false;
        if (GameInterfaceAPI.GetSettingString('cl_refresh_rate_recommendation_dont_show_again') !== '0')
            return false;
        let maxRefreshRate = 0;
        for (let mode of allDisplayModes) {
            if (mode.width == currDisplayMode.width &&
                mode.height == currDisplayMode.height &&
                mode.refresh_rate > maxRefreshRate) {
                maxRefreshRate = mode.refresh_rate;
            }
        }
        if (currDisplayMode.refresh_rate > maxRefreshRate * 0.9)
            return false;
        let elPanel = $.GetContextPanel();
        elPanel.SetDialogVariableInt('curr_refresh_rate', Math.round(currDisplayMode.refresh_rate));
        elPanel.SetDialogVariableInt('max_refresh_rate', Math.round(maxRefreshRate));
        UiToolkitAPI.ShowGenericPopupTwoOptions('#SettingsRecommendation', $.Localize('#RefreshRateRecommendation', elPanel), '', '#PlayMenu_GraphicsDriverWarning_DontShowAgain', () => {
            GameInterfaceAPI.SetSettingString('cl_refresh_rate_recommendation_dont_show_again', '1');
        }, '#OK', () => { });
        return true;
    }
    function MaybeShowLowLatencyVSyncPopup(vrrStatus, lowLatencyType, config) {
        if ((vrrStatus !== 'active') ||
            (lowLatencyType !== 'nvidia_reflex') ||
            (config.vsync === true && config.low_latency !== 0)) {
            return false;
        }
        if (GameInterfaceAPI.GetSettingString('cl_low_latency_vsync_recommendation_dont_show_again') !== '0')
            return false;
        UiToolkitAPI.ShowGenericPopupThreeOptions('#SettingsRecommendation', '#LowLatencyVSyncRecommendation_Nvidia', '', '#settings_apply_video', () => {
            $.DispatchEvent('OpenSettingsMenu');
            $.DispatchEvent('SettingsMenu_NavigateToSetting', 'VideoSettings', 'AdvancedVideoSettingsRadio', 'VSyncPanel');
            $.DispatchEvent('CSGOApplyLowLatencyVSyncRecommendation');
        }, '#PlayMenu_GraphicsDriverWarning_DontShowAgain', () => {
            GameInterfaceAPI.SetSettingString('cl_low_latency_vsync_recommendation_dont_show_again', '1');
        }, '#OK', () => { });
        return true;
    }
})(VideoSettingRecommendations || (VideoSettingRecommendations = {}));
