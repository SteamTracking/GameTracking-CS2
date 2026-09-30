"use strict";
/// <reference path="../csgo.d.ts" />
var PrimeButtonAction;
(function (PrimeButtonAction) {
    function SetUpPurchaseBtn(btnPurchase) {
        let sPrice = StoreAPI.GetStoreItemSalePrice(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1353, 0), 1, '');
        btnPurchase.SetDialogVariable("price", sPrice ? sPrice : '$0');
        btnPurchase.SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.OpenURL(GetStoreUrl() + '/sub/54029');
            $.DispatchEvent('UIPopupButtonClicked', '');
        });
    }
    PrimeButtonAction.SetUpPurchaseBtn = SetUpPurchaseBtn;
    function GetStoreUrl() {
        return 'https://store.' +
            ((SteamOverlayAPI.GetAppID() == 710) ? 'beta.' : '') +
            ((MyPersonaAPI.GetSteamType() === 'china' || MyPersonaAPI.GetLauncherType() === "perfectworld") ? 'steamchina' : 'steampowered') + '.com';
    }
})(PrimeButtonAction || (PrimeButtonAction = {}));
