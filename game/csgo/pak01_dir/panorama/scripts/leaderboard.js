"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="common/teamcolor.ts" />
$.LogChannel('p.leaderboard', "LV_OFF");
const regionToRegionName = {
    'namc': 'NorthAmerica',
    'samc': 'SouthAmerica',
    'euro': 'Europe',
    'asia': 'Asia',
    'ausc': 'Australia',
    'afrc': 'Africa',
    'cn': 'China',
};
var Leaderboard;
(function (Leaderboard) {
    let m_bEventsRegistered = false;
    let m_myXuid = MyPersonaAPI.GetXuid();
    let m_lbType;
    let m_LeaderboardsDirtyEventHandler;
    let m_LeaderboardsStateChangeEventHandler;
    let m_LobbyPlayerUpdatedEventHandler;
    let m_NameLockEventHandler;
    let m_leaderboardName = '';
    let m_onlyAvailableSeasonLeaderboard = '';
    const IS_NEW_SEASON = false;
    const IS_AROUND_PLAYER = true;
    function RegisterEventHandlers() {
        if (!m_bEventsRegistered) {
            m_LeaderboardsDirtyEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Leaderboards_Dirty', OnLeaderboardDirty);
            m_LeaderboardsStateChangeEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Leaderboards_StateChange', OnLeaderboardStateChange);
            if (m_lbType === 'party') {
                m_LobbyPlayerUpdatedEventHandler = $.RegisterForUnhandledEvent("PanoramaComponent_PartyList_RebuildPartyList", _UpdatePartyList);
            }
            if (m_lbType === 'general') {
                m_NameLockEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_SetPlayerLeaderboardSafeName', _UpdateNameLockButton);
            }
            m_bEventsRegistered = true;
        }
    }
    Leaderboard.RegisterEventHandlers = RegisterEventHandlers;
    function UnregisterEventHandlers() {
        if (m_bEventsRegistered) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_Leaderboards_Dirty', m_LeaderboardsDirtyEventHandler);
            $.UnregisterForUnhandledEvent('PanoramaComponent_Leaderboards_StateChange', m_LeaderboardsStateChangeEventHandler);
            if (m_lbType === 'party') {
                $.UnregisterForUnhandledEvent('PanoramaComponent_PartyList_RebuildPartyList', m_LobbyPlayerUpdatedEventHandler);
            }
            if (m_lbType === 'general') {
                $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_SetPlayerLeaderboardSafeName', m_NameLockEventHandler);
            }
            m_bEventsRegistered = false;
        }
    }
    Leaderboard.UnregisterEventHandlers = UnregisterEventHandlers;
    function _Init() {
        m_lbType = $.GetContextPanel().GetAttributeString('lbtype', '');
        RegisterEventHandlers();
        _SetTitle();
        _InitNavPanels();
        _UpdateLeaderboardName();
        if (m_lbType === 'party') {
            _UpdatePartyList();
            if (LeaderboardsAPI.DoesTheLocalPlayerNeedALeaderboardSafeNameSet()) {
                _AutomaticLeaderboardNameLockPopup();
            }
        }
        else if (m_lbType === 'general') {
            UpdateLeaderboardList();
            $.Schedule(0.5, _UpdateNameLockButton);
        }
        _ShowGlobalRank();
    }
    function _SetHonorIcon(elPanel, xuid) {
        const elHonorIcon = elPanel.FindChildTraverse('jsHonorIcon');
        if (elHonorIcon) {
            elHonorIcon.Set(PartyListAPI.GetFriendXpTrailLevel(xuid), PartyListAPI.GetFriendPrimeEligible(xuid));
        }
    }
    function _SetTitle() {
        $.GetContextPanel().SetDialogVariable('leaderboard-title', $.Localize('#leaderboard_title_' + String(m_lbType)));
    }
    function _InitSeason() {
        m_onlyAvailableSeasonLeaderboard = LeaderboardsAPI.GetCurrentSeasonPremierLeaderboard();
        let elSeason = $.GetContextPanel().FindChildTraverse('jsNavSeason');
        elSeason.text = $.Localize('#' + m_onlyAvailableSeasonLeaderboard + '_name');
    }
    let _LastRegionList = '';
    function _MaybeRefreshRegionsDropdown() {
        if (m_lbType === 'party')
            return;
        let currentRegionList = '(friends)';
        const arrLBsOfInterest = LeaderboardsAPI.GetPremierLeaderboardsOfInterest();
        for (let i = 0; i < arrLBsOfInterest.length; i++) {
            currentRegionList = currentRegionList + '(' + arrLBsOfInterest[i] + ')';
        }
        if (_LastRegionList === currentRegionList) {
            return;
        }
        _LastRegionList = currentRegionList;
        _InitLocationDropdown();
    }
    function _InitLocationDropdown() {
        let elLocationDropdown = $('#jsNavLocation');
        elLocationDropdown.visible = true;
        elLocationDropdown.RemoveAllOptions();
        let regions = LeaderboardsAPI.GetAllSeasonPremierLeaderboardRegions();
        regions.sort();
        regions.unshift('World');
        regions.unshift('Friends');
        let defaultRegion = 'World';
        for (let i = 0; i < regions.length; i++) {
            const szRegion = regions[i];
            const bCurrentRegion = _FindLocalPlayerInRegion(szRegion);
            if (IS_AROUND_PLAYER && !bCurrentRegion && (szRegion != 'Friends'))
                continue;
            const elEntry = $.CreatePanel('Label', elLocationDropdown, szRegion);
            elEntry.SetHasClass('of-interest', bCurrentRegion && (szRegion != 'Friends') && !IS_NEW_SEASON && !IS_AROUND_PLAYER);
            switch (szRegion) {
                case 'World':
                    elEntry.SetAttributeString('leaderboard-class', szRegion.toLowerCase());
                    break;
                case 'Friends':
                    elEntry.SetAttributeString('friendslb', 'true');
                    elEntry.SetAttributeString('leaderboard-class', 'friends');
                    break;
                default:
                    elEntry.SetAttributeString('location-suffix', '_' + szRegion);
                    elEntry.SetAttributeString('leaderboard-class', szRegion.toLowerCase());
                    if (bCurrentRegion) {
                        defaultRegion = szRegion;
                    }
            }
            elEntry.SetAcceptsFocus(true);
            elEntry.text = $.Localize('#leaderboard_region_' + szRegion);
            elLocationDropdown.AddOption(elEntry);
        }
        {
            defaultRegion = 'friends';
        }
        elLocationDropdown.SetSelected(defaultRegion);
    }
    function _getRegionFromLeaderboardName(lbname) {
        return lbname.split('_').slice(-1)[0];
    }
    function _isLeaderboardTheFriendsLeaderboard(lbname) {
        return lbname.split('.').slice(-1)[0] === 'friends';
    }
    function _FindLocalPlayerInRegion(region) {
        let arrLBsOfInterest = LeaderboardsAPI.GetPremierLeaderboardsOfInterest();
        for (let i = 0; i < arrLBsOfInterest.length; i++) {
            switch (region) {
                case 'World':
                    if (arrLBsOfInterest[i] === m_onlyAvailableSeasonLeaderboard)
                        return true;
                    break;
                case 'Friends':
                    if (_isLeaderboardTheFriendsLeaderboard(arrLBsOfInterest[i]))
                        return true;
                    break;
                default:
                    if (_getRegionFromLeaderboardName(arrLBsOfInterest[i]) === region)
                        return true;
            }
        }
        return false;
    }
    function _UpdateLeaderboardName() {
        if (m_lbType === 'general') {
            let elLocationDropdown = $('#jsNavLocation');
            let elregion = elLocationDropdown.GetSelected();
            if (elregion) {
                if (elregion.GetAttributeString('friendslb', '') === 'true') {
                    m_leaderboardName = m_onlyAvailableSeasonLeaderboard + '.friends';
                }
                else {
                    m_leaderboardName = m_onlyAvailableSeasonLeaderboard + elregion.GetAttributeString('location-suffix', '') +
                        (IS_AROUND_PLAYER ? '.self' : '');
                }
                $.GetContextPanel().SwitchClass('region', elregion.GetAttributeString('leaderboard-class', ''));
            }
        }
        else if (m_lbType === 'party') {
            m_leaderboardName = LeaderboardsAPI.GetCurrentSeasonPremierLeaderboard() + '.party';
        }
        return m_leaderboardName;
    }
    function _UpdateNameLockButton() {
        let elNameButton = $.GetContextPanel().FindChildTraverse('lbNameButton');
        elNameButton.visible = true;
        let status = MyPersonaAPI.GetMyLeaderboardNameStatus();
        let needsName = LeaderboardsAPI.DoesTheLocalPlayerNeedALeaderboardSafeNameSet();
        let showButton = status !== '' || needsName;
        elNameButton.visible = showButton;
        elNameButton.SetHasClass('no-hover', status !== '');
        elNameButton.ClearPanelEvent('onactivate');
        let buttonText = '';
        if (status) {
            let name = MyPersonaAPI.GetMyLeaderboardName();
            elNameButton.SetDialogVariable('leaderboard-name', name);
            buttonText = $.Localize('#leaderboard_namelock_button_hasname', elNameButton);
            let tooltipText = '';
            switch (status) {
                case 'submitted':
                    elNameButton.SwitchClass('status', 'submitted');
                    tooltipText = $.Localize('#leaderboard_namelock_button_tooltip_submitted');
                    break;
                case 'approved':
                    elNameButton.SwitchClass('status', 'approved');
                    tooltipText = $.Localize('#leaderboard_namelock_button_tooltip_approved');
                    break;
            }
            function onMouseOver(id, tooltipText) {
                UiToolkitAPI.ShowTextTooltip(id, tooltipText);
            }
            elNameButton.SetPanelEvent('onmouseover', onMouseOver.bind(elNameButton, elNameButton.id, tooltipText));
            elNameButton.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
        }
        else if (needsName) {
            buttonText = $.Localize('#leaderboard_namelock_button_needsname');
            elNameButton.SetPanelEvent('onactivate', _NameLockPopup);
        }
        elNameButton.SetDialogVariable('leaderboard_namelock_button', buttonText);
    }
    function _InitNavPanels() {
        $('#jsNavLocation').visible = false;
        $('#jsGoToTop').visible = (m_lbType === 'general') && !IS_AROUND_PLAYER;
        $('#jsGoToMe').visible = (m_lbType === 'general') && !IS_AROUND_PLAYER;
        if (m_lbType === 'party')
            return;
        _InitSeason();
        _MaybeRefreshRegionsDropdown();
    }
    function _ShowGlobalRank() {
        let showRank = $.GetContextPanel().GetAttributeString('showglobaloverride', 'true');
        $.GetContextPanel().SetHasClass('hide-global-rank', showRank === 'false');
    }
    function _UpdateGoToMeButton() {
        let lb = m_leaderboardName;
        let arrLBsOfInterest = LeaderboardsAPI.GetPremierLeaderboardsOfInterest();
        let myIndex = LeaderboardsAPI.GetIndexByXuid(lb, m_myXuid);
        let bPresent = arrLBsOfInterest.includes(lb) && myIndex !== -1;
        $.GetContextPanel().FindChildInLayoutFile('jsGoToMe').enabled = bPresent && !IS_NEW_SEASON && !IS_AROUND_PLAYER;
    }
    function _ShowNoData() {
        $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-list').visible = false;
        $.GetContextPanel().SwitchClass('leaderboard-status', 'lb-status-nodata');
    }
    function _ShowNewSeason() {
        $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-list').visible = false;
        $.GetContextPanel().SwitchClass('leaderboard-status', 'lb-status-newseason');
    }
    function _ShowNewSeasonFriends() {
        $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-list').visible = false;
        $.GetContextPanel().SwitchClass('leaderboard-status', 'lb-status-newseason-friends');
    }
    function _ShowLoading() {
        $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-list').visible = false;
        $.GetContextPanel().SwitchClass('leaderboard-status', 'lb-status-loading');
    }
    function _ShowLeaderboards() {
        $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-list').visible = true;
        $.GetContextPanel().SwitchClass('leaderboard-status', 'lb-status-ready');
        if (m_lbType === 'general' && IS_AROUND_PLAYER) {
            GoToSelf();
        }
    }
    function UpdateLeaderboardList() {
        _UpdateGoToMeButton();
        let count = LeaderboardsAPI.GetCount(m_leaderboardName);
        let status = LeaderboardsAPI.GetState(m_leaderboardName);
        let seasonName = $.Localize('#' + m_onlyAvailableSeasonLeaderboard + '_name');
        $.GetContextPanel().SetDialogVariable('season_name', seasonName);
        if ("ready" == status && count !== 0) {
            _FillOutEntries();
        }
        if (1 <= LeaderboardsAPI.HowManyMinutesAgoCached(m_leaderboardName)) {
            LeaderboardsAPI.Refresh(m_leaderboardName);
        }
        if (m_leaderboardName.includes('friends')) {
            if (count == 0) {
                _ShowNewSeasonFriends();
            }
            else {
                _ShowLeaderboards();
            }
            return;
        }
        if (IS_NEW_SEASON) {
            _ShowNewSeason();
        }
        else {
            if (("none" == status) || ("ready" == status && count == 0)) {
                if (IS_AROUND_PLAYER)
                    _ShowNewSeasonFriends();
                else
                    _ShowNoData();
            }
            else if ("loading" == status) {
                _ShowLoading();
            }
            else if ("ready" == status) {
                _ShowLeaderboards();
            }
        }
    }
    Leaderboard.UpdateLeaderboardList = UpdateLeaderboardList;
    function _AddPlayer(elEntry, oPlayer, index) {
        elEntry.SetDialogVariable('player-rank', '');
        elEntry.SetDialogVariable('player-name', '');
        elEntry.SetDialogVariable('player-wins', '');
        elEntry.SetDialogVariable('player-winrate', '');
        elEntry.SetDialogVariable('player-percentile', '');
        elEntry.SetHasClass('no-hover', oPlayer === null);
        elEntry.SetHasClass('background', index % 2 === 0);
        let elAvatar = elEntry.FindChildInLayoutFile('leaderboard-entry-avatar');
        elAvatar.visible = false;
        if (oPlayer) {
            function _AddOpenPlayerCardAction(elPanel, xuid) {
                function openCard() {
                    if (xuid && (xuid !== 0)) {
                        $.DispatchEvent('SidebarContextMenuActive', true);
                        let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => $.DispatchEvent('SidebarContextMenuActive', false));
                        contextMenuPanel.AddClass("ContextMenu_NoArrow");
                    }
                }
                elPanel.SetPanelEvent("onactivate", openCard);
                elPanel.SetPanelEvent("oncontextmenu", openCard);
            }
            elEntry.enabled = true;
            if (m_lbType === 'party' && oPlayer.XUID) {
                elAvatar.PopulateFromSteamID(oPlayer.XUID);
                elAvatar.visible = true;
                _SetHonorIcon(elEntry, oPlayer.XUID);
            }
            else {
                elAvatar.visible = false;
            }
            let elRatingEmblem = elEntry.FindChildTraverse('jsRatingEmblem');
            if (m_lbType === 'party') {
                const teamColorIdx = PartyListAPI.GetPartyMemberSetting(oPlayer.XUID, 'game/teamcolor');
                const teamColorRgb = TeamColor.GetTeamColor(Number(teamColorIdx));
                elAvatar.style.border = '2px solid rgb(' + teamColorRgb + ')';
            }
            _AddOpenPlayerCardAction(elEntry, oPlayer.XUID);
            let options;
            if (m_lbType === 'party') {
                options =
                    {
                        root_panel: elRatingEmblem,
                        rating_type: 'Premier',
                        do_fx: true,
                        leaderboard_details: oPlayer,
                        full_details: false,
                        local_player: oPlayer.XUID === MyPersonaAPI.GetXuid()
                    };
            }
            else {
                options =
                    {
                        root_panel: elRatingEmblem,
                        rating_type: 'Premier',
                        do_fx: true,
                        leaderboard_details: oPlayer,
                        full_details: false,
                        local_player: oPlayer.XUID === MyPersonaAPI.GetXuid()
                    };
            }
            RatingEmblem.SetXuid(options);
            elEntry.SetDialogVariable('partyxuid', oPlayer.XUID ?? '');
            elEntry.SetDialogVariable('xuid', oPlayer.XUID ?? '');
            elEntry.SetDialogVariable('player-name', oPlayer.displayName ?? '');
            let elPlayerNameLabel = elEntry.FindChildTraverse('jsPlayerName');
            if (m_lbType === 'party' && oPlayer.XUID) {
                elPlayerNameLabel.SetLocString('#friends_name_in_party_leaderboard');
            }
            else if (oPlayer.displayName) {
                elPlayerNameLabel.SetLocString('#friends_name_generic');
            }
            else {
                elPlayerNameLabel.SetLocString('#friends_name_from_steam');
            }
            elEntry.SetDialogVariable('player-wins', oPlayer.hasOwnProperty('matchesWon') ? String(oPlayer.matchesWon) : '-');
            let bHasRank = oPlayer.hasOwnProperty('rank') && oPlayer.rank > 0;
            elEntry.SetDialogVariableInt('player-rank', bHasRank ? oPlayer.rank : 0);
            elEntry.FindChildTraverse('jsPlayerRank').text = bHasRank ? $.Localize('{d:player-rank}', elEntry) : '-';
            let canShowWinRate = oPlayer.hasOwnProperty('matchesWon') && oPlayer.hasOwnProperty('matchesTied') && oPlayer.hasOwnProperty('matchesLost');
            if (canShowWinRate) {
                let matchesPlayed = (oPlayer.matchesWon ? oPlayer.matchesWon : 0) +
                    (oPlayer.matchesTied ? oPlayer.matchesTied : 0) +
                    (oPlayer.matchesLost ? oPlayer.matchesLost : 0);
                let winRate = matchesPlayed === 0 ? 0 : oPlayer.matchesWon * 100.00 / matchesPlayed;
                elEntry.SetDialogVariable('player-winrate', winRate.toFixed(2) + '%');
            }
            else {
                elEntry.SetDialogVariable('player-winrate', '-');
            }
            elEntry.SetDialogVariable('player-percentile', (oPlayer.hasOwnProperty('pct') && oPlayer.pct && oPlayer.pct > 0) ? oPlayer.pct.toFixed(0) + '%' : '-');
            elEntry.SetDialogVariable('player-region', (oPlayer.hasOwnProperty('region')) ? $.Localize('#leaderboard_region_abbr_' + regionToRegionName[oPlayer.region]) : '-');
        }
        return elEntry;
    }
    function _UpdatePartyList() {
        if (m_lbType !== 'party')
            return;
        let elStatus = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-loading');
        let elNoData = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-nodata');
        let elLeaderboardList = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-list');
        elLeaderboardList.SetHasClass('hidden', false);
        elStatus.SetHasClass('hidden', true);
        elNoData.SetHasClass('hidden', true);
        function OnMouseOver(xuid) {
            $.DispatchEvent('LeaderboardHoverPlayer', xuid);
        }
        function OnMouseOut() {
            $.DispatchEvent('LeaderboardHoverPlayer', '');
        }
        let elList = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-entries');
        if (LobbyAPI.IsSessionActive()) {
            let members = LobbyAPI.GetSessionSettings().members;
            function GetPartyLBRow(idx) {
                let oPlayer = null;
                let machine = 'machine' + idx;
                let bValidPartyPlayer = members.hasOwnProperty(machine) && members[machine].hasOwnProperty('player0') &&
                    members[machine].player0.hasOwnProperty('xuid');
                if (!bValidPartyPlayer)
                    return null;
                let xuid = members[machine].player0.xuid;
                oPlayer = LeaderboardsAPI.GetEntryDetailsObjectByXuid(m_leaderboardName, xuid);
                if (!oPlayer.XUID) {
                    oPlayer.XUID = xuid;
                }
                if (PartyListAPI.GetFriendCompetitiveRankType(xuid) === "Premier") {
                    let partyScore = PartyListAPI.GetFriendCompetitiveRank(xuid);
                    let partyWins = PartyListAPI.GetFriendCompetitiveWins(xuid);
                    if (partyScore || partyWins) {
                        oPlayer.score = PartyListAPI.GetFriendCompetitiveRank(xuid);
                        oPlayer.matchesWon = PartyListAPI.GetFriendCompetitiveWins(xuid);
                        oPlayer.rankWindowStats = PartyListAPI.GetFriendCompetitivePremierWindowStatsObject(xuid);
                    }
                }
                return oPlayer;
            }
            elList.SetLoadListItemFunction((parent, nPanelIdx, reusePanel) => {
                let oPlayer = GetPartyLBRow(nPanelIdx);
                if (!reusePanel || !reusePanel.IsValid()) {
                    reusePanel = $.CreatePanel("Button", elList, oPlayer ? oPlayer.XUID : '');
                    reusePanel.BLoadLayoutSnippet("leaderboard-entry");
                }
                _AddPlayer(reusePanel, oPlayer, nPanelIdx);
                reusePanel.SetPanelEvent('onmouseover', oPlayer ? OnMouseOver.bind(reusePanel, oPlayer.XUID) : OnMouseOut);
                reusePanel.SetPanelEvent('onmouseout', OnMouseOut);
                return reusePanel;
            });
            elList.UpdateListItems(PartyListAPI.GetCount());
        }
    }
    function OnLeaderboardDirty(type) {
        if (m_leaderboardName && m_leaderboardName === type) {
            _MaybeRefreshRegionsDropdown();
            LeaderboardsAPI.Refresh(m_leaderboardName);
        }
    }
    function ReadyForDisplay() {
        RegisterEventHandlers();
        _MaybeRefreshRegionsDropdown();
        if (m_leaderboardName) {
            LeaderboardsAPI.Refresh(m_leaderboardName);
        }
    }
    Leaderboard.ReadyForDisplay = ReadyForDisplay;
    function UnReadyForDisplay() {
        UnregisterEventHandlers();
    }
    Leaderboard.UnReadyForDisplay = UnReadyForDisplay;
    function _NameLockPopup() {
        UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_leaderboard_namelock.xml');
    }
    function _AutomaticLeaderboardNameLockPopup() {
        let data = $.GetContextPanel().Data();
        let bAlreadyAsked = data && data.bPromptedForLeaderboardSafeName;
        if (bAlreadyAsked)
            return;
        _NameLockPopup();
        data.bPromptedForLeaderboardSafeName = true;
    }
    function _FillOutEntries() {
        let nPlayers = LeaderboardsAPI.GetCount(m_leaderboardName);
        const elList = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-entries');
        elList.SetLoadListItemFunction((parent, nPanelIdx, reusePanel) => {
            let oPlayer = LeaderboardsAPI.GetEntryDetailsObjectByIndex(m_leaderboardName, nPanelIdx);
            if (!reusePanel || !reusePanel.IsValid()) {
                reusePanel = $.CreatePanel("Button", elList, oPlayer ? oPlayer.XUID : '');
                reusePanel.BLoadLayoutSnippet("leaderboard-entry");
            }
            _AddPlayer(reusePanel, oPlayer, nPanelIdx);
            reusePanel.SetHasClass('local-player', (oPlayer ? oPlayer.XUID : '') === m_myXuid);
            return reusePanel;
        });
        elList.UpdateListItems(nPlayers);
        if (m_lbType === 'general' && IS_AROUND_PLAYER)
            GoToSelf();
        else
            GoToTop();
    }
    function OnLeaderboardStateChange(type) {
        if (m_leaderboardName === type) {
            if (m_lbType === 'party') {
                _UpdatePartyList();
            }
            else if (m_lbType === 'general') {
                UpdateLeaderboardList();
            }
            return;
        }
    }
    Leaderboard.OnLeaderboardStateChange = OnLeaderboardStateChange;
    function OnLeaderboardChange() {
        _UpdateLeaderboardName();
        UpdateLeaderboardList();
    }
    Leaderboard.OnLeaderboardChange = OnLeaderboardChange;
    function GoToSelf() {
        let myIndex = LeaderboardsAPI.GetIndexByXuid(m_leaderboardName, m_myXuid);
        const elList = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-entries');
        $.DispatchEvent('ScrollToDelayLoadListItem', elList, myIndex, 'center', true);
    }
    Leaderboard.GoToSelf = GoToSelf;
    function GoToTop() {
        const elList = $.GetContextPanel().FindChildInLayoutFile('id-leaderboard-entries');
        $.DispatchEvent('ScrollToDelayLoadListItem', elList, 0, 'topleft', true);
    }
    Leaderboard.GoToTop = GoToTop;
    {
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), Leaderboard.ReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), Leaderboard.UnReadyForDisplay);
        _Init();
    }
})(Leaderboard || (Leaderboard = {}));
