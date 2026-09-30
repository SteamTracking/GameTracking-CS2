"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/popup_major_hub.ts" />
var PredictionsGroup;
(function (PredictionsGroup) {
    let _m_foundTarget = false;
    const _m_targetNamePrefix = "id-pickem-pick-";
    function Init() {
        let oPageData = PopupMajorHub.GetActivePageData();
        if (!oPageData.hasAlreadyInit.includes(oPageData.panel.id)) {
            _UpdateDragTargets(oPageData);
            _UpdateDragSourceTeams(oPageData);
            _SetUpExtraPickBtns(oPageData);
        }
        InitializeMatchLister(oPageData);
    }
    PredictionsGroup.Init = Init;
    function UpdateFromPredictionUploadedEvent() {
        let oPageData = PopupMajorHub.GetActivePageData();
        _UpdateDragTargets(oPageData);
        _UpdateDragSourceTeams(oPageData);
        _SetUpExtraPickBtns(oPageData);
    }
    PredictionsGroup.UpdateFromPredictionUploadedEvent = UpdateFromPredictionUploadedEvent;
    function _SetUpExtraPickBtns(oPageData) {
        let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
        let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, oPageData.groupId);
        let elRandomBtn = oPageData.panel.FindChildInLayoutFile('id-fill-random');
        let elClearBtn = oPageData.panel.FindChildInLayoutFile('id-clear-all-picks');
        elRandomBtn.visible = isActiveSection && canPick;
        elClearBtn.visible = isActiveSection && canPick;
        if (isActiveSection && !oPageData.hasAlreadyInit.includes(oPageData.panel.id)) {
            elRandomBtn.SetPanelEvent('onactivate', () => {
                _UpdateDragSourceTeams(oPageData);
                _FillOutPicksRandom();
                elRandomBtn.enabled = false;
            });
            elRandomBtn.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip('id-fill-random', '#pickem_teams_fill_tooltip');
            });
            elRandomBtn.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideTextTooltip();
            });
            elClearBtn.SetPanelEvent('onactivate', () => {
                _UpdateDragTargets(oPageData, true);
                _UpdateDragSourceTeams(oPageData);
            });
            elClearBtn.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip('id-fill-random', '#pickem_teams_remove_all_tooltip');
            });
            elClearBtn.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideTextTooltip();
            });
        }
    }
    function _UpdateDragSourceTeams(oPageData) {
        let nTeams = PredictionsAPI.GetGroupTeamsCount(oPageData.tournamentId, oPageData.groupId);
        let nActualTeams = 0;
        let aLocalPicks = _GetLocalSetPicks(oPageData);
        let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
        let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, oPageData.groupId);
        let elParent = oPageData.panel.FindChildInLayoutFile('id-predictions-draggable-teams');
        const sourceNamePrefix = 'id-group' + oPageData.groupId + '-team-';
        elParent.GetParent().FindChildInLayoutFile('id-no-teams').visible = (!(nTeams > 0) || !isActiveSection) && canPick;
        elParent.GetParent().FindChildInLayoutFile('id-drag-teams').visible = (nTeams > 0 && isActiveSection);
        for (let i = 0; i < nTeams; ++i) {
            let teamId = PredictionsAPI.GetGroupTeamIDByIndex(oPageData.tournamentId, oPageData.groupId, i);
            if (teamId !== 0 && teamId && !PredictionsAPI.GetFakeItemIDToRepresentTeamID(oPageData.tournamentId, teamId))
                teamId = 0;
            let elTeam = oPageData.panel.FindChildInLayoutFile(sourceNamePrefix + teamId);
            if (teamId !== 0 && teamId) {
                if (!elTeam) {
                    elTeam = $.CreatePanel("Panel", elParent, sourceNamePrefix + teamId);
                    elTeam.BLoadLayoutSnippet("team-draggable");
                    elTeam.Data().teamId = teamId;
                    elTeam.Data().isSource = true;
                    if (isActiveSection && !oPageData.hasAlreadyInit.includes(oPageData.panel.id)) {
                        _AddDragSourceEvents(elTeam);
                        _ShowHideTeamTooltip(elTeam);
                    }
                }
                _SetSourceDragTeamImage(elTeam, teamId);
                let isLocalPick = aLocalPicks.find(p => p.teamId == teamId);
                if (isLocalPick) {
                    elTeam.SwitchClass('team-state', 'already-picked');
                }
                else if (!isActiveSection || !canPick) {
                    elTeam.SwitchClass('team-state', 'team-locked');
                }
                else {
                    elTeam.SwitchClass('team-state', '');
                }
                elTeam.hittest = !isLocalPick;
                elTeam.hittestchildren = !isLocalPick;
                elTeam.SetDraggable((isActiveSection && canPick) && !isLocalPick);
                ++nActualTeams;
            }
        }
        SavePicksButton.UpdateBtn(aLocalPicks);
        if (isActiveSection) {
            let groupPickCount = PredictionsAPI.GetGroupPicksCount(oPageData.tournamentId, oPageData.groupId);
            oPageData.panel.FindChildInLayoutFile('id-fill-random').enabled =
                nActualTeams > 0 &&
                    (aLocalPicks.length < groupPickCount) &&
                    (nActualTeams >= groupPickCount);
            oPageData.panel.FindChildInLayoutFile('id-clear-all-picks').enabled =
                aLocalPicks.length > 0;
        }
        _FillWithEmptyTeams(elParent, nActualTeams);
    }
    function _ShowHideTeamTooltip(elPanel, tooltipLocIdOverride = '') {
        elPanel.SetPanelEvent('onmouseover', () => {
            if (!elPanel.Data().teamId)
                return;
            let oPageData = PopupMajorHub.GetActivePageData();
            if (oPageData && oPageData.panel) {
                if (oPageData.panel.BHasClass('show-all-correct-picks'))
                    return;
            }
            UiToolkitAPI.ShowTextTooltip(tooltipLocIdOverride ?
                tooltipLocIdOverride :
                elPanel.id, PredictionsAPI.GetTeamName(elPanel.Data().teamId));
        });
        elPanel.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
    }
    function _FillWithEmptyTeams(elParent, nTeams) {
        let nTeamsPossible = 16;
        let nEmptyteams = nTeamsPossible - nTeams;
        for (let i = 0; i < elParent.Children().length; ++i) {
            if (elParent.Children()[i] && elParent.Children()[i].id === 'empty-team') {
                elParent.Children()[i].DeleteAsync(0);
            }
        }
        if (nEmptyteams > 0) {
            for (let i = 0; i < nEmptyteams; ++i) {
                let elTeam = $.CreatePanel("Panel", elParent, 'empty-team');
                elTeam.BLoadLayoutSnippet("team-draggable");
                elTeam.SwitchClass('team-state', 'empty-team');
                elTeam.hittest = false;
                elTeam.hittestchildren = false;
            }
        }
    }
    function _AddDragSourceEvents(elTeam) {
        $.RegisterEventHandler('DragStart', elTeam, (elPanel, drag) => {
            OnDragStart(elTeam, drag);
            PopupMajorHub.GetActivePageData().panel.SetHasClass('is-dragging', true);
            elTeam.AddClass('dragged-away');
        });
        $.RegisterEventHandler('DragEnd', elTeam, (elRadial, elDragImage) => {
            OnDragEnd(elDragImage);
            PopupMajorHub.GetActivePageData().panel.SetHasClass('is-dragging', false);
            elTeam.RemoveClass('dragged-away');
        });
    }
    function _SetSourceDragTeamImage(elTeam, teamId) {
        let elLogoImage = elTeam.FindChildInLayoutFile('id-team-logo');
        if (!teamId) {
            elLogoImage.SetImage('');
            return;
        }
        elLogoImage.SetImage(PopupMajorHub.GetTeamIcon(teamId));
    }
    function _GetLocalSetPicks(oPageData, bAllowEmptySlots = false) {
        let nCount = PredictionsAPI.GetGroupPicksCount(oPageData.tournamentId, oPageData.groupId);
        let aPicks = [];
        for (let i = 0; i < nCount; ++i) {
            let elTarget = oPageData.panel.FindChildInLayoutFile(_m_targetNamePrefix + i);
            if (bAllowEmptySlots) {
                aPicks.push({ teamId: elTarget.Data().teamId, group: oPageData.groupId, groupIndex: i });
            }
            else if (elTarget.Data().teamId) {
                aPicks.push({ teamId: elTarget.Data().teamId, group: oPageData.groupId, groupIndex: i });
            }
        }
        return aPicks;
    }
    function _GetLocalPickPanel(teamId) {
        let oPageData = PopupMajorHub.GetActivePageData();
        let nCount = PredictionsAPI.GetGroupPicksCount(oPageData.tournamentId, oPageData.groupId);
        for (let i = 0; i < nCount; ++i) {
            let elTarget = oPageData.panel.FindChildInLayoutFile(_m_targetNamePrefix + i);
            if (elTarget.Data().teamId === teamId) {
                return elTarget;
            }
        }
        return null;
    }
    function OnDragStart(elDragSource, drag) {
        PopupMajorHub.DeleteDragItem();
        let elDragImage = $.CreatePanel('ItemImage', $.GetContextPanel(), '', {
            class: 'group-stage-drag-icon',
            textureheight: '48',
            texturewidth: '48'
        });
        elDragImage.SetImage(PopupMajorHub.GetTeamIcon(elDragSource.Data().teamId));
        elDragImage.AddClass('start-drag');
        elDragImage.Data().teamId = elDragSource.Data().teamId;
        elDragImage.Data().isSource = elDragSource.Data().isSource ? elDragSource.Data().isSource : false;
        PopupMajorHub.m_elDragImage = elDragImage;
        drag.displayPanel = elDragImage;
        drag.offsetX = 32;
        drag.offsetY = 32;
        drag.removePositionBeforeDrop = false;
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_pickup', 'MOUSE');
        UiToolkitAPI.HideTextTooltip();
        elDragImage.SetPanelEvent('onmouseout', () => { PopupMajorHub.DeleteDragItem(); });
    }
    function OnDragEnd(elDragImage) {
        elDragImage.AddClass('drag-end');
        PopupMajorHub.DeleteDragItem();
        if (!_m_foundTarget && !elDragImage.Data().isSource) {
            let elOldTarget = _GetLocalPickPanel(elDragImage.Data().teamId);
            _UpdateDropTarget(elOldTarget, null);
            _UpdateDragSourceTeams(PopupMajorHub.GetActivePageData());
        }
        _m_foundTarget = false;
    }
    function _UpdateDragTargets(oPageData, bForceClear = false) {
        let nCount = PredictionsAPI.GetGroupPicksCount(oPageData.tournamentId, oPageData.groupId);
        let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
        for (let i = 0; i < nCount; ++i) {
            let elTarget = oPageData.panel.FindChildInLayoutFile(_m_targetNamePrefix + i);
            _MakeUniqueTooltipLocator(elTarget, oPageData.groupId, i);
            if (bForceClear) {
                _UpdateDropTarget(elTarget, null);
                elTarget.SwitchClass('correct-state', 'not-active');
            }
            else {
                let savedTeamId = PredictionsAPI.GetMyPredictionTeamID(oPageData.tournamentId, oPageData.groupId, i);
                let LocalTeamId = elTarget.Data().teamId;
                _UpdateDropTarget(elTarget, (savedTeamId ? savedTeamId : LocalTeamId ? LocalTeamId : null));
                if (isActiveSection && !oPageData.hasAlreadyInit.includes(oPageData.panel.id)) {
                    _ItemDragTargetEvents(elTarget);
                    _AddDragSourceEvents(elTarget.FindChildInLayoutFile('id-team-panel'));
                }
                else {
                    let sCorrectPicks = PredictionsAPI.GetGroupCorrectPicksByIndex(oPageData.tournamentId, oPageData.groupId, i);
                    if (PopupMajorHub.CheckIfPickIsCorrect(sCorrectPicks, savedTeamId) && savedTeamId) {
                        elTarget.SwitchClass('correct-state', 'is-correct');
                    }
                    else if (savedTeamId && !isActiveSection) {
                        elTarget.SwitchClass('correct-state', 'is-incorrect');
                    }
                    else {
                        elTarget.SwitchClass('correct-state', 'not-active');
                    }
                }
            }
        }
        if (bForceClear) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_notequipped', 'MOUSE');
        }
    }
    function _MakeUniqueTooltipLocator(elTarget, groupId, index) {
        let tooltipLocId = 'id-target-tooltip-loc-' + groupId + '-' + index;
        let tooltipLoc = elTarget.FindChild(tooltipLocId);
        let tooltipLocClass = (index === 5 || index === 6 || index === 7) ? 'group-stage-drop-target__tooltip-loc bottom' : 'group-stage-drop-target__tooltip-loc';
        if (!tooltipLoc) {
            tooltipLoc = $.CreatePanel('Panel', elTarget, tooltipLocId, { class: tooltipLocClass });
            elTarget.Data().tooltipLocId = tooltipLocId;
        }
    }
    function _ItemDragTargetEvents(elTarget) {
        $.RegisterEventHandler('DragEnter', elTarget, () => {
            elTarget.AddClass('group-stage-drag-enter');
        });
        $.RegisterEventHandler('DragLeave', elTarget, () => {
            elTarget.RemoveClass('group-stage-drag-enter');
        });
        $.RegisterEventHandler('DragDrop', elTarget, (dispayId, elDragImage) => {
            _OnDragDrop(elTarget, elDragImage);
        });
    }
    function _OnDragDrop(elTarget, elDragImage) {
        if (elDragImage.Data().teamId !== elTarget.Data().teamId) {
            let elOldTarget = _GetLocalPickPanel(elDragImage.Data().teamId);
            if (elTarget.Data().teamId) {
                _UpdateDropTarget(elOldTarget, elTarget.Data().teamId);
            }
            else {
                _UpdateDropTarget(elOldTarget, null);
            }
        }
        _UpdateDropTarget(elTarget, elDragImage.Data().teamId);
        _UpdateDragSourceTeams(PopupMajorHub.GetActivePageData());
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_putdown', 'MOUSE');
        _m_foundTarget = true;
    }
    function _UpdateDropTarget(elTarget, teamId) {
        if (elTarget && elTarget.IsValid()) {
            let oPageData = PopupMajorHub.GetActivePageData();
            let isActiveSection = PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
            let canPick = PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, oPageData.groupId);
            elTarget.SetDraggable((isActiveSection && canPick));
            elTarget.Data().teamId = teamId;
            elTarget.SetHasClass('has-pick', teamId !== null ? true : false);
            elTarget.SetHasClass('not-active', teamId !== null);
            if (teamId === null || !isActiveSection || !canPick) {
                elTarget.FindChildInLayoutFile('id-team-panel').SwitchClass('team-state', 'team-locked');
            }
            else {
                elTarget.FindChildInLayoutFile('id-team-panel').SwitchClass('team-state', '');
            }
            elTarget.FindChildInLayoutFile('id-team-panel').Data().teamId = teamId;
            elTarget.FindChildInLayoutFile('id-team-panel').SetDraggable((isActiveSection && canPick) && teamId !== null);
            _SetSourceDragTeamImage(elTarget, teamId);
            _ShowHideTeamTooltip(elTarget, elTarget.Data().tooltipLocId);
        }
    }
    function _FillOutPicksRandom() {
        let oPageData = PopupMajorHub.GetActivePageData();
        let aLocalPicks = _GetLocalSetPicks(oPageData, true);
        let aTeams = [];
        let nTeams = PredictionsAPI.GetGroupTeamsCount(oPageData.tournamentId, oPageData.groupId);
        for (let i = 0; i < nTeams; ++i) {
            aTeams.push(PredictionsAPI.GetGroupTeamIDByIndex(oPageData.tournamentId, oPageData.groupId, i));
            aTeams = aTeams.filter(value => value !== 0);
        }
        if (aTeams.length === 0) {
            return;
        }
        let aUnpickedTeams = aTeams.filter((value, index) => !aLocalPicks.find(p => p.teamId == value));
        let top = aUnpickedTeams.length;
        while (--top) {
            var current = Math.floor(Math.random() * (top + 1));
            var tmp = aUnpickedTeams[current];
            aUnpickedTeams[current] = aUnpickedTeams[top];
            aUnpickedTeams[top] = tmp;
        }
        let aEmptySlotsToFill = [];
        aLocalPicks.forEach((pick, index) => {
            if (!pick.teamId && index < aTeams.length) {
                aEmptySlotsToFill.push(index);
            }
        });
        let nDelay = 0;
        aEmptySlotsToFill.forEach((value, index) => {
            let elTarget = oPageData.panel.FindChildInLayoutFile(_m_targetNamePrefix + value);
            $.Schedule(nDelay, () => {
                _UpdateDropTarget(elTarget, aUnpickedTeams[index]);
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_item_putdown', 'MOUSE');
            });
            nDelay = nDelay + .04;
        });
        $.Schedule(nDelay, () => { _UpdateDragSourceTeams(oPageData); });
    }
    let _m_elSections = {};
    let _m_elPlacements = {};
    function InitializeMatchLister(oPageData) {
        if (MatchListAPI.GetState(oPageData.tournamentId) !== 'ready')
            return;
        for (let numWs = 0; numWs <= 2; ++numWs) {
            for (let numLs = 0; numLs <= 2; ++numLs) {
                let strMatchups = 'matchups-' + numWs + '-' + numLs;
                let elMatchups = oPageData.panel.FindChildInLayoutFile(strMatchups);
                if (!elMatchups)
                    continue;
                elMatchups.FindChildInLayoutFile('matchup-score').text = $.Localize('#pickem_swiss_group_' + numWs + numLs);
                let arrTeamPairs = [];
                for (let iMatch = 0;; ++iMatch) {
                    let elTeamPair = elMatchups.FindChildInLayoutFile('match-idx-' + iMatch);
                    if (!elTeamPair)
                        break;
                    arrTeamPairs.push({ panel: elTeamPair, keyteamwl: 0, keyteam_wins: 0, keyteam_loss: 0 });
                    elTeamPair.SetHasClass('has_valid_matchup', false);
                    elTeamPair.SetHasClass('has_match_in_progress', false);
                    elTeamPair.FindChildInLayoutFile('id-team-matchup-logo-0').SetImage(oPageData.tournamentId == "tournament:24" ? "file://{images}/tournaments/unknown_team_dark.svg" : "file://{images}/tournaments/unknown_team.svg");
                    elTeamPair.FindChildInLayoutFile('id-team-matchup-logo-1').SetImage(oPageData.tournamentId == "tournament:24" ? "file://{images}/tournaments/unknown_team_dark.svg" : "file://{images}/tournaments/unknown_team.svg");
                    elTeamPair.Data().umids = [];
                    elTeamPair.SetPanelEvent('onactivate', () => {
                        let sUmids = (elTeamPair.Data().umids.length > 0) ? elTeamPair.Data().umids.join(',') : '';
                        var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_get_souvenir.xml', 'umids=' + sUmids +
                            '&' + 'tournamentId=' + PopupMajorHub.GetActivePageData().eventId);
                        contextMenuPanel.AddClass("ContextMenu_NoArrow");
                    });
                }
                _m_elSections[strMatchups] = { matches: arrTeamPairs, results: 0 };
            }
        }
        for (let numWs = 0; numWs <= 3; ++numWs) {
            for (let numLs = 0; numLs <= 3; ++numLs) {
                if (numWs != 3 && numLs != 3)
                    continue;
                let strID = 'placement-' + numWs + '-' + numLs;
                let elContainer = oPageData.panel.FindChildInLayoutFile(strID);
                if (!elContainer)
                    continue;
                let arrSlots = [];
                elContainer.Children().forEach(el => {
                    if (el.BHasClass('placeholder-team-icon'))
                        return;
                    if (el.GetChildCount() == 0) {
                        arrSlots.push(el);
                    }
                    else {
                        el.RemoveClass('actual-result-green-check');
                        arrSlots.push(el.FindChildInLayoutFile('placement-team-icon'));
                    }
                });
                arrSlots.forEach(el => {
                    el.SetImage(oPageData.tournamentId == "tournament:24" ? "file://{images}/tournaments/unknown_team_dark.svg" : "file://{images}/tournaments/unknown_team.svg");
                });
                _m_elPlacements[strID] = { slots: arrSlots, results: 0 };
            }
        }
        let numBestOf1Rounds = ((g_ActiveTournamentInfo.eventid >= 26)
            && (oPageData.sectionIndex >= g_ActiveTournamentInfo.num_stages_with_swiss - 1))
            ? 0 : 2;
        let teamStates = {};
        function GetTeamState(teamid) {
            if (!teamStates.hasOwnProperty(teamid)) {
                teamStates[teamid] = {
                    wins: 0,
                    loss: 0,
                    bo3w: 0,
                    bo3l: 0
                };
            }
            return teamStates[teamid];
        }
        function AddWin(state) {
            if (state.wins >= numBestOf1Rounds || state.loss >= numBestOf1Rounds) {
                ++state.bo3w;
                if (state.bo3w >= 2) {
                    state.bo3w = state.bo3l = 0;
                    ++state.wins;
                }
            }
            else {
                ++state.wins;
            }
        }
        function AddLoss(state) {
            if (state.wins >= numBestOf1Rounds || state.loss >= numBestOf1Rounds) {
                ++state.bo3l;
                if (state.bo3l >= 2) {
                    state.bo3l = state.bo3w = 0;
                    ++state.loss;
                }
            }
            else {
                ++state.loss;
            }
        }
        let nCount = PredictionsAPI.GetSectionMatchesCount(oPageData.tournamentId, oPageData.sectionId);
        for (let idxMatch = nCount; idxMatch-- > 0;) {
            let umid = PredictionsAPI.GetSectionMatchByIndex(oPageData.tournamentId, oPageData.sectionId, idxMatch);
            let team0 = MatchInfoAPI.GetMatchTournamentTeamTag(umid, 0);
            let team1 = MatchInfoAPI.GetMatchTournamentTeamTag(umid, 1);
            let res = MatchInfoAPI.GetMatchOutcome(umid);
            let bMatchStillInProgress = (!res || res <= 0);
            let winteam = ((res == 2) ? team1 : team0);
            let keyteam = (team0 < team1) ? team0 : team1;
            let steam = GetTeamState(keyteam);
            let matchup = 'matchups-' + steam.wins + '-' + steam.loss;
            if (!_m_elSections[matchup].hasOwnProperty(keyteam)) {
                _m_elSections[matchup][keyteam] = _m_elSections[matchup].results;
                ++_m_elSections[matchup].results;
            }
            if (_m_elSections[matchup][keyteam] < _m_elSections[matchup].matches.length) {
                let omatch = _m_elSections[matchup].matches[_m_elSections[matchup][keyteam]];
                let elTeamPair = omatch.panel;
                let nCountThisMatchForBO3 = bMatchStillInProgress ? 0 : 1;
                omatch.keyteamwl += ((winteam == keyteam) ? 1 : -1) * nCountThisMatchForBO3;
                omatch.keyteam_wins += ((winteam == keyteam) ? 1 : 0) * nCountThisMatchForBO3;
                omatch.keyteam_loss += ((winteam != keyteam) ? 1 : 0) * nCountThisMatchForBO3;
                let bSwap01 = (omatch.keyteamwl >= 0) ? ((team0 == keyteam) ? false : true)
                    : ((team0 == keyteam) ? true : false);
                let nLeftScore = 0;
                let nRightScore = 0;
                if (steam.wins >= numBestOf1Rounds || steam.loss >= numBestOf1Rounds) {
                    nLeftScore = (omatch.keyteam_wins >= omatch.keyteam_loss) ? omatch.keyteam_wins : omatch.keyteam_loss;
                    nRightScore = (omatch.keyteam_wins < omatch.keyteam_loss) ? omatch.keyteam_wins : omatch.keyteam_loss;
                }
                else {
                    nLeftScore = MatchInfoAPI.GetMatchRoundScoreForTeam(umid, bSwap01 ? 1 : 0);
                    nRightScore = MatchInfoAPI.GetMatchRoundScoreForTeam(umid, bSwap01 ? 0 : 1);
                }
                elTeamPair.SetHasClass('has_valid_matchup', true);
                elTeamPair.SetHasClass('has_match_in_progress', bMatchStillInProgress);
                elTeamPair.FindChildInLayoutFile('id-team-matchup-logo-0').SetImage("file://{images}/tournaments/teams/" +
                    (bSwap01 ? team1 : team0) + ".svg");
                elTeamPair.FindChildInLayoutFile('id-team-matchup-logo-1').SetImage("file://{images}/tournaments/teams/" +
                    (bSwap01 ? team0 : team1) + ".svg");
                elTeamPair.SetDialogVariableInt('match-score-0', nLeftScore);
                elTeamPair.SetDialogVariableInt('match-score-1', nRightScore);
                elTeamPair.Data().umids.push(umid);
                if (bMatchStillInProgress)
                    elTeamPair.Data().umids = [];
            }
            if (!bMatchStillInProgress) {
                AddWin(GetTeamState(winteam));
                AddLoss(GetTeamState((team0 == winteam) ? team1 : team0));
            }
        }
        for (let teamtag in teamStates) {
            if (teamStates[teamtag].wins < 3 && teamStates[teamtag].loss < 3)
                continue;
            let strID = 'placement-' + teamStates[teamtag].wins + '-' + teamStates[teamtag].loss;
            let idx = _m_elPlacements[strID].results++;
            if (idx >= _m_elPlacements[strID].slots.length)
                continue;
            _m_elPlacements[strID].slots[idx].SetImage("file://{images}/tournaments/teams/" + teamtag + ".svg");
            let elParent = _m_elPlacements[strID].slots[idx].GetParent();
            if (elParent && elParent.id.startsWith('id-pickem-pick-')) {
                let pickSlotIdx = parseInt(elParent.id.substring('id-pickem-pick-'.length));
                let pickSlotRange = (pickSlotIdx >= 0 && pickSlotIdx <= 1) ? { begin: 0, end: 1 } :
                    (pickSlotIdx >= 2 && pickSlotIdx <= 7) ? { begin: 2, end: 7 } :
                        (pickSlotIdx >= 8 && pickSlotIdx <= 9) ? { begin: 8, end: 9 } :
                            { begin: pickSlotIdx, end: pickSlotIdx };
                let bCorrectActualPick = false;
                for (let jj = pickSlotRange.begin; jj <= pickSlotRange.end; ++jj) {
                    let teamidPicked = PredictionsAPI.GetMyPredictionTeamID(oPageData.tournamentId, oPageData.groupId, jj);
                    let teamTagPicked = PredictionsAPI.GetTeamTag(teamidPicked);
                    if (teamTagPicked === teamtag) {
                        bCorrectActualPick = true;
                        break;
                    }
                }
                elParent.SetHasClass('actual-result-green-check', bCorrectActualPick);
            }
        }
    }
})(PredictionsGroup || (PredictionsGroup = {}));
