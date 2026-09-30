"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/popup_custom_layout.ts" />
var PlayerCardContextMenuClanTags;
(function (PlayerCardContextMenuClanTags) {
    let m_myPrevClanId = MyPersonaAPI.GetMyClanId32BitEquipped();
    function Init() {
        m_myPrevClanId = MyPersonaAPI.GetMyClanId32BitEquipped();
        const elClanTagContextMenu = $('#id-scrolling-tag-container');
        // Rebuild the list from scratch every time the menu opens so it reflects the latest clan membership.
        elClanTagContextMenu.RemoveAndDeleteChildren();
        // "Clear Clan Tag" option at the top of the list. Equipping clan id 0 unequips the current tag
        // (see SetMyClanId32BitEquipped: "pass zero to unequip"), so the player displays no clan tag.
        // Collapsed when nothing is equipped, since there is nothing to clear.
        const elClearItem = AddTextButtonItem(elClanTagContextMenu, 'noclan', $.Localize('#ClanTag_Clear_ClanTag'), () => EquipClanWithSpinner(0));
        elClearItem.SetHasClass('current-clantag', m_myPrevClanId == 0);
        elClearItem.enabled = m_myPrevClanId != 0;
        const nNumClans = MyPersonaAPI.GetMyClanCount();
        for (let i = 0; i < nNumClans; i++) {
            const clanID = MyPersonaAPI.GetMyClanId32BitByIndex(i);
            const clanTag = FriendsListAPI.GetClanInfoById32Bit(clanID, 'tag');
            const clanName = FriendsListAPI.GetClanInfoById32Bit(clanID, 'name');
            AddClanTagItem(elClanTagContextMenu, 'clanid' + i, clanID, '[' + clanTag + ']', clanName);
        }
        // Trailing shortcut to the player's Steam groups page. Clan tags come from Steam group
        // membership, so this lets the player review or join groups to get more tags to choose from.
        AddTextButtonItem(elClanTagContextMenu, 'id-manage-groups', $.Localize('#ClanTag_Manage_Groups'), () => {
            // GetSteamCommunityURL() returns the bare host (e.g. "steamcommunity.com"), so prepend the
            // scheme; "/profiles/<xuid>/groups/" is the player's own group list.
            const url = 'https://' + SteamOverlayAPI.GetSteamCommunityURL() + '/profiles/' + MyPersonaAPI.GetXuid() + '/groups/';
            SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser(url);
            // close the context menu
            $.DispatchEvent('ContextMenuEvent', '');
        });
    }
    PlayerCardContextMenuClanTags.Init = Init;
    // Creates a single selectable clan row (tag + name). Selecting it equips that clan's tag.
    function AddClanTagItem(elParent, id, clanID, tagText, nameText) {
        const elItem = $.CreatePanel('Button', elParent, id);
        elItem.BLoadLayoutSnippet('snippet-clantag-item');
        const elClanTagLabel = elItem.FindChildTraverse('id-clan-tag__label');
        elClanTagLabel.text = tagText;
        // Collapse the row for the currently-equipped clan; there's nothing to switch to.
        elItem.SetHasClass('current-clantag', m_myPrevClanId == clanID);
        elItem.enabled = m_myPrevClanId != clanID;
        const elClanNameLabel = elItem.FindChildTraverse('id-clan-name__label');
        elClanNameLabel.text = nameText;
        elItem.SetPanelEvent('onactivate', () => EquipClanWithSpinner(clanID));
    }
    // Creates a centered text-button row (e.g. "Clear Clan Tag", "Manage Steam Groups") from the shared
    // snippet and wires fnActivate to it. Returns the button so callers can adjust it further.
    function AddTextButtonItem(elParent, id, labelText, fnActivate) {
        const elItem = $.CreatePanel('Button', elParent, id);
        elItem.BLoadLayoutSnippet('snippet-clantag-text-button');
        const elLabel = elItem.FindChildTraverse('id-clantag-text-button__label');
        elLabel.text = labelText;
        elItem.SetPanelEvent('onactivate', fnActivate);
        return elItem;
    }
    // Equips clanID (0 unequips) and shows a blocking spinner popup that stays up until the persona
    // inventory-updated event confirms the GC round-trip (or the popup times out).
    function EquipClanWithSpinner(clanID) {
        let elPopup = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_custom_layout.xml');
        const jsEventHandler = UiToolkitAPI.RegisterJSCallback(OnMyPersonaInventoryUpdatedCallback);
        let oSettings = {
            image: 'file://{images}/control_icons/home_icon.vtf',
            message: $.Localize('#ClanTag_Updating'),
            show_spinner: true,
            no_min_width: true,
            show_loading_bar: false,
            hide_buttons: true,
            timeout: 1,
            watch_event: 'PanoramaComponent_MyPersona_InventoryUpdated',
            watch_event_callback: jsEventHandler,
        };
        elPopup.Data().oSettings = oSettings;
        // Kick off the actual change; the popup's watch_event above waits for the GC to confirm.
        MyPersonaAPI.SetMyClanId32BitEquipped(clanID);
    }
    // Fires when the persona inventory reports an update, i.e. the GC responded to our clan change.
    function OnMyPersonaInventoryUpdatedCallback() {
        // If we lost the inventory or GC connection there's nothing to confirm; just dismiss the spinner.
        if (!MyPersonaAPI.IsInventoryValid() || !MyPersonaAPI.IsConnectedToGC()) {
            $.DispatchEvent('UIPopupButtonClicked', '');
            return;
        }
        // Dismiss the spinner if the equipped clan actually changed from what it was when the menu opened.
        const myNewClanId = MyPersonaAPI.GetMyClanId32BitEquipped();
        if (myNewClanId != m_myPrevClanId) {
            $.DispatchEvent('UIPopupButtonClicked', '');
        }
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
    }
})(PlayerCardContextMenuClanTags || (PlayerCardContextMenuClanTags = {}));
