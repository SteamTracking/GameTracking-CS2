"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="mainmenu_watch.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="generated/items_event_current_generated_store.ts" />
var matchInfo;
(function (matchInfo) {
    let PLAYERSTATS = ['kills', 'assists', 'deaths', 'mvps', 'score'];
    let TEAMS = ['CT', 'TERRORIST'];
    let TEAMSIZE = 5;
    function _ShowMatchSpinner(value, tab) {
        if (tab) {
            let elSpinner = tab.FindChildInLayoutFile("id-match-spinner");
            if (elSpinner) {
                if (value) {
                    elSpinner.RemoveClass('hide');
                }
                else {
                    elSpinner.AddClass('hide');
                }
            }
        }
    }
    function _SetMatchMessage(value, show, tab) {
        if (tab) {
            let elMessage = tab.FindChildInLayoutFile("id-match-message");
            if (elMessage) {
                elMessage.text = value;
            }
            let elMessageContainer = tab.FindChildInLayoutFile("id-match-message-container");
            if (elMessageContainer) {
                if (show) {
                    elMessageContainer.RemoveClass('hide');
                }
                else {
                    elMessageContainer.AddClass('hide');
                }
            }
        }
    }
    function _IsMatchMetadataFullyLoaded(elParentPanel) {
        return (((elParentPanel.Data().matchListDescriptor == 'live') && (elParentPanel.Data().matchId != 'gotv')) || (MatchInfoAPI.GetMatchMetadataFullState(elParentPanel.Data().matchId)));
    }
    function _DownloadMatch(elParentPanel) {
        MatchInfoAPI.Delete(elParentPanel.Data().matchId);
        MatchInfoAPI.Download(elParentPanel.Data().matchId);
        _UpdateMatchMenu(elParentPanel);
    }
    function _DownloadFailedNotify(elParentPanel) {
        let canDownload = !(elParentPanel.Data().matchListDescriptor === 'downloaded')
            && ((MatchInfoAPI.GetMatchState(elParentPanel.Data().matchInfo) === 'recent') || (elParentPanel.Data().isTournament));
        if (canDownload) {
            UiToolkitAPI.ShowGenericPopupYesNo($.Localize("#WatchMenu_Info_Download_Failed"), $.Localize("#WatchMenu_Info_Download_Failed_Retry"), '', function () { _DownloadMatch(elParentPanel); }, function () { });
        }
        else {
            UiToolkitAPI.ShowGenericPopupOk($.Localize("#WatchMenu_Info_Download_Failed"), $.Localize("#WatchMenu_Info_Download_Failed_Info"), '', function () { });
        }
    }
    function _DeleteDemo(elParentPanel) {
        MatchInfoAPI.Delete(elParentPanel.Data().matchId);
        if (elParentPanel.Data().matchListDescriptor === 'downloaded') {
            mainmenu_watch.UpdateActiveTab();
        }
        else {
            _UpdateMatchMenu(elParentPanel);
        }
    }
    function _Watch(elParentPanel) {
        MatchInfoAPI.Watch(elParentPanel.Data().matchId, 0);
    }
    function _WatchHighlights(elParentPanel) {
        MatchInfoAPI.WatchHighlights(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid);
    }
    function _WatchLowlights(elParentPanel) {
        MatchInfoAPI.WatchLowlights(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid);
    }
    function _ShareMatch(elParentPanel) {
        SteamOverlayAPI.CopyTextToClipboard(MatchInfoAPI.GetMatchShareToken(elParentPanel.Data().matchId, "copyurl"));
        let elShareLinkButton = elParentPanel.FindChildInLayoutFile('id-mi-copy');
        UiToolkitAPI.HideTextTooltip();
        UiToolkitAPI.ShowTextTooltipOnPanel(elShareLinkButton, $.Localize("#WatchMenu_Share_Link_Copied"));
    }
    let _CanRedeem = function (elParentPanel) {
        if (!elParentPanel.Data().tournamentIndex) {
            return false;
        }
        let id = InventoryAPI.GetActiveTournamentCoinItemId(elParentPanel.Data().tournamentIndex);
        if (!id || id === '0') {
            return false;
        }
        else {
            let coinLevel = Number(InventoryAPI.GetItemAttributeValue(id, "upgrade level"));
            let coinRedeemsPurchased = Number(InventoryAPI.GetItemAttributeValue(id, "operation drops awarded 1"));
            if (coinRedeemsPurchased && coinLevel != undefined) {
                coinLevel += coinRedeemsPurchased;
            }
            let redeemed = Number(InventoryAPI.GetItemAttributeValue(id, "operation drops awarded 0"));
            let redeemsAvailable = coinLevel - redeemed;
            if ((elParentPanel.Data().tournamentIndex == g_ActiveTournamentInfo.eventid) &&
                g_ActiveTournamentInfo.itemid_charge &&
                ItemInfo.GetStoreSalePrice(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_charge, 0), 1, '')) {
                ++redeemsAvailable;
            }
            let tournamentName = MatchInfoAPI.GetMatchTournamentName(elParentPanel.Data().matchId);
            return redeemsAvailable > 0 &&
                ((tournamentName != undefined) && (tournamentName != ""));
        }
    };
    function _RedeemSouvenir(tournamentIndex, matchId) {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_redeem_souvenir.xml', 'matchid=' + matchId +
            '&' + 'tournamentindex=' + tournamentIndex);
    }
    function _RefreshRoundWatchEnabled(elParentPanel) {
        let isLive = Boolean(MatchInfoAPI.IsLive(elParentPanel.Data().matchId));
        if (isLive) {
            return;
        }
        let elStatsContainer = elParentPanel.FindChildInLayoutFile('id-mi-round-stats__container');
        let totalBars = elStatsContainer.Children().length;
        if (totalBars == 0) {
            return;
        }
        let canWatch = false;
        for (let i = 1; i <= totalBars; i++) {
            let elRoundStats = elStatsContainer.GetChild(i - 1);
            if (!canWatch) {
                elRoundStats.AddClass('no-hover');
            }
            else {
                elRoundStats.RemoveClass('no-hover');
                elRoundStats.style.tooltipPosition = "bottom";
                elRoundStats.style.tooltipBodyPosition = "50% 0%";
                function _OnRoundMouseOver(elButton) {
                    UiToolkitAPI.ShowTextTooltipOnPanel(elButton, $.Localize("#CSGO_Watch_Round"));
                }
                function _OnRoundActivate(nMatch, nRound) {
                    MatchInfoAPI.Watch(nMatch.toString(), nRound);
                }
                elRoundStats.SetPanelEvent('onmouseover', _OnRoundMouseOver.bind(undefined, elRoundStats));
                elRoundStats.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
                elRoundStats.SetPanelEvent('onactivate', _OnRoundActivate.bind(undefined, elParentPanel.Data().matchId, i));
            }
        }
    }
    function _UpdateMatchMenu(elParentPanel) {
        let matchState = MatchInfoAPI.GetMatchState(elParentPanel.Data().matchId);
        let elDownloadButton = elParentPanel.FindChildInLayoutFile('id-mi-download');
        let elShareLinkButton = elParentPanel.FindChildInLayoutFile('id-mi-copy');
        let elWatchButton = elParentPanel.FindChildInLayoutFile('id-mi-watch');
        let elSouvenirButton = elParentPanel.FindChildInLayoutFile('id-mi-souvenir');
        let elWatchHighlightsButton = elParentPanel.FindChildInLayoutFile('id-mi-watch-highlights');
        let elWatchLowlightsButton = elParentPanel.FindChildInLayoutFile('id-mi-watch-lowlights');
        let elDeleteButton = elParentPanel.FindChildInLayoutFile('id-mi-delete');
        let elDownloadingButton = elParentPanel.FindChildInLayoutFile('id-mi-downloading');
        let elDownloadFailedButton = elParentPanel.FindChildInLayoutFile('id-mi-error-delete');
        function _ShowButton(elButton, value) {
            if (elButton) {
                if (value) {
                    elButton.RemoveClass('hide');
                }
                else {
                    elButton.AddClass('hide');
                }
            }
        }
        function _EnableButton(elButton, value) {
            if (elButton) {
                if (value) {
                    elButton.enabled = true;
                }
                else {
                    elButton.enabled = false;
                }
            }
        }
        let canWatch = MatchInfoAPI.CanWatch(elParentPanel.Data().matchId);
        _EnableButton(elWatchButton, canWatch);
        if (elParentPanel.Data().matchListDescriptor != 'live') {
            _ShowButton(elWatchButton, canWatch);
            _ShowButton(elWatchHighlightsButton, canWatch);
            _ShowButton(elWatchLowlightsButton, canWatch);
            _ShowButton(elDownloadButton, !canWatch);
            _ShowButton(elSouvenirButton, (matchState !== "live") && _CanRedeem(elParentPanel));
            let szSouvenirButtonHint = '#popup_redeem_souvenir_title';
            elSouvenirButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elSouvenirButton, szSouvenirButtonHint); });
            elSouvenirButton.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
            if (elParentPanel.Data().matchListDescriptor != 'downloaded') {
                let szDownloadButtonHint = '#WatchMenu_Download_Demo';
                if (matchState === "downloaded") {
                    _EnableButton(elDownloadButton, false);
                    _ShowButton(elDownloadingButton, false);
                    _ShowButton(elDownloadFailedButton, false);
                }
                else if (matchState === "downloading") {
                    _EnableButton(elDownloadButton, false);
                    _ShowButton(elDownloadingButton, true);
                    _ShowButton(elDownloadFailedButton, false);
                    _ShowButton(elWatchHighlightsButton, false);
                    _ShowButton(elWatchLowlightsButton, false);
                    _ShowButton(elWatchButton, false);
                }
                else if (MatchInfoAPI.CanDownload(elParentPanel.Data().matchId)) {
                    _EnableButton(elDownloadButton, true);
                    _ShowButton(elDownloadingButton, false);
                    _ShowButton(elDownloadFailedButton, false);
                }
                else {
                    szDownloadButtonHint = '#WatchMenu_Download_Disabled_Hint';
                    _EnableButton(elDownloadButton, false);
                    _ShowButton(elDownloadingButton, false);
                    _ShowButton(elDownloadFailedButton, false);
                }
                _EnableButton(elShareLinkButton, (elParentPanel.Data().matchShareToken != "") && (elParentPanel.Data().matchShareToken != undefined));
                elDownloadButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elDownloadButton, szDownloadButtonHint); });
                elDownloadButton.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
            }
            else {
                _ShowButton(elDownloadButton, false);
                _ShowButton(elDownloadingButton, false);
                _ShowButton(elDownloadFailedButton, false);
            }
            let bEnabledReelLightsButton = ((elParentPanel.Data().activePlayerRow) && (MatchInfoAPI.CanWatchHighlights(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid)));
            _EnableButton(elWatchHighlightsButton, bEnabledReelLightsButton);
            _EnableButton(elWatchLowlightsButton, bEnabledReelLightsButton);
            let canDelete = MatchInfoAPI.CanDelete(elParentPanel.Data().matchId);
            _EnableButton(elDeleteButton, canDelete);
            if (!canWatch && canDelete) {
                _ShowButton(elDownloadFailedButton, true);
            }
        }
        else {
            _ShowButton(elDownloadButton, false);
            _ShowButton(elDownloadingButton, false);
            _ShowButton(elDownloadFailedButton, false);
            _ShowButton(elWatchHighlightsButton, false);
            _ShowButton(elWatchLowlightsButton, false);
            _ShowButton(elShareLinkButton, false);
            _ShowButton(elDeleteButton, false);
            _ShowButton(elSouvenirButton, false);
        }
        _RefreshRoundWatchEnabled(elParentPanel);
    }
    function Refresh(elParentPanel) {
        function _ShowLoadingError(elBoundParentPanel) {
            _ShowMatchSpinner(false, elBoundParentPanel);
            _SetMatchMessage($.Localize('#CSGO_Watch_NoMatchData'), true, elBoundParentPanel);
            if (elBoundParentPanel.Data().updateMatchInfoHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_MatchInfo_StateChange', elBoundParentPanel.Data().updateMatchInfoHandler);
            }
            elParentPanel.Data().downloadFailedHandler = undefined;
        }
        if (_IsMatchMetadataFullyLoaded(elParentPanel)) {
            _PopulateMatchInfo(elParentPanel);
        }
        else if (MatchInfoAPI.IsServerLogTournamentMatch(elParentPanel.Data().matchId)) {
            _PopulateServerLogTournamentMatchInfo(elParentPanel);
        }
        else if (!elParentPanel.Data().downloadFailedHandler) {
            MatchInfoAPI.DownloadWithShareToken(elParentPanel.Data().matchId);
            elParentPanel.Data().downloadFailedHandler = $.Schedule(3.0, _ShowLoadingError.bind(undefined, elParentPanel));
            elParentPanel.Data().updateMatchInfoHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MatchInfo_StateChange', _PopulateMatchInfo.bind(undefined, elParentPanel));
        }
    }
    matchInfo.Refresh = Refresh;
    function _PopulateMatchInfo(elParentPanel) {
        if (elParentPanel.Data().downloadFailedHandler) {
            $.CancelScheduled(elParentPanel.Data().downloadFailedHandler);
            elParentPanel.Data().downloadFailedHandler = undefined;
        }
        _FillScoreboard(elParentPanel);
        _UpdateMatchMenu(elParentPanel);
        if (elParentPanel.Data().matchListDescriptor != 'live') {
            _FillRoundStats(elParentPanel, elParentPanel.Data().activePlayerRow);
        }
        _Show(elParentPanel);
    }
    function _PopulateServerLogTournamentMatchInfo(elParentPanel) {
        _FillServerLogTournamentInfo(elParentPanel);
        _UpdateMatchMenu(elParentPanel);
        _Show(elParentPanel);
    }
    function _UpdateName(elParentPanel, elPlayerName) {
        if (elParentPanel.Data().isTournament) {
            elPlayerName.text = MatchInfoAPI.GetMatchPlayerStat(elParentPanel.Data().matchId, elPlayerName.Data().playerXuid, 'name');
        }
        else {
            elPlayerName.text = FriendsListAPI.GetFriendName(elPlayerName.Data().playerXuid);
        }
    }
    function _UpdateTitle(elParentPanel, playerXuid) {
        if (elParentPanel.Data().isTournament) {
            elParentPanel.SetDialogVariable('playerNameTitle', MatchInfoAPI.GetMatchPlayerStat(elParentPanel.Data().matchId, playerXuid, 'name'));
        }
        else {
            elParentPanel.SetDialogVariable('playerNameTitle', FriendsListAPI.GetFriendName(playerXuid));
        }
        let elWatchHighlightsButton = elParentPanel.FindChildInLayoutFile('id-mi-watch-highlights');
        let elWatchLowlightsButton = elParentPanel.FindChildInLayoutFile('id-mi-watch-lowlights');
        if (elWatchHighlightsButton) {
            elWatchHighlightsButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elWatchHighlightsButton, UiToolkitAPI.MakeStringSafe($.Localize('#WatchMenu_Watch_Highlights_Player_Selected', elParentPanel))); });
            elWatchLowlightsButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elWatchLowlightsButton, UiToolkitAPI.MakeStringSafe($.Localize('#WatchMenu_Watch_Lowlights_Player_Selected', elParentPanel))); });
        }
    }
    function _Show(elParentPanel) {
        elParentPanel.SetReadyForDisplay(true);
        elParentPanel.visible = true;
        elParentPanel.RemoveClass('mi-sb--hidden');
        elParentPanel.Data().updateMatchMenuHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MatchInfo_StateChange', _UpdateMatchMenu.bind(undefined, elParentPanel));
    }
    function _OnFadeOutEnd(elParentPanel) {
        if (elParentPanel.visible === true && elParentPanel.BIsTransparent()) {
            elParentPanel.visible = false;
            elParentPanel.SetReadyForDisplay(false);
        }
    }
    function Hide(elParentPanel) {
        for (let teamId in TEAMS) {
            let elTeam = elParentPanel.FindChildInLayoutFile('players-table-' + TEAMS[teamId]);
            for (let i = 0; i < TEAMSIZE; i++) {
                let elPlayerName = elTeam.GetChild(i).FindChildTraverse('name__label');
                if (elPlayerName.Data().nameUpdateHandler) {
                    $.UnregisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', elPlayerName.Data().nameUpdateHandler);
                    elPlayerName.Data().nameUpdateHandler = undefined;
                }
            }
        }
        if (elParentPanel.Data().downloadFailedHandler) {
            $.CancelScheduled(elParentPanel.Data().downloadFailedHandler);
            elParentPanel.Data().downloadFailedHandler = undefined;
        }
        if (elParentPanel.Data().updateMatchInfoHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_MatchInfo_StateChange', elParentPanel.Data().updateMatchInfoHandler);
            elParentPanel.Data().updateMatchInfoHandler = undefined;
        }
        let elTitle = elParentPanel.FindChildInLayoutFile('id-mi-player-stats-title');
        if (elTitle.Data().nameUpdateHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', elTitle.Data().nameUpdateHandler);
            elTitle.Data().nameUpdateHandler = undefined;
        }
        elParentPanel.AddClass('mi-sb--hidden');
    }
    matchInfo.Hide = Hide;
    function _FillRoundStats(elParentPanel, elPlayerRow) {
        let tickPatternOvertime = [
            'mi-round-tick--right-of-team-switch',
            'mi-round-tick--sub',
            'mi-round-tick--sub',
            'mi-round-tick--sub',
            'mi-round-tick--sub',
            'mi-round-tick--major'
        ];
        function flipBit(n) {
            if (n == 0)
                return 1;
            return 0;
        }
        let elTitle = elParentPanel.FindChildInLayoutFile('id-mi-player-stats-title');
        if (elTitle.Data().nameUpdateHandler == undefined) {
            elTitle.Data().nameUpdateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', _UpdateTitle.bind(undefined, elParentPanel, elPlayerRow.Data().playerXuid));
        }
        _UpdateTitle(elParentPanel, elPlayerRow.Data().playerXuid);
        let currentTeamId = elPlayerRow.Data().teamId;
        if (elParentPanel.Data().activePlayerRow) {
            elParentPanel.Data().activePlayerRow.checked = false;
            elParentPanel.Data().activePlayerRow.RemoveClass('no-hover');
        }
        elPlayerRow.checked = true;
        elPlayerRow.AddClass('no-hover');
        elParentPanel.Data().activePlayerRow = elPlayerRow;
        let isLive = Boolean(MatchInfoAPI.IsLive(elParentPanel.Data().matchId));
        if (isLive == false) {
            elParentPanel.FindChildInLayoutFile('id-mi-player-stats').RemoveClass('mi-player-stats__collapse');
        }
        let elStatsContainer = elParentPanel.FindChildInLayoutFile('id-mi-round-stats__container');
        let elTickLabels = elParentPanel.FindChildInLayoutFile('id-mi-round-stats__tick-labels');
        let team0Score = MatchInfoAPI.GetMatchRoundScoreForTeam(elParentPanel.Data().matchId, 0);
        if (team0Score === undefined)
            team0Score = 0;
        let team1Score = MatchInfoAPI.GetMatchRoundScoreForTeam(elParentPanel.Data().matchId, 1);
        if (team1Score === undefined)
            team1Score = 0;
        let playedRounds = team0Score + team1Score;
        let maxRounds = MatchInfoAPI.GetMatchMaxRounds(elParentPanel.Data().matchId);
        let totalRounds = Math.max(playedRounds, maxRounds);
        let nOvertime = Math.ceil((totalRounds - maxRounds) / 6);
        if (nOvertime > 0) {
            totalRounds = maxRounds + 6 * nOvertime;
        }
        let totalBars = elStatsContainer.Children().length;
        elStatsContainer.SetHasClass("horizontal-center", nOvertime == 0);
        let roundWinsStat = MatchInfoAPI.GetMatchPlayerRoundStats(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid, "round_wins");
        let roundWins = roundWinsStat ? roundWinsStat.split(',') : Array(totalRounds).fill(0);
        let mvpsStat = MatchInfoAPI.GetMatchPlayerRoundStats(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid, "mvps");
        let mvps = mvpsStat ? mvpsStat.split(',') : Array(totalRounds).fill(0);
        let killsStat = MatchInfoAPI.GetMatchPlayerRoundStats(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid, "enemy_kills");
        let kills = killsStat ? killsStat.split(',') : Array(totalRounds).fill(0);
        let headshotsStat = MatchInfoAPI.GetMatchPlayerRoundStats(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid, "enemy_headshots");
        let headshots = headshotsStat ? headshotsStat.split(',') : Array(totalRounds).fill(0);
        let deathsStat = MatchInfoAPI.GetMatchPlayerRoundStats(elParentPanel.Data().matchId, elParentPanel.Data().activePlayerRow.Data().playerXuid, "deaths");
        let deaths = deathsStat ? deathsStat.split(',') : Array(totalRounds).fill(0);
        function _IsMajorTick(n) {
            if (n == 1)
                return true;
            if (n == maxRounds)
                return true;
            if (n == totalRounds)
                return true;
            if (n > maxRounds && ((n - maxRounds) % 6 == 0))
                return true;
            return false;
        }
        function _IsMinorTick(n) {
            if (n < maxRounds) {
                if (maxRounds % 5 == 0)
                    return (n % 5 == 0);
                else if (maxRounds % 4 == 0)
                    return (n % 4 == 0);
                else if (maxRounds <= 12 && maxRounds % 3 == 0)
                    return (n % 3 == 0);
                else if (maxRounds <= 8 && maxRounds % 2 == 0)
                    return (n % 2 == 0);
            }
            else {
            }
            return false;
        }
        function _IsRightOfHalftime(n) {
            if (n == (maxRounds / 2 + 1))
                return true;
        }
        function _IsLeftOfHalftime(n) {
            if (n == (maxRounds / 2))
                return true;
        }
        function _GetTickStyleForRound(n) {
            if (_IsRightOfHalftime(n))
                return 'mi-round-tick--right-of-team-switch';
            else if (_IsLeftOfHalftime(n))
                return 'mi-round-tick--left-of-team-switch';
            else if (_IsMajorTick(n))
                return 'mi-round-tick--major';
            else if (_IsMinorTick(n))
                return 'mi-round-tick--minor';
            else
                return 'mi-round-tick--sub';
        }
        function _IsOvertime(n) {
            return (n > maxRounds);
        }
        function _OverTimeLabel(n) {
            if (n <= maxRounds)
                return '';
            let ot = Math.ceil(n - maxRounds) / 6;
            if (nOvertime > 1) {
                return $.Localize('#MatchInfo_Overtime') + ' ' + (ot);
            }
            else {
                return $.Localize('#MatchInfo_Overtime');
            }
        }
        function _GetLabelForTick(n) {
            if (_IsRightOfHalftime(n))
                return '<>';
            else if (_IsRightOfHalftime(n) || _IsLeftOfHalftime(n))
                return '';
            else if (_IsMajorTick(n) || _IsMinorTick(n))
                return n;
            else
                return '';
        }
        let numTimesPlayersChangedSides = 0;
        numTimesPlayersChangedSides += ((totalRounds > (maxRounds / 2)) ? 1 : 0);
        if (totalRounds > maxRounds) {
            let numRoundsPlayedInLastOvertime = (totalRounds - maxRounds) % 6;
            let numFullOvertimesPlayed = (totalRounds - maxRounds - numRoundsPlayedInLastOvertime) / 6;
            numTimesPlayersChangedSides += numFullOvertimesPlayed + ((numRoundsPlayedInLastOvertime > 3) ? 1 : 0);
        }
        if (numTimesPlayersChangedSides % 2 == 1) {
            currentTeamId = flipBit(currentTeamId);
        }
        for (let i = 1; i <= totalRounds; i++) {
            let elRoundStats = undefined;
            if (i > totalBars) {
                elRoundStats = $.CreatePanel('Button', elStatsContainer, 'id-stat-bar-round' + i);
                elRoundStats.BLoadLayoutSnippet('snippet_mi-round-summary-bar');
                elRoundStats.AddClass('round-selection-button');
            }
            else {
                elRoundStats = elStatsContainer.GetChild(i - 1);
            }
            let elRoundBar = elRoundStats.FindChildTraverse('id-mi-round-summary-bar__container');
            let elIconContainer = elRoundStats.FindChildTraverse('id-mi-icons__container');
            if (i > totalBars) {
                let elTick = elRoundBar.GetChild(2).GetChild(1);
                {
                    elTick.AddClass(_GetTickStyleForRound(i));
                }
            }
            else {
                elRoundBar.RemoveClass('hide');
            }
            let elWinBar = elRoundBar.GetChild(0).GetChild(0);
            let elWinLossBorder = elRoundBar.GetChild(1);
            let elLossBar = elRoundBar.GetChild(2).GetChild(0);
            if (i > playedRounds) {
                elWinLossBorder.RemoveClass('sb-tint--CT');
                elWinLossBorder.RemoveClass('sb-tint--TERRORIST');
                elWinBar.AddClass('mi-round-summary-bar--EMPTY');
                elLossBar.AddClass('mi-round-summary-bar--EMPTY');
                elIconContainer.AddClass('hide');
                elRoundStats.AddClass('no-hover');
            }
            else {
                _RefreshRoundWatchEnabled(elParentPanel);
                elIconContainer.RemoveClass('hide');
                let n = i - 1;
                let elMVPStarImg = elRoundStats.FindChildTraverse('id-mvp-star');
                if (mvps[n] != 0) {
                    elMVPStarImg.RemoveClass('hide');
                    elMVPStarImg.RemoveClass('sb-tint--' + TEAMS[flipBit(currentTeamId)]);
                    elMVPStarImg.AddClass('sb-tint--' + TEAMS[currentTeamId]);
                }
                else {
                    elMVPStarImg.AddClass('hide');
                }
                let nKills = parseInt(kills[n]);
                let nHeadshots = parseInt(headshots[n]);
                let elEliminationWinIcons = elRoundStats.FindChildTraverse('id-mi-eliminations-win');
                for (let k = 0; k < 5; k++) {
                    let kIcon = elEliminationWinIcons.FindChildTraverse('id-mi-icon-elimination_' + k);
                    let hIcon = elEliminationWinIcons.FindChildTraverse('id-mi-icon-elimination--headshot_' + k);
                    if (k >= (nKills)) {
                        kIcon.AddClass('hide');
                        hIcon.AddClass('hide');
                    }
                    else if (k >= nHeadshots) {
                        kIcon.RemoveClass('hide');
                        hIcon.AddClass('hide');
                    }
                    else {
                        kIcon.AddClass('hide');
                        hIcon.RemoveClass('hide');
                    }
                }
                let elDeathIcon = elIconContainer.FindChildTraverse('id-mi-elimination-death');
                if (deaths[n] == 1) {
                    elDeathIcon.RemoveClass('hide');
                }
                else {
                    elDeathIcon.AddClass('hide');
                }
                if (roundWins[n] == 1) {
                    elWinBar.RemoveClass('mi-round-summary-bar--EMPTY');
                    elLossBar.AddClass('mi-round-summary-bar--EMPTY');
                }
                else {
                    elWinBar.AddClass('mi-round-summary-bar--EMPTY');
                    elLossBar.RemoveClass('mi-round-summary-bar--EMPTY');
                }
                elWinBar.RemoveClass('sb-tint--' + TEAMS[flipBit(currentTeamId)]);
                elWinBar.AddClass('sb-tint--' + TEAMS[currentTeamId]);
                elWinLossBorder.RemoveClass('sb-tint--' + TEAMS[flipBit(currentTeamId)]);
                elWinLossBorder.AddClass('sb-tint--' + TEAMS[currentTeamId]);
                elEliminationWinIcons.RemoveClass('sb-tint--' + TEAMS[flipBit(currentTeamId)]);
                elEliminationWinIcons.AddClass('sb-tint--' + TEAMS[currentTeamId]);
            }
            if ((i == maxRounds / 2) || ((i > maxRounds) && (((i - maxRounds) % 6) == 3))) {
                currentTeamId = flipBit(currentTeamId);
            }
        }
        elParentPanel.FindChildInLayoutFile('id-mi-round-stats__tick-labels');
        elTickLabels.RemoveAndDeleteChildren();
        for (let i = 1; i <= totalRounds; i++) {
            let elTick = $.CreatePanel('Panel', elTickLabels, 'id-tick' + i);
            elTick.BLoadLayoutSnippet('snippet-tick');
            let strLabelForTick = _GetLabelForTick(i);
            elTick.SetDialogVariable('n', strLabelForTick.toString());
            elTick.SetHasClass('mi-tick-class-halftime-align', strLabelForTick === '<>');
        }
    }
    function _OpenPlayerCard(xuid) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE');
        let elPlayerCardContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-player-' + xuid, '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, function () { });
        elPlayerCardContextMenu.AddClass("ContextMenu_NoArrow");
    }
    function _FillScoreboard(elParentPanel) {
        let elScoreboard = elParentPanel.FindChildInLayoutFile('Scoreboard');
        elScoreboard.visible = true;
        _ShowMatchSpinner(false, elParentPanel);
        _SetMatchMessage("", false, elParentPanel);
        let currentTopPanelTeamId = MatchInfoAPI.GetMatchTournamentTeamID(elParentPanel.Data().matchId, 0);
        if (elParentPanel.Data().teamsFilled) {
            if (currentTopPanelTeamId != elParentPanel.Data().cachedTopPanelTeamId) {
                elParentPanel.Data().teamsFilled = false;
            }
        }
        elParentPanel.Data().cachedTopPanelTeamId = currentTopPanelTeamId;
        function Helper_FillTeamStats(teamId) {
            let elTeam = elParentPanel.FindChildInLayoutFile('players-table-' + TEAMS[teamId]);
            let elScoreboxBackdrop = elParentPanel.FindChildInLayoutFile('id-sb-scorebox_backdrop--' + TEAMS[teamId]);
            if (elParentPanel.Data().isTournament) {
                let tag = MatchInfoAPI.GetMatchTournamentTeamTag(elParentPanel.Data().matchId, teamId);
                if (!tag) {
                    tag = '';
                }
                elScoreboxBackdrop.SetImage('file://{images}/tournaments/teams/' + tag.toLowerCase() + '.svg');
                elScoreboxBackdrop.AddClass('scorebox_backdrop--tournament');
                elParentPanel.SetDialogVariable('sb_team_name--' + TEAMS[teamId], MatchInfoAPI.GetMatchTournamentTeamName(elParentPanel.Data().matchId, teamId));
            }
            else {
                elParentPanel.SetDialogVariable('sb_team_name--' + TEAMS[teamId], $.Localize('#teamname_' + TEAMS[teamId]));
            }
            elParentPanel.SetDialogVariable('score_' + TEAMS[teamId], (MatchInfoAPI.GetMatchRoundScoreForTeam(elParentPanel.Data().matchId, teamId)).toString());
            for (let i = 0; i < TEAMSIZE; i++) {
                let elPlayerRow = elTeam.GetChild(i);
                if (!elParentPanel.Data().teamsFilled) {
                    elPlayerRow.Data().playerXuid = MatchInfoAPI.GetMatchPlayerXuidByIndexForTeam(elParentPanel.Data().matchId, teamId, i);
                }
                let playerXuid = elPlayerRow.Data().playerXuid;
                let elPlayerName = elPlayerRow.FindChildTraverse('name__label');
                let elAvatarImage = elPlayerRow.FindChildTraverse('avatar');
                let elAvatarTeamLogo = elPlayerRow.FindChildTraverse('avatarteamlogo');
                if (!elParentPanel.Data().teamsFilled) {
                    elPlayerName.Data().matchId = elParentPanel.Data().matchId;
                    elPlayerName.Data().playerXuid = playerXuid;
                    elAvatarImage.SetPanelEvent('onactivate', _OpenPlayerCard.bind(undefined, playerXuid));
                    elAvatarTeamLogo.SetPanelEvent('onactivate', _OpenPlayerCard.bind(undefined, playerXuid));
                }
                if (elPlayerName.Data().nameUpdateHandler == undefined) {
                    elPlayerName.Data().nameUpdateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', _UpdateName.bind(undefined, elParentPanel, elPlayerName));
                }
                _UpdateName(elParentPanel, elPlayerName);
                if (!elParentPanel.Data().teamsFilled) {
                    let tag = MatchInfoAPI.GetMatchTournamentTeamTag(elParentPanel.Data().matchId, teamId);
                    if (!tag) {
                        tag = '';
                    }
                    elAvatarImage.visible = !elParentPanel.Data().isTournament;
                    elAvatarTeamLogo.visible = elParentPanel.Data().isTournament;
                    if (elParentPanel.Data().isTournament) {
                        elAvatarTeamLogo.SetImage('file://{images}/tournaments/teams/' + tag.toLowerCase() + '.svg');
                    }
                    else if (elAvatarImage.Data().steamid !== playerXuid) {
                        elAvatarImage.PopulateFromSteamID(playerXuid);
                        elAvatarImage.Data().steamid = playerXuid;
                    }
                }
                for (let p in PLAYERSTATS) {
                    let elStat = elPlayerRow.FindChildTraverse(PLAYERSTATS[p]);
                    let elStatData = MatchInfoAPI.GetMatchPlayerStat(elParentPanel.Data().matchId, playerXuid, PLAYERSTATS[p]);
                    elStat.text = elStatData;
                    if (PLAYERSTATS[p] === 'mvps') {
                        if (elStatData == '0' || !elStatData) {
                            elPlayerRow.FindChildTraverse('mvps__panel').AddClass('hide-mvps');
                        }
                        else {
                            elPlayerRow.FindChildTraverse('mvps__panel').RemoveClass('hide-mvps');
                        }
                    }
                }
            }
        }
        Helper_FillTeamStats(0);
        Helper_FillTeamStats(1);
        elParentPanel.Data().teamsFilled = true;
        let rawModeName = MatchInfoAPI.GetMatchMode(elParentPanel.Data().matchId);
        let rawMapName = MatchInfoAPI.GetMatchMap(elParentPanel.Data().matchId);
        let mapStringPrefix = '#SFUI_Map_';
        let mapName = $.Localize(mapStringPrefix + rawMapName);
        if (mapName === mapStringPrefix + rawMapName)
            mapName = rawMapName;
        elParentPanel.SetDialogVariable('map_name', mapName);
        let elMatchMapIcon = elParentPanel.FindChildTraverse("id-mi-map-icon");
        let setDefaultMapImage = function (mapIcon) {
            mapIcon.SetImage("file://{images}/map_icons/map_icon_NONE.png");
        };
        if (elMatchMapIcon) {
            $.RegisterEventHandler('ImageFailedLoad', elMatchMapIcon, setDefaultMapImage.bind(undefined, elMatchMapIcon));
            elMatchMapIcon.SetImage("file://{images}/map_icons/map_icon_" + rawMapName + ".svg");
        }
        let elMatchModeIcon = elParentPanel.FindChildTraverse("id-mi-mode-icon");
        let setDefaultModeImage = function (mapIcon) {
            mapIcon.SetImage("file://{images}/icons/ui/competitive.vsvg");
        };
        if (elMatchModeIcon) {
            $.RegisterEventHandler('ImageFailedLoad', elMatchModeIcon, setDefaultModeImage.bind(undefined, elMatchModeIcon));
            elMatchModeIcon.SetImage("file://{images}/icons/ui/" + rawModeName + ".svg");
        }
        let matchDuration = MatchInfoAPI.GetMatchDuration(elParentPanel.Data().matchId);
        matchDuration = Math.max(Math.floor(matchDuration / 60), 1);
        elParentPanel.SetDialogVariable('duration', $.ConstructString('#CSGO_Watch_Minute:f', { value: matchDuration }));
        if (elParentPanel.Data().matchListDescriptor === 'live') {
            let round = 1 + MatchInfoAPI.GetMatchRoundScoreForTeam(elParentPanel.Data().matchId, 0) + MatchInfoAPI.GetMatchRoundScoreForTeam(elParentPanel.Data().matchId, 1);
            let progressionStateString = '#WatchMenu_FirstHalf';
            if (round > 31) {
                progressionStateString = '#WatchMenu_Overtime';
            }
            else if (round > 15) {
                progressionStateString = '#WatchMenu_SecondHalf';
            }
            elParentPanel.SetDialogVariable('dateOrRound', $.Localize(progressionStateString));
            elParentPanel.SetDialogVariable('dateOrRoundLabel', $.Localize('#CSGO_Watch_Info_4'));
            elParentPanel.SetDialogVariable('durationLabel', $.Localize("#CSGO_Watch_Info_5"));
        }
        else {
            elParentPanel.SetDialogVariable('dateOrRound', MatchInfoAPI.IsLive(elParentPanel.Data().matchId) ? $.Localize('#CSGO_Watch_Cat_LiveMatches') : MatchInfoAPI.GetMatchTimestamp(elParentPanel.Data().matchId));
            elParentPanel.SetDialogVariable('dateOrRoundLabel', $.Localize('#CSGO_Watch_Info_2'));
            elParentPanel.SetDialogVariable('durationLabel', $.Localize("#CSGO_Watch_Info_1"));
        }
    }
    function _FillServerLogTournamentInfo(elParentPanel) {
        PopulateForTeam(0);
        PopulateForTeam(1);
        function PopulateForTeam(nTeam) {
            let tag = MatchInfoAPI.GetMatchTournamentTeamTag(elParentPanel.Data().matchId, nTeam);
            if (tag) {
                let strFilename = 'file://{images}/tournaments/teams/' + tag.toLowerCase() + '.svg';
                let img = elParentPanel.FindChildTraverse('team_image' + nTeam);
                img.SetImage(strFilename);
            }
            elParentPanel.SetDialogVariable('teamname' + nTeam, MatchInfoAPI.GetMatchTournamentTeamName(elParentPanel.Data().matchId, nTeam));
            elParentPanel.SetDialogVariable('score' + nTeam, (MatchInfoAPI.GetMatchRoundScoreForTeam(elParentPanel.Data().matchId, nTeam)).toString());
        }
        let rawMapName = MatchInfoAPI.GetMatchMap(elParentPanel.Data().matchId);
        let mapStringPrefix = '#SFUI_Map_';
        let mapName = $.Localize(mapStringPrefix + rawMapName);
        if (mapName === mapStringPrefix + rawMapName)
            mapName = rawMapName;
        elParentPanel.SetDialogVariable('mapname', mapName);
        let elMatchMapIcon = elParentPanel.FindChildTraverse("map_image");
        if (elMatchMapIcon) {
            elMatchMapIcon.SetImage("file://{images}/map_icons/map_icon_" + rawMapName + ".svg");
        }
        let elTournamentLogo = elParentPanel.FindChildTraverse("tournament_logo");
        elTournamentLogo.SetImage('file://{images}/tournaments/events/tournament_logo_' + elParentPanel.Data().tournamentIndex + '.svg');
        elParentPanel.SetDialogVariable('tournamentphase', $.Localize(MatchInfoAPI.GetMatchTournamentStageName(elParentPanel.Data().matchId)));
        elParentPanel.SetDialogVariable('matchphase', MatchInfoAPI.IsLive(elParentPanel.Data().matchId) ? $.Localize('#CSGO_Watch_Cat_LiveMatches') : MatchInfoAPI.GetMatchTimestamp(elParentPanel.Data().matchId));
    }
    function Init(elParentPanel) {
        _ShowMatchSpinner(true, elParentPanel);
        _SetMatchMessage("", false, elParentPanel);
        let bIsMinimalMatchInfo = MatchInfoAPI.IsServerLogTournamentMatch(elParentPanel.Data().matchId);
        elParentPanel.SetHasClass('matchinfo--minimal', bIsMinimalMatchInfo);
        if (bIsMinimalMatchInfo) {
            let minimalInfoBody = $.CreatePanel('Panel', elParentPanel, 'minimal-match-info');
            minimalInfoBody.BLoadLayoutSnippet('matchinfo_serverlogtournament_minimal');
        }
        let myXuid = MyPersonaAPI.GetXuid();
        function Helper_CreateScoreboard(teamId) {
            let elRowToActivate = undefined;
            let elTeam = elParentPanel.FindChildInLayoutFile('players-table-' + TEAMS[teamId]);
            for (let i = 0; i < TEAMSIZE; i++) {
                let playerXuid = MatchInfoAPI.GetMatchPlayerXuidByIndexForTeam(elParentPanel.Data().matchId, teamId, i);
                let elPlayerRow = $.CreatePanel('Panel', elTeam, 'id-player-' + playerXuid);
                if (!playerXuid) {
                    elTeam.AddClass('with-empty-rows');
                }
                elPlayerRow.Data().playerXuid = playerXuid;
                elPlayerRow.Data().teamId = teamId;
                if (elParentPanel.Data().matchListDescriptor != 'live') {
                    elPlayerRow.SetPanelEvent('onactivate', _FillRoundStats.bind(undefined, elParentPanel, elPlayerRow));
                    if (((i == 0) && (teamId == 0)) || (myXuid === playerXuid)) {
                        elParentPanel.Data().activePlayerRow = elPlayerRow;
                    }
                }
                elPlayerRow.BLoadLayoutSnippet('snippet_scoreboard-classic__row--comp');
                let elAvatarImage = elPlayerRow.FindChildTraverse('avatar');
                elAvatarImage.AddClass('sb-row__cell--avatar--' + TEAMS[teamId]);
                let elPlayerNameLabel = elPlayerRow.FindChildTraverse('name__label');
                elPlayerNameLabel.AddClass('sb-tint--' + TEAMS[teamId]);
                elPlayerNameLabel.SetPanelEvent('onactivate', function (elParentPanel, elPlayerRow, playerXuid) {
                    if (elParentPanel.Data().matchListDescriptor != 'live')
                        _FillRoundStats(elParentPanel, elPlayerRow);
                    _OpenPlayerCard(playerXuid);
                }
                    .bind(undefined, elParentPanel, elPlayerRow, playerXuid));
                let elStatsContainer = elPlayerRow.FindChildTraverse('id-sb-row-stats');
                for (let p in PLAYERSTATS) {
                    let elStat;
                    if (PLAYERSTATS[p] === 'mvps') {
                        let elMvpsPanel = $.CreatePanel('Panel', elStatsContainer, 'mvps__panel');
                        let elStar = $.CreatePanel("Image", elMvpsPanel, 'mvps--image');
                        elStar.SetImage('file://{images}/icons/ui/star.svg');
                        elStat = $.CreatePanel('Label', elMvpsPanel, PLAYERSTATS[p]);
                        elStat.AddClass('mi-mvps-shrink-overflow');
                        elMvpsPanel.AddClass('sb-row__cell');
                        elMvpsPanel.AddClass('sb-row__cell--mvps');
                        elStar.AddClass('sb-row__cell--mvps__star');
                        elStat.AddClass('sb-row__cell--mvps__count');
                        elStat = elMvpsPanel;
                    }
                    else {
                        elStat = $.CreatePanel('Panel', elStatsContainer, "");
                        elStat.AddClass('sb-row__cell');
                        elStat.AddClass('sb-row__cell--' + PLAYERSTATS[p]);
                        elStat = $.CreatePanel('Label', elStat, PLAYERSTATS[p]);
                    }
                    elStat.AddClass('sb-tint--' + TEAMS[teamId]);
                }
            }
        }
        Helper_CreateScoreboard(0);
        Helper_CreateScoreboard(1);
        let tournamentName = MatchInfoAPI.GetMatchTournamentName(elParentPanel.Data().matchId);
        elParentPanel.Data().isTournament = ((tournamentName != "") && (tournamentName != undefined));
        elParentPanel.Data().matchShareToken = MatchInfoAPI.GetMatchShareToken(elParentPanel.Data().matchId, "text");
        elParentPanel.Data().downloadFailedTest = undefined;
        elParentPanel.Data().updateMatchInfoHandler = undefined;
        elParentPanel.Data().teamsFilled = false;
        let elColumnLabels = elParentPanel.FindChildInLayoutFile('players-table__labels-row');
        for (let p in PLAYERSTATS) {
            let elStatContainter = $.CreatePanel('Panel', elColumnLabels, "");
            elStatContainter.AddClass('sb-row__cell');
            elStatContainter.AddClass('sb-row__cell--' + PLAYERSTATS[p]);
            elStatContainter.AddClass('matchinfo-scoreboard-header-stat-cell');
            let elStatLabel = $.CreatePanel('Label', elStatContainter, PLAYERSTATS[p]);
            elStatLabel.text = $.Localize('#Scoreboard_' + PLAYERSTATS[p] + '_header');
        }
        $.RegisterEventHandler('PropertyTransitionEnd', elParentPanel, _OnFadeOutEnd.bind(undefined, elParentPanel));
        let elDownloadButton = elParentPanel.FindChildInLayoutFile('id-mi-download');
        let elShareLinkButton = elParentPanel.FindChildInLayoutFile('id-mi-copy');
        let elWatchButton = elParentPanel.FindChildInLayoutFile('id-mi-watch');
        let elWatchHighlightsButton = elParentPanel.FindChildInLayoutFile('id-mi-watch-highlights');
        let elWatchLowlightsButton = elParentPanel.FindChildInLayoutFile('id-mi-watch-lowlights');
        let elDeleteButton = elParentPanel.FindChildInLayoutFile('id-mi-delete');
        let elDownloadingButton = elParentPanel.FindChildInLayoutFile('id-mi-downloading');
        let elDownloadFailedButton = elParentPanel.FindChildInLayoutFile('id-mi-error-delete');
        let elSouvenirButton = elParentPanel.FindChildInLayoutFile('id-mi-souvenir');
        if (elWatchButton && (elParentPanel.Data().matchListDescriptor == 'live')) {
            let elWatchLabel = elWatchButton.GetChild(0);
            elWatchLabel.text = $.Localize("#WatchMenu_Watch_Live");
            elWatchLabel.style.textTransform = "uppercase";
        }
        elDownloadButton.SetPanelEvent('onactivate', _DownloadMatch.bind(undefined, elParentPanel));
        elShareLinkButton.SetPanelEvent('onactivate', _ShareMatch.bind(undefined, elParentPanel));
        elShareLinkButton.SetDialogVariable('matchcode', elParentPanel.Data().matchShareToken);
        elShareLinkButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elShareLinkButton, $.Localize('#WatchMenu_Get_Share_Link')); });
        elShareLinkButton.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
        elWatchButton.SetPanelEvent('onactivate', _Watch.bind(undefined, elParentPanel));
        elWatchHighlightsButton.SetPanelEvent('onactivate', _WatchHighlights.bind(undefined, elParentPanel));
        elWatchHighlightsButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elWatchHighlightsButton, $.Localize('#WatchMenu_Watch_Highlights')); });
        elWatchHighlightsButton.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
        elWatchLowlightsButton.SetPanelEvent('onactivate', _WatchLowlights.bind(undefined, elParentPanel));
        elWatchLowlightsButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elWatchLowlightsButton, $.Localize('#WatchMenu_Watch_Lowlights')); });
        elWatchLowlightsButton.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
        elDeleteButton.SetPanelEvent('onactivate', _DeleteDemo.bind(undefined, elParentPanel));
        elDeleteButton.SetPanelEvent('onmouseover', function () { UiToolkitAPI.ShowTextTooltipOnPanel(elDeleteButton, $.Localize('#WatchMenu_Delete')); });
        elDeleteButton.SetPanelEvent('onmouseout', function () { UiToolkitAPI.HideTextTooltip(); });
        elDownloadFailedButton.SetPanelEvent('onactivate', _DownloadFailedNotify.bind(undefined, elParentPanel));
        elSouvenirButton.SetPanelEvent('onactivate', _RedeemSouvenir.bind(undefined, elParentPanel.Data().tournamentIndex, elParentPanel.Data().matchId));
        Refresh(elParentPanel);
    }
    matchInfo.Init = Init;
})(matchInfo || (matchInfo = {}));
