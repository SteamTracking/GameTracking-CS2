"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="popup_acknowledge_item.ts" />
/// <reference path="popup_capability_decodable.ts" />
/// <reference path="popup_inspect_shared.ts" />
var InspectRentalBar;
(function (InspectRentalBar) {
    function Init() {
        const elRentalBar = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectRentalBar');
        const itemId = InspectShared.GetPopupSetting('item_id');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const worktype = InspectShared.GetPopupSetting('work_type');
        const contextPanel = $.GetContextPanel();
        contextPanel.Data().rentalBarPanelRegisteredForEvents = false;
        contextPanel.Data().onlyRentalItemIds = [];
        const allowRental = InspectShared.GetPopupSetting('allow_rent');
        const sRestriction = InspectShared.GetPopupSetting('store_item_id') ? '' : InventoryAPI.GetDecodeableRestriction(itemId);
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        let isXrayRestriction = sRestriction === 'xray';
        if (InspectShared.GetPopupSetting('inspect_only') ||
            worktype !== 'decodeable' ||
            !allowRental ||
            (InspectShared.GetPopupSetting('purchase_item_id') && !sRestriction) ||
            showXrayMachineUi ||
            !InventoryAPI.IsValidItemID(itemId)) {
            elRentalBar.AddClass('hidden');
            return;
        }
        elRentalBar.RemoveClass('hidden');
        elRentalBar.SetHasClass('show-xray-buttons', sRestriction !== '');
        _SetNumLootlistItems(elRentalBar, itemId);
        _SetuUpButtonsBasedOnRestrictions(sRestriction, elRentalBar);
        if (!isXrayRestriction && toolId) {
            elRentalBar.FindChildInLayoutFile('UseItemImage').itemid = toolId;
            _SetDescString(elRentalBar);
        }
        if (!contextPanel.Data().rentalBarPanelRegisteredForEvents) {
            contextPanel.Data().rentalBarPanelRegisteredForEvents = true;
            $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', () => _OnMyPersonaInventoryUpdated(contextPanel));
        }
    }
    InspectRentalBar.Init = Init;
    function _SetDescString(elRentalBar) {
        const elLabel = elRentalBar.FindChildInLayoutFile('UseItemName');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const worktype = InspectShared.GetPopupSetting('work_type');
        elLabel.SetDialogVariable('itemname', InventoryAPI.GetItemName(toolId));
        elLabel.text = $.Localize('#popup_' + worktype + '_async_desc', elLabel);
        elLabel.visible = true;
    }
    function _SetuUpButtonsBasedOnRestrictions(sRestriction, elRentalBar) {
        const contextPanel = $.GetContextPanel();
        const itemId = InspectShared.GetPopupSetting('item_id');
        const keyToSellId = InspectShared.GetPopupSetting('purchase_item_id');
        if (sRestriction) {
            const elPurchaseBtn = elRentalBar.FindChildInLayoutFile('PurchaseKeyBtn');
            const elXrayRentBtn = elRentalBar.FindChildInLayoutFile('RentBtnXray');
            if (keyToSellId) {
                elPurchaseBtn.SetHasClass('hide', false);
                elXrayRentBtn.SetHasClass('hide', true);
                elPurchaseBtn.FindChildInLayoutFile('SellItemImage').itemid = keyToSellId;
                elRentalBar.SetDialogVariable('itemname', InventoryAPI.GetItemName(keyToSellId));
                elRentalBar.SetDialogVariable("price", ItemInfo.GetStoreSalePrice(keyToSellId, 1));
                elPurchaseBtn.SetPanelEvent('onactivate', () => {
                    StoreAPI.StoreItemPurchase(keyToSellId);
                    contextPanel.Data().confirmPopUpOpen = true;
                });
                if (sRestriction === 'xray')
                    _HoverEvents(elPurchaseBtn, null, contextPanel);
            }
            else {
                elPurchaseBtn.SetHasClass('hide', true);
                elXrayRentBtn.SetHasClass('hide', false);
                elXrayRentBtn.SetPanelEvent('onactivate', () => {
                    _SetUpRentActionBtn('rent', contextPanel);
                });
                if (sRestriction === 'xray')
                    _HoverEvents(elXrayRentBtn, null, contextPanel);
            }
            let xrayBtn = elRentalBar.FindChildInLayoutFile('OpenXray');
            xrayBtn.SetHasClass('hide', sRestriction === 'restricted');
            if (sRestriction !== 'restricted') {
                xrayBtn.SetPanelEvent('onactivate', () => {
                    $.DispatchEvent("ShowXrayCasePopup", '', itemId, false);
                    ClosePopup(contextPanel);
                });
                _HoverEvents(null, xrayBtn, contextPanel);
            }
            if (sRestriction === 'restricted') {
                elRentalBar?.GetParent().GetParent().SetHasClass('rental-mode', true);
            }
        }
        else {
            let RentBtn = elRentalBar.FindChildInLayoutFile('RentBtn');
            let ActionBtn = elRentalBar.FindChildInLayoutFile('OpenBtn');
            _HoverEvents(RentBtn, ActionBtn, contextPanel);
            RentBtn.SetPanelEvent('onactivate', () => {
                _SetUpRentActionBtn('rent', contextPanel);
            });
            ActionBtn.SetPanelEvent('onactivate', () => {
                OpenConfirmPopup('open', itemId, contextPanel);
            });
        }
    }
    function _SetNumLootlistItems(elRentalBar, itemId) {
        let count = InventoryAPI.GetLootListItemsCount(itemId);
        count = InventoryAPI.GetLootListItemIdByIndex(itemId, (count - 1)) == '0' ? count - 1 : count;
        elRentalBar?.SetDialogVariableInt('numlootlist', count);
    }
    function _SetUpRentActionBtn(type, contextPanel) {
        let sTimeRemainingString = GetAlreadyRentedItemsExpirationTime(contextPanel);
        const itemId = InspectShared.GetPopupSetting('item_id', contextPanel);
        contextPanel.Data().confirmPopUpOpen = true;
        if (sTimeRemainingString) {
            contextPanel.SetDialogVariable('time-remaining', sTimeRemainingString);
            contextPanel.SetDialogVariable('name', InventoryAPI.GetItemName(itemId));
            contextPanel.SetDialogVariable('expiration-time', $.Localize(sTimeRemainingString));
            UiToolkitAPI.ShowGenericPopupOk('#popup_container_confirm_title_rent', $.Localize('#popup_container_confirm_already_rented', contextPanel), '', () => $.DispatchEvent('UIPopupButtonClicked', ''));
        }
        else {
            OpenConfirmPopup(type, itemId, contextPanel);
        }
    }
    function OpenConfirmPopup(type, itemId, contextPanel) {
        contextPanel.Data().rentalBarPopupActionCallbackHandle = UiToolkitAPI.RegisterJSCallback(() => _OnPopupActionPressed(type, contextPanel));
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_container_open_confirm.xml', 'action-type=' + type
            + '&' + 'case=' + itemId
            + '&' + 'callback=' + contextPanel.Data().rentalBarPopupActionCallbackHandle);
    }
    function _OnPopupActionPressed(actionType, contextPanel) {
        _OpenActions(contextPanel);
        contextPanel.Data().actionType = actionType;
        const toolId = InspectShared.GetPopupSetting('tool_id', contextPanel);
        const itemId = InspectShared.GetPopupSetting('item_id', contextPanel);
        if (actionType === 'open') {
            InventoryAPI.UseTool(toolId, itemId);
            $.DispatchEvent('StartDecodeableAnim');
            return;
        }
        InventoryAPI.UseToolWithIntArg(toolId, itemId, 5318008);
        $.DispatchEvent('StartRentalAnim');
        $.Schedule(2.75, () => ShowRentalInspect(contextPanel));
    }
    function _OpenActions(contextPanel) {
        if (contextPanel.Data().rentalBarPopupActionCallbackHandle) {
            UiToolkitAPI.UnregisterJSCallback(contextPanel.Data().rentalBarPopupActionCallbackHandle);
        }
        const elRentalBar = contextPanel.FindChildInLayoutFile('PopUpInspectRentalBar');
        elRentalBar.FindChildInLayoutFile('OpenBtn').SetHasClass('is-active-action', true);
        elRentalBar.FindChildInLayoutFile('OpenBtn').enabled = false;
        elRentalBar.FindChildInLayoutFile('RentBtn').enabled = false;
        _ResetTimeoutHandle(contextPanel);
        contextPanel.Data().rentalBarScheduleActionTimoutHandle = $.Schedule(6, () => _ShowActionTimeOutPopup(contextPanel));
    }
    function _HoverEvents(RentBtn, ActionBtn, contextPanel) {
        const elRentalBar = contextPanel.FindChildInLayoutFile('PopUpInspectRentalBar');
        if (RentBtn) {
            RentBtn.SetPanelEvent('onmouseover', () => {
                contextPanel.Data().confirmPopUpOpen = false;
                elRentalBar?.GetParent().GetParent().SetHasClass('rental-mode', true);
            });
            RentBtn.SetPanelEvent('onmouseout', () => {
                if (!contextPanel.Data().confirmPopUpOpen) {
                    elRentalBar?.GetParent().GetParent().SetHasClass('rental-mode', false);
                }
            });
        }
        if (ActionBtn) {
            ActionBtn.SetPanelEvent('onmouseover', () => {
                elRentalBar?.GetParent().GetParent().SetHasClass('rental-mode', false);
            });
        }
    }
    function GetAlreadyRentedItemsExpirationTime(contextPanel) {
        const itemId = InspectShared.GetPopupSetting('item_id', contextPanel);
        let defIndex = InventoryAPI.GetItemDefinitionIndex(itemId);
        const nRentalHistoryCount = InventoryAPI.GetCacheTypeElementsCount('RentalHistory');
        if (nRentalHistoryCount < 1) {
            return '';
        }
        let nExpirationDate = 0;
        for (let i = 0; i < nRentalHistoryCount; ++i) {
            const oRentalHistory = InventoryAPI.GetCacheTypeElementJSOByIndex('RentalHistory', i);
            if (oRentalHistory.crate_def_index === defIndex) {
                nExpirationDate = nExpirationDate < oRentalHistory.expiration_date ? oRentalHistory.expiration_date : nExpirationDate;
            }
        }
        let oLocData = FormatText.FormatRentalTime(nExpirationDate);
        return oLocData.time;
    }
    function _ShowActionTimeOutPopup(contextPanel) {
        contextPanel.Data().rentalBarScheduleActionTimoutHandle = null;
        const elRentalBar = contextPanel.FindChildInLayoutFile('PopUpInspectRentalBar');
        if (!elRentalBar || !elRentalBar?.IsValid()) {
            return;
        }
        ClosePopup(contextPanel);
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', () => { });
    }
    InspectRentalBar._ShowActionTimeOutPopup = _ShowActionTimeOutPopup;
    function _ResetTimeoutHandle(contextPanel) {
        if (contextPanel.Data().rentalBarScheduleActionTimoutHandle && typeof contextPanel.Data().rentalBarScheduleActionTimoutHandle === "number") {
            $.CancelScheduled(contextPanel.Data().rentalBarScheduleActionTimoutHandle);
            contextPanel.Data().rentalBarScheduleActionTimoutHandle = null;
        }
    }
    function ClosePopup(contextPanel) {
        _ResetTimeoutHandle(contextPanel);
        $.DispatchEvent('HideSelectItemForCapabilityPopup');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
    }
    InspectRentalBar.ClosePopup = ClosePopup;
    function _OnMyPersonaInventoryUpdated(contextPanel) {
        const worktype = InspectShared.GetPopupSetting('work_type');
        const actionType = $.GetContextPanel().Data().actionType;
        if (worktype === 'decodeable') {
            const newItems = AcknowledgeItems.GetItems();
            if (newItems.length > 0 && newItems.filter(entry => entry.pickuptype === 'found_in_crate').length > 0) {
                _ResetTimeoutHandle(contextPanel);
            }
            if (actionType === 'rent') {
                newItems.filter(entry => InventoryAPI.IsRental(entry.id)).forEach(entry => {
                    contextPanel.Data().onlyRentalItemIds.push(entry.id);
                    InventoryAPI.SetItemSessionPropertyValue(entry.id, 'recent', '1');
                    InventoryAPI.AcknowledgeNewItembyItemID(entry.id);
                });
            }
        }
    }
    function ShowRentalInspect(contextPanel) {
        if (contextPanel.Data().onlyRentalItemIds.length > 0) {
            const itemId = InspectShared.GetPopupSetting('item_id', contextPanel);
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
            let oSettings = {
                item_id: contextPanel.Data().onlyRentalItemIds[0],
                inspect_only: true,
                hide_all_action_items: true,
                rental_item_ids: contextPanel.Data().onlyRentalItemIds.join(','),
                case_id_for_lootlist: itemId,
            };
            elPanel.Data().oSettings = oSettings;
            ClosePopup(contextPanel);
            return;
        }
        else {
            _ShowActionTimeOutPopup(contextPanel);
        }
    }
})(InspectRentalBar || (InspectRentalBar = {}));
