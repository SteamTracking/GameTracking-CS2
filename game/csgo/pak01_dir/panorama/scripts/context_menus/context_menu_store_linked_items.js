"use strict";
/// <reference path="../itemtile_store.ts" />
var StoreLinkedItems;
(function (StoreLinkedItems) {
    function Init() {
        const itemId = $.GetContextPanel().GetAttributeString("itemids", "");
        const isNotReleased = $.GetContextPanel().GetAttributeString("is-not-released", "") === "true";
        const aItemIds = itemId.split(',');
        let elItem = null;
        for (let i = 0; i < aItemIds.length; i++) {
            elItem = $.CreatePanel("Button", $.GetContextPanel().FindChildInLayoutFile('id-store-linked-items-images'), aItemIds[i]);
            elItem.BLoadLayout('file://{resources}/layout/itemtile_store.xml', false, false);
            let oItemData = {
                id: aItemIds[i],
                isNotReleased: isNotReleased,
                isDisabled: isNotReleased
            };
            ItemTileStore.Init(elItem, oItemData);
        }
        ShowWarningText();
    }
    StoreLinkedItems.Init = Init;
    function ShowWarningText() {
        let warningText = $.GetContextPanel().GetAttributeString("linkedWarning", "");
        if (warningText) {
            $.GetContextPanel().SetHasClass('hidewarning', false);
            $.GetContextPanel().SetDialogVariable('warning', $.Localize(warningText));
        }
        else {
            $.GetContextPanel().SetHasClass('hidewarning', true);
        }
    }
})(StoreLinkedItems || (StoreLinkedItems = {}));
