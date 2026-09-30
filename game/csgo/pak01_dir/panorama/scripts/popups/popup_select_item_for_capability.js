"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="popup_inspect_action-bar.ts" />
/// <reference path="popup_inspect_shared.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../inspect.ts" />
var SelectItemForCapability;
(function (SelectItemForCapability) {
    let _m_cp = $.GetContextPanel();
    let _m_elItemList = _m_cp.FindChildInLayoutFile('id-popup-select-item-list');
    SelectItemForCapability.oCapabilityInfo = {
        capability: '',
        initialItemId: '',
        popupVisible: false,
        bWorkshopItemPreview: false,
        bIsMultiSelect: false
    };
    function Init() {
        SelectItemForCapability.oCapabilityInfo.initialItemId = _m_cp.GetAttributeString('itemid', '');
        SelectItemForCapability.oCapabilityInfo.secondaryItemId = _m_cp.GetAttributeString('secondaryItemid', '');
        SelectItemForCapability.oCapabilityInfo.bWorkshopItemPreview = _m_cp.GetAttributeString("bWorkshopItemPreview", 'false') === 'true' ? true : false;
        SelectItemForCapability.oCapabilityInfo.capability = _m_cp.GetAttributeString("capability", '');
        SelectItemForCapability.oCapabilityInfo.bIsMultiSelect = (SelectItemForCapability.oCapabilityInfo.capability === "casketstore" || SelectItemForCapability.oCapabilityInfo.capability === "casketretrieve");
        SelectItemForCapability.oCapabilityInfo.popupVisible = true;
        $.DispatchEvent('CapabilityPopupIsOpen', true);
        _m_cp.FindChildInLayoutFile('id-initial-item-image').itemid = SelectItemForCapability.oCapabilityInfo.initialItemId;
        _m_elItemList.SetHasClass('inv-multi-select-allow', SelectItemForCapability.oCapabilityInfo.bIsMultiSelect);
        _m_cp.SetDialogVariable('item-name', InventoryAPI.GetItemName(SelectItemForCapability.oCapabilityInfo.initialItemId));
        _SetTitle();
        let elDropDownParent = _m_cp.FindChildInLayoutFile('id-dropdown-container');
        _AddSortDropdownToNavBar(elDropDownParent);
        _UpdateMultiSelectDisplay();
    }
    SelectItemForCapability.Init = Init;
    function _SetTitle() {
        let szPrefixString = '#inv_select_item_use_capability';
        if (SelectItemForCapability.oCapabilityInfo.capability === 'can_stattrack_swap') {
            szPrefixString = InventoryAPI.IsTool(SelectItemForCapability.oCapabilityInfo.initialItemId) ?
                '#inv_select_item_use_capability' :
                '#inv_select_item_stattrack_swap_capability';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_collect') {
            let defName = InventoryAPI.GetItemDefinitionName(SelectItemForCapability.oCapabilityInfo.initialItemId);
            szPrefixString = (defName === 'casket') ?
                '#inv_select_item_tostoreincasket' :
                '#inv_select_casketitem_tostorethis';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketcontents') {
            szPrefixString = '#inv_select_casketcontents';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketretrieve') {
            szPrefixString = '#inv_select_casketretrieve';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketstore') {
            szPrefixString = '#inv_select_casketstore';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'craft_souvenir') {
            szPrefixString = '#inv_select_item_craft_souvenir';
        }
        _m_cp.AddClass('PopupSelectItemForCapability_' + SelectItemForCapability.oCapabilityInfo.capability);
        _m_cp.SetDialogVariable('title', $.Localize(szPrefixString, _m_cp));
    }
    function _AddSortDropdownToNavBar(elDropDownParent) {
        let elDropdown = elDropDownParent.FindChildInLayoutFile('InvSortDropdown');
        let count = InventoryAPI.GetSortMethodsCount();
        for (let i = 0; i < count; i++) {
            let sort = InventoryAPI.GetSortMethodByIndex(i);
            let newEntry = $.CreatePanel('Label', elDropdown, sort, {
                class: 'DropDownMenu'
            });
            newEntry.text = $.Localize('#' + sort);
            elDropdown.AddOption(newEntry);
        }
        elDropdown.SetPanelEvent('oninputsubmit', () => UpdateSort());
        elDropdown.SetSelected(GameInterfaceAPI.GetSettingString("newest"));
    }
    function UpdateSort() {
        let elDropdown = _m_cp.FindChildInLayoutFile('InvSortDropdown');
        const sortString = (!elDropdown || !elDropdown.GetSelected()) ? 'newest' : elDropdown.GetSelected().id;
        let filterApplicationToPhantomItems = ItemInfo.IsFauxOrRentalOrPreviewTool(SelectItemForCapability.oCapabilityInfo.initialItemId) ? '' : ',is_rental:false,is_sealed:false';
        let capabilityFilter = SelectItemForCapability.oCapabilityInfo.capability + ':' + SelectItemForCapability.oCapabilityInfo.initialItemId + filterApplicationToPhantomItems;
        $.DispatchEvent('SetInventoryFilter', _m_elItemList, 'any', 'any', 'any', sortString, capabilityFilter, '');
        _ShowHideNoItemsMessage();
    }
    SelectItemForCapability.UpdateSort = UpdateSort;
    function _ShowHideNoItemsMessage() {
        let count = _m_elItemList.count;
        let elParent = _m_elItemList.GetParent();
        let elEmpty = elParent.FindChildInLayoutFile('id-select-item-empty-lister');
        if (count > 0) {
            elEmpty.visible = false;
            return;
        }
        let emptyText = '';
        elEmpty.SetDialogVariable('type', InventoryAPI.GetItemName(SelectItemForCapability.oCapabilityInfo.initialItemId));
        if ((SelectItemForCapability.oCapabilityInfo.capability === 'can_stattrack_swap') && !InventoryAPI.IsTool(SelectItemForCapability.oCapabilityInfo.initialItemId))
            emptyText = $.Localize('#inv_empty_lister_for_stattrackswap', elEmpty);
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_collect')
            emptyText = $.Localize('#inv_empty_lister_nocaskets', elEmpty);
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'craft_souvenir')
            emptyText = $.Localize('#inv_empty_lister_for_craft_souvenir', elEmpty);
        else
            emptyText = $.Localize('#inv_empty_lister_for_use', elEmpty);
        elEmpty.SetDialogVariable('empty-text', emptyText);
        elEmpty.visible = true;
    }
    function _UpdateMultiSelectDisplay() {
        const elMultiSelectDisplay = _m_cp.FindChildInLayoutFile('id-popup-select-multi-item-display');
        if (!SelectItemForCapability.oCapabilityInfo.bIsMultiSelect) {
            elMultiSelectDisplay.visible = false;
            return;
        }
        let count = _m_elItemList.selectedItemCount;
        elMultiSelectDisplay.SetDialogVariableInt('count', count);
        _m_cp.FindChildInLayoutFile('id-popup-select-multi-item-btn').enabled = (count > 0);
        elMultiSelectDisplay.visible = true;
    }
    function ClosePopUp() {
        if (_m_cp.IsValid()) {
            const callbackFunc = _m_cp.GetAttributeInt('callback', -1);
            if (callbackFunc != -1) {
                UiToolkitAPI.InvokeJSCallback(callbackFunc);
            }
        }
        SelectItemForCapability.oCapabilityInfo.popupVisible = false;
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
        $.DispatchEvent('BlurPopupPanel', 'popup-lootlist-item-inspect-' + SelectItemForCapability.oCapabilityInfo.initialItemId, false);
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    SelectItemForCapability.ClosePopUp = ClosePopUp;
    function _OnItemTileActivated(itemTile, itemid) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_item_select', 'MOUSE');
        if (SelectItemForCapability.oCapabilityInfo.capability === 'can_sticker') {
            _CapabilityCanStickerAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId), SelectItemForCapability.oCapabilityInfo.bWorkshopItemPreview);
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_wrap_sticker') {
            _CapabilityWrapStickerAsKeychainAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId, ItemInfo.IsSticker));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'nameable') {
            _CapabilityNameableAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_keychain') {
            _CapabilityCanKeychainAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId), SelectItemForCapability.oCapabilityInfo.bWorkshopItemPreview);
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'remove_keychain') {
            _CapabilityRemoveKeychainAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_patch') {
            _CapabilityCanPatchAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'decodable') {
            _CapabilityDecodableAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_stattrack_swap') {
            _CapabilityStatTrakSwapAction(SelectItemForCapability.oCapabilityInfo, itemid);
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_collect') {
            _CapabilityPutIntoCasketAction(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId);
        }
        if (SelectItemForCapability.oCapabilityInfo.capability === 'casketretrieve') {
            let listPanel = itemTile.FindAncestor("id-popup-select-item-list");
            listPanel.OnItemActivated(itemid);
            _UpdateMultiSelectDisplay();
            return;
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketstore') {
            let listPanel = itemTile.FindAncestor("id-popup-select-item-list");
            listPanel.OnItemActivated(itemid);
            _UpdateMultiSelectDisplay();
            return;
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'craft_souvenir') {
            _CapabilityCraftSouvenirAction(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId);
        }
        ClosePopUp();
    }
    function SortIdsIntoToolAndItemID(id, initalId, fnWhatIsTool) {
        let bIdIsTool = fnWhatIsTool ? fnWhatIsTool(id) : InventoryAPI.IsTool(id);
        let toolId = bIdIsTool ? id : initalId;
        let itemID = bIdIsTool ? initalId : id;
        return {
            tool: toolId,
            item: itemID
        };
    }
    ;
    function _CapabilityCanStickerAction(idsToUse, bWorkshopItemPreview) {
        const workshopPreview = bWorkshopItemPreview ? 'true' : 'false';
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_sticker.xml');
        let oSettings = {
            popup_panel: elPanel,
            item_id: idsToUse.item,
            tool_id: idsToUse.tool,
            work_type: 'can_sticker',
            is_workshop_preview: bWorkshopItemPreview
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityNameableAction(idsToUse) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_nameable.xml');
        let oSettings = {
            item_id: idsToUse.item,
            tool_id: idsToUse.tool,
            work_type: 'nameable'
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityCanKeychainAction(idsToUse, bWorkshopItemPreview) {
        const workshopPreview = bWorkshopItemPreview ? 'true' : 'false';
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
        let oSettings = {
            popup_panel: elPanel,
            tool_id: idsToUse.tool,
            item_id: idsToUse.item,
            work_type: 'can_keychain',
            is_workshop_preview: bWorkshopItemPreview
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityCraftSouvenirAction(itemid, umid) {
        if (InventoryAPI.GetItemStickerCount(itemid) > 0) {
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_can_sticker.xml');
            let oSettings = {
                popup_panel: elPanel,
                item_id: itemid,
                remove_sticker_all_at_once: true,
                work_type: 'remove_sticker',
                umid_souvenir: umid
            };
            elPanel.Data().oSettings = oSettings;
        }
        else {
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + itemid, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
            let oSettings = {
                item_id: itemid,
                tool_id: '',
                umid_souvenir: umid,
                work_type: 'craft_souvenir'
            };
            elPanel.Data().oSettings = oSettings;
        }
    }
    function _CapabilityWrapStickerAsKeychainAction(idsToUse) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
        let oSettings = {
            item_id: idsToUse.item,
            tool_id: idsToUse.tool,
            work_type: 'can_wrap_sticker'
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityRemoveKeychainAction(idsToUse) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
        let oSettings = {
            item_id: idsToUse.item,
            work_type: 'remove_keychain'
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityCanPatchAction(idsToUse) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_patch.xml');
        let oSettings = {
            item_id: idsToUse.item,
            tool_id: idsToUse.tool,
            work_type: 'can_patch'
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityDecodableAction(idsToUse) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_decodable.xml');
        let oSettings = {
            item_id: idsToUse.item,
            tool_id: idsToUse.tool,
            work_type: 'decodeable'
        };
        elPanel.Data().oSettings = oSettings;
    }
    ;
    function _CapabilityStatTrakSwapAction(capInfo, id) {
        if (InventoryAPI.IsTool(capInfo.initialItemId)) {
            const sWorkshop = false;
            $.DispatchEvent('CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE');
            $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, capInfo.initialItemId, capInfo.capability);
            ClosePopUp();
        }
        else {
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_can_stattrack_swap.xml');
            let oSettings = {
                tool_id: capInfo.secondaryItemId,
                item_id: capInfo.initialItemId,
                stattrak_swap_second_item_id: id
            };
            elPanel.Data().oSettings = oSettings;
        }
    }
    ;
    function _CapabilityPutIntoCasketAction(idCasket, idItem, cap) {
        $.DispatchEvent('ContextMenuEvent', '');
        if (!cap) {
            $.DispatchEvent('HideSelectItemForCapabilityPopup');
            $.DispatchEvent('UIPopupButtonClicked', '');
            $.DispatchEvent('CapabilityPopupIsOpen', false);
        }
        if (InventoryAPI.GetItemAttributeValue(idCasket, 'modification date')) {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=add' +
                (cap ? '&nextcapability=' + cap : '') +
                '&spinner=1' +
                '&casket_item_id=' + idCasket +
                '&subject_item_id=' + idItem);
        }
        else {
            const fauxNameTag = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1200, 0);
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_nameable.xml');
            let oSettings = {
                item_id: idCasket,
                tool_id: fauxNameTag,
                work_type: 'nameable',
                async_work_type_warning_text: '#popup_newcasket_warning'
            };
            elPanel.Data().oSettings = oSettings;
        }
    }
    ;
    function ProceedForMultiStatusCapabilityPopup() {
        let capability = SelectItemForCapability.oCapabilityInfo.capability;
        let count = _m_elItemList.selectedItemCount;
        let arrItemIDs = [];
        for (let i = 0; i < count; i++) {
            arrItemIDs.push(_m_elItemList.GetSelectedItemId(i).toString());
        }
        if (arrItemIDs.length <= 0)
            return;
        switch (capability) {
            case 'casketretrieve':
                {
                    let strItemIDs = arrItemIDs.join(",");
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=remove' +
                        '&nextcapability=batch' +
                        '&spinner=1' +
                        '&casket_item_id=' + SelectItemForCapability.oCapabilityInfo.initialItemId +
                        '&subject_item_id=' + strItemIDs);
                    break;
                }
            case 'casketstore':
                {
                    let strItemIDs = arrItemIDs.join(",");
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=add' +
                        '&nextcapability=batch' +
                        '&spinner=1' +
                        '&casket_item_id=' + SelectItemForCapability.oCapabilityInfo.initialItemId +
                        '&subject_item_id=' + strItemIDs);
                    break;
                }
        }
        ClosePopUp();
    }
    SelectItemForCapability.ProceedForMultiStatusCapabilityPopup = ProceedForMultiStatusCapabilityPopup;
    function _UpdateSelectItemForCapabilityPopup(capability, itemid, bSelected) {
        if (SelectItemForCapability.oCapabilityInfo.capability !== capability)
            return false;
        if (!itemid)
            return false;
        _UpdateMultiSelectDisplay();
        UpdateSort();
        return true;
    }
    {
        $.RegisterForUnhandledEvent("OnItemTileActivated", _OnItemTileActivated);
        $.RegisterForUnhandledEvent('UpdateSelectItemForCapabilityPopup', _UpdateSelectItemForCapabilityPopup);
    }
})(SelectItemForCapability || (SelectItemForCapability = {}));
