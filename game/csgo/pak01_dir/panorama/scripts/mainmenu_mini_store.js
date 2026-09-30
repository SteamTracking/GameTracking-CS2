"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="common/store_items.ts" />
/// <reference path="itemtile_store.ts" />
var MainMenuMiniStore;
(function (MainMenuMiniStore) {
    const _m_StorePanel = $.GetContextPanel();
    function _Init() {
        $.Msg('Item-mini-store- ' + "Init");
        if (!MyPersonaAPI.IsConnectedToGC()) {
            _m_StorePanel.SetHasClass('hidden', true);
            return;
        }
        let restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
        if (restrictions) {
            $.Msg('Item-mini-store- restrictions: ' + restrictions);
            _m_StorePanel.SetHasClass('hidden', true);
            return;
        }
        $.GetContextPanel().FindChildInLayoutFile('id-open-fullscreen-store-btn').SetPanelEvent('onactivate', () => {
            $.DispatchEvent('MainMenuGoToStore', '');
        });
        _GetStoreItems();
    }
    function _GetStoreItems() {
        $.Msg('Item-mini-store- ' + "_GetStoreItems");
        $.Msg('Item-mini-store- ' + StoreItems.GetStoreItems().coupon.length);
        if (StoreItems.GetStoreItems().coupon && StoreItems.GetStoreItems().coupon.length < 1) {
            StoreItems.MakeStoreItemList();
        }
        let aItemsList = StoreItems.GetStoreItems().coupon;
        if (aItemsList.length < 1) {
            _m_StorePanel.SetHasClass('hidden', true);
            return;
        }
        _MakeStoreItemTiles(aItemsList);
        _m_StorePanel.SetHasClass('hidden', false);
    }
    let _m_numMiniStoreItemsToShow = 5; // show at least 5, but might be more if we have more "new coupons"
    function _MakeStoreItemTiles(aItemsList) {
        $.Msg('Item-mini-store- ' + "_MakeStoreItemTiles();");
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-mini-store-carousel');
        // Calculate how many offers are "new"
        let numNewPinnedOffers = 0;
        for (let i = 0; i < aItemsList.length; i++) {
            let oItemData = aItemsList[i];
            if (oItemData.isNewRelease)
                ++numNewPinnedOffers;
            else
                break;
        }
        // Make all the new tiles, possibly bump the max count of tiles (but do not decrease it)
        _m_numMiniStoreItemsToShow = Math.max(_m_numMiniStoreItemsToShow, numNewPinnedOffers);
        for (let i = 0; i < _m_numMiniStoreItemsToShow; i++) {
            let oItemData = aItemsList[i];
            oItemData.isDisplayedInMainMenu = true;
            $.Msg('Item-mini-store- ' + $.Localize(InventoryAPI.GetRawDefinitionKey(oItemData.id, 'item_name') + '_tinyname'));
            let elTile = elParent.FindChildInLayoutFile('id-mini-store-tile' + aItemsList[i].id);
            if (!elTile) {
                elTile = $.CreatePanel('Button', elParent, 'id-mini-store-tile' + aItemsList[i].id);
                elTile.BLoadLayout('file://{resources}/layout/itemtile_store.xml', false, false);
            }
            ItemTileStore.Init(elTile, aItemsList[i]);
        }
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PriceSheetChanged', _Init);
    }
})(MainMenuMiniStore || (MainMenuMiniStore = {}));
