"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/tint_spray_icon.ts" />
/// <reference path="common/store_items.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="rankup_redemption_store.ts" />
var ItemTileStore;
(function (ItemTileStore) {
    function Init(elPanel, oItemData) {
        if (!oItemData || (oItemData.hasOwnProperty('noDropsEarned') && oItemData.noDropsEarned)) {
            elPanel.SetHasClass('no-drops-earned', true);
            return;
        }
        elPanel.SetHasClass('no-drops-earned', false);
        SetDropItemStyle(elPanel, oItemData);
        SetMainMenuItemStyle(elPanel, oItemData);
        SetItemImages(elPanel, oItemData);
        SetName(elPanel, oItemData);
        SetStatTrack(elPanel, oItemData.id);
        SetNewRelease(elPanel, (isNewRelease(oItemData) || oItemData.isDropItem));
        NotReleased(elPanel, oItemData.isNotReleased);
        SetPrice(elPanel, oItemData);
        SetOnActivate(elPanel, oItemData);
        SetClaimed(elPanel, oItemData);
        AddMouseOverEvents(elPanel, oItemData);
    }
    ItemTileStore.Init = Init;
    function SetItemImages(elPanel, oItemData) {
        let displayId = GetDisplayItemId(oItemData, oItemData.id);
        let elImage = elPanel.FindChildInLayoutFile('id-itemtile-store-image-main');
        elImage.itemid = displayId;
        TintSprayImage(elImage, displayId);
        elImage = GetBackgroundImage(elPanel, oItemData);
        elImage.itemid = displayId;
        if (oItemData.hasOwnProperty('linkedid')) {
            displayId = GetDisplayItemId(oItemData, oItemData.linkedid);
            elImage = elPanel.FindChildInLayoutFile('id-itemtile-store-image-linked');
            elImage.itemid = displayId;
        }
        elPanel.FindChildInLayoutFile('id-itemtile-store-image-linked').visible = oItemData.hasOwnProperty('linkedid');
        elPanel.SetHasClass('is-linked', oItemData.hasOwnProperty('linkedid'));
    }
    function GetBackgroundImage(elPanel, oItemData) {
        if (oItemData.hasOwnProperty('isDisplayedInMainMenu')) {
            return oItemData.isDisplayedInMainMenu ?
                elPanel.FindChildInLayoutFile('id-itemtile-mainmenu-store-image-bg') :
                elPanel.FindChildInLayoutFile('id-itemtile-store-image-bg');
        }
        return elPanel.FindChildInLayoutFile('id-itemtile-store-image-bg');
    }
    function TintSprayImage(elImage, ItemId) {
        TintSprayIcon.CheckIsSprayAndTint(ItemId, elImage);
    }
    function GetDisplayItemId(oItemData, itemId) {
        if (InventoryAPI.GetItemTypeFromEnum(itemId) === 'coupon')
            return InventoryAPI.GetLootListItemIdByIndex(itemId, 0);
        return itemId;
    }
    function SetName(elPanel, oItemData) {
        var strItemName = '';
        if (oItemData.useTinyNames) {
            strItemName = $.Localize(InventoryAPI.GetRawDefinitionKey(oItemData.id, 'item_name') + '_tinyname');
        }
        else {
            strItemName = InventoryAPI.GetItemName(oItemData.linkedid ? oItemData.linkedid : oItemData.id);
        }
        elPanel.SetDialogVariable('item-name', strItemName);
    }
    function SetStatTrack(elPanel, itemId) {
        let elStattrak = elPanel.FindChildInLayoutFile('id-itemtile-store-stattrak');
        elStattrak.SetHasClass('hidden', !ItemInfo.IsStatTrak(itemId));
    }
    function SetNewRelease(elPanel, isNew) {
        let elNew = elPanel.FindChildInLayoutFile('id-itemtile-store-new');
        elNew.SetHasClass('hidden', !isNew);
    }
    function NotReleased(elPanel, isnotReleased = false) {
        let elNew = elPanel.FindChildInLayoutFile('id-itemtile-store-not-released');
        elNew.SetHasClass('hidden', !isnotReleased);
    }
    function SetPrice(elPanel, oItemData) {
        if (oItemData.isDropItem) {
            elPanel.SetDialogVariable('sale-price', $.Localize('#op_reward_free'));
            return;
        }
        let reduction = StoreAPI.GetStoreItemPercentReduction(oItemData.id);
        let isMarketItem = IsMarketItem(oItemData);
        elPanel.FindChildInLayoutFile('id-itemtile-store-price').SetHasClass('is-marketlink', isMarketItem);
        elPanel.FindChildInLayoutFile('id-itemtile-store-price').SetHasClass('has-reduction', reduction !== '' && reduction !== undefined && !isMarketItem);
        elPanel.SetDialogVariable('reduction', reduction);
        let origPrice = (oItemData.hasOwnProperty('linkedid')) &&
            ItemInfo.GetStoreOriginalPrice(oItemData.linkedid, 1) !== ItemInfo.GetStoreOriginalPrice(oItemData.id, 1) ?
            ItemInfo.GetStoreOriginalPrice(oItemData.linkedid, 1) + ' - ' + ItemInfo.GetStoreOriginalPrice(oItemData.id, 1) :
            ItemInfo.GetStoreOriginalPrice(oItemData.id, 1);
        let salePrice = (isMarketItem) ?
            $.Localize('#SFUI_Store_Market_Link') :
            (oItemData.hasOwnProperty('linkedid')) &&
                ItemInfo.GetStoreOriginalPrice(oItemData.linkedid, 1) !== ItemInfo.GetStoreOriginalPrice(oItemData.id, 1) ?
                ItemInfo.GetStoreSalePrice(oItemData.linkedid, 1) + ' - ' + ItemInfo.GetStoreSalePrice(oItemData.id, 1) :
                ItemInfo.GetStoreSalePrice(oItemData.id, 1);
        elPanel.SetDialogVariable('original-price', origPrice);
        elPanel.SetDialogVariable('sale-price', salePrice);
    }
    function SetDropItemStyle(elPanel, oItemData) {
        if (oItemData.hasOwnProperty('isDropItem')) {
            elPanel.SetHasClass('is-drop-item', oItemData.isDropItem);
            if (oItemData.isDropItem) {
                elPanel.SetHasClass('is-case-drop', ItemInfo.IsCase(oItemData.id));
            }
        }
        else {
            elPanel.SetHasClass('is-drop-item', false);
        }
    }
    function SetMainMenuItemStyle(elPanel, oItemData) {
        if (oItemData.hasOwnProperty('isDisplayedInMainMenu')) {
            elPanel.SetHasClass('is-mainmenu-item', oItemData.isDisplayedInMainMenu);
        }
        else {
            elPanel.SetHasClass('is-mainmenu-item', false);
        }
    }
    function SetClaimed(elPanel, oItemData) {
        if (oItemData.isDropItem) {
            const bIsFauxItem = InventoryAPI.IsFauxItemID(oItemData.id);
            const bIsExpiredClaimSlot = bIsFauxItem && InventoryAPI.DoesItemMatchDefinitionByName(oItemData.id, 'expired_itemdef');
            elPanel.SetHasClass('item-claimed', bIsFauxItem);
            elPanel.SetHasClass('item-claimslot-expired', bIsExpiredClaimSlot);
        }
    }
    function isNewRelease(oItemData) {
        if (oItemData.hasOwnProperty('isNewRelease')) {
            return oItemData.isNewRelease ? true : false;
        }
        return false;
    }
    function IsMarketItem(oItemData) {
        if (oItemData.hasOwnProperty('isMarketItem')) {
            return oItemData.isMarketItem ? true : false;
        }
        return false;
    }
    function SetOnActivate(elPanel, oItemData) {
        elPanel.enabled = !oItemData.isDisabled;
        if (oItemData.isDropItem || oItemData.isDisabled) {
            return;
        }
        else if (IsMarketItem(oItemData)) {
            elPanel.SetPanelEvent('onactivate', OpenOverlayToMarket.bind(undefined, oItemData.id));
        }
        else if (oItemData.hasOwnProperty('linkedid')) {
            let OpenContextMenu = function (itemId, linkedid, isNotReleased, warning) {
                var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_store_linked_items.xml', 'itemids=' + itemId + ',' + linkedid +
                    '&' + 'is-not-released=' + isNotReleased +
                    '&' + 'linkedWarning=' + warning);
                contextMenuPanel.AddClass("ContextMenu_NoArrow");
            };
            let isNotReleased = oItemData.isNotReleased ? 'true' : 'false';
            let warning = oItemData.linkedWarning ? oItemData.linkedWarning : '';
            elPanel.SetPanelEvent('onactivate', OpenContextMenu.bind(undefined, oItemData.id, oItemData.linkedid, isNotReleased, warning));
            elPanel.SetPanelEvent('oncontextmenu', OpenContextMenu.bind(undefined, oItemData.id, oItemData.linkedid, isNotReleased, warning));
        }
        else if (ItemInfo.ItemHasCapability(oItemData.id, 'decodable')) {
            let displayItemId = '';
            let isNew = isNewRelease(oItemData);
            const isVolatile = !!InventoryAPI.GetItemAttributeValue(oItemData.id, '{uint32}volatile container');
            if (InventoryAPI.GetItemTypeFromEnum(oItemData.id) === 'coupon') {
                displayItemId = InventoryAPI.GetLootListItemIdByIndex(oItemData.id, 0);
                elPanel.SetPanelEvent('onactivate', ShowDecodePopup.bind(undefined, oItemData.id, displayItemId, isNew));
            }
            else if (isVolatile) {
                elPanel.SetPanelEvent('onactivate', ShowVolatilePopup.bind(undefined, oItemData.id));
            }
            else if (InventoryAPI.GetLootListItemsCount(oItemData.id) > 0) {
                elPanel.SetPanelEvent('onactivate', ShowDecodePopup.bind(undefined, oItemData.id, oItemData.id, isNew));
            }
            else {
                elPanel.SetPanelEvent('onactivate', ShowInspectPopup.bind(undefined, oItemData.id));
            }
        }
        else
            elPanel.SetPanelEvent('onactivate', ShowInspectPopup.bind(undefined, oItemData.id));
    }
    function OpenOverlayToMarket(itemId) {
        let m_AppID = SteamOverlayAPI.GetAppID();
        let m_CommunityUrl = SteamOverlayAPI.GetSteamCommunityURL();
        let strSetName = InventoryAPI.GetItemSet(itemId);
        SteamOverlayAPI.OpenURL(m_CommunityUrl + "/market/search?q=&appid=" + m_AppID + "&lock_appid=" + m_AppID + "&category_" + m_AppID + "_ItemSet%5B%5D=tag_" + strSetName);
    }
    function ShowVolatilePopup(id) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_offers_laptop.xml');
        let oSettings = {
            item_id: id,
            inspect_only: true,
            work_type: 'decodeable',
            only_close_btn: true
        };
        elPanel.Data().oSettings = oSettings;
    }
    function ShowDecodePopup(id, displayItemId, isNew) {
        var strExtraSettings = '';
        if (isNew) {
            strExtraSettings = '&overridepurchasemultiple=1';
        }
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_capability_decodable.xml');
        let oSettings = {
            item_id: displayItemId,
            store_item_id: id,
            force_hide_async_bar: true,
            show_work_type_warning: false,
            override_purchase_limit: isNew
        };
        elPanel.Data().oSettings = oSettings;
    }
    function ShowInspectPopup(id) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: id,
            inspect_only: false,
            show_work_type_warning: false,
            store_item_id: id
        };
        elPanel.Data().oSettings = oSettings;
    }
    let jsTooltipDelayHandle = null;
    function AddMouseOverEvents(elPanel, oItemData) {
        const tooltipHotspot = elPanel.FindChildTraverse('tooltip-hotspot');
        const tooltipTargetPanelId = oItemData.isDropItem ? elPanel.id :
            oItemData.hasOwnProperty('linkedid') ? 'tooltip-hotspot' :
                oItemData.isNotReleased ? 'tooltip-hotspot' :
                    'id-itemtile-store-image-main';
        tooltipHotspot.SetPanelEvent('onmouseover', ShowTooltip.bind(undefined, elPanel, oItemData, tooltipTargetPanelId));
        tooltipHotspot.SetPanelEvent('onmouseout', HideTooltip);
    }
    function ShowTooltip(elPanel, oItemData, tooltipTargetPanelId) {
        jsTooltipDelayHandle = $.Schedule(.1, ShowToolTipOnDelay.bind(undefined, elPanel, oItemData, tooltipTargetPanelId));
    }
    function ShowToolTipOnDelay(elPanel, oItemData, tooltipTargetPanelId) {
        jsTooltipDelayHandle = null;
        let itemId = GetDisplayItemId(oItemData, oItemData.id);
        if (!InventoryAPI.IsItemInfoValid(itemId)) {
            return;
        }
        if (oItemData.hasOwnProperty('linkedid')) {
            UiToolkitAPI.ShowTextTooltip(tooltipTargetPanelId, '#store_linked_item_tooltip');
            return;
        }
        if (oItemData.hasOwnProperty('isNotReleased') && oItemData.isNotReleased) {
            if (oItemData.hasOwnProperty('linkedWarning') && oItemData.linkedWarning) {
                UiToolkitAPI.ShowTextTooltip(tooltipTargetPanelId, oItemData.linkedWarning);
            }
            return;
        }
        UiToolkitAPI.ShowCustomLayoutParametersTooltip(tooltipTargetPanelId, 'JsItemStoreTooltip', 'file://{resources}/layout/tooltips/tooltip_inventory_item.xml', 'itemid=' + itemId);
    }
    function HideTooltip() {
        UiToolkitAPI.HideCustomLayoutTooltip('JsItemStoreTooltip');
        UiToolkitAPI.HideTextTooltip();
        if (jsTooltipDelayHandle) {
            $.CancelScheduled(jsTooltipDelayHandle);
            jsTooltipDelayHandle = null;
        }
    }
})(ItemTileStore || (ItemTileStore = {}));
