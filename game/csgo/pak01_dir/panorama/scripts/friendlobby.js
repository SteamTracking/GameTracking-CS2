"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="common/commonutil.ts" />
var friendLobby;
(function (friendLobby) {
    let _m_xuid = '';
    let _m_isInPopup = false;
    function Init(elTile) {
        const _m_isPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld" ? true : false;
        _m_xuid = elTile.GetAttributeString('xuid', '(not found)');
        if (_m_xuid === '(not found)') {
            return;
        }
        _m_isInPopup = elTile.GetAttributeString('showinpopup', 'false') === 'true' ? true : false;
        let lobbyType = PartyBrowserAPI.GetPartyType(_m_xuid);
        let gameMode = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/mode');
        elTile.SetHasClass('playerforhire', (lobbyType === 'nearby'));
        _SetLobbyLeaderNameAvatar(elTile, lobbyType);
        _SetGroupNameLink(elTile, lobbyType);
        _SetPrime(elTile);
        if (!_m_isPerfectWorld) {
            _SetRegion(elTile);
        }
        _SetSkillGroup(elTile, gameMode);
        _SetLobbySettings(elTile, gameMode);
        _SetLobbyPlayerSlots(elTile, gameMode, lobbyType);
        _SetUpJoinBtn(elTile, lobbyType);
        _SetUpLobbiesPopupBtn(elTile);
        _SetDismissButton(elTile, lobbyType);
        elTile.SetHasClass('friendlobby--is-in-popup', _m_isInPopup);
    }
    friendLobby.Init = Init;
    function _SetLobbyLeaderNameAvatar(elTile, lobbyType) {
        let xuidLobbyLeader = PartyBrowserAPI.GetPartyMemberXuid(_m_xuid, 0);
        let rawName = FriendsListAPI.GetFriendName(xuidLobbyLeader);
        elTile.SetDialogVariable('friendname', rawName);
        let nameString = (lobbyType === 'invited') ? '#tooltip_friend_invited_you' : "#tooltip_lobby_leader_name";
        elTile.FindChildTraverse('JsFriendLobbyLeaderName').text = nameString;
        elTile.FindChildTraverse('JsFriendLobbyLeaderAvatar').PopulateFromSteamID(xuidLobbyLeader);
        elTile.FindChildTraverse('JsFriendLobbyLeaderBtn').SetPanelEvent('onactivate', () => _OpenContextMenu(xuidLobbyLeader));
    }
    function _SetPrime(elTile) {
        let primeValue = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/apr');
        elTile.FindChildTraverse('JsFriendLobbyPrime').visible = (primeValue && primeValue != '0') ? true : false;
    }
    function _SetRegion(elTile) {
        let countryCode = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/loc');
        CommonUtil.SetRegionOnLabel(countryCode, elTile);
    }
    function _SetSkillGroup(elTile, gameMode) {
        let szSkillGroupType = "Competitive";
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
            do_fx: true,
            full_details: false,
            rating_type: szSkillGroupType,
            leaderboard_details: { score: score },
            local_player: _m_xuid === MyPersonaAPI.GetXuid()
        };
        RatingEmblem.SetXuid(options);
    }
    function _SetLobbySettings(elTile, gameMode) {
        let gameModeType = GameTypesAPI.GetGameModeType(gameMode);
        let gameModeDisplay = GameTypesAPI.GetGameModeAttribute(gameModeType, gameMode, 'nameID');
        elTile.SetDialogVariable('lobby-mode', $.Localize(gameModeDisplay));
        elTile.SetDialogVariable('lobby-maps', _GetMapNames(gameMode));
    }
    function _GetMapNames(gameMode) {
        let mapGroups = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, 'game/mapgroupname');
        if (mapGroups == 'workshop')
            return $.Localize('#SFUI_Groups_workshop');
        if (!mapGroups)
            mapGroups = '';
        let mapsList = mapGroups.split(',');
        let mapsNiceNamesList = [];
        for (let i = 0; i < mapsList.length; i++) {
            if (i < 4) {
                let mapNiceName = GameTypesAPI.GetMapGroupAttribute(mapsList[i], 'nameID');
                mapsNiceNamesList.push($.Localize(mapNiceName));
            }
        }
        return mapsNiceNamesList.join(', ');
    }
    function _SetLobbyPlayerSlots(elTile, gameMode, lobbyType) {
        if (lobbyType === 'nearby')
            return;
        let numSlotsToShow = SessionUtil.GetMaxLobbySlotsForGameMode(gameMode) - 1;
        let elAvatarRow = elTile.FindChildTraverse('JsFriendLobbyAvatars');
        for (let i = 1; i <= numSlotsToShow; i++) {
            let xuid = PartyBrowserAPI.GetPartyMemberXuid(_m_xuid, i);
            let slotId = _m_xuid + ':' + i;
            let playerSlot = elAvatarRow.FindChild(slotId);
            if (!playerSlot) {
                playerSlot = $.CreatePanel('Panel', elAvatarRow, slotId);
                playerSlot.BLoadLayoutSnippet('FriendLobbyAvatarSlot');
            }
            if (i === 1)
                playerSlot.AddClass('friendlobby__slot--first');
            let elEmpty = playerSlot.FindChildTraverse('JsFriendAvatarEmpty');
            let elAvatar = playerSlot.FindChildTraverse('JsFriendAvatar');
            if (xuid) {
                elAvatar.PopulateFromSteamID(xuid);
                playerSlot.FindChild('JsFriendAvatarBtn').SetPanelEvent('onactivate', () => _OpenContextMenu(xuid));
                elEmpty.visible = false;
                elAvatar.visible = true;
            }
            else {
                elEmpty.visible = true;
                elAvatar.visible = false;
            }
        }
    }
    function _SetUpJoinBtn(elTile, lobbyType) {
        let elJoinBtn = elTile.FindChildInLayoutFile('JsFriendLobbyJoinBtn');
        let clientInLobby = false;
        let clientXuid = MyPersonaAPI.GetXuid();
        let count = PartyBrowserAPI.GetPartyMembersCount(_m_xuid);
        for (let i = 0; i <= count; i++) {
            if (clientXuid === PartyBrowserAPI.GetPartyMemberXuid(_m_xuid, i)) {
                clientInLobby = true;
                break;
            }
        }
        if (clientInLobby || lobbyType === 'suggested') {
            elJoinBtn.AddClass('hidden');
            return;
        }
        elJoinBtn.RemoveClass('hidden');
        let tooltipText = $.Localize((lobbyType === 'invited') ? '#tooltip_accept_invite' : '#tooltip_join_public_lobby');
        elJoinBtn.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip('JsFriendLobbyJoinBtn', tooltipText));
        elJoinBtn.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
        let lobbyLeaderXuid = _m_xuid;
        elJoinBtn.SetPanelEvent('onactivate', () => {
            $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'PanoramaUI.Lobby.Joined', 'MOUSE', 1.0);
            PartyBrowserAPI.ActionJoinParty(lobbyLeaderXuid);
        });
    }
    function _SetGroupNameLink(elTile, lobbyType) {
        let elGroupLBtn = elTile.FindChildTraverse('JsFriendLobbyGroupBtn');
        let elGroupLabel = elTile.FindChildTraverse('JsFriendLobbyGroupTxt');
        if (lobbyType === 'invited') {
            elGroupLabel.visible = false;
            elGroupLBtn.visible = false;
        }
        if (lobbyType === 'nearby') {
            elGroupLabel.text = $.Localize('#SFUI_Lobby_GroupsNearby');
            elGroupLBtn.enabled = false;
        }
        else {
            let clanId = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, "game/clanid");
            let clanName = PartyBrowserAPI.GetPartySessionSetting(_m_xuid, "game/clantag");
            if (lobbyType === 'suggested') {
                elGroupLabel.SetDialogVariable('group', clanName);
                elGroupLabel.text = $.Localize('#FriendsLobby_GroupsSuggested', elGroupLabel);
            }
            else {
                elGroupLabel.SetDialogVariable('group', clanName);
                elGroupLabel.text = $.Localize('#FriendsLobby_GroupName', elGroupLabel);
            }
            let onActivate = _GetClanLink(clanId);
            elGroupLBtn.SetPanelEvent('onactivate', onActivate);
            elGroupLBtn.enabled = true;
        }
    }
    function _SetDismissButton(elTile, lobbyType) {
        if (lobbyType === 'invited') {
            var elCloseButton = elTile.FindChildInLayoutFile('FriendLobbyCloseButton');
            elCloseButton.RemoveClass('hidden');
            elCloseButton.SetPanelEvent("onactivate", function () {
                $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'PanoramaUI.Lobby.Left', 'MOUSE', 1.0);
                PartyBrowserAPI.ClearInvite(elTile.GetAttributeString('xuid', '(not found)'));
            });
            elCloseButton.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip('FriendLobbyCloseButton', $.Localize('#tooltip_discard_invite'));
            });
            elCloseButton.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideTextTooltip();
            });
        }
    }
    function _SetUpLobbiesPopupBtn(elTile) {
        let elAlert = elTile.FindChildInLayoutFile('JsFriendLobbyCount');
        let nLobbies = PartyBrowserAPI.GetInvitesCount();
        if (nLobbies < 2) {
            elTile.FindChildInLayoutFile('JsFriendLobbySeeAllInvites').visible = false;
            return;
        }
        if (elAlert && elAlert.IsValid()) {
            elAlert.SetDialogVariable("lobby_count", (nLobbies - 1).toString());
            elAlert.SetDialogVariable("alert_value", $.Localize('#friends_lobby_count', elAlert));
        }
        let elBtn = elTile.FindChildInLayoutFile('JsFriendLobbySeeAllInvitesBtn');
        elBtn.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('JsFriendLobbySeeAllInvitesBtn', $.Localize('#tooltip_lobby_count'));
        });
        elBtn.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        elBtn.SetPanelEvent('onactivate', OpenLobbiesContextMenu);
    }
    function OpenLobbiesContextMenu() {
        var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenu('', '', 'file://{resources}/layout/context_menus/context_menu_lobbies.xml');
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
    }
    function _GetClanLink(clanId) {
        return () => {
            let link = '';
            if (SteamOverlayAPI.GetAppID() == 710)
                link = "http://beta.steamcommunity.com/gid/" + clanId;
            else
                link = "http://steamcommunity.com/gid/" + clanId;
            SteamOverlayAPI.OpenURL(link);
        };
    }
    function _OpenContextMenu(xuid) {
        $.DispatchEvent('SidebarContextMenuActive', true);
        var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => $.DispatchEvent('SidebarContextMenuActive', false));
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
    }
})(friendLobby || (friendLobby = {}));
