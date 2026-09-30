"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/async.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="match_stakes.ts" />
$.LogChannel('p.teamintro', "LV_OFF");
var TeamIntroMenu;
(function (TeamIntroMenu) {
    async function _StartTeamIntro() {
        const type = MockAdapter.GetPlayerCompetitiveRankType(GameStateAPI.GetLocalPlayerXuid());
        const elMenu = $.GetContextPanel();
        elMenu.SetHasClass('premier', type === 'Premier');
        const sLocalXuid = GameStateAPI.GetLocalPlayerXuid();
        const nLocalTeam = GameStateAPI.GetPlayerTeamNumber(sLocalXuid);
        const endPromise = Async.UnhandledEvent("EndTeamIntro");
        elMenu.SetHasClass("active", true);
        _SetFaded(true, 0);
        elMenu.StartCamera();
        const modelRefs = _SetupModels(nLocalTeam);
        _SetTeam(nLocalTeam);
        _SetupHeader(nLocalTeam);
        const teamInfoAbort = new Async.AbortController();
        _SetupTeamInfos(nLocalTeam, modelRefs, teamInfoAbort.signal);
        await Async.Delay(0.5);
        _SetFaded(false, 0.5);
        MatchStakes.StartTeamIntro();
        $.DispatchEvent('CSGOPlaySoundEffect', 'TeamIntro', 'MOUSE');
        if (nLocalTeam == 2) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'TeamIntro_TSuits', 'MOUSE');
        }
        else {
            $.DispatchEvent('CSGOPlaySoundEffect', 'TeamIntro_CTSuits', 'MOUSE');
        }
        await endPromise;
        _SetFaded(true, 0.5);
        await Async.Delay(0.5);
        teamInfoAbort.abort();
        $("#TeamIntroHeader").AddClass("hidden");
        $("#TeamIntroTeammateInfos").RemoveAndDeleteChildren();
        MatchStakes.EndTeamIntro();
        _ClearBackground();
        elMenu.StopCamera();
        elMenu.ClearModels();
        _SetFaded(false, 0.5);
        await Async.Delay(0.5);
        elMenu.SetHasClass("active", false);
    }
    function _SetTeam(nTeamNumber) {
        switch (nTeamNumber) {
            case 2:
                $.GetContextPanel().SwitchClass('team', "TERRORIST");
                break;
            case 3:
                $.GetContextPanel().SwitchClass('team', "CT");
                break;
        }
    }
    function _ClearBackground() {
        $.GetContextPanel().SwitchClass('team', "no-background");
    }
    function _SetupTeamInfos(nTeamNumber, modelRefs, abortSignal) {
        const elMenu = $.GetContextPanel();
        $("#TeamIntroTeammateInfos").RemoveAndDeleteChildren();
        const teammateInfos = new Map();
        Async.RunSequence(function* () {
            for (const ref of modelRefs.values()) {
                yield Async.Delay(1.0);
                const elInfo = _CreateTeammateInfo(ref);
                teammateInfos.set(ref.nOrdinal, elInfo);
                elInfo.RemoveClass("hidden");
            }
        }, abortSignal);
        Async.RunSequence(function* () {
            while (true) {
                for (const [nOrdinal, elInfo] of teammateInfos) {
                    let { x, y } = elMenu.GetModelBonePosition(nTeamNumber, nOrdinal, "neck_0");
                    if (isFinite(x) && isFinite(y) && elInfo) {
                        y -= 10.0;
                        x -= elInfo.actuallayoutwidth / elInfo.actualuiscale_x * 0.5;
                        y -= elInfo.actuallayoutheight / elInfo.actualuiscale_y;
                        elInfo.style.transform = "translate3d( " + x + "px, " + y + "px, 0px )";
                    }
                }
                yield Async.NextFrame();
            }
        }, abortSignal);
    }
    function _SetHonorIcon(elPanel, xuid, teamColor) {
        const elHonorIconFrame = elPanel.FindChildTraverse('jsHonorIcon');
        if (elHonorIconFrame) {
            elHonorIconFrame.Set(GameStateAPI.GetPlayerXpTrailLevel(xuid), false);
            if (teamColor) {
                const elImage = elHonorIconFrame.FindChildTraverse('JsHonorIconImage');
                if (elImage) {
                    elImage.style.washColor = teamColor;
                }
            }
        }
    }
    function _CreateTeammateInfo(ref) {
        const sXuid = ref.sXuid;
        const nOrdinal = ref.nOrdinal;
        const elInfos = $("#TeamIntroTeammateInfos");
        const elInfo = $.CreatePanel("Panel", elInfos, nOrdinal.toString());
        elInfo.BLoadLayoutSnippet("TeamIntroTeammateInfo");
        const elAvatarImage = elInfo.FindChildInLayoutFile("AvatarImage");
        elAvatarImage.PopulateFromPlayerSlot(GameStateAPI.GetPlayerSlot(sXuid));
        const elName = elInfo.FindChildInLayoutFile("Name");
        elName.SetDialogVariableInt("intro_player_slot", GameStateAPI.GetPlayerSlot(sXuid));
        const teamColor = GameStateAPI.GetPlayerColor(sXuid);
        if (teamColor)
            elName.style.washColor = teamColor;
        _SetHonorIcon(elInfo, sXuid, teamColor);
        return elInfo;
    }
    function _SetupModels(nLocalTeam) {
        const elMenu = $.GetContextPanel();
        elMenu.ClearModels();
        const modelRefs = [];
        for (let nOrdinal = 1;; ++nOrdinal) {
            const jso = elMenu.AddModel(nLocalTeam, nOrdinal);
            const sXuid = jso.sXuid;
            if (!sXuid)
                break;
            const ref = { sXuid, nOrdinal };
            modelRefs.push(ref);
        }
        return modelRefs;
    }
    function _SetFaded(bVisible, transitionDuration) {
        const elFade = $("#TeamIntroFade");
        elFade.style.transitionDuration = `${transitionDuration}s`;
        elFade.SetHasClass("hidden", !bVisible);
    }
    function _SetupHeader(nTeamNumber) {
        const timeData = GameStateAPI.GetTimeDataJSO();
        const nOvertime = timeData.overtime;
        const bFirstHalf = timeData.gamephase === 2;
        $("#TeamIntroHeader").RemoveClass("hidden");
        const elIcon = $("#TeamIntroIcon");
        const elHalfLabel = $("#TeamIntroHalfLabel");
        const elTeamLabel = $("#TeamIntroTeamLabel");
        if (timeData.has_halftime) {
            elHalfLabel.RemoveClass('collapse');
            if (nOvertime > 0) {
                elHalfLabel.SetDialogVariableInt("overtime_num", nOvertime);
                elHalfLabel.SetLocString(bFirstHalf ? "#team-intro-overtime-1st-half:f" : "#team-intro-overtime-2nd-half:f");
            }
            else {
                elHalfLabel.SetLocString(bFirstHalf ? "#team-intro-1st-half" : "#team-intro-2nd-half");
            }
        }
        else {
            elHalfLabel.AddClass('collapse');
        }
        switch (nTeamNumber) {
            case 2:
                if (elIcon) {
                    elIcon.SetImage("file://{images}/icons/t_logo.svg");
                }
                elTeamLabel.SetLocString(nOvertime == 0 && bFirstHalf ? "#team-intro-starting-as-t" : "#team-intro-playing-as-t");
                break;
            case 3:
                if (elIcon) {
                    elIcon.SetImage("file://{images}/icons/ct_logo.svg");
                }
                elTeamLabel.SetLocString(nOvertime == 0 && bFirstHalf ? "#team-intro-starting-as-ct" : "#team-intro-playing-as-ct");
                break;
        }
    }
    {
        $.RegisterForUnhandledEvent("StartTeamIntro", _StartTeamIntro);
    }
})(TeamIntroMenu || (TeamIntroMenu = {}));
