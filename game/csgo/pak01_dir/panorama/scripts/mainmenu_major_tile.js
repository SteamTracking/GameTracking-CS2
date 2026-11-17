"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="generated/items_event_current_generated_store.d.ts" />
/// <reference path="generated/items_event_current_generated_store.ts" />
/// <reference path="common/major_store_prices.ts" />
var MainMenuMajorTile;
(function (MainMenuMajorTile) {
    const _m_cp = $.GetContextPanel();
    const _m_aTiles = [];
    function _UpdateVisibility() {
        const bVisible = MyPersonaAPI.IsConnectedToGC()
            && !LicenseUtil.GetCurrentLicenseRestrictions()
            && g_ActiveTournamentInfo.active;
        _m_cp.SetHasClass('hidden', !bVisible);
        if (bVisible) {
            StoreAPI.VolatileShopSubscribe(g_ActiveTournamentInfo.itemid_dynamic_stickers, false);
        }
    }
    function _FillCarousel() {
        const elCarousel = _m_cp.FindChildInLayoutFile('id-major-mini-store-carousel');
        MajorStorePrices.GetTopTeams()
            .map(team => MajorStorePrices.PickTeamSticker(team, false))
            .filter(itemId => itemId !== '')
            .forEach((itemId, i) => {
            const elTile = $.CreatePanel('Button', elCarousel, 'id-mini-store-tile-' + i);
            elTile.BLoadLayoutSnippet('major-shop-item');
            elTile.hittest = false;
            elTile.FindChildInLayoutFile('id-item-image').itemid = itemId;
            _m_aTiles.push({ elTile, itemId });
        });
    }
    function _UpdatePrices() {
        _m_aTiles.forEach(({ elTile, itemId }) => {
            const price = MajorStorePrices.GetItemPrice(itemId);
            MajorStorePrices.SetPriceOnPanel(elTile, price);
            elTile.SetHasClass('has-price', MajorStorePrices.GetEffectivePrice(price) > 0);
        });
    }
    function _ShowRealPrices(bShow) {
        _m_aTiles.forEach(({ elTile, itemId }) => {
            if (bShow) {
                MajorStorePrices.ShowRealPrice(elTile, MajorStorePrices.GetItemPrice(itemId));
            }
            else {
                MajorStorePrices.HideRealPrice(elTile);
            }
        });
    }
    function _OpenMajorHub() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-major-hub', 'file://{resources}/layout/popups/popup_major_hub.xml', 'eventid=' + g_ActiveTournamentInfo.eventid);
    }
    {
        const elBtn = _m_cp.FindChildInLayoutFile('id-img-open-major-hub');
        elBtn.SetPanelEvent('onactivate', _OpenMajorHub);
        elBtn.SetPanelEvent('onmouseover', () => _ShowRealPrices(true));
        elBtn.SetPanelEvent('onmouseout', () => _ShowRealPrices(false));
        _m_cp.FindChildInLayoutFile('id-major-promo-image').SetImage('file://{images}/tournaments/backgrounds/pickem_mainmenu_promo_' + g_ActiveTournamentInfo.eventid + '.psd');
        _m_cp.style.backgroundImage = 'url( "file://{images}/tournaments/backgrounds/pickem_mainmenu_bg_' + g_ActiveTournamentInfo.eventid + '.psd" )';
        _m_cp.style.backgroundSize = '100% auto';
        _m_cp.style.backgroundPosition = '100% 100%';
        _m_cp.style.backgroundRepeat = 'no-repeat';
        _FillCarousel();
        _UpdateVisibility();
        _UpdatePrices();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _UpdateVisibility);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _UpdateVisibility);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PriceSheetChanged', _UpdatePrices);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_VolatileShopSubscribe', _UpdatePrices);
    }
})(MainMenuMajorTile || (MainMenuMajorTile = {}));
