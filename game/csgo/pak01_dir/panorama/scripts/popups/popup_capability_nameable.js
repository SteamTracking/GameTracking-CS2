"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="popup_inspect_async-bar.ts" />
/// <reference path="popup_inspect_purchase-bar.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="popup_acknowledge_item.ts" />
/// <reference path="popup_inspect_shared.ts" />
var CapabilityNameable;
(function (CapabilityNameable) {
    function Init() {
        const itemId = InspectShared.GetPopupSetting('item_id');
        if (ItemInfo.IsWeapon(itemId) || ItemInfo.IsMelee(itemId)) {
            InspectShared.SetPopupSetting('temp_display_item_id', InventoryAPI.CreateTempCombinedItemWithTool(itemId, _GetNameTagFauxItemID()));
        }
        else {
            InspectShared.SetPopupSetting('temp_display_item_id', itemId);
        }
        const defName = InventoryAPI.GetItemDefinitionName(itemId);
        const contextPanel = $.GetContextPanel();
        contextPanel.SetHasClass('isstorageunit', (defName === 'casket'));
        _SetUpPanelElements(contextPanel);
        $.Schedule(1, () => { contextPanel.FindChildTraverse('NameableTextEntry').SetPanelEvent('ontextentrychange', _OnEntryChanged.bind(undefined, contextPanel)); });
        $.DispatchEvent('CapabilityPopupIsOpen', true);
    }
    CapabilityNameable.Init = Init;
    ;
    function _GetNameTagFauxItemID() {
        const nameTagStoreId = InventoryAPI.GetItemDefinitionIndexFromDefinitionName("Name Tag");
        const fakeItem = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(nameTagStoreId, 0);
        return fakeItem;
    }
    function _SetItemModel(id) {
        const elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectModelOrImage');
        InspectModelImage.Init(elItemModelImagePanel, id);
        elItemModelImagePanel.AddClass('popup-inspect-modelpanel_darken');
        const elNameTagModel = $.GetContextPanel().FindChildInLayoutFile('id-inspect-nametag-model');
        if (elNameTagModel && elNameTagModel.IsValid()) {
            elNameTagModel.TransitionToCamera('cam_nametag', 1.0);
            elNameTagModel.SetItemModel('weapons/models/shared/nametag/nametag_module.vmdl');
            elNameTagModel.SetItemLabel('');
        }
    }
    ;
    function _RefreshItemPresentationWithUpdatedName(bNameTagModelVisible, strTextForTempItem) {
        if (InspectShared.GetPopupSetting('temp_display_item_id') === InspectShared.GetPopupSetting('item_id'))
            return;
        const elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectModelOrImage');
        if (elItemModelImagePanel && elItemModelImagePanel.IsValid()) {
            const elItemPanel = elItemModelImagePanel.FindChildInLayoutFile('ItemPreviewPanel');
            if (elItemPanel && elItemPanel.IsValid()) {
                elItemPanel.RefreshWeaponItemNameTag(InspectShared.GetPopupSetting('temp_display_item_id'), strTextForTempItem);
            }
            if (elItemPanel && elItemPanel.PanZoomEnabled()) {
                if (bNameTagModelVisible) {
                    elItemPanel.ResetPanZoom();
                }
                else {
                    elItemPanel.SetFocus();
                }
            }
        }
        const elNameTagModel = $.GetContextPanel().FindChildInLayoutFile('id-inspect-nametag-model');
        if (elNameTagModel && elNameTagModel.IsValid()) {
            elNameTagModel.visible = bNameTagModelVisible;
        }
    }
    function _SetUpPanelElements(contextPanel) {
        const toolId = InspectShared.GetPopupSetting('tool_id');
        if (!toolId) {
            InspectShared.SetPopupSetting('show_work_type_warning', false);
        }
        const itemId = InspectShared.GetPopupSetting('item_id');
        InspectAsyncActionBar.Init();
        _ShowPurchase(toolId);
        CapabilityHeader.Init();
        _SetItemModel(InspectShared.GetPopupSetting('temp_display_item_id'));
        const noTool = (toolId === '');
        const hasName = InventoryAPI.HasCustomName(itemId);
        _SetUpButtonStates(itemId, hasName, noTool, contextPanel);
        _UpdateAcceptState(false, contextPanel);
    }
    ;
    function _ShowPurchase(toolId) {
        if (!toolId) {
            const fakeItem = _GetNameTagFauxItemID();
            InspectShared.SetPopupSetting('purchase_item_id', fakeItem);
        }
        InspectPurchaseBar.Init();
    }
    ;
    function _SetUpButtonStates(itemId, hasName, noTool, contextPanel) {
        const elAsyncActionBarPanel = contextPanel.FindChildInLayoutFile('PopUpInspectAsyncBar');
        const elTextEntry = contextPanel.FindChildInLayoutFile('NameableTextEntry');
        const elValidBtn = contextPanel.FindChildInLayoutFile('NameableValidBtn');
        const elRemoveBtn = contextPanel.FindChildInLayoutFile('NameableRemoveBtn');
        InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, false);
        elValidBtn.SetHasClass('hidden', noTool);
        elValidBtn.SetPanelEvent('onactivate', () => {
            $.DispatchEvent("CSGOPlaySoundEffect", "rename_select", "MOUSE");
            InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, true);
            elTextEntry.enabled = false;
            elRemoveBtn.SetHasClass('hidden', false);
            elValidBtn.SetHasClass('hidden', true);
            _UpdateAcceptState(true, contextPanel);
        });
        elRemoveBtn.SetPanelEvent('onactivate', _RemoveButtonAction.bind(undefined, contextPanel));
        const RemoveConfirm = contextPanel.FindChildInLayoutFile('NameableRemoveConfirm');
        RemoveConfirm.SetPanelEvent('onactivate', _OnRemoveConfirm.bind(undefined, itemId));
        const defName = InventoryAPI.GetItemDefinitionName(itemId);
        RemoveConfirm.SetHasClass('hidden', !hasName || defName === 'casket' || defName === 'pet');
        elTextEntry.SetFocus();
        elTextEntry.SetMaxChars(20);
        elTextEntry.text = _SetDefaultTextForTextEntry(hasName, itemId, contextPanel);
    }
    ;
    function _RemoveButtonAction(contextPanel) {
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        const elTextEntry = contextPanel.FindChildTraverse('NameableTextEntry');
        const elValidBtn = contextPanel.FindChildInLayoutFile('NameableValidBtn');
        const elRemoveBtn = contextPanel.FindChildInLayoutFile('NameableRemoveBtn');
        InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, false);
        elTextEntry.enabled = true;
        elTextEntry.SetFocus();
        elRemoveBtn.SetHasClass('hidden', true);
        elValidBtn.SetHasClass('hidden', false);
        elTextEntry.text = '';
        const itemId = InspectShared.GetPopupSetting('item_id', contextPanel);
        const strOriginalItemName = InventoryAPI.HasCustomName(itemId) ? InventoryAPI.GetItemNameCustomized(itemId) : '';
        if (InspectShared.GetPopupSetting('temp_display_item_id') !== InspectShared.GetPopupSetting('item_id')) {
            InventoryAPI.SetNameToolString(strOriginalItemName, '');
            _RefreshItemPresentationWithUpdatedName(true, strOriginalItemName);
        }
    }
    function _SetDefaultTextForTextEntry(hasName, itemId, contextPanel) {
        const elTextEntry = contextPanel.FindChildTraverse('NameableTextEntry');
        if (elTextEntry.text !== '') {
            return elTextEntry.text;
        }
        if (!hasName) {
            return '';
        }
        const nameWithQuotes = InventoryAPI.GetItemName(itemId);
        if (nameWithQuotes && nameWithQuotes.length > 4
            && nameWithQuotes[0] == "'" && nameWithQuotes[1] == "'"
            && nameWithQuotes[nameWithQuotes.length - 1] == "'" && nameWithQuotes[nameWithQuotes.length - 2] == "'") {
            return nameWithQuotes.substr(2, nameWithQuotes.length - 4);
        }
        else {
            return nameWithQuotes;
        }
    }
    ;
    function _OnRemoveConfirm(itemId) {
        const temp = UiToolkitAPI.ShowGenericPopupOkCancel($.Localize('#popup_nameable_remove_confirm_title'), $.Localize('#tooltip_nameable_remove'), '', () => {
            InventoryAPI.ClearCustomName(itemId);
            ClosePopup();
            $.DispatchEvent('HideSelectItemForCapabilityPopup');
        }, () => { });
    }
    ;
    function _OnEntryChanged(contextPanel) {
        const elNameTagModel = contextPanel.FindChildInLayoutFile('id-inspect-nametag-model');
        if (elNameTagModel && elNameTagModel.IsValid()) {
            const elTextEntry = contextPanel.FindChildTraverse('NameableTextEntry');
            elNameTagModel.SetItemLabel(elTextEntry.text);
            $.DispatchEvent("CSGOPlaySoundEffect", "rename_teletype", "MOUSE");
            _UpdateAcceptState(false, contextPanel);
        }
    }
    ;
    function _UpdateAcceptState(bApplyToItem, contextPanel) {
        if (InspectShared.GetPopupSetting('temp_display_item_id') === InspectShared.GetPopupSetting('item_id'))
            bApplyToItem = false;
        const elTextEntry = contextPanel.FindChildTraverse('NameableTextEntry');
        const elValidBtn = contextPanel.FindChildInLayoutFile('NameableValidBtn');
        const isValid = InventoryAPI.SetNameToolString(elTextEntry.text, '');
        elValidBtn.enabled = isValid;
        elValidBtn.SetPanelEvent('onmouseover', () => {
            if (!isValid)
                UiToolkitAPI.ShowTextTooltip('NameableValidBtn', '#tooltip_nameable_invalid');
        });
        elValidBtn.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        if (bApplyToItem) {
            _RefreshItemPresentationWithUpdatedName(false, elTextEntry.text);
        }
    }
    ;
    function _NameTagAcquired(nameTagId) {
        const tool_id = InspectShared.GetPopupSetting('tool_id');
        if (!tool_id) {
            if (ItemInfo.IsNameTag(nameTagId)) {
                InspectShared.SetPopupSetting('tool_id', nameTagId);
                $.DispatchEvent('HideStoreStatusPanel');
                InspectShared.SetPopupSetting('purchase_item_id', '');
                _SetUpPanelElements($.GetContextPanel());
                _AcknowlegeNameTags();
            }
        }
    }
    ;
    function _AcknowlegeNameTags() {
        const bShouldAcknowledge = true;
        AcknowledgeItems.GetItemsByType(['name tag'], bShouldAcknowledge);
    }
    ;
    function _UpdateInspectMap() {
        InspectModelImage.SwitchMap($.GetContextPanel());
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
    }
    CapabilityNameable.ClosePopup = ClosePopup;
    ;
    $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', _NameTagAcquired);
    $.RegisterForUnhandledEvent('CSGOShowMainMenu', Init);
    $.RegisterForUnhandledEvent('PopulateLoadingScreen', ClosePopup);
    $.RegisterForUnhandledEvent("CSGOInspectBackgroundMapChanged", _UpdateInspectMap);
})(CapabilityNameable || (CapabilityNameable = {}));
