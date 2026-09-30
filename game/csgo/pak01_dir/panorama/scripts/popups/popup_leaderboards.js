"use strict";
/// <reference path="../csgo.d.ts" />
var PopupLeaderboards;
(function (PopupLeaderboards) {
    var m_type = '';
    var m_myXuid = MyPersonaAPI.GetXuid();
    PopupLeaderboards.Init = function () {
        var type = $.GetContextPanel().GetAttributeString('type', '');
        if (type === '') {
            return;
        }
        var aTypes = type.split(',');
        _SetTitle(aTypes[0]);
        _SetBackground();
        _SetPointsTitle();
        _MakeTabs(aTypes);
        _ShowGlobalRank();
        var extraStyle = $.GetContextPanel().GetAttributeString('popup-style', '');
        if (extraStyle) {
            $.GetContextPanel().AddClass(extraStyle);
        }
        $('#id-popup-leaderboard-refresh-button')?.SetPanelEvent('onactivate', function (lbType) { LeaderboardsAPI.Refresh(lbType); }.bind(undefined, type));
    };
    function _SetTitle(type) {
        var titleOverride = $.GetContextPanel().GetAttributeString('titleoverride', '');
        var title = titleOverride;
        if (!title) {
            title = '#CSGO_' + (type.split('.')[0]);
        }
        $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-title').text = $.Localize(title);
    }
    ;
    function _SetBackground() {
        const eventId = $.GetContextPanel().GetAttributeString('eventid', '');
        if (!eventId) {
            return;
        }
        let elBackground = $.GetContextPanel().FindChild('id-popup-leaderboard-bg');
        elBackground.style.backgroundImage = 'url( "file://{images}/tournaments/backgrounds/pickem_bg_' + $.GetContextPanel().GetAttributeString('eventid', '') + '.png");';
        elBackground.style.backgroundSize = 'cover';
        elBackground.style.backgroundPosition = ' 50% 50%;';
        elBackground.visible = true;
        $.GetContextPanel().SetHasClass('major-' + $.GetContextPanel().GetAttributeString('eventid', ''), true);
    }
    function _SetPointsTitle() {
        var strPointsTitle = $.GetContextPanel().GetAttributeString('points-title', '');
        if (strPointsTitle !== '') {
            $.GetContextPanel().FindChildInLayoutFile('id-header-score').text = $.Localize(strPointsTitle);
        }
    }
    ;
    function _MakeTabs(aTypes) {
        if (aTypes.length <= 1) {
            m_type = aTypes[0];
            _UpdateLeaderboard(aTypes[0]);
            return;
        }
        var elNavBar = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-navbar');
        elNavBar.RemoveClass('hidden');
        var elTabs = elNavBar.FindChild('id-popup-leaderboard-tabs');
        for (var i = 0; i < aTypes.length; i++) {
            var elTab = $.CreatePanel("RadioButton", elTabs, aTypes[i]);
            elTab.BLoadLayoutSnippet("leaderboard-tab");
            elTab.SetPanelEvent('onactivate', _UpdateLeaderboard.bind(undefined, aTypes[i]));
            elTab.FindChildInLayoutFile('leaderboard-tab-label').text = $.Localize('#CSGO_' + aTypes[i] + '_tab');
        }
        $.DispatchEvent("Activated", elTabs.Children()[0], "mouse");
    }
    ;
    function _ShowGlobalRank() {
        var showRank = $.GetContextPanel().GetAttributeString('showglobaloverride', 'true');
        $.GetContextPanel().SetHasClass('hide-global-rank', showRank === 'false');
    }
    ;
    function _UpdateLeaderboard(type) {
        m_type = type;
        var count = 0;
        var status = LeaderboardsAPI.GetState(type);
        var elStatus = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-loading');
        var elData = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-nodata');
        var elLeaderboardList = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-list');
        if ("none" == status) {
            elStatus.SetHasClass('hidden', false);
            elData.SetHasClass('hidden', true);
            elLeaderboardList.SetHasClass('hidden', true);
            LeaderboardsAPI.Refresh(type);
        }
        if ("loading" == status) {
            elStatus.SetHasClass('hidden', false);
            elData.SetHasClass('hidden', true);
            elLeaderboardList.SetHasClass('hidden', true);
        }
        if ("ready" == status) {
            count = LeaderboardsAPI.GetCount(type);
            let limitRows = $.GetContextPanel().GetAttributeInt('limitrows', 0);
            if (limitRows > 0 && limitRows < count) {
                count = limitRows;
            }
            if (count === 0) {
                elData.SetHasClass('hidden', false);
                elStatus.SetHasClass('hidden', true);
                elLeaderboardList.SetHasClass('hidden', true);
            }
            else {
                elLeaderboardList.SetHasClass('hidden', false);
                elStatus.SetHasClass('hidden', true);
                elData.SetHasClass('hidden', true);
                _FillOutEntries(type, count);
            }
            if (1 <= LeaderboardsAPI.HowManyMinutesAgoCached(type)) {
                LeaderboardsAPI.Refresh(type);
            }
        }
        $.GetContextPanel().SetHasClass('leaderboard-has-nodata', count === 0);
        if ($.GetContextPanel().BHasClass('leaderboard_embedded')) {
            let elParent = $.GetContextPanel().GetParent();
            if (elParent) {
                elParent.SetHasClass('leaderboard-has-nodata', count === 0);
            }
        }
    }
    ;
    function _FillOutEntries(type, count) {
        var elParent = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-entries');
        elParent.RemoveAndDeleteChildren();
        function _AddOpenPlayerCardAction(elAvatar, xuid) {
            var openCard = function (xuid) {
                $.DispatchEvent('SidebarContextMenuActive', true);
                if (xuid !== '0' && xuid) {
                    var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, function () {
                        $.DispatchEvent('SidebarContextMenuActive', false);
                    });
                    contextMenuPanel.AddClass("ContextMenu_NoArrow");
                }
            };
            elAvatar.SetPanelEvent("onactivate", openCard.bind(undefined, xuid));
            elAvatar.SetPanelEvent("oncontextmenu", openCard.bind(undefined, xuid));
        }
        for (var i = 0; i < count; i++) {
            var lbData = LeaderboardsAPI.GetEntryDetailsObjectByIndex(type, i);
            var xuid = lbData.XUID;
            var score = lbData.score;
            var elEntry = $.CreatePanel("Panel", elParent, xuid);
            elEntry.BLoadLayoutSnippet("leaderboard-entry");
            elEntry.FindChildInLayoutFile('popup-leaderboard-entry-avatar').PopulateFromSteamID(xuid);
            _AddOpenPlayerCardAction(elEntry, xuid);
            elEntry.SetDialogVariable('player-rank', (i + 1).toString());
            elEntry.SetDialogVariable('player-score', score?.toString());
            elEntry.SetDialogVariable('player-name', FriendsListAPI.GetFriendName(xuid));
            var children = elEntry.FindChildrenWithClassTraverse('popup-leaderboard__list__column');
            if (i % 2 === 0) {
                children.forEach(element => {
                    element.AddClass('background');
                });
            }
        }
        _HighightMySelf();
    }
    ;
    function _HighightMySelf() {
        var elParent = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-entries');
        var elEntry = elParent.FindChildInLayoutFile(m_myXuid);
        if (elEntry) {
            elEntry.AddClass('local-player');
            elEntry.ScrollParentToMakePanelFit(1, false);
        }
    }
    ;
    function RefreshLeaderBoard(type) {
        if (m_type === type) {
            _UpdateLeaderboard(type);
            return;
        }
    }
    PopupLeaderboards.RefreshLeaderBoard = RefreshLeaderBoard;
    ;
    function UpdateName(xuid) {
        var elParent = $.GetContextPanel().FindChildInLayoutFile('id-popup-leaderboard-entries');
        var elEntry = elParent.FindChildInLayoutFile(xuid);
        if (elEntry) {
            elEntry.SetDialogVariable('player-name', FriendsListAPI.GetFriendName(xuid));
        }
    }
    PopupLeaderboards.UpdateName = UpdateName;
    ;
    function Close() {
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupLeaderboards.Close = Close;
    ;
})(PopupLeaderboards || (PopupLeaderboards = {}));
(function () {
    $.RegisterForUnhandledEvent('PanoramaComponent_Leaderboards_StateChange', PopupLeaderboards.RefreshLeaderBoard);
    $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', PopupLeaderboards.UpdateName);
    PopupLeaderboards.Init();
})();
