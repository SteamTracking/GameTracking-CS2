"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="popup_inspect_shared.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var CanApplyHeader;
(function (CanApplyHeader) {
    function Init(oTitleSettings) {
        oTitleSettings.headerPanel.RemoveClass('hidden');
        _SetTitle(oTitleSettings);
        _SetUpDesc(oTitleSettings);
        _SetUpWarning(oTitleSettings);
    }
    CanApplyHeader.Init = Init;
    function _SetTitle(oTitleSettings) {
        if (oTitleSettings.type === 'sticker' && !oTitleSettings.isRemove) {
            const listStickers = ItemInfo.GetitemStickerList(oTitleSettings.itemId);
            oTitleSettings.contextPanel.SetDialogVariableInt("sticker_count", listStickers.length + 1);
            oTitleSettings.contextPanel.SetDialogVariableInt("max_stickers", 5);
            oTitleSettings.contextPanel.SetDialogVariable("CanApplyTitle", $.Localize('#popup_can_sticker_button', oTitleSettings.contextPanel));
            return;
        }
        let title = oTitleSettings.isRemove ? '#SFUI_InvContextMenu_can_stick_Wear_full_' + oTitleSettings.type : '#SFUI_InvContextMenu_stick_use_' + oTitleSettings.type;
        switch (InspectShared.GetPopupSetting('work_type')) {
            case 'remove_sticker':
                if (InspectShared.GetPopupSetting('remove_sticker_all_at_once', oTitleSettings.contextPanel))
                    title = '#SFUI_InvUse_Remove_Stickers';
                break;
            case 'can_wrap_sticker':
                title = oTitleSettings.toolId ? '#CSGO_Tool_WrapStickerInDisplayCase_Title' : '#CSGO_Tool_UnWrapStickerInDisplayCase_Title';
                break;
            case 'craft_souvenir':
                title = "#popup_craft_souvenir_button";
                break;
        }
        oTitleSettings.contextPanel.SetDialogVariable("CanApplyTitle", $.Localize(title, oTitleSettings.contextPanel));
    }
    function _SetUpDesc(oTitleSettings) {
        const currentName = InventoryAPI.GetItemNameUncustomized(oTitleSettings.itemId);
        oTitleSettings.contextPanel.SetDialogVariable('tool_target_name', currentName);
        let desc = oTitleSettings.isRemove ? '#popup_can_stick_scrape_full_' + oTitleSettings.type : '#popup_can_stick_desc';
        switch (InspectShared.GetPopupSetting('work_type')) {
            case 'remove_sticker':
                if (InspectShared.GetPopupSetting('remove_sticker_all_at_once', oTitleSettings.contextPanel))
                    desc += '_wipestickers';
                break;
            case 'can_wrap_sticker':
                desc = '';
                break;
            case 'craft_souvenir':
                desc = '#popup_craft_souvenir_desc';
                break;
        }
        oTitleSettings.contextPanel.SetDialogVariable("CanApplyDesc", $.Localize(desc, oTitleSettings.contextPanel));
    }
    function _SetUpWarning(oTitleSettings) {
        const elLabel = oTitleSettings.headerPanel.FindChildTraverse('id-can-apply-warning');
        switch (InspectShared.GetPopupSetting('work_type')) {
            case 'can_wrap_sticker':
                elLabel.visible = true;
                elLabel.FindChildInLayoutFile('id-can-apply-warning-text').SetLocString(oTitleSettings.toolId ? '#CSGO_Tool_WrapStickerInDisplayCase_Desc' : '#CSGO_Tool_UnWrapStickerInDisplayCase_Desc');
                return;
            case 'craft_souvenir':
                elLabel.visible = true;
                const balanceCredits = InspectShared.GetPopupSetting('credits_owned_souvenir');
                elLabel.SetDialogVariableInt('credits_owned_souvenir', balanceCredits);
                elLabel.SetDialogVariableLocString('event_credits', '#CSGO_TournamentPass_' + g_ActiveTournamentInfo.location + '_credits');
                elLabel.FindChildInLayoutFile('id-can-apply-warning-text').SetLocString('#popup_craft_souvenir_warn');
                return;
        }
        if (oTitleSettings.isRemove && InspectShared.GetPopupSetting('work_type') == 'remove_keychain') {
            elLabel.visible = true;
            const numKeychainRemoveToolChargesRemaining = InventoryAPI.GetCacheTypeElementFieldByIndex('KeychainRemoveToolCharges', 0, 'charges');
            elLabel.SetDialogVariableInt('item_count', numKeychainRemoveToolChargesRemaining);
            elLabel.FindChildInLayoutFile('id-can-apply-warning-text').SetLocString('#Notify_KeychainRemoveTool_ChargesUseToRemove');
            return;
        }
        elLabel.visible = !oTitleSettings.isRemove;
        if (oTitleSettings.isRemove) {
            return;
        }
        let warningText = _GetWarningTradeRestricted(oTitleSettings);
        warningText = !warningText ? '#SFUI_InvUse_Warning_use_can_stick_' + oTitleSettings.type : warningText;
        if (ItemInfo.IsFauxOrRentalOrPreviewTool(oTitleSettings.toolId)) {
            warningText = '#SFUI_InvUse_Warning_use_can_stick_previewonly_' + oTitleSettings.type;
            let bPhantomDisplayItemCannotApply = true;
            oTitleSettings.contextPanel.SetHasClass('can_apply_previewonly_phantom_display', bPhantomDisplayItemCannotApply);
        }
        warningText = $.Localize(warningText, elLabel);
        oTitleSettings.contextPanel.SetDialogVariable("CanApplyWarning", warningText);
    }
    function _GetWarningTradeRestricted(oTitleSettings) {
        let strSpecialWarning = '';
        let strSpecialParam = null;
        const bIsPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld" ? true : false;
        if (!bIsPerfectWorld) {
            if (InventoryAPI.IsMarketable(oTitleSettings.itemId)) {
                if (!InventoryAPI.IsPotentiallyMarketable(oTitleSettings.toolId)) {
                    strSpecialParam = String(InventoryAPI.GetItemAttributeValue(oTitleSettings.toolId, "tradable after date"));
                    if (strSpecialParam !== undefined && strSpecialParam !== null) {
                        strSpecialWarning = _GetSpecialWarningString(oTitleSettings, strSpecialParam, "marketrestricted");
                    }
                }
                else {
                    strSpecialWarning = _GetStickerMarketDateGreater(oTitleSettings);
                }
            }
        }
        else {
            strSpecialWarning = _GetStickerMarketDateGreater(oTitleSettings);
        }
        return strSpecialWarning;
    }
    function _GetStickerMarketDateGreater(oTitleSettings) {
        const rtTradableAfterSticker = InventoryAPI.GetItemAttributeValue(oTitleSettings.toolId, "{uint32}tradable after date");
        const rtTradableAfterWeapon = InventoryAPI.GetItemAttributeValue(oTitleSettings.itemId, "{uint32}tradable after date");
        if (rtTradableAfterSticker != undefined && rtTradableAfterSticker != null &&
            (rtTradableAfterWeapon == undefined || rtTradableAfterWeapon == null || rtTradableAfterSticker > rtTradableAfterWeapon)) {
            let strSpecialParam = null;
            strSpecialParam = String(InventoryAPI.GetItemAttributeValue(oTitleSettings.toolId, "tradable after date"));
            if (strSpecialParam != undefined && strSpecialParam != null) {
                return _GetSpecialWarningString(oTitleSettings, strSpecialParam, "traderestricted");
            }
        }
        return '';
    }
    function _GetSpecialWarningString(oTitleSettings, strSpecialParam, warningText) {
        const elLabel = oTitleSettings.headerPanel.FindChildInLayoutFile('id-can-apply-warning');
        elLabel.SetDialogVariable('date', strSpecialParam);
        return "#popup_can_stick_warning_" + warningText + "_" + oTitleSettings.type;
    }
})(CanApplyHeader || (CanApplyHeader = {}));
