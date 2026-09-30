"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="popup_inspect_purchase-bar.ts" />
/// <reference path="popup_capability_can_keychain.ts" />
/// <reference path="popup_capability_can_patch.ts" />
/// <reference path="popup_can_apply_pick_slot.ts" />
/// <reference path="popup_can_apply_header.ts" />
/// <reference path="popup_acknowledge_item.ts" />
/// <reference path="popup_inspect_shared.ts" />
var CapabilityCanApplyAction;
(function (CapabilityCanApplyAction) {
    const m_szRemoveKeychainToolChargesForPurchase = 'Remove Keychain Tool Pack'; // this is what user must buy to refill charges
    function Init() {
        InspectShared.SetPopupSetting('is_apply_remove_item', true);
        const itemId = InspectShared.GetPopupSetting('item_id');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const worktype = InspectShared.GetPopupSetting('work_type');
        const isRemove = _IsRemove(worktype);
        if (isRemove) {
            if (!itemId) {
                //Add error dialog here
                ClosePopUp();
                return;
            }
        }
        else {
            // if we are applying a keychain, then duplicate off the item into a temp item
            // and then force-apply the keychain in code for the simulation to be easy
            if (worktype === 'can_keychain' || worktype === 'can_sticker') {
                const tempCreatedItem = InventoryAPI.CreateTempCombinedItemWithTool(itemId, toolId);
                $.Msg(`CreateTempCombinedItemWithTool( ${itemId}, ${toolId} ) --> ${tempCreatedItem}`);
                if (!tempCreatedItem) {
                    ClosePopUp();
                    return;
                }
                InspectShared.SetPopupSetting('temp_display_item_id', tempCreatedItem);
            }
            if ((worktype === 'can_wrap_sticker') && toolId) {
                const tempCreatedItem = InventoryAPI.CreateTempCombinedItemWithTool(itemId, toolId);
                $.Msg(`CreateTempCombinedItemWithTool( ${itemId}, ${toolId} ) --> ${tempCreatedItem}`);
                if (!tempCreatedItem) {
                    ClosePopUp();
                    return;
                }
                InspectShared.SetPopupSetting('temp_display_item_id', tempCreatedItem);
            }
            if (worktype === 'craft_souvenir') {
                const craftSouvenirFauxTool = 'craft_souvenir:' + InspectShared.GetPopupSetting('umid_souvenir');
                const tempCreatedItem = InventoryAPI.CreateTempCombinedItemWithTool(itemId, craftSouvenirFauxTool);
                $.Msg(`CreateTempCombinedItemWithTool( ${itemId}, ${craftSouvenirFauxTool} ) --> ${tempCreatedItem}`);
                if (!tempCreatedItem) {
                    ClosePopUp();
                    return;
                }
                // Find how many credits our player currently owns?
                let nRedeemableBalance = 0;
                {
                    const idxLookup = InventoryAPI.GetCacheTypeElementIndexByKey('SeasonalOperations', g_ActiveTournamentInfo.credits_id);
                    if (g_ActiveTournamentInfo.credits_id == InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'season_value')) {
                        // This could come back "undefined" or "null" and should be treated as zero
                        nRedeemableBalance = InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'redeemable_balance');
                        nRedeemableBalance = (nRedeemableBalance === null || nRedeemableBalance === undefined) ? 0 : nRedeemableBalance;
                    }
                }
                InspectShared.SetPopupSetting('temp_display_item_id', tempCreatedItem);
                InspectShared.SetPopupSetting('credits_owned_souvenir', nRedeemableBalance);
            }
        }
        let oSettings = {
            headerPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyHeader'),
            infoPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyPickSlot'),
            asyncBarPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar'),
            contextPanel: $.GetContextPanel(),
            itemId: InspectShared.GetPopupSetting('temp_display_item_id') ? InspectShared.GetPopupSetting('temp_display_item_id') : itemId,
            toolId: toolId,
            isRemove: (worktype === 'can_wrap_sticker') ? true
                : isRemove,
            type: (worktype === 'can_wrap_sticker') ? 'keychain'
                : (worktype.indexOf('sticker') !== -1) ? 'sticker'
                    : (worktype.indexOf('patch') !== -1) ? 'patch'
                        : (worktype.indexOf('keychain') !== -1) ? 'keychain'
                            : '',
            funcOnConfirm: _OnConfirmPressed,
            funcOnNext: _OnNextPressed,
            funcOnCancel: _OnCancelPressed,
            funcOnSelectForRemove: _OnSelectForRemove
        };
        CanApplyHeader.Init(oSettings);
        CanApplySlotInfo.ResetSlotIndex();
        CapabilityCanPatch.ResetPos();
        CapabilityCanKeychain.ResetPos();
        CanApplySlotInfo.UpdateEmptySlotList(itemId);
        CanApplyPickSlot.Init(oSettings);
        $.GetContextPanel().Data().oApplySettings = oSettings;
        _SetItemModel(toolId, itemId, isRemove);
        _SetUpAsyncActionBar(toolId);
        _UpdateEnableDisableOkBtn(false, oSettings);
        if (oSettings.isRemove && ((oSettings.type === 'keychain')
            || (oSettings.type === 'sticker' && !!InspectShared.GetPopupSetting('remove_sticker_all_at_once')))) {
            _OnConfirmPressed(oSettings);
        }
        // Stickers scraping doesn't close the popup but updates the model.  So we register this event so we know when to update the model.
        if (worktype === "remove_sticker") {
            $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', CapabilityCanSticker.OnFinishedScratch);
        }
        $.DispatchEvent('CapabilityPopupIsOpen', true);
        // If the user is trying to remove charms, have zero charges, but own charm charges, then instead go to
        // the interface for them to use their charm charges first
        if (worktype === 'remove_keychain') {
            const numKeychainRemoveToolChargesRemaining = InventoryAPI.GetCacheTypeElementFieldByIndex('KeychainRemoveToolCharges', 0, 'charges');
            if (numKeychainRemoveToolChargesRemaining > 0) {
                $.Msg(`Remove Keychain Popup: ${numKeychainRemoveToolChargesRemaining} charges owned`);
            }
            else {
                let ownedKeychainRemoveChargesID = '';
                const bAutoAcknowledge = true;
                const unackItems = AcknowledgeItems.GetItemsByType([m_szRemoveKeychainToolChargesForPurchase], bAutoAcknowledge);
                if (unackItems && unackItems.length > 0) {
                    ownedKeychainRemoveChargesID = unackItems[0];
                }
                if (!ownedKeychainRemoveChargesID) {
                    InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'item_definition:' + m_szRemoveKeychainToolChargesForPurchase, '', '');
                    const countOfChargeItemsOwned = InventoryAPI.GetInventoryCount();
                    if (countOfChargeItemsOwned > 0) {
                        ownedKeychainRemoveChargesID = InventoryAPI.GetInventoryItemIDByIndex(0);
                    }
                }
                if (ownedKeychainRemoveChargesID) {
                    $.Msg(`User has no keychain remove charges, but has an item to activate: ${ownedKeychainRemoveChargesID} -- offering useitem for it`);
                    ClosePopUp();
                    // Offer the user to immediately use their newly purchased charges
                    // we must do it via event so that it was properly queued up after the
                    // event forcing all popups to close
                    const elPanel = $.DispatchEvent("ShowCustomLayoutPopupParametersAsEvent", '', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'item_id=' + ownedKeychainRemoveChargesID +
                        ',' + 'work_type=useitem');
                }
                else {
                    $.Msg(`User has no keychain remove charges, will see purchase bar to buy: ${m_szRemoveKeychainToolChargesForPurchase}`);
                }
            }
        }
    }
    CapabilityCanApplyAction.Init = Init;
    //--------------------------------------------------------------------------------------------------
    function _IsRemove(worktype) {
        return (worktype === "remove_sticker" || worktype === "remove_patch" || worktype === "remove_keychain");
    }
    function _OnConfirmPressed(oSettings) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'generic_button_press', 'MOUSE');
        _SetSelectedSlot(CanApplySlotInfo.GetSelectedEmptySlot(), oSettings);
        _UpdateEnableDisableOkBtn(true, oSettings);
        InspectAsyncActionBar.EnableDisableChangeSceneryBtn(false, oSettings.contextPanel.FindChildInLayoutFile('PopUpInspectAsyncBar'));
    }
    function _OnNextPressed(itemToApplyId, activeSlot, oSettings) {
        const worktype = InspectShared.GetPopupSetting('work_type', oSettings.contextPanel);
        _UpdateEnableDisableOkBtn(false, oSettings);
        if (worktype === 'can_sticker' || worktype === 'can_keychain') {
            CapabilityCanSticker.NextStickerButtonPressed(oSettings.contextPanel);
        }
        else if (worktype === 'can_patch') {
            CapabilityCanPatch.PreviewPatchOnChar(itemToApplyId, activeSlot, oSettings.contextPanel);
        }
    }
    function _OnCancelPressed(oSettings) {
        _UpdateEnableDisableOkBtn(false, oSettings);
        InspectAsyncActionBar.EnableDisableChangeSceneryBtn(true, oSettings.contextPanel.FindChildInLayoutFile('PopUpInspectAsyncBar'));
    }
    function _StickerPlacementUpdated() {
        const elParent = $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyPickSlot');
        const elCancelBtn = elParent.FindChildInLayoutFile('CanApplyCancel');
        if (elCancelBtn.visible)
            $.DispatchEvent("Activated", elParent.FindChildInLayoutFile('CanApplyCancel'), "mouse");
    }
    function _OnSelectForRemove(slotIndex, oSettings) {
        const worktype = InspectShared.GetPopupSetting('work_type', oSettings.contextPanel);
        if (worktype === 'remove_sticker') {
            _SetSelectedSlot(slotIndex, oSettings);
            CanApplyPickSlot.UpdateSelectedRemoveForSticker(slotIndex, oSettings);
            _UpdateEnableDisableOkBtn(true, oSettings);
        }
        else if (worktype === 'remove_patch') {
            _SetSelectedSlot(slotIndex, oSettings);
            _UpdateEnableDisableOkBtn(true, oSettings);
            CapabilityCanPatch.CameraAnim(slotIndex, oSettings.contextPanel);
        }
    }
    function _UpdateEnableDisableOkBtn(bEnable, oSettings) {
        const elAsyncActionBarPanel = oSettings.contextPanel.FindChildInLayoutFile('PopUpInspectAsyncBar');
        InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, bEnable);
        return;
    }
    function _SetSelectedSlot(slotIndex, oSettings) {
        oSettings.asyncBarPanel.SetAttributeString('selectedItemToApplySlot', slotIndex.toString());
    }
    //--------------------------------------------------------------------------------------------------
    function _UpdateInspectMap() {
        InspectModelImage.SwitchMap($.GetContextPanel());
        const worktype = InspectShared.GetPopupSetting('work_type');
        if (worktype === 'can_patch') {
            CapabilityCanPatch.ResetPos();
        }
        InspectAsyncActionBar.ZoomCamera(true, $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar'));
        _UpdateItemToApplyPreview(InspectShared.GetPopupSetting('tool_id'), $.GetContextPanel());
    }
    function _SetItemModel(toolId, itemId, m_isRemove) {
        if (!InventoryAPI.IsItemInfoValid(itemId))
            return;
        const elPreviewPanel = $.GetContextPanel().FindChildInLayoutFile('CanApplyItemModel');
        const worktype = InspectShared.GetPopupSetting('work_type');
        const displayItemId = InspectShared.GetPopupSetting('temp_display_item_id');
        InspectModelImage.Init(elPreviewPanel, displayItemId ? displayItemId : itemId);
        elPreviewPanel.Data().id = itemId;
        if (m_isRemove) {
            if (worktype === 'remove_patch') {
                $.Schedule(.3, () => CanApplyPickSlot.SelectFirstRemoveItem());
            }
        }
        else {
            _UpdateItemToApplyPreview(toolId, $.GetContextPanel());
        }
    }
    function _UpdateItemToApplyPreview(toolId, contextPanel) {
        const worktype = InspectShared.GetPopupSetting('work_type');
        if (worktype === 'can_sticker') {
            CapabilityCanSticker.PreviewStickerInSlot(toolId, CanApplySlotInfo.GetSelectedEmptySlot());
        }
        if (worktype === 'can_patch') {
            $.Schedule(.3, () => CapabilityCanPatch.PreviewPatchOnChar(toolId, CanApplySlotInfo.GetSelectedEmptySlot(), contextPanel));
        }
    }
    function _SetUpAsyncActionBar(toolId) {
        //$.GetContextPanel().SetAttributeString( 'toolid', toolId );
        const worktype = InspectShared.GetPopupSetting('work_type');
        const itemId = InspectShared.GetPopupSetting('item_id');
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        InspectAsyncActionBar.Init();
        //
        // If an action requires a purchased tool, then upsell it:
        //
        const elPurchase = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
        let bConfigurePurchaseBar = false;
        let mustPurchaseItemID = '';
        if (worktype === 'can_wrap_sticker' && InventoryAPI.IsFauxItemID(itemId)) {
            // We are showing a preview of "encapsulation", but the user actually must purchase
            // a new Sticker Slab to encapsulate the sticker, so the action bar will be the "purchase bar"
            bConfigurePurchaseBar = true;
            mustPurchaseItemID = itemId;
        }
        if (worktype === 'remove_keychain' || worktype === 'can_keychain') {
            bConfigurePurchaseBar = true;
            if (worktype === 'remove_keychain') { // only offer purchasing keychain remove charges if the user doesn't have any charges currently
                const numKeychainRemoveToolChargesRemaining = InventoryAPI.GetCacheTypeElementFieldByIndex('KeychainRemoveToolCharges', 0, 'charges');
                // numKeychainRemoveToolChargesRemaining = 0; // to test purchase of charm detachments
                const defidxForPurchase = (numKeychainRemoveToolChargesRemaining > 0) ? 0 : InventoryAPI.GetItemDefinitionIndexFromDefinitionName(m_szRemoveKeychainToolChargesForPurchase);
                if (defidxForPurchase) {
                    mustPurchaseItemID = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxForPurchase, 0);
                }
            }
        }
        if (elPurchase && bConfigurePurchaseBar) {
            if (mustPurchaseItemID) {
                InspectShared.SetPopupSetting('purchase_item_id', mustPurchaseItemID);
                $.GetContextPanel().SetAttributeString('toolid', ''); // force showing "This action requires ..." upsell purchase string
            }
            InspectPurchaseBar.Init();
            if (mustPurchaseItemID) {
                $.GetContextPanel().SetAttributeString('toolid', toolId);
                elAsyncActionBarPanel.AddClass('hidden');
            }
        }
    }
    function _OnStorePurchaseCompleted(ItemId) {
        if (InventoryAPI.DoesItemMatchDefinitionByName(ItemId, m_szRemoveKeychainToolChargesForPurchase)) {
            $.Msg('_OnStorePurchaseCompleted (remove keychain charges): ' + ItemId);
            $.DispatchEvent('HideStoreStatusPanel');
            const bAutoAcknowledge = true;
            AcknowledgeItems.GetItemsByType([m_szRemoveKeychainToolChargesForPurchase], bAutoAcknowledge);
            ClosePopUp();
            // Offer the user to immediately use their newly purchased charges
            // we must do it via event so that it was properly queued up after the
            // event forcing all popups to close
            $.DispatchEvent("ShowCustomLayoutPopupParametersAsEvent", '', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'item_id=' + ItemId +
                ',' + 'work_type=useitem');
        }
        const worktype = InspectShared.GetPopupSetting('work_type');
        const itemId = InspectShared.GetPopupSetting('item_id');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        if (worktype === 'can_wrap_sticker' &&
            InventoryAPI.IsFauxItemID(itemId) &&
            InventoryAPI.DoesItemMatchDefinitionByName(ItemId, "sticker_display_case")) {
            $.Msg('_OnStorePurchaseCompleted (sticker slab): ' + ItemId);
            $.DispatchEvent('HideStoreStatusPanel');
            const bAutoAcknowledge = true;
            AcknowledgeItems.GetItemsByType(["sticker_display_case"], bAutoAcknowledge);
            ClosePopUp();
            // Offer the user to immediately use their newly purchased sticker slab
            // we must do it via event so that it was properly queued up after the
            // event forcing all popups to close
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + ItemId, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
            let oSettings = {
                popup_panel: elPanel,
                tool_id: toolId,
                item_id: ItemId,
                work_type: 'can_wrap_sticker'
            };
            elPanel.Data().oSettings = oSettings;
        }
    }
    ;
    //--------------------------------------------------------------------------------------------------
    function ClosePopUp() {
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        const elPurchase = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
        if (!elAsyncActionBarPanel.BHasClass('hidden')) {
            InspectAsyncActionBar.OnEventToClose();
        }
        else if (elPurchase && elPurchase.IsValid() && !elPurchase.BHasClass('hidden')) {
            InspectPurchaseBar.ClosePopup();
        }
    }
    CapabilityCanApplyAction.ClosePopUp = ClosePopUp;
    function StickerScrapeClickedStickerIndex(stickerIndex) {
        _OnSelectForRemove(stickerIndex, $.GetContextPanel().Data().oApplySettings);
    }
    // Entry point called when panel is created
    {
        // Got a new item from a case
        let _m_PanelRegisteredForEventsStickerApply;
        if (!_m_PanelRegisteredForEventsStickerApply) {
            _m_PanelRegisteredForEventsStickerApply = $.RegisterForUnhandledEvent('CSGOShowMainMenu', Init);
            $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', _OnStorePurchaseCompleted);
            $.RegisterForUnhandledEvent("CSGOInspectBackgroundMapChanged", _UpdateInspectMap);
            $.RegisterForUnhandledEvent("CS2StickerPreviewMoved", _StickerPlacementUpdated);
            $.RegisterForUnhandledEvent("CS2StickerScrapeClickedStickerIndex", StickerScrapeClickedStickerIndex);
            $.RegisterForUnhandledEvent('PopulateLoadingScreen', ClosePopUp);
        }
    }
})(CapabilityCanApplyAction || (CapabilityCanApplyAction = {}));
//--------------------------------------------------------------------------------------------------
// Sticker specific funtions
//--------------------------------------------------------------------------------------------------
var CapabilityCanSticker;
(function (CapabilityCanSticker) {
    let m_isFinalScratch = false;
    let m_firstCameraAnim = false;
    function NextStickerButtonPressed(contextPanel) {
        const m_elPreviewPanel = contextPanel.FindChildInLayoutFile('CanApplyItemModel');
        const elPanel = m_elPreviewPanel.FindChildTraverse('ItemPreviewPanel') || null;
        if (elPanel != null) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_nextPosition', 'MOUSE');
            InventoryAPI.OnNextStickerButtonPressed(elPanel);
        }
    }
    CapabilityCanSticker.NextStickerButtonPressed = NextStickerButtonPressed;
    function SetStickerScrapeLevel(valScrapeLevel, contextPanel) {
        const m_elPreviewPanel = contextPanel.FindChildInLayoutFile('CanApplyItemModel');
        const elPanel = m_elPreviewPanel.FindChildTraverse('ItemPreviewPanel') || null;
        if (elPanel != null) {
            InventoryAPI.SetStickerScrapeLevel(elPanel, valScrapeLevel);
        }
    }
    CapabilityCanSticker.SetStickerScrapeLevel = SetStickerScrapeLevel;
    function PreviewStickerInSlot(stickerId, slot) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_nextPosition', 'MOUSE');
        const m_elPreviewPanel = $.GetContextPanel().FindChildInLayoutFile('CanApplyItemModel');
        const elPanel = m_elPreviewPanel.FindChildTraverse('ItemPreviewPanel') || null;
        InventoryAPI.PreviewStickerInModelPanel(stickerId, slot, elPanel);
    }
    CapabilityCanSticker.PreviewStickerInSlot = PreviewStickerInSlot;
    function CameraAnim(slot) {
        const m_elPreviewPanel = $.GetContextPanel().FindChildInLayoutFile('CanApplyItemModel');
        const elPanel = m_elPreviewPanel.FindChildTraverse('ItemPreviewPanel') || null;
        if (!m_firstCameraAnim) {
            // no need to reset the position of the gun its the first time and already in default position.
            // intro anim logic will play from inspect.ts
            m_firstCameraAnim = true;
            return;
        }
        InspectModelImage.SetItemCameraByWeaponType(m_elPreviewPanel.Data().id, elPanel, true);
        elPanel.SetRotation(0, 0, 1);
    }
    CapabilityCanSticker.CameraAnim = CameraAnim;
    function OnScratchSticker(itemId, slotIndex, bRemoveCompletely, popup_panel) {
        if (bRemoveCompletely || InventoryAPI.IsItemStickerAtExtremeWear(itemId, slotIndex)) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.StickerScratch', 'MOUSE');
            m_isFinalScratch = true;
            InspectAsyncActionBar.ResetTimeouthandle();
            InventoryAPI.WearItemSticker(itemId, slotIndex, 111); // remove the sticker
            InspectAsyncActionBar.SetCallbackTimeout();
        }
        else {
            let valTargetWear = 0;
            const elStickerScrapeLevelContainer = popup_panel.FindChildInLayoutFile('PopUpCanApplyPickSlot').FindChildInLayoutFile('StickerScrapeLevelContainer');
            if (elStickerScrapeLevelContainer) {
                const elStickerScrapeLevelSlider = elStickerScrapeLevelContainer.FindChildInLayoutFile('StickerScrapeLevelSlider');
                if (elStickerScrapeLevelSlider) {
                    valTargetWear = elStickerScrapeLevelSlider.value;
                    if (valTargetWear <= elStickerScrapeLevelSlider.default) {
                        $.Msg(`InventoryAPI.WearItemSticker( ${itemId}, ${slotIndex}, ${valTargetWear} ) ignored because wear is already at ${elStickerScrapeLevelSlider.default}`);
                        InspectAsyncActionBar.ResetTimeouthandle();
                        const elAsyncActionBarPanel = popup_panel.FindChildInLayoutFile('PopUpInspectAsyncBar');
                        InspectAsyncActionBar.OnCloseRemove(elAsyncActionBarPanel);
                        return; // this button is "disabled" and performs no scraping
                    }
                }
            }
            $.Msg(`InventoryAPI.WearItemSticker( ${itemId}, ${slotIndex}, ${valTargetWear} )`);
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.StickerScratch', 'MOUSE');
            HighlightStickerBySlot(slotIndex);
            InventoryAPI.WearItemSticker(itemId, slotIndex, valTargetWear);
        }
    }
    CapabilityCanSticker.OnScratchSticker = OnScratchSticker;
    function HighlightStickerBySlot(slotIndex) {
        InventoryAPI.HighlightStickerBySlot(slotIndex);
    }
    CapabilityCanSticker.HighlightStickerBySlot = HighlightStickerBySlot;
    function OnFinishedScratch() {
        // Last scratch so the panel is going to close from the 'PanoramaComponent_Inventory_ItemCustomizationNotification' event
        // in the Asyncbar.
        if (m_isFinalScratch || !$.GetContextPanel()) {
            return;
        }
        const m_elPreviewPanel = $.GetContextPanel().FindChildInLayoutFile('CanApplyItemModel');
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        InspectAsyncActionBar.ResetTimeouthandle();
        InspectAsyncActionBar.OnCloseRemove(elAsyncActionBarPanel);
        InspectModelImage.UpdateModelOnly(m_elPreviewPanel.Data().id);
        const elStickersToRemove = $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyPickSlot').FindChildInLayoutFile('CanStickerItemIcons');
        if (elStickersToRemove && InspectShared.GetPopupSetting('work_type') === "remove_patch") {
            const panelsList = elStickersToRemove.Children();
            panelsList.forEach(element => element.enabled = true);
        }
        if (elStickersToRemove && InspectShared.GetPopupSetting('work_type') === "remove_sticker") {
            const panelsList = elStickersToRemove.Children();
            panelsList.forEach(element => { if (element.checked) {
                $.DispatchEvent("Activated", element, "mouse");
            } });
        }
    }
    CapabilityCanSticker.OnFinishedScratch = OnFinishedScratch;
})(CapabilityCanSticker || (CapabilityCanSticker = {}));
