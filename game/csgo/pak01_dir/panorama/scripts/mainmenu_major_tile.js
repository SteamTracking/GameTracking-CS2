"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="generated/items_event_current_generated_store.d.ts" />
/// <reference path="generated/items_event_current_generated_store.ts" />
var MainMenuMajorTile;
(function (MainMenuMajorTile) {
    const _m_cp = $.GetContextPanel();
    function _Init() {
        const bForceHidden = true;
        let bVisible = !bForceHidden;
        if (!MyPersonaAPI.IsConnectedToGC())
            bVisible = false;
        else if (LicenseUtil.GetCurrentLicenseRestrictions())
            bVisible = false;
        else if (!g_ActiveTournamentInfo.active)
            bVisible = false;
        _m_cp.SetHasClass('hidden', !bVisible);
        if (!bVisible)
            return;
        StoreAPI.VolatileShopSubscribe(g_ActiveTournamentInfo.itemid_rankings_stickers, false);
        _m_cp.FindChildInLayoutFile('id-img-open-major-hub').SetPanelEvent('onactivate', OpenMajorHub);
        _m_cp.SetHasClass('major-' + g_ActiveTournamentInfo.eventid.toString(), true);
        _m_cp.FindChildInLayoutFile('id-major-promo-image').SetImage('file://{images}/tournaments/backgrounds/pickem_mainmenu_promo_' + g_ActiveTournamentInfo.eventid + '.psd');
        let bHasActualCapsulesForPurchase = false;
        _m_cp.SetHasClass('has-reduction', false);
        let tournamentEventId = NewsAPI.GetActiveTournamentEventID();
        if ((tournamentEventId !== 0)) {
            let arrSorted = [];
            const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
            const fnStickerKit = (nStickerKit) => {
                const fauxId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, nStickerKit);
                const cHigh = MissionsAPI.GetSeasonalOperationFauxItemTrend(g_ActiveTournamentInfo.credits_id, fauxId, 'high');
                const cPrice = MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, fauxId);
                const weeklyPctReductionFromHigh = (cHigh > cPrice) ? ((cHigh - cPrice) * 100.0 / cHigh) : 0.0;
                arrSorted.push({ discount: weeklyPctReductionFromHigh, price: cPrice, fauxid: fauxId });
            };
            g_ActiveTournamentTeams.forEach((tt) => {
                tt.players.forEach((tp) => tp.rankingids.forEach(fnStickerKit));
            });
            g_ActiveTournamentInfo.rankingids.forEach(fnStickerKit);
            for (let i = arrSorted.length; i-- > 0;) {
                const j = Math.floor(Math.random() * (i + 1));
                [arrSorted[i], arrSorted[j]] = [arrSorted[j], arrSorted[i]];
            }
            arrSorted.sort((a, b) => b.price - a.price);
            const nBaseIndex = Math.floor(Math.random() * (arrSorted.length / 10));
            let elParent = $.GetContextPanel().FindChildInLayoutFile('id-major-mini-store-carousel');
            const _m_numMiniStoreItemsToShow = 10;
            for (let i = 0; i < _m_numMiniStoreItemsToShow; i++) {
                const nIndex = nBaseIndex + i;
                let elTile = elParent.FindChildInLayoutFile('id-mini-store-tile-' + i);
                if (!elTile) {
                    elTile = $.CreatePanel('Button', elParent, 'id-mini-store-tile-' + i);
                    elTile.BLoadLayoutSnippet('major-shop-item');
                    elTile.hittest = false;
                }
                elTile.FindChildInLayoutFile('id-item-image').itemid = arrSorted[nIndex].fauxid;
                elTile.SetDialogVariableInt('price', arrSorted[nIndex].price);
                elTile.FindChildInLayoutFile('id-item-inspect-btn').SetPanelEvent('onactivate', () => {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: arrSorted[nIndex].fauxid,
                        inspect_only: true,
                        hide_all_action_items: true,
                        price_in_tokens: arrSorted[nIndex].price,
                    };
                    elPanel.Data().oSettings = oSettings;
                });
            }
            bHasActualCapsulesForPurchase = true;
        }
        _m_cp.SetDialogVariable('hub-title-bar-caption', $.Localize(bHasActualCapsulesForPurchase ? '#mainmenu_major_hub' : '#mainmenu_major_hub_no_items'));
        _m_cp.SetHasClass('can-sell-items', bHasActualCapsulesForPurchase);
    }
    function OpenMajorHub() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-major-hub', 'file://{resources}/layout/popups/popup_major_hub.xml', 'eventid=' + (g_ActiveTournamentInfo.eventid));
    }
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PriceSheetChanged', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_VolatileShopSubscribe', _Init);
    }
})(MainMenuMajorTile || (MainMenuMajorTile = {}));
