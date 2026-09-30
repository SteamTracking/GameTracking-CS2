"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/commonutil.ts" />
/// <reference path="rating_emblem.ts" />
var FriendAdvertiseTile;
(function (FriendAdvertiseTile) {
    let _m_xuid = '';
    function Init(elTile) {
        _m_xuid = elTile.GetAttributeString('xuid', '(not found)');
        let gameMode = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/mode');
        let _m_isPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld" ? true : false;
        _SetNameAvatar(elTile);
        _SetPrime(elTile);
        if (!_m_isPerfectWorld)
            _SetRegion(elTile);
        _SetSkillGroup(elTile, gameMode);
        _SetInvitedFromCallback(elTile);
        _ShowInviteButton(elTile);
        _OnInviteSetPanelEvent(elTile);
    }
    FriendAdvertiseTile.Init = Init;
    function _SetNameAvatar(elTile) {
        let xuidLobbyLeader = PartyBrowserAPI.GetPartyMemberXuid(_m_xuid, 0);
        elTile.SetDialogVariable('friendname', FriendsListAPI.GetFriendName(xuidLobbyLeader));
        elTile.FindChildTraverse('JsFriendAvatar').PopulateFromSteamID(xuidLobbyLeader);
        elTile.FindChildTraverse('JsFriendAvatarBtn').SetPanelEvent('onactivate', _OpenContextMenu.bind(undefined, xuidLobbyLeader));
    }
    function _SetPrime(elTile) {
        let primeValue = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/apr');
        elTile.FindChildTraverse('JsFriendAdvertisePrime').visible = (primeValue && primeValue != '0') ? true : false;
    }
    function _SetRegion(elTile) {
        let countryCode = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/loc');
        CommonUtil.SetRegionOnLabel(countryCode, elTile);
    }
    function _SetSkillGroup(elTile, gameMode) {
        let szSkillGroupType = "skillgroup";
        if (gameMode === 'scrimcomp2v2') {
            szSkillGroupType = 'Wingman';
        }
        else {
            szSkillGroupType = 'Premier';
        }
        let score = Number(PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/ark'));
        score = Math.floor(score / 10);
        const options = {
            root_panel: elTile.FindChildTraverse('jsRatingEmblem'),
            xuid: _m_xuid,
            do_fx: true,
            full_details: false,
            rating_type: szSkillGroupType,
            leaderboard_details: { score: score },
            local_player: _m_xuid === MyPersonaAPI.GetXuid()
        };
        RatingEmblem.SetXuid(options);
    }
    function _OpenContextMenu(xuid) {
        $.DispatchEvent('SidebarContextMenuActive', true);
        let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid +
            '&type=nearby', () => $.DispatchEvent('SidebarContextMenuActive', false));
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
    }
    function _ShowInviteButton(elTile) {
        let elInvited = elTile.FindChildTraverse('JsInviteAdvertisingPlayer');
        elInvited.visible = !(_m_xuid === MyPersonaAPI.GetXuid());
    }
    function _SetInvitedFromCallback(elTile) {
        let isInvited = FriendsListAPI.IsFriendInvited(_m_xuid);
        _SetInvited(elTile, isInvited);
    }
    function _SetInvited(elTile, isInvited) {
        let elInvited = elTile.FindChildTraverse('JsFriendInvited');
        if (elInvited !== null)
            elInvited.SetHasClass('hidden', !isInvited);
    }
    function _OnInviteSetPanelEvent(elTile) {
        let xuid = _m_xuid;
        elTile.FindChildTraverse('JsInviteAdvertisingPlayer').SetPanelEvent('onactivate', () => {
            FriendsListAPI.ActionInviteFriend(xuid, '');
            $.DispatchEvent('FriendInvitedFromContextMenu', xuid);
        });
    }
})(FriendAdvertiseTile || (FriendAdvertiseTile = {}));
