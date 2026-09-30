"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="settingsmenu_shared.ts" />
/// <reference path="common/promoted_settings.ts" />
/// <reference path="context_menus/context_menu_color_picker.ts" />
var SettingsMenuCrosshairSettings;
(function (SettingsMenuCrosshairSettings) {
    function OnCrosshairStyleChange() {
        let nStyle = parseInt(GameInterfaceAPI.GetSettingString('cl_crosshairstyle'));
        const cp = $.GetContextPanel();
        // Hide all style settings
        //-----------------------------------------------------------------------
        $("#XhairCenterDot").visible = false;
        $("#XhairCenterDotSeparator").visible = false;
        $("#XhairGap").visible = false;
        $("#XhairGapSeparator").visible = false;
        $("#XhairClassicGap").visible = false;
        $("#XhairClassicGapSeparator").visible = false;
        $("#XhairLength").visible = false;
        $("#XhairLengthSeparator").visible = false;
        $("#XhairTStyle").visible = false;
        $("#XhairTStyleSeparator").visible = false;
        $("#XhairDynamicSpreadDist").visible = false;
        $("#XhairDynamicSpreadDistSeparator").visible = false;
        $("#XhairClassicSplitDist").visible = false;
        $("#XhairClassicSplitDistSeparator").visible = false;
        $("#XhairClassicSplitInnerAlpha").visible = false;
        $("#XhairClassicSplitInnerAlphaSeparator").visible = false;
        $("#XhairClassicSplitOuterAlpha").visible = false;
        $("#XhairClassicSplitOuterAlphaSeparator").visible = false;
        $("#XhairClassicSplitRatio").visible = false;
        $("#XhairClassicSplitRatioSeparator").visible = false;
        $("#XhairOutlineColorPicker").visible = false;
        $("#XhairOutlineColorPickerSeparator").visible = false;
        $("#XhairStaticQuadSplitRatio").visible = false;
        $("#XhairStaticQuadSplitRatioSeparator").visible = false;
        // Outline color
        //-----------------------------------------------------------------------
        let nDrawOutline = parseInt(GameInterfaceAPI.GetSettingString('cl_crosshair_drawoutline'));
        if (nDrawOutline != 0) {
            $("#XhairOutlineColorPicker").visible = true;
            $("#XhairOutlineColorPickerSeparator").visible = true;
        }
        // Show only relevant settings per style
        //-----------------------------------------------------------------------
        // Dynamic Cross
        if (nStyle == 0) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
            $("#XhairLength").visible = true;
            $("#XhairLengthSeparator").visible = true;
            $("#XhairTStyle").visible = true;
            $("#XhairTStyleSeparator").visible = true;
            $("#XhairDynamicSpreadDist").visible = true;
            $("#XhairDynamicSpreadDistSeparator").visible = true;
        }
        // Dynamic Circle
        else if (nStyle == 1) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairDynamicSpreadDist").visible = true;
            $("#XhairDynamicSpreadDistSeparator").visible = true;
        }
        // Dynamic Cross (Classic)
        else if (nStyle == 2) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairClassicGap").visible = true;
            $("#XhairClassicGapSeparator").visible = true;
            $("#XhairLength").visible = true;
            $("#XhairLengthSeparator").visible = true;
            $("#XhairTStyle").visible = true;
            $("#XhairTStyleSeparator").visible = true;
            $("#XhairClassicSplitRatio").visible = true;
            $("#XhairClassicSplitRatioSeparator").visible = true;
            $("#XhairClassicSplitDist").visible = true;
            $("#XhairClassicSplitDistSeparator").visible = true;
            $("#XhairClassicSplitInnerAlpha").visible = true;
            $("#XhairClassicSplitInnerAlphaSeparator").visible = true;
            $("#XhairClassicSplitOuterAlpha").visible = true;
            $("#XhairClassicSplitOuterAlphaSeparator").visible = true;
        }
        // Static Circle
        else if (nStyle == 3) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
        }
        // Static Cross
        else if (nStyle == 4) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
            $("#XhairLength").visible = true;
            $("#XhairLengthSeparator").visible = true;
            $("#XhairTStyle").visible = true;
            $("#XhairTStyleSeparator").visible = true;
        }
        // Static Cross (Feedback)
        else if (nStyle == 5) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
            $("#XhairLength").visible = true;
            $("#XhairLengthSeparator").visible = true;
            $("#XhairTStyle").visible = true;
            $("#XhairTStyleSeparator").visible = true;
        }
        // Dot-Only
        else if (nStyle == 6) {
            // Nothing
        }
        // Dynamic Quad
        else if (nStyle == 7) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
            $("#XhairLength").visible = true;
            $("#XhairLengthSeparator").visible = true;
            $("#XhairTStyle").visible = true;
            $("#XhairTStyleSeparator").visible = true;
            $("#XhairDynamicSpreadDist").visible = true;
            $("#XhairDynamicSpreadDistSeparator").visible = true;
        }
        // Static Square
        else if (nStyle == 8) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
        }
        // Static Quad
        else if (nStyle == 9) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
            $("#XhairStaticQuadSplitRatio").visible = true;
            $("#XhairStaticQuadSplitRatioSeparator").visible = true;
        }
        // Misc Settings
        //-----------------------------------------------------------------------
        $("#CrosshairEditorPreview").SetHasClass("dynamic-crosshair", nStyle === 0 || nStyle === 1 || nStyle === 2 || nStyle === 6);
        let obsCrosshairs = parseInt(GameInterfaceAPI.GetSettingString('cl_show_observer_crosshair'));
        let showObserverBotSetting = (obsCrosshairs === 2);
        $("#XhairObservedBotCrosshair").visible = showObserverBotSetting;
        $("#XhairObservedBotCrosshairSeparator").visible = showObserverBotSetting;
        // Color
        //-----------------------------------------------------------------------
        _RefreshColorDisplay(cp);
        const elColorBox = $("#XhairColorDisplayBox");
        $("#XhairColorDisplay")?.SetPanelEvent('onactivate', () => {
            let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_color_picker.xml', '');
            contextMenuPanel.AddClass("ContextMenu_NoArrow");
            contextMenuPanel.Data().initRGB = {
                r: parseInt(GameInterfaceAPI.GetSettingString('cl_crosshaircolor_r')),
                g: parseInt(GameInterfaceAPI.GetSettingString('cl_crosshaircolor_g')),
                b: parseInt(GameInterfaceAPI.GetSettingString('cl_crosshaircolor_b'))
            };
            contextMenuPanel.Data().nInitAlpha = parseInt(GameInterfaceAPI.GetSettingString('cl_crosshaircolor_a'));
            contextMenuPanel.Data().funcCallback = (oResult) => {
                if ('rgb' in oResult) {
                    const safeRgb = oResult.rgb;
                    GameInterfaceAPI.SetSettingString('cl_crosshaircolor_r', safeRgb.r.toString());
                    GameInterfaceAPI.SetSettingString('cl_crosshaircolor_g', safeRgb.g.toString());
                    GameInterfaceAPI.SetSettingString('cl_crosshaircolor_b', safeRgb.b.toString());
                    _RefreshColorDisplay(cp);
                }
                if ('alpha' in oResult) {
                    const alphaVal = oResult.alpha;
                    GameInterfaceAPI.SetSettingString('cl_crosshaircolor_a', alphaVal.toString());
                }
            };
        });
        // Outline Color
        //-----------------------------------------------------------------------
        const elOutlineColorBox = $("#XhairOutlineColorDisplayBox");
        $("#XhairOutlineColorDisplay")?.SetPanelEvent('onactivate', () => {
            let contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_color_picker.xml', '');
            contextMenuPanel.AddClass("ContextMenu_NoArrow");
            contextMenuPanel.Data().initRGB = {
                r: parseInt(GameInterfaceAPI.GetSettingString('cl_crosshairoutline_r')),
                g: parseInt(GameInterfaceAPI.GetSettingString('cl_crosshairoutline_g')),
                b: parseInt(GameInterfaceAPI.GetSettingString('cl_crosshairoutline_b'))
            };
            contextMenuPanel.Data().nInitAlpha = parseInt(GameInterfaceAPI.GetSettingString('cl_crosshairoutline_a'));
            contextMenuPanel.Data().funcCallback = (oResult) => {
                if ('rgb' in oResult) {
                    const safeRgb = oResult.rgb;
                    GameInterfaceAPI.SetSettingString('cl_crosshairoutline_r', safeRgb.r.toString());
                    GameInterfaceAPI.SetSettingString('cl_crosshairoutline_g', safeRgb.g.toString());
                    GameInterfaceAPI.SetSettingString('cl_crosshairoutline_b', safeRgb.b.toString());
                    _RefreshColorDisplay(cp);
                }
                if ('alpha' in oResult) {
                    const alphaVal = oResult.alpha;
                    GameInterfaceAPI.SetSettingString('cl_crosshairoutline_a', alphaVal.toString());
                }
            };
        });
    }
    SettingsMenuCrosshairSettings.OnCrosshairStyleChange = OnCrosshairStyleChange;
    function _RefreshColorDisplay(cp) {
        let ColorR = GameInterfaceAPI.GetSettingString('cl_crosshaircolor_r');
        let ColorG = GameInterfaceAPI.GetSettingString('cl_crosshaircolor_g');
        let ColorB = GameInterfaceAPI.GetSettingString('cl_crosshaircolor_b');
        cp.FindChildInLayoutFile('XhairColorDisplayBox').style.backgroundColor = 'rgb(' + ColorR + ',' + ColorG + ',' + ColorB + ');';
        let OutlineR = GameInterfaceAPI.GetSettingString('cl_crosshairoutline_r');
        let OutlineG = GameInterfaceAPI.GetSettingString('cl_crosshairoutline_g');
        let OutlineB = GameInterfaceAPI.GetSettingString('cl_crosshairoutline_b');
        cp.FindChildInLayoutFile('XhairOutlineColorDisplayBox').style.backgroundColor = 'rgb(' + OutlineR + ',' + OutlineG + ',' + OutlineB + ');';
    }
    function _RefreshControlsRecursive(panel) {
        if (panel == null) {
            return;
        }
        if ('OnShow' in panel) {
            panel.OnShow();
        }
        if (panel.GetChildCount == undefined) {
            // This happens sometimes. Not sure why
            return;
        }
        else // We don't have nested settings controls
         {
            let nCount = panel.GetChildCount();
            for (let i = 0; i < nCount; i++) {
                let child = panel.GetChild(i);
                _RefreshControlsRecursive(child);
            }
        }
    }
    // Hardcoded for now: crosshair styles that get an inline "new" tag in the Style dropdown
    const k_arrNewCrosshairStyles = [3, 6, 0, 1, 7, 8, 9];
    // Hardcoded for now: setting rows that get an inline tag after their name (Title label) and a tooltip on the row. tag picks the #settings_<tag> string and settings-tag--<tag> modifier
    const k_arrTaggedCrosshairSettings = [
        { id: 'XhairStyle', loc_name: '#GameUI_CrosshairStyle', tag: 'new', loc_tooltip: '#GameUI_CrosshairUpdated_Style' },
        { id: 'XhairColorPicker', loc_name: '#GameUI_CrosshairColor', tag: 'updated', loc_tooltip: '#GameUI_CrosshairUpdated_Info' },
        { id: 'XhairThickness', loc_name: '#GameUI_CrosshairThickness', tag: 'updated', loc_tooltip: '#GameUI_CrosshairUpdated_Info' },
        { id: 'XhairLength', loc_name: '#GameUI_CrosshairLength', tag: 'updated', loc_tooltip: '#GameUI_CrosshairUpdated_Info' },
        { id: 'XhairGap', loc_name: '#GameUI_CrosshairGap', tag: 'updated', loc_tooltip: '#GameUI_CrosshairUpdated_Info' }
    ];
    function _MakeTagSpan(strLocToken, strModifier) {
        return '<span class="settings-tag ' + strModifier + '"> ' + $.Localize(strLocToken) + ' </span>';
    }
    function _SetHtmlText(el, strText) {
        if (!el)
            return;
        el.html = true;
        el.text = strText;
    }
    function _TagCrosshairSettings() {
        // Only while the crosshair Style promotion counts as new; clears together with the other promoted-setting badges
        if (!PromotedSettingsUtil.GetUnacknowledgedPromotedSettings().some(setting => setting.id === 'XhairStyle'))
            return;
        // "New" in front of the tagged styles in the Style dropdown
        const elDropdown = $('#XhairStyleDropdown');
        if (elDropdown) {
            for (const nStyle of k_arrNewCrosshairStyles) {
                const id = 'crosshairstyle' + nStyle;
                const strText = _MakeTagSpan('#settings_new', 'settings-tag--new') + ' ' + $.Localize('#GameUI_CrosshairStyle' + nStyle);
                // The option in the menu, plus the dropdown's clone of it when it is the current selection
                _SetHtmlText(elDropdown.FindDropDownMenuChild(id), strText);
                _SetHtmlText(elDropdown.FindChild(id), strText);
            }
        }
        // Tag after the name on the tagged rows (each keeps its name in a Title label), plus the tooltip on the row
        for (const setting of k_arrTaggedCrosshairSettings) {
            const elRow = $('#' + setting.id);
            if (!elRow)
                continue;
            const elTitle = elRow.FindChildTraverse('Title');
            _SetHtmlText(elTitle, $.Localize(setting.loc_name) + ' ' + _MakeTagSpan('#settings_' + setting.tag, 'settings-tag--' + setting.tag));
            elRow.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltipOnPanel(elRow, setting.loc_tooltip));
            elRow.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
        }
    }
    // On creation
    {
        OnCrosshairStyleChange();
        _TagCrosshairSettings();
        SettingsMenuShared.ChangeBackground(0);
    }
})(SettingsMenuCrosshairSettings || (SettingsMenuCrosshairSettings = {}));
