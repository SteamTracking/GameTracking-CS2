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
    let m_AssociatedItemId = ''; // Other item being acted on (eg nametag or sticker seeking a weapon). 
    function Init() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE');
        m_InvFilter = $.GetContextPanel().GetAttributeString('filter_category', 'all');
        m_AssociatedItemId = $.GetContextPanel().GetAttributeString('associated_item', '');
        // Setup title bar
        if (m_AssociatedItemId !== '') {
            $.GetContextPanel().SetDialogVariable('item_name', InventoryAPI.GetItemNameUncustomized(m_AssociatedItemId));
            m_ItemImage.itemid = m_AssociatedItemId;
        }
        // TODO: Deal with multiselect
        // Setup dropdown with sort methods from inventory api
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
        $.DispatchEvent('SetInventoryFilter', m_ItemList, // List to repopulate
        "any", "any", "any", // These are redundant with the below
        m_SortDropdown.GetSelected() ? m_SortDropdown.GetSelected().id : 'inv_sort_age', // Sort setting
        m_InvFilter, // Capability filter string
        m_SearchText.text); // Current search text
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
    // Entry point called when panel is created
    {
        $.RegisterForUnhandledEvent("OnItemTileActivated", OnItemTileActivated);
    }
})(SelectInventoryItem || (SelectInventoryItem = {}));
