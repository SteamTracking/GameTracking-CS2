"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
var SelectInventoryItem;
(function (SelectInventoryItem) {
    const m_ItemList = $('#ItemList');
    const m_SortDropdown = $("#SortDropdown");
    const m_SearchText = $("#Search");
    const m_ItemImage = $("#SelectItemImage");
    let m_InvFilter = '';
    let m_AssociatedItemId = '';
    function Init() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE');
        m_InvFilter = $.GetContextPanel().GetAttributeString('filter_category', 'all');
        m_AssociatedItemId = $.GetContextPanel().GetAttributeString('associated_item', '');
        if (m_AssociatedItemId !== '') {
            $.GetContextPanel().SetDialogVariable('item_name', InventoryAPI.GetItemNameUncustomized(m_AssociatedItemId));
            m_ItemImage.itemid = m_AssociatedItemId;
        }
        const sortMethods = InventoryAPI.GetSortMethodsCount();
        for (let i = 0; i < sortMethods; i++) {
            let sort = InventoryAPI.GetSortMethodByIndex(i);
            let newEntry = $.CreatePanel('Label', m_SortDropdown.GetParent(), sort, {
                class: 'DropDownMenu'
            });
            newEntry.text = $.Localize('#' + sort);
            m_SortDropdown.AddOption(newEntry);
        }
        m_SortDropdown.SetSelected("inv_sort_age");
        m_SortDropdown.SetPanelEvent('oninputsubmit', UpdatePopup);
        m_SearchText.RaiseChangeEvents(true);
        m_SearchText.SetPanelEvent('ontextentrychange', UpdatePopup);
        UpdatePopup();
    }
    SelectInventoryItem.Init = Init;
    function UpdatePopup() {
        $.DispatchEvent('SetInventoryFilter', m_ItemList, "any", "any", "any", m_SortDropdown.GetSelected() ? m_SortDropdown.GetSelected().id : 'inv_sort_age', m_InvFilter, m_SearchText.text);
    }
    SelectInventoryItem.UpdatePopup = UpdatePopup;
    function ClosePopUp() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    SelectInventoryItem.ClosePopUp = ClosePopUp;
    function OnItemTileActivated(panel, itemid) {
        $.DispatchEvent('UIPopupButtonClicked', 'OnInventoryItemSelected(' + itemid + ')');
    }
    SelectInventoryItem.OnItemTileActivated = OnItemTileActivated;
    {
        $.RegisterForUnhandledEvent("OnItemTileActivated", OnItemTileActivated);
    }
})(SelectInventoryItem || (SelectInventoryItem = {}));
