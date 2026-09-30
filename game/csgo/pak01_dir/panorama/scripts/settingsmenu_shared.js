"use strict";
/// <reference path="csgo.d.ts" />
var SettingsMenuShared;
(function (SettingsMenuShared) {
    function _ResetControlsRecursive(panel) {
        if (panel == null) {
            return;
        }
        if (panel.GetChildCount == undefined) {
            return;
        }
        if (panel.paneltype == 'CSGOSettingsSlider' || panel.paneltype == 'CSGOSettingsEnumDropDown') {
            panel.RestoreCVarDefault();
        }
        else if (panel.paneltype == 'CSGOSettingsKeyBinder') {
            panel.OnShow();
        }
        else {
            let nCount = panel.GetChildCount();
            for (let i = 0; i < nCount; i++) {
                let child = panel.GetChild(i);
                _ResetControlsRecursive(child);
            }
        }
    }
    function ResetControls() {
        GameInterfaceAPI.ResetThreadPoolOptions();
        _ResetControlsRecursive($.GetContextPanel());
        InventoryAPI.StopItemPreviewMusic();
    }
    SettingsMenuShared.ResetControls = ResetControls;
    function ResetKeybdMouseDefaults() {
        OptionsMenuAPI.RestoreKeybdMouseBindingDefaults();
        ResetControls();
    }
    SettingsMenuShared.ResetKeybdMouseDefaults = ResetKeybdMouseDefaults;
    function ResetAudioSettings() {
        $.DispatchEvent("CSGOAudioSettingsResetDefault");
        ResetControls();
    }
    SettingsMenuShared.ResetAudioSettings = ResetAudioSettings;
    function ResetVideoSettings() {
        $.DispatchEvent("CSGOVideoSettingsResetDefault");
        ResetControls();
        VideoSettingsOnUserInputSubmit();
    }
    SettingsMenuShared.ResetVideoSettings = ResetVideoSettings;
    function ResetVideoSettingsAdvanced() {
        $.DispatchEvent("CSGOVideoSettingsResetDefaultAdvanced");
        VideoSettingsEnableDiscard();
    }
    SettingsMenuShared.ResetVideoSettingsAdvanced = ResetVideoSettingsAdvanced;
    function _RefreshControls() {
        _RefreshControlsRecursive($.GetContextPanel());
    }
    function _RefreshControlsRecursive(panel) {
        if (panel == null) {
            return;
        }
        if ('OnShow' in panel) {
            panel.OnShow();
        }
        if (panel.GetChildCount == undefined) {
            return;
        }
        else {
            let nCount = panel.GetChildCount();
            for (let i = 0; i < nCount; i++) {
                let child = panel.GetChild(i);
                _RefreshControlsRecursive(child);
            }
        }
    }
    function ShowConfirmReset(resetCall, locText) {
        UiToolkitAPI.ShowGenericPopupOneOptionCustomCancelBgStyle('#settings_reset_confirm_title', locText, '', '#settings_reset', resetCall, '#settings_return', () => { }, 'dim');
    }
    SettingsMenuShared.ShowConfirmReset = ShowConfirmReset;
    function ShowConfirmDiscard(discardCall) {
        UiToolkitAPI.ShowGenericPopupOneOptionCustomCancelBgStyle('#settings_discard_confirm_title', '#settings_discard_confirm_video_desc', '', '#settings_discard', discardCall, '#settings_return', () => { }, 'dim');
    }
    SettingsMenuShared.ShowConfirmDiscard = ShowConfirmDiscard;
    function ScrollToId(locationId) {
        let elLocationPanel = $.GetContextPanel().FindChildTraverse(locationId);
        if (elLocationPanel != null) {
            $.GetContextPanel().Data().bScrollingToId = true;
            elLocationPanel.ScrollParentToMakePanelFit(3, false);
            elLocationPanel.TriggerClass('Highlight');
        }
    }
    SettingsMenuShared.ScrollToId = ScrollToId;
    function SetVis(locationId, vis) {
        let panel = $.GetContextPanel().FindChildTraverse(locationId);
        if (panel != null) {
            panel.visible = vis;
        }
    }
    SettingsMenuShared.SetVis = SetVis;
    let gBtnApplyVideoSettingsButton = null;
    let gBtnDiscardVideoSettingChanges = null;
    let gBtnDiscardVideoSettingChanges2 = null;
    function VideoSettingsOnUserInputSubmit() {
        if (gBtnApplyVideoSettingsButton != null) {
            gBtnApplyVideoSettingsButton.enabled = true;
        }
        if (gBtnDiscardVideoSettingChanges != null) {
            gBtnDiscardVideoSettingChanges.enabled = true;
        }
    }
    SettingsMenuShared.VideoSettingsOnUserInputSubmit = VideoSettingsOnUserInputSubmit;
    function VideoSettingsEnableDiscard() {
        if (gBtnDiscardVideoSettingChanges2 != null) {
            gBtnDiscardVideoSettingChanges2.enabled = true;
        }
    }
    SettingsMenuShared.VideoSettingsEnableDiscard = VideoSettingsEnableDiscard;
    function _VideoSettingsResetUserInput() {
        if (gBtnApplyVideoSettingsButton != null) {
            gBtnApplyVideoSettingsButton.enabled = false;
        }
        if (gBtnDiscardVideoSettingChanges != null) {
            gBtnDiscardVideoSettingChanges.enabled = false;
        }
        if (gBtnDiscardVideoSettingChanges2 != null) {
            gBtnDiscardVideoSettingChanges2.enabled = false;
        }
    }
    function VideoSettingsDiscardChanges() {
        $.DispatchEvent("CSGOVideoSettingsInit");
        _VideoSettingsResetUserInput();
    }
    SettingsMenuShared.VideoSettingsDiscardChanges = VideoSettingsDiscardChanges;
    function VideoSettingsDiscardAdvanced() {
        $.DispatchEvent("CSGOVideoSettingsDiscardAdvanced");
        _VideoSettingsResetUserInput();
    }
    SettingsMenuShared.VideoSettingsDiscardAdvanced = VideoSettingsDiscardAdvanced;
    function VideoSettingsApplyChanges() {
        $.DispatchEvent("CSGOApplyVideoSettings");
        _VideoSettingsResetUserInput();
    }
    SettingsMenuShared.VideoSettingsApplyChanges = VideoSettingsApplyChanges;
    function NewTabOpened(newTab) {
        let videoSettingsStr = 'VideoSettings';
        if (newTab == videoSettingsStr) {
            let videoSettingsPanel = $.GetContextPanel().FindChildInLayoutFile(videoSettingsStr);
            gBtnApplyVideoSettingsButton = videoSettingsPanel.FindChildInLayoutFile("BtnApplyVideoSettings");
            gBtnDiscardVideoSettingChanges = videoSettingsPanel.FindChildInLayoutFile("BtnDiscardVideoSettingChanges");
            gBtnDiscardVideoSettingChanges2 = videoSettingsPanel.FindChildInLayoutFile("BtnDiscardVideoSettingChanges2");
            gBtnApplyVideoSettingsButton.enabled = false;
            gBtnDiscardVideoSettingChanges.enabled = false;
            gBtnDiscardVideoSettingChanges2.enabled = false;
            $.DispatchEvent("CSGOVideoSettingsInit");
        }
        let newTabPanel = $.GetContextPanel().FindChildInLayoutFile(newTab);
        _RefreshControlsRecursive(newTabPanel);
        GameInterfaceAPI.ConsoleCommand("host_writeconfig");
        InventoryAPI.StopItemPreviewMusic();
    }
    SettingsMenuShared.NewTabOpened = NewTabOpened;
    function ChangeBackground(delta) {
        let elBkg = $("#XhairBkg");
        if (elBkg) {
            let nBkgIdx = elBkg.GetAttributeInt("bkg-id", 0);
            let arrBkgs = ["bkg-dust2", "bkg-nuke", "bkg-mirage", "bkg-ancient", "bkg-anubis", "bkg-cache", "bkg-inferno"];
            nBkgIdx = (arrBkgs.length + nBkgIdx + delta) % arrBkgs.length;
            elBkg.SwitchClass("bkg-style", arrBkgs[nBkgIdx]);
            elBkg.SetAttributeInt("bkg-id", nBkgIdx);
        }
    }
    SettingsMenuShared.ChangeBackground = ChangeBackground;
    {
    }
})(SettingsMenuShared || (SettingsMenuShared = {}));
