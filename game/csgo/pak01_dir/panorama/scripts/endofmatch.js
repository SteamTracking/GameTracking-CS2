"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="common/gamerules_constants.ts" />
/// <reference path="endofmatch-characters.ts" />
/// <reference path="mock_adapter.ts" />
var EndOfMatch;
(function (EndOfMatch) {
    // for the case when we're a debug panel, use "PanelToTest". see \scripts\mainmenu_tests.js
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
    //DEVONLY{
    const DEBUG_EOM = false;
    $.RegisterForUnhandledEvent("EndOfMatch_Test_Show", _StartTestShow);
    //}DEVONLY
    _m_cP.AddClass('scoreboard-visible');
    function _NavigateToTab(tab) {
        // if an active tab exists, first deactivate it
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
        // we delay the latch to capture the last bits of data
        $.Schedule(1, () => { $.DispatchEvent("EndOfMatch_Latch"); });
        _m_data._m_arrPanelObjects = [];
        _m_data._m_currentPanelIndex = -1;
        _m_data._m_elActiveTab = null;
        if (_m_data._m_jobStart !== null) {
            $.CancelScheduled(_m_data._m_jobStart);
            _m_data._m_jobStart = null;
        }
        // Determine the game mode
        var mode = MockAdapter.GetGameModeInternalName(false);
        _m_data._m_scoreboardVisible = (mode == "cooperative") || (mode == "coopmission");
        var elLayout = _m_cP.FindChildTraverse("id-eom-layout");
        elLayout.RemoveAndDeleteChildren();
        let strEomLayoutSnippet = "snippet-eom-layout--default";
        if (mode == "premier") {
            strEomLayoutSnippet = "snippet-eom-layout--premier";
        }
        elLayout.BLoadLayoutSnippet(strEomLayoutSnippet);
        // reset progress bar
        let elProgBar = _m_cP.FindChildTraverse("id-display-timer-progress-bar");
        elProgBar.style.transitionDuration = "0s";
        elProgBar.style.width = '0%';
        // SCOREBOARD TOGGLE BINDING (start with scoreboard in coop)
        var bind = GameInterfaceAPI.GetSettingString("cl_scoreboard_mouse_enable_binding");
        if (bind.charAt(0) == '+' || bind.charAt(0) == '-')
            bind = bind.substring(1);
        bind = "{s:bind_" + bind + "}";
        bind = $.Localize(bind, _m_cP);
        _m_cP.SetDialogVariable("scoreboard_toggle_bind", bind);
        _m_cP.FindChildrenWithClassTraverse("timer").forEach(el => el.active = false);
        // populate navbar
        var elNavBar = _m_cP.FindChildTraverse("id-content-navbar__tabs");
        elNavBar.RemoveAndDeleteChildren();
        _m_cP.FindChildrenWithClassTraverse("eom-panel").forEach((elPanel, i) => {
            // create the navbar button
            var elRBtn = $.CreatePanel("RadioButton", elNavBar, "rb--" + elPanel.id);
            elRBtn.BLoadLayoutSnippet("snippet_navbar-button");
            elRBtn.AddClass("navbar-button");
            elRBtn.AddClass("appear");
            let tabName = elPanel.id;
            elRBtn.SetPanelEvent('onactivate', () => _NavigateToTab(tabName));
            //DEVONLY{
            if (DEBUG_EOM) {
                elRBtn.style.border = '1px solid red';
                function _r(min = 0, max = 100) {
                    return Math.ceil(Math.random() * ((max - min) + min));
                }
                ;
                let tabName = elPanel.id;
                elRBtn.SetPanelEvent('onactivate', () => {
                    _NavigateToTab(tabName);
                    if (i === 0) {
                        let rankType = 'Premier';
                        let oldrank;
                        let newrank;
                        switch (rankType) {
                            case 'Wingman':
                            case 'Competitive':
                                oldrank = Math.ceil(Math.random() * 17);
                                newrank = oldrank + _r(-1, +1);
                                break;
                            case 'Premier':
                                //oldrank = Math.ceil( Math.random() * 7 ) * 500 - Math.floor( Math.random() * 50);
                                //Keep for promotion state
                                //newrank = oldrank + (100 - (oldrank - (Math.floor(oldrank/100)*100))) - 1 ; // _r( 0, 100 );
                                //newrank = oldrank + _r( 0, 100 );
                                oldrank = 30001;
                                newrank = 30002;
                                break;
                        }
                        const k_SkillgroupDataJSO = {};
                        k_SkillgroupDataJSO[MockAdapter.GetLocalPlayerXuid()] = {
                            old_rank: oldrank,
                            new_rank: newrank,
                            num_wins: 13,
                            rank_change: 666,
                            rank_type: rankType
                        };
                        const xpTracksPreMatch = [
                            Math.random() * 20000,
                            Math.random() * 20000,
                            Math.random() * 20000,
                            Math.random() * 20000,
                            Math.random() * 20000
                        ];
                        const xpEarned = 400;
                        const xptracksPostMatch = xpTracksPreMatch.map(xp => xp + xpEarned);
                        MockAdapter.AddTable('custom', {
                            k_bSkillgroupDataReady: false,
                            k_SkillgroupDataJSO,
                            k_GetPlayerCompetitiveRankType: {
                                0: rankType
                            },
                            k_GetPlayerCompetitiveRanking: 0,
                            k_GetPlayerCompetitiveWins: 734,
                            // xp
                            k_bXpDataReady: true,
                            k_XpDataJSO: {
                                current_level: _r(0, 39),
                                current_xp: 100,
                                free_rewards: 2,
                                xp_progress_data: [
                                    { xp_points: 100, xp_category: 2 },
                                    { xp_points: 0, xp_category: 6 },
                                ],
                                xp_trail_xp_needed: -10000,
                                xp_trail_remaining: 20000,
                            },
                            // xpshop
                            k_bXpShopDataReady: true,
                            k_XpShopDataJSO: {
                                prematch: {
                                    redeemable_balance: 3,
                                    xp_tracks: xpTracksPreMatch
                                },
                                postmatch: {
                                    redeemable_balance: 1,
                                    xp_tracks: xptracksPostMatch
                                },
                            }
                        });
                        $.DispatchEvent('EndOfMatch_Test_Show', 'custom,EOM_WIN,RANK');
                    }
                    else {
                        _m_data._m_arrPanelObjects[i - 1].Start();
                    }
                });
            }
            //}DEVONLY
            elRBtn.FindChildTraverse("id-navbar-button__label").text = $.Localize("#" + elPanel.id);
        });
    }
    function _ShowPanelStart() {
        if (!_m_cP || !_m_cP.IsValid())
            return;
        _m_cP.AddClass("eom--reveal");
        // Fade to black before enabling the in-world camera.
        // Then transition back by hiding the fade.
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
            // unfortunately we can't do this synchronously --
            // we might be in the last frame of a killer replay,
            // which erroneously makes us think we are in a "demo".
            //
            // so instead do an async schedule here to wait 1 frame
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
        // reset
        $.Schedule(0.0, () => {
            if (elProgBar && elProgBar.IsValid()) {
                elProgBar.style.transitionDuration = "0s";
                elProgBar.style.width = '0%';
            }
        });
        // play
        $.Schedule(0.0, () => {
            if (elProgBar && elProgBar.IsValid()) {
                elProgBar.style.transitionDuration = time + "s";
                elProgBar.style.width = '100%';
            }
        });
    }
    EndOfMatch.StartDisplayTimer = StartDisplayTimer;
    // the shownext event will cycle the end of match to the next state
    function ShowNextPanel() {
        _m_data._m_currentPanelIndex++;
        if (_m_data._m_currentPanelIndex < _m_data._m_arrPanelObjects.length) {
            // reveal timer on last panel if live game
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
