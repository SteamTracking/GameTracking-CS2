"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="avatar.ts" />
var MapDraft;
(function (MapDraft) {
    const _m_cp = $.GetContextPanel();
    let _m_nPhase = 0;
    let _m_hDenyInputToGame = null;
    let _m_isThisPhasePick = false;
    const _m_phaseTitleText = _m_cp.FindChildInLayoutFile('id-map-draft-phase-info');
    const _m_rowsContainer = _m_cp.FindChildInLayoutFile('id-map-draft-phase-rows');
    const _m_rowPhaseName = 'id-map-draft-phase-buttons-container';
    const _m_nT = 2;
    const _m_nCt = 3;
    let _m_msLastSoundTimestamp = (new Date()).getTime();
    function _PlaySoundEffect(strSoundEffect, msThrottleRequired = 0) {
        const msTimestampNow = (new Date()).getTime();
        if (msThrottleRequired && (msThrottleRequired > 0)) {
            if (msTimestampNow - _m_msLastSoundTimestamp < msThrottleRequired)
                return;
        }
        $.DispatchEvent('CSGOPlaySoundEffect', strSoundEffect, 'MOUSE');
        _m_msLastSoundTimestamp = msTimestampNow;
    }
    function _Update() {
        let sGameUiState = GameStateAPI.GetCSGOGameUIStateName();
        let bThisPanelIsVisible = true;
        if (sGameUiState === 'CSGO_GAME_UI_STATE_LOADINGSCREEN' || MatchDraftAPI.GetDraft() !== 'ingame' || MatchDraftAPI.GetIngamePhase() < 1) {
            bThisPanelIsVisible = false;
        }
        _m_cp.visible = bThisPanelIsVisible;
        _m_cp.SetHasClass('map-draft--show', bThisPanelIsVisible);
        let bMouseCaptureActive = _m_hDenyInputToGame ? true : false;
        if (bMouseCaptureActive != bThisPanelIsVisible) {
            if (bThisPanelIsVisible) {
                _m_hDenyInputToGame = UiToolkitAPI.AddDenyInputFlagsToGame(_m_cp, "MapDraft", "ShareMouse");
                _PopulatePlayerList();
            }
            else {
                UiToolkitAPI.ReleaseDenyInputFlagsToGame(_m_hDenyInputToGame);
                _m_hDenyInputToGame = null;
            }
        }
        if (!bThisPanelIsVisible) {
            _m_rowsContainer.RemoveAndDeleteChildren();
            return;
        }
        _m_cp.visible = true;
        _m_cp.SetHasClass('map-draft--show', true);
        if (MatchDraftAPI.GetIngamePhase() != _m_nPhase) {
            _PlaySoundEffect('tab_mainmenu_watch');
        }
        else {
            const ingameTeamToActNow = MatchDraftAPI.GetIngameTeamToActNow();
            if (ingameTeamToActNow && (ingameTeamToActNow == GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid()))) {
                _PlaySoundEffect('UIPanorama.mainmenu_rollover', 400);
            }
        }
        _m_nPhase = MatchDraftAPI.GetIngamePhase();
        if (_m_nPhase > 6) {
            _m_nPhase = 6;
        }
        _HideFinishedPhaseRows();
        _MakeVoteButtons(_UpdateButtonsRow());
        _UpdateActionText();
        _UpdatePhaseProgressBar();
    }
    function _UpdatePhaseProgressBar() {
        const aChildren = _m_cp.FindChildInLayoutFile('id-map-draft-phasebar-container').Children();
        for (let phase of aChildren) {
            const nPhaseBarIndex = parseInt(phase.GetAttributeString('data-phase', ''));
            phase.SetHasClass('map-draft-phasebar--ban', !_m_isThisPhasePick && nPhaseBarIndex === _m_nPhase);
            phase.SetHasClass('map-draft-phasebar--pick', _m_isThisPhasePick && nPhaseBarIndex === _m_nPhase);
            phase.SetHasClass('map-draft-phasebar--pre', nPhaseBarIndex > _m_nPhase);
            phase.SetHasClass('map-draft-phasebar--post', nPhaseBarIndex < _m_nPhase);
            phase.FindChildInLayoutFile('id-map-draft-phase-name').text = $.Localize('#matchdraft_phase_' + nPhaseBarIndex);
            if (nPhaseBarIndex === _m_nPhase) {
                const nTimeRemaining = MatchDraftAPI.GetIngamePhaseSecondsRemaining() || 0;
                phase.FindChildInLayoutFile('id-map-draft-phase-timer').timeleft = nTimeRemaining;
            }
        }
    }
    function _UpdateButtonsRow() {
        let elContainer = _m_rowsContainer.FindChildInLayoutFile(_m_rowPhaseName + _m_nPhase);
        if (!elContainer) {
            elContainer = $.CreatePanel('Panel', _m_rowsContainer, _m_rowPhaseName + _m_nPhase);
            elContainer.AddClass('map-draft-phase-buttons-container');
            elContainer.AddClass('map-draft-phase-buttons-container--show');
            elContainer.Data().phase = _m_nPhase;
        }
        elContainer.SetHasClass('map-draft-phase-buttons-container--show', true);
        elContainer.SetHasClass('map-draft-phase-buttons-container--hide', false);
        elContainer.hittest = true;
        elContainer.hittestchildren = true;
        return elContainer;
    }
    function _HideFinishedPhaseRows() {
        const aRows = _m_rowsContainer.Children();
        for (let row of aRows) {
            if (row.Data().phase !== _m_nPhase) {
                row.RemoveClass('map-draft-phase-buttons-container--show');
                row.AddClass('map-draft-phase-buttons-container--hide');
                row.hittest = false;
                row.hittestchildren = false;
            }
        }
    }
    function _MakeVoteButtons(elContainer) {
        if (_m_nPhase === 1) {
            _m_isThisPhasePick = true;
            const nYourTeam = GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid());
            const nOtherTeam = nYourTeam === _m_nT ? _m_nCt : _m_nT;
            _MakeButton(elContainer, {
                id: 'id-phase-1-btn-ban-first',
                image: 'url("file://{images}/mapdraft/ban_first.png")',
                selectorimg: "file://{images}/mapdraft/green_check.png",
                name: "#matchdraft_vote_ban_first",
                statustext: '#matchdraft_vote_status_pick',
                ispick: _m_isThisPhasePick,
                voteid: nYourTeam
            });
            _MakeButton(elContainer, {
                id: 'id-phase-1-btn-pick-side',
                image: 'url("file://{images}/mapdraft/pick_team.png")',
                selectorimg: "file://{images}/mapdraft/green_check.png",
                name: "#matchdraft_vote_pick_team",
                statustext: '#matchdraft_vote_status_pick',
                ispick: _m_isThisPhasePick,
                voteid: nOtherTeam
            });
        }
        else if (_m_nPhase === 5) {
            _m_isThisPhasePick = true;
            _MakeButton(elContainer, {
                id: 'id-phase-5-btn-start-ct',
                image: 'url("file://{images}/mapdraft/pick_ct.png")',
                selectorimg: "file://{images}/mapdraft/green_check.png",
                name: "#CSGO_Inventory_Team_CT",
                statustext: '#matchdraft_vote_status_pick',
                ispick: _m_isThisPhasePick,
                voteid: _m_nCt
            });
            _MakeLargeMap(elContainer);
            _MakeButton(elContainer, {
                id: 'id-phase-5-btn-start-t',
                image: 'url("file://{images}/mapdraft/pick_t.png")',
                selectorimg: "file://{images}/mapdraft/green_check.png",
                name: "#CSGO_Inventory_Team_T",
                statustext: '#matchdraft_vote_status_pick',
                ispick: _m_isThisPhasePick,
                voteid: _m_nT
            });
        }
        else if (_m_nPhase === 6) {
            _MakeLargeMap(elContainer, 'map-draft-phase-pick-map-image--large');
        }
        else if (_m_nPhase < 5) {
            _m_isThisPhasePick = false;
            const aVoteIds = MatchDraftAPI.GetIngameMapIdsList().split(',');
            for (let i = 0; i < aVoteIds.length; i++) {
                const nVoteId = parseInt(aVoteIds[i]);
                const mapName = DeepStatsAPI.MapIDToString(nVoteId);
                if (_m_nPhase !== 4 ||
                    (_m_nPhase === 4 && MatchDraftAPI.GetIngameTeamToActNow() !== GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid())) ||
                    (_m_nPhase === 4 && MatchDraftAPI.GetIngameTeamToActNow() === GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid()) &&
                        MatchDraftAPI.GetIngameMapIdState(nVoteId) !== 'veto')) {
                    _MakeButton(elContainer, {
                        id: 'id-phase-' + _m_nPhase + '-btn-' + aVoteIds[i],
                        image: 'url("file://{images}/map_icons/screenshots/360p/' + mapName + '.png")',
                        selectorimg: "file://{images}/mapdraft/red_x.png",
                        name: '#SFUI_Map_' + mapName,
                        statustext: '#matchdraft_vote_status_ban',
                        ispick: _m_isThisPhasePick,
                        mapstatus: MatchDraftAPI.GetIngameMapIdState(nVoteId),
                        voteid: nVoteId
                    });
                }
            }
        }
    }
    function _MakeButton(elContainer, oBtnData) {
        let elButton = elContainer.FindChildInLayoutFile(oBtnData.id);
        if (!elButton) {
            elButton = $.CreatePanel('Button', elContainer, oBtnData.id);
            elButton.BLoadLayoutSnippet('ButtonMapTile');
            const bgImage = elButton.FindChildInLayoutFile('draft-phase-button-image');
            bgImage.style.backgroundImage = oBtnData.image;
            bgImage.style.backgroundPosition = '50% 0%';
            bgImage.style.backgroundSize = 'auto 100%';
            elButton.FindChildInLayoutFile('draft-phase-button-selectorimg').SetImage(oBtnData.selectorimg);
            elButton.SetDialogVariable('mapname', $.Localize(oBtnData.name));
            const elStatusText = elButton.FindChildInLayoutFile('draft-phase-button-statustext');
            elStatusText.text = $.Localize(oBtnData.statustext);
            elButton.SetPanelEvent('onactivate', () => _OnActivateVoteTile(elContainer, oBtnData));
            elButton.SetPanelEvent('onmouseover', () => {
                if (elButton.enabled) {
                    _PlaySoundEffect('UIPanorama.mainmenu_rollover');
                }
            });
            elButton.Data().voteid = oBtnData.voteid;
        }
        elButton.SetHasClass('map-draft-phase-button__status--positive', oBtnData.ispick);
        elButton.enabled = true;
        if (MatchDraftAPI.GetIngameTeamToActNow() !== GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid()) ||
            oBtnData.hasOwnProperty('mapstatus') && oBtnData.mapstatus === 'veto') {
            elButton.SetHasClass('map-draft-phase-button--vetoed', oBtnData.mapstatus === 'veto');
            elButton.enabled = false;
            return;
        }
        const aVotedXuids = MatchDraftAPI.GetIngameXuidsForVote(Number(oBtnData.voteid)).split(',');
        elButton.SetHasClass('map-draft-phase-button--selected', aVotedXuids.indexOf(MyPersonaAPI.GetXuid()) !== -1);
        if (MatchDraftAPI.GetIngameXuidsForVote(Number(oBtnData.voteid))) {
            const aVoteIds = MatchDraftAPI.GetIngameWinningVotes().split(',');
            elButton.SetHasClass('map-draft-phase-button--winning-vote', aVoteIds.indexOf(oBtnData.voteid.toString()) !== -1);
        }
        else {
            elButton.SetHasClass('map-draft-phase-button--winning-vote', false);
        }
        const elAvatarsContainer = elButton.FindChildInLayoutFile('id-map-draft-phase-avatars-container');
        elAvatarsContainer.RemoveAndDeleteChildren();
        for (let i = 0; i < aVotedXuids.length; i++) {
            _MakeAvatar(aVotedXuids[i], elAvatarsContainer);
        }
    }
    function _OnActivateVoteTile(elContainer, oBtnData) {
        const aCurrentVotes = _GetCurrentVotes();
        const matchingVoteSlot = aCurrentVotes.indexOf(oBtnData.voteid);
        if (matchingVoteSlot !== -1) {
            MatchDraftAPI.ActionIngameCastMyVote(_m_nPhase, matchingVoteSlot, 0);
            _PlaySoundEffect('buymenu_select');
            return;
        }
        const aBtns = elContainer.Children().filter(btn => btn.Data().voteid);
        if (aBtns.length < 3) {
            MatchDraftAPI.ActionIngameCastMyVote(_m_nPhase, 0, oBtnData.voteid);
            _PlaySoundEffect('buymenu_purchase');
            return;
        }
        const freeSlot = _GetFirstFreeVoteSlot(aCurrentVotes);
        if (freeSlot !== null) {
            MatchDraftAPI.ActionIngameCastMyVote(_m_nPhase, freeSlot, oBtnData.voteid);
            _PlaySoundEffect('buymenu_purchase');
        }
        else {
            for (let btn of aBtns) {
                if (btn.BHasClass('map-draft-phase-button--selected')) {
                    btn.RemoveClass('map-draft-phase-button--pulse');
                    btn.AddClass('map-draft-phase-button--pulse');
                }
            }
            _PlaySoundEffect('buymenu_failure');
        }
    }
    function _GetCurrentVotes() {
        const aCurrentVotes = [];
        for (let i = 0; i < _GetNumVoteSlots(); i++) {
            const voteId = MatchDraftAPI.GetIngameMyVoteInSlot(i) || "empty";
            aCurrentVotes.push(voteId);
        }
        return aCurrentVotes;
    }
    function _GetFirstFreeVoteSlot(aCurrentVotes) {
        for (let i = 0; i < aCurrentVotes.length; i++) {
            if (aCurrentVotes[i] === 'empty') {
                return i;
            }
        }
        return null;
    }
    function _GetNumVoteSlots() {
        if (_m_nPhase === 1 || _m_nPhase === 5) {
            return 1;
        }
        if (_m_nPhase === 2) {
            return 2;
        }
        if (_m_nPhase === 3) {
            return 3;
        }
        if (_m_nPhase === 4) {
            return 1;
        }
        return 0.;
    }
    function _UpdateActionText() {
        const isWaiting = MatchDraftAPI.GetIngameTeamToActNow() !== GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid());
        _m_cp.FindChildInLayoutFile('id-map-draft-phase-info').SetHasClass('map-draft-phase-info--hidden', isWaiting);
        _m_cp.FindChildInLayoutFile('id-map-draft-phase-waiting').SetHasClass('map-draft-phase-info--hidden', !isWaiting);
        if (isWaiting) {
            _m_cp.FindChildInLayoutFile('id-map-draft-phase-wait').text = $.Localize('#matchdraft_phase_action_wait_' + _m_nPhase);
            return;
        }
        const elContainer = _m_rowsContainer.FindChildInLayoutFile(_m_rowPhaseName + _m_nPhase);
        const nPickedMaps = elContainer.Children().filter(btn => btn.BHasClass('map-draft-phase-button--selected'));
        _m_cp.SetDialogVariableInt('maps', nPickedMaps.length);
        _m_phaseTitleText.text = $.Localize('#matchdraft_phase_action_' + _m_nPhase, _m_cp);
    }
    function _MakeLargeMap(elContainer, style) {
        const aMapIds = MatchDraftAPI.GetIngameMapIdsList().split(',');
        const mapPickId = aMapIds.filter(id => MatchDraftAPI.GetIngameMapIdState(parseInt(id)) === 'pick')[0];
        const mapName = DeepStatsAPI.MapIDToString(parseInt(mapPickId));
        let elMapImage = elContainer.FindChildInLayoutFile('id-map-draft-phase-pick-map-image');
        if (!elMapImage) {
            elMapImage = $.CreatePanel('Panel', elContainer, 'id-map-draft-phase-pick-map-image');
            elMapImage.BLoadLayoutSnippet('FinalMapPick');
        }
        elMapImage.SetDialogVariable('mapname', $.Localize('#SFUI_Map_' + mapName));
        elMapImage.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/360p/' + mapName + '.png")';
        elMapImage.style.backgroundPosition = '50% 0%';
        elMapImage.style.backgroundSize = 'auto 100%';
        elMapImage.style.backgroundImgOpacity = '.5';
        if (style) {
            elMapImage.AddClass(style);
            const nYourTeam = GameStateAPI.GetPlayerTeamNumber(MyPersonaAPI.GetXuid());
            const nOtherTeam = nYourTeam === _m_nT ? _m_nCt : _m_nT;
            const nStartingTeam = (MatchDraftAPI.GetIngameTeamWithFirstChoice() === MatchDraftAPI.GetIngameTeamStartingCT())
                ? nOtherTeam : nYourTeam;
            const teamLogo = nStartingTeam === _m_nT ? 't_logo.svg' : 'ct_logo.svg';
            const startingTeam = nStartingTeam === _m_nT ? '#CSGO_Inventory_Team_T' : '#CSGO_Inventory_Team_CT';
            elContainer.FindChildInLayoutFile('id-map-draft-starting-team').visible = true;
            elContainer.FindChildInLayoutFile('id-map-draft-starting-team-icon').SetImage("file://{images}/icons/" + teamLogo);
            elContainer.SetDialogVariable('teamname', $.Localize(startingTeam));
        }
    }
    function _PopulatePlayerList() {
        const yourXuid = MyPersonaAPI.GetXuid();
        const oPlayerData = GameStateAPI.GetPlayerDataJSO();
        const teamNames = ['TERRORIST', 'CT'];
        let iYourXuidTeamIdx = 1;
        for (let iTeam = 0; iTeam < teamNames.length; ++iTeam) {
            const teamName = teamNames[iTeam];
            const teamIndex = oPlayerData.teams.findIndex(t => t.name === teamName);
            if (iTeam === 0 && oPlayerData.players.find(p => p.team === teamIndex)) {
                iYourXuidTeamIdx = 0;
            }
            const teamPanelId = (iYourXuidTeamIdx === iTeam) ? 'id-map-draft-phase-your-team' : 'id-map-draft-phase-other-team';
            const elTeammates = _m_cp.FindChildInLayoutFile(teamPanelId).FindChild('id-map-draft-phase-avatars');
            elTeammates.RemoveAndDeleteChildren();
            for (const p of oPlayerData.players) {
                if (p.team == teamIndex) {
                    const xuid = p.xuid;
                    if (!GameStateAPI.IsFakePlayer(xuid)) {
                        _MakeAvatar(xuid, elTeammates, true);
                    }
                }
            }
        }
    }
    function _MakeAvatar(xuid, elTeammates, bisTeamLister = false) {
        if (xuid === "0")
            return;
        if (xuid) {
            let elAvatar = elTeammates.FindChildInLayoutFile(xuid);
            const panelType = bisTeamLister ? 'Button' : 'Panel';
            if (!elAvatar || elAvatar.BHasClass('hidden')) {
                elAvatar = $.CreatePanel(panelType, elTeammates, xuid);
                elAvatar.BLoadLayoutSnippet('SmallAvatar');
                if (bisTeamLister) {
                    _AddOpenPlayerCardAction(elAvatar, xuid);
                }
            }
            elAvatar.FindChildTraverse('JsAvatarImage').PopulateFromSteamID(xuid);
            const teamColor = GameStateAPI.GetPlayerColor(xuid);
            const elTeamColor = elAvatar.FindChildInLayoutFile('JsAvatarTeamColor');
            if (!teamColor) {
                elTeamColor.visible = false;
            }
            else {
                elTeamColor.visible = true;
                elTeamColor.style.washColor = teamColor;
            }
            elAvatar.SetDialogVariable('teammate_name', FriendsListAPI.GetFriendName(xuid));
        }
    }
    function _AddOpenPlayerCardAction(elAvatar, xuid) {
        elAvatar.SetPanelEvent("onactivate", () => {
            $.DispatchEvent('SidebarContextMenuActive', true);
            if (xuid !== "0") {
                const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => $.DispatchEvent('SidebarContextMenuActive', false));
                contextMenuPanel.AddClass("ContextMenu_NoArrow");
            }
        });
    }
    const m_eventHandles = [];
    function _OnReadyForDisplay() {
        m_eventHandles.push(['PanoramaComponent_IngameDraft_DraftUpdate', $.RegisterForUnhandledEvent('PanoramaComponent_IngameDraft_DraftUpdate', _Update)]);
        m_eventHandles.push(['UnloadLoadingScreenAndReinit', $.RegisterForUnhandledEvent('UnloadLoadingScreenAndReinit', _Update)]);
        m_eventHandles.push(['PlayerTeamChanged', $.RegisterForUnhandledEvent('PlayerTeamChanged', _PopulatePlayerList)]);
    }
    function _OnUnreadyForDisplay() {
        while (m_eventHandles.length > 0) {
            const h = m_eventHandles.pop();
            $.UnregisterForUnhandledEvent(h[0], h[1]);
        }
    }
    {
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), _OnReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), _OnUnreadyForDisplay);
    }
})(MapDraft || (MapDraft = {}));
