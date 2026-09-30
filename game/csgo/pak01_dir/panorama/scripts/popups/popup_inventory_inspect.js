"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="../notification/notification_equip.ts" />
/// <reference path="popup_inspect_action-bar.ts" />
/// <reference path="popup_inspect_async-bar.ts" />
/// <reference path="popup_inspect_header.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="popup_inspect_purchase-bar.ts" />
/// <reference path="popup_inspect_shared.ts" />
var InventoryInspect;
(function (InventoryInspect) {
    let _m_PanelRegisteredForEvents;
    function Init() {
        const itemId = InspectShared.GetPopupSetting('item_id');
        $.GetContextPanel().SetAttributeString('popup-id', $.GetContextPanel().id);
        // Set required attributes
        // if ( ItemInfo.IsFauxOrRentalOrPreviewTool( itemId ) ) // << store items use this screen with various purchase options
        if (InventoryAPI.IsRental(itemId)) {
            InspectShared.SetPopupSetting('hide_all_action_items', true);
            InspectShared.SetPopupSetting('inspect_only', true);
        }
        // These below objects will check the attributes of the context panel
        // and show and hide themselves.
        // Each panel will check for it's relevent attributes to set it self up.
        // This panel is used for single item actions, like inspect, delete, purchase of a non lootlist item.
        if (!_m_PanelRegisteredForEvents) {
            _m_PanelRegisteredForEvents = $.RegisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', _ShowNotification);
            $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', _ItemAcquired);
            $.RegisterForUnhandledEvent("CSGOInspectBackgroundMapChanged", _UpdateInspectMap);
        }
        _SetupLootlistNavPanels(itemId);
        _UpdatePanelData(itemId);
        _PlayShowPanelSound(itemId);
        _LoadEquipNotification();
    }
    InventoryInspect.Init = Init;
    function _UpdatePanelData(itemId) {
        // when updating the panel from lootlist inspect or other places update the item id
        InspectShared.SetPopupSetting('item_id', itemId);
        const elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectModelOrImage');
        InspectModelImage.Init(elItemModelImagePanel, itemId);
        InspectActionBar.Init();
        InspectAsyncActionBar.Init();
        InspectHeader.Init();
        CapabilityHeader.Init();
        InspectPurchaseBar.Init();
        _SetDescription(itemId);
        // Always do the "Pet look at" when inspecting a pet from the inventory
        if (ItemInfo.IsPet(itemId)) {
            InspectModelImage.StartPetLookAt();
        }
        //DEVONLY{
        // Allow overriding the keychain seed interactively
        if (ItemInfo.IsKeychain(itemId)
            && GameInterfaceAPI.GetSettingString('keychain_seed_override')
            && (parseInt(GameInterfaceAPI.GetSettingString('keychain_seed_override')) >= 0)) {
            const elSlider = $.GetContextPanel().FindChildInLayoutFile('InspectItemSlider');
            if (elSlider) {
                elSlider.min = 0;
                elSlider.max = 100000;
                elSlider.default = 50000;
                elSlider.SetValueNoEvents(parseInt(GameInterfaceAPI.GetSettingString('keychain_seed_override')));
                elSlider.RemoveClass('hidden');
                elSlider.SetPanelEvent('onvaluechanged', () => GameInterfaceAPI.SetSettingString('keychain_seed_override', '' + Math.floor(elSlider.value)));
            }
        }
        if (ItemInfo.IsSticker(itemId)
            && GameInterfaceAPI.GetSettingString('sticker_wear_amount_override')
            && (parseInt(GameInterfaceAPI.GetSettingString('sticker_wear_amount_override')) >= 0)) {
            const elSlider = $.GetContextPanel().FindChildInLayoutFile('InspectItemSlider');
            if (elSlider) {
                elSlider.min = 0;
                elSlider.max = 100000;
                elSlider.default = 50000;
                elSlider.SetValueNoEvents(parseInt(GameInterfaceAPI.GetSettingString('sticker_wear_amount_override')));
                elSlider.RemoveClass('hidden');
                elSlider.SetPanelEvent('onvaluechanged', () => GameInterfaceAPI.SetSettingString('sticker_wear_amount_override', '' + Math.floor(elSlider.value)));
            }
        }
        //}DEVONLY
    }
    function _PlayShowPanelSound(itemId) {
        const category = InventoryAPI.GetLoadoutCategory(itemId);
        const slot = InventoryAPI.GetDefaultSlot(itemId);
        //Calculate and play the correct sound effect for inspecting this item.
        let inspectSound = "";
        if (category == "heavy" || category == "rifle" || category == "smg" || category == "secondary") {
            //gun inspect sound
            inspectSound = "inventory_inspect_weapon";
        }
        else if (category == "melee") {
            //knife inspect sound
            inspectSound = "inventory_inspect_knife";
        }
        else if (ItemInfo.IsSticker(itemId)) {
            //sticker sound
            inspectSound = "inventory_inspect_sticker";
        }
        else if (category == "spray") {
            //graffiti sound
            inspectSound = "inventory_inspect_graffiti";
        }
        else if (category == "musickit") {
            //music kit sound
            inspectSound = "inventory_inspect_musicKit";
        }
        else if (category == "flair0") {
            //coin sound
            inspectSound = "inventory_inspect_coin";
        }
        else if (category == "clothing" && slot == "clothing_hands") {
            //gloves sound
            inspectSound = "inventory_inspect_gloves";
        }
        else {
            //generic sound
            inspectSound = "inventory_inspect_sticker";
        }
        $.DispatchEvent("CSGOPlaySoundEffect", inspectSound, "MOUSE");
    }
    function _SetDescription(id) {
        $.GetContextPanel().SetDialogVariable('item_description', '');
        if (!InventoryAPI.IsValidItemID(id)) {
            return;
        }
        const descText = InventoryAPI.GetItemDescription(id, '');
        // removes the collection list for the item
        const shortString = descText.substring(0, descText.indexOf("</font></b><br><font color='#9da1a9'>"));
        $.GetContextPanel().SetDialogVariable('item_description', shortString === '' ? descText : shortString);
    }
    //--------------------------------------------------------------------------------------------------
    function _LoadEquipNotification() {
        const elParent = $.GetContextPanel();
        const elNotification = $.CreatePanel('Panel', elParent, 'InspectNotificationEquip');
        elNotification.BLoadLayout('file://{resources}/layout/notification/notification_equip.xml', false, false);
    }
    function _ShowNotification(team, slot, oldItemId, newItemId, bNew) {
        if (!bNew)
            return;
        const elNotification = $.GetContextPanel().FindChildInLayoutFile('InspectNotificationEquip');
        if (elNotification && elNotification.IsValid()) {
            EquipNotification.ShowEquipNotification(elNotification, slot, newItemId);
        }
    }
    function _UpdateInspectMap() {
        InspectModelImage.SwitchMap($.GetContextPanel());
    }
    let m_lootlistItemIndex = 0;
    function _SetupLootlistNavPanels(itemId) {
        m_lootlistItemIndex = 0;
        let aLootlistIds = _GetLootlistItems();
        if (aLootlistIds.length < 1) {
            const rentalItemIds = InspectShared.GetPopupSetting('rental_item_ids');
            if (!rentalItemIds) {
                $.GetContextPanel().FindChildInLayoutFile('id-lootlist-btns-container').visible = false;
                $.GetContextPanel().FindChildInLayoutFile('id-lootlist-title-container').visible = false;
                return;
            }
            aLootlistIds = rentalItemIds.split(',');
        }
        InspectShared.SetPopupSetting('is_item_in_lootlist', true);
        $.GetContextPanel().FindChildInLayoutFile('id-lootlist-btns-container').visible = true;
        $.GetContextPanel().FindChildInLayoutFile('id-lootlist-title-container').visible = true;
        m_lootlistItemIndex = aLootlistIds.indexOf(itemId);
        const btnNext = $.GetContextPanel().FindChildInLayoutFile('id-lootlist-next');
        const btnPrev = $.GetContextPanel().FindChildInLayoutFile('id-lootlist-prev');
        const count = aLootlistIds.length;
        _EnableNextPrevBtns(aLootlistIds);
        _UpdateLootlistTitleBar(count);
        btnNext.SetPanelEvent('onactivate', () => {
            m_lootlistItemIndex = (m_lootlistItemIndex < (count - 1)) ? m_lootlistItemIndex + 1 : m_lootlistItemIndex;
            _EnableNextPrevBtns(aLootlistIds);
            _UpdatePanelData(aLootlistIds[m_lootlistItemIndex]);
            _UpdateCharacterModelPanel(aLootlistIds[m_lootlistItemIndex]);
        });
        btnPrev.SetPanelEvent('onactivate', () => {
            m_lootlistItemIndex = m_lootlistItemIndex > 0 ? m_lootlistItemIndex - 1 : m_lootlistItemIndex;
            _EnableNextPrevBtns(aLootlistIds);
            _UpdatePanelData(aLootlistIds[m_lootlistItemIndex]);
            _UpdateCharacterModelPanel(aLootlistIds[m_lootlistItemIndex]);
        });
    }
    function _UpdateCharacterModelPanel(itemId) {
        if (!(ItemInfo.IsWeapon(itemId) || ItemInfo.IsMelee(itemId))) {
            return;
        }
        const elCp = $.GetContextPanel();
        const elActionBarPanel = elCp.FindChildInLayoutFile('PopUpInspectActionBar');
        InspectActionBar.OnUpdateCharModel(elActionBarPanel.FindChildInLayoutFile('InspectDropdownCharModels'), itemId, elCp);
    }
    function _EnableNextPrevBtns(aLootlistIds) {
        const btnNext = $.GetContextPanel().FindChildInLayoutFile('id-lootlist-next');
        const btnPrev = $.GetContextPanel().FindChildInLayoutFile('id-lootlist-prev');
        btnNext.enabled = (m_lootlistItemIndex < aLootlistIds.length - 1) && (aLootlistIds[m_lootlistItemIndex + 1] !== '0');
        btnPrev.enabled = m_lootlistItemIndex > 0;
        _SetBtnLabel(btnNext, btnPrev, aLootlistIds);
        _UpdateLootlistTitleBar(aLootlistIds.length);
    }
    function _SetBtnLabel(btnNext, btnPrev, aLootlistIds) {
        if (btnNext.enabled) {
            const elNextLabel = btnNext.FindChildInLayoutFile('id-lootlist-label');
            elNextLabel.text = InventoryAPI.GetItemName(aLootlistIds[m_lootlistItemIndex + 1]);
            const rarityColor = InventoryAPI.GetItemRarityColor(aLootlistIds[m_lootlistItemIndex + 1]);
            if (rarityColor) {
                btnNext.FindChildInLayoutFile('id-lootlist-rarity').style.washColor = rarityColor;
            }
        }
        if (btnPrev.enabled) {
            const elPrevLabel = btnPrev.FindChildInLayoutFile('id-lootlist-label');
            elPrevLabel.text = InventoryAPI.GetItemName(aLootlistIds[m_lootlistItemIndex - 1]);
            const rarityColor = InventoryAPI.GetItemRarityColor(aLootlistIds[m_lootlistItemIndex - 1]);
            if (rarityColor) {
                btnPrev.FindChildInLayoutFile('id-lootlist-rarity').style.washColor = rarityColor;
            }
        }
    }
    function _GetLootlistItems() {
        m_lootlistItemIndex = 0;
        const aLootlistIds = [];
        const caseId = InspectShared.GetPopupSetting('case_id_for_lootlist');
        if (!caseId) {
            return aLootlistIds;
        }
        const count = InventoryAPI.GetLootListItemsCount(caseId);
        for (let i = 0; i < count; i++) {
            aLootlistIds.push(InventoryAPI.GetLootListItemIdByIndex(caseId, i));
        }
        return aLootlistIds;
    }
    function _UpdateLootlistTitleBar(count) {
        const elPanel = $.GetContextPanel().FindChildInLayoutFile('id-lootlist-title-container');
        const lootlistOverride = InspectShared.GetPopupSetting('lootlist_name_override');
        let caseName;
        if (lootlistOverride !== 'false' && lootlistOverride !== '') {
            caseName = $.Localize(lootlistOverride, $.GetContextPanel());
        }
        else {
            const caseId = InspectShared.GetPopupSetting('case_id_for_lootlist');
            caseName = InventoryAPI.GetItemName(caseId);
        }
        elPanel.SetDialogVariable('container', caseName);
        elPanel.SetDialogVariableInt('index', m_lootlistItemIndex + 1);
        elPanel.SetDialogVariableInt('total', count);
        const rentalItemIds = InspectShared.GetPopupSetting('rental_item_ids');
        const text = !rentalItemIds ? $.Localize('#popup_inv_lootlist_header', elPanel) : $.Localize('#popup_inv_lootlist_rental_header', elPanel);
        elPanel.SetDialogVariable('lootlist-header', text);
    }
    function _ItemAcquired(ItemId) {
        $.Msg('popup_inventory_inspect.ts -- PanoramaComponent_Store_PurchaseCompleted ' + ItemId);
        const storeItemId = InspectShared.GetPopupSetting('store_item_id');
        if (storeItemId) {
            const storeItemSeasonAccess = InventoryAPI.GetItemAttributeValue(storeItemId, 'season access');
            const acquiredItemSeasonAccess = InventoryAPI.GetItemAttributeValue(ItemId, 'season access');
            if (acquiredItemSeasonAccess && (storeItemSeasonAccess === acquiredItemSeasonAccess)) {
                const nSeasonAccess = GameTypesAPI.GetActiveSeasionIndexValue();
                const nCoinRank = MyPersonaAPI.GetMyMedalRankByType((nSeasonAccess + 1) + "Operation$OperationCoin");
                // Player has an inactive pass and pass is the same as active season
                if (nCoinRank === 1 && nSeasonAccess === acquiredItemSeasonAccess) {
                    ShowActiveItemPopup(ItemId);
                    return;
                }
            }
            const storeItemToolType = InventoryAPI.GetToolType(storeItemId);
            const acquiredItemToolType = InventoryAPI.GetToolType(ItemId);
            if (storeItemToolType === 'xp_shop_ticket' && acquiredItemToolType === 'xp_shop_ticket') {
                // let oXpShopTrackProgress =  InventoryAPI.GetCacheTypeElementJSOByIndex( 'XpShop', 0 );
                // if( !oXpShopTrackProgress )
                // {
                // 	ShowActiveItemPopup( ItemId );
                // 	return;
                // }
                // else if( oXpShopTrackProgress.xp_tracks.length < StoreAPI.GetXpShopMaxTracks() ) // max tracks 5
                // {
                // //show activation
                // 	ShowActiveItemPopup( ItemId );
                // 	return;
                // }
                InventoryAPI.AcknowledgeNewItembyItemID(ItemId);
                ClosePopup();
                $.DispatchEvent('HideStoreStatusPanel');
            }
            const defName = InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_charge, 0));
            if (InventoryAPI.DoesItemMatchDefinitionByName(storeItemId, defName) && InventoryAPI.DoesItemMatchDefinitionByName(ItemId, defName)) {
                ClosePopup();
                $.DispatchEvent('ShowAcknowledgePopup', '', '');
                $.DispatchEvent('HideStoreStatusPanel');
                return;
            }
            ClosePopup();
            $.DispatchEvent('ShowAcknowledgePopup', '', ItemId);
            $.DispatchEvent('HideStoreStatusPanel');
        }
    }
    function ShowActiveItemPopup(itemId) {
        InventoryAPI.AcknowledgeNewItembyItemID(itemId);
        ClosePopup();
        $.DispatchEvent('HideStoreStatusPanel');
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'itemid=' + itemId +
            '&' + 'asyncworktype=useitem' +
            '&' + 'seasonpass=true');
        const oSettings = {
            item_id: itemId,
            work_type: 'useitem',
            is_season_pass: true
        };
        elPanel.Data().oSettings = oSettings;
    }
    function ClosePopup() {
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        const elPurchase = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
        if (!elAsyncActionBarPanel.BHasClass('hidden')) {
            InspectAsyncActionBar.OnEventToClose();
        }
        else if (!elPurchase.BHasClass('hidden')) {
            InspectPurchaseBar.ClosePopup();
        }
        else {
            if ($.GetContextPanel().IsValid()) {
                let callbackFromPopup = InspectShared.GetPopupSetting('callback_handle');
                callbackFromPopup = !callbackFromPopup ? -1 : callbackFromPopup;
                InspectActionBar.CloseBtnAction(callbackFromPopup, elAsyncActionBarPanel);
            }
        }
    }
    InventoryInspect.ClosePopup = ClosePopup;
    function _Refresh() {
        const itemId = InspectShared.GetPopupSetting('item_id');
        if (!itemId || !InventoryAPI.IsValidItemID(itemId)) {
            ClosePopup();
            return;
        }
        _UpdatePanelData(itemId);
        InspectActionBar.NavigateModelPanel('InspectModel');
    }
    function _BlurPanel(panelId, shouldBlur) {
        if (shouldBlur) {
            if (panelId == $.GetContextPanel().id) {
                $.GetContextPanel().SetHasClass('popup-inspect-modelpanel_darken_blur', shouldBlur);
            }
        }
        else {
            if ($.GetContextPanel().BHasClass('popup-inspect-modelpanel_darken_blur')) {
                $.GetContextPanel().SetHasClass('popup-inspect-modelpanel_darken_blur', false);
            }
        }
    }
    $.RegisterForUnhandledEvent('CSGOShowMainMenu', _Refresh);
    $.RegisterForUnhandledEvent('PopulateLoadingScreen', ClosePopup);
    $.RegisterForUnhandledEvent('BlurPopupPanel', _BlurPanel);
})(InventoryInspect || (InventoryInspect = {}));
