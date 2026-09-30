"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="common/gamerules_constants.ts" />
/// <reference path="endofmatch-characters.ts" />
/// <reference path="mock_adapter.ts" />
var EndOfMatch;
(function (EndOfMatch) {
    const _m_cP = $('#EndOfMatch');
    const _m_data = {
        _m_arrPanelObjects: [],
        _m_currentPanelIndex: -1,
        _m_jobStart: null,
        _m_elActiveTab: null,
        _m_scoreboardVisible: false,
    };
    $.RegisterEventHandler("EndOfMatch_Show", _m_cP, _Start);
    $.RegisterForUnhandledEvent("EndOfMatch_Shutdown", _Shutdown);
    _m_cP.AddClass('scoreboard-visible');
    function _NavigateToTab(tab) {
        if (_m_data._m_elActiveTab && _m_data._m_elActiveTab.IsValid()) {
            _m_data._m_elActiveTab.RemoveClass('eom-panel--active');
        }
        _m_data._m_elActiveTab = _m_cP.FindChildTraverse(tab);
        if (_m_data._m_elActiveTab) {
            _m_data._m_elActiveTab.AddClass('eom-panel--active');
        }
    }
    function SwitchToPanel(tab) {
        _m_cP.FindChildTraverse('rb--' + tab).RemoveClass("hidden");
        _m_cP.FindChildTraverse('rb--' + tab).checked = true;
        _NavigateToTab(tab);
    }
    EndOfMatch.SwitchToPanel = SwitchToPanel;
    function RegisterPanelObject(panel) {
        _m_data._m_arrPanelObjects.push(panel);
    }
    EndOfMatch.RegisterPanelObject = RegisterPanelObject;
    function _Initialize() {
        _m_cP.SetMouseCapture(true);
        for (var j = 1; j < 10; ++j) {
            var elPanel = $.GetContextPanel().FindChildTraverse('EomCancelReason' + j);
            if (elPanel)
                elPanel.RemoveClass('show');
        }
        $.Schedule(1, () => { $.DispatchEvent("EndOfMatch_Latch"); });
        _m_data._m_arrPanelObjects = [];
        _m_data._m_currentPanelIndex = -1;
        _m_data._m_elActiveTab = null;
        if (_m_data._m_jobStart !== null) {
            $.CancelScheduled(_m_data._m_jobStart);
            _m_data._m_jobStart = null;
        }
        var mode = MockAdapter.GetGameModeInternalName(false);
        _m_data._m_scoreboardVisible = (mode == "cooperative") || (mode == "coopmission");
        var elLayout = _m_cP.FindChildTraverse("id-eom-layout");
        elLayout.RemoveAndDeleteChildren();
        let strEomLayoutSnippet = "snippet-eom-layout--default";
        if (mode == "premier") {
            strEomLayoutSnippet = "snippet-eom-layout--premier";
        }
        elLayout.BLoadLayoutSnippet(strEomLayoutSnippet);
        let elProgBar = _m_cP.FindChildTraverse("id-display-timer-progress-bar");
        elProgBar.style.transitionDuration = "0s";
        elProgBar.style.width = '0%';
        var bind = GameInterfaceAPI.GetSettingString("cl_scoreboard_mouse_enable_binding");
        if (bind.charAt(0) == '+' || bind.charAt(0) == '-')
            bind = bind.substring(1);
        bind = "{s:bind_" + bind + "}";
        bind = $.Localize(bind, _m_cP);
        _m_cP.SetDialogVariable("scoreboard_toggle_bind", bind);
        _m_cP.FindChildrenWithClassTraverse("timer").forEach(el => el.active = false);
        var elNavBar = _m_cP.FindChildTraverse("id-content-navbar__tabs");
        elNavBar.RemoveAndDeleteChildren();
        _m_cP.FindChildrenWithClassTraverse("eom-panel").forEach((elPanel, i) => {
            var elRBtn = $.CreatePanel("RadioButton", elNavBar, "rb--" + elPanel.id);
            elRBtn.BLoadLayoutSnippet("snippet_navbar-button");
            elRBtn.AddClass("navbar-button");
            elRBtn.AddClass("appear");
            let tabName = elPanel.id;
            elRBtn.SetPanelEvent('onactivate', () => _NavigateToTab(tabName));
            elRBtn.FindChildTraverse("id-navbar-button__label").text = $.Localize("#" + elPanel.id);
        });
    }
    function _ShowPanelStart() {
        if (!_m_cP || !_m_cP.IsValid())
            return;
        _m_cP.AddClass("eom--reveal");
        const elFade = $("#id-eom-fade");
        elFade.AddClass("active");
        let elFallbackBackground = $("#id-eom-fallback-background");
        elFallbackBackground.AddClass("hidden");
        var elBackgroundImage = _m_cP.FindChildInLayoutFile('BackgroundMapImage');
        elBackgroundImage.SetImage('file://{images}/map_icons/screenshots/1080p/' + GameStateAPI.GetMapBSPName() + '.png');
        $.Schedule(0.5, () => {
            _m_cP.SetWantsCamera(true);
            if (_m_cP.FindChildTraverse('id-eom-characters-root')) {
                EOM_Characters.Start();
            }
            elFade.RemoveClass("active");
            if (_m_cP.IsInFallbackMode()) {
                elFallbackBackground.RemoveClass("hidden");
            }
        });
    }
    function _Start(bHardCut) {
        _Initialize();
        if (bHardCut) {
            _m_data._m_jobStart = $.Schedule(0.0, () => {
                _m_data._m_jobStart = null;
                _ShowPanelStart();
                ShowNextPanel();
            });
        }
        else {
            _m_data._m_jobStart = $.Schedule(0.0, () => {
                _m_data._m_jobStart = null;
                _ShowPanelStart();
                $.Schedule(1.25, ShowNextPanel);
            });
        }
    }
    function _StartTestShow(mockData) {
        MockAdapter.SetMockData(mockData);
        $.DispatchEvent("Scoreboard_ResetAndInit");
        $.DispatchEvent("OnOpenScoreboard");
        _m_cP.SetMouseCapture(false);
        _Initialize();
        _ShowPanelStart();
        $.Schedule(1.25, ShowNextPanel);
    }
    function StartDisplayTimer(time) {
        var elProgBar = _m_cP.FindChildTraverse("id-display-timer-progress-bar");
        $.Schedule(0.0, () => {
            if (elProgBar && elProgBar.IsValid()) {
                elProgBar.style.transitionDuration = "0s";
                elProgBar.style.width = '0%';
            }
        });
        $.Schedule(0.0, () => {
            if (elProgBar && elProgBar.IsValid()) {
                elProgBar.style.transitionDuration = time + "s";
                elProgBar.style.width = '100%';
            }
        });
    }
    EndOfMatch.StartDisplayTimer = StartDisplayTimer;
    function ShowNextPanel() {
        _m_data._m_currentPanelIndex++;
        if (_m_data._m_currentPanelIndex < _m_data._m_arrPanelObjects.length) {
            if (_m_data._m_currentPanelIndex === (_m_data._m_arrPanelObjects.length - 1) &&
                !GameStateAPI.IsDemoOrHltv() &&
                !GameStateAPI.IsQueuedMatchmaking()) {
                _m_cP.FindChildrenWithClassTraverse("timer").forEach(el => el.active = true);
            }
            _m_data._m_arrPanelObjects[_m_data._m_currentPanelIndex].Start();
        }
    }
    EndOfMatch.ShowNextPanel = ShowNextPanel;
    function _Shutdown() {
        if (_m_data._m_jobStart) {
            $.CancelScheduled(_m_data._m_jobStart);
            _m_data._m_jobStart = null;
        }
        var elLayout = _m_cP.FindChildTraverse("id-eom-layout");
        elLayout.RemoveAndDeleteChildren();
        for (const panelObject of _m_data._m_arrPanelObjects) {
            if (panelObject.Shutdown)
                panelObject.Shutdown();
        }
        _m_cP.RemoveClass("eom--reveal");
        if (_m_cP.FindChildTraverse('id-eom-characters-root')) {
            EOM_Characters.Shutdown();
        }
        _m_cP.SetWantsCamera(false);
    }
})(EndOfMatch || (EndOfMatch = {}));
