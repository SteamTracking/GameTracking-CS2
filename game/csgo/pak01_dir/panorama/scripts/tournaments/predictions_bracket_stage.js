"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/popup_major_hub.ts" />
var PredictionsBracket;
(function (PredictionsBracket) {
    let _m_foundTarget = false;
    let _m_aBracketSectionIndexes = [g_ActiveTournamentInfo.num_stages_with_swiss, g_ActiveTournamentInfo.num_stages_with_swiss + 1, g_ActiveTournamentInfo.num_stages_with_swiss + 2];
    let _m_aPickPanels;
    function Init() {
        let oPageData = PopupMajorHub.GetActivePageData();
        if (!oPageData.hasAlreadyInit.includes(oPageData.panel.id)) {
            SetPicksDataOnPanels(oPageData.panel, oPageData.tournamentId);
        }
        _UpdateAllPickSections();
        InitializeMatchLister(oPageData);
    }
    PredictionsBracket.Init = Init;
    function SetPicksDataOnPanels(elPanel, tournamentId) {
        _m_aPickPanels = [];
        let sectionId = PredictionsAPI.GetEventSectionIDByIndex(tournamentId, _m_aBracketSectionIndexes[0]);
        let groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 0);
        let elGroup = elPanel.FindChildInLayoutFile('bracket-section-3-group-0');
        let elTeam = elGroup.FindChildInLayoutFile('team-pick-0');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[0];
        elTeam.Data().pickGroup = 0;
        elTeam.Data().groupId = groupId;
        elTeam.Data().pickId = '0';
        elTeam.Data().validSlotIds = "4,6";
        _m_aPickPanels.push(elTeam);
        groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 1);
        elTeam = elGroup.FindChildInLayoutFile('team-pick-1');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[0];
        elTeam.Data().pickGroup = 1;
        elTeam.Data().groupId = groupId;
        elTeam.Data().pickId = "1";
        elTeam.Data().validSlotIds = "4,6";
        _m_aPickPanels.push(elTeam);
        groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 2);
        elGroup = elPanel.FindChildInLayoutFile('bracket-section-3-group-1');
        elTeam = elGroup.FindChildInLayoutFile('team-pick-0');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[0];
        elTeam.Data().pickGroup = 2;
        elTeam.Data().groupId = groupId;
        elTeam.Data().pickId = '2';
        elTeam.Data().validSlotIds = "5,6";
        _m_aPickPanels.push(elTeam);
        groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 3);
        elTeam = elGroup.FindChildInLayoutFile('team-pick-1');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[0];
        elTeam.Data().pickGroup = 3;
        elTeam.Data().pickId = "3";
        elTeam.Data().groupId = groupId;
        elTeam.Data().validSlotIds = "5,6";
        _m_aPickPanels.push(elTeam);
        sectionId = PredictionsAPI.GetEventSectionIDByIndex(tournamentId, _m_aBracketSectionIndexes[1]);
        groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 0);
        elGroup = elPanel.FindChildInLayoutFile('bracket-section-4-group-0');
        elTeam = elGroup.FindChildInLayoutFile('team-pick-0');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[1];
        elTeam.Data().pickGroup = 0;
        elTeam.Data().groupId = groupId;
        elTeam.Data().pickId = "4";
        elTeam.Data().validSlotIds = "6";
        _m_aPickPanels.push(elTeam);
        groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 1);
        elTeam = elGroup.FindChildInLayoutFile('team-pick-1');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[1];
        elTeam.Data().pickGroup = 1;
        elTeam.Data().groupId = groupId;
        elTeam.Data().pickId = "5";
        elTeam.Data().validSlotIds = "6";
        _m_aPickPanels.push(elTeam);
        sectionId = PredictionsAPI.GetEventSectionIDByIndex(tournamentId, _m_aBracketSectionIndexes[2]);
        groupId = PredictionsAPI.GetSectionGroupIDByIndex(tournamentId, sectionId, 0);
        elGroup = elPanel.FindChildInLayoutFile('bracket-section-5');
        elTeam = elGroup.FindChildInLayoutFile('team-pick-0');
        elTeam.Data().pickSection = _m_aBracketSectionIndexes[2];
        elTeam.Data().pickGroup = 0;
        elTeam.Data().groupId = groupId;
        elTeam.Data().pickId = "6";
        _m_aPickPanels.push(elTeam);
        _m_aPickPanels.forEach(element => {
            _AddDragSourceEvents(element);
            _ItemDragDropEvents(element);
        });
    }
    function _AddDragSourceEvents(elTeam) {
        $.RegisterEventHandler('DragStart', elTeam, (elPanel, drag) => {
            OnDragStart(elTeam, drag);
            _GetValidDropTargets(elTeam.Data().validSlotIds).forEach(panel => panel.SetHasClass('is-dragging', true));
            elTeam.AddClass('dragged-away');
        });
        $.RegisterEventHandler('DragEnd', elTeam, (elRadial, elDragImage) => {
            OnDragEnd(elDragImage);
            _GetValidDropTargets(elTeam.Data().validSlotIds).forEach(panel => panel.SetHasClass('is-dragging', false));
            elTeam.RemoveClass('dragged-away');
        });
    }
    function _ItemDragDropEvents(elTarget) {
        $.RegisterEventHandler('DragEnter', elTarget, () => {
            elTarget.AddClass('bracket-stage-drag-enter');
        });
        $.RegisterEventHandler('DragLeave', elTarget, () => {
            elTarget.RemoveClass('bracket-stage-drag-enter');
        });
        $.RegisterEventHandler('DragDrop', elTarget, (dispayId, elDragImage) => {
            _OnDragDrop(elTarget, elDragImage);
        });
    }
    function OnDragStart(elDragSource, drag) {
        let elDragImage = $.CreatePanel('ItemImage', $.GetContextPanel(), '', {
            class: 'group-stage-drag-icon',
            textureheight: '48',
            texturewidth: '48'
        });
        elDragImage.SetImage(PopupMajorHub.GetTeamIcon(elDragSource.Data().teamId));
        elDragImage.AddClass('start-drag');
        elDragImage.Data().teamId = elDragSource.Data().teamId;
        elDragImage.Data().pickId = elDragSource.Data().pickId;
        elDragImage.Data().validSlotIds = elDragSource.Data().validSlotIds;
        PopupMajorHub.m_elDragImage = elDragImage;
        drag.displayPanel = elDragImage;
        drag.offsetX = 32;
        drag.offsetY = 32;
        drag.removePositionBeforeDrop = false;
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_pickup', 'MOUSE');
    }
    function OnDragEnd(elDragImage) {
        if (!_m_foundTarget) {
            let aValidTargets = _GetValidDropTargets(elDragImage.Data().validSlotIds + ',' + elDragImage.Data().pickId);
            aValidTargets.forEach(target => {
                if (parseInt(target.Data().pickId) >= parseInt(elDragImage.Data().pickId)) {
                    _UpdateDropTarget(target, null);
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_notequipped', 'MOUSE');
                }
            });
        }
        elDragImage.AddClass('drag-end');
        PopupMajorHub.DeleteDragItem();
        _m_foundTarget = false;
    }
    function _OnDragDrop(elTarget, elDragImage) {
        _m_foundTarget = true;
        let teamIdRemoved = elTarget.Data().teamId;
        let aValidTargets = _GetValidDropTargets(elDragImage.Data().validSlotIds);
        aValidTargets.forEach(target => {
            if (parseInt(target.Data().pickId) <= parseInt(elTarget.Data().pickId)) {
                _UpdateDropTarget(target, elDragImage.Data().teamId);
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_putdown', 'MOUSE');
            }
            else {
                if (target.Data().teamId === teamIdRemoved &&
                    elTarget.Data().teamId !== target.Data().teamId) {
                    teamIdRemoved = target.Data().teamId;
                    _UpdateDropTarget(target, null);
                }
            }
        });
    }
    function _UpdateDropTarget(elTarget, teamId) {
        if (elTarget && elTarget.IsValid()) {
            let oPageData = PopupMajorHub.GetActivePageData();
            let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
            let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, oPageData.groupId);
            elTarget.SetDraggable((isActiveSection && canPick));
            elTarget.Data().teamId = teamId;
            if (teamId === null || !isActiveSection || !canPick) {
                elTarget.SwitchClass('team-state', 'team-locked');
            }
            else {
                elTarget.SwitchClass('team-state', '');
            }
            UpdatePick(oPageData, elTarget, teamId === null ? 0 : teamId);
        }
    }
    function _GetValidDropTargets(validSlotIds) {
        let aValidSlots;
        aValidSlots = [];
        if (validSlotIds) {
            validSlotIds.split(',').forEach(id => _m_aPickPanels.forEach(panel => {
                if (panel.Data().pickId === id) {
                    aValidSlots.push(panel);
                }
            }));
        }
        return aValidSlots;
    }
    function _UpdateAllPickSections() {
        let oPageData = PopupMajorHub.GetActivePageData();
        for (var i = 0; i < _m_aBracketSectionIndexes.length; i++) {
            if (i == 0) {
                _SetUpStartTeams(oPageData);
            }
            _UpdateAllPicksForSection(oPageData, _m_aBracketSectionIndexes[i]);
        }
    }
    ;
    function UpdateFromPredictionUploadedEvent() {
        _UpdateAllPickSections();
    }
    PredictionsBracket.UpdateFromPredictionUploadedEvent = UpdateFromPredictionUploadedEvent;
    function _SetUpStartTeams(oPageData) {
        let sectionId = PredictionsAPI.GetEventSectionIDByIndex(oPageData.tournamentId, _m_aBracketSectionIndexes[0]);
        let nGroupCount = PredictionsAPI.GetSectionGroupsCount(oPageData.tournamentId, sectionId);
        let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, sectionId);
        for (let i = 0; i < nGroupCount; ++i) {
            let groupId = PredictionsAPI.GetSectionGroupIDByIndex(oPageData.tournamentId, sectionId, i);
            let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, groupId);
            let elGroup = oPageData.panel.FindChildInLayoutFile('bracket-section-' + 2 + '-group-' + i);
            let sValidSlotIds = elGroup.GetAttributeString('data-valid-slots', '');
            let nTeamCount = PredictionsAPI.GetGroupTeamsCount(oPageData.tournamentId, groupId);
            for (var j = 0; j < nTeamCount; j++) {
                let teamId = PredictionsAPI.GetGroupTeamIDByIndex(oPageData.tournamentId, groupId, j);
                let elTeam = elGroup.FindChildInLayoutFile('team-pick-' + j);
                elTeam.Data().validSlotIds = sValidSlotIds;
                elTeam.Data().teamId = teamId;
                SetTeamName(elTeam, teamId, true);
                elTeam.FindChild('id-team-logo').SetImage(!elTeam || teamId === 0 ?
                    '' :
                    PopupMajorHub.GetTeamIcon(teamId));
                if (!oPageData.hasAlreadyInit.includes(oPageData.panel.id)) {
                    _AddDragSourceEvents(elTeam);
                }
                elTeam.SwitchClass('team-state', 'not-active');
                elTeam.SetDraggable((isActiveSection && canPick));
                elTeam.hittest = (isActiveSection && canPick);
                elTeam.hittestchildren = (isActiveSection && canPick);
            }
        }
    }
    function _UpdateAllPicksForSection(oPageData, sectionIndex) {
        let aPicksInSection = _m_aPickPanels.filter(element => element.Data().pickSection === sectionIndex);
        aPicksInSection.forEach(element => {
            UpdatePick(oPageData, element, 0, true);
        });
    }
    function UpdatePick(oPageData, elTeam, teamId = 0, bUsePrediction = false) {
        let secId = PredictionsAPI.GetEventSectionIDByIndex(oPageData.tournamentId, elTeam.Data().pickSection);
        let groupId = PredictionsAPI.GetSectionGroupIDByIndex(oPageData.tournamentId, secId, elTeam.Data().pickGroup);
        let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
        let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, groupId);
        teamId = (teamId === 0 && bUsePrediction) ? PredictionsAPI.GetMyPredictionTeamID(oPageData.tournamentId, groupId, 0) : teamId;
        elTeam.Data().teamId = teamId;
        SetTeamName(elTeam, teamId);
        elTeam.FindChild('id-team-logo').SetImage(!elTeam || teamId === 0 ?
            '' :
            PopupMajorHub.GetTeamIcon(teamId));
        let sCorrectPicks = PredictionsAPI.GetGroupCorrectPicksByIndex(oPageData.tournamentId, groupId, 0);
        if (PopupMajorHub.CheckIfPickIsCorrect(sCorrectPicks, teamId) && teamId) {
            elTeam.SwitchClass('team-state', 'is-correct');
        }
        else if (teamId && !isActiveSection) {
            elTeam.SwitchClass('team-state', 'is-incorrect');
        }
        else {
            elTeam.SwitchClass('team-state', '');
        }
        elTeam.SetDraggable((isActiveSection && canPick));
        elTeam.hittest = (isActiveSection && canPick);
        elTeam.hittestchildren = (isActiveSection && canPick);
        SavePicksButton.UpdateBtn(_GetLocalSetPicks());
    }
    function SetTeamName(elTeam, teamId, bisStartTeam = false) {
        elTeam.SetDialogVariable('team-name', teamId === 0 && elTeam.BHasClass('bracket-team-pick') && !bisStartTeam ?
            $.Localize('#CSGO_Fantasy_Team_Action') :
            teamId === 0 ?
                $.Localize('#CSGO_PickEm_Team_TBD') :
                PredictionsAPI.GetTeamName(teamId));
    }
    function _GetLocalSetPicks() {
        let aPicks = [];
        _m_aPickPanels.forEach(pick => {
            if (pick.Data().teamId && pick.Data().teamId !== 0) {
                aPicks.push({ teamId: pick.Data().teamId, group: pick.Data().groupId, groupIndex: 0 });
            }
        });
        return aPicks;
    }
    ;
    let _m_elSections = {};
    function _GetMatchlisterMatchupsIdForWinCount(numWs) {
        return 'bracket-section-' + (2 + numWs);
    }
    function _SetTeamDataIntoPanel(elPanel, idx, teamtag, teamname, score, bIsCorrectPickemPick, extraClass = '') {
        if (!elPanel)
            return;
        elPanel = elPanel.FindChildInLayoutFile('team-result-' + idx);
        if (!elPanel)
            return;
        elPanel.SetDialogVariable('team-name', teamname);
        elPanel.SetDialogVariable('team-score', (score < 0) ? '' : ('' + score));
        if (extraClass)
            elPanel.AddClass(extraClass);
        elPanel.FindChildInLayoutFile('id-team-logo').SetImage("file://{images}/tournaments/teams/" + teamtag + ".svg");
        if (bIsCorrectPickemPick)
            elPanel.AddClass('is-correct');
    }
    function InitializeMatchLister(oPageData) {
        if (MatchListAPI.GetState(oPageData.tournamentId) !== 'ready')
            return;
        for (let numWs = 0; numWs <= 3; ++numWs) {
            let strMatchups = _GetMatchlisterMatchupsIdForWinCount(numWs);
            let elMatchups = oPageData.panel.FindChildInLayoutFile(strMatchups);
            if (!elMatchups)
                continue;
            let arrTeamPairs = [];
            for (let iMatch = 0;; ++iMatch) {
                let elTeamPair = elMatchups.FindChildInLayoutFile(strMatchups + '-group-' + iMatch);
                if (!elTeamPair)
                    break;
                arrTeamPairs.push({ panel: elTeamPair, keyteamwl: 0, keyteam_wins: 0, keyteam_loss: 0 });
                elTeamPair.SetHasClass('has_valid_matchup', false);
                elTeamPair.SetHasClass('has_match_in_progress', false);
                elTeamPair.SetHasClass('is_winner', false);
                elTeamPair.SetHasClass('is_loser', false);
                [elTeamPair.FindChildInLayoutFile('team-result-0'),
                    elTeamPair.FindChildInLayoutFile('team-result-1')].forEach(elTeam => {
                    if (elTeam) {
                        elTeam.SetDialogVariable('team-name', $.Localize('#CSGO_PickEm_Team_TBD'));
                        elTeam.SetDialogVariable('team-score', '');
                        elTeam.FindChildInLayoutFile('id-team-logo').SetImage(oPageData.tournamentId == "tournament:24" ? "file://{images}/tournaments/unknown_team_dark.svg" : "file://{images}/tournaments/unknown_team.svg");
                        elTeam.RemoveClass('is-correct');
                    }
                });
                elTeamPair.Data().umids = [];
                if (numWs < 3)
                    elTeamPair.SetPanelEvent('onactivate', () => {
                        let sUmids = (elTeamPair.Data().umids.length > 0) ? elTeamPair.Data().umids.join(',') : '';
                        if (!sUmids)
                            return;
                        var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_get_souvenir.xml', 'umids=' + sUmids +
                            '&' + 'tournamentId=' + PopupMajorHub.GetActivePageData().eventId);
                        contextMenuPanel.AddClass("ContextMenu_NoArrow");
                    });
            }
            _m_elSections[strMatchups] = { matches: arrTeamPairs };
        }
        let teamStates = {};
        function GetTeamState(teamid) {
            if (!teamStates.hasOwnProperty(teamid)) {
                teamStates[teamid] = {
                    wins: 0,
                    loss: 0,
                    boXw: 0,
                    boXl: 0
                };
            }
            return teamStates[teamid];
        }
        function AddWin(state, winsNeeded) {
            ++state.boXw;
            if (state.boXw >= winsNeeded) {
                state.boXw = state.boXl = 0;
                ++state.wins;
            }
        }
        function AddLoss(state, winsNeeded) {
            ++state.boXl;
            if (state.boXl >= winsNeeded) {
                state.boXl = state.boXw = 0;
                ++state.loss;
            }
        }
        for (let idxGroup = 0; idxGroup < 4; ++idxGroup) {
            let nTeams = PredictionsAPI.GetGroupTeamsCount(oPageData.tournamentId, oPageData.groupId + idxGroup);
            for (let i = 0; i < nTeams; ++i) {
                let teamId = PredictionsAPI.GetGroupTeamIDByIndex(oPageData.tournamentId, oPageData.groupId + idxGroup, i);
                if (teamId !== 0 && teamId && !PredictionsAPI.GetFakeItemIDToRepresentTeamID(oPageData.tournamentId, teamId))
                    teamId = 0;
                if (!teamId)
                    continue;
                let teamtag = PredictionsAPI.GetTeamTag(teamId);
                let idxMatchup = idxGroup;
                let idxSlotInMatch = i;
                _SetTeamDataIntoPanel(_m_elSections[_GetMatchlisterMatchupsIdForWinCount(0)].matches[idxGroup].panel, idxSlotInMatch, teamtag, PredictionsAPI.GetTeamName(teamId), -1, false);
                for (let numWs = 0; numWs <= 3; ++numWs) {
                    let matchup = _GetMatchlisterMatchupsIdForWinCount(numWs);
                    _m_elSections[matchup][teamtag] = idxMatchup;
                    _m_elSections[matchup]['slot:' + teamtag] = idxSlotInMatch;
                    idxSlotInMatch = idxMatchup % 2;
                    idxMatchup = (idxMatchup - (idxMatchup % 2)) / 2;
                }
            }
        }
        for (let idxSection = 0; idxSection <= 2; ++idxSection) {
            let nCount = PredictionsAPI.GetSectionMatchesCount(oPageData.tournamentId, oPageData.sectionId + idxSection);
            for (let idxMatch = nCount; idxMatch-- > 0;) {
                let umid = PredictionsAPI.GetSectionMatchByIndex(oPageData.tournamentId, oPageData.sectionId + idxSection, idxMatch);
                let team0 = MatchInfoAPI.GetMatchTournamentTeamTag(umid, 0);
                let team1 = MatchInfoAPI.GetMatchTournamentTeamTag(umid, 1);
                let team0name = MatchInfoAPI.GetMatchTournamentTeamName(umid, 0);
                let team1name = MatchInfoAPI.GetMatchTournamentTeamName(umid, 1);
                let res = MatchInfoAPI.GetMatchOutcome(umid);
                let bMatchStillInProgress = (!res || res <= 0);
                let matchup = _GetMatchlisterMatchupsIdForWinCount(GetTeamState(team0).wins);
                if (!_m_elSections[matchup].hasOwnProperty(team0) || !_m_elSections[matchup].hasOwnProperty(team1))
                    continue;
                let winteam = ((res == 2) ? team1 : team0);
                let keyteam = (_m_elSections[matchup]['slot:' + team0] === 0) ? team0 : team1;
                let steam = GetTeamState(keyteam);
                const nStageID = MatchInfoAPI.GetMatchTournamentStageID(umid);
                const numWinsNeeded = MatchInfoAPI.GetMatchTournamentStageIDWinsNeeded(nStageID);
                if (_m_elSections[matchup][keyteam] < _m_elSections[matchup].matches.length) {
                    let omatch = _m_elSections[matchup].matches[_m_elSections[matchup][keyteam]];
                    let elTeamPair = omatch.panel;
                    let nCountThisMatchForBO3 = bMatchStillInProgress ? 0 : 1;
                    omatch.keyteamwl += ((winteam == keyteam) ? 1 : -1) * nCountThisMatchForBO3;
                    omatch.keyteam_wins += ((winteam == keyteam) ? 1 : 0) * nCountThisMatchForBO3;
                    omatch.keyteam_loss += ((winteam != keyteam) ? 1 : 0) * nCountThisMatchForBO3;
                    let bSwap01 = ((team0 == keyteam) ? false : true);
                    let nLeftScore = omatch.keyteam_wins;
                    let nRightScore = omatch.keyteam_loss;
                    elTeamPair.SetHasClass('has_valid_matchup', true);
                    elTeamPair.SetHasClass('has_match_in_progress', bMatchStillInProgress);
                    _SetTeamDataIntoPanel(elTeamPair, 0, (bSwap01 ? team1 : team0), (bSwap01 ? team1name : team0name), nLeftScore, false, (nLeftScore == numWinsNeeded || nRightScore == numWinsNeeded) ? (nLeftScore == numWinsNeeded ? 'is_winner' : 'is_loser') : '');
                    _SetTeamDataIntoPanel(elTeamPair, 1, (bSwap01 ? team0 : team1), (bSwap01 ? team0name : team1name), nRightScore, false, (nLeftScore == numWinsNeeded || nRightScore == numWinsNeeded) ? (nRightScore == numWinsNeeded ? 'is_winner' : 'is_loser') : '');
                    elTeamPair.Data().umids.push(umid);
                    if (bMatchStillInProgress)
                        elTeamPair.Data().umids = [];
                    if (nLeftScore == numWinsNeeded || nRightScore == numWinsNeeded) {
                        let matchOffset = _m_elSections[matchup][keyteam];
                        let groupOffset = ((idxSection == 2) ? 6 : (idxSection * 4)) + matchOffset;
                        let teamidPicked = PredictionsAPI.GetMyPredictionTeamID(oPageData.tournamentId, oPageData.groupId + groupOffset, 0);
                        let teamTagPicked = PredictionsAPI.GetTeamTag(teamidPicked);
                        let nextmatchup = _GetMatchlisterMatchupsIdForWinCount(steam.wins + 1);
                        let elMatch = _m_elSections[nextmatchup].matches[(matchOffset - (matchOffset % 2)) / 2];
                        _SetTeamDataIntoPanel(elMatch.panel, matchOffset % 2, winteam, (winteam === team0) ? team0name : team1name, -1, teamTagPicked === winteam);
                    }
                }
                if (!bMatchStillInProgress) {
                    AddWin(GetTeamState(winteam), numWinsNeeded);
                    AddLoss(GetTeamState((team0 == winteam) ? team1 : team0), numWinsNeeded);
                }
            }
        }
    }
})(PredictionsBracket || (PredictionsBracket = {}));
