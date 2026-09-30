"use strict";
/// <reference path="../csgo.d.ts" />
var CommonUtil;
(function (CommonUtil) {
    const remap_lang_to_region = {
        af: 'za',
        ar: 'sa',
        be: 'by',
        cs: 'cz',
        da: 'dk',
        el: 'gr',
        en: 'gb',
        et: 'ee',
        ga: 'ie',
        he: 'il',
        hi: 'in',
        ja: 'jp',
        kk: 'kz',
        ko: 'kr',
        nn: 'no',
        sl: 'si',
        sr: 'rs',
        sv: 'se',
        uk: 'ua',
        ur: 'pk',
        vi: 'vn',
        zh: 'cn',
        zu: 'za',
    };
    const valid_country_codes = [
        "ae", "ar", "asia", "at", "au", "be", "bg", "br", "by", "ca",
        "cc", "ch", "cl", "cn", "cz", "de", "dk", "dz", "ee", "es",
        "eu", "fi", "fr", "gb", "gp", "gr", "hk", "hr", "hu", "id",
        "ie", "il", "in", "ir", "is", "it", "jp", "kr", "kz", "lt",
        "lu", "lv", "ly", "mk", "mo", "mx", "my", "nam", "nl", "no",
        "nz", "oce", "pe", "ph", "pk", "pl", "pt", "re", "ro", "rs",
        "ru", "sa", "sam", "se", "sg", "si", "sk", "sq", "th", "tr",
        "tw", "ua", "us", "ve", "vn", "za",
    ];
    function SetRegionOnLabel(isoCode, elPanel, tooltip = true) {
        let tooltipString = "";
        if (isoCode) {
            tooltipString = $.Localize("#SFUI_Country_" + isoCode.toUpperCase());
        }
        SetDataOnLabelInternal(isoCode, isoCode, tooltip ? tooltipString : "", elPanel, tooltipString ? false : true);
    }
    CommonUtil.SetRegionOnLabel = SetRegionOnLabel;
    function SetLanguageOnLabel(isoCode, elPanel, tooltip = true) {
        let tooltipString = "";
        let imgCode = isoCode;
        if (isoCode) {
            const sTranslated = $.Localize("#Language_Name_Translated_" + isoCode);
            const sLocal = $.Localize("#Language_Name_Native_" + isoCode);
            if (sTranslated && sLocal && sTranslated === sLocal) {
                tooltipString = sLocal;
            }
            else {
                tooltipString = (sTranslated && sLocal) ? sTranslated + " (" + sLocal + ")" : "";
            }
            if (remap_lang_to_region[isoCode]) {
                imgCode = remap_lang_to_region[isoCode];
            }
        }
        SetDataOnLabelInternal(isoCode, imgCode, tooltip ? tooltipString : "", elPanel, tooltipString ? false : true);
    }
    CommonUtil.SetLanguageOnLabel = SetLanguageOnLabel;
    function SetDataOnLabelInternal(isoCode, imgCode, tooltipString, elPanel, bWarningColor) {
        if (!elPanel)
            return;
        const elLabel = elPanel.FindChildTraverse('JsRegionLabel');
        elLabel.AddClass('visible-if-not-perfectworld');
        if (isoCode) {
            elLabel.text = isoCode.toUpperCase();
            imgCode = imgCode.toLowerCase();
            imgCode = valid_country_codes.indexOf(imgCode) > -1 ? imgCode : "world";
            elLabel.style.backgroundImage = 'url("file://{images}/regions/' + imgCode + '.png")';
            let elTTAnchor = elLabel.FindChildTraverse('region-tt-anchor');
            if (!elTTAnchor) {
                elTTAnchor = $.CreatePanel("Panel", elLabel, elPanel.id + '-region-tt-anchor');
            }
            if (tooltipString) {
                elLabel.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip(elTTAnchor.id, tooltipString));
                elLabel.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
            }
            elLabel.RemoveClass('hidden');
            elLabel.SetHasClass('world-region-label', true);
            elLabel.SetHasClass('world-region-label--image', true);
        }
        else {
            elLabel.AddClass('hidden');
            elLabel.SetHasClass('world-region-label', false);
            elLabel.SetHasClass('world-region-label--image', false);
        }
    }
})(CommonUtil || (CommonUtil = {}));
