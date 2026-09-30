"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupRankUpRedemptionStore;
(function (PopupRankUpRedemptionStore) {
    function OnClose() {
        const callbackHandle = $.GetContextPanel().GetAttributeInt("callback", -1);
        if (callbackHandle != -1) {
            UiToolkitAPI.InvokeJSCallback(callbackHandle);
        }
        let fnPopupRankUpRedemptionStoreOnClose = $.GetContextPanel().Data().fnPopupRankUpRedemptionStoreOnClose;
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_new_item_accept', 'MOUSE');
        if (fnPopupRankUpRedemptionStoreOnClose)
            fnPopupRankUpRedemptionStoreOnClose();
    }
    PopupRankUpRedemptionStore.OnClose = OnClose;
})(PopupRankUpRedemptionStore || (PopupRankUpRedemptionStore = {}));
