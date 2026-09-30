"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="avatar.ts" />
/// <reference path="mock_adapter.ts" />
var TeamSelectMenu;
(function (TeamSelectMenu) {
    let m_nHighlightedTeamNum = 0;
    let m_errorTimerHandle = false;
    let m_playerCounts = [0, 0];
    let m_botCounts = [0, 0];
    let _m_UiSceneFrameBoundaryEventHandler = null;
    let m_scheduledHideWash = null;
    function _Init() {
        let elBtnTeamT = $("#BtnSelectTeam-TERRORIST");
        elBtnTeamT.SetPanelEvent("onmouseover", _HighlightTTeam);
        elBtnTeamT.SetPanelEvent("onmouseout", _UnhighlightTTeam);
        elBtnTeamT.SetPanelEvent("onactivate", () => _SelectTeam(2));
        let elBtnTeamCT = $("#BtnSelectTeam-CT");
        elBtnTeamCT.SetPanelEvent("onmouseover", _HighlightCTTeam);
        elBtnTeamCT.SetPanelEvent("onmouseout", _UnhighlightCTTeam);
        elBtnTeamCT.SetPanelEvent("onactivate", () => _SelectTeam(3));
        let elBtnSpectate = $("#TeamSelectSpectate");
        elBtnSpectate.SetPanelEvent("onactivate", () => _SelectTeam(1));
        let elBtnAuto = $("#TeamSelectAuto");
        elBtnAuto.SetPanelEvent("onactivate", () => _SelectTeam(0));
        _UnhighlightTTeam();
        _UnhighlightCTTeam();
    }
    function _ShowPanelTest(mockdata) {
        MockAdapter.SetMockData(mockdata);
        _ShowPanel();
    }
    function _ShowPanel() {
        if (GameStateAPI.IsDemoOrHltv())
            return;
        if (m_scheduledHideWash != null) {
            $.CancelScheduled(m_scheduledHideWash);
            m_scheduledHideWash = null;
        }
        const elFade = $("#TeamSelectFade");
        elFade.style.transitionDuration = "0.0s";
        elFade.RemoveClass("hidden");
        m_scheduledHideWash = $.Schedule(0.5, () => {
            if (elFade.IsValid()) {
                elFade.style.transitionDuration = "0.5s";
                elFade.AddClass("hidden");
            }
            m_scheduledHideWash = null;
        });
        let elBackgroundImage = $.GetContextPanel().FindChildInLayoutFile('BackgroundMapImage');
        let mapName = MockAdapter.GetMapBSPName();
        elBackgroundImage.SetImage('file://{images}/map_icons/screenshots/1080p/' + mapName + '.png');
        _OnServerForcingTeamJoin(0);
        m_nHighlightedTeamNum = 0;
        $("#TeamJoinError").AddClass("hidden");
        if (m_errorTimerHandle !== false) {
            $.CancelScheduled(m_errorTimerHandle);
            m_errorTimerHandle = false;
        }
    }
    function _OnReadyForDisplay() {
        if (!_m_UiSceneFrameBoundaryEventHandler) {
            _m_UiSceneFrameBoundaryEventHandler = $.RegisterForUnhandledEvent("UISceneFrameBoundary", _OnUISceneFrameBoundary);
        }
    }
    function _OnUnreadyForDisplay() {
        if (_m_UiSceneFrameBoundaryEventHandler) {
            $.UnregisterForUnhandledEvent("UISceneFrameBoundary", _m_UiSceneFrameBoundaryEventHandler);
            _m_UiSceneFrameBoundaryEventHandler = null;
        }
    }
    function _OnUISceneFrameBoundary() {
        let bInFallbackMode = $.GetContextPanel().IsInFallbackMode();
        for (let el of $("#TeamSelectMenu").FindChildrenWithClassTraverse("team-select-fallback")) {
            if (bInFallbackMode)
                el.RemoveClass("team-select-fallback-hidden");
            else
                el.AddClass("team-select-fallback-hidden");
        }
    }
    function _UpdateBotPlayerCount(countBots, countPlayers, team) {
        let elLabel = $("#BtnSelectTeam-" + team).FindChildInLayoutFile("PlayerBotCount");
        if (countBots === 1)
            elLabel.SetDialogVariable("botlabel", $.Localize("#team_select_bot"));
        else
            elLabel.SetDialogVariable("botlabel", $.Localize("#team_select_bots"));
        if (countPlayers === 1)
            elLabel.SetDialogVariable("playerlabel", $.Localize("#team_select_player"));
        else
            elLabel.SetDialogVariable("playerlabel", $.Localize("#team_select_players"));
        elLabel.SetDialogVariableInt("bots", countBots);
        elLabel.SetDialogVariableInt("players", countPlayers);
        elLabel.text = $.Localize("#team_select_bot_player_count", elLabel);
    }
    function _OnServerForcingTeamJoin(nTimeout) {
        let bUnassigned = $.GetContextPanel().GetTeamNumber() == 0;
        $("#TeamSelectCancel").visible = !bUnassigned;
        if (bUnassigned && isFinite(nTimeout) && nTimeout > 0) {
            let elTimer = $("#AutojoinTimer");
            let elTimerBar = elTimer.FindChildInLayoutFile("AutojoinTimerBar");
            if (elTimerBar) {
                elTimerBar.DeleteAsync(0);
            }
            elTimerBar = $.CreatePanel("Panel", elTimer, "AutojoinTimerBar");
            elTimerBar.style.animationDuration = nTimeout + "s";
            elTimerBar.AddClass("team-select__timer__bar");
            elTimer.endTime = Date.now() * 0.001 + nTimeout;
            elTimer.visible = true;
        }
        else {
            $("#AutojoinTimer").visible = false;
        }
    }
    function _SelectTeam(nTeamNum) {
        if (nTeamNum != 0 && nTeamNum == MockAdapter.GetPlayerTeamNumber(MyPersonaAPI.GetXuid())) {
            HidePanel();
            return;
        }
        _SetTeam(nTeamNum);
    }
    function _HighlightTTeam() {
        _UnhighlightTeam(m_nHighlightedTeamNum);
        m_nHighlightedTeamNum = 2;
        $.GetContextPanel().HighlightTeam(2, true);
    }
    function _HighlightCTTeam() {
        _UnhighlightTeam(m_nHighlightedTeamNum);
        m_nHighlightedTeamNum = 3;
        $.GetContextPanel().HighlightTeam(3, true);
    }
    function _UnhighlightTTeam() {
        _UnhighlightTeam(2);
    }
    function _UnhighlightCTTeam() {
        _UnhighlightTeam(3);
    }
    function _UnhighlightTeam(nTeamNum) {
        if (m_nHighlightedTeamNum == nTeamNum) {
            m_nHighlightedTeamNum = 0;
            $.GetContextPanel().HighlightTeam(nTeamNum, false);
        }
    }
    function _SetTeam(team) {
        GameInterfaceAPI.ConsoleCommand("jointeam " + team + " 1");
    }
    function _SetTeamT() {
        _SetTeam(2);
    }
    function _SetTeamCT() {
        _SetTeam(3);
    }
    function _ShowError(locString) {
        let elLabel = $("#TeamJoinErrorLabel");
        let elWarningPanel = $("#TeamJoinError");
        elLabel.text = $.Localize(locString);
        elWarningPanel.RemoveClass("hidden");
        m_errorTimerHandle = $.Schedule(5.0, function () {
            if (elWarningPanel.IsValid())
                elWarningPanel.AddClass("hidden");
            m_errorTimerHandle = false;
        });
    }
    function _Escape() {
        if ($.GetContextPanel().GetTeamNumber() == 0)
            GameInterfaceAPI.ConsoleCommand("gameui_activate");
        else
            HidePanel();
    }
    function HidePanel() {
        $.DispatchEvent("CSGOShowTeamSelectMenu", false, true);
    }
    TeamSelectMenu.HidePanel = HidePanel;
    function _ClearPlayerLists() {
        $("#List-0").RemoveAndDeleteChildren();
        $("#List-1").RemoveAndDeleteChildren();
        m_playerCounts[0] = 0;
        m_playerCounts[1] = 0;
        m_botCounts[0] = 0;
        m_botCounts[1] = 0;
        _UpdateBotPlayerCount(0, 0, "TERRORIST");
        _UpdateBotPlayerCount(0, 0, "CT");
    }
    function _AddToPlayerList(nTeamIdx, xuid) {
        let elList = $("#List-" + nTeamIdx);
        let elTeammate = $.CreatePanel("Panel", elList, "Teammate");
        elTeammate.BLoadLayoutSnippet("Teammate");
        let elAvatar = $.CreatePanel("Panel", elTeammate, "Avatar");
        elAvatar.BLoadLayout("file://{resources}/layout/avatar.xml", false, false);
        elAvatar.BLoadLayoutSnippet("AvatarParty");
        Avatar.Init(elAvatar, xuid.toString(), "playercard");
        if (MockAdapter.IsFakePlayer(xuid)) {
            let elAvatarImage = elAvatar.FindChildInLayoutFile("JsAvatarImage");
            elAvatarImage.PopulateFromPlayerSlot(MockAdapter.GetPlayerSlot(xuid));
            m_botCounts[nTeamIdx]++;
        }
        else {
            m_playerCounts[nTeamIdx]++;
        }
        elTeammate.SetHasClass('bot', MockAdapter.IsFakePlayer(xuid));
        let elName = elTeammate.FindChildInLayoutFile("TeamSelectTeammateName");
        elName.SetDialogVariableInt('player_slot', GameStateAPI.GetPlayerSlot(xuid));
        elTeammate.MoveChildAfter(elName, elAvatar);
        _UpdateBotPlayerCount(m_botCounts[nTeamIdx], m_playerCounts[nTeamIdx], nTeamIdx == 0 ? "TERRORIST" : "CT");
    }
    {
        _Init();
        $.RegisterForUnhandledEvent("CSGOShowTeamSelectMenu", _ShowPanel);
        $.RegisterForUnhandledEvent("CSGOShowTeamSelectMenu_Test", _ShowPanelTest);
        $.RegisterForUnhandledEvent("ServerForcingTeamJoin", _OnServerForcingTeamJoin);
        $.RegisterForUnhandledEvent("TeamJoinFailed", _ShowError);
        $.RegisterForUnhandledEvent("ClearTeamSelectPlayerLists", _ClearPlayerLists);
        $.RegisterForUnhandledEvent("AddToTeamSelectPlayerList", _AddToPlayerList);
        $.GetContextPanel().RegisterForReadyEvents(true);
        $.RegisterEventHandler("ReadyForDisplay", $.GetContextPanel(), _OnReadyForDisplay);
        $.RegisterEventHandler("UnreadyForDisplay", $.GetContextPanel(), _OnUnreadyForDisplay);
        let _m_cP = $("#TeamSelectMenu");
        if (!_m_cP)
            _m_cP = $("#PanelToTest");
        $.RegisterKeyBind(_m_cP, "key_escape", _Escape);
        $.RegisterKeyBind(_m_cP, "key_1", _SetTeamT);
        $.RegisterKeyBind(_m_cP, "key_2", _SetTeamCT);
    }
})(TeamSelectMenu || (TeamSelectMenu = {}));
