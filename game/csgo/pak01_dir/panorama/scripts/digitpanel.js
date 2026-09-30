"use strict";
/// <reference path="csgo.d.ts" />
var DigitPanelFactory;
(function (DigitPanelFactory) {
    function MakeDigitPanel(elParent, nDigits, suffix = undefined, duration = 0.5, digitStringToken = "#digitpanel_digits", timingFunc = 'cubic-bezier( 0.9, 0.01, 0.1, 1 )') {
        elParent.RemoveAndDeleteChildren();
        const elContainer = $.CreatePanel('Panel', elParent, 'DigitPanel');
        elContainer.m_nDigits = nDigits;
        elContainer.m_suffix = suffix;
        elContainer.m_duration = duration;
        elContainer.m_strDigitsToken = digitStringToken;
        elContainer.m_timingFunc = timingFunc;
        elContainer.m_pendingSetStringHandle = null;
        elContainer.m_bPendingSetStringInstant = false;
        elContainer.style.flowChildren = 'right';
        elContainer.style.overflow = 'clip';
        _MakeDigitPanelContents(elContainer);
        return elContainer;
    }
    DigitPanelFactory.MakeDigitPanel = MakeDigitPanel;
    function _UpdateSuffix(elContainer) {
        if (elContainer.m_suffix != undefined) {
            let elSuffixLabel = elContainer.FindChildTraverse('DigitPanel-Suffix');
            if (!elSuffixLabel) {
                elSuffixLabel = $.CreatePanel('Label', elContainer, 'DigitPanel-Suffix');
                elSuffixLabel.style.marginLeft = '2px';
                elSuffixLabel.style.height = "100%";
                elSuffixLabel.style.textAlign = "right";
            }
            elSuffixLabel.text = elContainer.m_suffix;
        }
        _SetWidth(elContainer);
    }
    function _MakeDigitPanelContents(elContainer) {
        if (!elContainer.IsValid())
            return;
        const elParent = elContainer.GetParent();
        if (!elParent.IsSizeValid()) {
            $.Schedule(0.5, () => _MakeDigitPanelContents(elContainer));
        }
        else {
            const ParentHeight = Math.floor(elParent.actuallayoutheight / elParent.actualuiscale_y);
            elContainer.style.height = ParentHeight + 'px';
            for (let i = 0; i < elContainer.m_nDigits; i++) {
                const elDigit = $.CreatePanel('Panel', elContainer, 'DigitPanel-Digit-' + i);
                elDigit.style.flowChildren = 'down';
                elDigit.AddClass("digitpanel__digit");
                elDigit.style.transitionProperty = 'transform, position';
                elDigit.m_duration = elContainer.m_duration + 's';
                elDigit.style.transitionDuration = elContainer.m_duration + 's';
                elDigit.style.transitionTimingFunction = elContainer.m_timingFunc;
                const arrSymbols = $.Localize(elContainer.m_strDigitsToken).split("");
                arrSymbols.forEach(function (number) {
                    const elNumeralLabel = $.CreatePanel('Label', elDigit, 'DigitPanel-Numeral-' + number);
                    elNumeralLabel.style.textAlign = 'center';
                    elNumeralLabel.style.letterSpacing = '0px';
                    elNumeralLabel.text = number;
                    elNumeralLabel.style.height = ParentHeight + "px";
                    elNumeralLabel.style.horizontalAlign = 'center';
                    elNumeralLabel.AddClass('digitpanel-font');
                });
            }
            _UpdateSuffix(elContainer);
        }
    }
    function _SetWidth(elContainer) {
        if (!elContainer || !elContainer.IsValid())
            return;
        if (!elContainer.IsSizeValid()) {
            $.Schedule(0.1, () => _SetWidth(elContainer));
        }
        else {
            const dig0 = elContainer.FindChildTraverse('DigitPanel-Digit-0');
            const nDigitWidth = Math.ceil(dig0.actuallayoutwidth / dig0.actualuiscale_x);
            let width = elContainer.m_nDigits * nDigitWidth;
            const elSuffixLabel = elContainer.FindChildTraverse('DigitPanel-Suffix');
            if (elSuffixLabel) {
                width += elSuffixLabel.actuallayoutwidth / elSuffixLabel.actualuiscale_x;
            }
            elContainer.style.width = width + 'px';
        }
    }
    function SetDigitPanelString(elParent, string, bInstant = false) {
        if (!elParent || !elParent.IsValid())
            return;
        const elContainer = elParent.FindChildTraverse('DigitPanel');
        if (!elContainer)
            return;
        if (elContainer.m_pendingSetStringHandle !== null) {
            $.CancelScheduled(elContainer.m_pendingSetStringHandle);
            elContainer.m_pendingSetStringHandle = null;
        }
        bInstant ||= elContainer.m_bPendingSetStringInstant;
        if (elContainer.GetChildCount() === 0) {
            elContainer.m_pendingSetStringHandle = $.Schedule(0.1, () => {
                elContainer.m_pendingSetStringHandle = null;
                SetDigitPanelString(elParent, string, bInstant);
            });
            elContainer.m_bPendingSetStringInstant = bInstant;
            return;
        }
        elContainer.m_bPendingSetStringInstant = false;
        const nDigits = elContainer.m_nDigits;
        let arrDigits = String(string).split("");
        const padsNeeded = Math.max(0, nDigits - arrDigits.length);
        if (padsNeeded > 0) {
            const padding = Array(padsNeeded).fill(" ");
            arrDigits = padding.concat(arrDigits);
            arrDigits = arrDigits.slice(0, nDigits);
        }
        const arrSymbols = $.Localize(elContainer.m_strDigitsToken).split("");
        for (let d = nDigits; d >= 0; d--) {
            const symbol = arrDigits[d];
            const elDigit = elContainer.FindChildTraverse('DigitPanel-Digit-' + d);
            if (elDigit) {
                const index = arrSymbols.indexOf(symbol);
                elDigit.visible = d < arrDigits.length;
                if (index >= 0) {
                    elDigit.style.transitionDuration = bInstant ? '0s' : elDigit.m_duration;
                    $.Schedule(0.01, () => {
                        if (elDigit && elDigit.IsValid()) {
                            elDigit.style.transform = "translate3D( " + d + "%," + -Number(index) * 100 + "%, 0px);";
                        }
                    });
                }
            }
        }
        _UpdateSuffix(elContainer);
    }
    DigitPanelFactory.SetDigitPanelString = SetDigitPanelString;
})(DigitPanelFactory || (DigitPanelFactory = {}));
