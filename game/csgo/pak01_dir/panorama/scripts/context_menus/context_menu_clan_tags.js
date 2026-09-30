"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/popup_custom_layout.ts" />
var PlayerCardContextMenuClanTags;
(function (PlayerCardContextMenuClanTags) {
    let m_myPrevClanId = MyPersonaAPI.GetMyClanId32BitEquipped();
    function Init() {
        m_myPrevClanId = MyPersonaAPI.GetMyClanId32BitEquipped();
        const elClanTagContextMenu = $('#id-scrolling-tag-container');
        elClanTagContextMenu.RemoveAndDeleteChildren();
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
        AddTextButtonItem(elClanTagContextMenu, 'id-manage-groups', $.Localize('#ClanTag_Manage_Groups'), () => {
            const url = 'https://' + SteamOverlayAPI.GetSteamCommunityURL() + '/profiles/' + MyPersonaAPI.GetXuid() + '/groups/';
            SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser(url);
            $.DispatchEvent('ContextMenuEvent', '');
        });
    }
    PlayerCardContextMenuClanTags.Init = Init;
    function AddClanTagItem(elParent, id, clanID, tagText, nameText) {
        const elItem = $.CreatePanel('Button', elParent, id);
        elItem.BLoadLayoutSnippet('snippet-clantag-item');
        const elClanTagLabel = elItem.FindChildTraverse('id-clan-tag__label');
        elClanTagLabel.text = tagText;
        elItem.SetHasClass('current-clantag', m_myPrevClanId == clanID);
        elItem.enabled = m_myPrevClanId != clanID;
        const elClanNameLabel = elItem.FindChildTraverse('id-clan-name__label');
        elClanNameLabel.text = nameText;
        elItem.SetPanelEvent('onactivate', () => EquipClanWithSpinner(clanID));
    }
    function AddTextButtonItem(elParent, id, labelText, fnActivate) {
        const elItem = $.CreatePanel('Button', elParent, id);
        elItem.BLoadLayoutSnippet('snippet-clantag-text-button');
        const elLabel = elItem.FindChildTraverse('id-clantag-text-button__label');
        elLabel.text = labelText;
        elItem.SetPanelEvent('onactivate', fnActivate);
        return elItem;
    }
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
        MyPersonaAPI.SetMyClanId32BitEquipped(clanID);
    }
    function OnMyPersonaInventoryUpdatedCallback() {
        if (!MyPersonaAPI.IsInventoryValid() || !MyPersonaAPI.IsConnectedToGC()) {
            $.DispatchEvent('UIPopupButtonClicked', '');
            return;
        }
        const myNewClanId = MyPersonaAPI.GetMyClanId32BitEquipped();
        if (myNewClanId != m_myPrevClanId) {
            $.DispatchEvent('UIPopupButtonClicked', '');
        }
    }
    {
    }
})(PlayerCardContextMenuClanTags || (PlayerCardContextMenuClanTags = {}));
