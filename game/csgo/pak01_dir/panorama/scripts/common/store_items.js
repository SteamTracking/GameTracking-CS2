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
            if (!isPerfectWorld &&
                InventoryAPI.IsTool(FauxItemId) &&
                InventoryAPI.GetItemCapabilityByIndex(FauxItemId, 0) === 'decodable') {
                m_oItemsByCategory.key.push({ id: FauxItemId });
            }
            else if (StoreAPI.IsBannerEntryMarketLink(i)) {
                m_oItemsByCategory.market.push({ id: FauxItemId, isMarketItem: true });
            }
            else if ((strBannerEntryCustomFormatString = StoreAPI.GetBannerEntryCustomFormatString(i)).startsWith("coupon")) {
                if (!AllowDisplayingItemInStore(FauxItemId))
                    continue;
                let obj = { id: FauxItemId };
                let sLinkedCoupon = StoreAPI.GetBannerEntryLinkedCoupon(i);
                if (sLinkedCoupon) {
                    let LinkedItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(parseInt(sLinkedCoupon), 0);
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
        let idToCheckForRestrictions = FauxItemId;
        let bIsCouponCrate = InventoryAPI.IsCouponCrate(idToCheckForRestrictions);
        if (bIsCouponCrate && InventoryAPI.GetLootListItemsCount(idToCheckForRestrictions) > 0) {
            idToCheckForRestrictions = InventoryAPI.GetLootListItemIdByIndex(idToCheckForRestrictions, 0);
        }
        let sDefinitionName = InventoryAPI.GetItemDefinitionName(idToCheckForRestrictions);
        if (sDefinitionName === "crate_stattrak_swap_tool")
            return true;
        let bIsDecodable = ItemInfo.ItemHasCapability(idToCheckForRestrictions, 'decodable');
        let sRestriction = bIsDecodable ? InventoryAPI.GetDecodeableRestriction(idToCheckForRestrictions) : null;
        if (sRestriction === "restricted" || sRestriction === "xray") {
            return false;
        }
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
        let sRestriction = InventoryAPI.GetDecodeableRestriction("capsule");
        let bCanSellCapsules = (sRestriction !== "restricted" && sRestriction !== "xray");
        for (let i = 0; i < g_ActiveTournamentStoreLayout.length; i++) {
            if (!bCanSellCapsules && i >= g_ActiveTournamentInfo.num_global_offerings) {
                return;
            }
            let bContainsJustChampions = (typeof g_ActiveTournamentStoreLayout[i][1] === 'string');
            let FauxItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentStoreLayout[i][0], 0);
            let GroupName = g_ActiveTournamentStoreLayout[i][2] ? g_ActiveTournamentStoreLayout[i][2] : '';
            let warning = warningTextTournamentItems(isPurchaseable(FauxItemId), FauxItemId);
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
            if (!itemPrice && i >= g_ActiveTournamentInfo.num_global_offerings) {
                break;
            }
        }
    }
    function warningTextTournamentItems(isPurchaseable, itemid) {
        return !isPurchaseable
            ? '#tournament_items_not_released_1'
            : InventoryAPI.GetItemTypeFromEnum(itemid) === 'type_tool' ? '#tournament_items_notice' : '';
    }
    function isPurchaseable(itemid) {
        let itemSchemaDef = ItemInfo.BuildItemSchemaDef(itemid);
        return itemSchemaDef["cannot_inspect"] === 1 ? false : true;
    }
})(StoreItems || (StoreItems = {}));
