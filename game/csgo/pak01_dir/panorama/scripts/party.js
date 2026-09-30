"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="avatar.ts" />
/// <reference path="friendslist.ts" />
var PartyMenu;
(function (PartyMenu) {
    let elPartySection = $('#PartyList');
    let m_eventRebuildPartyList;
    let m_prevMembersInParty = 1;
    function _Init() {
        _RefreshPartyMembers();
        _AddOnActivateLeaveBtn();
        _ShowMatchmakingStatusTooltipEvent();
    }
    function _RefreshPartyMembers() {
        if (!_IsSessionActive()) {
            return;
        }
        let lobbySettings = LobbyAPI.GetSessionSettings().game;
        if (!lobbySettings) {
            return;
        }
        let elPartyMembersList = elPartySection.FindChildInLayoutFile('PartyMembers');
        _UpdateNumPlayersInparty();
        let bIsSearching = _IsSearching();
        if (m_prevMembersInParty >= PartyListAPI.GetPartySessionUiThreshold() || bIsSearching) {
            elPartyMembersList.RemoveAndDeleteChildren();
            _UpdateMembersList(lobbySettings, m_prevMembersInParty);
        }
        else {
            elPartySection.AddClass('hidden');
            FriendsList.UpdateHeightOpenSection();
            elPartyMembersList.RemoveAndDeleteChildren();
        }
        elPartySection.GetParent().SetHasClass('friendslist-party-searching', bIsSearching && (m_prevMembersInParty <= 1));
        _UpdateLeaveBtn();
    }
    function _UpdateNumPlayersInparty() {
        let numPlayersActuallyInParty = PartyListAPI.GetCount();
        if (numPlayersActuallyInParty > m_prevMembersInParty) {
            $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'PanoramaUI.Lobby.Joined', 'PartyList', 1.0);
        }
        else if (numPlayersActuallyInParty < m_prevMembersInParty) {
            $.DispatchEvent('CSGOPlaySoundEffectMuteBypass', 'PanoramaUI.Lobby.Left', 'PartyList', 1.0);
        }
        m_prevMembersInParty = numPlayersActuallyInParty;
        elPartySection.SetDialogVariable('alert_value', String(numPlayersActuallyInParty));
    }
    function _IsSessionActive() {
        if (!LobbyAPI.IsSessionActive()) {
            elPartySection.AddClass('hidden');
            FriendsList.UpdateHeightOpenSection();
            elPartySection.GetParent().SetHasClass('friendslist-party-searching', false);
            return false;
        }
        return true;
    }
    function _UpdateMembersList(lobbySettings, numPlayersActuallyInParty) {
        let maxAllowedInLobby = 10;
        let numPlayersPossibleInMode = SessionUtil.GetMaxLobbySlotsForGameMode(lobbySettings.mode);
        if (elPartySection.BHasClass('hidden')) {
            elPartySection.RemoveClass('hidden');
        }
        FriendsList.UpdateHeightOpenSection();
        for (let i = 0; i < maxAllowedInLobby; i++) {
            let xuid = i < numPlayersActuallyInParty ? PartyListAPI.GetXuidByIndex(i) : '0';
            let isOverPossible = (numPlayersActuallyInParty > numPlayersPossibleInMode) ? true : false;
            let elPartyMemberCurrent = null;
            if (i < numPlayersActuallyInParty) {
                elPartyMemberCurrent = _MakeNewPartyMemberTile("PartyMember" + i, xuid);
                _SetPartyMemberRank(elPartyMemberCurrent, xuid);
                _SetPrimeForMember(elPartyMemberCurrent, xuid);
                _UpdateAvatar(elPartyMemberCurrent, xuid);
                _TintForOverPlayerCountForMode(elPartyMemberCurrent, isOverPossible);
            }
        }
        _SetLobbyTitle(numPlayersPossibleInMode, numPlayersActuallyInParty);
    }
    function _MakeNewPartyMemberTile(panelIdToLoad, xuid) {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('PartyMembers');
        let elPartyMember = $.CreatePanel("Panel", elParent, panelIdToLoad);
        elPartyMember.BLoadLayoutSnippet('PartyMember');
        elPartyMember.Data().xuid = xuid;
        elPartyMember.SetDialogVariable('partyxuid', xuid);
        let memberBtn = elPartyMember.FindChildInLayoutFile('PartyMemberBtn');
        let elAvatar = $.CreatePanel("Panel", memberBtn, xuid);
        _SetAttributeStringsOnAvatarPanel(elAvatar, xuid);
        elAvatar.BLoadLayout('file://{resources}/layout/avatar.xml', false, false);
        elAvatar.BLoadLayoutSnippet("AvatarParty");
        elAvatar.enabled = false;
        _SetHonorIcon(elPartyMember, xuid);
        memberBtn.MoveChildBefore(elAvatar, memberBtn.GetChild(0));
        if (xuid != '0' && xuid)
            _AddOpenPlayerCardAction(memberBtn, xuid);
        else
            _ClearExisitingOnActivateEvent(memberBtn);
        return elPartyMember;
    }
    function _SetHonorIcon(elPartyMember, xuid) {
        const elHonorIcon = elPartyMember.FindChildTraverse('jsHonorIcon');
        if (elHonorIcon) {
            elHonorIcon.Set(PartyListAPI.GetFriendXpTrailLevel(xuid), PartyListAPI.GetFriendPrimeEligible(xuid));
        }
    }
    function _UpdateAvatar(elPartyMember, xuid) {
        let elAvatar = elPartyMember.FindChildInLayoutFile(xuid);
        Avatar.Init(elAvatar, xuid, 'partymember');
    }
    function _SetPartyMemberRank(elPartyMember, xuid) {
        let skillgroupType = PartyListAPI.GetFriendCompetitiveRankType(xuid);
        let skillGroup = PartyListAPI.GetFriendCompetitiveRank(xuid);
        let wins = PartyListAPI.GetFriendCompetitiveWins(xuid);
        let winsNeededForRank = SessionUtil.GetNumWinsNeededForRank(skillgroupType);
        let elRank = elPartyMember.FindChildInLayoutFile('PartyRank');
        if (wins < winsNeededForRank || (wins >= winsNeededForRank && skillGroup < 1) || !PartyListAPI.GetFriendPrimeEligible(xuid)) {
            elRank.visible = false;
            return;
        }
        let imageName = (skillgroupType !== 'Competitive') ? skillgroupType : 'skillgroup';
        elRank.SetImage('file://{images}/icons/skillgroups/' + imageName + skillGroup + '.svg');
        elRank.visible = true;
    }
    function _SetPrimeForMember(elPartyMember, xuid) {
        return;
    }
    function _TintForOverPlayerCountForMode(elPartyMember, isOverCount) {
        elPartyMember.SetHasClass('friendtile--warning', isOverCount);
    }
    function _SetLobbyTitle(numPlayersPossibleInMode, numPlayersActuallyInParty) {
        let elPanel = $('#PartyList').FindChildInLayoutFile('PartyListHeader');
        elPanel.FindChildInLayoutFile('PartyCancelBtn').visible = LobbyAPI.BIsHost() && _IsSearching();
        let elCount = elPanel.FindChildInLayoutFile('PartyTitleAlertText');
        elCount.text = numPlayersActuallyInParty + '/' + numPlayersPossibleInMode;
    }
    function _SetAttributeStringsOnAvatarPanel(elAvatar, xuid) {
        elAvatar.SetAttributeString('xuid', xuid);
        elAvatar.SetAttributeString('showleader', _ShowLobbyLeaderIcon(xuid));
    }
    function _ShowLobbyLeaderIcon(xuid) {
        return LobbyAPI.GetHostSteamID() === xuid ? 'show' : '';
    }
    function _AddOpenPlayerCardAction(elPartyMember, xuid) {
        function openCard() {
            $.DispatchEvent('SidebarContextMenuActive', true);
            if (xuid != '0') {
                let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => $.DispatchEvent('SidebarContextMenuActive', false));
                contextMenuPanel.AddClass("ContextMenu_NoArrow");
            }
        }
        ;
        elPartyMember.SetPanelEvent("onactivate", openCard);
        elPartyMember.SetPanelEvent("oncontextmenu", openCard);
    }
    function _ClearExisitingOnActivateEvent(elPartyMember) {
        elPartyMember.SetPanelEvent("onactivate", () => { });
        elPartyMember.SetPanelEvent("onmouseover", () => UiToolkitAPI.ShowTextTooltip(elPartyMember.id, '#tooltip_invite_to_lobby'));
        elPartyMember.SetPanelEvent("onmouseout", () => UiToolkitAPI.HideTextTooltip());
    }
    function _SessionUpdate(updateType) {
        if (LobbyAPI.IsSessionActive()) {
            if (m_eventRebuildPartyList == undefined) {
                m_eventRebuildPartyList = $.RegisterForUnhandledEvent("PanoramaComponent_PartyList_RebuildPartyList", _RefreshPartyMembers);
            }
        }
        else {
            if (m_eventRebuildPartyList) {
                $.UnregisterForUnhandledEvent("PanoramaComponent_PartyList_RebuildPartyList", m_eventRebuildPartyList);
                m_eventRebuildPartyList = undefined;
            }
        }
        _RefreshPartyMembers();
        _TintBgForSearch();
    }
    function _TintBgForSearch() {
        let serverWarning = NewsAPI.GetCurrentActiveAlertForUser();
        let isWarning = serverWarning !== '' && serverWarning !== undefined ? true : false;
        $.GetContextPanel().FindChildInLayoutFile('MatchStatusBackground').SetHasClass('party-list__bg--warning', (isWarning && _IsSeaching()));
        $.GetContextPanel().FindChildInLayoutFile('MatchStatusBackground').SetHasClass('party-list__bg--searching', _IsSeaching());
    }
    function _IsSeaching() {
        let StatusString = _GetSearchStatus();
        return (StatusString !== '' && StatusString !== null) ? true : false;
    }
    function _PlayerActivityVoice(xuid) {
        let elPartyMembersList = elPartySection.FindChildInLayoutFile('PartyMembers');
        elPartyMembersList.Children().forEach(element => {
            if (element.Data().xuid === xuid) {
                let elAvatar = element.FindChildInLayoutFile(xuid);
                if (elAvatar) {
                    Avatar.UpdateTalkingState(elAvatar, xuid);
                }
            }
        });
    }
    function _UpdateLeaveBtn() {
        let elLeaveBtn = elPartySection.FindChildInLayoutFile('PartyLeaveBtn');
        elLeaveBtn.visible = (!GameStateAPI.IsLocalPlayerPlayingMatch() && LobbyAPI.IsSessionActive());
    }
    function _AddOnActivateLeaveBtn() {
        let elLeaveBtn = elPartySection.FindChildInLayoutFile('PartyLeaveBtn');
        elLeaveBtn.SetPanelEvent('onactivate', () => LobbyAPI.CloseSession());
    }
    function _GetSearchStatus() {
        return LobbyAPI.GetMatchmakingStatusString();
    }
    function _IsSearching() {
        let StatusString = _GetSearchStatus();
        return (StatusString !== '' && StatusString !== null) ? true : false;
    }
    function _ShowMatchmakingStatusTooltipEvent() {
        let btnSettings = $.GetContextPanel().FindChildInLayoutFile('MatchStatusInfo');
        btnSettings.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowCustomLayoutParametersTooltip('MatchStatusInfo', 'LobbySettingsTooltip', 'file://{resources}/layout/tooltips/tooltip_lobby_settings.xml', 'xuid=' + '');
        });
        btnSettings.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideCustomLayoutTooltip('LobbySettingsTooltip'));
    }
    {
        _Init();
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _SessionUpdate);
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_PlayerUpdated", _SessionUpdate);
        $.RegisterForUnhandledEvent("PanoramaComponent_PartyList_PlayerActivityVoice", _PlayerActivityVoice);
    }
})(PartyMenu || (PartyMenu = {}));
