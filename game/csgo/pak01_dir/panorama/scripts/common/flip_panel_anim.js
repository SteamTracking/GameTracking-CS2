"use strict";
/// <reference path="../csgo.d.ts" />
var FlipPanelAnimation = class {
    oData;
    get ActiveIndex() { return this.oData.activeIndex; }
    set ActiveIndex(value) { this.oData.activeIndex = value; }
    set CallbackData(value) { this.oData.oCallbackData = value; }
    constructor(oData) {
        this.oData = oData;
    }
    AddParamToCallbackData(param, value) {
        this.oData.oCallbackData[param] = value;
    }
    ControlBtnActions() {
        if (this.oData.controlBtnPrev) {
            this.oData.controlBtnPrev.SetPanelEvent('onactivate', this.oData.funcCallback.bind(this, this.oData, true));
            this.oData.controlBtnNext.SetPanelEvent('onactivate', this.oData.funcCallback.bind(this, this.oData, false));
            this.oData.controlBtnPrev.enabled = false;
            this.oData.controlBtnNext.enabled = false;
        }
    }
    UpdateTextLabel(elPanel, aTextData) {
        aTextData.forEach(element => {
            if (typeof element.value == 'number' && element.value > 0) {
                elPanel.SetDialogVariableInt(element.name, element.value);
            }
            else if (element.value) {
                elPanel.SetDialogVariable(element.name, element.value.toString());
            }
        });
    }
    UseCallback() {
        this.oData.funcCallback(this.oData, false);
    }
    DetermineVisiblePanel(animPanelA, animPanelB) {
        return animPanelA.BHasClass('flip-panel-anim-down-show') || animPanelA.BHasClass('flip-panel-anim-up-show') ? animPanelA : animPanelB;
    }
    BtnPressNextAnim(panelA, panelB) {
        const visiblePanel = this.DetermineVisiblePanel(panelA, panelB);
        const hiddenPanel = visiblePanel === panelA ? panelB : panelA;
        visiblePanel.RemoveClass('flip-panel-anim-transition');
        visiblePanel.RemoveClass('flip-panel-anim-up-hidden');
        visiblePanel.RemoveClass('flip-panel-anim-down-show');
        visiblePanel.RemoveClass('flip-panel-anim-up-show');
        visiblePanel.RemoveClass('flip-panel-anim-down-hidden');
        visiblePanel.AddClass('flip-panel-anim-transition');
        visiblePanel.AddClass('flip-panel-anim-down-hidden');
        hiddenPanel.RemoveClass('flip-panel-anim-transition');
        hiddenPanel.RemoveClass('flip-panel-anim-down-hidden');
        hiddenPanel.AddClass('flip-panel-anim-up-hidden');
        hiddenPanel.AddClass('flip-panel-anim-transition');
        hiddenPanel.AddClass('flip-panel-anim-down-show');
    }
    BtnPressPrevAnim(panelA, panelB) {
        const visiblePanel = this.DetermineVisiblePanel(panelA, panelB);
        const hiddenPanel = visiblePanel === panelA ? panelB : panelA;
        visiblePanel.RemoveClass('flip-panel-anim-transition');
        visiblePanel.RemoveClass('flip-panel-anim-up-hidden');
        visiblePanel.RemoveClass('flip-panel-anim-down-show');
        visiblePanel.RemoveClass('flip-panel-anim-up-show');
        visiblePanel.RemoveClass('flip-panel-anim-down-hidden');
        visiblePanel.AddClass('flip-panel-anim-transition');
        visiblePanel.AddClass('flip-panel-anim-up-hidden');
        hiddenPanel.RemoveClass('flip-panel-anim-transition');
        hiddenPanel.RemoveClass('flip-panel-anim-up-hidden');
        hiddenPanel.AddClass('flip-panel-anim-down-hidden');
        hiddenPanel.AddClass('flip-panel-anim-transition');
        hiddenPanel.AddClass('flip-panel-anim-up-show');
    }
    DetermineHiddenPanel(animPanelA, animPanelB) {
        return (!animPanelA.BHasClass('flip-panel-anim-down-show') &&
            !animPanelA.BHasClass('flip-panel-anim-up-show')) ?
            animPanelA : animPanelB;
    }
};
