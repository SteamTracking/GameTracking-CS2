"use strict";
/// <reference path="csgo.d.ts" />
var AdvertisingToggle;
(function (AdvertisingToggle) {
    let _m_elParent = $.GetContextPanel().FindChildInLayoutFile('id-friendslist-broadcast-toggle');
    let _m_elBtn = _m_elParent.FindChildInLayoutFile('id-slider-btn');
    let _m_lobbyListerFilter = '';
    function _Init() {
        _m_elBtn.SetPanelEvent('onactivate', _OnActivateToggle);
    }
    ;
    function OnFilterPressed(sFilter) {
        _m_lobbyListerFilter = sFilter;
        _UpdateToggle();
        _UpdateTooltip(PartyListAPI.GetCount() > 1);
    }
    AdvertisingToggle.OnFilterPressed = OnFilterPressed;
    function _UpdateToggle() {
        if (PartyListAPI.GetCount() > 1) {
            _m_elBtn.checked = false;
            _m_elBtn.enabled = false;
            _UpdateTooltip(true);
            return;
        }
        _m_elBtn.enabled = true;
        _m_elBtn.checked = GetAdvertisingSetting() === _m_lobbyListerFilter;
        _m_elBtn.SetDialogVariable('slide_toggle_text', $.Localize("#advertising_for_hire_" + _m_lobbyListerFilter));
        _UpdateTooltip(false);
    }
    ;
    function _OnActivateToggle() {
        let currentSetting = GetAdvertisingSetting();
        let newSetting = currentSetting === _m_lobbyListerFilter ? '' : _m_lobbyListerFilter;
        PartyListAPI.SetLocalPlayerForHireAdvertising(newSetting);
    }
    function GetAdvertisingSetting() {
        let strAdvertising = PartyListAPI.GetLocalPlayerForHireAdvertising();
        return strAdvertising.split('-')[0];
    }
    AdvertisingToggle.GetAdvertisingSetting = GetAdvertisingSetting;
    function _AdvertisingChanged() {
        let currentSetting = GetAdvertisingSetting();
        _m_elBtn.checked = (currentSetting !== '' && currentSetting === _m_lobbyListerFilter);
        PartyBrowserAPI.Refresh();
    }
    function _UpdateTooltip(isDisabled) {
        let OnMouseOver = function () {
            let tooltipText = isDisabled === true ? '#advertising_for_hire_tooltip_disabled' : '#advertising_for_hire_tooltip';
            UiToolkitAPI.ShowTitleTextTooltip(_m_elBtn.id, '#advertising_for_hire_tooltip_title', tooltipText);
        };
        _m_elBtn.SetPanelEvent('onmouseover', OnMouseOver);
        _m_elBtn.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTitleTextTooltip(); });
    }
    ;
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_LocalPlayerForHireAdvertisingChanged', _AdvertisingChanged);
        $.RegisterForUnhandledEvent("PanoramaComponent_PartyList_RebuildPartyList", _UpdateToggle);
    }
})(AdvertisingToggle || (AdvertisingToggle = {}));
