"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../common/characteranims.ts" />
var MainMenuVanityContextMenu;
(function (MainMenuVanityContextMenu) {
    function ChooseMapNameToken(map) {
        let token = "#VanityMapName_" + map;
        if ($.Localize(token) == token) {
            token = "#SFUI_Map_" + map;
        }
        return token;
    }
    function Init() {
        let strType = $.GetContextPanel().GetAttributeString("type", "");
        let team = $.GetContextPanel().GetAttributeString("team", "");
        let elContextMenuBodyNoScroll = $.GetContextPanel().FindChildTraverse('ContextMenuBodyNoScroll');
        elContextMenuBodyNoScroll.SetDialogVariableLocString("mainmenu_bkgnd", ChooseMapNameToken(GameInterfaceAPI.GetSettingString("ui_mainmenu_bkgnd_movie")));
        $.RegisterForUnhandledEvent("CSGOMainInitBackgroundMovie", () => {
            elContextMenuBodyNoScroll.SetDialogVariableLocString("mainmenu_bkgnd", ChooseMapNameToken(GameInterfaceAPI.GetSettingString("ui_mainmenu_bkgnd_movie")));
        });
        if (strType === 'catagory')
            MakeCatBtns(team);
        else if (strType === 'weapons')
            MakeWeaponBtns(team);
        else
            MakeMapBtns();
    }
    MainMenuVanityContextMenu.Init = Init;
    function fnAddVanityPopupMenuItem(idString, strItemNameString, fnOnActivate) {
        let elContextMenuBodyNoScroll = $.GetContextPanel().FindChildTraverse('ContextMenuBodyNoScroll');
        let elItem = $.CreatePanel('Button', elContextMenuBodyNoScroll, idString);
        elItem.BLoadLayoutSnippet('snippet-vanity-item');
        let elLabel = elItem.FindChildTraverse('id-vanity-item__label');
        elLabel.SetLocString(strItemNameString);
        elItem.SetPanelEvent('onactivate', fnOnActivate);
        return elItem;
    }
    ;
    function MakeCatBtns(team) {
        let elContextMenuBodyNoScroll = $.GetContextPanel().FindChildTraverse('ContextMenuBodyNoScroll');
        elContextMenuBodyNoScroll.RemoveAndDeleteChildren();
        fnAddVanityPopupMenuItem('ChangeVanityMap', '#mainmenu_change_vanity_map', () => {
            const elVanityContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-vanity-contextmenu-maps', '', 'file://{resources}/layout/context_menus/context_menu_mainmenu_vanity.xml', 'type=maps', () => $.DispatchEvent('ContextMenuEvent', ''));
            elVanityContextMenu.AddClass('ContextMenu_NoArrow');
        })
            .SetFocus();
        fnAddVanityPopupMenuItem('ChangeWeapon', '#mainmenu_change_vanity_weapon', () => {
            const elVanityContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-vanity-contextmenu-weapons', '', 'file://{resources}/layout/context_menus/context_menu_mainmenu_vanity.xml', 'type=weapons' +
                '&' + 'team=' + team, () => $.DispatchEvent('ContextMenuEvent', ''));
            elVanityContextMenu.AddClass('ContextMenu_NoArrow');
        });
        let strOtherTeamToPrecache = ((team == '2') ? 'ct' : 't');
        fnAddVanityPopupMenuItem('switchTo_' + strOtherTeamToPrecache, '#mainmenu_switch_vanity_to_' + strOtherTeamToPrecache, () => {
            $.DispatchEvent("MainMenuSwitchVanity", strOtherTeamToPrecache);
            $.DispatchEvent('ContextMenuEvent', '');
        })
            .AddClass('BottomSeparator');
        fnAddVanityPopupMenuItem('GoToLoadout', '#mainmenu_go_to_character_loadout', () => {
            $.DispatchEvent("MainMenuGoToCharacterLoadout", team);
            $.DispatchEvent('ContextMenuEvent', '');
        });
        let otherTeamCharacterItemID = LoadoutAPI.GetItemID(strOtherTeamToPrecache, 'customplayer');
        let settingsForOtherTeam = ItemInfo.GetOrUpdateVanityCharacterSettings(otherTeamCharacterItemID);
        ItemInfo.PrecacheVanityCharacterSettings(settingsForOtherTeam);
    }
    ;
    function MakeWeaponBtns(team) {
        let elContextMenuBodyWeapons = $.GetContextPanel().FindChildTraverse('ContextMenuBodyWeapons');
        elContextMenuBodyWeapons.RemoveAndDeleteChildren();
        for (let [loadoutSubSlot, weaponItemId] of ItemInfo.GetLoadoutWeapons(team)) {
            let elItem = $.CreatePanel('Button', elContextMenuBodyWeapons, weaponItemId);
            elItem.BLoadLayoutSnippet('snippet-vanity-item');
            elItem.AddClass('vanity-item--weapon');
            let elLabel = elItem.FindChildTraverse('id-vanity-item__label');
            elLabel.text = InventoryAPI.GetItemName(weaponItemId);
            let elRarity = elItem.FindChildTraverse('id-vanity-item__rarity');
            let rarityColor = InventoryAPI.GetItemRarityColor(weaponItemId);
            elRarity.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from(" + rarityColor + " ), color-stop( 0.0125, #00000000 ), to( #00000000 ) );";
            elItem.SetPanelEvent('onactivate', () => {
                let shortTeam = CharacterAnims.NormalizeTeamName(team, true);
                GameInterfaceAPI.SetSettingString('ui_vanitysetting_loadoutslot_' + shortTeam, loadoutSubSlot);
                $.DispatchEvent('ForceRestartVanity');
                $.DispatchEvent('ContextMenuEvent', '');
            });
        }
    }
    function MakeMapBtns() {
        let cvarInfo = $.GetContextPanel().GetAttributeString("inspect-map", "") === "true"
            ? GameInterfaceAPI.GetSettingInfo("ui_inspect_bkgnd_map")
            : GameInterfaceAPI.GetSettingInfo("ui_mainmenu_bkgnd_movie");
        let aMaps = cvarInfo.allowed_values;
        let elContextMenuBodyNoScroll = $.GetContextPanel().FindChildTraverse('ContextMenuBodyNoScroll');
        elContextMenuBodyNoScroll.RemoveAndDeleteChildren();
        for (let map of aMaps) {
            fnAddVanityPopupMenuItem('context-menu-vanity-' + map, ChooseMapNameToken(map), () => {
                if ($.GetContextPanel().GetAttributeString("inspect-map", "") === "true") {
                    GameInterfaceAPI.SetSettingString('ui_inspect_bkgnd_map', map);
                }
                else {
                    GameInterfaceAPI.SetSettingString('ui_mainmenu_bkgnd_movie', map);
                }
                $.DispatchEvent('ContextMenuEvent', '');
            });
        }
    }
})(MainMenuVanityContextMenu || (MainMenuVanityContextMenu = {}));
