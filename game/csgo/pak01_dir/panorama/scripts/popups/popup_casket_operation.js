"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
var PopupCasketOperations;
(function (PopupCasketOperations) {
    let m_strOperation = '';
    let m_CasketOperationTimeoutScheduledHandle = null;
    let m_strShowSelectItemForCapabilityPopupCapability = '';
    let m_numSubjectItems = 1;
    let m_itemidCasket = '';
    let m_itemidSubject = '';
    let m_arrSubjectItemsRemaining = [];
    function _BIsBatchMode() {
        if (m_strShowSelectItemForCapabilityPopupCapability && (m_strShowSelectItemForCapabilityPopupCapability === 'batch'))
            return true;
        else
            return false;
    }
    ;
    function SetupPopup() {
        m_strOperation = $.GetContextPanel().GetAttributeString("op", "");
        $.GetContextPanel().SetDialogVariable("title", $.Localize("#popup_casket_title_" + m_strOperation));
        m_itemidCasket = $.GetContextPanel().GetAttributeString("casket_item_id", "");
        m_strShowSelectItemForCapabilityPopupCapability = $.GetContextPanel().GetAttributeString("nextcapability", "");
        // Set the ItemID
        let itemidsList = $.GetContextPanel().GetAttributeString("subject_item_id", "");
        ConfigurePopupFromItemsList(itemidsList);
        // $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated );
        $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', OnItemCustomizationNotification);
    }
    PopupCasketOperations.SetupPopup = SetupPopup;
    ;
    function ConfigurePopupFromItemsList(itemidsList) {
        m_arrSubjectItemsRemaining = itemidsList.split(",");
        m_numSubjectItems = m_arrSubjectItemsRemaining.length;
        $.GetContextPanel().SetDialogVariableInt("count", m_numSubjectItems);
        $('#ItemsRemaining').visible = (m_numSubjectItems > 1);
        $('#PopupButtonRow').visible = _BIsBatchMode() && (m_numSubjectItems > 1);
        let itemid = m_arrSubjectItemsRemaining.splice(0, 1)[0];
        m_itemidSubject = itemid;
        if (!InventoryAPI.GetItemRarityColor(m_itemidSubject)) {
            $.Msg('Bad ItemID encountered ' + m_itemidSubject);
            PanelTimedOut();
            return;
        }
        let elItem = $("#CasketItemPanel");
        elItem.SetAttributeString('itemid', itemid);
        elItem.BLoadLayoutSnippet("LootListItem");
        // Set the item data on the panel
        elItem.FindChildInLayoutFile('ItemImage').itemid = itemid;
        elItem.FindChildInLayoutFile('JsRarity').style.backgroundColor = InventoryAPI.GetItemRarityColor(itemid);
        ItemInfo.GetFormattedName(itemid).SetOnLabel(elItem.FindChildInLayoutFile('JsItemName'));
        // Set spinner visibility
        let spinnerVisible = $.GetContextPanel().GetAttributeInt("spinner", 0) !== 0 ? true : false;
        $("#Spinner").SetHasClass("SpinnerVisible", spinnerVisible);
        m_CasketOperationTimeoutScheduledHandle = $.Schedule(10, PanelTimedOut);
        let schOperation = 0.75;
        if (m_strOperation === 'loadcontents') {
            schOperation = 0.5;
        }
        else if ((m_strOperation === 'add') && m_strShowSelectItemForCapabilityPopupCapability) {
            schOperation = 0.25;
        }
        else if (_BIsBatchMode()) {
            schOperation = 0.2;
        }
        //DEVONLY{
        let cvvalue = parseFloat(GameInterfaceAPI.GetSettingString('dev_caskettxn_latency'));
        if (cvvalue) // allow shortening the spinners for development iteration
         {
            cvvalue = cvvalue;
            if (cvvalue > 0)
                schOperation = cvvalue;
        }
        //}DEVONLY
        $.Schedule(schOperation, LaunchOperation);
    }
    ;
    var PanelTimedOut = function () {
        // We did not hearback from the inventory updated
        m_CasketOperationTimeoutScheduledHandle = null;
        $.DispatchEvent('UIPopupButtonClicked', '');
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', function () {
        });
    };
    var _CancelCasketOperationTimeoutScheduledHandle = function () {
        if (m_CasketOperationTimeoutScheduledHandle) {
            $.CancelScheduled(m_CasketOperationTimeoutScheduledHandle);
            m_CasketOperationTimeoutScheduledHandle = null;
        }
    };
    var _ClosePopUp = function () {
        $.DispatchEvent('UIPopupButtonClicked', '');
    };
    var _TeardownPreviousInventoryCapabilitiesPopup = function () {
        $.DispatchEvent('ContextMenuEvent', '');
        $.DispatchEvent('HideSelectItemForCapabilityPopup');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
    };
    function OnRequestCancelBatch() {
        $.Msg('OnRequestCancelBatch while had ' + (m_arrSubjectItemsRemaining ? m_arrSubjectItemsRemaining.length : 0) + ' items remaining');
        m_arrSubjectItemsRemaining = [];
    }
    PopupCasketOperations.OnRequestCancelBatch = OnRequestCancelBatch;
    function OnItemCustomizationNotification(numericType, type, itemid) {
        _CancelCasketOperationTimeoutScheduledHandle();
        //
        // Batch mode processing
        //
        switch (type) {
            case 'casket_added':
            case 'casket_removed':
                if (_BIsBatchMode()) {
                    if (m_arrSubjectItemsRemaining.length > 0) { // still working on this batch
                        var strItemIDs = m_arrSubjectItemsRemaining.join(",");
                        ConfigurePopupFromItemsList(strItemIDs);
                    }
                    else { // finished with the entire batch
                        _ClosePopUp();
                    }
                    return;
                }
        }
        //
        // Single item processing
        //
        _ClosePopUp();
        switch (type) {
            case 'casket_too_full':
            case 'casket_inv_full':
                UiToolkitAPI.ShowGenericPopupOk($.Localize('#popup_casket_title_error_' + type), $.Localize('#popup_casket_message_error_' + type), '', function () {
                });
                break;
            case 'casket_added':
                // Expected notification
                if (m_strShowSelectItemForCapabilityPopupCapability) { // open the next stage if requested
                    _TeardownPreviousInventoryCapabilitiesPopup();
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', itemid, '', m_strShowSelectItemForCapabilityPopupCapability);
                }
                else { // need to prompt the user if they want to move more items?
                    $.DispatchEvent("PromptShowSelectItemForCapabilityPopup", '#popup_casket_title_prompt_bulkstore', '#popup_casket_message_prompt_bulkstore', 'casketstore', itemid, '');
                }
                break;
            case 'casket_removed':
                // Expected notification, argument is the casket container that was used for extraction
                _TeardownPreviousInventoryCapabilitiesPopup();
                if (InventoryAPI.GetItemAttributeValue(itemid, 'items count')) {
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', itemid, '', m_strShowSelectItemForCapabilityPopupCapability);
                }
                break;
            case 'casket_contents':
                // Contents loaded, display it
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', itemid, '', m_strShowSelectItemForCapabilityPopupCapability);
                break;
            default:
                // Unexpected
                $.Msg("Unexpected OnItemCustomizationNotification when waiting for casket operation: " + type);
                break;
        }
    }
    ;
    function LaunchOperation() {
        $.Msg("Casket operation (" + m_strOperation + "): casket = " + m_itemidCasket + " subject = " + m_itemidSubject);
        var nOpRequestNumber = 0;
        switch (m_strOperation) {
            case "add":
                nOpRequestNumber = 1;
                break;
            case "remove":
                nOpRequestNumber = -1;
                break;
        }
        InventoryAPI.PerformItemCasketTransaction(nOpRequestNumber, m_itemidCasket, m_itemidSubject);
    }
})(PopupCasketOperations || (PopupCasketOperations = {}));
