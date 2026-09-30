"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var PopupMajorStoreBalance;
(function (PopupMajorStoreBalance) {
    const _m_cp = $.GetContextPanel();
    let _m_callbackHandle = -1;
    function Init() {
        const eventId = g_ActiveTournamentInfo.eventid;
        _m_callbackHandle = _m_cp.GetAttributeInt('callback', -1);
        _m_cp.SetDialogVariableInt('balance', _m_cp.GetAttributeInt('balance', 0));
        _m_cp.SetDialogVariable('tournament_name', $.Localize('#CSGO_Tournament_Event_NameShort_' + eventId));
        _m_cp.FindChildInLayoutFile('id-major-store-balance-logo').SetImage('file://{images}/tournaments/backgrounds/pickem_mainmenu_promo_' + eventId + '.psd');
        _m_cp.FindChildInLayoutFile('id-major-store-balance-banner').style.backgroundImage = "url( 'file://{images}/tournaments/backgrounds/pickem_bg_" + eventId + ".png')";
        _m_cp.SetHasClass('major-' + eventId, true);
    }
    PopupMajorStoreBalance.Init = Init;
    function OpenMajorHub() {
        Close();
        UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-major-hub', 'file://{resources}/layout/popups/popup_major_hub.xml', 'eventid=' + g_ActiveTournamentInfo.eventid);
    }
    PopupMajorStoreBalance.OpenMajorHub = OpenMajorHub;
    function Close() {
        if (_m_callbackHandle != -1) {
            UiToolkitAPI.InvokeJSCallback(_m_callbackHandle);
            _m_callbackHandle = -1;
        }
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupMajorStoreBalance.Close = Close;
})(PopupMajorStoreBalance || (PopupMajorStoreBalance = {}));
