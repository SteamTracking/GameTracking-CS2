"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="iteminfo.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var ItemContextEntries;
(function (ItemContextEntries) {
    function FilterEntries(id, populateFilterText) {
        const bHasFilter = populateFilterText !== "(not found)";
        return _Entries.filter((entry) => {
            if (entry.exclusiveFilter) {
                if (!entry.exclusiveFilter.includes(populateFilterText))
                    return false;
            }
            else if (bHasFilter && entry.populateFilter) {
                if (!entry.populateFilter.includes(populateFilterText))
                    return false;
            }
            else {
                if (bHasFilter)
                    return false;
            }
            if (!entry.bActionIsRentalAware && InventoryAPI.IsRental(id))
                return false;
            return entry.AvailableForItem(id);
        });
    }
    ItemContextEntries.FilterEntries = FilterEntries;
    const _Entries = [
        {
            name: 'preview',
            populateFilter: ['lootlist', 'loadout', 'loadout_slot_t', 'loadout_slot_ct', 'tradeup_items', 'tradeup_ingredients'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                if (InventoryAPI.DoesItemMatchDefinitionByName(id, "Remove Keychain Tool"))
                    return true;
                if (InventoryAPI.DoesItemMatchDefinitionByName(id, "sticker_display_case"))
                    return true;
                return ItemInfo.IsPreviewable(id);
            },
            OnSelected: (id, contextmenuparam) => {
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent("InventoryItemPreview", id, contextmenuparam);
            }
        },
        {
            name: 'view_highlight_reel',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return !!InventoryAPI.GetItemAttributeValue(id, '{uint32}keychain slot 0 highlight');
            },
            OnSelected: (id) => {
                const reelId = InventoryAPI.GetItemAttributeValue(id, '{uint32}keychain slot 0 highlight');
                UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-videoclip-' + reelId, 'file://{resources}/layout/popups/popup_videoclip.xml', 'reelid=' + reelId + '&' +
                    'itemid=' + id);
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'open_season_stats_panel',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return (ItemInfo.ItemDefinitionNameStartsWith(id, 'premier season coin'));
            },
            OnSelected: (id) => {
                const season = InventoryAPI.GetItemAttributeValue(id, 'premier season');
                UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-season-stats', 'file://{resources}/layout/popups/popup_season_stats.xml', 'seasonid=' + season + '&' +
                    'itemid=' + id);
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'bulkretrieve',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                const defName = InventoryAPI.GetItemDefinitionName(id);
                return (defName === 'casket') && !!InventoryAPI.GetItemAttributeValue(id, 'modification date');
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const defName = InventoryAPI.GetItemDefinitionName(id);
                if (defName === 'casket') {
                    if (InventoryAPI.GetItemAttributeValue(id, 'items count')) {
                        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=loadcontents' +
                            '&nextcapability=casketretrieve' +
                            '&spinner=1' +
                            '&casket_item_id=' + id +
                            '&subject_item_id=' + id);
                    }
                    else {
                        UiToolkitAPI.ShowGenericPopupOk($.Localize('#popup_casket_title_error_casket_empty'), $.Localize('#popup_casket_message_error_casket_empty'), '', () => { });
                    }
                    return;
                }
            }
        },
        {
            name: 'bulkstore',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            style: (id) => 'BottomSeparator',
            AvailableForItem: (id) => {
                const defName = InventoryAPI.GetItemDefinitionName(id);
                return (defName === 'casket') && !!InventoryAPI.GetItemAttributeValue(id, 'modification date');
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const defName = InventoryAPI.GetItemDefinitionName(id);
                if (defName === 'casket') {
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'casketstore');
                }
            }
        },
        {
            name: 'openloadout',
            style: (id) => 'TopSeparator',
            bActionIsRentalAware: true,
            AvailableForItem: (id) => !!InventoryAPI.GetRawDefinitionKey(id, 'flexible_loadout_group'),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent("ShowLoadoutForItem", id);
            }
        },
        {
            name: 'swap_finish_both',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => _CanSwapFinish(id, 'ct') && _CanSwapFinish(id, 't'),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                EquipItem(id, ['ct', 't']);
            }
        },
        {
            name: 'swap_finish_ct',
            CustomName: (id) => GetItemToReplaceName(id, 'ct'),
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => _CanSwapFinish(id, 'ct'),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                EquipItem(id, ['ct']);
            }
        },
        {
            name: 'swap_finish_t',
            CustomName: (id) => GetItemToReplaceName(id, 't'),
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => _CanSwapFinish(id, 't'),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                EquipItem(id, ['t']);
            }
        },
        {
            name: 'flair',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                return InventoryAPI.GetDefaultSlot(id) === 'flair0' && (!InventoryAPI.IsEquipped(id, "noteam") || (InventoryAPI.GetRawDefinitionKey(id, 'item_sub_position2') !== ''));
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                EquipItem(id, ['noteam']);
            }
        },
        {
            name: 'equip_spray',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => ItemInfo.IsSprayPaint(id) && !InventoryAPI.IsEquipped(id, "noteam"),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                EquipItem(id, ['noteam'], 'spray0');
            }
        },
        {
            name: 'equip_tournament_spray',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'tournament_journal_') && (InventoryAPI.GetRawDefinitionKey(id, 'item_sub_position2') === 'spray0'));
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_tournament_select_spray.xml', 'journalid=' + id);
            }
        },
        {
            name: 'equip_musickit',
            CustomName: (id) => GetItemToReplaceName(id, 'noteam'),
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => InventoryAPI.GetDefaultSlot(id) === 'musickit' && !InventoryAPI.IsEquipped(id, "noteam"),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const isMusicvolumeOn = InventoryAPI.TestMusicVolume();
                if (isMusicvolumeOn) {
                    $.DispatchEvent('CSGOPlaySoundEffect', 'equip_musickit', 'MOUSE');
                    EquipItem(id, ['noteam']);
                }
            }
        },
        {
            name: 'unequip',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let availableForSlots = ['flair0', 'spray0'];
                return InventoryAPI.IsEquipped(id, "noteam") && availableForSlots.includes(InventoryAPI.GetDefaultSlot(id));
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot('noteam', '0', InventoryAPI.GetDefaultSlot(id));
            },
        },
        {
            name: 'open_watch_panel_pickem',
            AvailableForItem: (id) => {
                if (GameStateAPI.GetMapBSPName())
                    return false;
                return (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'tournament_journal_') && (InventoryAPI.GetRawDefinitionKey(id, 'item_sub_position2') === 'spray0'));
            },
            OnSelected: (id) => {
                $.DispatchEvent('OpenWatchMenu');
                $.DispatchEvent('ShowActiveTournamentPage', '');
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'getprestige',
            AvailableForItem: (id) => {
                return (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'xpgrant') &&
                    (FriendsListAPI.GetFriendLevel(MyPersonaAPI.GetXuid()) >= InventoryAPI.GetMaxLevel()));
            },
            OnSelected: (id) => {
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                let oSettings = {
                    item_id: '0',
                    show_work_type_warning: false,
                    work_type: 'prestigecheck'
                };
                elPanel.Data().oSettings = oSettings;
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: (id) => InventoryAPI.IsRental(id) ? 'preview' : 'useitem',
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                if (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'tournament_pass_'))
                    return true;
                if (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'XpShopTicket'))
                    return true;
                if (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'Remove Keychain Tool '))
                    return true;
                if (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'xpgrant')) {
                    return (FriendsListAPI.GetFriendLevel(MyPersonaAPI.GetXuid()) < InventoryAPI.GetMaxLevel());
                }
                if (!InventoryAPI.IsTool(id))
                    return false;
                const season = InventoryAPI.GetItemAttributeValue(id, 'season access');
                if (season != undefined)
                    return true;
                return false;
            },
            OnSelected: (id) => {
                if (InventoryAPI.IsRental(id)) {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: id,
                        inspect_only: true
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else if (ItemInfo.ItemDefinitionNameSubstrMatch(id, 'tournament_pass_') && !ItemInfo.ItemDefinitionNameSubstrMatch(id, '_credits')) {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_decodable.xml');
                    let oSettings = {
                        item_id: id,
                        work_type: 'decodeable'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: id,
                        work_type: 'useitem'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'usespray',
            populateFilter: ['inspect'],
            AvailableForItem: (id) => ItemInfo.IsSpraySealed(id),
            OnSelected: (id) => {
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_decodable.xml');
                let oSettings = {
                    item_id: id,
                    work_type: 'decodeable'
                };
                elPanel.Data().oSettings = oSettings;
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'secure_connection_line',
            AvailableForItem: (id) => {
                return ItemInfo.ItemHasCapability(id, 'decodable') &&
                    !!InventoryAPI.GetItemAttributeValue(id, '{uint32}volatile container') &&
                    InventoryAPI.IsRental(id) &&
                    (InventoryAPI.GetItemQuality(id) === 14);
            },
            bActionIsRentalAware: true,
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_offers_laptop.xml');
                let oSettings = {
                    item_id: id,
                    work_type: 'decodeable',
                };
                elPanel.Data().oSettings = oSettings;
            }
        },
        {
            name: (id) => {
                if (InventoryAPI.GetItemAttributeValue(id, '{uint32}volatile container'))
                    return InventoryAPI.IsRental(id) ? 'inspect_contents' : 'open_terminal';
                else if (InventoryAPI.GetDecodeableRestriction(id) === 'restricted' && !InventoryAPI.IsTool(id) && !InventoryAPI.CanOpenForRental(id))
                    return 'look_inside';
                else if (InventoryAPI.IsRental(id))
                    return 'look_inside';
                else
                    return 'open_package';
            },
            AvailableForItem: (id) => {
                return ItemInfo.ItemHasCapability(id, 'decodable');
            },
            bActionIsRentalAware: true,
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                if (InventoryAPI.GetItemAttributeValue(id, '{uint32}volatile container')
                    && InventoryAPI.IsRental(id)) {
                    $.DispatchEvent("LootlistItemPreview", InventoryAPI.GetLootListItemIdByIndex(id, 0), id +
                        ',' + id);
                    return;
                }
                if (InventoryAPI.GetChosenActionItemsCount(id, 'decodable') === 0) {
                    if (InventoryAPI.IsTool(id)) {
                        $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'decodable');
                    }
                    else if (InventoryAPI.GetItemAttributeValue(id, '{uint32}volatile container')) {
                        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_offers_laptop.xml');
                        let oSettings = {
                            item_id: id,
                            work_type: 'decodeable',
                        };
                        elPanel.Data().oSettings = oSettings;
                        return;
                    }
                    else {
                        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_capability_decodable.xml');
                        let oSettings = {
                            item_id: id,
                            work_type: 'decodeable'
                        };
                        elPanel.Data().oSettings = oSettings;
                    }
                    $.DispatchEvent('ContextMenuEvent', '');
                    return;
                }
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'decodable');
            }
        },
        {
            name: (id) => {
                if (InventoryAPI.IsRental(id))
                    return 'preview';
                if (InventoryAPI.GetItemDefinitionName(id) === 'casket') {
                    return InventoryAPI.GetItemAttributeValue(id, 'modification date') ? 'yourcasket' : 'newcasket';
                }
                return 'nameable';
            },
            style: (id) => {
                const defName = InventoryAPI.GetItemDefinitionName(id);
                return (defName === 'casket' || defName === 'Name Tag') ? '' : 'TopSeparator';
            },
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                if (InventoryAPI.IsRental(id))
                    return InventoryAPI.IsTool(id) && ItemInfo.ItemHasCapability(id, 'nameable');
                return ItemInfo.ItemHasCapability(id, 'nameable');
            },
            OnSelected: (id) => {
                if (InventoryAPI.IsRental(id)) {
                    $.DispatchEvent('ContextMenuEvent', '');
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: id,
                        inspect_only: true
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else if (InventoryAPI.GetItemDefinitionName(id) === 'casket') {
                    const fauxNameTag = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1200, 0);
                    const noteText = InventoryAPI.GetItemAttributeValue(id, 'modification date') ? 'yourcasket' : 'newcasket';
                    $.DispatchEvent('ContextMenuEvent', '');
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_nameable.xml');
                    let oSettings = {
                        item_id: id,
                        tool_id: fauxNameTag,
                        work_type: 'nameable',
                        async_work_type_warning_text: '#popup_' + noteText + '_warning'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else if (DoesNotHaveChosenActionItems(id, 'nameable')) {
                    const nameTagId = '', itemToNameId = id;
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_nameable.xml');
                    let oSettings = {
                        item_id: itemToNameId,
                        tool_id: nameTagId,
                        work_type: 'nameable'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else {
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'nameable');
                    $.DispatchEvent('ContextMenuEvent', '');
                }
            }
        },
        {
            name: (id) => InventoryAPI.IsRental(id) ? 'preview_can_keychain' : 'can_keychain',
            populateFilter: ['inspect', 'preview', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => ItemInfo.IsKeychain(id) && ItemInfo.ItemHasCapability(id, 'can_keychain'),
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_keychain');
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'can_unwrap_sticker',
            style: (id) => 'TopSeparator',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => ItemInfo.IsKeychain(id) && ItemInfo.ItemHasCapability(id, 'can_keychain') &&
                !!InventoryAPI.GetItemAttributeValue(id, '{uint32}keychain slot 0 sticker'),
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
                let oSettings = {
                    popup_panel: elPanel,
                    item_id: id,
                    work_type: 'can_wrap_sticker'
                };
                elPanel.Data().oSettings = oSettings;
            }
        },
        {
            name: 'can_keychain',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return ItemInfo.ItemHasCapability(id, 'can_keychain') &&
                    InventoryAPI.GetItemKeychainSlotCount(id) > InventoryAPI.GetItemKeychainCount(id);
            },
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_keychain');
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'remove_keychain',
            AvailableForItem: (id) => InventoryAPI.DoesItemMatchDefinitionByName(id, "Remove Keychain Tool"),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'remove_keychain');
            }
        },
        {
            name: 'remove_keychain',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => ItemInfo.ItemHasCapability(id, 'can_keychain') && InventoryAPI.GetItemKeychainCount(id) > 0,
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
                let oSettings = {
                    popup_panel: elPanel,
                    item_id: id,
                    work_type: 'remove_keychain'
                };
                elPanel.Data().oSettings = oSettings;
            }
        },
        {
            name: (id) => InventoryAPI.IsRental(id) ? 'preview_can_sticker' : 'can_sticker',
            populateFilter: ['inspect', 'preview', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => ItemInfo.IsSticker(id) && ItemInfo.ItemHasCapability(id, 'can_sticker'),
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_sticker');
            }
        },
        {
            name: 'can_sticker',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return ItemInfo.ItemHasCapability(id, 'can_sticker') &&
                    InventoryAPI.GetItemStickerSlotCount(id) > InventoryAPI.GetItemStickerCount(id);
            },
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_sticker');
            }
        },
        {
            name: 'can_wrap_sticker',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return InventoryAPI.DoesItemMatchDefinitionByName(id, "sticker_display_case");
            },
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_wrap_sticker');
            }
        },
        {
            name: 'wrap_sticker',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return ItemInfo.ItemHasCapability(id, 'can_wrap_sticker') &&
                    !InventoryAPI.DoesItemMatchDefinitionByName(id, "sticker_display_case");
            },
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                if (InventoryAPI.GetChosenActionItemsCount(id, 'can_wrap_sticker') > 0) {
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_wrap_sticker');
                }
                else {
                    const defidxWrapper = InventoryAPI.GetItemDefinitionIndexFromDefinitionName("sticker_display_case");
                    const fauxCasket = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxWrapper, 0);
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
                    let oSettings = {
                        popup_panel: elPanel,
                        tool_id: id,
                        item_id: fauxCasket,
                        work_type: 'can_wrap_sticker'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
            }
        },
        {
            name: 'remove_sticker',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => ItemInfo.ItemHasCapability(id, 'can_sticker') && InventoryAPI.GetItemStickerCount(id) > 0,
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_can_sticker.xml');
                let oSettings = {
                    popup_panel: elPanel,
                    item_id: id,
                    work_type: 'remove_sticker'
                };
                elPanel.Data().oSettings = oSettings;
            }
        },
        {
            name: (id) => InventoryAPI.IsRental(id) ? 'preview_can_patch' : 'can_patch',
            populateFilter: ['inspect', 'preview', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => ItemInfo.IsPatch(id) && ItemInfo.ItemHasCapability(id, 'can_patch'),
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_patch');
            }
        },
        {
            name: 'can_patch',
            populateFilter: ['loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            AvailableForItem: (id) => {
                return ItemInfo.ItemHasCapability(id, 'can_patch') &&
                    InventoryAPI.GetItemStickerSlotCount(id) > InventoryAPI.GetItemStickerCount(id);
            },
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_patch');
            }
        },
        {
            name: 'remove_patch',
            AvailableForItem: (id) => ItemInfo.ItemHasCapability(id, 'can_patch') && InventoryAPI.GetItemStickerCount(id) > 0,
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_can_patch.xml');
                let oSettings = {
                    item_id: id,
                    work_type: 'remove_patch'
                };
                elPanel.Data().oSettings = oSettings;
            }
        },
        {
            name: 'recipe',
            AvailableForItem: (id) => ItemInfo.IsRecipe(id),
            OnSelected: (id) => $.DispatchEvent('ContextMenuEvent', ''),
        },
        {
            name: (id) => InventoryAPI.IsRental(id) ? 'preview' : 'can_stattrack_swap',
            AvailableForItem: (id) => ItemInfo.ItemHasCapability(id, 'can_stattrack_swap') && InventoryAPI.IsTool(id),
            bActionIsRentalAware: true,
            OnSelected: (id) => {
                if (InventoryAPI.IsRental(id)) {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: id,
                        inspect_only: true
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else {
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_stattrack_swap');
                }
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'tradeup_add',
            populateFilter: ['tradeup_items'],
            AvailableForItem: (id) => {
                const slot = InventoryAPI.GetDefaultSlot(id);
                return !!slot && slot !== "melee" && slot !== "c4" && slot !== "clothing_hands" && !ItemInfo.IsEquippalbleButNotAWeapon(id) &&
                    (InventoryAPI.CanTradeUp(id) || InventoryAPI.GetNumItemsNeededToTradeUp(id) > 0);
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.AddCraftIngredient(id);
            }
        },
        {
            name: 'tradeup_remove',
            exclusiveFilter: ['tradeup_ingredients'],
            AvailableForItem: (id) => {
                const slot = InventoryAPI.GetDefaultSlot(id);
                return !!slot && slot !== "melee" && slot !== "c4" && slot !== "clothing_hands" && !ItemInfo.IsEquippalbleButNotAWeapon(id);
            },
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.RemoveCraftIngredient(id);
            }
        },
        {
            name: 'open_contract',
            AvailableForItem: (id) => ItemInfo.IsTradeUpContract(id),
            OnSelected: (id) => {
                $.DispatchEvent('ShowTradeUpPanel');
                $.DispatchEvent('ContextMenuEvent', '');
            }
        },
        {
            name: 'usegift',
            AvailableForItem: (id) => InventoryAPI.GetToolType(id) === 'gift',
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const CapDisabledMessage = InventoryAPI.GetItemCapabilityDisabledMessageByIndex(id, 0);
                if (CapDisabledMessage === "") {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: id,
                        show_work_type_warning: false,
                        work_type: 'usegift'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else {
                    const capDisabledMessage = InventoryAPI.GetItemCapabilityDisabledMessageByIndex(id, 0);
                    UiToolkitAPI.ShowGenericPopupOk($.Localize('#inv_context_usegift'), $.Localize(capDisabledMessage), '', () => { });
                }
            }
        },
        {
            name: 'add_to_favorites_both',
            style: (id) => 'TopSeparator',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => CanAddToFavorites(id, 't') && CanAddToFavorites(id, 'ct'),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.AddItemToFavorites('ct', id);
                InventoryAPI.AddItemToFavorites('t', id);
            },
        },
        {
            name: 'add_to_favorites_ct',
            style: (id) => {
                if (CanAddToFavorites(id, 't'))
                    return '';
                return 'TopSeparator';
            },
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: id => CanAddToFavorites(id, 'ct'),
            OnSelected: id => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.AddItemToFavorites('ct', id);
            },
        },
        {
            name: 'remove_from_favorites_ct',
            style: (id) => 'TopSeparator',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => InventoryAPI.ItemIsInFavorites('ct', id),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.RemoveItemFromFavorites('ct', id);
            },
        },
        {
            name: 'add_to_favorites_t',
            style: (id) => {
                if (CanAddToFavorites(id, 'ct') || InventoryAPI.ItemIsInFavorites('ct', id))
                    return '';
                return 'TopSeparator';
            },
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => CanAddToFavorites(id, 't'),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.AddItemToFavorites('t', id);
            },
        },
        {
            name: 'remove_from_favorites_t',
            style: (id) => {
                if (CanAddToFavorites(id, 'ct') || InventoryAPI.ItemIsInFavorites('ct', id))
                    return '';
                return 'TopSeparator';
            },
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => InventoryAPI.ItemIsInFavorites('t', id),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.RemoveItemFromFavorites('t', id);
            },
        },
        {
            name: 'add_to_favorites_noteam',
            style: (id) => 'TopSeparator',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: id => CanAddToFavorites(id, 'noteam'),
            OnSelected: id => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.AddItemToFavorites('noteam', id);
            },
        },
        {
            name: 'remove_from_favorites_noteam',
            style: (id) => 'TopSeparator',
            populateFilter: ['inspect', 'loadout', 'loadout_slot_t', 'loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => InventoryAPI.ItemIsInFavorites('noteam', id),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.RemoveItemFromFavorites('noteam', id);
            },
        },
        {
            name: 'enable_shuffle_slot',
            exclusiveFilter: ['loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                return ['customplayer', 'clothing', 'melee', 'c4', 'musickit', 'equipment2'].includes(category);
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 'ct');
                LoadoutAPI.SetShuffleEnabled(team, slot, true);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'enable_shuffle_slot',
            exclusiveFilter: ['loadout_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                return ['customplayer', 'clothing', 'melee', 'c4', 'musickit', 'equipment2'].includes(category);
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 't');
                LoadoutAPI.SetShuffleEnabled(team, slot, true);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'enable_weapon_shuffle',
            exclusiveFilter: ['loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                if (category != 'secondary' && category != 'smg' && category != 'rifle')
                    return false;
                $.GetContextPanel().SetDialogVariable("weapon_type", $.Localize(InventoryAPI.GetItemBaseName(id)));
                return true;
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 'ct');
                LoadoutAPI.SetShuffleEnabled(team, slot, true);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'enable_weapon_shuffle',
            exclusiveFilter: ['loadout_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                if (category != 'secondary' && category != 'smg' && category != 'rifle')
                    return false;
                $.GetContextPanel().SetDialogVariable("weapon_type", $.Localize(InventoryAPI.GetItemBaseName(id)));
                return true;
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 't');
                LoadoutAPI.SetShuffleEnabled(team, slot, true);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'disable_shuffle_slot',
            exclusiveFilter: ['shuffle_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                return ['customplayer', 'clothing', 'melee', 'c4', 'musickit', 'equipment2'].includes(category);
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 'ct');
                LoadoutAPI.SetShuffleEnabled(team, slot, false);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'disable_shuffle_slot',
            exclusiveFilter: ['shuffle_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                return ['customplayer', 'clothing', 'melee', 'c4', 'musickit', 'equipment2'].includes(category);
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 't');
                LoadoutAPI.SetShuffleEnabled(team, slot, false);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'disable_weapon_shuffle',
            exclusiveFilter: ['shuffle_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                if (category != 'secondary' && category != 'smg' && category != 'rifle')
                    return false;
                $.GetContextPanel().SetDialogVariable("weapon_type", $.Localize(InventoryAPI.GetItemBaseName(id)));
                return true;
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 'ct');
                LoadoutAPI.SetShuffleEnabled(team, slot, false);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'disable_weapon_shuffle',
            exclusiveFilter: ['shuffle_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                const category = InventoryAPI.GetLoadoutCategory(id);
                if (category != 'secondary' && category != 'smg' && category != 'rifle')
                    return false;
                $.GetContextPanel().SetDialogVariable("weapon_type", $.Localize(InventoryAPI.GetItemBaseName(id)));
                return true;
            },
            OnSelected: (id) => {
                const [team, slot] = _GetLoadoutSlot(id, 't');
                LoadoutAPI.SetShuffleEnabled(team, slot, false);
                $.DispatchEvent('ContextMenuEvent', '');
            },
        },
        {
            name: 'intocasket',
            style: (id) => 'TopSeparator',
            AvailableForItem: (id) => InventoryAPI.IsPotentiallyMarketable(id),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                if (InventoryAPI.GetChosenActionItemsCount(id, 'can_collect') > 0) {
                    $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, '', 'can_collect');
                }
                else {
                    const fauxCasket = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1201, 0);
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: fauxCasket,
                        inspect_only: true,
                        show_work_type_warning: false,
                        store_item_id: 'fauxCasket'
                    };
                    elPanel.Data().oSettings = oSettings;
                }
            }
        },
        {
            name: 'sell',
            AvailableForItem: (id) => InventoryAPI.IsMarketable(id),
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_sellOnMarket', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.MarketListingForItem(id, 'create');
            }
        },
        {
            name: 'marketlisting',
            style: (id) => 'TopSeparator',
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                if (MyPersonaAPI.GetLauncherType() === 'perfectworld')
                    return false;
                let unProtectedEscrowValue = InventoryAPI.GetItemAttributeValue(id, '{uint32}trade protected escrow date');
                return ((unProtectedEscrowValue !== undefined) && (unProtectedEscrowValue == 0));
            },
            OnSelected: (id) => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_sellOnMarket', 'MOUSE');
                $.DispatchEvent('ContextMenuEvent', '');
                InventoryAPI.MarketListingForItem(id, 'view');
            }
        },
        {
            name: 'delete',
            style: (id) => !InventoryAPI.IsMarketable(id) ? 'TopSeparator' : '',
            AvailableForItem: (id) => InventoryAPI.IsDeletable(id),
            OnSelected: (id) => {
                $.DispatchEvent('ContextMenuEvent', '');
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                let oSettings = {
                    item_id: id,
                    override_async_btn_style: 'Negative',
                    work_type: 'delete'
                };
                elPanel.Data().oSettings = oSettings;
            }
        },
        {
            name: 'loadout_slot_reset_t',
            exclusiveFilter: ['loadout_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let team = 't';
                let slot = InventoryAPI.GetDefaultSlot(id);
                if (slot == 'musickit')
                    team = 'noteam';
                else if (slot != 'customplayer' && slot != 'clothing_hands' && slot != 'melee' && slot != 'c4' && slot != 'equipment2')
                    return false;
                return id != LoadoutAPI.GetDefaultItem(team, slot);
            },
            OnSelected: (id) => {
                let team = 't';
                let slot = InventoryAPI.GetDefaultSlot(id);
                if (slot == 'musickit')
                    team = 'noteam';
                let defaultId = LoadoutAPI.GetDefaultItem(team, slot);
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot(team, defaultId, slot);
            },
        },
        {
            name: 'loadout_slot_reset_ct',
            exclusiveFilter: ['loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let team = 'ct';
                let slot = InventoryAPI.GetDefaultSlot(id);
                if (slot == 'musickit')
                    team = 'noteam';
                else if (slot != 'customplayer' && slot != 'clothing_hands' && slot != 'melee' && slot != 'c4' && slot != 'equipment2')
                    return false;
                return id != LoadoutAPI.GetDefaultItem(team, slot);
            },
            OnSelected: (id) => {
                let team = 'ct';
                let slot = InventoryAPI.GetDefaultSlot(id);
                if (slot == 'musickit')
                    team = 'noteam';
                let defaultId = LoadoutAPI.GetDefaultItem(team, slot);
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot(team, defaultId, slot);
            },
        },
        {
            name: 'loadout_slot_reset_weapon_t',
            exclusiveFilter: ['loadout_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let team = 't';
                let category = InventoryAPI.GetLoadoutCategory(id);
                if (category != 'secondary' && category != 'smg' && category != 'rifle')
                    return false;
                let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
                let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, defIndex);
                let defaultId = LoadoutAPI.GetDefaultItem(team, slot);
                let defaultDefIndex = InventoryAPI.GetItemDefinitionIndex(defaultId);
                return defIndex != defaultDefIndex;
            },
            OnSelected: (id) => {
                let team = 't';
                let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
                let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, defIndex);
                let defaultId = LoadoutAPI.GetDefaultItem(team, slot);
                let defaultDefIndex = InventoryAPI.GetItemDefinitionIndex(defaultId);
                let preferredId = LoadoutAPI.GetPreferredItemIdForItemDefIndex(team, defaultDefIndex);
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot(team, preferredId, slot);
            },
        },
        {
            name: 'loadout_slot_reset_weapon_ct',
            exclusiveFilter: ['loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let team = 'ct';
                let category = InventoryAPI.GetLoadoutCategory(id);
                if (category != 'secondary' && category != 'smg' && category != 'rifle')
                    return false;
                let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
                let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, defIndex);
                let defaultId = LoadoutAPI.GetDefaultItem(team, slot);
                let defaultDefIndex = InventoryAPI.GetItemDefinitionIndex(defaultId);
                return defIndex != defaultDefIndex;
            },
            OnSelected: (id) => {
                let team = 'ct';
                let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
                let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, defIndex);
                let defaultId = LoadoutAPI.GetDefaultItem(team, slot);
                let defaultDefIndex = InventoryAPI.GetItemDefinitionIndex(defaultId);
                let preferredId = LoadoutAPI.GetPreferredItemIdForItemDefIndex(team, defaultDefIndex);
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot(team, preferredId, slot);
            },
        },
        {
            name: 'loadout_slot_reset_finish_t',
            exclusiveFilter: ['loadout_slot_t'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let category = InventoryAPI.GetLoadoutCategory(id);
                if (category == 'secondary' || category == 'smg' || category == 'rifle')
                    return !InventoryAPI.IsFauxItemID(id);
                else
                    return false;
            },
            OnSelected: (id) => {
                let team = 't';
                let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
                let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, defIndex);
                let fauxId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defIndex, 0);
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot(team, fauxId, slot);
            },
        },
        {
            name: 'loadout_slot_reset_finish_ct',
            exclusiveFilter: ['loadout_slot_ct'],
            bActionIsRentalAware: true,
            AvailableForItem: (id) => {
                let category = InventoryAPI.GetLoadoutCategory(id);
                if (category == 'secondary' || category == 'smg' || category == 'rifle')
                    return !InventoryAPI.IsFauxItemID(id);
                else
                    return false;
            },
            OnSelected: (id) => {
                let team = 'ct';
                let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
                let slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, defIndex);
                let fauxId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defIndex, 0);
                $.DispatchEvent('ContextMenuEvent', '');
                TryEquipItemInSlot(team, fauxId, slot);
            },
        },
    ];
    function GetItemToReplaceName(id, team, slot) {
        if (slot === null || slot === undefined || slot === '') {
            if (ItemInfo.IsWeapon(id) && !['melee', 'secondary0', 'c4', 'equipment2'].includes(InventoryAPI.GetDefaultSlot(id))) {
                slot = ItemInfo.GetEquippedSlot(id, team);
            }
            else {
                slot = InventoryAPI.GetDefaultSlot(id);
            }
        }
        const currentEquippedItem = ItemInfo.GetItemIdForItemEquippedInSlot(team, slot);
        if (currentEquippedItem && currentEquippedItem !== '0') {
            $.GetContextPanel().SetDialogVariable("item_name", GetNameWithRarity(currentEquippedItem));
            if (team != 'noteam') {
                return $.Localize('#inv_context_equip_team', $.GetContextPanel());
            }
            else
                return $.Localize('#inv_context_equip', $.GetContextPanel());
        }
        return 'WRONG CONTEXT -GetItemToReplaceName()' + id;
    }
    function GetNameWithRarity(id) {
        const rarityColor = InventoryAPI.GetItemRarityColor(id);
        let sName = InventoryAPI.HasCustomName(id) ? $.HTMLEscape(InventoryAPI.GetItemNameCustomized(id)) : InventoryAPI.GetItemName(id);
        return '<font color="' + rarityColor + '">' + sName + '</font>';
    }
    function EquipItem(id, team, slot) {
        if (slot === null || slot === undefined || slot === '') {
            slot = InventoryAPI.GetDefaultSlot(id);
            if (ItemInfo.IsWeapon(id) && !["melee", "secondary0", "c4", "equipment2"].includes(slot))
                slot = ItemInfo.GetEquippedSlot(id, team[0]);
        }
        const teamShownOnMainMenu = GameInterfaceAPI.GetSettingString('ui_vanitysetting_team');
        for (let element of team) {
            if (!TryEquipItemInSlot(element, id, slot))
                return;
        }
        let bNeedToRestartMainMenuVanity = false;
        if (ItemInfo.IsCharacter(id)) {
            const teamOfCharacter = (InventoryAPI.GetItemTeam(id).search('Team_T') === -1) ? 'ct' : 't';
            if (teamOfCharacter !== teamShownOnMainMenu) {
                GameInterfaceAPI.SetSettingString('ui_vanitysetting_team', teamOfCharacter);
            }
            bNeedToRestartMainMenuVanity = true;
        }
        else {
            team.filter(e => e === teamShownOnMainMenu);
            if (team.length > 0) {
                if ((slot === 'clothing_hands') ||
                    (slot === GameInterfaceAPI.GetSettingString('ui_vanitysetting_loadoutslot_' + teamShownOnMainMenu))) {
                    bNeedToRestartMainMenuVanity = true;
                }
            }
        }
        if (bNeedToRestartMainMenuVanity) {
            $.DispatchEvent('ForceRestartVanity');
        }
    }
    function TryEquipItemInSlot(szTeam, szItemID, szSlot) {
        let bSuccess = LoadoutAPI.EquipItemInSlot(szTeam, szItemID, szSlot);
        if (!bSuccess) {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#LoadoutLockedPopupTitle'), $.Localize('#LoadoutLockedPopupText'), '', () => { });
        }
        return bSuccess;
    }
    function DoesNotHaveChosenActionItems(id, capability) {
        return (InventoryAPI.GetChosenActionItemsCount(id, capability) === 0 && !InventoryAPI.IsTool(id));
    }
    function DoesItemTeamMatchTeamRequired(team, id) {
        if (team === 't') {
            return ItemInfo.IsItemT(id) || ItemInfo.IsItemAnyTeam(id);
        }
        if (team === 'ct') {
            return ItemInfo.IsItemCt(id) || ItemInfo.IsItemAnyTeam(id);
        }
        if (team === 'noteam') {
            return InventoryAPI.GetLoadoutCategory(id) == 'musickit';
        }
        return false;
    }
    function CanEquipItem(itemID) {
        return !!InventoryAPI.GetDefaultSlot(itemID) && !ItemInfo.IsEquippableThroughContextMenu(itemID);
    }
    function IsKeyForXrayItem(id) {
        const oData = ItemInfo.GetItemsInXray();
        if (oData.case && oData.reward) {
            const numActionItems = InventoryAPI.GetChosenActionItemsCount(oData.case, 'decodable');
            if (numActionItems > 0) {
                for (let i = 0; i < numActionItems; i++) {
                    if (id === InventoryAPI.GetChosenActionItemIDByIndex(oData.case, 'decodable', i)) {
                        return oData.case;
                    }
                }
            }
        }
        return '';
    }
    function _CanSwapFinish(id, team) {
        if (!DoesItemTeamMatchTeamRequired(team, id))
            return false;
        let slot;
        let group = InventoryAPI.GetRawDefinitionKey(id, 'flexible_loadout_group');
        switch (group) {
            case 'customplayer':
            case 'clothing_hands':
            case 'melee':
            case 'c4':
            case 'equipment2':
                {
                    slot = group;
                    break;
                }
            case 'secondary0':
            case 'secondary':
            case 'smg':
            case 'rifle':
                {
                    let itemDefIndex = InventoryAPI.GetItemDefinitionIndex(id);
                    slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, itemDefIndex);
                    if (!slot)
                        return false;
                    break;
                }
            default:
                {
                    return false;
                }
        }
        if (LoadoutAPI.GetItemID(team, slot) == id)
            return false;
        if (LoadoutAPI.IsShuffleEnabled(team, slot))
            return false;
        return CanEquipItem(id);
    }
    function _GetLoadoutSlot(id, team) {
        let group = InventoryAPI.GetRawDefinitionKey(id, 'flexible_loadout_group');
        if (['equipment2', 'secondary0', 'secondary', 'smg', 'rifle'].includes(group)) {
            let itemDefIndex = InventoryAPI.GetItemDefinitionIndex(id);
            return [team, LoadoutAPI.GetSlotEquippedWithDefIndex(team, itemDefIndex)];
        }
        else if (['musickit', 'flair0', 'spray0'].includes(group)) {
            return ['noteam', group];
        }
        else {
            return [team, group];
        }
    }
    function CanAddToFavorites(id, team) {
        const [_, slot] = _GetLoadoutSlot(id, team);
        if (!(ItemInfo.IsWeapon(id) || ItemInfo.IsMelee(id)) && slot != 'customplayer' && slot != 'clothing_hands' && slot != 'musickit')
            return false;
        if (slot == 'musickit' && team != 'noteam')
            return false;
        if (InventoryAPI.ItemIsInFavorites(team, id))
            return false;
        if (!DoesItemTeamMatchTeamRequired(team, id))
            return false;
        return !!InventoryAPI.GetDefaultSlot(id);
    }
})(ItemContextEntries || (ItemContextEntries = {}));
