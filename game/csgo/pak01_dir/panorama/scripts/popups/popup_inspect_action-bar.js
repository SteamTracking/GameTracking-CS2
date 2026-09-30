"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/item_context_entries.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="../characterbuttons.ts" />
/// <reference path="../common/shopping_cart.ts" />
var InspectActionBar;
(function (InspectActionBar) {
    function Init() {
        const elActionBar = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectActionBar');
        if (!InspectShared.GetPopupSetting('inspect_only')) {
            elActionBar.AddClass('hidden');
            return;
        }
        elActionBar.Data().schfnMusicMvpPreviewEnd = null;
        elActionBar.Data().previewingMusic = false;
        elActionBar.RemoveClass('hidden');
        elActionBar.Data().panelRegisteredForEvents = false;
        const itemId = InspectShared.GetPopupSetting('item_id');
        _SetUpItemCertificate(elActionBar, itemId);
        _SetupEquipItemBtns(elActionBar, itemId);
        _ShowButtonsForWeaponInspect(elActionBar, itemId);
        _ShowButtonsForCharacterInspect(elActionBar, itemId);
        _SetCloseBtnAction(elActionBar, $.GetContextPanel());
        _SetUpMarketLink(elActionBar, itemId);
        _SetUpOpenSeasonStatsAction(elActionBar, $.GetContextPanel(), itemId);
        _SetUpViewHighlightReelAction(elActionBar, itemId);
        const nPrice = InspectShared.GetPopupSetting('price_in_tokens');
        _SetupAddRemoveToCartButtons(elActionBar, itemId, nPrice);
        _SetupCartActionsBtn(elActionBar, nPrice, itemId);
        _ShowHideCartBtn(elActionBar, nPrice);
        _ShowHideFavoriteBtn($.GetContextPanel(), elActionBar, nPrice);
        if (!elActionBar.Data().panelRegisteredForEvents) {
            elActionBar.Data().panelRegisteredForEvents = true;
            $.RegisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', () => _SetupEquipItemBtns(elActionBar, itemId));
        }
        if (nPrice) {
            $.RegisterForUnhandledEvent('PanoramaComponent_Store_VolatileShopSubscribe', (...args) => { _OnVolatileShopSubscribe(...args, elActionBar); });
            _EnsureVolatileShopSubscribed($.GetContextPanel());
        }
        const contentPanel = $.GetContextPanel();
        elActionBar.FindChildInLayoutFile('InspectPlayMvpBtn').SetPanelEvent('onactivate', () => InspectPlayMusic('mvp', contentPanel));
        const category = InventoryAPI.GetLoadoutCategory(itemId);
        if (category == "musickit") {
            InventoryAPI.PlayItemPreviewMusic(itemId, '');
            elActionBar.Data().previewingMusic = true;
            const elMusicBtn = elActionBar.FindChildInLayoutFile('InspectPlayMvpBtn');
            elMusicBtn.SetHasClass('hidden', (InventoryAPI.GetItemRarity(itemId) <= 0));
        }
        const bisItemInLootlist = InspectShared.GetPopupSetting('is_item_in_lootlist');
        elActionBar.FindChildInLayoutFile('InspectWeaponBtn').checked =
            (!elActionBar.FindChildInLayoutFile('InspectCharBtn').checked &&
                !elActionBar.FindChildInLayoutFile('LookatWeaponBtn').checked) ||
                bisItemInLootlist;
        if (bisItemInLootlist) {
            $.DispatchEvent("Activated", elActionBar.FindChildInLayoutFile('InspectWeaponBtn'), "mouse");
        }
    }
    InspectActionBar.Init = Init;
    function _EnsureVolatileShopSubscribed(cp) {
        if (!cp || !cp.IsValid())
            return;
        if (cp.Data().refreshSubscriptionHandle) {
            $.CancelScheduled(cp.Data().refreshSubscriptionHandle);
            cp.Data().refreshSubscriptionHandle = null;
        }
        g_ActiveTournamentDynamicContainers.forEach((id) => StoreAPI.VolatileShopSubscribe(id, true));
        cp.Data().refreshSubscriptionHandle = $.Schedule(150, () => _EnsureVolatileShopSubscribed(cp));
    }
    function _OnVolatileShopSubscribe(nContainerDef, bNewPricesParsed, elActionBar) {
        const nPrice = InspectShared.GetPopupSetting('price_in_tokens');
        const itemId = InspectShared.GetPopupSetting('item_id');
        _SetupAddRemoveToCartButtons(elActionBar, itemId, nPrice);
        _SetupCartActionsBtn(elActionBar, nPrice, itemId);
        _ShowHideCartBtn(elActionBar, nPrice);
        _ShowHideFavoriteBtn($.GetContextPanel(), elActionBar, nPrice);
    }
    function _SetUpItemCertificate(elPanel, id) {
        const elCert = elPanel.FindChildInLayoutFile('InspectItemCert');
        if (!elCert || !elCert.IsValid()) {
            return;
        }
        const certData = InventoryAPI.GetItemCertificateInfo(id);
        if (!certData || InspectShared.GetPopupSetting('hide_item_cert')) {
            elCert.visible = false;
            return;
        }
        const aCertData = certData.split("\n");
        let strLine = "";
        for (let i = 0; i < aCertData.length - 1; i++) {
            if (i % 2 == 0) {
                strLine = strLine + "<b>" + aCertData[i] + "</b>" + ": " + aCertData[i + 1] + "<br><br>";
            }
        }
        elCert.visible = true;
        elCert.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip('InspectItemCert', strLine));
        elCert.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
    }
    function _SetUpMarketLink(elPanel, id) {
        const elMarketLinkBtn = elPanel.FindChildInLayoutFile('InspectMarketLink');
        const bMarketLink = InspectShared.GetPopupSetting('show_market_link');
        elMarketLinkBtn.SetHasClass('hidden', !bMarketLink);
        if (!bMarketLink) {
            return;
        }
        elMarketLinkBtn.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip('InspectMarketLink', '#SFUI_Store_Market_Link'));
        elMarketLinkBtn.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
        elMarketLinkBtn.SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.OpenURL(ItemInfo.GetMarketLinkForLootlistItem(id));
        });
    }
    function _SetUpOpenSeasonStatsAction(elPanel, contextPanel, id) {
        if (InspectShared.GetPopupSetting('hide_all_action_items'))
            return;
        const elOpenSeasonPanel = elPanel.FindChildInLayoutFile('OpenSeasonStats');
        if (ItemInfo.ItemDefinitionNameStartsWith(id, 'premier season coin')) {
            const season = InventoryAPI.GetItemAttributeValue(id, 'premier season');
            elOpenSeasonPanel.SetPanelEvent('onactivate', () => {
                UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-season-stats', 'file://{resources}/layout/popups/popup_season_stats.xml', 'seasonid=' + season + '&' +
                    'itemid=' + id);
                CloseBtnAction(_GetSettingCallback(contextPanel), elPanel);
            });
            $.DispatchEvent('ContextMenuEvent', '');
            elOpenSeasonPanel.SetHasClass('hidden', false);
        }
    }
    function _SetUpViewHighlightReelAction(elPanel, id) {
        const reelId = InventoryAPI.GetItemAttributeValue(id, '{uint32}keychain slot 0 highlight');
        if (!reelId)
            return;
        const elViewHighlightReelAction = elPanel.FindChildInLayoutFile('ViewHighlightReelAction');
        const fnPopupVideoClip = () => {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-videoclip-' + reelId, 'file://{resources}/layout/popups/popup_videoclip.xml', 'reelid=' + reelId + '&' +
                'itemid=' + id);
        };
        elViewHighlightReelAction.SetPanelEvent('onactivate', fnPopupVideoClip);
        elViewHighlightReelAction.SetHasClass('hidden', false);
        if (ItemInfo.IsKeychain(id)) {
            $.Schedule(0.0001, fnPopupVideoClip);
        }
    }
    function _SetupEquipItemBtns(elPanel, id) {
        const elMoreActionsBtn = elPanel.FindChildInLayoutFile('InspectActionsButton');
        const contextPanel = $.GetContextPanel();
        elMoreActionsBtn.SetPanelEvent('onactivate', () => ShowContextMenu(contextPanel));
        const elSingleActionBtn = elPanel.FindChildInLayoutFile('SingleAction');
        if (InspectShared.GetPopupSetting('is_inside_casket')) {
            elMoreActionsBtn.AddClass('hidden');
            elSingleActionBtn.RemoveClass('hidden');
            elSingleActionBtn.text = !InspectShared.GetPopupSetting('is_selected') ? '#UI_Select' : '#UI_Unselect';
            elSingleActionBtn.SetPanelEvent('onactivate', () => _OnActivateUpdateSelectionForMultiSelect(id, contextPanel));
            return;
        }
        if (InspectShared.GetPopupSetting('hide_all_action_items')) {
            elMoreActionsBtn.AddClass('hidden');
            elSingleActionBtn.AddClass('hidden');
            _TrySetUpSingleActionPreviewBtn(elPanel, id);
            return;
        }
        const isFanToken = ItemInfo.ItemDefinitionNameSubstrMatch(id, 'tournament_pass_');
        const isStickerDisplaySleeve = InventoryAPI.DoesItemMatchDefinitionByName(id, 'sticker_display_case');
        const isSticker = ItemInfo.IsSticker(id);
        const isPatch = ItemInfo.IsPatch(id);
        const isKeychain = ItemInfo.IsKeychain(id);
        const isSpraySealed = ItemInfo.IsSpraySealed(id);
        const bCloseInspectOnSingleAction = (isSticker || isSpraySealed || isFanToken || isPatch || isKeychain || isStickerDisplaySleeve);
        let isEquipped = InventoryAPI.IsEquipped(id, 't') || InventoryAPI.IsEquipped(id, 'ct') || InventoryAPI.IsEquipped(id, "noteam");
        isEquipped ||= ItemInfo.IsPet(id);
        if (ItemInfo.IsEquippalbleButNotAWeapon(id) ||
            bCloseInspectOnSingleAction ||
            isEquipped) {
            elMoreActionsBtn.AddClass('hidden');
            if (!isEquipped) {
                elSingleActionBtn.RemoveClass('hidden');
                _SetUpSingleActionBtn(elPanel, id, bCloseInspectOnSingleAction, contextPanel);
            }
            return;
        }
        else {
            elMoreActionsBtn.RemoveClass('hidden');
            elSingleActionBtn.AddClass('hidden');
        }
    }
    function _SetUpSingleActionBtn(elPanel, id, closeInspect, contextPanel) {
        const validEntries = ItemContextEntries.FilterEntries(id, 'inspect');
        const elSingleActionBtn = elPanel.FindChildInLayoutFile('SingleAction');
        for (let i = 0; i < validEntries.length; i++) {
            const entry = validEntries[i];
            let displayName = '';
            if (entry.name instanceof Function) {
                displayName = entry.name(id);
            }
            else {
                displayName = entry.name;
            }
            elSingleActionBtn.text = '#inv_context_' + displayName;
            elSingleActionBtn.SetPanelEvent('onactivate', () => _OnSingleAction(entry, id, closeInspect, contextPanel));
            elSingleActionBtn.RemoveClass('hidden');
        }
    }
    function _TrySetUpSingleActionPreviewBtn(elPanel, id) {
        const validEntries = ItemContextEntries.FilterEntries(id, 'preview');
        const elSingleActionBtn = elPanel.FindChildInLayoutFile('SingleAction');
        for (let i = 0; i < validEntries.length; i++) {
            const entry = validEntries[i];
            let displayName = '';
            if (entry.name instanceof Function) {
                displayName = entry.name(id);
            }
            else {
                displayName = entry.name;
            }
            const previewActionPrefix = displayName.startsWith('preview_') ? '' : 'preview_';
            const contextPanel = $.GetContextPanel();
            elSingleActionBtn.text = '#inv_context_' + previewActionPrefix + displayName;
            elSingleActionBtn.SetPanelEvent('onactivate', () => {
                const bCloseInspect = (contextPanel.IsValid()) ? false : true;
                _OnSingleAction(entry, id, bCloseInspect, contextPanel);
                if (!bCloseInspect) {
                    $.DispatchEvent('BlurPopupPanel', contextPanel.id, true);
                }
            });
            elSingleActionBtn.RemoveClass('hidden');
        }
    }
    function _OnSingleAction(entry, id, closeInspect, contextPanel) {
        if (closeInspect) {
            CloseBtnAction(_GetSettingCallback(contextPanel), contextPanel);
        }
        entry.OnSelected(id);
    }
    function _SetupAddRemoveToCartButtons(elPanel, id, price) {
        const elAddToCartContainer = elPanel.FindChildInLayoutFile('AddToCartContainer');
        const elPrice = elPanel.FindChildInLayoutFile('MajorItemPrice');
        if (!price) {
            elAddToCartContainer.SetHasClass('hidden', true);
            return;
        }
        elPrice.visible = price > 0;
        elAddToCartContainer.SetHasClass('hidden', false);
        elPanel.SetDialogVariableInt('cart-count', ShoppingCart.cart.getItemQuantity(id));
        elPanel.SetDialogVariableInt('total-items', ShoppingCart.cart.getTotalItems());
        const shopItem = { id: id, name: ItemInfo.GetFormattedName(id), price: price };
        elAddToCartContainer.FindChildInLayoutFile('AddToCart').SetPanelEvent('onactivate', () => {
            ShoppingCart.cart.addItem(shopItem, 1);
            const quantity = ShoppingCart.cart.getItemQuantity(id);
            elPanel.SetDialogVariableInt('cart-count', quantity);
            _ShowHideCartBtn(elPanel, price);
            elPrice.visible = quantity > 0;
        });
        elAddToCartContainer.FindChildInLayoutFile('RemoveFromCart').SetPanelEvent('onactivate', () => {
            ShoppingCart.cart.decrementItem(id);
            const quantity = ShoppingCart.cart.getItemQuantity(id);
            elPanel.SetDialogVariableInt('cart-count', quantity);
            _ShowHideCartBtn(elPanel, price);
            elPrice.visible = price > 0;
        });
    }
    function _SetupCartActionsBtn(elPanel, price, id) {
        if (!price) {
            return;
        }
        const elOpenCartBtn = elPanel.FindChildInLayoutFile('InspectOpenCheckout');
        const cp = $.GetContextPanel();
        function _Callback() {
            CloseBtnAction(_GetSettingCallback(cp), elPanel);
        }
        ;
        const callback = UiToolkitAPI.RegisterJSCallback(_Callback);
        elOpenCartBtn.SetPanelEvent('onactivate', () => {
            if (InspectShared.GetPopupSetting('back_to_checkout', cp)) {
                CloseBtnAction(_GetSettingCallback(cp), elPanel);
                return;
            }
            const popupPanel = UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-shopping-cart-checkout', 'file://{resources}/layout/popups/popup_shopping_cart_checkout.xml', '&callback=' + callback);
            popupPanel.Data().eventId = g_ActiveTournamentInfo.eventid;
            popupPanel.Data().isFromInspect = true;
        });
        ShoppingCart.cart.subscribeToUpdates(elOpenCartBtn, 'inspect-sticker', () => {
            const quantityInCart = ShoppingCart.cart.getItemQuantity(id);
            elPanel.SetDialogVariableInt('cart-count', ShoppingCart.cart.getItemQuantity(id));
            elPanel.SetDialogVariableInt('total-items', ShoppingCart.cart.getTotalItems());
            elPanel.SetDialogVariableInt('price', quantityInCart == 0 ? price : ShoppingCart.cart.getItemLinePrice(id));
        });
    }
    function _ShowHideCartBtn(elPanel, price) {
        const elOpenCartBtn = elPanel.FindChildInLayoutFile('InspectOpenCheckout');
        if (!price) {
            elOpenCartBtn.SetHasClass('hidden', true);
            return;
        }
        if (ShoppingCart.cart.getTotalItems() < 1) {
            elOpenCartBtn.SetHasClass('hidden', true);
            return;
        }
        elOpenCartBtn.SetHasClass('hidden', false);
    }
    function _ShowHideFavoriteBtn(cp, elPanel, nPrice) {
        const elBtn = elPanel.FindChildInLayoutFile('id-sticker-bookmark');
        const defIndex = InspectShared.GetPopupSetting('sticker_def_index', cp);
        if (!nPrice || !defIndex) {
            elBtn.SetHasClass('hidden', true);
            return;
        }
        elBtn.checked = GameInterfaceAPI.GetSettingString('cl_major_store_watch_list').split(',').includes(defIndex.toString());
        elBtn.SetPanelEvent('onactivate', () => {
            const aDefIndexes = GameInterfaceAPI.GetSettingString('cl_major_store_watch_list').split(',');
            const idIndex = aDefIndexes.findIndex(id => id === defIndex.toString());
            if (idIndex === -1) {
                aDefIndexes.push(defIndex.toString());
            }
            else {
                aDefIndexes.splice(idIndex, 1);
            }
            GameInterfaceAPI.SetSettingString('cl_major_store_watch_list', aDefIndexes.length > 0 ? aDefIndexes.join(',') : "");
        });
        elBtn.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-sticker-bookmark', '#major_store_bookmark_tooltip');
        });
        elBtn.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        elBtn.SetHasClass('hidden', false);
    }
    function _OnActivateUpdateSelectionForMultiSelect(idSubjectItem, contextPanel) {
        CloseBtnAction(_GetSettingCallback(contextPanel), contextPanel);
        $.DispatchEvent('UpdateSelectItemForCapabilityPopup', InspectShared.GetPopupSetting('capability', contextPanel), idSubjectItem, !InspectShared.GetPopupSetting('is_selected', contextPanel));
    }
    function _ShowButtonsForWeaponInspect(elPanel, id) {
        const hasAnims = ItemInfo.IsCharacter(id) || ItemInfo.IsWeapon(id) || ItemInfo.IsMelee(id);
        if (InspectShared.GetPopupSetting('hide_char_select')) {
            return;
        }
        if (hasAnims &&
            !ItemInfo.IsEquippalbleButNotAWeapon(id) &&
            !ItemInfo.IsSticker(id) &&
            !ItemInfo.IsSpraySealed(id) &&
            !ItemInfo.ItemDefinitionNameSubstrMatch(id, "tournament_journal_") &&
            !ItemInfo.ItemDefinitionNameSubstrMatch(id, "tournament_pass_")) {
            elPanel.FindChildInLayoutFile('InspectCharBtn').SetHasClass('hidden', !hasAnims);
            elPanel.FindChildInLayoutFile('InspectWeaponBtn').SetHasClass('hidden', !hasAnims);
            elPanel.FindChildInLayoutFile('LookatWeaponBtn').SetHasClass('hidden', !(ItemInfo.IsWeapon(id) || ItemInfo.IsMelee(id)));
            const list = CharacterAnims.GetValidCharacterModels(true).filter((entry) => {
                return (ItemInfo.IsItemCt(id) && (entry.team === 'ct' || entry.team === 'any')) ||
                    (ItemInfo.IsItemT(id) && (entry.team === 't' || entry.team === 'any')) ||
                    ItemInfo.IsItemAnyTeam(id);
            });
            if (list && (list.length > 0) && !elPanel.FindChildInLayoutFile('InspectDropdownCharModels').Data().selectedId)
                _SetDropdown(elPanel, list, id);
        }
        elPanel.FindChildInLayoutFile('ChangeScenery').SetHasClass('hidden', ItemInfo.IsCharacter(id) || ItemInfo.IsPet(id));
    }
    function _ShowButtonsForCharacterInspect(elPanel, id) {
        const elPreviewPanel = InspectModelImage.GetModelPanel();
        if (!ItemInfo.IsCharacter(id))
            return;
        elPanel.FindChildInLayoutFile('id-character-button-container').SetHasClass('hidden', false);
        const inspectCameraPresets = {
            "AspectRatio4x3": [16, 17],
            "AspectRatio16x9": [26, 27],
            "AspectRatio21x9": [28, 29]
        };
        let arrCameraSetToUse = inspectCameraPresets.AspectRatio4x3;
        if ($.GetContextPanel().BAscendantHasClass("AspectRatio16x9") ||
            $.GetContextPanel().BAscendantHasClass("AspectRatio16x10")) {
            arrCameraSetToUse = inspectCameraPresets.AspectRatio16x9;
        }
        else if ($.GetContextPanel().BAscendantHasClass("AspectRatio21x9")) {
            arrCameraSetToUse = inspectCameraPresets.AspectRatio21x9;
        }
        const characterToolbarButtonSettings = {
            charItemId: id,
            cameraPresetUnzoomed: arrCameraSetToUse[0],
            cameraPresetZoomed: arrCameraSetToUse[1]
        };
        const elCharacterButtons = elPanel.FindChildInLayoutFile('id-character-buttons');
        CharacterButtons.InitCharacterButtons(elCharacterButtons, elPreviewPanel, characterToolbarButtonSettings);
    }
    function _SetDropdown(elPanel, validEntiresList, id) {
        const currentMainMenuVanitySettings = ItemInfo.GetOrUpdateVanityCharacterSettings(ItemInfo.IsItemAnyTeam(id) ? null
            : LoadoutAPI.GetItemID(ItemInfo.IsItemCt(id) ? 'ct' : 't', 'customplayer'));
        const elDropdown = elPanel.FindChildInLayoutFile('InspectDropdownCharModels');
        for (let entry of validEntiresList) {
            const rarityColor = InventoryAPI.GetItemRarityColor(entry.itemId);
            const newEntry = $.CreatePanel('Label', elDropdown, entry.itemId, {
                'class': 'DropDownMenu',
                'html': 'true',
                'text': "<font color='" + rarityColor + "'>•</font> " + entry.label,
                'data-team': (entry.team === 'any') ? ((ItemInfo.IsItemT(id) || ItemInfo.IsItemAnyTeam(id)) ? 't' : 'ct') : entry.team
            });
            elDropdown.AddOption(newEntry);
        }
        const itemId = InspectShared.GetPopupSetting('item_id');
        const contextPanel = $.GetContextPanel();
        elDropdown.SetPanelEvent('oninputsubmit', () => InspectActionBar.OnUpdateCharModel(elDropdown, itemId, contextPanel));
        elDropdown.SetSelected(currentMainMenuVanitySettings.charItemId);
    }
    function OnUpdateCharModel(elDropdown, weaponItemId, contextPanel) {
        const characterItemId = elDropdown.GetSelected().id;
        elDropdown.Data().selectedId = elDropdown.GetSelected().id;
        InspectModelImage.SetCharScene(characterItemId, weaponItemId, contextPanel);
    }
    InspectActionBar.OnUpdateCharModel = OnUpdateCharModel;
    function NavigateModelPanel(type, bEndWeaponLookat = true) {
        InspectModelImage.ShowHideItemPanel((type !== 'InspectModelChar'));
        InspectModelImage.ShowHideCharPanel((type === 'InspectModelChar'));
        $.GetContextPanel().FindChildTraverse('InspectCharModelsControls').SetHasClass('hidden', type !== 'InspectModelChar');
        if (bEndWeaponLookat) {
            InspectModelImage.EndWeaponLookat();
        }
        const elDesc = $.GetContextPanel().GetParent().FindChildInLayoutFile('InspectItemDesc');
        if (elDesc && elDesc.IsValid()) {
            elDesc.SetHasClass('hidden', false);
        }
    }
    InspectActionBar.NavigateModelPanel = NavigateModelPanel;
    function InspectPlayMusic(type, contentPanel) {
        const elActionBar = contentPanel.FindChildInLayoutFile('PopUpInspectActionBar');
        if (!elActionBar.Data().previewingMusic)
            return;
        const itemId = InspectShared.GetPopupSetting('item_id', contentPanel);
        if (type === 'mvp') {
            if (elActionBar.Data().schfnMusicMvpPreviewEnd)
                return;
            InventoryAPI.StopItemPreviewMusic();
            InventoryAPI.PlayItemPreviewMusic(itemId, 'MVPPreview');
            elActionBar.Data().schfnMusicMvpPreviewEnd = $.Schedule(6.8, () => InspectActionBar.InspectPlayMusic('schfn', contentPanel));
        }
        else if (type === 'schfn') {
            elActionBar.Data().schfnMusicMvpPreviewEnd = null;
            InventoryAPI.StopItemPreviewMusic();
            InventoryAPI.PlayItemPreviewMusic(itemId, '');
        }
    }
    InspectActionBar.InspectPlayMusic = InspectPlayMusic;
    function ShowContextMenu(contextPanel) {
        const elBtn = contextPanel.FindChildTraverse('InspectActionsButton');
        const id = InspectShared.GetPopupSetting('item_id', contextPanel);
        const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(elBtn.id, '', 'file://{resources}/layout/context_menus/context_menu_inventory_item.xml', 'itemid=' + id + '&populatefiltertext=inspect', () => $.DispatchEvent("CSGOPlaySoundEffect", "weapon_selectReplace", "MOUSE"));
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
    }
    InspectActionBar.ShowContextMenu = ShowContextMenu;
    function _SetCloseBtnAction(elPanel, contextPanel) {
        const elBtn = elPanel.FindChildInLayoutFile('InspectCloseBtn');
        elBtn.SetPanelEvent('onactivate', () => CloseBtnAction(_GetSettingCallback(contextPanel), elPanel));
    }
    function _GetSettingCallback(contextPanel) {
        let callbackFromPopup = InspectShared.GetPopupSetting('callback_handle', contextPanel);
        return !callbackFromPopup ? -1 : callbackFromPopup;
    }
    function UpdateScenery() {
        UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-inspect-contextmenu-maps', '', 'file://{resources}/layout/context_menus/context_menu_mainmenu_vanity.xml', 'type=maps' +
            '&' + 'inspect-map=true', () => $.DispatchEvent('ContextMenuEvent', ''));
    }
    InspectActionBar.UpdateScenery = UpdateScenery;
    function LookatWeapon() {
        const bEndWeaponLookat = false;
        NavigateModelPanel('InspectModel', bEndWeaponLookat);
        const elDesc = $.GetContextPanel().GetParent().FindChildInLayoutFile('InspectItemDesc');
        if (elDesc && elDesc.IsValid()) {
            elDesc.SetHasClass('hidden', true);
        }
        InspectModelImage.StartWeaponLookat();
    }
    InspectActionBar.LookatWeapon = LookatWeapon;
    function CloseBtnAction(callbackHandle = -1, elActionBar) {
        $.DispatchEvent("CSGOPlaySoundEffect", "inventory_inspect_close", "MOUSE");
        $.DispatchEvent('UIPopupButtonClicked', '');
        UiToolkitAPI.HideTextTooltip();
        if (callbackHandle != -1) {
            UiToolkitAPI.InvokeJSCallback(callbackHandle);
        }
        if (elActionBar.Data().previewingMusic) {
            InventoryAPI.StopItemPreviewMusic();
            elActionBar.Data().previewingMusic = false;
            if (elActionBar.Data().schfnMusicMvpPreviewEnd) {
                $.CancelScheduled(elActionBar.Data().schfnMusicMvpPreviewEnd);
                elActionBar.Data().schfnMusicMvpPreviewEnd = null;
            }
        }
    }
    InspectActionBar.CloseBtnAction = CloseBtnAction;
})(InspectActionBar || (InspectActionBar = {}));
