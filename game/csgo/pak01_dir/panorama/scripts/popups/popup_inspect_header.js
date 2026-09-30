"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/icon.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="popup_inspect_shared.ts" />
var InspectHeader;
(function (InspectHeader) {
    function Init() {
        const elHeaderPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectHeader');
        const showXRayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        const isInspectOnly = InspectShared.GetPopupSetting('inspect_only');
        if (isInspectOnly === false && !showXRayMachineUi)
            return;
        const itemId = showXRayMachineUi ? $.GetContextPanel().Data().existingRewardFromXrayId : InspectShared.GetPopupSetting('item_id');
        elHeaderPanel.RemoveClass('hidden');
        _SetName(elHeaderPanel, itemId);
        _SetRarity(elHeaderPanel, itemId);
        _SetCollectionInfo(elHeaderPanel, itemId);
        _SetRentalTime(elHeaderPanel, itemId);
        _SetOriginalOwner(elHeaderPanel, itemId);
    }
    InspectHeader.Init = Init;
    function _SetName(elPanel, ItemId) {
        const strViewFunc = InspectShared.GetPopupSetting('force_inspect_view_type');
        if (ItemInfo.ItemDefinitionNameSubstrMatch(ItemId, 'tournament_journal_'))
            ItemId = (strViewFunc === 'primary') ? ItemId : ItemInfo.GetFauxReplacementItemID(ItemId, 'graffiti');
        elPanel.SetDialogVariable('item_name', InventoryAPI.GetItemNameUncustomized(ItemId));
        elPanel.SetDialogVariable('item_custom_name', InventoryAPI.GetItemNameCustomized(ItemId));
        const bShowCustomName = InventoryAPI.HasCustomName(ItemId);
        elPanel.FindChildInLayoutFile('InspectCustomName').visible = bShowCustomName;
        elPanel.FindChildInLayoutFile('InspectName').SetHasClass('text-align-left', ItemInfo.GetSet(ItemId) !== '');
    }
    function _SetRentalTime(elPanel, ItemId) {
        const elLabel = elPanel.FindChildInLayoutFile('ItemRentalTime');
        const expirationDate = InventoryAPI.IsRental(ItemId) ? InventoryAPI.GetExpirationDate(ItemId) : 0;
        const bHasExpirationDate = (expirationDate > 0);
        if (bHasExpirationDate) {
            const oLocData = FormatText.FormatRentalTime(expirationDate);
            elPanel.SetDialogVariable('time-remaining', oLocData.time);
            elLabel.RemoveClass('hide');
        }
        elLabel.SetHasClass('hide', !bHasExpirationDate);
    }
    function _SetOriginalOwner(elPanel, itemId) {
        const elOriginalOwner = elPanel.FindChildInLayoutFile('InspectOriginalOwner');
        elOriginalOwner.visible = (InventoryAPI.GetItemAttributeValue(itemId, '{uint32}purchaser account id') != undefined);
        const elImage = elPanel.FindChildInLayoutFile('InspectSetImage');
        elOriginalOwner.SetHasClass('horizontal-center', !elImage.visible);
    }
    function _SetRarity(elPanel, itemId) {
        const rarityColor = InventoryAPI.GetItemRarityColor(itemId);
        if (rarityColor) {
            elPanel.FindChildInLayoutFile('InspectBar').style.washColor = rarityColor;
        }
    }
    function _SetCollectionInfo(elPanel, itemId) {
        const setName = ItemInfo.GetSet(itemId);
        const elImage = elPanel.FindChildInLayoutFile('InspectSetImage');
        const elLabel = elPanel.FindChildInLayoutFile('InspectCollection');
        if (InventoryAPI.DoesItemMatchDefinitionByName(itemId, "Remove Keychain Tool")) {
            elImage.SetImage('file://{images}/icons/ui/keychain_removal.svg');
            elImage.visible = true;
            const numKeychainRemoveToolChargesRemaining = InventoryAPI.GetCacheTypeElementFieldByIndex('KeychainRemoveToolCharges', 0, 'charges');
            elLabel.SetDialogVariableInt('item_count', numKeychainRemoveToolChargesRemaining);
            elLabel.text = $.Localize('#Attrib_KeychainRemoveTool_Charges', elLabel);
            elLabel.visible = true;
            return;
        }
        if (setName === '') {
            elImage.visible = false;
            elLabel.visible = false;
            return;
        }
        elLabel.text = $.Localize('#CSGO_' + setName);
        elLabel.visible = true;
        IconUtil.SetupFallbackItemSetIcon(elImage, setName);
        IconUtil.SetItemSetSVGImage(elImage, setName);
        elImage.visible = true;
    }
})(InspectHeader || (InspectHeader = {}));
