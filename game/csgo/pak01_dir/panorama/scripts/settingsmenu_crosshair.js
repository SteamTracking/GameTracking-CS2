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
        $("#XhairCenterDot").visible = false;
        $("#XhairCenterDotSeparator").visible = false;
        $("#XhairGap").visible = false;
        $("#XhairGapSeparator").visible = false;
        $("#XhairLength").visible = false;
        $("#XhairLengthSeparator").visible = false;
        $("#XhairTStyle").visible = false;
        $("#XhairTStyleSeparator").visible = false;
        $("#XhairDynamicSpreadDist").visible = false;
        $("#XhairDynamicSpreadDistSeparator").visible = false;
        $("#XhairLegacySplitDist").visible = false;
        $("#XhairLegacySplitDistSeparator").visible = false;
        $("#XhairLegacySplitInnerAlpha").visible = false;
        $("#XhairLegacySplitInnerAlphaSeparator").visible = false;
        $("#XhairLegacySplitOuterAlpha").visible = false;
        $("#XhairLegacySplitOuterAlphaSeparator").visible = false;
        $("#XhairLegacySplitRatio").visible = false;
        $("#XhairLegacySplitRatioSeparator").visible = false;
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
        else if (nStyle == 1) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairDynamicSpreadDist").visible = true;
            $("#XhairDynamicSpreadDistSeparator").visible = true;
        }
        else if (nStyle == 2) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
            $("#XhairLength").visible = true;
            $("#XhairLengthSeparator").visible = true;
            $("#XhairTStyle").visible = true;
            $("#XhairTStyleSeparator").visible = true;
            $("#XhairLegacySplitRatio").visible = true;
            $("#XhairLegacySplitRatioSeparator").visible = true;
            $("#XhairLegacySplitDist").visible = true;
            $("#XhairLegacySplitDistSeparator").visible = true;
            $("#XhairLegacySplitInnerAlpha").visible = true;
            $("#XhairLegacySplitInnerAlphaSeparator").visible = true;
            $("#XhairLegacySplitOuterAlpha").visible = true;
            $("#XhairLegacySplitOuterAlphaSeparator").visible = true;
        }
        else if (nStyle == 3) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
        }
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
        else if (nStyle == 6) {
        }
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
        else if (nStyle == 8) {
            $("#XhairCenterDot").visible = true;
            $("#XhairCenterDotSeparator").visible = true;
            $("#XhairGap").visible = true;
            $("#XhairGapSeparator").visible = true;
        }
        $("#CrosshairEditorPreview").SetHasClass("dynamic-crosshair", nStyle === 0 || nStyle === 1 || nStyle === 2 || nStyle === 6);
        let obsCrosshairs = parseInt(GameInterfaceAPI.GetSettingString('cl_show_observer_crosshair'));
        let showObserverBotSetting = (obsCrosshairs === 2);
        $("#XhairObservedBotCrosshair").visible = showObserverBotSetting;
        $("#XhairObservedBotCrosshairSeparator").visible = showObserverBotSetting;
        _RefreshColorDisplay(cp);
        const elStaticColorBox = $("#XhairColorDisplayBox");
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
    }
    SettingsMenuCrosshairSettings.OnCrosshairStyleChange = OnCrosshairStyleChange;
    function _RefreshColorDisplay(cp) {
        let ColorR = GameInterfaceAPI.GetSettingString('cl_crosshaircolor_r');
        let ColorG = GameInterfaceAPI.GetSettingString('cl_crosshaircolor_g');
        let ColorB = GameInterfaceAPI.GetSettingString('cl_crosshaircolor_b');
        cp.FindChildInLayoutFile('XhairColorDisplayBox').style.backgroundColor = 'rgb(' + ColorR + ',' + ColorG + ',' + ColorB + ');';
    }
    function _RefreshControlsRecursive(panel) {
        if (panel == null) {
            return;
        }
        if ('OnShow' in panel) {
            panel.OnShow();
        }
        if (panel.GetChildCount == undefined) {
            return;
        }
        else {
            let nCount = panel.GetChildCount();
            for (let i = 0; i < nCount; i++) {
                let child = panel.GetChild(i);
                _RefreshControlsRecursive(child);
            }
        }
    }
    const k_arrNewCrosshairStyles = [3, 6, 0, 1, 7, 8];
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
        if (!PromotedSettingsUtil.GetUnacknowledgedPromotedSettings().some(setting => setting.id === 'XhairStyle'))
            return;
        const elDropdown = $('#XhairStyleDropdown');
        if (elDropdown) {
            for (const nStyle of k_arrNewCrosshairStyles) {
                const id = 'crosshairstyle' + nStyle;
                const strText = _MakeTagSpan('#settings_new', 'settings-tag--new') + ' ' + $.Localize('#GameUI_CrosshairStyle' + nStyle);
                _SetHtmlText(elDropdown.FindDropDownMenuChild(id), strText);
                _SetHtmlText(elDropdown.FindChild(id), strText);
            }
        }
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
    {
        OnCrosshairStyleChange();
        _TagCrosshairSettings();
        SettingsMenuShared.ChangeBackground(0);
    }
})(SettingsMenuCrosshairSettings || (SettingsMenuCrosshairSettings = {}));
