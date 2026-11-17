"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var TooltipSouvenirReceipt;
(function (TooltipSouvenirReceipt) {
    function Init() {
        if ($.GetContextPanel().GetAttributeString("pricing", "") === "persticker")
            InitWithPerStickerPricing();
        else
            InitWithPerRarityPricing();
    }
    TooltipSouvenirReceipt.Init = Init;
    function InitWithPerRarityPricing() {
        let itemId = $.GetContextPanel().GetAttributeString("itemid", "");
        if (!itemId) {
            UiToolkitAPI.HideCustomLayoutTooltip('tooltip-souvenir-receipt');
            return;
        }
        const nItemRarity = InventoryAPI.GetItemRarity(itemId);
        const nTotalCostInCredits = MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, 'R' + itemId);
        const elParent = $.GetContextPanel().FindChildInLayoutFile('id-sticker-list');
        const nMaxRarityShown = (nItemRarity < 7) ? 6 : nItemRarity;
        elParent.Children().forEach((sticker, idx) => { if (idx >= nMaxRarityShown)
            sticker.DeleteAsync(0); });
        for (let j = 1; j <= nMaxRarityShown; ++j) {
            let elPanel = elParent.FindChildInLayoutFile('id-sticker' + j);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elParent, 'id-sticker' + j);
                elPanel.BLoadLayoutSnippet('sticker-entry');
            }
            elPanel.style.washColor = InventoryAPI.GetItemRarityColor('R' + j);
            elPanel.SetDialogVariableInt('price', MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, 'R!' + j));
            elPanel.SetDialogVariable('sticker-name', $.Localize('#RI_R' + j + 'p'));
            elPanel.SetHasClass('activeitem', j === nItemRarity);
        }
        const totalSum = nTotalCostInCredits;
        let discountPrice = nTotalCostInCredits;
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-total-row').SetDialogVariableInt('price', totalSum);
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-discount-price-row').SetDialogVariableInt('price', discountPrice);
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-discount-price-row').SetDialogVariable('currency', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, discountPrice, ''));
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-discount-row').SetDialogVariableInt('discount', InventoryAPI.GetItemSouvenirDiscountPercent(itemId));
    }
    function InitWithPerStickerPricing() {
        let itemId = $.GetContextPanel().GetAttributeString("itemid", "");
        if (!itemId) {
            UiToolkitAPI.HideCustomLayoutTooltip('tooltip-souvenir-receipt');
            return;
        }
        const elParent = $.GetContextPanel().FindChildInLayoutFile('id-sticker-list');
        const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
        let slots = [];
        const slotCount = InventoryAPI.GetItemStickerSlotCount(itemId);
        elParent.Children().forEach((sticker, idx) => { if (idx > slotCount) {
            sticker.DeleteAsync(0);
        } });
        for (let i = 0; i < slotCount; i++) {
            const imagePath = InventoryAPI.GetItemStickerImageBySlot(itemId, i);
            if (imagePath) {
                let unCostInCredits = 0;
                const idStickerKit = InventoryAPI.GetItemAttributeValue(itemId, '{uint32}sticker slot ' + i + ' id');
                const idFauxSticker = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, idStickerKit);
                unCostInCredits = MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, idFauxSticker);
                if (!unCostInCredits)
                    unCostInCredits = g_ActiveTournamentInfo.souvenir_cost;
                let fmtName = ItemInfo.GetFormattedName(idFauxSticker);
                const name = fmtName.vars.paintkit_name;
                slots.push({ index: i, imagePath: imagePath, name: name, cost: unCostInCredits });
            }
        }
        slots.sort((a, b) => (b.cost - a.cost) * 100 + (a.index - b.index));
        for (let j = 0; j < slots.length; j++) {
            let elPanel = elParent.FindChildInLayoutFile('id-sticker' + j);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elParent, 'id-sticker' + j);
                elPanel.BLoadLayoutSnippet('sticker-entry');
            }
            elPanel.SetDialogVariableInt('price', slots[j].cost);
            elPanel.SetDialogVariable('sticker-name', slots[j].name ?? slots[j].name);
        }
        const totalSum = slots.reduce((acc, curr) => { return acc + (curr.cost ?? 0); }, 0);
        const discountAmount = InventoryAPI.GetItemSouvenirDiscountPercent(itemId);
        const discountCredits = Math.trunc(totalSum * discountAmount / 100);
        let discountPrice = totalSum;
        if (discountCredits < totalSum)
            discountPrice -= discountCredits;
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-total-row').SetDialogVariableInt('price', totalSum);
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-discount-price-row').SetDialogVariableInt('price', discountPrice);
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-discount-price-row').SetDialogVariable('currency', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, discountPrice, ''));
        $.GetContextPanel().FindChildInLayoutFile('id-sticker-discount-row').SetDialogVariableInt('discount', InventoryAPI.GetItemSouvenirDiscountPercent(itemId));
    }
})(TooltipSouvenirReceipt || (TooltipSouvenirReceipt = {}));
