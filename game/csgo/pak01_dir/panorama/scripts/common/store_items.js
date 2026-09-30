"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="iteminfo.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var StoreItems;
(function (StoreItems) {
    let m_oItemsByCategory = {
        coupon: [],
        tournament: [],
        prime: [],
        market: [],
        key: [],
        store: []
    };
    function MakeStoreItemList() {
        let count = StoreAPI.GetBannerEntryCount();
        if (!count || count < 1) {
            return;
        }
        m_oItemsByCategory = {
            coupon: [],
            tournament: [],
            prime: [],
            market: [],
            key: [],
            store: []
        };
        let isPerfectWorld = (MyPersonaAPI.GetLauncherType() === "perfectworld");
        let strBannerEntryCustomFormatString;
        for (let i = 0; i < count; i++) {
            let ItemId = StoreAPI.GetBannerEntryDefIdx(i);
            let FauxItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(ItemId, 0);
            // Add key
            if (!isPerfectWorld &&
                InventoryAPI.IsTool(FauxItemId) &&
                InventoryAPI.GetItemCapabilityByIndex(FauxItemId, 0) === 'decodable') {
                m_oItemsByCategory.key.push({ id: FauxItemId });
            }
            // Add Market Entries
            else if (StoreAPI.IsBannerEntryMarketLink(i)) {
                m_oItemsByCategory.market.push({ id: FauxItemId, isMarketItem: true });
            }
            // Add coupons
            else if ((strBannerEntryCustomFormatString = StoreAPI.GetBannerEntryCustomFormatString(i)).startsWith("coupon")) {
                if (!AllowDisplayingItemInStore(FauxItemId))
                    continue;
                let obj = { id: FauxItemId };
                let sLinkedCoupon = StoreAPI.GetBannerEntryLinkedCoupon(i);
                if (sLinkedCoupon) {
                    let LinkedItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(parseInt(sLinkedCoupon), 0);
                    $.Msg('Coupon ' + ItemId + ' (itemid ' + FauxItemId + ') is linked to ' + sLinkedCoupon + ' (itemid ' + LinkedItemId + ')');
                    obj.linkedid = LinkedItemId;
                }
                if (strBannerEntryCustomFormatString === "coupon_new") {
                    obj.isNewRelease = true;
                    if (!sLinkedCoupon) {
                        obj.activationType = 'newstore';
                    }
                }
                m_oItemsByCategory.coupon.push(obj);
            }
            else {
                if (!AllowDisplayingItemInStore(FauxItemId))
                    continue;
                m_oItemsByCategory.store.push({ id: FauxItemId });
            }
        }
        GetTournamentItems();
    }
    StoreItems.MakeStoreItemList = MakeStoreItemList;
    function AllowDisplayingItemInStore(FauxItemId) {
        // New releases or store items for coupons should not appear in countries where they cannot be consumed
        let idToCheckForRestrictions = FauxItemId;
        // Use the item contained inside the coupon to check for restrictions
        let bIsCouponCrate = InventoryAPI.IsCouponCrate(idToCheckForRestrictions);
        if (bIsCouponCrate && InventoryAPI.GetLootListItemsCount(idToCheckForRestrictions) > 0) {
            idToCheckForRestrictions = InventoryAPI.GetLootListItemIdByIndex(idToCheckForRestrictions, 0);
        }
        // Check named exceptions
        let sDefinitionName = InventoryAPI.GetItemDefinitionName(idToCheckForRestrictions);
        if (sDefinitionName === "crate_stattrak_swap_tool")
            return true;
        // Get the restrictions
        let bIsDecodable = ItemInfo.ItemHasCapability(idToCheckForRestrictions, 'decodable');
        let sRestriction = bIsDecodable ? InventoryAPI.GetDecodeableRestriction(idToCheckForRestrictions) : null;
        if (sRestriction === "restricted" || sRestriction === "xray") {
            $.Msg("Not displaying store item " + FauxItemId + " >> " + idToCheckForRestrictions + " due to restriction: " + (sRestriction ? sRestriction : "<none>"));
            return false;
        }
        // Otherwise allowed to purchase
        return true;
    }
    function GetStoreItems() {
        return m_oItemsByCategory;
    }
    StoreItems.GetStoreItems = GetStoreItems;
    function GetStoreItemData(type, idx) {
        return m_oItemsByCategory[type][idx];
    }
    StoreItems.GetStoreItemData = GetStoreItemData;
    function GetTournamentItems() {
        // Determine restrictions in user region
        let sRestriction = InventoryAPI.GetDecodeableRestriction("capsule");
        let bCanSellCapsules = (sRestriction !== "restricted" && sRestriction !== "xray");
        for (let i = 0; i < g_ActiveTournamentStoreLayout.length; i++) {
            if (!bCanSellCapsules && i >= g_ActiveTournamentInfo.num_global_offerings) { // Don't create store offers in France and other countries, only globally available offerings there
                return;
            }
            let bContainsJustChampions = (typeof g_ActiveTournamentStoreLayout[i][1] === 'string');
            let FauxItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentStoreLayout[i][0], 0);
            let GroupName = g_ActiveTournamentStoreLayout[i][2] ? g_ActiveTournamentStoreLayout[i][2] : '';
            let warning = warningTextTournamentItems(isPurchaseable(FauxItemId), FauxItemId);
            // Item will have no price if we have stopped selling it from the GC but not updated the item sheet
            let itemPrice = ItemInfo.GetStoreSalePrice(FauxItemId, 1);
            if (itemPrice || bContainsJustChampions) {
                let storeItem = {
                    id: FauxItemId,
                    useTinyNames: true
                };
                storeItem.isDisabled = !isPurchaseable(FauxItemId);
                storeItem.isNotReleased = !isPurchaseable(FauxItemId);
                if (!bContainsJustChampions) {
                    storeItem.linkedid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentStoreLayout[i][1], 0);
                }
                if (GroupName) {
                    storeItem.groupName = GroupName.toString();
                }
                if (warning) {
                    storeItem.linkedWarning = warning;
                }
                if (g_ActiveTournamentStoreLayout[i][0] === g_ActiveTournamentInfo.itemid_pass) {
                    storeItem.isTournamentPass = true;
                }
                m_oItemsByCategory.tournament?.push(storeItem);
            }
            if (!itemPrice && i >= g_ActiveTournamentInfo.num_global_offerings) { // Once we find capsules that are not for sale, then break out
                break;
            }
        }
    }
    function warningTextTournamentItems(isPurchaseable, itemid) {
        return !isPurchaseable
            ? '#tournament_items_not_released_1'
            : InventoryAPI.GetItemTypeFromEnum(itemid) === 'type_tool' ? '#tournament_items_notice' : '';
    }
    //when we need unlock the champions
    function isPurchaseable(itemid) {
        let itemSchemaDef = ItemInfo.BuildItemSchemaDef(itemid);
        return itemSchemaDef["cannot_inspect"] === 1 ? false : true;
    }
})(StoreItems || (StoreItems = {}));
