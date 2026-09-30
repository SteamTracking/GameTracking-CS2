"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/item_context_entries.ts" />
var ItemContextMenu;
(function (ItemContextMenu) {
    function SetupContextMenu() {
        let id = $.GetContextPanel().GetAttributeString("itemid", "(not found)");
        let populateFilterText = $.GetContextPanel().GetAttributeString("populatefiltertext", "(not found)");
        InventoryAPI.PrecacheCustomMaterials(id);
        _PopulateContextMenu(id, populateFilterText);
    }
    ItemContextMenu.SetupContextMenu = SetupContextMenu;
    function _PopulateContextMenu(id, populateFilterText) {
        let elParent = $.GetContextPanel();
        let validEntries = ItemContextEntries.FilterEntries(id, populateFilterText);
        function OnMouseOver(location, displayText) {
            UiToolkitAPI.ShowTextTooltip(location, displayText);
        }
        let contextmenuparam = $.GetContextPanel().GetAttributeString('contextmenuparam', '');
        for (let i = 0; i < validEntries.length; i++) {
            const entry = validEntries[i];
            let elButton = $.CreatePanel('Button', elParent, 'ContextMenuItem' + i);
            let elLabel = $.CreatePanel('Label', elButton, '', { html: 'true' });
            let displayName = '';
            if (entry.name instanceof Function) {
                displayName = entry.name(id);
            }
            else {
                displayName = entry.name;
            }
            elLabel.text = '#inv_context_' + displayName;
            if (entry.style) {
                let strStyleToAdd = entry.style(id);
                if (strStyleToAdd !== '') {
                    if (strStyleToAdd === 'BottomSeparator' && i !== (validEntries.length - 1) ||
                        strStyleToAdd === 'TopSeparator' && i !== 0) {
                        elButton.AddClass(strStyleToAdd);
                    }
                }
            }
            let handler = entry.OnSelected;
            elButton.SetPanelEvent('onactivate', () => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_item_popupSelect', 'MOUSE');
                handler(id, contextmenuparam);
            });
            if (entry.CustomName) {
                if (entry.CustomName(id) !== '') {
                    let buttonId = elButton.id;
                    let customName = entry.CustomName(id);
                    elButton.SetPanelEvent('onmouseover', () => OnMouseOver(buttonId, customName));
                    elButton.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
                }
            }
        }
        if (!validEntries.length) {
            let elButton = $.CreatePanel('Button', elParent, 'ContextMenuItem');
            let elLabel = $.CreatePanel('Label', elButton, '', { html: 'true' });
            elLabel.text = '#inv_context_no_valid_actions';
            elButton.SetPanelEvent('onactivate', () => $.DispatchEvent('ContextMenuEvent', ''));
        }
    }
})(ItemContextMenu || (ItemContextMenu = {}));
