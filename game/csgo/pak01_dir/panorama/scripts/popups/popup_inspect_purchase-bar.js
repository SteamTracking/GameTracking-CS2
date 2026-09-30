"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../popups/popup_inspect_shared.ts" />
var InspectPurchaseBar;
(function (InspectPurchaseBar) {
    function Init() {
        const elPurchaseBar = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
        elPurchaseBar.FindChildInLayoutFile('id-popup-purchase').SetPanelEvent('onactivate', ClosePopup);
        if (InspectShared.GetPopupSetting('only_close_btn')) {
            elPurchaseBar.FindChildInLayoutFile('id-purchase-section').visible = false;
            elPurchaseBar.RemoveClass('hidden');
            return;
        }
        const storeItemId = InspectShared.GetPopupSetting("store_item_id");
        const purchaseItemId = (!storeItemId ? InspectShared.GetPopupSetting('purchase_item_id') : storeItemId);
        if (!InventoryAPI.IsValidItemID(purchaseItemId)) {
            elPurchaseBar.AddClass('hidden');
            return;
        }
        InspectShared.SetPopupSetting('purchase_item_id', purchaseItemId);
        const bFauxItemIdForPurchase = InventoryAPI.IsFauxItemID(purchaseItemId);
        const priceOriginal = bFauxItemIdForPurchase ? ItemInfo.GetStoreOriginalPrice(purchaseItemId, 1) : '';
        const sRestriction = InspectShared.GetPopupSetting('store_item_id') ? '' :
            InventoryAPI.GetDecodeableRestriction(InspectShared.GetPopupSetting('item_id'));
        const showXrayMachineUi = InspectShared.GetPopupSetting("is_xray_machine");
        if ((InspectShared.GetPopupSetting("work_type") === 'delete') ||
            (InspectShared.GetPopupSetting('inspect_only') === true) ||
            !InventoryAPI.IsValidItemID(purchaseItemId) ||
            !priceOriginal ||
            sRestriction === 'xray' && !showXrayMachineUi ||
            sRestriction === 'restricted' && !$.GetContextPanel().Data().existingRewardFromXrayId) {
            elPurchaseBar.AddClass('hidden');
            return;
        }
        elPurchaseBar.RemoveClass('hidden');
        _SetPurchaseImage(elPurchaseBar, InspectShared.GetPopupSetting('item_id'));
        elPurchaseBar.SetDialogVariable("itemname", InventoryAPI.GetItemName(purchaseItemId));
        const descString = InspectShared.GetPopupSetting('allow_rent') ? '#popup_capability_upsell_rental' : '#popup_capability_upsell';
        _UpdateDecString(elPurchaseBar, storeItemId, descString);
        _SetUpPurchaseBtn(elPurchaseBar);
        _SetUpDropdownAction(elPurchaseBar, $.GetContextPanel());
        _UpdatePurchasePrice(elPurchaseBar, $.GetContextPanel());
    }
    InspectPurchaseBar.Init = Init;
    function _SetPurchaseImage(elPanel, itemId) {
        const elImage = elPanel.FindChildInLayoutFile('PurchaseItemImage');
        const showXrayMachineUi = InspectShared.GetPopupSetting("is_xray_machine");
        elImage.itemid = itemId;
        elImage.SetHasClass('popup-capability-faded', showXrayMachineUi && !InspectShared.GetPopupSetting('allow_xray_purchase'));
    }
    function _UpdateDecString(elPanel, storeItemId, descString) {
        const elDesc = elPanel.FindChildInLayoutFile('PurchaseItemName');
        const showXrayMachineUi = InspectShared.GetPopupSetting("is_xray_machine");
        if (showXrayMachineUi) {
            elPanel.SetDialogVariable("itemprice", ItemInfo.GetStoreSalePrice(InspectShared.GetPopupSetting('purchase_item_id'), 1));
            elDesc.text = "#popup_capability_upsell_xray";
        }
        else if (!storeItemId && !InspectShared.GetPopupSetting('tool_id')) {
            elDesc.text = descString;
        }
        else {
            elDesc.text = "#popup_capability_use";
        }
        const allowXrayPurchase = InspectShared.GetPopupSetting('allow_xray_purchase');
        elDesc.SetHasClass('popup-capability-faded', showXrayMachineUi && !allowXrayPurchase);
    }
    function _UpdatePurchasePrice(elPurchaseBar, contextPanel) {
        if (!elPurchaseBar || !elPurchaseBar.IsValid())
            return;
        const elBtn = elPurchaseBar.FindChildInLayoutFile('PurchaseBtn');
        const elDropdown = elPurchaseBar.FindChildInLayoutFile('PurchaseCountDropdown');
        let qty = 1;
        const showXrayMachineUi = InspectShared.GetPopupSetting("is_xray_machine", contextPanel);
        const bCanShowQuantityDropdown = !showXrayMachineUi && _isAllowedToPurchaseMultiple(contextPanel);
        elDropdown.visible = bCanShowQuantityDropdown;
        if (bCanShowQuantityDropdown) {
            qty = Number(elDropdown.GetSelected().id);
        }
        const salePrice = ItemInfo.GetStoreSalePrice(InspectShared.GetPopupSetting('purchase_item_id', contextPanel), qty);
        elBtn.text = showXrayMachineUi ? '#popup_totool_purchase_header2' : salePrice;
        _UpdateSalePrice(elPurchaseBar, qty, contextPanel);
    }
    function _isAllowedToPurchaseMultiple(contextPanel) {
        const OverridePurchaseMultiple = InspectShared.GetPopupSetting("override_purchase_limit", contextPanel);
        const purchaseItemId = InspectShared.GetPopupSetting('purchase_item_id', contextPanel);
        if (OverridePurchaseMultiple)
            return (OverridePurchaseMultiple);
        const attValue = InventoryAPI.GetItemAttributeValue(purchaseItemId, 'season access');
        if (attValue)
            return false;
        const strToolType = InventoryAPI.GetToolType(purchaseItemId);
        if (strToolType === 'fantoken')
            return false;
        const defName = InventoryAPI.GetItemDefinitionName(purchaseItemId);
        if (defName === 'casket')
            return false;
        if (defName && defName.startsWith('XpShopTicket'))
            return false;
        return true;
    }
    function _SetUpPurchaseBtn(elPurchaseBar) {
        const allowXrayPurchase = InspectShared.GetPopupSetting('allow_xray_purchase');
        const showXrayMachineUi = InspectShared.GetPopupSetting("is_xray_machine");
        const purchaseItemId = InspectShared.GetPopupSetting('purchase_item_id');
        const elDropdown = elPurchaseBar.FindChildInLayoutFile('PurchaseCountDropdown');
        elPurchaseBar.FindChildInLayoutFile('PurchaseBtn').enabled = !showXrayMachineUi || (showXrayMachineUi && allowXrayPurchase);
        elPurchaseBar.FindChildInLayoutFile('PurchaseBtn').SetPanelEvent('onactivate', () => {
            const qty = Number(elDropdown.GetSelected().id);
            const itemDefitionNameString = InventoryAPI.GetItemDefinitionName(purchaseItemId);
            const purchaseList = [];
            for (let i = 0; i < qty; i++) {
                purchaseList.push(purchaseItemId);
            }
            const purchaseString = purchaseList.join(',');
            if (itemDefitionNameString && itemDefitionNameString.startsWith('coupon - crate_patch_') &&
                !ItemInfo.FindAnyUserOwnedCharacterItemID()) {
                UiToolkitAPI.ShowGenericPopupYesNo($.Localize('#CSGO_Patch_NoAgent_Title'), $.Localize('#CSGO_Patch_NoAgent_Message'), '', () => StoreAPI.StoreItemPurchase(purchaseString), () => { });
            }
            else {
                StoreAPI.StoreItemPurchase(purchaseString);
            }
            $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.buymenu_purchase", "MOUSE");
        });
    }
    function _UpdateSalePrice(elPurchaseBar, qty, contextPanel) {
        const purchaseItemId = InspectShared.GetPopupSetting('purchase_item_id', contextPanel);
        const price = ItemInfo.GetStoreOriginalPrice(purchaseItemId, qty);
        const elSalePrice = elPurchaseBar.FindChildInLayoutFile('PurchaseSalePrice');
        const elSalePercent = elPurchaseBar.FindChildInLayoutFile('PurchaseItemPercent');
        const salePercent = StoreAPI.GetStoreItemPercentReduction(purchaseItemId);
        if (salePercent) {
            elSalePrice.visible = true;
            elSalePrice.text = price;
            elSalePercent.visible = true;
            elSalePercent.text = salePercent;
            return;
        }
        elSalePrice.visible = false;
        elSalePercent.visible = false;
    }
    function _SetUpDropdownAction(elPurchaseBar, contextPanel) {
        elPurchaseBar.FindChildInLayoutFile('PurchaseCountDropdown').SetPanelEvent('oninputsubmit', () => _OnDropdownUpdate(elPurchaseBar, contextPanel));
    }
    function _OnDropdownUpdate(elPurchaseBar, contextPanel) {
        _UpdatePurchasePrice(elPurchaseBar, contextPanel);
    }
    function ClosePopup() {
        InventoryAPI.StopItemPreviewMusic();
        $.DispatchEvent('HideSelectItemForCapabilityPopup');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
    }
    InspectPurchaseBar.ClosePopup = ClosePopup;
})(InspectPurchaseBar || (InspectPurchaseBar = {}));
