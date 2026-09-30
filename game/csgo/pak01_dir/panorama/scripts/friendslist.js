"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="advertising_toggle.ts" />
/// <reference path="friendtile.ts" />
/// <reference path="friendlobby.ts" />
/// <reference path="friend_advertise_tile.ts" />
var FriendsList;
(function (FriendsList) {
    let _m_isPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld" ? true : false;
    let m_activeSection = 'id-friendslist-section-friends';
    let m_Sections = $.GetContextPanel().FindChildInLayoutFile('id-friendslist-accordian');
    let _m_sLobbiesTabListFiltersString = GameInterfaceAPI.GetSettingString('ui_nearbylobbies_filter');
    let _m_schfnUpdateAntiAddiction = null;
    let _m_ClosedSectionHeight = Math.floor($.GetContextPanel().FindChildInLayoutFile('id-friendslist-section-recent').desiredlayoutheight / $.GetContextPanel().actualuiscale_x);
    function _Init() {
        let btnLobbiesTabListFilters = $('#JsFriendsList-lobbies-toolbar-button-' + _m_sLobbiesTabListFiltersString);
        AdvertisingToggle.OnFilterPressed(_m_sLobbiesTabListFiltersString);
        if (btnLobbiesTabListFilters) {
            btnLobbiesTabListFilters.checked = true;
            let elParent = btnLobbiesTabListFilters.GetParent();
            for (let child of elParent.Children()) {
                let gameMode = child.GetAttributeString('data-type', '');
                if (gameMode !== '') {
                    child.visible = PartyListAPI.IsPlayerForHireAdvertisingEnabledForGameMode(gameMode);
                }
            }
        }
        _UpdateBroadcastIcon();
    }
    function _UpdateBroadcastIcon() {
        let adSetting = AdvertisingToggle.GetAdvertisingSetting();
        _ActiveFilterOnTab(adSetting);
        $.GetContextPanel().FindChildInLayoutFile('id-friendslist-section-broadcast-icon').SetHasClass('advertising-active', adSetting !== "");
    }
    function _UpdateAntiAddiction() {
        let elAAGroup = $.GetContextPanel().FindChildInLayoutFile('AntiAddiction');
        let numSec = _m_isPerfectWorld ? MyPersonaAPI.GetAntiAddictionTimeRemaining() : -1;
        if (numSec < 0) {
            elAAGroup.AddClass('hidden');
            return false;
        }
        elAAGroup.RemoveClass('hidden');
        let szSeverity = 'Green';
        if (numSec <= 300)
            szSeverity = 'Red';
        else if (numSec <= 1800)
            szSeverity = 'Yellow';
        let elAAIcon = elAAGroup.FindChildInLayoutFile('AntiAddictionIcon');
        elAAIcon.SetHasClass('anti-addiction-Green', 'Green' === szSeverity);
        elAAIcon.SetHasClass('anti-addiction-Yellow', 'Yellow' === szSeverity);
        elAAIcon.SetHasClass('anti-addiction-Red', 'Red' === szSeverity);
        let strTimeRemainingSentence = (numSec >= 60)
            ? FormatText.SecondsToSignificantTimeString(numSec)
            : $.Localize('#AntiAddiction_Label_TimeRemainingNone');
        elAAGroup.SetDialogVariable('aatime', strTimeRemainingSentence);
        let szLocalizedTooltip = $.Localize(((numSec >= 60)
            ? '#UI_AntiAddiction_Tooltip_GameTime'
            : '#UI_AntiAddiction_Tooltip_GameTimeNone'), elAAGroup);
        elAAGroup.SetPanelEvent("onmouseover", () => {
            UiToolkitAPI.ShowTextTooltip('AntiAddiction', szLocalizedTooltip);
        });
        if (_m_schfnUpdateAntiAddiction)
            $.CancelScheduled(_m_schfnUpdateAntiAddiction);
        _m_schfnUpdateAntiAddiction = $.Schedule(30, _UpdateAntiAddictionTimer);
    }
    function _UpdateAntiAddictionTimer() {
        _m_schfnUpdateAntiAddiction = null;
        _UpdateAntiAddiction();
    }
    function _UpdateIncomingInvitesContainer() {
        let elInviteRoot = $.GetContextPanel().FindChildInLayoutFile('JsIncomingInvites');
        elInviteRoot.AddClass('hidden');
        let elInviteContainer = elInviteRoot.FindChildInLayoutFile('JsIncomingInviteContainer');
        elInviteContainer.RemoveAndDeleteChildren();
        let numInvites = PartyBrowserAPI.GetInvitesCount();
        if (numInvites > 0) {
            let xuid = PartyBrowserAPI.GetInviteXuidByIndex(0);
            _AddTile(elInviteContainer, null, xuid, 0, 'friendlobby', null);
            elInviteRoot.RemoveClass('hidden');
        }
        UpdateHeightOpenSection();
    }
    function OnSectionPressed(sectionId) {
        if (!sectionId) {
            return;
        }
        if (m_activeSection !== sectionId) {
            m_activeSection = sectionId;
            if (sectionId === 'id-friendslist-section-recent') {
                TeammatesAPI.Refresh();
            }
            if (sectionId === 'id-friendslist-section-broadcast') {
                RefreshLobbyListings();
            }
        }
        _UpdateSection(sectionId, false);
    }
    FriendsList.OnSectionPressed = OnSectionPressed;
    function _UpdateAllSections() {
        _UpdateSection('', true);
    }
    function _UpdateSection(sectionId, bUpdateAll) {
        if (_m_ClosedSectionHeight === 0 || _m_ClosedSectionHeight === undefined) {
            _m_ClosedSectionHeight = Math.floor($.GetContextPanel().FindChildInLayoutFile('id-friendslist-section-recent').desiredlayoutheight / $.GetContextPanel().actualuiscale_x);
        }
        let funcGetXuid;
        if (sectionId === 'id-friendslist-section-friends' || bUpdateAll) {
            funcGetXuid = _GetXuidByIndex;
            _UpdateSectionContent({
                id: 'id-friendslist-section-friends',
                count: _GetFriendsCount(),
                xml: 'friendtile',
                xuid_func: funcGetXuid,
                no_data_String: '#FriendsList_nodata_friends'
            });
        }
        if (sectionId === 'id-friendslist-section-recent' || bUpdateAll) {
            funcGetXuid = _GetRecentXuidByIndex;
            _UpdateSectionContent({
                id: 'id-friendslist-section-recent',
                count: _GetRecentsCount(),
                xml: 'friendtile',
                xuid_func: funcGetXuid,
                type: 'recent',
                no_data_String: '#FriendsList_nodata_recents',
                show_loading_bar_only: _ShowRecentsLoadingBar(),
                loading_bar_id: 'JsFriendsListRecentsLoadingBar'
            });
        }
        if (sectionId === 'id-friendslist-section-invite' || m_activeSection === 'id-friendslist-section-invite' || bUpdateAll) {
            funcGetXuid = _GetRequestsXuidByIndex;
            _UpdateSectionContent({
                id: 'id-friendslist-section-invite',
                count: _GetRequestsCount(),
                alerts_count: _GetRequestsAlertCount(),
                xml: 'friendtile',
                xuid_func: funcGetXuid,
                no_data_String: '#FriendsList_nodata_requests',
                hide_if_empty: true
            });
        }
        if (sectionId === 'id-friendslist-section-broadcast' || bUpdateAll) {
            _UpdateLobbiesLoadingBar();
            funcGetXuid = _GetLobbyXuidByIndex;
            _UpdateSectionContent({
                id: 'id-friendslist-section-broadcast',
                count: _GetLobbiesCount(),
                xml: 'friend_advertise_tile',
                xuid_func: funcGetXuid,
                no_data_String: '#FriendsList_nodata_advertising'
            });
        }
    }
    function _UpdateSectionContent(oSettings) {
        let elSection = m_Sections.FindChildInLayoutFile(oSettings.id);
        let count = (oSettings.hasOwnProperty('alerts_count') ? oSettings.alerts_count : oSettings.count);
        _ShowHideCounter(elSection, count);
        if (oSettings.hasOwnProperty('hide_if_empty') && oSettings.hide_if_empty === true && count < 1) {
            elSection.SetHasClass('hidden', true);
            return;
        }
        elSection.SetHasClass('hidden', false);
        if (oSettings.hasOwnProperty('show_loading_bar_only') && oSettings.show_loading_bar_only) {
            return;
        }
        if (m_activeSection === oSettings.id) {
            let elNodata = elSection.FindChildInLayoutFile('id-friendslist-nodata');
            let elList = elSection.FindChildInLayoutFile('id-friendslist-section-list-contents');
            if (oSettings.count && oSettings.count > 0) {
                elNodata.visible = false;
                elList.visible = true;
                _MakeOrUpdateTiles(elList, oSettings);
                _SetSectionHeight(oSettings.id);
                return;
            }
            elNodata.SetDialogVariable('no_data_title', $.Localize(oSettings.no_data_String + '_title'));
            elNodata.SetDialogVariable('no_data_body', $.Localize(oSettings.no_data_String));
            elNodata.visible = true;
            elList.visible = false;
            _SetSectionHeight(oSettings.id);
        }
    }
    function _GetAddtionalSectionHeight(idSection) {
        let elPanel = $.GetContextPanel().FindChildInLayoutFile(idSection);
        return elPanel.BHasClass('hidden') ? 0 :
            Math.floor(elPanel.desiredlayoutheight / m_Sections.actualuiscale_x);
    }
    function _SetSectionHeight(sectionId) {
        let aSectionsToClose = m_Sections.Children().filter(element => element.id !== m_activeSection && !element.BHasClass('hidden'));
        for (let element of aSectionsToClose) {
            let elList = element.FindChildInLayoutFile('id-friendslist-section-list');
            elList.style.height = '0px;';
        }
        let closedSectionsHeight = _m_ClosedSectionHeight * (aSectionsToClose.length + 1);
        let basicHeight = Math.floor(($.GetContextPanel().desiredlayoutheight / $.GetContextPanel().actualuiscale_x)) -
            (closedSectionsHeight + _GetAddtionalSectionHeight('PartyList') + _GetAddtionalSectionHeight('JsIncomingInvites'));
        m_Sections.FindChildInLayoutFile(sectionId).FindChildInLayoutFile('id-friendslist-section-list').style.height = basicHeight + "px;";
    }
    function _ShowHideCounter(elSection, count) {
        if (!count) {
            elSection.SetHasClass('hide-notification', true);
            return;
        }
        elSection.SetDialogVariable('alert_value', String(count));
        elSection.SetHasClass('hide-notification', false);
    }
    function _MakeOrUpdateTiles(elList, oSettings) {
        elList.SetLoadListItemFunction((parent, nPanelIdx, reusePanel) => {
            let xuid = oSettings.xuid_func(nPanelIdx);
            if (!reusePanel || !reusePanel.IsValid()) {
                reusePanel = _AddTile(elList, null, xuid, nPanelIdx, oSettings.xml, oSettings.type);
            }
            else {
                reusePanel.SetAttributeString("xuid", xuid);
                _InitTile(reusePanel, oSettings.xml);
            }
            return reusePanel;
        });
        if (oSettings.count) {
            elList.UpdateListItemsNonDestructive(oSettings.count);
            for (let i = 0; i < oSettings.count; ++i) {
                if (elList.TryGetListItemAtIndex(i))
                    elList.ReloadListItem(i);
            }
        }
    }
    function _AddTile(elList, children, xuid, index, tileXmlToUse, type) {
        let elTile = $.CreatePanel("Panel", elList, xuid);
        elTile.SetAttributeString('xuid', xuid);
        elTile.BLoadLayout('file://{resources}/layout/' + tileXmlToUse + '.xml', false, false);
        if (type) {
            elTile.Data().type = type;
        }
        if (tileXmlToUse) {
            elTile.Data().tileXmlToUse = tileXmlToUse;
        }
        if (children && children[index + 1])
            elList.MoveChildBefore(elTile, children[index + 1]);
        _AddTransitionEndEventHandler(elTile);
        _InitTile(elTile, tileXmlToUse);
        return elTile;
    }
    function _InitTile(elTile, tileXmlToUse) {
        if (tileXmlToUse === "friendtile") {
            FriendTile.Init(elTile);
        }
        else if (tileXmlToUse === "friendlobby") {
            elTile.SetAttributeString('showinpopup', 'false');
            friendLobby.Init(elTile);
        }
        else {
            FriendAdvertiseTile.Init(elTile);
        }
        elTile.RemoveClass('hidden');
    }
    function _AddTransitionEndEventHandler(elTile) {
        $.RegisterEventHandler('PropertyTransitionEnd', elTile, (panel, propertyName) => {
            if (elTile === panel && propertyName === 'opacity') {
                if (elTile.visible === true && elTile.BIsTransparent()) {
                    elTile.DeleteAsync(.0);
                    return true;
                }
            }
            return false;
        });
    }
    function _ShowRecentsLoadingBar() {
        let elBarOuter = $('#JsFriendsListRecentsLoadingBar');
        let elBarInner = $('#JsFriendsListRecentsLoadingBarInner');
        if (TeammatesAPI.GetSecondsAgoFinished() < 0) {
            if (elBarOuter.BHasClass('hidden'))
                elBarOuter.RemoveClass('hidden');
            elBarInner.AddClass('loadingbar-indeterminate');
            return true;
        }
        else {
            elBarInner.RemoveClass('loadingbar-indeterminate');
            elBarOuter.AddClass('hidden');
            return false;
        }
    }
    function _UpdateLobbiesLoadingBar() {
        let progress = PartyBrowserAPI.GetProgress();
        let elBarOuter = $('#JsFriendsListLobbyLoadingBar');
        let elBarInner = $('#JsFriendsListLobbyLoadingBarInner');
        if (progress > 1 && progress < 100) {
            if (elBarOuter.BHasClass('hidden'))
                elBarOuter.RemoveClass('hidden');
            elBarInner.style.width = progress + '%';
            return true;
        }
        else {
            elBarOuter.AddClass('hidden');
            return false;
        }
    }
    function UpdateHeightOpenSection() {
        _UpdateSection(m_activeSection, false);
    }
    FriendsList.UpdateHeightOpenSection = UpdateHeightOpenSection;
    function SetLobbiesTabListFilters(sFilterString) {
        _m_sLobbiesTabListFiltersString = sFilterString;
        AdvertisingToggle.OnFilterPressed(sFilterString);
        let adSetting = AdvertisingToggle.GetAdvertisingSetting();
        _ActiveFilterOnTab(adSetting);
        RefreshLobbyListings();
    }
    FriendsList.SetLobbiesTabListFilters = SetLobbiesTabListFilters;
    function _ActiveFilterOnTab(adSetting) {
        let aBtns = $.GetContextPanel().FindChildInLayoutFile('JsFriendsListSettingsBtns').Children();
        for (let btn of aBtns) {
            btn.SetHasClass('toggle-active', ((btn.GetAttributeString('data-type', '') === adSetting) && adSetting !== ''));
        }
    }
    function RefreshLobbyListings() {
        m_Sections.FindChildInLayoutFile('id-friendslist-section-broadcast').FindChildInLayoutFile('id-friendslist-section-list-contents').ScrollToTop();
        GameInterfaceAPI.SetSettingString('ui_nearbylobbies_filter', _m_sLobbiesTabListFiltersString);
        PartyBrowserAPI.SetSearchFilter(_m_sLobbiesTabListFiltersString, "");
        PartyBrowserAPI.Refresh();
    }
    FriendsList.RefreshLobbyListings = RefreshLobbyListings;
    function _OnGcHello() {
        _UpdateAllSections();
        UpdateHeightOpenSection();
    }
    function _FriendsListNameChanged(xuid) {
        let elSection = m_Sections.FindChildInLayoutFile(m_activeSection);
        if (!elSection)
            return;
        let elList = elSection.FindChildInLayoutFile('id-friendslist-section-list-contents');
        if (!elList)
            return;
        let elTile = elList.FindChildTraverse(xuid);
        if (!elTile)
            return;
        _InitTile(elTile, elTile.Data().tileXmlToUse);
    }
    function OnAddFriend() {
        UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_add_friend.xml');
    }
    FriendsList.OnAddFriend = OnAddFriend;
    function _GetFriendsCount() {
        return FriendsListAPI.GetCount();
    }
    function _GetRequestsCount() {
        return FriendsListAPI.GetFriendRequestsCount();
    }
    function _GetRecentsCount() {
        let count = TeammatesAPI.GetCount();
        if (count)
            return count;
    }
    function _GetLobbiesCount() {
        let count = PartyBrowserAPI.GetResultsCount();
        if (count)
            return count;
    }
    function _GetRequestsAlertCount() {
        return FriendsListAPI.GetFriendRequestsNotificationNumber();
    }
    function _GetXuidByIndex(index) {
        return FriendsListAPI.GetXuidByIndex(index);
    }
    function _GetRequestsXuidByIndex(index) {
        return FriendsListAPI.GetFriendRequestsXuidByIdx(index);
    }
    function _GetRecentXuidByIndex(index) {
        return TeammatesAPI.GetXuidByIndex(index);
    }
    function _GetLobbyXuidByIndex(index) {
        return PartyBrowserAPI.GetXuidByIndex(index);
    }
    function _ShowMatchAcceptPopUp(map, location, ping) {
        UiToolkitAPI.ShowGlobalCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_accept_match.xml', 'map_and_isreconnect=' + map + ',false' + ((location && ping) ? '&ping=' + ping + '&location=' + location : ''));
    }
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', _OnGcHello);
        $.RegisterForUnhandledEvent("PanoramaComponent_FriendsList_RebuildFriendsList", () => _UpdateSection('id-friendslist-section-friends', false));
        $.RegisterForUnhandledEvent('PanoramaComponent_Teammates_Refresh', () => _UpdateSection('id-friendslist-section-recent', false));
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_Refresh', () => _UpdateSection('id-friendslist-section-broadcast', false));
        $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', _FriendsListNameChanged);
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_InviteConsumed', _UpdateIncomingInvitesContainer);
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_InviteReceived', _UpdateIncomingInvitesContainer);
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_LocalPlayerForHireAdvertisingChanged', _UpdateBroadcastIcon);
        $.RegisterForUnhandledEvent("ServerReserved", _ShowMatchAcceptPopUp);
    }
})(FriendsList || (FriendsList = {}));
