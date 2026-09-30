"use strict";
/// <reference path="csgo.d.ts" />
var InventorySearch;
(function (InventorySearch) {
    let m_elList = null;
    let m_elSearchPanel = $.GetContextPanel();
    let m_elSuggestedPanel = null;
    let m_InventoryUpdatedHandler = null;
    function _Init() {
        _RegisterForInventoryUpdate();
        let elTextEntry = m_elSearchPanel.FindChildInLayoutFile('InvSearchTextEntry');
        elTextEntry.SetPanelEvent('ontextentrychange', UpdateItemList);
        _PopulateSuggested(m_elSearchPanel.FindChildInLayoutFile('InvSearchSuggestionsList'));
        _TextEntrySettings.SetTextEntryPanel(elTextEntry);
        m_elSuggestedPanel = m_elSearchPanel.FindChildInLayoutFile('InvSearchSuggestions');
        m_elList = m_elSearchPanel.FindChildInLayoutFile('InvSearchPanel-List');
        _AddSortDropdownEntries();
        UpdateItemList();
    }
    function _RegisterForInventoryUpdate() {
        m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', UpdateItemList);
        m_elSearchPanel.RegisterForReadyEvents(true);
        $.RegisterEventHandler('ReadyForDisplay', m_elSearchPanel, () => {
            if (!m_InventoryUpdatedHandler) {
                m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', UpdateItemList);
            }
        });
        $.RegisterEventHandler('UnreadyForDisplay', m_elSearchPanel, () => {
            if (m_InventoryUpdatedHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', m_InventoryUpdatedHandler);
                m_InventoryUpdatedHandler = null;
            }
        });
    }
    function UpdateItemList() {
        if (!m_elList) {
            return;
        }
        let filterString = _TextEntrySettings.GetText();
        if (filterString === '') {
            _ShowHideSuggestedPanel(true);
        }
        else {
            let sortText = m_elSearchPanel.FindChildInLayoutFile('InvSortDropdown').GetSelected().id;
            $.DispatchEvent('SetInventoryFilter', m_elList, 'any', 'any', 'any', sortText, '', filterString);
            _ShowHideSuggestedPanel(m_elList.count < 1);
        }
    }
    InventorySearch.UpdateItemList = UpdateItemList;
    let _TextEntrySettings;
    (function (_TextEntrySettings) {
        let elTextEntry = null;
        function SetTextEntryPanel(elPanel) {
            elTextEntry = elPanel;
        }
        _TextEntrySettings.SetTextEntryPanel = SetTextEntryPanel;
        function UpdateText(selectedEntryText) {
            elTextEntry.text = selectedEntryText;
        }
        _TextEntrySettings.UpdateText = UpdateText;
        function GetText() {
            return elTextEntry ? elTextEntry.text : '';
        }
        _TextEntrySettings.GetText = GetText;
    })(_TextEntrySettings || (_TextEntrySettings = {}));
    function _PopulateSuggested(elSearchResults) {
        let settings = {
            0: ['inv_sort_rarity', 'melee'],
            1: ['inv_sort_age', 'not_equipment'],
            2: ['inv_sort_rarity', 'rifle'],
            3: ['inv_sort_age', 'flair0'],
            4: ['inv_sort_rarity', 'smg'],
            5: ['inv_sort_age', 'spray'],
            6: ['inv_sort_rarity', 'secondary']
        };
        let delay = 0.25;
        let count = 0;
        for (let entry of Object.values(settings)) {
            count++;
            let sortType = entry[0];
            let searchText = entry[1];
            $.Schedule(count * delay, () => {
                let id = _GetSuggested(sortType, searchText);
                if (id !== '')
                    _AddSuggestedEntry(id, elSearchResults);
            });
        }
    }
    function _GetSuggested(sortType, searchText) {
        InventoryAPI.SetInventorySortAndFilters(sortType, false, searchText, '', '');
        let count = InventoryAPI.GetInventoryCount();
        let itemsList = [];
        let itemsValid = 0;
        let itemsNeedToCollect = 5;
        for (let i = 0; i < count; i++) {
            let itemId = InventoryAPI.GetInventoryItemIDByIndex(i);
            itemsValid++;
            itemsList.push(itemId);
            if (itemsValid > itemsNeedToCollect)
                break;
        }
        let countValidItems = itemsList.length;
        if (countValidItems > 0) {
            let index = countValidItems > itemsNeedToCollect ?
                Math.floor(Math.random() * itemsNeedToCollect) :
                Math.floor(Math.random() * countValidItems);
            return itemsList[index];
        }
        return '';
    }
    function _AddSuggestedEntry(id, elSearchResults) {
        let elEntry = $.CreatePanel('Panel', elSearchResults, id);
        elEntry.BLoadLayoutSnippet('SuggestedEntry');
        let itemName = InventoryAPI.GetItemName(id);
        elEntry.SetPanelEvent('onactivate', () => {
            _TextEntrySettings.UpdateText(itemName);
        });
        elEntry.SetDialogVariable('suggestion_text', itemName);
        let elImage = elEntry.FindChildInLayoutFile('SuggestedImage');
        elImage.itemid = id;
        let elPanel = elEntry.FindChildInLayoutFile('SuggestedRarity');
        elPanel.style.washColor = InventoryAPI.GetItemRarityColor(id);
    }
    function _ShowHideSuggestedPanel(bShow) {
        m_elSuggestedPanel.SetHasClass('collapse', !bShow);
        m_elList.SetHasClass('hide', bShow);
    }
    function _AddSortDropdownEntries() {
        let elDropdown = m_elSearchPanel.FindChildInLayoutFile('InvSortDropdown');
        elDropdown.SetPanelEvent('oninputsubmit', UpdateItemList);
        let count = InventoryAPI.GetSortMethodsCount();
        for (let i = 0; i < count; i++) {
            let sort = InventoryAPI.GetSortMethodByIndex(i);
            let newEntry = $.CreatePanel('Label', elDropdown, sort, {
                class: 'DropDownMenu'
            });
            newEntry.text = $.Localize('#' + sort);
            elDropdown.AddOption(newEntry);
        }
        elDropdown.SetSelected(InventoryAPI.GetSortMethodByIndex(0));
    }
    {
        _Init();
    }
})(InventorySearch || (InventorySearch = {}));
