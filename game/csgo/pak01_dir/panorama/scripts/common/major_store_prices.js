"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var MajorStorePrices;
(function (MajorStorePrices) {
    const TOP_TEAM_COUNT = 10;
    const MIN_REAL_PRICE_TOKENS = 100;
    const FAKE_SALES_ENABLED = false;
    const fakeSales = new Map();
    function _GetPriceTrend(itemId, szField) {
        return MissionsAPI.GetSeasonalOperationFauxItemTrend(g_ActiveTournamentInfo.credits_id, itemId, szField);
    }
    function GetItemPrice(itemId) {
        const high = _GetPriceTrend(itemId, 'high');
        let low = _GetPriceTrend(itemId, 'low');
        if (FAKE_SALES_ENABLED) {
            if (!fakeSales.has(itemId)) {
                fakeSales.set(itemId, Math.random() < 0.25);
            }
            if (fakeSales.get(itemId)) {
                low = Math.round(high * 0.67);
            }
        }
        const bOnSale = low > 0 && low < high;
        return {
            price: high,
            salePrice: bOnSale ? low : undefined,
            discountPct: bOnSale ? Math.round((high - low) * 100 / high) : undefined,
        };
    }
    MajorStorePrices.GetItemPrice = GetItemPrice;
    function GetEffectivePrice(price) {
        return price.salePrice ?? price.price;
    }
    MajorStorePrices.GetEffectivePrice = GetEffectivePrice;
    function SetPriceOnPanel(elPanel, price) {
        elPanel.SetDialogVariableInt('price', GetEffectivePrice(price));
        elPanel.SetDialogVariableInt('regular-price', price.price);
        elPanel.SetDialogVariableInt('discount', price.discountPct ?? 0);
        elPanel.SetHasClass('on-sale', price.salePrice !== undefined);
        elPanel.FindChildInLayoutFile('id-store-item-price').text = $.Localize('#major_store_price', elPanel);
    }
    MajorStorePrices.SetPriceOnPanel = SetPriceOnPanel;
    function ShowRealPrice(elPanel, price) {
        const nPrice = GetEffectivePrice(price);
        elPanel.FindChildInLayoutFile('id-store-item-real-price').SetHasClass('show', nPrice >= MIN_REAL_PRICE_TOKENS);
        elPanel.SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, nPrice, ''));
    }
    MajorStorePrices.ShowRealPrice = ShowRealPrice;
    function HideRealPrice(elPanel) {
        elPanel.FindChildInLayoutFile('id-store-item-real-price').SetHasClass('show', false);
    }
    MajorStorePrices.HideRealPrice = HideRealPrice;
    function _RandomInt(max) {
        return Math.floor(Math.random() * (max + 1));
    }
    function _Shuffle(aItems) {
        const aShuffled = aItems.slice();
        for (let top = aShuffled.length - 1; top > 0; --top) {
            const j = _RandomInt(top);
            [aShuffled[top], aShuffled[j]] = [aShuffled[j], aShuffled[top]];
        }
        return aShuffled;
    }
    function _ToStickerItemIds(aStickerIds) {
        const defidxSticker = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
        return aStickerIds.map(id => InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxSticker, id));
    }
    function _Rarest(aItemIds) {
        return aItemIds.reduce((best, id) => InventoryAPI.GetItemRarity(id) > InventoryAPI.GetItemRarity(best) ? id : best);
    }
    function GetTopTeams() {
        return _Shuffle(g_ActiveTournamentTeams.slice(0, TOP_TEAM_COUNT));
    }
    MajorStorePrices.GetTopTeams = GetTopTeams;
    function GetTeamGoldSticker(team) {
        return team.stickerids.length > 0 ? _Rarest(_ToStickerItemIds(team.stickerids)) : '';
    }
    MajorStorePrices.GetTeamGoldSticker = GetTeamGoldSticker;
    function PickPlayerStickers(team, nCount) {
        return _Shuffle(team.players.filter(player => player.stickerids.length > 0))
            .slice(0, nCount)
            .map(player => _ToStickerItemIds(player.stickerids)[_RandomInt(player.stickerids.length - 1)]);
    }
    MajorStorePrices.PickPlayerStickers = PickPlayerStickers;
    function PickTeamSticker(team, bRarest) {
        const aSets = [team.stickerids, ...team.players.map(player => player.stickerids)].filter(ids => ids.length > 0);
        if (aSets.length === 0) {
            return '';
        }
        const aItemIds = _ToStickerItemIds(aSets[_RandomInt(aSets.length - 1)]);
        if (bRarest) {
            return _Rarest(aItemIds);
        }
        return aItemIds[_RandomInt(aItemIds.length - 1)];
    }
    MajorStorePrices.PickTeamSticker = PickTeamSticker;
    function GetStoreStickerItemIds() {
        const defidxSticker = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
        const aRawIds = [
            ...g_ActiveTournamentTeams.flatMap(team => [
                ...team.stickerids,
                ...team.players.flatMap(player => player.stickerids),
                ...team.champions.flatMap(player => player.stickerids),
            ]),
            ...g_ActiveTournamentInfo.stickerids,
        ];
        return aRawIds.map(id => InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxSticker, id));
    }
    MajorStorePrices.GetStoreStickerItemIds = GetStoreStickerItemIds;
    function GetStickerPriceRange() {
        let low = 0;
        let high = 0;
        let maxDiscountPct = 0;
        GetStoreStickerItemIds().forEach(itemId => {
            const price = GetItemPrice(itemId);
            const nPrice = GetEffectivePrice(price);
            if (nPrice <= 0) {
                return;
            }
            low = (low === 0) ? nPrice : Math.min(low, nPrice);
            high = Math.max(high, nPrice);
            maxDiscountPct = Math.max(maxDiscountPct, price.discountPct ?? 0);
        });
        return { low, high, maxDiscountPct };
    }
    MajorStorePrices.GetStickerPriceRange = GetStickerPriceRange;
})(MajorStorePrices || (MajorStorePrices = {}));
