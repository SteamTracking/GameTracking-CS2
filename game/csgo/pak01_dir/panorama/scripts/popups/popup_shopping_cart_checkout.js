"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/shopping_cart.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/hold_button.ts" />
/// <reference path="../common/add_major_tokens_anim.ts" />
/// <reference path="../popups/popup_major_store.ts" />
/// <reference path="../popups/popup_acknowledge_item.ts" />
var PopUpShoppingCartCheckout;
(function (PopUpShoppingCartCheckout) {
    function getCart(cp) {
        if (!cp)
            cp = $.GetContextPanel();
        let cart = ShoppingCart.cart;
        while (cp) {
            if (cp.Data().hasOwnProperty('cart') && cp.Data().cart) {
                cart = cp.Data().cart;
                break;
            }
            cp = cp.GetParent();
        }
        return cart;
    }
    function OnReadyForDisplay() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        const cp = $.GetContextPanel();
        $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', (...args) => { _ItemCustomizationNotification(...args, cp); });
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', (...args) => { _OnPurchaseCompletion(...args, cp); });
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', Init);
        cp.FindChildInLayoutFile('id-cart-close').SetPanelEvent('onactivate', ClosePopup);
        cp.FindChildInLayoutFile('id-cart-balance').SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, 100, ''));
        cp.FindChildInLayoutFile('id-cart-balance').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTitleTextTooltip('id-cart-balance', '#CSGO_TournamentPass_' + g_ActiveTournamentInfo.location + '_credits', '#major_store_balance_tooltip');
        });
        cp.FindChildInLayoutFile('id-cart-balance').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTitleTextTooltip();
        });
        AddMajorTokensAnim.SetTransitionEndEvent(cp.FindChildInLayoutFile('id-cart-add-tokens'));
    }
    function OnUnreadyForDisplay() {
    }
    let m_numTotalEconItemsInInventory = 0;
    function Init() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'only_econ_items', '', '');
        m_numTotalEconItemsInInventory = InventoryAPI.GetInventoryCount();
        const cp = $.GetContextPanel();
        const strOneOffCartId = cp.GetAttributeString('cartid', '');
        if (strOneOffCartId) {
            let cart = ShoppingCart.findOrCreateTempCart(strOneOffCartId, false);
            if (cart) {
                cp.Data().cart = cart;
                ShoppingCart.releaseTempCart(strOneOffCartId);
            }
        }
        cp.SetHasClass('shopping-oneoff-cart', getCart(cp) !== ShoppingCart.cart);
        _SetRedeemableBalance(cp);
        getCart(cp).subscribeToUpdates(cp, 'purchase-btn', () => {
            _SetupButtonsAndWarnings(cp);
        });
        _SetUpEmptyState(cp);
        _MakeCartTiles(cp);
        getCart(cp).subscribeToUpdates(cp, 'total-price', () => {
            cp.SetDialogVariableInt('total-price', getCart(cp).getTotalPrice());
        });
        getCart(cp).subscribeToUpdates(cp, 'total-count', () => {
            cp.SetDialogVariableInt('total-count', getCart(cp).getTotalItems());
        });
        cp.FindChildInLayoutFile('id-checkout-clear-all').SetPanelEvent('onactivate', () => {
            getCart(cp).clearCart();
            _SetUpEmptyState(cp);
            _MakeCartTiles(cp);
        });
        if (PopupMajorStore.GetSecondsUntilPendingPriceUpdateForAllTournamentItems() > 0) {
            PopupMajorStore.PriceRefreshTimerUpdate(cp);
        }
    }
    PopUpShoppingCartCheckout.Init = Init;
    function _SetRedeemableBalance(cp) {
        const idxLookup = InventoryAPI.GetCacheTypeElementIndexByKey('SeasonalOperations', g_ActiveTournamentInfo.credits_id);
        let nRedeemableBalance = 0;
        if (g_ActiveTournamentInfo.credits_id == InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'season_value')) {
            nRedeemableBalance = InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'redeemable_balance');
            nRedeemableBalance = (nRedeemableBalance === null || nRedeemableBalance === undefined) ? 0 : nRedeemableBalance;
        }
        cp.SetDialogVariableInt('balance', nRedeemableBalance);
        cp.Data().redeemableBalance = nRedeemableBalance;
    }
    function _SetupButtonsAndWarnings(cp) {
        const isInventoryFull = (m_numTotalEconItemsInInventory + getCart(cp).getTotalItems() > ItemInfo.NUM_BACKPACK_SLOTS);
        cp.FindChildInLayoutFile('id-cart-warning').visible = isInventoryFull;
        _AcknowledgeNewTokens(cp);
        $.Schedule(.4, () => {
            let itemId = '';
            let numInactiveTokens = 0;
            if (!cp || !cp.IsValid()) {
                return;
            }
            InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'tool_type:seasontiers,has_attribute:season access:==:' + g_ActiveTournamentInfo.credits_id, '', '');
            if (InventoryAPI.GetInventoryCount() > 0) {
                itemId = InventoryAPI.GetInventoryItemIDByIndex(0);
                numInactiveTokens = Number(InventoryAPI.GetItemAttributeValue(itemId, '{uint32}upgrade level'));
            }
            cp.Data().activatedCredits = numInactiveTokens;
            let nPurchaseTokens = getCart(cp).getTotalPrice() - (cp.Data().redeemableBalance + numInactiveTokens);
            const nActualNumberOfPurchaseTokensNeeded = nPurchaseTokens;
            nPurchaseTokens = nPurchaseTokens > 0 ? Math.max(nPurchaseTokens, 100) : 0;
            const nTokensNeeded = getCart(cp).getTotalPrice() - cp.Data().redeemableBalance;
            cp.SetDialogVariableInt('tokens-needed', nTokensNeeded);
            cp.SetDialogVariableInt('inactive-tokens', numInactiveTokens);
            cp.SetDialogVariableInt('purchase-tokens', nPurchaseTokens);
            cp.FindChildInLayoutFile('id-cart-not-enough-tokens').SetHasClass('show', nTokensNeeded >= 0 && !isInventoryFull && getCart(cp).getTotalPrice() > 0);
            let oSettings = {
                cp: cp,
                nInactiveTokens: numInactiveTokens,
                nPurchaseTokens: nPurchaseTokens,
                nActualNumberOfPurchaseTokensNeeded: nActualNumberOfPurchaseTokensNeeded,
                nTokensNeeded: nTokensNeeded,
                isInventoryFull: isInventoryFull,
                itemId: itemId
            };
            _UpdateActiveTokenProgressSection(oSettings);
            _UpdatePurchaseTokenProgressSection(oSettings);
            _UpdateUseTokensProgressSection(oSettings);
        });
    }
    function _UpdateActiveTokenProgressSection(oSettings) {
        let elActivateSection = oSettings.cp.FindChildInLayoutFile('id-cart-checkout-step-activate');
        const bEnabled = oSettings.nInactiveTokens > 0 &&
            (oSettings.cp.Data().redeemableBalance < getCart(oSettings.cp).getTotalPrice());
        !oSettings.isInventoryFull &&
            getCart(oSettings.cp).getTotalPrice() > 0;
        const bHide = (getCart(oSettings.cp).getTotalItems() < 1) || (oSettings.nInactiveTokens < 1 && oSettings.nPurchaseTokens < 1);
        elActivateSection.SetHasClass('hide', bHide);
        if (bHide)
            return;
        const elPurchaseSection = oSettings.cp.FindChildInLayoutFile('id-cart-checkout-step-purchase');
        if (oSettings.nInactiveTokens > 0 || oSettings.nPurchaseTokens < 1) {
            oSettings.cp.FindChildInLayoutFile('id-cart-purchase-steps').MoveChildBefore(elActivateSection, elPurchaseSection);
            elActivateSection.FindChildInLayoutFile('id-cart-top-line').SetHasClass('hide-top-line', true);
            elPurchaseSection.FindChildInLayoutFile('id-cart-top-line').SetHasClass('hide-top-line', false);
        }
        else {
            elActivateSection.FindChildInLayoutFile('id-cart-top-line').SetHasClass('hide-top-line', false);
            elPurchaseSection.FindChildInLayoutFile('id-cart-top-line').SetHasClass('hide-top-line', true);
            oSettings.cp.FindChildInLayoutFile('id-cart-purchase-steps').MoveChildAfter(elActivateSection, elPurchaseSection);
        }
        const elBtn = elActivateSection.FindChildInLayoutFile('id-cart-activate-tokens-btn');
        const btnSettings = {
            btn: elBtn,
            tooltip: '#major_store_checkout_activate_tokens_tooltip',
            locString: $.Localize('#major_store_checkout_activate_btn'),
            loopingSound: 'UI.Laptop.ButtonFillLoop',
            timerCompleteAction: () => {
                InventoryAPI.UseTool(oSettings.itemId, '');
                elBtn.enabled = false;
                _SetCallbackTimeout(oSettings.cp, elActivateSection);
            }
        };
        HoldButton.SetupButton(btnSettings);
        elBtn.enabled = bEnabled;
        elActivateSection.SetHasClass('active', bEnabled);
    }
    function _UpdatePurchaseTokenProgressSection(oSettings) {
        const elProgressSection = oSettings.cp.FindChildInLayoutFile('id-cart-checkout-step-purchase');
        const bEnabled = oSettings.nInactiveTokens <= 0 && oSettings.nPurchaseTokens > 0 &&
            !oSettings.isInventoryFull &&
            getCart(oSettings.cp).getTotalPrice() > 0;
        const bHide = (oSettings.nPurchaseTokens <= 0 || getCart(oSettings.cp).getTotalItems() < 1);
        elProgressSection.SetHasClass('hide', bHide);
        if (bHide)
            return;
        const elBtn = elProgressSection.FindChildInLayoutFile('id-cart-buy-tokens-btn');
        elBtn.SetDialogVariable('real-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, oSettings.nPurchaseTokens, ''));
        const btnSettings = {
            btn: elBtn,
            tooltip: '#major_store_checkout_purchase_tokens_tooltip' + ((oSettings.nActualNumberOfPurchaseTokensNeeded < 100) ? '100' : ''),
            locString: $.Localize('#major_store_checkout_purchase_btn', elBtn),
            loopingSound: 'UI.Laptop.ButtonFillLoop',
            timerCompleteAction: () => {
                elBtn.enabled = false;
                StoreAPI.StoreItemPurchase('' + g_ActiveTournamentInfo.itemid_charge + '(' + oSettings.nPurchaseTokens + ')');
                $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.buymenu_purchase", "MOUSE");
            }
        };
        elBtn.enabled = bEnabled;
        HoldButton.SetupButton(btnSettings);
        elBtn.enabled = bEnabled;
        elProgressSection.SetHasClass('active', bEnabled);
    }
    function _UpdateUseTokensProgressSection(oSettings) {
        const elProgressSection = oSettings.cp.FindChildInLayoutFile('id-cart-checkout-step-use-tokens');
        const bHide = (getCart(oSettings.cp).getTotalItems() < 1);
        elProgressSection.SetHasClass('hide', bHide);
        if (bHide)
            return;
        const bEnabled = !oSettings.isInventoryFull &&
            getCart(oSettings.cp).getTotalPrice() > 0 &&
            oSettings.nPurchaseTokens <= 0 &&
            (oSettings.nInactiveTokens <= 0 || oSettings.cp.Data().redeemableBalance >= getCart(oSettings.cp).getTotalPrice());
        const elBtn = elProgressSection.FindChildInLayoutFile('id-cart-use-tokens-btn');
        const strCheckoutSuffix = oSettings.cp.GetAttributeString('checkoutsuffix', '') || '';
        const strButtonText = $.Localize('#major_store_checkout_use_tokens_btn' + strCheckoutSuffix);
        elBtn.text = strButtonText;
        const btnSettings = {
            btn: elBtn,
            tooltip: '#major_store_checkout_use_tokens_tooltip' + strCheckoutSuffix,
            locString: strButtonText,
            loopingSound: 'UI.Laptop.ButtonFillLoop',
            timerCompleteAction: () => {
                InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'only_econ_items', '', '');
                if (InventoryAPI.GetInventoryCount() + getCart(oSettings.cp).getTotalItems() > ItemInfo.NUM_BACKPACK_SLOTS) {
                    UiToolkitAPI.ShowGenericPopupOk($.Localize('#popup_casket_title_error_casket_inv_full'), $.Localize('#SFUI_InventoryFull_Error'), '', () => { });
                    return;
                }
                _OnAccept(oSettings.cp.Data().redeemableBalance, getCart(oSettings.cp).getTotalPrice(), oSettings.cp);
                elBtn.enabled = false;
                oSettings.cp.FindChildInLayoutFile('id-cart-close').enabled = false;
                _SetCallbackTimeout(oSettings.cp, elProgressSection);
            }
        };
        HoldButton.SetupButton(btnSettings);
        elBtn.enabled = bEnabled;
        elProgressSection.SetHasClass('active', bEnabled);
    }
    function _SetUpEmptyState(cp) {
        const items = getCart(cp).getItems();
        cp.SetHasClass('empty-cart', items.length <= 0);
    }
    function ClosePopup() {
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('ContextMenuEvent', '');
        UiToolkitAPI.HideTextTooltip();
        UiToolkitAPI.HideTitleTextTooltip();
        PopupMajorStore.CancelRefreshTimerUpdate($.GetContextPanel());
    }
    PopUpShoppingCartCheckout.ClosePopup = ClosePopup;
    function _OnAccept(creditsOwned, totalPrice, cp) {
        const items = getCart(cp).getItems();
        let szPurchaseItems = '';
        if (items.length === 0) {
            getCart(cp).clearCart();
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#major_store_checkout_cart_error'), $.Localize('#major_store_checkout_cart_error_desc'), '', () => $.DispatchEvent('HideContentPanel'));
            ClosePopup();
        }
        else {
            for (const item of items) {
                for (let j = 0; j < item.quantity; ++j) {
                    let purchase_id = item.checkout_id || item.id;
                    szPurchaseItems = purchase_id + (szPurchaseItems ? ',' + szPurchaseItems : '');
                }
            }
        }
        cp.FindChildInLayoutFile('id-checkout-lister').Children().forEach(entry => {
            entry.FindChildInLayoutFile('id-cart-quantity-block').hittest = false;
            entry.FindChildInLayoutFile('id-cart-quantity-block').hittestchildren = false;
        });
        MissionsAPI.ActionOperationFauxPurchase(g_ActiveTournamentInfo.credits_id, creditsOwned, totalPrice, szPurchaseItems);
    }
    function _MakeCartTiles(cp) {
        const elParent = cp.FindChildInLayoutFile('id-checkout-lister');
        const cartIds = new Set(getCart(cp).getItems().map(item => item.id));
        const aItemsNotInCart = elParent.Children().filter(tile => !cartIds.has(tile.id));
        aItemsNotInCart.forEach(tile => {
            tile.AddClass('hide-for-delete');
        });
        getCart(cp).getItems().forEach(item => {
            let elTile = elParent.FindChildInLayoutFile(item.id);
            if (!elTile) {
                elTile = $.CreatePanel('Panel', elParent, item.id);
                elTile.BLoadLayoutSnippet('cart-item');
                const itemImage = elTile.FindChildInLayoutFile('id-cart-item-image');
                itemImage.itemid = item.id;
                itemImage.SetPanelEvent('onactivate', () => {
                    if (getCart(cp) !== ShoppingCart.cart)
                        return;
                    if (cp.Data().isFromInspect) {
                        return;
                    }
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: item.id,
                        inspect_only: true,
                        hide_all_action_items: true,
                        price_in_tokens: item.price,
                        back_to_checkout: true
                    };
                    elPanel.Data().oSettings = oSettings;
                });
                let fmtName = ItemInfo.GetFormattedName(item.id);
                fmtName.SetOnLabel(elTile.FindChildInLayoutFile('id-cart-item-name'));
                elTile.FindChildInLayoutFile('id-cart-item-add-to-cart-btn').SetPanelEvent('onactivate', () => {
                    getCart(cp).addItem(item);
                    const itemQuantity = getCart(cp).getItemQuantity(item.id);
                    elTile.SetDialogVariableInt('count', itemQuantity);
                    const lineItemPrice = getCart(cp).getItemLinePrice(item.id);
                    elTile.SetDialogVariableInt('price', lineItemPrice);
                    if (ShoppingCart.cart.getItemQuantity(item.id) >= 10 || ShoppingCart.cart.getTotalItems() >= 100) {
                        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
                        return;
                    }
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
                });
                elTile.FindChildInLayoutFile('id-cart-item-remove-from-cart-btn').SetPanelEvent('onactivate', () => {
                    getCart(cp).decrementItem(item.id);
                    const itemQuantity = getCart(cp).getItemQuantity(item.id);
                    const lineItemPrice = getCart(cp).getItemLinePrice(item.id);
                    elTile.SetDialogVariableInt('price', lineItemPrice);
                    elTile.SetDialogVariableInt('count', itemQuantity);
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
                });
                elTile.FindChildInLayoutFile('id-cart-item-trash-btn').SetPanelEvent('onactivate', () => {
                    getCart(cp).removeItem(item.id);
                    _SetUpEmptyState(cp);
                    _MakeCartTiles(cp);
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UI.BookClose', 'MOUSE');
                });
                let isInitialSetup = true;
                let lastSeenPrice;
                const elChange = elTile.FindChildInLayoutFile('id-cart-item-price-change');
                getCart(cp).subscribeToUpdates(elTile, 'cart-item', () => {
                    if (item.oldPrice !== undefined && item.oldPrice !== item.price) {
                        const nDifference = item.price - item.oldPrice;
                        elTile.SetDialogVariableInt('price-change', Math.abs(nDifference * getCart(cp).getItemQuantity(item.id)));
                        elChange.SetHasClass('show-change', false);
                        elChange.SwitchClass('direction', item.price > item.oldPrice ? 'higher' : 'lower');
                        if (isInitialSetup || lastSeenPrice == item.price) {
                            elChange.SetHasClass('show-change', true);
                        }
                        else {
                            elTile.FindChildInLayoutFile('id-cart-item-price-loading').visible = true;
                            $.Schedule(1, () => {
                                elTile.FindChildInLayoutFile('id-cart-item-price-loading').visible = false;
                                elChange.SetHasClass('show-change', true);
                            });
                        }
                    }
                    else
                        elChange.SetHasClass('show-change', false);
                    const lineItemPrice = getCart(cp).getItemLinePrice(item.id);
                    const itemQuantity = getCart(cp).getItemQuantity(item.id);
                    elTile.SetDialogVariableInt('price', lineItemPrice);
                    lastSeenPrice = item.price;
                    isInitialSetup = false;
                });
                $.RegisterEventHandler('PropertyTransitionEnd', elTile, function (panelName, propertyName) {
                    if (propertyName === "opacity") {
                        if (elTile.visible === true && elTile.BIsTransparent()) {
                            elTile.DeleteAsync(0);
                        }
                    }
                });
            }
            const lineItemPrice = getCart(cp).getItemLinePrice(item.id);
            const itemQuantity = getCart(cp).getItemQuantity(item.id);
            elTile.SetDialogVariableInt('count', getCart(cp).getItemQuantity(item.id));
            elTile.SetDialogVariableInt('price', getCart(cp).getItemLinePrice(item.id));
        });
    }
    function _SetCallbackTimeout(cp, elProgressSection) {
        _CancelCallbackTimeout(cp);
        elProgressSection.SetHasClass('show-spinner', true);
        cp.Data().redeemTimeoutHandle = $.Schedule(5, () => {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => $.DispatchEvent('HideContentPanel'));
            ClosePopup();
        });
    }
    function _CancelCallbackTimeout(cp) {
        if (cp.Data().redeemTimeoutHandle) {
            $.CancelScheduled(cp.Data().redeemTimeoutHandle);
            cp.Data().redeemTimeoutHandle = null;
            cp.FindChildInLayoutFile('id-cart-purchase-steps').FindChildrenWithClassTraverse('show-spinner').forEach(element => {
                element.SetHasClass('show-spinner', false);
            });
        }
    }
    function _ItemCustomizationNotification(numericType, type, itemid, cp) {
        if (type === 'seasontiers') {
            _CancelCallbackTimeout(cp);
            function CallAtEndAnimation() {
                Init();
                cp.FindChildInLayoutFile('id-cart-add-tokens').SetHasClass('hidden', true);
                cp.FindChildInLayoutFile('id-cart-balance').TriggerClass('popup-major-store__top-bar__balance-anim');
            }
            cp.FindChildInLayoutFile('id-cart-add-tokens').SetHasClass('hidden', false);
            AddMajorTokensAnim.StartAnim(cp.FindChildInLayoutFile('id-cart-add-tokens'), cp.FindChildInLayoutFile('id-cart-balance'), cp.Data().activatedCredits, CallAtEndAnimation);
            cp.Data().activatedCredits = 0;
        }
        if (type === 'reward_redeemed') {
            _CancelCallbackTimeout(cp);
            const aNewItems = AcknowledgeItems.GetItems().filter(item => (item.pickuptype
                && ['purchased'].includes(item.pickuptype)));
            if (aNewItems.length > 0) {
                getCart(cp).clearCart();
                _InvokeCallback($.GetContextPanel());
                $.DispatchEvent('ShowAcknowledgePopup', '', '');
                ClosePopup();
            }
            else {
                ClosePopup();
            }
        }
    }
    function _OnPurchaseCompletion(itemId, cp) {
        _CancelCallbackTimeout(cp);
        _AcknowledgeNewTokens(cp);
    }
    function _AcknowledgeNewTokens(cp) {
        const aNewItems = AcknowledgeItems.GetItems().filter(item => (item.pickuptype
            && ['purchased'].includes(item.pickuptype)));
        let bHasNewCredits = false;
        aNewItems.forEach(item => {
            if ((ItemInfo.ItemDefinitionNameSubstrMatch(item.id, 'tournament_pass_') && ItemInfo.ItemDefinitionNameSubstrMatch(item.id, '_credits'))) {
                InventoryAPI.AcknowledgeNewItembyItemID(item.id);
                bHasNewCredits = true;
            }
        });
        if (bHasNewCredits) {
            $.DispatchEvent('HideStoreStatusPanel');
            $.Schedule(.1, Init);
            if (!cp.Data().isFromInspect)
                _InvokeCallback($.GetContextPanel());
        }
    }
    function _InvokeCallback(cp) {
        var callbackHandle = cp.GetAttributeInt("callback", -1);
        if (callbackHandle != -1) {
            UiToolkitAPI.InvokeJSCallback(callbackHandle, '');
        }
    }
    {
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), OnReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), OnUnreadyForDisplay);
        $.GetContextPanel().RegisterForReadyEvents(true);
        if ($.GetContextPanel().BReadyForDisplay()) {
            OnReadyForDisplay();
        }
    }
})(PopUpShoppingCartCheckout || (PopUpShoppingCartCheckout = {}));
