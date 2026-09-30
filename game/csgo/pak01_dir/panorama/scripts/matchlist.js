"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="mainmenu_watch.ts" />
/// <reference path="matchinfo.ts" />
var matchList;
(function (matchList) {
    let _m_myXuid = MyPersonaAPI.GetXuid();
    function ShowListSpinner(value, tab) {
        if (tab) {
            let elSpinner = tab.FindChildInLayoutFile("id-list-spinner");
            ShowInfoPanel(false, tab);
            _ShowListPanel(false, tab);
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
    matchList.ShowListSpinner = ShowListSpinner;
    function SetListMessage(value, show, tab = null) {
        if (tab) {
            let elMessage = tab.FindChildInLayoutFile("id-list-message");
            if (elMessage) {
                elMessage.text = value;
            }
            let elMessageContainer = tab.FindChildInLayoutFile("id-list-message-container");
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
    matchList.SetListMessage = SetListMessage;
    function ShowInfoPanel(value, tab = null) {
        if (tab) {
            let elInfoPanel = tab.FindChildInLayoutFile("Info");
            let elMatchList = tab.FindChildInLayoutFile("JsMatchList");
            if (elInfoPanel) {
                if (value) {
                    elInfoPanel.AddClass('subsection-content__background-color--dark');
                    if (tab.Data().activeMatchInfoPanel) {
                        matchInfo.Refresh(tab.Data().activeMatchInfoPanel);
                    }
                }
                else {
                    elInfoPanel.RemoveClass('subsection-content__background-color--dark');
                    if (tab.Data().activeMatchInfoPanel) {
                        matchInfo.Hide(tab.Data().activeMatchInfoPanel);
                    }
                }
            }
            if (elMatchList) {
                if (value) {
                    elMatchList.AddClass("MatchList--Filled");
                }
                else {
                    elMatchList.RemoveClass("MatchList--Filled");
                }
            }
        }
    }
    matchList.ShowInfoPanel = ShowInfoPanel;
    function _ShowListPanel(value, tab = undefined) {
        if (tab) {
            let elMatchList = tab.FindChildInLayoutFile("JsMatchList");
            if (elMatchList) {
                if (!value) {
                    elMatchList.AddClass('hide');
                }
                else {
                    elMatchList.RemoveClass('hide');
                }
            }
        }
    }
    function _ClearList(elListPanel, tournament_id) {
        let activeTiles = elListPanel.Children();
        for (let i = activeTiles.length - 1; i >= 0; i--) {
            if (activeTiles[i].Data().markForDelete) {
                if (elListPanel.Data().activeButton === activeTiles[i]) {
                    elListPanel.Data().activeButton = undefined;
                }
                activeTiles[i].checked = false;
                if (watchTile.GetDownloadHandler(activeTiles[i])) {
                    $.UnregisterForUnhandledEvent('PanoramaComponent_MatchInfo_StateChange', watchTile.GetDownloadHandler(activeTiles[i]));
                    watchTile.SetDownloadHandler(activeTiles[i], null);
                }
                if (tournament_id) {
                    activeTiles[i].AddClass('MatchTile--Collapse');
                }
                else {
                    watchTile.Delete(activeTiles[i]);
                }
            }
        }
    }
    function _SelectFirstTile(parentPanel, elMatchList, matchListDescriptor) {
        if (elMatchList && !(elMatchList.Data().activeButton) && (elMatchList.GetChildCount() > 0)) {
            let tileIsVisible = false;
            let elFirstTile = null;
            let n = 0;
            do {
                elFirstTile = elMatchList.GetChild(n);
                tileIsVisible = (elFirstTile && !elFirstTile.BHasClass('MatchTile--Collapse'));
                n = n + 1;
            } while ((!tileIsVisible) && (elFirstTile != undefined));
            if (elFirstTile) {
                elFirstTile.checked = true;
                elMatchList.Data().activeButton = elFirstTile;
                elFirstTile.ScrollParentToMakePanelFit(2, false);
                _PopulateMatchInfo(parentPanel, matchListDescriptor, elFirstTile.Data().matchId);
            }
        }
    }
    function ReselectActiveTile(elListRoot) {
        let elMatchList = elListRoot.FindChildTraverse("JsMatchList");
        if (elMatchList && elMatchList.Data().activeButton) {
            (elMatchList.Data().activeButton).checked = true;
            _PopulateMatchInfo(elListRoot, elListRoot.Data().matchListDescriptor, elMatchList.Data().activeButton.Data().matchId);
        }
        else {
            _SelectFirstTile(elListRoot, elMatchList, elListRoot.Data().matchListDescriptor);
        }
    }
    matchList.ReselectActiveTile = ReselectActiveTile;
    let _OnTournamentTeamSelected = function (elParentPanel, elMatchList, matchListDescriptor) {
        elParentPanel.Data().matchListIsPopulated = false;
        UpdateMatchList(elParentPanel, elParentPanel.Data().tournament_id);
        elMatchList.Data().activeButton = undefined;
        _SelectFirstTile(elParentPanel, elMatchList, matchListDescriptor);
    };
    let _OnTournamentSectionSelected = function (elParentPanel, elMatchList, matchListDescriptor) {
        _PopulateMatchTeamsDropdown(elParentPanel, elParentPanel.Data().tournament_id);
        elParentPanel.Data().matchListIsPopulated = false;
        UpdateMatchList(elParentPanel, elParentPanel.Data().tournament_id);
        elMatchList.Data().activeButton = undefined;
        _SelectFirstTile(elParentPanel, elMatchList, matchListDescriptor);
    };
    function MakeDropDownEntry(index, sectionDesc, sectionName, elMatchlistDropdown) {
        let elSection = $.CreatePanel('Label', elMatchlistDropdown, 'group_' + sectionDesc, { text: sectionName });
        elSection.AddClass("DropDownMenu");
        elSection.AddClass("Width-300");
        elSection.AddClass("White");
        elSection.SetAttributeString('value', index.toString());
        elSection.SetAttributeString('section_id', sectionDesc.toString());
        elMatchlistDropdown.AddOption(elSection);
    }
    let _PopulateMatchlistDropdown = function (elParentPanel, tournamentId) {
        let elMatchlistDropdown = elParentPanel.FindChildTraverse("id-match-list-selector");
        elMatchlistDropdown.ClearPanelEvent('oninputsubmit');
        let nSections = PredictionsAPI.GetEventSectionsCount(tournamentId);
        elMatchlistDropdown.RemoveAllOptions();
        for (let i = 0; i < nSections; i++) {
            let sectionDesc = PredictionsAPI.GetEventSectionIDByIndex(tournamentId, i);
            let sectionName = PredictionsAPI.GetSectionName(tournamentId, sectionDesc);
            sectionName = $.Localize("#CSGO_MatchInfo_Stage_" + sectionName.replace(/\s+/g, ''));
            MakeDropDownEntry(i, sectionDesc.toString(), sectionName, elMatchlistDropdown);
        }
        let sectionsCount = PredictionsAPI.GetEventSectionsCount(tournamentId);
        let activeIndex = sectionsCount - 1;
        for (let i = 0; i < sectionsCount; i++) {
            let sectionId = PredictionsAPI.GetEventSectionIDByIndex(tournamentId, i);
            if (PredictionsAPI.GetSectionIsActive(tournamentId, sectionId)) {
                activeIndex = i;
                break;
            }
        }
        elMatchlistDropdown.SetSelectedIndex(activeIndex);
        elMatchlistDropdown.RemoveClass('hide');
        let elMatchList = elParentPanel.FindChildTraverse("JsMatchList");
        elMatchlistDropdown.SetPanelEvent('oninputsubmit', _OnTournamentSectionSelected.bind(undefined, elParentPanel, elMatchList, tournamentId));
    };
    let _PopulateMatchTeamsDropdown = function (elParentPanel, tournamentId) {
        let elMatchistTeamDropdown = elParentPanel.FindChildTraverse("id-match-list-selector-teams");
        elMatchistTeamDropdown.ClearPanelEvent('oninputsubmit');
        elMatchistTeamDropdown.RemoveAllOptions();
        let elStageDropdown = elParentPanel.FindChildTraverse("id-match-list-selector");
        let sectionId = elStageDropdown.GetSelected().GetAttributeString('section_id', '');
        let teamsList = [];
        let numGroups = PredictionsAPI.GetSectionGroupsCount(tournamentId, parseInt(sectionId));
        MakeDropDownEntry(0, 'allteams', '#Matchlist_Team_Selection', elMatchistTeamDropdown);
        teamsList.push('allteams');
        for (let j = 0; j < numGroups; j++) {
            let numGroupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, parseInt(sectionId), j);
            let count = PredictionsAPI.GetGroupTeamsPickableCount(tournamentId, numGroupId);
            for (let h = 0; h < count; h++) {
                let teamId = PredictionsAPI.GetGroupTeamIDByIndex(tournamentId, numGroupId, h);
                if (teamsList.indexOf(teamId) === -1 && teamId) {
                    teamsList.push(teamId);
                    let teamName = PredictionsAPI.GetTeamName(teamId);
                    MakeDropDownEntry((teamsList.length - 1), teamId.toString(), teamName, elMatchistTeamDropdown);
                }
            }
        }
        elMatchistTeamDropdown.SetSelectedIndex(teamsList.indexOf('allteams'));
        elMatchistTeamDropdown.RemoveClass('hide');
        elMatchistTeamDropdown.enabled = (teamsList.length > 1);
        let elMatchList = elParentPanel.FindChildTraverse("JsMatchList");
        elMatchistTeamDropdown.SetPanelEvent('oninputsubmit', _OnTournamentTeamSelected.bind(undefined, elParentPanel, elMatchList, tournamentId));
    };
    function UpdateMatchList(elTab, matchListDescriptor, optbFromMatchListChangeEvent = false) {
        let listState = MatchListAPI.GetState(matchListDescriptor);
        if (listState === 'none') {
            listState = _RequestMatchListUpdate(elTab, matchListDescriptor);
        }
        else if (listState === 'ready' && !optbFromMatchListChangeEvent) {
            listState = _RequestMatchListUpdate(elTab, matchListDescriptor);
        }
        if (elTab && (listState !== "loading")) {
            _PopulateMatchList(elTab, matchListDescriptor);
        }
    }
    matchList.UpdateMatchList = UpdateMatchList;
    function _PopulateMatchInfo(parentPanel, matchListDescriptor, matchId) {
        let elMatchList = parentPanel.FindChildTraverse("JsMatchList");
        let elButton = parentPanel.FindChildTraverse(matchListDescriptor + "_" + matchId);
        if (elMatchList.Data().activeButton) {
            watchTile.SetParentActive(elMatchList.Data().activeButton, false);
        }
        if (elButton) {
            elMatchList.Data().activeButton = elButton;
        }
        if ((parentPanel.Data().activeMatchInfoPanel) && (parentPanel.Data().activeMatchInfoPanel.Data().matchId === matchId) && (matchId != 'gotv')) {
            matchInfo.Refresh(parentPanel.Data().activeMatchInfoPanel);
            return;
        }
        if ((parentPanel.Data().activeMatchInfoPanel) && (parentPanel.Data().activeMatchInfoPanel.Data().matchId != matchId)) {
            matchInfo.Hide(parentPanel.Data().activeMatchInfoPanel);
            parentPanel.Data().activeMatchInfoPanel = undefined;
        }
        let parentInfoPanel = parentPanel.FindChildTraverse('Info');
        parentPanel.Data().activeMatchInfoPanel = parentInfoPanel.FindChild('info_' + matchId);
        if (parentPanel.Data().activeMatchInfoPanel == undefined) {
            parentPanel.Data().activeMatchInfoPanel = $.CreatePanel('Panel', parentInfoPanel, 'info_' + matchId);
            parentPanel.Data().activeMatchInfoPanel.Data().matchId = matchId;
            parentPanel.Data().activeMatchInfoPanel.Data().matchListDescriptor = matchListDescriptor;
            parentPanel.Data().activeMatchInfoPanel.BLoadLayout("file://{resources}/layout/matchinfo.xml", false, false);
            parentPanel.Data().activeMatchInfoPanel.Data().tournament_id = parentPanel.Data().tournament_id;
            parentPanel.Data().activeMatchInfoPanel.Data().tournamentIndex = parentPanel.Data().tournamentIndex;
            matchInfo.Init(parentPanel.Data().activeMatchInfoPanel);
        }
        else {
            matchInfo.Refresh(parentPanel.Data().activeMatchInfoPanel);
        }
    }
    function _RequestMatchListUpdate(elTab, matchListDescriptor) {
        function _ShowLoadingError(elBoundTab) {
            ShowListSpinner(false, elBoundTab);
            let msg = "";
            if (elBoundTab.Data().tournament_id) {
                msg = "#CSGO_Watch_NoMatch_Tournament_" + elBoundTab.Data().tournament_id.split(':')[1];
            }
            else {
                switch (elTab.id) {
                    case "JsLive":
                        msg = "#CSGO_Watch_NoMatch_live";
                        break;
                    case "JsYourMatches":
                        msg = "#CSGO_Watch_NoMatch_your_ranked";
                        break;
                }
            }
            SetListMessage($.Localize(msg), true, elBoundTab);
            elBoundTab.Data().downloadFailedHandler = undefined;
        }
        if (elTab) {
            MatchListAPI.Refresh(matchListDescriptor);
            let newState = MatchListAPI.GetState(matchListDescriptor);
            if (newState === "loading") {
                ShowListSpinner(true, elTab);
                SetListMessage("", false, elTab);
                elTab.Data().matchListIsPopulated = false;
                if (elTab.Data().downloadFailedHandler) {
                    $.CancelScheduled(elTab.Data().downloadFailedHandler);
                    elTab.Data().downloadFailedHandler = undefined;
                }
                elTab.Data().downloadFailedHandler = $.Schedule(3.0, _ShowLoadingError.bind(undefined, elTab));
            }
            return newState;
        }
    }
    function _MarkActiveTabUnpopulated() {
        mainmenu_watch.GetActiveTab().Data().matchListIsPopulated = false;
    }
    function _PopulateMatchList(parentPanel, matchListDescriptor) {
        if (!parentPanel)
            return;
        function OnMouseOverButton(currentParentPanel, buttonId) {
            let elButton = currentParentPanel.FindChildTraverse(buttonId);
            watchTile.SetParentActive(elButton, true);
        }
        function OnMouseOutButton(currentParentPanel, buttonId) {
            let elButton = currentParentPanel.FindChildTraverse(buttonId);
            if (!elButton.IsSelected()) {
                watchTile.SetParentActive(elButton, false);
            }
        }
        function _ClearMatchInfo() {
            if (parentPanel.Data().activeMatchInfoPanel) {
                matchInfo.Hide(parentPanel.Data().activeMatchInfoPanel);
                parentPanel.Data().activeMatchInfoPanel = undefined;
            }
        }
        function _ShowGOTVConfirmPopup(elListRoot) {
            _ClearMatchInfo();
            UiToolkitAPI.ShowGenericPopupOkCancel($.Localize('#CSGO_Watch_Gotv_Theater'), $.Localize('#CSGO_Watch_Gotv_Theater_tip'), '', function () { MatchListAPI.StartGOTVTheater("live"); }, ReselectActiveTile.bind(undefined, elListRoot));
        }
        if (parentPanel.Data().downloadFailedHandler) {
            $.CancelScheduled(parentPanel.Data().downloadFailedHandler);
            parentPanel.Data().downloadFailedHandler = undefined;
        }
        function GetListOfMatchIds(matchListDescriptor, tournamentIndex, unfilteredCount, sectionDesc, teamId = null) {
            let MatchIds = [];
            for (let i = 0; i < unfilteredCount; i++) {
                let matchId = '';
                if (tournamentIndex > 3) {
                    matchId = PredictionsAPI.GetSectionMatchByIndex(matchListDescriptor, sectionDesc, i);
                }
                else if (tournamentIndex <= 3 || !tournamentIndex) {
                    matchId = MatchListAPI.GetMatchByIndex(matchListDescriptor, i).toString();
                }
                if (tournamentIndex && teamId && teamId != 0) {
                    if (IsTeamInMatch(teamId, matchId)) {
                        MatchIds.push(matchId);
                    }
                }
                else {
                    MatchIds.push(matchId);
                }
            }
            return MatchIds;
        }
        function IsTeamInMatch(teamId, matchId) {
            for (let i = 0; i <= 1; i++) {
                if (MatchInfoAPI.GetMatchTournamentTeamID(matchId, i) === teamId) {
                    return true;
                }
            }
            return false;
        }
        let unfilteredCount = MatchListAPI.GetCount(matchListDescriptor);
        let nCount = 0;
        let sectionDesc = 0;
        let tournamentIndex = 0;
        let MatchIdsFiltered = [];
        if ((unfilteredCount > 0) && (parentPanel.Data().tournament_id)) {
            tournamentIndex = parentPanel.Data().tournament_id.split(':')[1];
            parentPanel.Data().tournamentIndex = tournamentIndex;
            if (!parentPanel.Data().matchListDropdownIsPopulated) {
                if (tournamentIndex > 3) {
                    _PopulateMatchlistDropdown(parentPanel, parentPanel.Data().tournament_id);
                    _PopulateMatchTeamsDropdown(parentPanel, parentPanel.Data().tournament_id);
                }
                parentPanel.Data().matchListDropdownIsPopulated = true;
            }
            if (tournamentIndex > 3) {
                let elDropdown = parentPanel.FindChildTraverse("id-match-list-selector");
                sectionDesc = parseInt(elDropdown.GetSelected().GetAttributeString('section_id', ''));
                unfilteredCount = PredictionsAPI.GetSectionMatchesCount(parentPanel.Data().tournament_id, sectionDesc);
                let elStageDropdown = parentPanel.FindChildTraverse("id-match-list-selector-teams");
                ;
                let strTeamId = elStageDropdown.GetSelected().GetAttributeString('section_id', '');
                let nteamId = strTeamId === 'allteams' ? 0 : Number(strTeamId);
                MatchIdsFiltered = GetListOfMatchIds(parentPanel.Data().tournament_id, tournamentIndex, unfilteredCount, sectionDesc, nteamId);
                nCount = MatchIdsFiltered.length;
            }
            else if (tournamentIndex == 1) {
                MatchIdsFiltered = GetListOfMatchIds(parentPanel.Data().tournament_id, tournamentIndex, unfilteredCount, sectionDesc, null);
                nCount = MatchIdsFiltered.length - 3;
            }
            else if (tournamentIndex == 3) {
                MatchIdsFiltered = GetListOfMatchIds(parentPanel.Data().tournament_id, tournamentIndex, unfilteredCount, sectionDesc, null);
                nCount = MatchIdsFiltered.length - 1;
            }
        }
        else {
            MatchIdsFiltered = GetListOfMatchIds(matchListDescriptor, null, unfilteredCount, null, null);
            nCount = unfilteredCount;
        }
        ShowListSpinner(false, parentPanel);
        if (nCount <= 0) {
            ShowInfoPanel(false, parentPanel);
            _ShowListPanel(false, parentPanel);
            let msg = "";
            if (parentPanel.Data().tournament_id) {
                msg = "#CSGO_Watch_NoMatch_Tournament_" + parentPanel.Data().tournament_id.split(':')[1];
            }
            else {
                switch (parentPanel.id) {
                    case "JsLive":
                        msg = "#CSGO_Watch_NoMatch_live";
                        break;
                    case "JsYourMatches":
                        msg = "#CSGO_Watch_NoMatch_your_ranked";
                        break;
                    case "JsDownloaded":
                        msg = "#CSGO_Watch_NoMatch_downloaded";
                        break;
                }
            }
            SetListMessage($.Localize(msg), true, parentPanel);
        }
        let elMatchList = parentPanel.FindChildTraverse("JsMatchList");
        if (!elMatchList) {
            return;
        }
        for (let i = 0; i < elMatchList.GetChildCount(); i++) {
            elMatchList.GetChild(i).Data().markForDelete = true;
        }
        function _CreateOrValidateMatchTile(matchId) {
            let elMatchButton = elMatchList.FindChildInLayoutFile(matchListDescriptor + "_" + matchId);
            if (!elMatchButton || matchListDescriptor === 'live') {
                if (matchListDescriptor === 'live') {
                    if (elMatchButton) {
                        elMatchButton.DeleteAsync(0.0);
                    }
                }
                elMatchButton = $.CreatePanel('RadioButton', elMatchList, matchListDescriptor + "_" + matchId);
                elMatchButton.Data().downloadStateHandler = undefined;
                elMatchButton.Data().group = parentPanel.id;
                elMatchButton.Data().myXuid = _m_myXuid;
                elMatchButton.Data().matchId = matchId;
                elMatchButton.Data().matchListDescriptor = matchListDescriptor;
                if (matchId != 'gotv') {
                    elMatchButton.SetPanelEvent('onactivate', _PopulateMatchInfo.bind(undefined, parentPanel, matchListDescriptor, matchId));
                }
                else {
                    elMatchButton.SetPanelEvent('onactivate', _ShowGOTVConfirmPopup.bind(undefined, parentPanel));
                }
                elMatchButton.SetPanelEvent('onmouseover', OnMouseOverButton.bind(undefined, parentPanel, matchListDescriptor + "_" + matchId));
                elMatchButton.SetPanelEvent('onmouseout', OnMouseOutButton.bind(undefined, parentPanel, matchListDescriptor + "_" + matchId));
                watchTile.Init(elMatchButton);
                elMatchButton.RemoveClass('MatchTile--Collapse');
            }
            else {
                watchTile.Refresh(elMatchButton);
            }
            elMatchButton.Data().markForDelete = false;
            function _UpdateDownloadState(elBoundMatchButton) {
                if ((elBoundMatchButton) && (!elBoundMatchButton.Data().markForDelete)) {
                    let elDownloadIndicator = elBoundMatchButton.FindChildInLayoutFile('id-download-state');
                    if (elDownloadIndicator) {
                        let isDownloading = Boolean((MatchInfoAPI.GetMatchState(elBoundMatchButton.Data().matchId) === "downloading"));
                        let canWatch = Boolean(MatchInfoAPI.CanWatch(elBoundMatchButton.Data().matchId));
                        let isLive = Boolean(MatchInfoAPI.IsLive(elBoundMatchButton.Data().matchId));
                        elDownloadIndicator.SetHasClass("download-animation", isDownloading);
                        elDownloadIndicator.SetHasClass("watchlive", isLive);
                        elDownloadIndicator.SetHasClass("downloaded", canWatch && !isLive);
                    }
                }
            }
            if ((elMatchButton.Data().downloadStateHandler == undefined) && elMatchButton.FindChildInLayoutFile('id-download-state')) {
                elMatchButton.Data().downloadStateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MatchInfo_StateChange', _UpdateDownloadState.bind(undefined, elMatchButton));
            }
            _UpdateDownloadState(elMatchButton);
            elMatchButton.RemoveClass('MatchTile--Collapse');
        }
        for (let i = 0; i < nCount; i++) {
            if ((parentPanel.Data().tournament_id) && (tournamentIndex > 3)) {
                _CreateOrValidateMatchTile(MatchIdsFiltered[i]);
            }
            else {
                let matchbyindex = MatchListAPI.GetMatchByIndex(matchListDescriptor, i);
                _CreateOrValidateMatchTile(MatchIdsFiltered[i]);
            }
        }
        if ((matchListDescriptor === 'live') && elMatchList.FindChildInLayoutFile("live_gotv")) {
            elMatchList.FindChildInLayoutFile("live_gotv").Data().markForDelete = true;
        }
        _ClearList(elMatchList, parentPanel.Data().tournament_id);
        _SelectFirstTile(parentPanel, elMatchList, matchListDescriptor);
        if (nCount > 0) {
            _ShowListPanel(true, parentPanel);
            ShowInfoPanel(true, parentPanel);
            SetListMessage("", false, parentPanel);
        }
        if ((matchListDescriptor === 'live') && (nCount > 0)) {
            _CreateOrValidateMatchTile('gotv');
        }
        parentPanel.Data().matchListIsPopulated = true;
    }
})(matchList || (matchList = {}));
