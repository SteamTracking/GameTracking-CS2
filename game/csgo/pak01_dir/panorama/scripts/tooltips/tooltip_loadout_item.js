"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
var TooltipLoadoutItem;
(function (TooltipLoadoutItem) {
    function SetupTooltip() {
        let ctx = $.GetContextPanel();
        let id = ctx.GetAttributeString("itemid", "");
        let nameOnly = ctx.GetAttributeString("nameonly", "");
        let slot = ctx.GetAttributeString("slot", "");
        let idForItemName = id;
        if (slot === 'spray0') {
            idForItemName = ItemInfo.GetFauxReplacementItemID(id, 'graffiti');
        }
        ctx.SetDialogVariable('name', InventoryAPI.GetItemName(idForItemName));
        let color = InventoryAPI.GetItemRarityColor(id);
        if (color) {
            $.GetContextPanel().FindChildInLayoutFile('id-tooltip-layout-name').style.color = color;
        }
        else {
            $.GetContextPanel().FindChildInLayoutFile('id-tooltip-layout-name').style.color = 'white';
        }
        $.GetContextPanel().FindChildInLayoutFile('id-tooltip-layout-desc').visible = nameOnly === 'true';
        $.GetContextPanel().FindChildInLayoutFile('id-tooltip-layout-seperator').visible = nameOnly === 'true';
        if (nameOnly === 'true') {
            let defName = InventoryAPI.GetItemDefinitionName(id);
            defName = defName ? defName?.replace('weapon_', '') : '';
            ctx.SetDialogVariable('desc', $.Localize('#csgo_item_usage_desc_' + defName));
        }
    }
    TooltipLoadoutItem.SetupTooltip = SetupTooltip;
})(TooltipLoadoutItem || (TooltipLoadoutItem = {}));
