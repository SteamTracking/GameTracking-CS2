"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../friendlobby.ts" />
var ContextMenuLobbies;
(function (ContextMenuLobbies) {
    let m_elNewestLobby = null;
    let m_btnGoToNew = $.GetContextPanel().FindChildInLayoutFile('id-context-menu-lobbies-new-btn');
    let m_bSeenNewestLobby = false;
    function Init() {
        let numInvites = PartyBrowserAPI.GetInvitesCount();
        $.GetContextPanel().SetDialogVariableInt('lobby_count', numInvites);
        let elInviteContainer = $.GetContextPanel().FindChildInLayoutFile('id-context-menu-lobbies');
        if (numInvites < 1) {
            $.DispatchEvent('ContextMenuEvent', '');
            return;
        }
        let xuidsFromUpdate = [];
        for (let i = 0; i < numInvites; i++) {
            let xuid = PartyBrowserAPI.GetInviteXuidByIndex(i);
            xuidsFromUpdate.push(xuid);
        }
        DeleteTilesNotInUpdate(elInviteContainer, xuidsFromUpdate);
        xuidsFromUpdate.reverse();
        for (let i = 0; i < xuidsFromUpdate.length; i++) {
            let xuid = xuidsFromUpdate[i];
            let elTile = elInviteContainer.FindChildTraverse(xuid);
            if (!elTile)
                AddTile(elInviteContainer, xuid, i);
            else
                UpdateTilePosition(elInviteContainer, elTile, i);
        }
        let elLastItem = elInviteContainer.Children()[elInviteContainer.Children().length - 1];
        if (elLastItem && elLastItem.IsValid()) {
            if (m_elNewestLobby === null) {
                m_elNewestLobby = elLastItem;
            }
            else if (m_elNewestLobby && m_elNewestLobby.IsValid() && m_elNewestLobby.id !== elLastItem.id) {
                m_elNewestLobby = elLastItem;
                m_bSeenNewestLobby = false;
            }
        }
        ShowHideNewLobbiesBtn();
        elInviteContainer.SetSendScrollPositionChangedEvents(true);
    }
    ContextMenuLobbies.Init = Init;
    ;
    function DeleteTilesNotInUpdate(elList, xuidsFromUpdate) {
        let children = elList.Children();
        let sectionChildrenCount = children.length;
        for (let i = 0; i < sectionChildrenCount; i++) {
            let panelId = children[i].id;
            if (xuidsFromUpdate.indexOf(panelId) < 0)
                children[i].DeleteAsync(0);
        }
    }
    ;
    function UpdateTilePosition(elList, elTile, index) {
        let children = elList.Children();
        if (children[index])
            elList.MoveChildBefore(elTile, children[index]);
        friendLobby.Init(elTile);
    }
    ;
    function ShowHideNewLobbiesBtn() {
        $.Schedule(1, () => {
            if (!m_elNewestLobby || !m_elNewestLobby.IsValid()) {
                m_btnGoToNew.SetHasClass('hide', true);
                return;
            }
            else if (m_elNewestLobby.BCanSeeInParentScroll() && !m_bSeenNewestLobby) {
                m_btnGoToNew.SetHasClass('hide', true);
                m_bSeenNewestLobby = true;
            }
            else if (!m_elNewestLobby.BCanSeeInParentScroll() && !m_bSeenNewestLobby) {
                m_btnGoToNew.SetHasClass('hide', false);
            }
        });
    }
    ContextMenuLobbies.ShowHideNewLobbiesBtn = ShowHideNewLobbiesBtn;
    function AddTile(elList, xuid, index) {
        let elTile = $.CreatePanel("Panel", elList, xuid);
        elTile.SetAttributeString('xuid', xuid);
        elTile.BLoadLayout('file://{resources}/layout/friendlobby.xml', false, false);
        AddTransitionEndEventHandler(elTile);
        elTile.SetAttributeString('showinpopup', 'true');
        friendLobby.Init(elTile);
        elTile.RemoveClass('hidden');
        $.RegisterEventHandler('ScrolledIntoView', elTile, () => { });
        $.Schedule(1, () => { });
    }
    ;
    function AddTransitionEndEventHandler(elTile) {
        $.RegisterEventHandler('PropertyTransitionEnd', elTile, fnOnPropertyTransitionEndEvent);
        function fnOnPropertyTransitionEndEvent(panel, propertyName) {
            if (elTile === panel && propertyName === 'opacity') {
                if (elTile.visible === true && elTile.BIsTransparent()) {
                    elTile.DeleteAsync(0.0);
                    return true;
                }
            }
            return false;
        }
        ;
    }
    ;
    function OnPressGotoNew() {
        let elPanel = $.GetContextPanel().FindChildInLayoutFile('id-context-menu-lobbies');
        elPanel.ScrollToBottom();
    }
    ContextMenuLobbies.OnPressGotoNew = OnPressGotoNew;
    {
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_InviteConsumed', Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_InviteReceived', Init);
        let elLister = $.GetContextPanel().FindChildInLayoutFile('id-context-menu-lobbies');
        elLister.SetSendScrollPositionChangedEvents(true);
        $.RegisterEventHandler('ScrollPositionChanged', elLister, ShowHideNewLobbiesBtn);
    }
})(ContextMenuLobbies || (ContextMenuLobbies = {}));
