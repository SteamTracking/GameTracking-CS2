"use strict";
/// <reference path="../csgo.d.ts" />
var ContextMenuColorPicker;
(function (ContextMenuColorPicker) {
    function Init() {
        const contextPanel = $.GetContextPanel();
        const contextData = contextPanel.GetParent().GetParent().GetParent().Data();
        if (!contextData.initRGB) {
            $.DispatchEvent('ContextMenuEvent', '');
            return;
        }
        const bShowAlphaUi = ('nInitAlpha' in contextData);
        const { initRGB: oRGB = { r: 0, g: 255, b: 0 }, nInitAlpha = 0, funcCallback } = contextData;
        const elPicker = contextPanel.FindChildInLayoutFile('id-color-picker');
        const elAlphaSliderTrack = elPicker.FindChildInLayoutFile('color-picker-alpha-slider').FindChildInLayoutFile('SliderTrack');
        const hexColor = rgbToHex(oRGB);
        let currentRgb = oRGB;
        let currentAlpha = nInitAlpha;
        const MakeResult = (rgb, alpha) => bShowAlphaUi ? { rgb, alpha } : { rgb };
        $.RegisterEventHandler('CSColorPicked', elPicker, (r, g, b, a) => {
            currentRgb = { r, g, b };
            currentAlpha = a;
            const newHex = rgbToHex(currentRgb);
            elPicker.FindChildInLayoutFile('color-box-new').style.backgroundColor = newHex;
            if (bShowAlphaUi)
                elAlphaSliderTrack.style.backgroundColor = _AlphaGradient(newHex);
            if (funcCallback) {
                const result = MakeResult(currentRgb, currentAlpha);
                _Debounce(elPicker, 'debounceHandler', .3, () => { funcCallback(result); });
            }
        });
        elPicker.SetHasClass('hide-alpha', !bShowAlphaUi);
        elPicker.FindChildInLayoutFile('color-box-current').style.backgroundColor = hexColor;
        elPicker.FindChildInLayoutFile('color-box-new').style.backgroundColor = hexColor;
        elPicker.SetRgb(oRGB.r, oRGB.g, oRGB.b);
        if (bShowAlphaUi) {
            elAlphaSliderTrack.style.backgroundColor = _AlphaGradient(hexColor);
            elPicker.SetAlpha(nInitAlpha);
        }
        contextPanel.FindChildInLayoutFile('id-color-picker-cancel').SetPanelEvent('onactivate', () => {
            if (funcCallback)
                funcCallback(MakeResult(oRGB, nInitAlpha));
            $.DispatchEvent('ContextMenuEvent', '');
        });
        contextPanel.FindChildInLayoutFile('id-color-picker-set').SetPanelEvent('onactivate', () => {
            if (funcCallback)
                funcCallback(MakeResult(currentRgb, currentAlpha));
            $.DispatchEvent('ContextMenuEvent', '');
        });
    }
    ContextMenuColorPicker.Init = Init;
    function _AlphaGradient(hexColor) {
        return "gradient( linear,  0% 0%, 100% 0%, from( " + hexColor + "00 ), to( " + hexColor + ") );";
    }
    function rgbToHex({ r, g, b }) {
        const clamp = (val) => Math.max(0, Math.min(255, val));
        const toHex = (channel) => Math.round(clamp(channel)).toString(16).padStart(2, '0');
        return `#${toHex(r)}${toHex(g)}${toHex(b)}`.toUpperCase();
    }
    function _Debounce(cp, handleName, delay, fnAction) {
        if (cp.Data()[handleName]) {
            $.CancelScheduled(cp.Data()[handleName]);
            cp.Data()[handleName] = null;
        }
        cp.Data()[handleName] = $.Schedule(delay, fnAction);
    }
})(ContextMenuColorPicker || (ContextMenuColorPicker = {}));
