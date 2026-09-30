"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="popups/popup_select_item_for_capability.ts" />
/// <reference path="common/formattext.ts" />
var ItemTile;
(function (ItemTile) {
    function _OnTileUpdated(elTeamTile) {
        let id = elTeamTile.GetAttributeString('itemid', '0');
        if (id === '0')
            return;
        let idForDisplay = id;
        if (elTeamTile.GetAttributeString('filter_category', '') === 'inv_graphic_art') {
            idForDisplay = ItemInfo.GetFauxReplacementItemID(id, 'graffiti');
        }
        _SetItemName(idForDisplay);
        _SetItemRarity(id);
        _SetEquippedState(id);
        _SetStickers(id);
        _SetRecentLabel(id);
        _TintSprayImage(id);
        _DisableTile(id);
        _SetBackground(id);
        _SetRentalTime(id);
        _SetIsRentable(id);
        _SetOriginalOwner(id);
        let loadImage = $.GetContextPanel().GetAttributeString('loadimage', '');
        if (loadImage) {
            _SetImage(id);
        }
    }
    ;
    function _SetItemName(id) {
        let fmtName = ItemInfo.GetFormattedName(id);
        fmtName.SetOnLabel($('#JsItemName'));
    }
    ;
    function _SetBackground(id) {
        let elTeamTile = $.GetContextPanel().FindChildInLayoutFile('ItemTileTeam');
        let subSlot = InventoryAPI.GetDefaultSlot(id);
        if (subSlot == 'customplayer') {
            elTeamTile.visible = true;
            let isCT = ItemInfo.IsItemCt(id);
            if (isCT) {
                elTeamTile.SetImage("file://{images}/icons/ui/ct_logo_1c.svg");
                elTeamTile.style.washColor = '#B5D4EE';
            }
            else {
                elTeamTile.SetImage("file://{images}/icons/ui/t_logo_1c.svg");
                elTeamTile.style.washColor = '#EAD18A';
            }
        }
        else {
            elTeamTile.visible = false;
        }
    }
    function _SetImage(id) {
        $.GetContextPanel().FindChildInLayoutFile('ItemImage').itemid = id;
    }
    ;
    function _SetItemRarity(id) {
        let color = InventoryAPI.GetItemRarityColor(id);
        if (!color)
            return;
        $.GetContextPanel().FindChildInLayoutFile('JsRarity').style.backgroundColor = color;
    }
    ;
    function _SetEquippedState(id) {
        let elNoteamDot = $.GetContextPanel().FindChildInLayoutFile('ItemEquipped-noteam');
        let elCtDot = $.GetContextPanel().FindChildInLayoutFile('ItemEquipped-ct');
        let elTDot = $.GetContextPanel().FindChildInLayoutFile('ItemEquipped-t');
        let elFavoriteIconNoteam = $.GetContextPanel().FindChildInLayoutFile('FavoriteIcon-noteam');
        let elFavoriteIconCt = $.GetContextPanel().FindChildInLayoutFile('FavoriteIcon-ct');
        let elFavoriteIconT = $.GetContextPanel().FindChildInLayoutFile('FavoriteIcon-t');
        elTDot.AddClass('hidden');
        elCtDot.AddClass('hidden');
        elNoteamDot.AddClass('hidden');
        elTDot.RemoveClass('item-tile__equipped__radiodot--filled');
        elCtDot.RemoveClass('item-tile__equipped__radiodot--filled');
        elNoteamDot.RemoveClass('item-tile__equipped__radiodot--filled');
        elFavoriteIconNoteam.SetHasClass('hidden', !InventoryAPI.ItemIsInFavorites('noteam', id));
        elFavoriteIconCt.SetHasClass('hidden', !InventoryAPI.ItemIsInFavorites('ct', id));
        elFavoriteIconT.SetHasClass('hidden', !InventoryAPI.ItemIsInFavorites('t', id));
        for (let team of ['t', 'ct', 'noteam']) {
            if (_ItemIsInShuffle(id, team)) {
                _SetEquipIcon(true, team);
            }
            else if (InventoryAPI.IsEquipped(id, team)) {
                _SetEquipIcon(false, team);
            }
        }
    }
    ;
    function _ItemIsInShuffle(id, team) {
        let slot = InventoryAPI.GetRawDefinitionKey(id, 'flexible_loadout_group');
        if (['secondary0', 'secondary', 'smg', 'rifle'].includes(slot)) {
            let itemDefIndex = InventoryAPI.GetItemDefinitionIndex(id);
            slot = LoadoutAPI.GetSlotEquippedWithDefIndex(team, itemDefIndex);
        }
        return LoadoutAPI.IsShuffleEnabled(team, slot) && InventoryAPI.ItemIsInFavorites(team, id);
    }
    ;
    function _SetEquipIcon(isShuffle, team) {
        let elCtDot = $.GetContextPanel().FindChildInLayoutFile('ItemEquipped-' + team);
        elCtDot.RemoveClass('hidden');
        elCtDot.AddClass('item-tile__equipped__radiodot--filled');
        elCtDot.SetHasClass('shuffle', isShuffle);
    }
    ;
    function _SetStickers(id) {
        let elParentStickers = $.GetContextPanel().FindChildInLayoutFile('StickersOnWeapon');
        elParentStickers.RemoveAndDeleteChildren();
        let elParentKeychains = $.GetContextPanel().FindChildInLayoutFile('KeychainsOnWeapon');
        elParentKeychains.RemoveAndDeleteChildren();
        let listStickers = ItemInfo.GetitemStickerList(id);
        for (let entry of listStickers) {
            $.CreatePanel('Image', elParentStickers, 'ItemImage' + entry.image, {
                src: 'file://{images}' + entry.image + '.png',
                scaling: 'stretch-to-fit-preserve-aspect',
                class: 'item-tile__stickers__image'
            });
        }
        elParentStickers.SetHasClass('hidden', listStickers.length <= 0 || listStickers === undefined);
        let listKeychains = ItemInfo.GetitemKeychainList(id);
        for (let entry of listKeychains) {
            $.CreatePanel('Image', elParentKeychains, 'ItemImage' + entry.image, {
                src: 'file://{images}' + entry.image + '.png',
                scaling: 'stretch-to-fit-preserve-aspect',
                class: 'item-tile__stickers__image'
            });
        }
        elParentKeychains.SetHasClass('hidden', listKeychains.length <= 0 || listKeychains === undefined);
    }
    ;
    function _SetRecentLabel(id) {
        let elLabel = $.GetContextPanel().FindChildInLayoutFile('JsRecent');
        let unProtectedEscrowValue = InventoryAPI.GetItemAttributeValue(id, '{uint32}trade protected escrow date');
        if ((unProtectedEscrowValue !== undefined) && (unProtectedEscrowValue == 0)) {
            elLabel.RemoveClass('hidden');
            elLabel.text = $.Localize('#inv_session_prop_marketlisting');
            return;
        }
        let isRecentValue = InventoryAPI.GetItemSessionPropertyValue(id, 'recent');
        let isUpdatedValue = InventoryAPI.GetItemSessionPropertyValue(id, 'updated');
        if (isUpdatedValue === '1' || isRecentValue === '1') {
            let locString = 'recent';
            if (isRecentValue === '1') {
                let strItemPickupMethod = InventoryAPI.GetItemSessionPropertyValue(id, 'item_pickup_method');
                if (strItemPickupMethod && ['xpshopredeem', 'quest_reward'].includes(strItemPickupMethod)) {
                    locString = strItemPickupMethod;
                }
            }
            else {
                locString = 'updated';
            }
            elLabel.RemoveClass('hidden');
            elLabel.text = $.Localize('#inv_session_prop_' + locString);
            return;
        }
        elLabel.AddClass('hidden');
    }
    ;
    function _TintSprayImage(id) {
        let elImage = $.GetContextPanel().FindChildInLayoutFile('ItemImage');
        TintSprayIcon.CheckIsSprayAndTint(id, elImage);
    }
    ;
    function _DisableTile(id) {
        let capabilityInfo = _GetPopUpCapability();
        if (capabilityInfo && capabilityInfo.capability === 'can_sticker' && !ItemInfo.IsSticker(id)) {
            $.GetContextPanel().enabled = (InventoryAPI.GetItemStickerSlotCount(id) > InventoryAPI.GetItemStickerCount(id));
        }
        else if (capabilityInfo && capabilityInfo.capability === 'can_patch' && !ItemInfo.IsPatch(id)) {
            $.GetContextPanel().enabled = (InventoryAPI.GetItemStickerSlotCount(id) > InventoryAPI.GetItemStickerCount(id));
        }
        else if (capabilityInfo && capabilityInfo.capability === 'can_keychain' && !ItemInfo.IsKeychain(id)) {
            $.GetContextPanel().enabled = (InventoryAPI.GetItemKeychainSlotCount(id) > InventoryAPI.GetItemKeychainCount(id));
        }
    }
    ;
    function _SetRentalTime(id) {
        let elLabel = $.GetContextPanel().FindChildInLayoutFile('JsItemRental');
        let bHide = !InventoryAPI.IsRental(id);
        if (bHide) {
            elLabel.AddClass('hidden');
            return;
        }
        const expirationDate = InventoryAPI.GetExpirationDate(id);
        if (expirationDate <= 0) {
            elLabel.AddClass('hidden');
            return;
        }
        let oLocData = FormatText.FormatRentalTime(expirationDate);
        elLabel.SetHasClass('item-expired', oLocData.isExpired);
        elLabel.SetDialogVariable('time-remaining', oLocData.time);
        elLabel.text = $.Localize(oLocData.locString, elLabel);
        elLabel.RemoveClass('hidden');
    }
    function _SetIsRentable(id) {
        let elLabel = $.GetContextPanel().FindChildInLayoutFile('JsCanRentItem');
        if (!InventoryAPI.CanOpenForRental(id)) {
            elLabel.AddClass('hidden');
            return;
        }
        elLabel.text = $.Localize('#item-can-rent');
        elLabel.RemoveClass('hidden');
    }
    ItemTile._SetIsRentable = _SetIsRentable;
    function _SetOriginalOwner(id) {
        const elImage = $.GetContextPanel().FindChildInLayoutFile('JsOriginalOwner');
        elImage.SetHasClass('hidden', !(InventoryAPI.GetItemAttributeValue(id, '{uint32}purchaser account id') != undefined));
    }
    function OnActivate() {
        HideTooltip();
        let id = $.GetContextPanel().GetAttributeString('itemid', '0');
        if ($.GetContextPanel().FindAncestor("id-popup-select-item-list") != null) {
            $.DispatchEvent("OnItemTileActivated", $.GetContextPanel(), id);
            return;
        }
        if ($.GetContextPanel().FindAncestor("id-pet-sticker-item-list") != null) {
            $.DispatchEvent("OnItemTileActivated", $.GetContextPanel(), id);
            return;
        }
        if ($.GetContextPanel().FindAncestor("Crafting-Items") != null) {
            InventoryAPI.AddCraftIngredient(id);
            return;
        }
        if ($.GetContextPanel().FindAncestor("Crafting-Ingredients") != null) {
            InventoryAPI.RemoveCraftIngredient(id);
            return;
        }
        let filterValue = $.GetContextPanel().GetAttributeString('context_menu_filter', '');
        let filterForContextMenuEntries = filterValue ? '&populatefiltertext=' + filterValue : '';
        let contextmenuparam = '';
        if ($.GetContextPanel().GetAttributeString('filter_category', '') === 'inv_graphic_art')
            contextmenuparam = '&contextmenuparam=graffiti';
        let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_inventory_item.xml', 'itemid=' + id + filterForContextMenuEntries + contextmenuparam, () => { });
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
        contextMenuPanel.AddClass("ContextMenuCursorTopLeft");
    }
    ItemTile.OnActivate = OnActivate;
    ;
    let updateItemListCallback;
    function OnActivateInspectButtonFromTile() {
        let id = $.GetContextPanel().GetAttributeString('itemid', '0');
        if ($.GetContextPanel().FindAncestor("Crafting-Items") != null || $.GetContextPanel().FindAncestor("Crafting-Ingredients") != null) {
            $.DispatchEvent("InventoryItemPreview", id, '');
            return;
        }
        let oCapabilityInfo = _GetPopUpCapability();
        if (oCapabilityInfo !== null && oCapabilityInfo.popupVisible) {
            if (updateItemListCallback) {
                UiToolkitAPI.UnregisterJSCallback(updateItemListCallback);
            }
            updateItemListCallback = UiToolkitAPI.RegisterJSCallback(SelectItemForCapability.UpdateSort);
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
            let oSettings = {
                item_id: id,
                inspect_only: true,
                is_inside_casket: oCapabilityInfo.initialItemId ? true : false,
                capability: oCapabilityInfo.capability,
                hide_all_action_items: true,
                is_selected: $.GetContextPanel().BHasClass('capability_multistatus_selected'),
                callback_handle: updateItemListCallback
            };
            elPanel.Data().oSettings = oSettings;
        }
    }
    ItemTile.OnActivateInspectButtonFromTile = OnActivateInspectButtonFromTile;
    function _GetPopUpCapability() {
        if (typeof SelectItemForCapability === "object") {
            if (SelectItemForCapability.oCapabilityInfo.popupVisible) {
                return SelectItemForCapability.oCapabilityInfo;
            }
        }
        return null;
    }
    ;
    let jsTooltipDelayHandle = null;
    function ShowVideoClip() {
        const id = $.GetContextPanel().GetAttributeString('itemid', '0');
        const reelId = InventoryAPI.GetItemAttributeValue(id, '{uint32}keychain slot 0 highlight');
        if (reelId) {
            const reelJson = InventoryAPI.BuildHighlightReelSchemaJSON(reelId);
            const reelSchemaDef = JSON.parse(reelJson);
            const videoPlayerContainer = $.GetContextPanel().FindChildTraverse('VideoClipMovieContainer');
            const videoPlayer = $.GetContextPanel().FindChildTraverse('VideoClipMovie');
            if (videoPlayerContainer && videoPlayer) {
                videoPlayerContainer.AddClass('play');
                videoPlayer.AddClass('play');
                videoPlayer.SetMovie(reelSchemaDef["url_480p"]);
                videoPlayer.Play();
            }
        }
    }
    function HideVideoClip() {
        let id = $.GetContextPanel().GetAttributeString('itemid', '0');
        if (InventoryAPI.GetItemAttributeValue(id, '{uint32}keychain slot 0 highlight')) {
            const videoPlayerContainer = $.GetContextPanel().FindChildTraverse('VideoClipMovieContainer');
            const videoPlayer = $.GetContextPanel().FindChildTraverse('VideoClipMovie');
            if (videoPlayerContainer && videoPlayer) {
                videoPlayerContainer.RemoveClass('play');
                videoPlayer.RemoveClass('play');
                videoPlayer.Stop();
            }
        }
    }
    function ShowTooltip() {
        jsTooltipDelayHandle = $.Schedule(.4, ShowToolTipOnDelay);
    }
    ItemTile.ShowTooltip = ShowTooltip;
    function ShowToolTipOnDelay() {
        let id = $.GetContextPanel().GetAttributeString('itemid', '0');
        jsTooltipDelayHandle = null;
        if (!InventoryAPI.IsItemInfoValid(id)) {
            return;
        }
        UiToolkitAPI.ShowCustomLayoutParametersTooltip('ItemImage', 'JsItemTooltip', 'file://{resources}/layout/tooltips/tooltip_inventory_item.xml', 'itemid=' + id);
        ShowVideoClip();
    }
    ;
    function HideTooltip() {
        UiToolkitAPI.HideCustomLayoutTooltip('JsItemTooltip');
        if (jsTooltipDelayHandle) {
            $.CancelScheduled(jsTooltipDelayHandle);
            jsTooltipDelayHandle = null;
        }
        HideVideoClip();
    }
    ItemTile.HideTooltip = HideTooltip;
    ;
    {
        $.RegisterEventHandler('CSGOInventoryItemLoaded', $.GetContextPanel(), _OnTileUpdated);
        $.RegisterEventHandler('UpdateItemTile', $.GetContextPanel(), _OnTileUpdated);
        $.RegisterEventHandler('CSGOInventoryHideTooltip', $.GetContextPanel(), HideTooltip);
    }
})(ItemTile || (ItemTile = {}));
