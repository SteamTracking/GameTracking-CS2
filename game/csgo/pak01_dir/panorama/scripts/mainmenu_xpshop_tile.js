"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="common/icon.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="common/store_items.ts" />
/// <reference path="popups/popup_acknowledge_item.ts" />
/// <reference path="xpshop_track.ts" />
/// <reference path="itemtile_store.ts" />
/// <reference path="xpshop.ts" />
var MainMenuXpShop;
(function (MainMenuXpShop) {
    const _m_XpShopPanel = $.GetContextPanel();
    const m_passDefName = 'XpShopTicket1';
    const m_passId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName(m_passDefName), 0);
    let m_displayStarted = false;
    let m_nTrack;
    let m_scheduleHandleRepeatCollage = null;
    function _Init() {
        if (!_ShouldShow()) {
            return;
        }
        $.GetContextPanel().FindChildInLayoutFile('id-btn-open-xpshop').SetPanelEvent('onactivate', () => {
            $.DispatchEvent('MainMenuGoToStore', 'id-store-nav-xpshop');
        });
        _GetXpShopItems();
    }
    function _GetXpShopItems() {
        m_nTrack = MissionsAPI.GetSeasonalOperationXpShopIndex();
        if (!m_nTrack || m_nTrack === 0) {
            _m_XpShopPanel.SetHasClass('hidden', true);
            return;
        }
        _SetUpTracks();
        if (!m_displayStarted) {
            _MakeStoreItemTiles(_GetItemsForDisplay());
            m_displayStarted = true;
        }
        _m_XpShopPanel.SetHasClass('hidden', false);
    }
    function _ShouldShow() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            _m_XpShopPanel.SetHasClass('hidden', true);
            return false;
        }
        let restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
        if (restrictions) {
            _m_XpShopPanel.SetHasClass('hidden', true);
            return false;
        }
        return true;
    }
    function _SetUpTracks() {
        let bHasPrime = FriendsListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid());
        AcknowledgeItems.GetItemsByType([m_passDefName], true);
        InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'item_definition:' + m_passDefName, '', '');
        let nPass = bHasPrime ? InventoryAPI.GetInventoryCount() : 0;
        let passIndex = 0;
        let oXpShopTrackProgress = InventoryAPI.GetCacheTypeElementJSOByIndex('XpShop', 0);
        const elTracksContainer = $.GetContextPanel().FindChildInLayoutFile('id-tracks-container');
        const elBalance = $.GetContextPanel().FindChildInLayoutFile('id-balance');
        const elUpsell = $.GetContextPanel().FindChildInLayoutFile('id-upsell');
        const elTitle = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-title');
        elTracksContainer.SetDialogVariableInt('max-stars', StoreAPI.GetXpShopMaxTrackLevel());
        const bHasXpShopTracksOrBalance = oXpShopTrackProgress && (oXpShopTrackProgress.xp_tracks.length > 0 || oXpShopTrackProgress.redeemable_balance > 0);
        if (nPass > 0 || bHasXpShopTracksOrBalance) {
            elTracksContainer.visible = true;
            elTitle.visible = true;
            elBalance.visible = false;
            elUpsell.visible = false;
            let numVisiblePassesOrTracks = 0;
            let elParent = $.GetContextPanel().FindChildInLayoutFile('id-tracks');
            for (let i = 0; i < StoreAPI.GetXpShopMaxTracks(); i++) {
                let elTrack = elParent.FindChildInLayoutFile('id-xpshop_track_' + i);
                if (!elTrack) {
                    elTrack = $.CreatePanel('Panel', elParent, 'id-xpshop_track_' + i);
                    elTrack.BLoadLayoutSnippet('mainmenu-shop-ticket');
                    elTrack.FindChildInLayoutFile('id-mainmenu-xpshop-track-progress').BLoadLayout('file://{resources}/layout/xpshop_track.xml', false, false);
                }
                let elTrackProgress = elTrack.FindChildInLayoutFile('id-mainmenu-xpshop-track-progress');
                let elPass = elTrack.FindChildInLayoutFile('id-mainmenu-xpshop-pass');
                let oSettings;
                if (oXpShopTrackProgress && oXpShopTrackProgress.xp_tracks[i]) {
                    oSettings = {
                        xpshop_track_frame_panel: elTrack,
                        xpshop_track_value: parseInt(oXpShopTrackProgress.xp_tracks[i]),
                    };
                    XpShopTrack.XpShopInit(oSettings);
                    elTrack.visible = true;
                    elTrackProgress.visible = true;
                    elPass.visible = false;
                    ++numVisiblePassesOrTracks;
                }
                else if (nPass > 0 && passIndex < nPass) {
                    passIndex++;
                    oSettings = {
                        xpshop_track_frame_panel: elTrack,
                        xpshop_track_value: 0,
                    };
                    XpShopTrack.XpShopInit(oSettings);
                    elTrackProgress.visible = false;
                    elPass.visible = true;
                    elPass.SetHasClass('small-passes', nPass > 2 ? true : false);
                    elTrack.visible = true;
                    ++numVisiblePassesOrTracks;
                }
                else {
                    elTrack.visible = false;
                }
            }
            if (oXpShopTrackProgress && oXpShopTrackProgress.redeemable_balance !== undefined) {
                elBalance.SetDialogVariableInt('redeemable-points', oXpShopTrackProgress.redeemable_balance);
                elBalance.Data().balance = oXpShopTrackProgress.redeemable_balance;
                elBalance.visible = true;
            }
            if (!numVisiblePassesOrTracks) {
                elUpsell.visible = true;
                elTracksContainer.visible = false;
            }
        }
        else {
            elTracksContainer.visible = false;
            elBalance.visible = false;
            elUpsell.visible = true;
            elTitle.visible = false;
            elUpsell.FindChildInLayoutFile('id-upsell-pass-image').itemid = m_passId;
        }
    }
    let m_tilePreviouslyUpdated = null;
    function _GetItemsForDisplay() {
        let nCount = MissionsAPI.GetSeasonalOperationRedeemableGoodsCount(m_nTrack);
        let aXpShopItems = [];
        let nNewItemCount = 0;
        if (nCount < 1) {
            return [];
        }
        for (let i = 0; i < nCount; i++) {
            const ShopEntry = {
                item_name: MissionsAPI.GetSeasonalOperationRedeemableGoodsSchema(m_nTrack, i, 'item_name'),
                lootlist: [],
                ui_show_new_tag: MissionsAPI.GetSeasonalOperationRedeemableGoodsSchema(m_nTrack, i, 'ui_show_new_tag')
            };
            const isNew = XpShop.ShouldShowNewTagForShopEntry(ShopEntry);
            nNewItemCount = isNew ? nNewItemCount++ : nNewItemCount;
            _GetLootListForReward(ShopEntry.item_name).forEach(itemId => {
                aXpShopItems.push({
                    item_name: InventoryAPI.GetItemName(itemId),
                    itemId: itemId,
                    ui_show_new_tag: isNew
                });
            });
        }
        const newItems = aXpShopItems.filter(item => item.ui_show_new_tag);
        const oldItems = aXpShopItems.filter(item => !item.ui_show_new_tag);
        const numItemsInCarousel = 12;
        let aShuffleItems = [];
        if (newItems.length > 0) {
            const nMaxNewItems = Math.round(.6 * numItemsInCarousel);
            const sampleSize = Math.min(newItems.length, nMaxNewItems);
            aShuffleItems = _GetRandomSample([..._GetRandomSample(newItems, sampleSize), ..._GetRandomSample(oldItems, numItemsInCarousel - sampleSize)], numItemsInCarousel);
            aShuffleItems.sort((a, b) => {
                if (a.ui_show_new_tag && !b.ui_show_new_tag)
                    return -1;
                if (!a.ui_show_new_tag && b.ui_show_new_tag)
                    return 1;
                return 0;
            });
        }
        else {
            aShuffleItems = _GetRandomSample(oldItems, numItemsInCarousel);
        }
        return aShuffleItems;
    }
    function _GetRandomSample(items, sampleSize = 10) {
        const size = Math.min(sampleSize, items.length);
        const copy = [...items];
        for (let i = 0; i < size; i++) {
            const randomIndex = i + Math.floor(Math.random() * (copy.length - i));
            [copy[i], copy[randomIndex]] = [copy[randomIndex], copy[i]];
        }
        return copy.slice(0, size);
    }
    function _GetLootListForReward(rewardId) {
        if (rewardId.startsWith('crate_')) {
            let nDefinitionIndex = InventoryAPI.GetItemDefinitionIndexFromDefinitionName(rewardId);
            let idCrate = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(nDefinitionIndex, 0);
            return [idCrate];
        }
        var count = InventoryAPI.GetLootListItemsCount(rewardId);
        var itemsList = [];
        if (!count) {
            itemsList.push(rewardId);
        }
        else {
            for (var i = 0; i < count; i++) {
                var itemId = InventoryAPI.GetLootListItemIdByIndex(rewardId, i);
                itemsList.push(itemId);
            }
        }
        return itemsList;
    }
    ;
    function _MakeStoreItemTiles(aItemsList) {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-mainmenu-xpshop-carousel');
        for (let i = 0; i < aItemsList.length; i++) {
            let elTile = elParent.FindChildInLayoutFile('id-mainmenu-xpshop-store-tile' + aItemsList[i].itemId);
            if (!elTile) {
                elTile = $.CreatePanel('Panel', elParent, 'id-mainmenu-xpshop-store-tile' + aItemsList[i].itemId);
                elTile.BLoadLayoutSnippet('mainmenu-xpshop-itemtile');
                elTile.FindChildInLayoutFile('id-item-image').itemid = aItemsList[i].itemId;
                const setName = ItemInfo.GetSet(aItemsList[i].itemId);
                const SetImage = elTile.FindChildInLayoutFile('id-item-set-image');
                IconUtil.SetupFallbackItemSetIcon(SetImage, setName);
                IconUtil.SetItemSetSVGImage(SetImage, setName);
            }
            elTile.SetHasClass('new', aItemsList[i].ui_show_new_tag);
        }
    }
    function _UpdateTile() {
        if (GameStateAPI.IsLocalPlayerPlayingMatch() || !_ShouldShow()) {
            return;
        }
        _GetXpShopItems();
    }
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PriceSheetChanged', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _UpdateTile);
        $.RegisterForUnhandledEvent('CSGOShowMainMenu', _UpdateTile);
    }
})(MainMenuXpShop || (MainMenuXpShop = {}));
