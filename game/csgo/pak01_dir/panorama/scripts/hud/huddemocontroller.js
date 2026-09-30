"use strict";
/// <reference path="../csgo.d.ts" />
var HudDemoController;
(function (HudDemoController) {
    function EatClick() {
        return true;
    }
    HudDemoController.EatClick = EatClick;
    let ObserverMode;
    (function (ObserverMode) {
        ObserverMode[ObserverMode["OBS_MODE_NONE"] = 0] = "OBS_MODE_NONE";
        ObserverMode[ObserverMode["OBS_MODE_FIXED"] = 1] = "OBS_MODE_FIXED";
        ObserverMode[ObserverMode["OBS_MODE_IN_EYE"] = 2] = "OBS_MODE_IN_EYE";
        ObserverMode[ObserverMode["OBS_MODE_CHASE"] = 3] = "OBS_MODE_CHASE";
        ObserverMode[ObserverMode["OBS_MODE_ROAMING"] = 4] = "OBS_MODE_ROAMING";
    })(ObserverMode || (ObserverMode = {}));
    let DemoTimelineEvent;
    (function (DemoTimelineEvent) {
        DemoTimelineEvent[DemoTimelineEvent["EDemoTimelineEvent_Kill"] = 0] = "EDemoTimelineEvent_Kill";
        DemoTimelineEvent[DemoTimelineEvent["EDemoTimelineEvent_Death"] = 1] = "EDemoTimelineEvent_Death";
        DemoTimelineEvent[DemoTimelineEvent["EDemoTimelineEvent_DamageInflicted"] = 2] = "EDemoTimelineEvent_DamageInflicted";
        DemoTimelineEvent[DemoTimelineEvent["EDemoTimelineEvent_DamageReceived"] = 3] = "EDemoTimelineEvent_DamageReceived";
        DemoTimelineEvent[DemoTimelineEvent["EDemoTimelineEvent_TickMarker"] = 4] = "EDemoTimelineEvent_TickMarker";
    })(DemoTimelineEvent || (DemoTimelineEvent = {}));
    function TimelineEventToLabel(timelineEvent) {
        const labels = [
            "kill",
            "death",
            "dealt_damage",
            "received_damage",
            "tick"
        ];
        return labels[timelineEvent];
    }
    const timeStepSeconds = 15;
    const cp = $.GetContextPanel();
    cp.SetDialogVariableInt("timestep_value", timeStepSeconds);
    const slider = $("#Slider");
    const timescale = $("#TimeScale");
    const XRayToggleButton = $("#XRayToggleButton");
    const TrueViewToggleButton = $("#TrueViewToggleButton");
    const TrueViewDOACheckBox = $("#TrueViewDOACheckBox");
    const TrueViewDOAToggleButton = $("#TrueViewDOAToggleButton");
    const TrueViewWrongVersionCheckBox = $("#TrueViewWrongVersionCheckBox");
    const TrueViewWrongVersionToggleButton = $("#TrueViewWrongVersionToggleButton");
    const SettingsPanel = $("#Settings");
    timescale.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip(timescale.id, "Playback speed"));
    timescale.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
    const hud = cp.GetParent();
    $.RegisterForUnhandledEvent("DemoToggleUI", () => {
        if (!cp.IsPlayingDemo())
            return;
        if (lastState && lastState.bIsPlayingBroadcast)
            return;
        if (lastState && lastState.bIsOverwatch)
            return;
        if (hud.BHasClass("DemoControllerMinimal")) {
            hud.SetHasClass("DemoControllerMinimal", false);
            hud.SetHasClass("DemoControllerFull", true);
        }
        else if (hud.BHasClass("DemoControllerFull")) {
            hud.SetHasClass("DemoControllerMinimal", false);
            hud.SetHasClass("DemoControllerFull", false);
        }
        else {
            hud.SetHasClass("DemoControllerMinimal", true);
            hud.SetHasClass("DemoControllerFull", false);
        }
    });
    $.RegisterForUnhandledEvent("DemoSetHUDVisible", (bVisible) => {
        if (!cp.IsPlayingDemo())
            return;
        hud.SetHasClass("hide", !bVisible);
    });
    $.RegisterForUnhandledEvent("DemoSetMouseEnabled", (bEnabled) => {
        if (!cp.IsPlayingDemo())
            return;
        cp.SetHasClass("mouseActive", bEnabled);
        const sMouseMode = bEnabled ?
            $.Localize('#CSGO_Demo_Enable_Mouse_Camera', cp) :
            $.Localize('#CSGO_Demo_Enable_Mouse_Cursor', cp);
        cp.SetDialogVariable('mouse-mode', sMouseMode);
    });
    let lastState = null;
    let bRoundsMarked = false;
    let bAtEndOfPlayback = false;
    let nSpectatingPlayerId = -1;
    let bHighlightsMode = false;
    function FrameUpdate() {
        const state = cp.GetDemoControllerState();
        if (state == null) {
            hud.SetHasClass("DemoControllerMinimal", false);
            hud.SetHasClass("DemoControllerFull", false);
            lastState = null;
            $.Schedule(1, FrameUpdate);
            return;
        }
        const nFinalTick = state.bIsPlayingHighlights && state.HighlightIntervals ?
            state.HighlightIntervals.at(-1)?.nTickEnd :
            state.RoundIntervals.at(-1)?.nTickEnd;
        const bStateAtEndOfPlayback = nFinalTick != undefined && state.nTick >= nFinalTick;
        if (bStateAtEndOfPlayback != bAtEndOfPlayback) {
            if (state.bIsOverwatch) {
                const sEndPlayback = bStateAtEndOfPlayback ?
                    $.Localize('#CSGO_Demo_End_Playback_Overwatch_Finished') :
                    $.Localize('#CSGO_Demo_End_Playback_Overwatch');
                cp.SetDialogVariable('end-playback', sEndPlayback);
            }
            bAtEndOfPlayback = bStateAtEndOfPlayback;
        }
        if (!cp.visible || !cp.BReadyForDisplay() || !cp.IsSizeValid()) {
            $.Schedule(1, FrameUpdate);
            return;
        }
        $.Schedule(0, FrameUpdate);
        let bStateChanged = false;
        if (lastState == null || lastState.sFileName !== state.sFileName) {
            bRoundsMarked = false;
            bStateChanged = true;
            let sFileName = state.sFileName.replaceAll("\\", "/");
            let nSlashIndex = sFileName.lastIndexOf("/");
            if (nSlashIndex !== -1)
                sFileName = sFileName.substring(nSlashIndex + 1);
            cp.SetDialogVariable("total_time", TicksToTimeText(state.nTotalTicks, state.nSecondsPerTick, false));
            if (state?.bIsPlayingBroadcast) {
                hud.SetHasClass("DemoControllerHidden", false);
                hud.SetHasClass("DemoControllerMinimal", false);
                hud.SetHasClass("DemoControllerFull", false);
            }
            else {
                let nUIMode = Number(GameInterfaceAPI.GetSettingString("demo_ui_mode"));
                hud.SetHasClass("DemoControllerHidden", nUIMode == 0);
                hud.SetHasClass("DemoControllerMinimal", nUIMode == 1);
                hud.SetHasClass("DemoControllerFull", nUIMode == 2);
            }
            OnHighlightsModeChanged(state.bIsPlayingHighlights);
            bHighlightsMode = state.bIsPlayingHighlights;
            const sEndPlayback = state.bIsOverwatch ?
                $.Localize('#CSGO_Demo_End_Playback_Overwatch') :
                $.Localize('#CSGO_Demo_End_Playback');
            cp.SetDialogVariable('end-playback', sEndPlayback);
            const sMouseMode = $.Localize('#CSGO_Demo_Enable_Mouse_Camera', cp);
            cp.SetDialogVariable('mouse-mode', sMouseMode);
        }
        lastState = state;
        const pMarkers = $("#RoundMarkers");
        if (pMarkers.actuallayoutwidth > 0 && !bRoundsMarked) {
            bRoundsMarked = true;
            pMarkers.RemoveAndDeleteChildren();
            const pThumb = $("#SliderThumb");
            const nThumbWidth = pThumb.actuallayoutwidth / pThumb.actualuiscale_x;
            const nMarkersWidth = (pMarkers.actuallayoutwidth / pThumb.actualuiscale_x) - nThumbWidth;
            for (let i = 0; i < state.RoundIntervals.length; i++) {
                const nStartTick = state.RoundIntervals[i].nTickStart;
                const nEndTick = state.RoundIntervals[i].nTickEnd;
                let nLeft = nStartTick / state.nTotalTicks * nMarkersWidth + nThumbWidth / 2;
                let nWidth = (nEndTick - nStartTick) / state.nTotalTicks * nMarkersWidth;
                if (i === 0) {
                    nWidth += nLeft;
                    nLeft = 0;
                }
                else if (i === state.RoundIntervals.length - 1) {
                    nWidth += nThumbWidth / 2;
                }
                const className = i % 2 === 0 ? "roundMarker even" : "roundMarker odd";
                const pMarker = $.CreatePanel("Panel", pMarkers, "", { class: className });
                pMarker.style.position = `${nLeft}px 0 0`;
                pMarker.style.width = nWidth + "px";
            }
        }
        if (nSpectatingPlayerId != state.nSpectatingPlayerId) {
            CreateHighlightIntervals();
            CreateTimelineEvents();
            nSpectatingPlayerId = state.nSpectatingPlayerId;
            $("#HighlightsButton")?.SetHasClass("hide", !ShouldShowHighlightsButton());
        }
        if ((state.bIsPlayingHighlights != bHighlightsMode) || bStateChanged) {
            OnHighlightsModeChanged(state.bIsPlayingHighlights);
            bHighlightsMode = state.bIsPlayingHighlights;
        }
        cp.SetHasClass("paused", state.bIsPaused);
        cp.SetHasClass("mouseCamAllowed", IsMouseCameraAllowed());
        cp.SetHasClass("flyCamActive", state.nObserverMode == ObserverMode.OBS_MODE_ROAMING);
        slider.min = 0;
        slider.max = state.nTotalTicks;
        if (!slider.mousedown) {
            slider.value = state.nTick;
            cp.SetDialogVariable("current_time", TicksToTimeText(state.nTick, state.nSecondsPerTick, true));
            SetRoundNumberLabel();
        }
        timescale.text = parseFloat(state.fTimeScale.toFixed(4)).toString() + "x";
        const bSettingsVisible = cp.BHasClass("SettingsVisible");
        if (bSettingsVisible) {
            SettingsPanel.AddClass("Visible");
            const spec_show_xray = parseInt(GameInterfaceAPI.GetSettingString("spec_show_xray"));
            XRayToggleButton.SetSelected(spec_show_xray != 0);
            const cl_demo_predict = parseInt(GameInterfaceAPI.GetSettingString("cl_demo_predict"));
            const cl_trueview_show_doa_predictions = parseInt(GameInterfaceAPI.GetSettingString("cl_trueview_show_doa_predictions"));
            TrueViewToggleButton.SetSelected(cl_demo_predict > 0);
            TrueViewDOAToggleButton.SetSelected(cl_trueview_show_doa_predictions != 0);
            TrueViewDOACheckBox.enabled = cl_demo_predict > 0;
            TrueViewWrongVersionCheckBox.enabled = cl_demo_predict > 0;
            if (cl_demo_predict > 0) {
                TrueViewWrongVersionToggleButton.SetSelected(cl_demo_predict >= 2);
            }
        }
        else {
            SettingsPanel.RemoveClass("Visible");
        }
        const cl_demo_predict = parseInt(GameInterfaceAPI.GetSettingString("cl_demo_predict"));
    }
    $.Schedule(0, FrameUpdate);
    $.RegisterEventHandler("SliderReleased", slider, (_, fValue) => {
        if (lastState == null)
            return true;
        cp.SetDialogVariable("current_time", TicksToTimeText(fValue, lastState.nSecondsPerTick, true));
        SetRoundNumberLabel();
        cp.GotoTick(Math.floor(fValue));
        return true;
    });
    $.RegisterEventHandler("SliderValueChanged", slider, (_, fValue) => {
        if (lastState == null)
            return true;
        cp.SetDialogVariable("current_time", TicksToTimeText(fValue, lastState.nSecondsPerTick, true));
        SetRoundNumberLabel();
        return true;
    });
    function OnPlayClicked() {
        cp.SetPaused(!cp.BHasClass("paused"));
        return true;
    }
    HudDemoController.OnPlayClicked = OnPlayClicked;
    function OnStepTimeBackward() {
        return OnStepTime(-timeStepSeconds);
    }
    HudDemoController.OnStepTimeBackward = OnStepTimeBackward;
    function OnStepTimeForward() {
        return OnStepTime(timeStepSeconds);
    }
    HudDemoController.OnStepTimeForward = OnStepTimeForward;
    function OnStepTime(fStep) {
        if (lastState) {
            cp.GotoTick(lastState.nTick + (fStep / lastState.nSecondsPerTick));
        }
        return true;
    }
    function OnStepInterval(nStep) {
        if (!lastState) {
            return false;
        }
        if (lastState.bIsPlayingHighlights) {
            if (lastState.HighlightIntervals?.length > 0) {
                const nIntervalIndex = lastState.HighlightIntervals.findIndex(r => r.nTickStart > lastState.nTick) - 1;
                let nNewInterval = nIntervalIndex + nStep;
                if (nNewInterval < 0)
                    nNewInterval = 0;
                else if (nNewInterval > lastState.HighlightIntervals.length - 1)
                    nNewInterval = lastState.HighlightIntervals.length - 1;
                cp.GotoTick(lastState.HighlightIntervals[nNewInterval].nTickStart);
            }
        }
        else if (lastState.RoundIntervals?.length > 0) {
            const nIntervalIndex = lastState.RoundIntervals.findIndex(r => r.nTickStart > lastState.nTick) - 1;
            let nNewInterval = nIntervalIndex + nStep;
            if (nNewInterval < 0)
                nNewInterval = 0;
            else if (nNewInterval > lastState.RoundIntervals.length - 1)
                nNewInterval = lastState.RoundIntervals.length - 1;
            cp.GotoTick(lastState.RoundIntervals[nNewInterval].nTickStart);
        }
        return true;
    }
    HudDemoController.OnStepInterval = OnStepInterval;
    function OnShowTimeScaleContextMenu() {
        cp.OnShowTimeScaleContextMenu();
        return true;
    }
    HudDemoController.OnShowTimeScaleContextMenu = OnShowTimeScaleContextMenu;
    function OnStopPlayback() {
        cp.StopPlayback();
        return true;
    }
    HudDemoController.OnStopPlayback = OnStopPlayback;
    function OnHighlightsToggle() {
        let bIsEnabled = !lastState?.bIsPlayingHighlights;
        cp.SetHighlightsModeEnabled(!!bIsEnabled);
    }
    HudDemoController.OnHighlightsToggle = OnHighlightsToggle;
    function ShouldShowHighlightsButton() {
        if (lastState?.bIsOverwatch)
            return false;
        return true;
    }
    function OnHighlightsModeChanged(bEnabled) {
        cp.SetHasClass("highlightsActive", bEnabled);
        $("#IntervalLabel").text = bEnabled ? $.Localize('#CSGO_Demo_Highlight') : $.Localize('#CSGO_Demo_Round');
        CreateHighlightIntervals();
        CreateTimelineEvents();
        SetRoundNumberLabel();
        return true;
    }
    function DestroyTimelineEvents() {
        const pHighlightIcons = $("#HighlightIcons");
        pHighlightIcons.RemoveAndDeleteChildren();
    }
    function CreateTimelineEvents() {
        DestroyTimelineEvents();
        if (!lastState || !lastState.TimelineEvents)
            return;
        const pThumb = $("#SliderThumb");
        const pHighlightIcons = $("#HighlightIcons");
        const nThumbWidth = pThumb.actuallayoutwidth / pThumb.actualuiscale_x;
        const nMarkersWidth = (pHighlightIcons.actuallayoutwidth / pHighlightIcons.actualuiscale_x) - nThumbWidth;
        for (let iEvent = lastState.TimelineEvents.length - 1; iEvent >= 0; --iEvent) {
            const timelineEvent = lastState.TimelineEvents[iEvent];
            const nHalfIconWidth = 11;
            const nLeft = (timelineEvent.nTick / lastState.nTotalTicks * nMarkersWidth + nThumbWidth / 2) - nHalfIconWidth;
            const sClass = TimelineEventToLabel(timelineEvent.eEventType);
            const pIcon = $.CreatePanel("Panel", pHighlightIcons, "", { class: `highlight-icon ${sClass}` });
            pIcon.style.marginLeft = nLeft + "px";
            const flSkipToTicksBefore = 64 * 2;
            pIcon.SetPanelEvent('onactivate', () => cp.GotoTick(timelineEvent.nTick - flSkipToTicksBefore));
        }
    }
    function DestroyHighlightIntervals() {
        const pMarkers = $("#HighlightMarkers");
        pMarkers.RemoveAndDeleteChildren();
    }
    function CreateHighlightIntervals() {
        DestroyHighlightIntervals();
        if (!lastState || !lastState.HighlightIntervals)
            return;
        const pMarkers = $("#HighlightMarkers");
        const pThumb = $("#SliderThumb");
        const nThumbWidth = pThumb.actuallayoutwidth / pThumb.actualuiscale_x;
        const nMarkersWidth = (pMarkers.actuallayoutwidth / pThumb.actualuiscale_x) - nThumbWidth;
        for (let i = 0; i < lastState.HighlightIntervals.length; i++) {
            const highlight = lastState.HighlightIntervals[i];
            const nStartTick = highlight.nTickStart;
            const nEndTick = highlight.nTickEnd;
            let nLeft = nStartTick / lastState.nTotalTicks * nMarkersWidth + nThumbWidth / 2;
            let nWidth = (nEndTick - nStartTick) / lastState.nTotalTicks * nMarkersWidth;
            const pMarker = $.CreatePanel("Panel", pMarkers, "");
            pMarker.style.marginLeft = nLeft + "px";
            pMarker.style.width = nWidth + "px";
        }
    }
    function GetCurrentIntervalNumber() {
        if (!lastState)
            return 0;
        if (lastState.bIsPlayingHighlights) {
            return 0;
        }
        return TicksToRound(lastState.nTick, lastState.RoundIntervals);
    }
    function TicksToTimeText(nTick, nSecondsPerTick, bFractionalSeconds) {
        const nTime = nSecondsPerTick * nTick;
        const nMinutes = Math.floor(nTime / 60.0);
        const nSeconds = nTime - nMinutes * 60.0;
        let sSeconds = "";
        if (bFractionalSeconds) {
            sSeconds = (Math.floor(nSeconds * 10.0) / 10.0).toFixed(1);
            if (sSeconds.length < 4)
                sSeconds = "0" + sSeconds;
        }
        else {
            sSeconds = nSeconds.toFixed(0);
            if (sSeconds.length < 2)
                sSeconds = "0" + sSeconds;
        }
        return `${nMinutes}:${sSeconds}`;
    }
    function TicksToRound(nTick, rounds) {
        if (rounds.length === 0 || rounds[0].nTickStart > nTick)
            return 0;
        for (let i = 0; i < rounds.length; i++) {
            if (nTick < rounds[i].nTickStart) {
                return i;
            }
        }
        return rounds.length;
    }
    function IsMouseCameraAllowed() {
        return lastState?.nObserverMode == ObserverMode.OBS_MODE_CHASE ||
            lastState?.nObserverMode == ObserverMode.OBS_MODE_ROAMING;
    }
    function ToggleSettingsVisible() {
        cp.ToggleClass("SettingsVisible");
        $.Schedule(0, FrameUpdate);
    }
    HudDemoController.ToggleSettingsVisible = ToggleSettingsVisible;
    function ToggleXRay() {
        let spec_show_xray = parseInt(GameInterfaceAPI.GetSettingString("spec_show_xray"));
        spec_show_xray = spec_show_xray ? 0 : 1;
        GameInterfaceAPI.ConsoleCommand(`spec_show_xray ${spec_show_xray}`);
    }
    HudDemoController.ToggleXRay = ToggleXRay;
    function ToggleTrueView() {
        const cl_demo_predict = parseInt(GameInterfaceAPI.GetSettingString("cl_demo_predict"));
        if (cl_demo_predict) {
            GameInterfaceAPI.ConsoleCommand("cl_demo_predict 0");
        }
        else {
            if (!TrueViewWrongVersionToggleButton.IsSelected()) {
                GameInterfaceAPI.ConsoleCommand("cl_demo_predict 1");
            }
            else {
                GameInterfaceAPI.ConsoleCommand("cl_demo_predict 2");
            }
        }
    }
    HudDemoController.ToggleTrueView = ToggleTrueView;
    function ToggleTrueViewDOACommands() {
        let cl_trueview_show_doa_predictions = parseInt(GameInterfaceAPI.GetSettingString("cl_trueview_show_doa_predictions"));
        cl_trueview_show_doa_predictions = cl_trueview_show_doa_predictions ? 0 : 1;
        GameInterfaceAPI.ConsoleCommand(`cl_trueview_show_doa_predictions ${cl_trueview_show_doa_predictions}`);
    }
    HudDemoController.ToggleTrueViewDOACommands = ToggleTrueViewDOACommands;
    function ToggleTrueViewWrongVersion() {
        const cl_demo_predict = parseInt(GameInterfaceAPI.GetSettingString("cl_demo_predict"));
        if (cl_demo_predict == 1) {
            GameInterfaceAPI.ConsoleCommand("cl_demo_predict 2");
        }
        else if (cl_demo_predict == 2) {
            GameInterfaceAPI.ConsoleCommand("cl_demo_predict 1");
        }
    }
    HudDemoController.ToggleTrueViewWrongVersion = ToggleTrueViewWrongVersion;
    function SetRoundNumberLabel() {
        if (lastState && lastState.bIsPlayingHighlights) {
            var roundNumber = $("#RoundNumber");
            if (roundNumber) {
                roundNumber.visible = false;
            }
        }
        else {
            var roundNumber = $("#RoundNumber");
            if (roundNumber) {
                roundNumber.visible = true;
            }
            cp.SetDialogVariableInt("round_number", GetCurrentIntervalNumber());
        }
    }
})(HudDemoController || (HudDemoController = {}));
