"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="popup_inspect_shared.ts" />
var CapabilityHeader;
(function (CapabilityHeader) {
    function Init() {
        let elCapabilityHeaderPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpCapabilityHeader');
        const itemId = InspectShared.GetPopupSetting('item_id');
        const worktype = InspectShared.GetPopupSetting('work_type');
        const storeItemid = InspectShared.GetPopupSetting('store_item_id');
        if (!worktype && !storeItemid)
            return;
        let itemType = '';
        if (itemId != undefined && itemId != null && itemId !== '') {
            let itemDefName = InventoryAPI.GetItemDefinitionName(itemId);
            if (worktype === 'decodeable') {
                if (itemDefName && itemDefName.indexOf("spray") != -1)
                    itemType = "_graffiti";
                else if (itemDefName && itemDefName.indexOf("tournament_pass_") != -1)
                    itemType = "_fantoken";
                else if (InventoryAPI.GetItemAttributeValue(itemId, '{uint32}volatile container'))
                    itemType = "_terminal";
            }
            else if (worktype === 'useitem') {
                if (itemDefName && itemDefName.startsWith('Remove Keychain Tool'))
                    itemType = "_getkeychaincharges";
            }
        }
        elCapabilityHeaderPanel.RemoveClass('hidden');
        _SetDialogVariables(elCapabilityHeaderPanel, itemId);
        _SetUpHeaders(elCapabilityHeaderPanel, itemType);
    }
    CapabilityHeader.Init = Init;
    function _SetDialogVariables(elPanel, itemId) {
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        let displayItemId = '';
        if (showXrayMachineUi && InventoryAPI.IsFauxItemID($.GetContextPanel().Data().existingRewardFromXrayId)) {
            displayItemId = $.GetContextPanel().Data().existingRewardFromXrayId;
        }
        else {
            displayItemId = itemId;
        }
        elPanel.SetDialogVariable("itemname", InventoryAPI.GetItemNameUncustomized(displayItemId));
    }
    function _SetUpHeaders(elPanel, itemType) {
        _SetUpTitle(elPanel, itemType);
        _SetUpWarning(elPanel, itemType);
        _SetUpDesc(elPanel, itemType);
    }
    function _SetUpTitle(elPanel, itemType) {
        let elTitle = elPanel.FindChildInLayoutFile('CapabilityTitle');
        const itemId = InspectShared.GetPopupSetting('item_id');
        const inspectOnly = InspectShared.GetPopupSetting('inspect_only');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        const allowXrayPurchase = InspectShared.GetPopupSetting('allow_xray_purchase');
        const allowXrayClaim = InspectShared.GetPopupSetting('allow_xray_claim');
        const worktype = _GetWorkType();
        if (inspectOnly && worktype === 'decodeable') {
            elTitle.text = '#popup_cartpreview_title';
        }
        else if (showXrayMachineUi) {
            if (allowXrayPurchase || allowXrayClaim) {
                elTitle.text = "#popup_xray_claim_title";
            }
            else {
                elTitle.text = "#popup_xray_title";
            }
        }
        else if (worktype === 'decodeable' && InventoryAPI.GetDecodeableRestriction(itemId) === 'xray') {
            elTitle.text = '#popup_' + worktype + '_xray_title';
        }
        else if (!toolId && worktype === 'decodeable') {
            elTitle.text = '#popup_totool_' + worktype + '_header' + itemType;
        }
        else {
            let defName = InventoryAPI.GetItemDefinitionName(itemId);
            if (defName === 'casket' && worktype === 'nameable')
                elTitle.text = '#popup_newcasket_title';
            else
                elTitle.text = '#popup_' + worktype + '_title' + itemType;
        }
    }
    function _SetUpWarning(elPanel, itemType) {
        let elWarn = elPanel.FindChildInLayoutFile('CapabilityWarning');
        const storeItemId = InspectShared.GetPopupSetting('store_item_id');
        const itemId = InspectShared.GetPopupSetting('item_id');
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        const allowRental = InspectShared.GetPopupSetting('allow_rent');
        const worktype = _GetWorkType();
        let sWarnLocString = '';
        if (InspectShared.GetPopupSetting('show_work_type_warning') === false ? false : true) {
            sWarnLocString = '#popup_' + worktype + '_warning' + itemType;
        }
        if (worktype === 'decodeable') {
            let sRestriction = storeItemId ? '' : InventoryAPI.GetDecodeableRestriction(itemId);
            if ((sRestriction === 'restricted' && !allowRental) || (sRestriction === 'xray' && showXrayMachineUi)) {
                sWarnLocString = '#popup_' + worktype + '_err_' + sRestriction;
                elWarn.AddClass('popup-capability__error');
            }
        }
        const warningText = InspectShared.GetPopupSetting('async_work_type_warning_text');
        if (warningText) {
            sWarnLocString = warningText;
        }
        elWarn.SetHasClass('hidden', sWarnLocString ? false : true);
        if (sWarnLocString) {
            let elWarnLabel = elWarn.FindChildInLayoutFile('CapabilityWarningLabel');
            elWarnLabel.text = sWarnLocString;
        }
    }
    function _SetUpDesc(elPanel, itemType) {
        let sDescString = '';
        const itemId = InspectShared.GetPopupSetting('item_id');
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        const allowXrayPurchase = InspectShared.GetPopupSetting('allow_xray_purchase');
        const allowXrayClaim = InspectShared.GetPopupSetting('allow_xray_claim');
        const inspectOnly = InspectShared.GetPopupSetting('inspect_only');
        const worktype = _GetWorkType();
        if (worktype === 'decodeable' && inspectOnly) {
            sDescString = "#popup_preview_desc";
        }
        else if (showXrayMachineUi) {
            if (allowXrayClaim || allowXrayPurchase) {
                sDescString = "#popup_xray_claim_desc";
            }
            else {
                sDescString = '#popup_xray_desc';
            }
        }
        else if ((worktype === 'decodeable') && (InventoryAPI.GetDecodeableRestriction(itemId) === 'xray')) {
            sDescString = '#popup_' + worktype + '_xray_desc';
        }
        else {
            sDescString = '#popup_' + worktype + '_desc' + itemType;
        }
        elPanel.FindChildInLayoutFile('CapabilityDesc').text = sDescString;
    }
    function _GetWorkType() {
        let worktype = InspectShared.GetPopupSetting('work_type');
        const storeItemId = InspectShared.GetPopupSetting('store_item_id');
        return storeItemId ? 'purchase' : worktype;
    }
})(CapabilityHeader || (CapabilityHeader = {}));
