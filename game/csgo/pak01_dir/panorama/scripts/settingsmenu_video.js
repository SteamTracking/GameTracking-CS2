"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="settingsmenu_shared.ts" />
var SettingsMenuVideo;
(function (SettingsMenuVideo) {
    function SelectSimpleVideoSettings() {
        SettingsMenuShared.VideoSettingsDiscardChanges();
        SettingsMenuShared.SetVis('video_settings', true);
        SettingsMenuShared.SetVis('advanced_video', false);
        $('#SimpleVideoSettingsRadio').checked = true;
        $('#AdvancedVideoSettingsRadio').checked = false;
    }
    SettingsMenuVideo.SelectSimpleVideoSettings = SelectSimpleVideoSettings;
    function SelectAdvancedVideoSettings() {
        SettingsMenuShared.VideoSettingsDiscardChanges();
        SettingsMenuShared.SetVis('video_settings', false);
        SettingsMenuShared.SetVis('advanced_video', true);
        $('#SimpleVideoSettingsRadio').checked = false;
        $('#AdvancedVideoSettingsRadio').checked = true;
    }
    SettingsMenuVideo.SelectAdvancedVideoSettings = SelectAdvancedVideoSettings;
    function ShowHudEdgePositions() {
        UiToolkitAPI.ShowCustomLayoutPopupWithCancelCallback('', 'file://{resources}/layout/popups/popup_hud_edge_positions.xml', () => { });
    }
    SettingsMenuVideo.ShowHudEdgePositions = ShowHudEdgePositions;
    {
        SelectSimpleVideoSettings();
    }
})(SettingsMenuVideo || (SettingsMenuVideo = {}));
