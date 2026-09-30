"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="inspect.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="common/tint_spray_icon.ts" />
/// <reference path="common/formattext.ts" />
var LoadoutGrid;
(function (LoadoutGrid) {
    let m_hasRunFirstTime = false;
    let m_equipSlotChangedHandler;
    let m_setShuffleEnabledHandler;
    let m_inventoryUpdatedHandler;
    let m_selectedTeam;
    let m_mouseOverSlot;
    let m_elDragSource;
    let m_dragItemId;
    let m_filterItemId = '';
    let m_updatedFromShowItemInLoadout = false;
    let m_currentCharId = {
        t: '',
        ct: '',
        noteam: '',
    };
    let m_currentCharGlovesId = {
        t: '',
        ct: '',
        noteam: '',
    };
    let m_currentCharWeaponId = {
        t: '',
        ct: '',
        noteam: '',
    };
    let m_currentPetId = {
        t: '',
        ct: '',
        noteam: '',
    };
    const m_arrGenericCharacterGlobalSlots = [
        { slot: 'customplayer', category: 'customplayer' },
        { slot: 'clothing_hands', category: 'clothing' },
        { slot: 'melee', category: 'melee', equip_on_hover: true },
        { slot: 'equipment2', category: 'equipment2', equip_on_hover: true },
        { slot: 'c4', category: 'c4', required_team: 't', equip_on_hover: true },
        { slot: 'musickit', category: 'musickit' },
        { slot: 'flair0', category: 'flair0' },
        { slot: 'spray0', category: 'spray' },
    ];
    function _BCanFitIntoNonWeaponSlot(category, team) {
        return m_arrGenericCharacterGlobalSlots.find((entry) => { return entry.category === category && (!entry.required_team || (entry.required_team === team)); })
            ? true
            : false;
    }
    function _BIsSlotAndTeamConfigurationValid(slot, team) {
        return m_arrGenericCharacterGlobalSlots.find((entry) => { return entry.slot === slot && entry.required_team && (entry.required_team !== team); })
            ? false
            : true;
    }
    function OnReadyForDisplay() {
        if (!m_hasRunFirstTime) {
            m_hasRunFirstTime = true;
            Init();
        }
        else {
            FillOutRowItems('ct');
            FillOutRowItems('t');
            UpdateGridFilterIcons();
            UpdateGridShuffleIcons();
            UpdateItemList();
            UpdateCharModel('ct');
            UpdateCharModel('t');
            FillOutGridItems('ct');
            FillOutGridItems('t');
            m_updatedFromShowItemInLoadout = m_updatedFromShowItemInLoadout ? false : false;
        }
        m_equipSlotChangedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', OnEquipSlotChanged);
        m_setShuffleEnabledHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Loadout_SetShuffleEnabled', UpdateGridShuffleIcons);
        m_inventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', () => {
            OnMyPersonaInventoryUpdated();
        });
    }
    function OnMyPersonaInventoryUpdated() {
        UpdateItemList();
        FillOutRowItems('ct');
        FillOutRowItems('t');
        UpdateCharModel('ct');
        UpdateCharModel('t');
    }
    function OnUnreadyForDisplay() {
        if (m_equipSlotChangedHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', m_equipSlotChangedHandler);
            m_equipSlotChangedHandler = null;
        }
        if (m_setShuffleEnabledHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_Loadout_SetShuffleEnabled', m_setShuffleEnabledHandler);
            m_setShuffleEnabledHandler = null;
        }
        if (m_inventoryUpdatedHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', m_inventoryUpdatedHandler);
            m_inventoryUpdatedHandler = null;
        }
        UiToolkitAPI.HideCustomLayoutTooltip('JsLoadoutItemTooltip');
    }
    function OnEquipSlotChanged(team, slot, oldItemId, newItemId, bNew) {
        if (team == 't' || team == 'ct') {
            FillOutGridItems(team);
            if (['melee', 'secondary', 'smg', 'rifle', 'c4', 'equipment2'].includes(InventoryAPI.GetLoadoutCategory(newItemId)))
                UpdateCharModel(team, newItemId);
            else
                UpdateCharModel(team);
        }
        else if (slot == 'pet') {
            UpdateCharModel('ct');
            UpdateCharModel('t');
        }
        FillOutRowItems('ct');
        FillOutRowItems('t');
        UpdateGridFilterIcons();
    }
    function Init() {
        UpdateCharModel('ct');
        UpdateCharModel('t');
        SetUpTeamSelectBtns();
        InitSortDropDown();
        UpdateGridShuffleIcons();
        $.DispatchEvent("Activated", $.GetContextPanel().FindChildInLayoutFile('id-loadout-select-team-btn-t'), "mouse");
        $.DispatchEvent("Activated", $.GetContextPanel().FindChildInLayoutFile('id-loadout-select-team-btn-ct'), "mouse");
        let elItemList = $('#id-loadout-item-list');
        elItemList.SetAttributeInt('DragScrollSpeedHorizontal', 0);
        elItemList.SetAttributeInt('DragScrollSpeedVertical', 0);
        RegisterGridItemEvents('ct');
        RegisterGridItemEvents('t');
    }
    function SetUpTeamSelectBtns() {
        let aSectionSuffexes = ['ct', 't'];
        for (let suffex of aSectionSuffexes) {
            let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + suffex);
            let elBtn = elSection.FindChildInLayoutFile('id-loadout-select-team-btn-' + suffex);
            elBtn.Data().team = suffex;
            ItemDragTargetEvents(elBtn);
            elBtn.SetPanelEvent('onactivate', ChangeSelectedTeam);
            elBtn.SetPanelEvent('onmouseover', () => { UiToolkitAPI.HideCustomLayoutTooltip('JsLoadoutItemTooltip'); });
        }
    }
    function ChangeSelectedTeam() {
        let suffex = (m_selectedTeam == 't' ? 'ct' : 't');
        let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + suffex);
        $.GetContextPanel().SetHasClass('loadout_t_selected', suffex === 't');
        elSection.FindChildInLayoutFile('id-loadout-grid-slots-' + suffex).hittest = true;
        let oppositeTeam = suffex === 't' ? 'ct' : 't';
        let elOppositeSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + oppositeTeam);
        elOppositeSection.FindChildInLayoutFile('id-loadout-grid-slots-' + oppositeTeam).hittest = false;
        m_selectedTeam = suffex;
        FillOutGridItems(m_selectedTeam);
        FillOutRowItems(m_selectedTeam);
        if (!_BIsSlotAndTeamConfigurationValid(GetSelectedGroup(), m_selectedTeam)) {
            let elGroupDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-group');
            elGroupDropdown.SetSelected('all');
        }
        else {
            UpdateFilters();
        }
        UiToolkitAPI.HideCustomLayoutTooltip('JsLoadoutItemTooltip');
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_select', 'MOUSE');
    }
    function OnActivateSideItem(slotName, TeamName) {
        if (m_selectedTeam !== TeamName) {
            ChangeSelectedTeam();
            ToggleGroupDropdown(slotName, true);
        }
        else {
            ClearItemIdFilter();
            ToggleGroupDropdown(slotName, false);
        }
    }
    function UpdateCharModel(team, weaponId = '') {
        let elPanel = $.GetContextPanel().FindChildInLayoutFile('id-loadout-agent-' + team);
        if (!elPanel)
            return;
        let charId = LoadoutAPI.GetItemID(team, 'customplayer');
        let glovesId = LoadoutAPI.GetItemID(team, 'clothing_hands');
        let petId = InventoryAPI.GetPetItemID();
        const settings = ItemInfo.GetOrUpdateVanityCharacterSettings(charId);
        if (team == m_selectedTeam) {
            let selectedGroup = GetSelectedGroup();
            if (['melee', 'secondary0', 'c4', 'equipment2'].includes(selectedGroup)) {
                weaponId = LoadoutAPI.GetItemID(team, selectedGroup);
            }
            else if (['secondary', 'smg', 'rifle'].includes(selectedGroup)) {
                let selectedItemDef = GetSelectedItemDef();
                if (selectedItemDef != 'all') {
                    let itemDefIndex = InventoryAPI.GetItemDefinitionIndexFromDefinitionName(selectedItemDef);
                    if (LoadoutAPI.IsItemDefEquipped(team, itemDefIndex)) {
                        let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, itemDefIndex);
                        weaponId = LoadoutAPI.GetItemID(team, slot);
                    }
                }
            }
        }
        if (!weaponId || weaponId == '0') {
            weaponId = m_currentCharWeaponId[team];
            if (!weaponId || weaponId == '0')
                weaponId = LoadoutAPI.GetItemID(team, 'melee');
        }
        if (charId != m_currentCharId[team] ||
            glovesId != m_currentCharGlovesId[team] ||
            weaponId != m_currentCharWeaponId[team]
            || Number(petId) != 0 || Number(m_currentPetId[team]) != 0) {
            m_currentCharId[team] = charId;
            m_currentCharGlovesId[team] = glovesId;
            m_currentCharWeaponId[team] = weaponId;
            m_currentPetId[team] = petId;
            settings.panel = elPanel;
            settings.weaponItemId = weaponId;
            settings.petItemId = petId;
            elPanel.SetPetPlacement(!!petId && Number(petId) != 0 ? 'shoulder' : 'none');
            CharacterAnims.PlayAnimsOnPanel(settings);
        }
    }
    function FillOutGridItems(team) {
        let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + team);
        let elGrid = elSection.FindChildInLayoutFile('id-loadout-grid-slots-' + team);
        for (let column of elGrid.Children()) {
            let aPanels = column.Children().filter(panel => panel.GetAttributeString('data-slot', '') !== '');
            for (let i = 0; i < aPanels.length; i++) {
                if (column.GetAttributeString('data-slot', '') === 'equipment' ||
                    column.GetAttributeString('data-slot', '') === 'grenade') {
                    UpdateSlotItemImage(team, aPanels[i], true, false, true);
                }
                else {
                    UpdateSlotItemImage(team, aPanels[i], false, true);
                    UpdateName(aPanels[i]);
                    UpdateMoney(aPanels[i], team);
                    UpdateIsRentable(aPanels[i], team);
                }
            }
        }
    }
    function FillOutRowItems(team) {
        let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + team);
        let elRow = elSection.FindChildInLayoutFile('id-loadout-row-slots-' + team);
        for (let entry of m_arrGenericCharacterGlobalSlots) {
            if (entry.required_team && entry.required_team !== team)
                continue;
            let panelId = 'id-loadout-row-slots-' + entry.slot + '-' + team;
            let elBtn = elRow.FindChild(panelId);
            if (!elBtn) {
                elBtn = $.CreatePanel('ItemImage', elRow, panelId, {
                    class: 'loadout-model-panel__slot'
                });
                elBtn.SetAttributeString('data-slot', entry.slot);
            }
            let slotName = entry.slot;
            let itemid = LoadoutAPI.GetItemID(OverrideTeam(team, slotName), slotName);
            let useIconSlots = ['musickit', 'spray0', 'flair0'];
            let bUseIcon = useIconSlots.includes(slotName) && itemid === '0' ? true : false;
            UpdateSlotItemImage(team, elBtn, bUseIcon, true);
            if (itemid && itemid != '0' && elBtn) {
                elBtn.SetPanelEvent('oncontextmenu', () => {
                    let filterValue = '';
                    if (LoadoutAPI.IsShuffleEnabled(OverrideTeam(team, slotName), slotName))
                        filterValue = 'shuffle_slot_' + team;
                    else
                        filterValue = 'loadout_slot_' + team;
                    if (slotName === 'spray0')
                        filterValue += '&contextmenuparam=graffiti';
                    OpenContextMenu(elBtn, filterValue);
                });
                elBtn.SetPanelEvent('onmouseover', () => {
                    if (team == m_selectedTeam && entry.equip_on_hover)
                        UpdateCharModel(team, LoadoutAPI.GetItemID(team, slotName));
                    UiToolkitAPI.ShowCustomLayoutParametersTooltip(panelId, 'JsLoadoutItemTooltip', 'file://{resources}/layout/tooltips/tooltip_loadout_item.xml', 'itemid=' + elBtn.Data().itemid +
                        '&' + 'slot=' + slotName +
                        '&' + 'team=' + m_selectedTeam);
                });
                elBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideCustomLayoutTooltip('JsLoadoutItemTooltip'); });
            }
            else {
                elBtn.ClearPanelEvent('oncontextmenu');
                elBtn.ClearPanelEvent('onmouseover');
                elBtn.ClearPanelEvent('onmouseout');
            }
            elBtn.SetPanelEvent('onactivate', () => OnActivateSideItem(slotName, team));
        }
    }
    function BTeamHasIconForSlot(team, slot) {
        return (team == "t" && slot == "equipment3") ? false : true;
    }
    function UpdateSlotItemImage(team, elPanel, bUseIcon, bReplacable, bIsEquipment = false) {
        let slot = elPanel.GetAttributeString('data-slot', '');
        team = OverrideTeam(team, slot);
        let itemImage = elPanel.FindChild('loudout-item-image-' + slot);
        let itemid = LoadoutAPI.GetItemID(team, slot);
        let elRarity = elPanel.FindChild('id-loadout-item-rarity');
        if (!itemImage) {
            itemImage = $.CreatePanel('ItemImage', elPanel, 'loudout-item-image-' + slot, {
                class: 'loadout-slot__image'
            });
            if (slot === 'spray0') {
                itemImage.SetAttributeInt('ItemInventoryImagePurpose', 1);
            }
            if (!bUseIcon) {
                elRarity = $.CreatePanel('Panel', elPanel, 'id-loadout-item-rarity', {
                    class: 'loadout-slot-rarity'
                });
            }
            if (bReplacable) {
                $.CreatePanel('Image', elPanel, 'id-loadout-item-filter-icon', {
                    class: 'loadout-slot-filter-icon'
                });
                let elShuffleIcon = $.CreatePanel('Image', elPanel, 'id-loadout-item-shuffle-icon', {
                    class: 'loadout-slot-shuffle-icon'
                });
                elShuffleIcon.visible = LoadoutAPI.IsShuffleEnabled(team, slot);
            }
        }
        itemImage.SetHasClass('loadout-slot__image', !bUseIcon);
        itemImage.SetHasClass('loadout-slot-svg__image', bUseIcon);
        if (!bIsEquipment) {
            TintSprayImage(itemImage, itemid);
        }
        if (bUseIcon && BTeamHasIconForSlot(team, slot)) {
            itemImage.itemid = '';
            itemImage.SetImage('file://{images}/icons/equipment/' + GetDefName(itemid, slot) + '.svg');
        }
        else {
            itemImage.itemid = itemid;
        }
        if (LoadoutAPI.IsShuffleEnabled(team, slot)) {
            let sShuffleIds = GetShuffleItems(team, slot);
            let elContainer = elPanel.FindChild('loudout-item-image-' + slot + '-shuffle');
            if (!elContainer) {
                elContainer = $.CreatePanel('Panel', elPanel, 'loudout-item-image-' + slot + '-shuffle', {});
            }
            for (let element of sShuffleIds) {
                $.CreatePanel('ItemImage', elContainer, 'loudout-item-image-' + slot, {
                    class: 'loadout-slot__image'
                });
            }
        }
        elPanel.Data().itemid = itemid;
        elPanel.Data().visuals_itemid = itemid;
        if (slot === 'spray0') {
            elPanel.Data().visuals_itemid = ItemInfo.GetFauxReplacementItemID(itemid, 'graffiti');
        }
        let color = InventoryAPI.GetItemRarityColor(itemid);
        if (elRarity) {
            elRarity.visible = color ? true : false;
            if (color)
                elRarity.style.backgroundColor = color;
            return;
        }
    }
    function TintSprayImage(itemImage, itemId) {
        TintSprayIcon.CheckIsSprayAndTint(itemId, itemImage);
    }
    function UpdateName(elPanel) {
        let elName = elPanel.FindChild('id-loadout-item-name');
        if (!elName) {
            elName = $.CreatePanel('Label', elPanel, 'id-loadout-item-name', {
                class: 'loadout-slot__name stratum-regular',
                text: '{s:item-name}'
            });
        }
        elPanel.SetDialogVariable('item-name', $.Localize(InventoryAPI.GetItemBaseName(elPanel.Data().visuals_itemid)));
    }
    function UpdateMoney(elPanel, team) {
        let elMoney = elPanel.FindChild('id-loadout-item-money');
        if (!elMoney) {
            elMoney = $.CreatePanel('Label', elPanel, 'id-loadout-item-money', {
                class: 'loadout-slot__money stratum-regular',
                text: '{d:money}'
            });
        }
        elPanel.SetDialogVariableInt('money', LoadoutAPI.GetItemGamePrice(team, elPanel.GetAttributeString('data-slot', '')));
        elMoney.text = $.Localize("#buymenu_money", elPanel);
    }
    function GetDefName(itemid, slot) {
        let defName = InventoryAPI.GetItemDefinitionName(itemid);
        let aDefName = [];
        if (slot === 'clothing_hands' || slot === 'melee' || slot === 'customplayer' || itemid === '0') {
            return slot;
        }
        else {
            aDefName = defName ? defName.split('_') : [];
            return aDefName[1];
        }
    }
    function UpdateIsRentable(elPanel, team) {
        let elLabel = elPanel.FindChild('id-loadout-item-is-rentable');
        if (!elLabel) {
            elLabel = $.CreatePanel('Label', elPanel, 'id-loadout-item-is-rentable', {
                html: 'true',
                class: 'item-tile__rental-expiration stratum-regular-italic',
                text: '#item-rental-time-remaining'
            });
        }
        let slot = elPanel.GetAttributeString('data-slot', '');
        let itemId = LoadoutAPI.GetItemID(team, slot);
        if (!InventoryAPI.IsRental(itemId)) {
            elLabel.AddClass('hide');
            return;
        }
        let expirationDate = InventoryAPI.GetExpirationDate(itemId);
        if (expirationDate <= 0) {
            elLabel.AddClass('hide');
            return;
        }
        let oLocData = FormatText.FormatRentalTime(expirationDate);
        elLabel.SetHasClass('item-expired', oLocData.isExpired);
        elLabel.SetDialogVariable('time-remaining', oLocData.time);
        elLabel.text = $.Localize(oLocData.locString, elLabel);
        elLabel.RemoveClass('hide');
    }
    function OverrideTeam(team, slot) {
        let noteamSlots = ['musickit', 'spray0', 'flair0'];
        return noteamSlots.includes(slot) ? 'noteam' : team;
    }
    function LoadoutSlotItemTileEvents(elPanel) {
        elPanel.SetPanelEvent('onactivate', () => {
            ClearItemIdFilter();
            FilterByItemType(elPanel.Data().itemid, true);
        });
        elPanel.SetPanelEvent('onmouseover', () => {
            m_mouseOverSlot = elPanel.GetAttributeString('data-slot', '');
            UpdateCharModel(m_selectedTeam, LoadoutAPI.GetItemID(m_selectedTeam, m_mouseOverSlot));
            UiToolkitAPI.ShowCustomLayoutParametersTooltip('loudout-item-image-' + m_mouseOverSlot, 'JsLoadoutItemTooltip', 'file://{resources}/layout/tooltips/tooltip_loadout_item.xml', 'itemid=' + elPanel.Data().itemid +
                '&' + 'slot=' + m_mouseOverSlot +
                '&' + 'team=' + m_selectedTeam +
                '&' + 'nameonly=' + 'true');
        });
        elPanel.SetPanelEvent('onmouseout', () => {
            m_mouseOverSlot = '';
            elPanel.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideCustomLayoutTooltip('JsLoadoutItemTooltip'); });
        });
        elPanel.SetPanelEvent('oncontextmenu', () => {
            let slot = elPanel.GetAttributeString('data-slot', '');
            let filterValue = '';
            if (LoadoutAPI.IsShuffleEnabled(m_selectedTeam, slot))
                filterValue = 'shuffle_slot_' + m_selectedTeam;
            else
                filterValue = 'loadout_slot_' + m_selectedTeam;
            if (slot === 'spray0')
                filterValue += '&contextmenuparam=graffiti';
            OpenContextMenu(elPanel, filterValue);
        });
        elPanel.SetDraggable(true);
        $.RegisterEventHandler('DragStart', elPanel, (elPanel, drag) => {
            if (m_mouseOverSlot !== null) {
                let itemid = LoadoutAPI.GetItemID(m_selectedTeam, m_mouseOverSlot);
                let bShuffle = LoadoutAPI.IsShuffleEnabled(m_selectedTeam, m_mouseOverSlot);
                OnDragStart(elPanel, drag, itemid, bShuffle);
            }
        });
        $.RegisterEventHandler('DragEnd', elPanel, (elRadial, elDragImage) => {
            OnDragEnd(elDragImage);
        });
    }
    function OpenContextMenu(elPanel, filterValue) {
        UiToolkitAPI.HideCustomLayoutTooltip('JsLoadoutItemTooltip');
        let filterForContextMenuEntries = '&populatefiltertext=' + filterValue;
        let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_inventory_item.xml', 'itemid=' + elPanel.Data().itemid + filterForContextMenuEntries, () => { });
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
    }
    function ItemDragTargetEvents(elPanel) {
        $.RegisterEventHandler('DragEnter', elPanel, () => {
            elPanel.AddClass('loadout-drag-enter');
            m_mouseOverSlot = elPanel.GetAttributeString('data-slot', '');
        });
        $.RegisterEventHandler('DragLeave', elPanel, () => {
            elPanel.RemoveClass('loadout-drag-enter');
            m_mouseOverSlot = '';
        });
        $.RegisterEventHandler('DragDrop', elPanel, (dispayId, elDragImage) => {
            OnDragDrop(elPanel, elDragImage);
        });
    }
    function OnDragStart(elDragSource, drag, itemid, bShuffle) {
        let elDragImage = $.CreatePanel('ItemImage', $.GetContextPanel(), '', {
            class: 'loadout-drag-icon',
            textureheight: '128',
            texturewidth: '128'
        });
        elDragImage.itemid = itemid;
        elDragImage.Data().bShuffle = bShuffle;
        TintSprayImage(elDragImage, itemid);
        drag.displayPanel = elDragImage;
        drag.offsetX = 96;
        drag.offsetY = 64;
        drag.removePositionBeforeDrop = false;
        elDragImage.AddClass('drag-start');
        m_elDragSource = elDragSource;
        m_elDragSource.AddClass('dragged-away');
        m_dragItemId = itemid;
        UpdateValidDropTargets();
        let elItemList = $('#id-loadout-item-list');
        elItemList.hittest = false;
        elItemList.hittestchildren = false;
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_pickup', 'MOUSE');
    }
    function OnDragEnd(elDragImage) {
        elDragImage.DeleteAsync(0.1);
        elDragImage.AddClass('drag-end');
        m_elDragSource.RemoveClass('dragged-away');
        m_dragItemId = '';
        UpdateValidDropTargets();
        let elItemList = $('#id-loadout-item-list');
        elItemList.hittest = true;
        elItemList.hittestchildren = true;
    }
    function OnDragDrop(elPanel, elDragImage) {
        let newSlot = elPanel.GetAttributeString('data-slot', '');
        if (newSlot !== null) {
            if (newSlot === 'side_slots' && m_selectedTeam === elPanel.GetAttributeString('data-team', '')) {
                let itemId = elDragImage.itemid;
                let bShuffle = elDragImage.Data().bShuffle;
                if (ItemInfo.IsSpraySealed(itemId)) {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_decodable.xml');
                    let oSettings = {
                        item_id: itemId,
                        work_type: 'decodeable'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else {
                    let category = InventoryAPI.GetLoadoutCategory(itemId);
                    if (_BCanFitIntoNonWeaponSlot(category, m_selectedTeam)) {
                        let slot = category === 'spray' ? 'spray0' : category === 'clothing' ? 'clothing_hands' : category;
                        let team = OverrideTeam(m_selectedTeam, slot);
                        let elRow = $.GetContextPanel().FindChildInLayoutFile('id-loadout-row-slots-' + m_selectedTeam);
                        let elItemPanel = elRow.FindChildInLayoutFile('id-loadout-row-slots-' + slot + '-' + m_selectedTeam);
                        let isSameId = elDragImage.itemid === elItemPanel.Data().itemid ? true : false;
                        let equipSuccess = TryEquipItemInSlot(team, itemId, slot);
                        PlayDropSounds(equipSuccess, isSameId);
                        if (equipSuccess && bShuffle) {
                            LoadoutAPI.SetShuffleEnabled(team, slot, true);
                        }
                    }
                }
                return;
            }
            let canEquip = LoadoutAPI.CanEquipItemInSlot(m_selectedTeam, elDragImage.itemid, newSlot);
            if (canEquip) {
                let itemId = elDragImage.itemid;
                let bShuffle = elDragImage.Data().bShuffle;
                if (InventoryAPI.IsValidItemID(itemId)) {
                    let itemDefIndex = InventoryAPI.GetItemDefinitionIndex(itemId);
                    let oldSlot = LoadoutAPI.GetSlotEquippedWithDefIndex(m_selectedTeam, itemDefIndex);
                    let isSameId = elDragImage.itemid === elPanel.Data().itemid ? true : false;
                    let equipSuccess = TryEquipItemInSlot(m_selectedTeam, itemId, newSlot);
                    PlayDropSounds(equipSuccess, isSameId);
                    if (equipSuccess && bShuffle) {
                        LoadoutAPI.SetShuffleEnabled(m_selectedTeam, newSlot, true);
                    }
                    elPanel.TriggerClass('drop-target');
                    $.Schedule(.5, () => { if (elPanel) {
                        elPanel.RemoveClass('drop-target');
                    } });
                    elPanel.hittestchildren = false;
                    $.Schedule(1, () => { elPanel.hittestchildren = true; });
                    let oldTile = FindGridTile(oldSlot);
                    if (oldTile) {
                        oldTile.AddClass('old-item-slot');
                        $.Schedule(.5, () => { if (oldTile) {
                            oldTile.RemoveClass('old-item-slot');
                        } });
                    }
                }
            }
        }
    }
    function PlayDropSounds(equipSuccess, isSameId) {
        if (equipSuccess && !isSameId) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_putdown', 'MOUSE');
        }
        else {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_notequipped', 'MOUSE');
        }
    }
    const m_aActiveUsedColumns = [
        'id-loadout-column1',
        'id-loadout-column2',
        'id-loadout-column3',
    ];
    function UpdateValidDropTargets() {
        if (m_dragItemId && InventoryAPI.IsValidItemID(m_dragItemId)) {
            let category = InventoryAPI.GetLoadoutCategory(m_dragItemId);
            if (!category || _BCanFitIntoNonWeaponSlot(category, m_selectedTeam)) {
                let elBtn = $.GetContextPanel().FindChildInLayoutFile('id-loadout-agent-' + m_selectedTeam);
                elBtn.SetHasClass('loadout-valid-target', true);
                return;
            }
        }
        let aSectionSuffexes = ['ct', 't'];
        for (let suffex of aSectionSuffexes) {
            let elBtn = $.GetContextPanel().FindChildInLayoutFile('id-loadout-agent-' + suffex);
            elBtn.SetHasClass('loadout-valid-target', false);
        }
        let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + m_selectedTeam);
        let elGrid = elSection.FindChildInLayoutFile('id-loadout-grid-slots-' + m_selectedTeam);
        for (let columnId of m_aActiveUsedColumns) {
            let elColumn = elGrid.FindChildInLayoutFile(columnId);
            for (let elPanel of elColumn.Children()) {
                let slot = elPanel.GetAttributeString('data-slot', '');
                let canEquip = LoadoutAPI.CanEquipItemInSlot(m_selectedTeam, m_dragItemId, slot);
                elPanel.SetHasClass('loadout-valid-target', canEquip);
            }
        }
    }
    function FindGridTile(oldSlot) {
        let elGrid = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-slots-' + m_selectedTeam);
        {
            for (let columnId of m_aActiveUsedColumns) {
                let elColumn = elGrid.FindChildInLayoutFile(columnId);
                for (let elPanel of elColumn.Children()) {
                    let slot = elPanel.GetAttributeString('data-slot', '');
                    if (slot === oldSlot) {
                        return elPanel;
                    }
                }
            }
        }
        return null;
    }
    function InitSortDropDown() {
        let elDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-sort');
        let count = InventoryAPI.GetSortMethodsCount();
        for (let i = 0; i < count; i++) {
            let id = InventoryAPI.GetSortMethodByIndex(i);
            let newEntry = $.CreatePanel('Label', elDropdown, id, { class: 'DropDownMenu' });
            newEntry.text = $.Localize('#' + id);
            elDropdown.AddOption(newEntry);
        }
        elDropdown.SetSelected(GameInterfaceAPI.GetSettingString("cl_loadout_saved_sort"));
    }
    function UpdateFilters() {
        let group = GetSelectedGroup();
        if (!_BIsSlotAndTeamConfigurationValid(group, m_selectedTeam)) {
            $.DispatchEvent("Activated", $.GetContextPanel().FindChildInLayoutFile('id-loadout-select-team-btn-t'), "mouse");
            return;
        }
        let elClearBtn = $.GetContextPanel().FindChildInLayoutFile('id-loadout-clear-filters');
        elClearBtn.visible = (group != 'all' || m_filterItemId !== '');
        let itemDefNames = null;
        if (['secondary', 'smg', 'rifle'].includes(group)) {
            itemDefNames = JSON.parse(LoadoutAPI.GetGroupItemDefNames(m_selectedTeam, group));
            itemDefNames.sort();
        }
        let elItemDefDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-itemdef');
        if (itemDefNames) {
            let prevSelected = GetSelectedItemDef();
            elItemDefDropdown.RemoveAllOptions();
            {
                let elOption = $.CreatePanel('Label', elItemDefDropdown, 'all', { class: 'DropDownMenu' });
                elOption.text = $.Localize('#inv_filter_all_' + group);
                elItemDefDropdown.AddOption(elOption);
            }
            let itemDefNames = JSON.parse(LoadoutAPI.GetGroupItemDefNames(m_selectedTeam, group)).sort();
            for (let itemDefName of itemDefNames) {
                let itemDefIndex = InventoryAPI.GetItemDefinitionIndexFromDefinitionName(itemDefName);
                let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(itemDefIndex, 0);
                let elOption = $.CreatePanel('Label', elItemDefDropdown, itemDefName, { class: 'DropDownMenu' });
                elOption.text = $.Localize(InventoryAPI.GetItemBaseName(itemId));
                elItemDefDropdown.AddOption(elOption);
                ;
            }
            elItemDefDropdown.visible = true;
            if (elItemDefDropdown.HasOption(prevSelected))
                elItemDefDropdown.SetSelected(prevSelected);
            else
                elItemDefDropdown.SetSelected('all');
        }
        else {
            elItemDefDropdown.visible = false;
            elItemDefDropdown.SetSelected('all');
            UpdateItemList();
        }
        UpdateGridFilterIcons();
    }
    LoadoutGrid.UpdateFilters = UpdateFilters;
    function UpdateItemList() {
        let loadoutSlotParams = m_selectedTeam;
        let group = GetSelectedGroup();
        loadoutSlotParams += ',flexible_loadout_group:' + (group == 'all' ? 'any' : group);
        let elItemDefDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-itemdef');
        if (elItemDefDropdown.visible) {
            let itemDefName = GetSelectedItemDef();
            if (itemDefName != 'all')
                loadoutSlotParams += ',item_definition:' + itemDefName;
        }
        let elSortDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-sort');
        let sortType = elSortDropdown.GetSelected().id;
        if (GameInterfaceAPI.GetSettingString("cl_loadout_saved_sort") != sortType) {
            GameInterfaceAPI.SetSettingString("cl_loadout_saved_sort", sortType);
            GameInterfaceAPI.ConsoleCommand("host_writeconfig");
        }
        if (m_filterItemId !== '' &&
            InventoryAPI.IsValidItemID(m_filterItemId) &&
            group === InventoryAPI.GetRawDefinitionKey(m_filterItemId, 'flexible_loadout_group') &&
            m_updatedFromShowItemInLoadout) {
            loadoutSlotParams += ',item_id:' + m_filterItemId;
        }
        else if (m_filterItemId) {
            ClearItemIdFilter();
        }
        let elItemList = $.GetContextPanel().FindChildInLayoutFile('id-loadout-item-list');
        $.DispatchEvent('SetInventoryFilter', elItemList, 'any', 'any', 'any', sortType, loadoutSlotParams, '');
        UpdateGridFilterIcons();
        ShowHideItemFilterText(m_filterItemId != '');
    }
    LoadoutGrid.UpdateItemList = UpdateItemList;
    function ClearFilters() {
        let elGroupDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-group');
        if ($.GetContextPanel().FindChildInLayoutFile('id-loadout-clear-filters-label').visible) {
            ShowHideItemFilterText(false);
            ClearItemIdFilter();
            UpdateItemList();
            return;
        }
        elGroupDropdown.SetSelected('all');
    }
    LoadoutGrid.ClearFilters = ClearFilters;
    function ShowHideItemFilterText(bShow) {
        $.GetContextPanel().FindChildInLayoutFile('id-loadout-clear-filters-label').visible = bShow;
    }
    function FilterByItemType(itemId, bToggle = false) {
        let group = InventoryAPI.GetRawDefinitionKey(itemId, 'flexible_loadout_group');
        let elGroupDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-group');
        let elItemDefDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-itemdef');
        if (bToggle && GetSelectedGroup() == group && !elItemDefDropdown.visible) {
            elGroupDropdown.SetSelected('all');
            return;
        }
        elGroupDropdown.SetSelected(group);
        if (elItemDefDropdown.visible) {
            let itemDefName = InventoryAPI.GetItemDefinitionName(itemId);
            if (bToggle && GetSelectedItemDef() == itemDefName)
                elItemDefDropdown.SetSelected('all');
            else
                elItemDefDropdown.SetSelected(itemDefName);
        }
    }
    function ToggleGroupDropdown(group, bDisallowToggle = false) {
        let elGroupDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-group');
        let elItemDefDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-itemdef');
        if (GetSelectedGroup() == group && !bDisallowToggle) {
            if (GetSelectedItemDef() != 'all')
                elItemDefDropdown.SetSelected('all');
            else
                elGroupDropdown.SetSelected('all');
        }
        else {
            elGroupDropdown.SetSelected(group);
            if (elItemDefDropdown.visible)
                elItemDefDropdown.SetSelected('all');
        }
    }
    LoadoutGrid.ToggleGroupDropdown = ToggleGroupDropdown;
    function OnItemTileLoaded(elItemTile) {
        elItemTile.SetPanelEvent('onactivate', () => { });
        elItemTile.SetDraggable(true);
        $.RegisterEventHandler('DragStart', elItemTile, (elItemTile, drag) => {
            $.DispatchEvent('CSGOInventoryHideTooltip');
            OnDragStart(elItemTile, drag, elItemTile.GetAttributeString('itemid', '0'), false);
        });
        $.RegisterEventHandler('DragEnd', elItemTile, (elItemTile, elDragImage) => {
            OnDragEnd(elDragImage);
        });
    }
    function ShowLoadoutForItem(itemId) {
        if (!DoesItemTeamMatchTeamRequired(m_selectedTeam, itemId)) {
            ChangeSelectedTeam();
        }
        m_filterItemId = itemId;
        m_updatedFromShowItemInLoadout = true;
        let elClearBtn = $.GetContextPanel().FindChildInLayoutFile('id-loadout-clear-filters');
        elClearBtn.SetDialogVariable('item_name', InventoryAPI.GetItemName(m_filterItemId));
        ShowHideItemFilterText(true);
        FilterByItemType(itemId);
    }
    function ClearItemIdFilter() {
        m_filterItemId = m_filterItemId !== '' ? '' : '';
    }
    function DoesItemTeamMatchTeamRequired(team, id) {
        if (team === 't') {
            return ItemInfo.IsItemT(id) || ItemInfo.IsItemAnyTeam(id);
        }
        if (team === 'ct') {
            return ItemInfo.IsItemCt(id) || ItemInfo.IsItemAnyTeam(id);
        }
        return false;
    }
    function UpdateGridFilterIcons() {
        let selectedGroup = GetSelectedGroup();
        let selectedItemDef = GetSelectedItemDef();
        let elGrid = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-slots-' + m_selectedTeam);
        if (elGrid) {
            for (let group of ['secondary0', 'secondary', 'smg', 'rifle']) {
                let btn = elGrid.FindChildInLayoutFile('id-loadout-btn-' + group);
                if (btn) {
                    btn.checked = (group == selectedGroup && (!selectedItemDef || selectedItemDef == 'all'));
                }
            }
            for (let columnId of m_aActiveUsedColumns) {
                let elColumn = elGrid.FindChildInLayoutFile(columnId);
                for (let elPanel of elColumn.Children()) {
                    let elFilterIcon = elPanel.FindChildInLayoutFile('id-loadout-item-filter-icon');
                    if (elFilterIcon) {
                        let slot = elPanel.GetAttributeString('data-slot', '');
                        let itemId = LoadoutAPI.GetItemID(m_selectedTeam, slot);
                        let itemDef = InventoryAPI.GetItemDefinitionName(itemId);
                        elFilterIcon.visible = (itemDef == selectedItemDef);
                    }
                }
            }
        }
        for (let team of ['ct', 't']) {
            let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + team);
            let elRow = elSection.FindChildInLayoutFile('id-loadout-row-slots-' + team);
            for (let elPanel of elRow.Children()) {
                let elFilterIcon = elPanel.FindChildInLayoutFile('id-loadout-item-filter-icon');
                if (elFilterIcon) {
                    if (team == m_selectedTeam) {
                        let slot = elPanel.GetAttributeString('data-slot', '');
                        elFilterIcon.visible = (slot == selectedGroup);
                    }
                    else {
                        elFilterIcon.visible = false;
                    }
                }
            }
        }
        UpdateCharModel(m_selectedTeam);
    }
    function UpdateGridShuffleIcons() {
        let elGrid = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-slots-' + m_selectedTeam);
        if (elGrid) {
            for (let columnId of m_aActiveUsedColumns) {
                let elColumn = elGrid.FindChildInLayoutFile(columnId);
                for (let elPanel of elColumn.Children()) {
                    let elShuffleIcon = elPanel.FindChildInLayoutFile('id-loadout-item-shuffle-icon');
                    if (elShuffleIcon) {
                        let slot = elPanel.GetAttributeString('data-slot', '');
                        elShuffleIcon.visible = LoadoutAPI.IsShuffleEnabled(OverrideTeam(m_selectedTeam, slot), slot);
                    }
                }
            }
        }
        for (let team of ['ct', 't']) {
            let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + team);
            let elRow = elSection.FindChildInLayoutFile('id-loadout-row-slots-' + team);
            for (let elPanel of elRow.Children()) {
                let elShuffleIcon = elPanel.FindChildInLayoutFile('id-loadout-item-shuffle-icon');
                if (elShuffleIcon) {
                    let slot = elPanel.GetAttributeString('data-slot', '');
                    elShuffleIcon.visible = LoadoutAPI.IsShuffleEnabled(OverrideTeam(team, slot), slot);
                }
            }
        }
    }
    function GetSelectedGroup() {
        let elDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-group');
        return (elDropdown?.visible ? elDropdown.GetSelected()?.id : null) ?? 'all';
    }
    function GetSelectedItemDef() {
        let elDropdown = $.GetContextPanel().FindChildInLayoutFile('id-loadout-filter-itemdef');
        return (elDropdown?.visible ? elDropdown.GetSelected()?.id : null) ?? 'all';
    }
    function GetShuffleItems(team, slot) {
        return JSON.parse(LoadoutAPI.GetShuffleItems(team, slot));
    }
    function RegisterGridItemEvents(team) {
        let elSection = $.GetContextPanel().FindChildInLayoutFile('id-loadout-grid-section-' + team);
        let elGrid = elSection.FindChildInLayoutFile('id-loadout-grid-slots-' + team);
        for (let column of elGrid.Children()) {
            let aPanels = column.Children().filter(panel => panel.GetAttributeString('data-slot', '') !== '');
            for (let i = 0; i < aPanels.length; i++) {
                if (column.GetAttributeString('data-slot', '') !== 'equipment' &&
                    column.GetAttributeString('data-slot', '') !== 'grenade') {
                    LoadoutSlotItemTileEvents(aPanels[i]);
                    ItemDragTargetEvents(aPanels[i]);
                }
            }
        }
    }
    function TryEquipItemInSlot(szTeam, szItemID, szSlot) {
        let bSuccess = LoadoutAPI.EquipItemInSlot(szTeam, szItemID, szSlot);
        if (!bSuccess && LoadoutAPI.CanEquipItemInSlot(szTeam, szItemID, szSlot)) {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#LoadoutLockedPopupTitle'), $.Localize('#LoadoutLockedPopupText'), '', () => { });
        }
        return bSuccess;
    }
    {
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), OnReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), OnUnreadyForDisplay);
        $.RegisterForUnhandledEvent('LoadoutFilterByItemType', FilterByItemType);
        $.RegisterEventHandler('CSGOInventoryItemLoaded', $.GetContextPanel(), OnItemTileLoaded);
        $.RegisterForUnhandledEvent('ShowLoadoutForItem', ShowLoadoutForItem);
    }
})(LoadoutGrid || (LoadoutGrid = {}));
