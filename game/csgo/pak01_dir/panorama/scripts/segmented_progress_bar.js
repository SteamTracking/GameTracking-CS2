"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="mission_tile.ts" />
$.LogChannel('p.progressbar', "LV_OFF");
var SegmentedProgressBar;
(function (SegmentedProgressBar) {
    const WHOLE_BAR_WIDTH = 180;
    const PROGRESS_PIP_WIDTH = 24;
    const SEGMENT_MARGIN_LEFT = 1;
    const SEGMENT_MARGIN_RIGHT = 1;
    class CSegment {
        min;
        max;
        totalMax;
        elRoot;
        elProg;
        elPip;
        constructor(parent, name, min, max, totalMax, addPip, numSegments) {
            this.totalMax = totalMax;
            this.min = min;
            this.max = max;
            this.elRoot = $.CreatePanel('Panel', parent, name);
            this.elRoot.BLoadLayoutSnippet("snippet__progress-bar-segment");
            this.elProg = this.elRoot.FindChildTraverse('pbs-progressbar');
            this.elProg.max = this.max;
            this.elProg.min = this.min;
            this.elProg.value = 0;
            const totalWidth = WHOLE_BAR_WIDTH - (numSegments * PROGRESS_PIP_WIDTH);
            const fractionOfTotalProgress = (this.max - this.min) / totalMax;
            const segmentBarWidth = fractionOfTotalProgress * totalWidth;
            const segmentBarWidthWithPip = segmentBarWidth + PROGRESS_PIP_WIDTH;
            this.elRoot.style.width = segmentBarWidthWithPip + 'px';
            this.elProg.style.marginLeft = SEGMENT_MARGIN_LEFT + 'px';
            this.elProg.style.marginRight = SEGMENT_MARGIN_RIGHT + 'px';
            const elPip = this.elRoot.FindChildTraverse('pbs-progresspip');
            const goalLabel = this.elRoot.FindChildTraverse('pbs-progress-goal-label');
            elPip.style.visibility = addPip ? 'visible' : 'collapse';
            elPip.style.width = PROGRESS_PIP_WIDTH + 'px';
            elPip.style.height = PROGRESS_PIP_WIDTH + 'px';
            this.elPip = elPip;
            goalLabel.SetDialogVariableInt('goal-checkpoint', this.max);
        }
        setValue(value) {
            this.elProg.value = value;
            if (value >= this.max) {
                this.elRoot.SwitchClass('state', 'complete');
            }
            else if (value < this.min) {
                this.elRoot.SwitchClass('state', 'future');
            }
            else {
                this.elRoot.SwitchClass('state', 'current');
            }
        }
    }
    class CWholeBar {
        segments;
        constructor(elParent, barType, missionData) {
            this.segments = [];
            const arrGoals = missionData.goal_points;
            const arrXpRewards = missionData.xp_reward;
            for (let i = 0; i < arrGoals.length; i++) {
                let min = 0;
                let max = arrGoals[i];
                if (i > 0) {
                    min = arrGoals[i - 1];
                    max = arrGoals[i];
                }
                const totalGoal = arrGoals.slice(-1)[0];
                const addPip = arrGoals.length > 1;
                const seg = new CSegment(elParent, barType + i, min, max, totalGoal, addPip, arrGoals.length);
                this.segments.push(seg);
                if (barType == "Base") {
                    seg.elRoot.SetDialogVariableInt('mission-points', max - min);
                    seg.elRoot.SetDialogVariableInt('xp-reward', arrXpRewards[i]);
                    seg.elRoot.SetPanelEvent('onmouseover', () => {
                        const strTooltip = $.Localize("#mission_segment_tooltip", seg.elRoot);
                        UiToolkitAPI.ShowTextTooltipOnPanelStyled(seg.elRoot, strTooltip, 'mission-segment-tooltip');
                    });
                    seg.elRoot.SetPanelEvent('onmouseout', () => {
                        UiToolkitAPI.HideTextTooltip();
                    });
                }
            }
        }
        setBarValue(val) {
            for (let i = 0; i < this.segments.length; i++) {
                let seg = this.segments[i];
                seg.setValue(val);
            }
        }
    }
    function CreateSegmentedProgressBar(elPanel, missionData) {
        elPanel.BLoadLayout('file://{resources}/layout/segmented_progress_bar.xml', true, false);
        elPanel.Data().m_backgroundProgBar = new CWholeBar(elPanel.FindChildTraverse('spbBackground'), 'Background', missionData);
        elPanel.Data().m_liveProgBar = new CWholeBar(elPanel.FindChildTraverse('spbLive'), 'Live', missionData);
        elPanel.Data().m_baseProgBar = new CWholeBar(elPanel.FindChildTraverse('spbBase'), 'Base', missionData);
        MissionTile.ExtractStringTokens(elPanel.FindChildTraverse('spbBase'), missionData.string_tokens);
        elPanel.style.width = WHOLE_BAR_WIDTH + 'px';
    }
    SegmentedProgressBar.CreateSegmentedProgressBar = CreateSegmentedProgressBar;
    function Init(elPanel, missionData) {
        elPanel.RemoveAndDeleteChildren();
        CreateSegmentedProgressBar(elPanel, missionData);
    }
    SegmentedProgressBar.Init = Init;
    function SetValue(elPanel, val, bar) {
        if (elPanel && elPanel.IsValid() && elPanel.Data().m_liveProgBar) {
            switch (bar) {
                case 'Live':
                    elPanel.Data().m_liveProgBar.setBarValue(val);
                    break;
                case 'Base':
                    elPanel.Data().m_baseProgBar.setBarValue(val);
                    break;
            }
            elPanel.Data().m_backgroundProgBar.setBarValue(val);
        }
    }
    SegmentedProgressBar.SetValue = SetValue;
})(SegmentedProgressBar || (SegmentedProgressBar = {}));
