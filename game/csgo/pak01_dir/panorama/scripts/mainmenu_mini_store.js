"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="common/store_items.ts" />
/// <reference path="itemtile_store.ts" />
var MainMenuMiniStore;
(function (MainMenuMiniStore) {
    const _m_StorePanel = $.GetContextPanel();
    function _Init() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            _m_StorePanel.SetHasClass('hidden', true);
            return;
        }
        let restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
        if (restrictions) {
            _m_StorePanel.SetHasClass('hidden', true);
            return;
        }
        $.GetContextPanel().FindChildInLayoutFile('id-open-fullscreen-store-btn').SetPanelEvent('onactivate', () => {
            $.DispatchEvent('MainMenuGoToStore', '');
        });
        _GetStoreItems();
    }
    function _GetStoreItems() {
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
    let _m_numMiniStoreItemsToShow = 5;
    function _MakeStoreItemTiles(aItemsList) {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-mini-store-carousel');
        let numNewPinnedOffers = 0;
        for (let i = 0; i < aItemsList.length; i++) {
            let oItemData = aItemsList[i];
            if (oItemData.isNewRelease)
                ++numNewPinnedOffers;
            else
                break;
        }
        _m_numMiniStoreItemsToShow = Math.max(_m_numMiniStoreItemsToShow, numNewPinnedOffers);
        for (let i = 0; i < _m_numMiniStoreItemsToShow; i++) {
            let oItemData = aItemsList[i];
            oItemData.isDisplayedInMainMenu = true;
            let elTile = elParent.FindChildInLayoutFile('id-mini-store-tile' + aItemsList[i].id);
            if (!elTile) {
                elTile = $.CreatePanel('Button', elParent, 'id-mini-store-tile' + aItemsList[i].id);
                elTile.BLoadLayout('file://{resources}/layout/itemtile_store.xml', false, false);
            }
            ItemTileStore.Init(elTile, aItemsList[i]);
        }
    }
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PriceSheetChanged', _Init);
    }
})(MainMenuMiniStore || (MainMenuMiniStore = {}));
