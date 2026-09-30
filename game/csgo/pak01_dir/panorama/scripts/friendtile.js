"use strict";
/// <reference path="csgo.d.ts" />
var FriendTile;
(function (FriendTile) {
    let _m_xuid = '';
    let _m_isClan = false;
    let _m_hasClanInfo = false;
    let _m_clanHandle = null;
    function Init(elTile) {
        _m_xuid = elTile.GetAttributeString('xuid', '(not found)');
        _m_isClan = elTile.GetAttributeString('isClan', 'false') === 'true';
        if (_m_isClan) {
            _m_hasClanInfo = FriendsListAPI.GetClanInfoById32Bit(FriendsListAPI.ConvertXuidToId32Bit(_m_xuid), 'name') != '';
            if (!_m_clanHandle)
                _m_clanHandle = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_ClansInfoUpdated', _ClansInfoUpdated);
        }
        _SetImage(elTile);
        _SetHonorIcon(elTile);
        _SetName(elTile);
        _SetStatus(elTile);
        _SetStatusBar(elTile);
        _SetInvitedFromCallback(elTile);
        _SetCanJoin(elTile);
        _SetCanWatch(elTile);
        _SetOnActivateEvent(elTile);
    }
    FriendTile.Init = Init;
    function _SetHonorIcon(elTile) {
        const elHonorIcon = elTile.FindChildTraverse('jsHonorIcon');
        if (elHonorIcon)
            elHonorIcon.Set(FriendsListAPI.GetFriendXpTrailLevel(_m_xuid), false);
    }
    function _SetImage(elTile) {
        let elAvatarImg = elTile.FindChildTraverse('JsFriendAvatar');
        elAvatarImg.PopulateFromSteamID(_m_xuid);
        elAvatarImg.visible = !_m_isClan || _m_hasClanInfo;
    }
    function _SetStatusBar(elTile) {
        let elBg = elTile.FindChildTraverse('JsFriendTileStatusBg');
        let statusBucket = FriendsListAPI.GetFriendStatusBucket(_m_xuid);
        let isFriend = FriendsListAPI.GetFriendRelationship(_m_xuid);
        if (TeammatesAPI.GetCoPlayerInCSGO(_m_xuid) && isFriend !== "friend") {
            statusBucket = "PlayingCSGO";
        }
        else if (isFriend !== "friend") {
            statusBucket = "Offline";
        }
        elBg.SetHasClass('ingame', statusBucket === "PlayingCSGO");
    }
    function _SetName(elTile) {
        let elLabel = elTile.FindChildTraverse('JsFriendName');
        if (!_m_isClan) {
            let name = FriendsListAPI.GetFriendName(_m_xuid);
            if (name === "[unknown]") {
                name = '[' + $.Localize('SFUI_Friends_Unknown') + ']';
            }
            elLabel.text = name;
        }
        else {
            elLabel.text = FriendsListAPI.GetClanInfoById32Bit(FriendsListAPI.ConvertXuidToId32Bit(_m_xuid), 'name');
            elLabel.visible = !_m_isClan || _m_hasClanInfo;
        }
    }
    function _SetStatus(elTile) {
        let friendStatusText = '';
        if (_m_isClan) {
            friendStatusText = "#steamgroup";
        }
        else {
            if (elTile.Data().type === 'recent') {
                friendStatusText = TeammatesAPI.GetCoPlayerTime(_m_xuid);
            }
            if (!friendStatusText)
                friendStatusText = FriendsListAPI.GetFriendStatus(_m_xuid);
        }
        let elLabel = elTile.FindChildTraverse('JsFriendStatus');
        elLabel.text = $.Localize(friendStatusText);
    }
    function _SetInvitedFromCallback(elTile) {
        let isInvited = FriendsListAPI.IsFriendInvited(_m_xuid);
        _SetInvited(elTile, isInvited);
    }
    function SetInvitedFromContextMenu(elTile) {
        _SetInvited(elTile, true);
    }
    FriendTile.SetInvitedFromContextMenu = SetInvitedFromContextMenu;
    function _SetInvited(elTile, isInvited) {
        let elInvited = elTile.FindChildTraverse('JsFriendInvited');
        if (elInvited !== null)
            elInvited.SetHasClass('hidden', !isInvited);
    }
    function _SetCanJoin(elTile) {
        let canJoin = FriendsListAPI.IsFriendJoinable(_m_xuid);
        elTile.FindChildTraverse('JsFriendJoin').SetHasClass('hidden', !canJoin);
    }
    function _SetCanWatch(elTile) {
        let canWatch = FriendsListAPI.IsFriendWatchable(_m_xuid);
        elTile.FindChildTraverse('JsFriendWatch').SetHasClass('hidden', !canWatch);
    }
    function _SetOnActivateEvent(elTile) {
        if (_m_isClan) {
            elTile.SetPanelEvent('onactivate', () => {
                SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser("https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/gid/" + _m_xuid);
            });
            return;
        }
        function OpenContextMenu(xuid) {
            $.DispatchEvent('SidebarContextMenuActive', true);
            let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid +
                (elTile.Data().type ? ('&type=' + elTile.Data().type) : ''), () => $.DispatchEvent('SidebarContextMenuActive', false));
            contextMenuPanel.AddClass("ContextMenu_NoArrow");
        }
        elTile.FindChildTraverse('JsFriendTileBtn').SetPanelEvent('onactivate', OpenContextMenu.bind(undefined, _m_xuid));
        elTile.FindChildTraverse('JsFriendTileBtn').SetPanelEvent('oncontextmenu', OpenContextMenu.bind(undefined, _m_xuid));
    }
    function _ClansInfoUpdated() {
        let elTile = $.GetContextPanel().FindChildTraverse('JsKeyValidatedResult');
        if (elTile.codeType === 'g' && !elTile.FindChildTraverse('JsAvatarImage')) {
            Init(elTile);
        }
    }
})(FriendTile || (FriendTile = {}));
