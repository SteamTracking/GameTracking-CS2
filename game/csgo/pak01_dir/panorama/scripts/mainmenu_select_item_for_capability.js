"use strict";
/// <reference path="csgo.d.ts" />
var MainMenuSelectItemForCapability;
(function (MainMenuSelectItemForCapability) {
    function _ShowSelectItemForCapabilityPopup(itemid, itemid2, capability, bWorkshopItemPreview = false) {
        _OpenSelectItemForCapabilityPopUp(itemid, itemid2, capability, bWorkshopItemPreview);
    }
    function _ShowSelectItemForWorkshopPreviewCapability(capability, itemid, itemid2) {
        _OpenSelectItemForCapabilityPopUp(capability, itemid, itemid2, true);
    }
    // This gets called when have added one item to the storage unit and are asked it we wat to add more to that unit.
    function _PromptShowSelectItemForCapabilityPopup(titletxt, messagetxt, capability, itemid, itemid2) {
        UiToolkitAPI.ShowGenericPopupOkCancel($.Localize(titletxt), $.Localize(messagetxt), '', () => $.DispatchEvent('ShowSelectItemForCapabilityPopup', itemid, itemid2, capability), () => { });
    }
    function _OpenSelectItemForCapabilityPopUp(itemid, itemid2 = '', capability, bWorkshopItemPreview = false) {
        const CloseItemForCapabilityCallbackHandle = UiToolkitAPI.RegisterJSCallback(() => {
            $.Msg('Close Item Capability Callback');
            if (CloseItemForCapabilityCallbackHandle) {
                UiToolkitAPI.UnregisterJSCallback(CloseItemForCapabilityCallbackHandle);
            }
        });
        const sWorkshop = bWorkshopItemPreview === true ? bWorkshopItemPreview : false;
        $.DispatchEvent('CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE');
        UiToolkitAPI.ShowCustomLayoutPopupParameters('id-select-item-for-capability=' + itemid, 'file://{resources}/layout/popups/popup_select_item_for_capability.xml', 'itemid=' + itemid +
            '&' + 'secondaryItemid=' + itemid2 +
            '&' + 'bWorkshopItemPreview=' + sWorkshop +
            '&' + 'capability=' + capability +
            '&' + 'callback=' + CloseItemForCapabilityCallbackHandle);
    }
    {
        $.RegisterForUnhandledEvent('PromptShowSelectItemForCapabilityPopup', _PromptShowSelectItemForCapabilityPopup);
        $.RegisterForUnhandledEvent('ShowSelectItemForCapabilityPopup', _ShowSelectItemForCapabilityPopup);
        $.RegisterForUnhandledEvent('ShowSelectItemForWorkshopPreviewCapability', _ShowSelectItemForWorkshopPreviewCapability);
    }
})(MainMenuSelectItemForCapability || (MainMenuSelectItemForCapability = {}));
