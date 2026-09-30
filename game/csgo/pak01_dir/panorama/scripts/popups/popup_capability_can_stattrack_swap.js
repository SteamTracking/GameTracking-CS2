"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="popup_inspect_shared.ts" />
var CapabilityCanStatTrackSwap;
(function (CapabilityCanStatTrackSwap) {
    function Init() {
        const itemids = [
            InspectShared.GetPopupSetting('item_id'),
            InspectShared.GetPopupSetting('stattrak_swap_second_item_id')
        ];
        const contextPanel = $.GetContextPanel();
        contextPanel.Data().statNumbersOriginal = [0, 0];
        contextPanel.Data().distanceLerped = 9999999;
        contextPanel.Data().flLerpProgress = 0.0;
        contextPanel.Data().scheduleHandle = null;
        itemids.forEach((item, idx) => {
            contextPanel.Data().statNumbersOriginal[idx] = parseInt(String(InventoryAPI.GetItemAttributeValue(item, "kill eater")));
            _SetItemModel(itemids[idx], idx);
        });
        _SetUpButtonStates();
        $.DispatchEvent('CapabilityPopupIsOpen', true);
        contextPanel.Data().scheduleHandle = $.Schedule(0.01, () => _LerpTimer(contextPanel));
    }
    CapabilityCanStatTrackSwap.Init = Init;
    function _SetItemModel(itemId, idx) {
        let elPanel = $.GetContextPanel().FindChildInLayoutFile('StatTrackSwapItemModel' + idx);
        InspectModelImage.Init(elPanel, itemId);
        elPanel.AddClass('darken');
        elPanel.RemoveClass('full-width');
        elPanel.RemoveClass('full-height');
    }
    function _SetUpButtonStates() {
        const contextPanel = $.GetContextPanel();
        contextPanel.FindChildInLayoutFile('StatTrackSwapAcceptConfirm').SetPanelEvent('onactivate', () => _OnAccept(contextPanel));
        contextPanel.FindChildInLayoutFile('StatTrackSwapCancelBtn').SetPanelEvent('onactivate', ClosePopup);
    }
    function _LerpTimer(contextPanel) {
        contextPanel.Data().scheduleHandle = null;
        let originalLen = contextPanel.Data().statNumbersOriginal[1] - contextPanel.Data().statNumbersOriginal[0];
        let newDistanceLerped = (contextPanel.Data().flLerpProgress < 1.0) ? Math.round(contextPanel.Data().flLerpProgress * originalLen) : originalLen;
        if (newDistanceLerped != contextPanel.Data().distanceLerped) {
            contextPanel.Data().distanceLerped = newDistanceLerped;
            $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'popup_accept_match_waitquiet', 'MOUSE', 1.0);
            let elSwapNumber0 = contextPanel.FindChildInLayoutFile('StatTrackSwapNumber0');
            let elSwapNumber1 = contextPanel.FindChildInLayoutFile('StatTrackSwapNumber1');
            elSwapNumber0.text = (contextPanel.Data().statNumbersOriginal[0] + contextPanel.Data().distanceLerped).toString().padStart(6, "0");
            elSwapNumber1.text = (contextPanel.Data().statNumbersOriginal[1] - contextPanel.Data().distanceLerped).toString().padStart(6, "0");
        }
        if (contextPanel.Data().flLerpProgress < 1.0) {
            contextPanel.Data().flLerpProgress += 0.01;
            contextPanel.Data().scheduleHandle = $.Schedule(0.04, () => _LerpTimer(contextPanel));
        }
        else {
        }
    }
    function _OnAccept(contextPanel) {
        if (contextPanel.Data().scheduleHandle) {
            $.CancelScheduled(contextPanel.Data().scheduleHandle);
            contextPanel.Data().flLerpProgress = 1.0;
            _LerpTimer(contextPanel);
        }
        contextPanel.FindChildInLayoutFile('NameableSpinner').RemoveClass('hidden');
        contextPanel.Data().scheduleHandle = $.Schedule(5, () => _CancelWaitforCallBack(contextPanel));
        InventoryAPI.SetStatTrakSwapToolItems(InspectShared.GetPopupSetting('item_id', contextPanel), InspectShared.GetPopupSetting('stattrak_swap_second_item_id', contextPanel));
        const toolId = InspectShared.GetPopupSetting('tool_id', contextPanel);
        InventoryAPI.UseTool(toolId, '');
    }
    function ClosePopup() {
        $.DispatchEvent('HideSelectItemForCapabilityPopup');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
    }
    CapabilityCanStatTrackSwap.ClosePopup = ClosePopup;
    function _CancelWaitforCallBack(contextPanel) {
        let elSpinner = contextPanel.FindChildInLayoutFile('NameableSpinner');
        elSpinner.AddClass('hidden');
        ClosePopup();
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', () => { });
    }
    function _OnItemCustomization(numericType, type, itemid) {
        const contextPanel = $.GetContextPanel();
        if (contextPanel.Data().scheduleHandle) {
            $.CancelScheduled(contextPanel.Data().scheduleHandle);
            contextPanel.Data().scheduleHandle = null;
        }
        ClosePopup();
        $.DispatchEvent('ShowAcknowledgePopup', type, itemid);
    }
    $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', _OnItemCustomization);
})(CapabilityCanStatTrackSwap || (CapabilityCanStatTrackSwap = {}));
