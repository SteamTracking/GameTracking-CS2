"use strict";
/// <reference path="../csgo.d.ts" />
var CFormattedText = class {
    tag;
    vars;
    constructor(strLocTag, mapDialogVars) {
        this.tag = strLocTag;
        this.vars = Object.assign({}, mapDialogVars);
    }
    SetOnLabel(elLabel) {
        FormatText.SetFormattedTextOnLabel(elLabel, this);
    }
};
var FormatText;
(function (FormatText) {
    function SetFormattedTextOnLabel(elLabel, fmtText) {
        if (!elLabel || !elLabel.IsValid()) {
            return;
        }
        ClearFormattedTextFromLabel(elLabel);
        elLabel.text = fmtText.tag;
        elLabel.fmtTextVars = {};
        for (const varName in fmtText.vars) {
            elLabel.SetDialogVariable(varName, elLabel.html ? $.HTMLEscape(fmtText.vars[varName]) : fmtText.vars[varName]);
            elLabel.fmtTextVars[varName] = true;
        }
    }
    FormatText.SetFormattedTextOnLabel = SetFormattedTextOnLabel;
    function ClearFormattedTextFromLabel(elLabel) {
        elLabel.text = '';
        if (!elLabel.fmtTextVars)
            return;
        for (const varName in elLabel.fmtTextVars) {
            elLabel.SetDialogVariable(varName, '');
        }
        delete elLabel.fmtTextVars;
    }
    function SecondsToDDHHMMSSWithSymbolSeperator(rawSeconds) {
        const time = ConvertSecondsToDaysHoursMinSec(rawSeconds);
        const timeText = [];
        let returnRemaining = false;
        for (const key in time) {
            const value = time[key];
            if ((value > 0 && !returnRemaining) || key == 'minutes')
                returnRemaining = true;
            if (returnRemaining) {
                const valueToShow = (value < 10) ? ('0' + value.toString()) : value.toString();
                timeText.push(valueToShow);
            }
        }
        return timeText.join(':');
    }
    FormatText.SecondsToDDHHMMSSWithSymbolSeperator = SecondsToDDHHMMSSWithSymbolSeperator;
    function SecondsToSignificantTimeString(rawSeconds) {
        rawSeconds = Math.floor(Number(rawSeconds));
        if (rawSeconds < 60)
            return $.ConstructString('#SFUI_Store_Timer_Min:f', { value: 1 });
        const time = ConvertSecondsToDaysHoursMinSec(rawSeconds);
        let timecomponents = ['days', 'hours', 'minutes', 'seconds'];
        for (const idx in timecomponents) {
            const key = timecomponents[idx];
            let value = time[key];
            if (key == 'seconds')
                break;
            if (value <= 0)
                continue;
            let lockey = '#SFUI_Store_Timer_Day:f';
            if (key == 'days') {
                if (time['hours'] > 16)
                    ++value;
            }
            else if (key == 'hours') {
                lockey = '#SFUI_Store_Timer_Hour:f';
                if (time['minutes'] > 40)
                    ++value;
            }
            else if (key == 'minutes') {
                lockey = '#SFUI_Store_Timer_Min:f';
                if (time['seconds'] > 40)
                    ++value;
            }
            return $.ConstructString(lockey, { value: value });
        }
        return $.ConstructString('#SFUI_Store_Timer_Min:f', { value: 1 });
    }
    FormatText.SecondsToSignificantTimeString = SecondsToSignificantTimeString;
    function ConvertSecondsToDaysHoursMinSec(rawSeconds) {
        rawSeconds = Number(rawSeconds);
        const time = {
            days: Math.floor(rawSeconds / 86400),
            hours: Math.floor((rawSeconds % 86400) / 3600),
            minutes: Math.floor(((rawSeconds % 86400) % 3600) / 60),
            seconds: ((rawSeconds % 86400) % 3600) % 60
        };
        return time;
    }
    function PadNumber(integer, digits, char = '0') {
        integer = integer.toString();
        while (integer.length < digits)
            integer = char + integer;
        return integer;
    }
    FormatText.PadNumber = PadNumber;
    function SplitAbbreviateNumber(number, fixed = 0) {
        if (number < 0)
            return -1;
        let pow10 = Math.log10(number) | 0;
        let stringToken = "";
        const locFilePrefix = "#NumberAbbreviation_suffix_E";
        do {
            stringToken = locFilePrefix + [pow10];
            if ($.CanLocalize(stringToken))
                break;
        } while (--pow10 > 0);
        if (!$.CanLocalize(stringToken))
            return [number.toString(), ''];
        const scale = Math.pow(10, pow10);
        const scaledNumber = number / scale;
        const decimals = scaledNumber < 10.0 ? 1 : 0;
        const finalNum = scaledNumber.toFixed(fixed).replace(/\.0+$/, '');
        return [finalNum, $.Localize(stringToken)];
    }
    FormatText.SplitAbbreviateNumber = SplitAbbreviateNumber;
    function AbbreviateNumber(number) {
        if (number < 0)
            return -1;
        let pow10 = Math.log10(number) | 0;
        let stringToken = "";
        const locFilePrefix = "#NumberAbbreviation_E";
        do {
            stringToken = locFilePrefix + [pow10];
            if ($.CanLocalize(stringToken))
                break;
        } while (--pow10 > 0);
        if (!$.CanLocalize(stringToken))
            return number.toString();
        const scale = Math.pow(10, pow10);
        const scaledNumber = number / scale;
        const decimals = scaledNumber < 10.0 ? 1 : 0;
        const finalNum = scaledNumber.toFixed(decimals).replace(/\.0+$/, '');
        $.GetContextPanel().SetDialogVariable('abbreviated_number', finalNum);
        const result = $.Localize(stringToken, $.GetContextPanel());
        return result;
    }
    FormatText.AbbreviateNumber = AbbreviateNumber;
    function FormatRentalTime(expirationDate) {
        let currentDate = Math.trunc(Date.now() / 1000);
        if (expirationDate <= currentDate) {
            return {
                time: '',
                locString: '#item-rental-time-expired',
                isExpired: true
            };
        }
        else {
            let seconds = expirationDate - currentDate;
            return {
                time: FormatText.SecondsToSignificantTimeString(seconds),
                locString: '#item-rental-time-remaining',
                isExpired: false
            };
        }
    }
    FormatText.FormatRentalTime = FormatRentalTime;
    function FormatExpirationToDDHHMMSSWithSymbolSeperator(expirationDate) {
        let currentDate = Math.trunc(Date.now() / 1000);
        if (expirationDate <= currentDate) {
            return {
                time: '',
                locString: '#item-rental-time-expired',
                isExpired: true
            };
        }
        else {
            let seconds = expirationDate - currentDate;
            return {
                time: FormatText.SecondsToDDHHMMSSWithSymbolSeperator(seconds),
                locString: '#item-rental-time-remaining',
                isExpired: false,
                seconds: seconds
            };
        }
    }
    FormatText.FormatExpirationToDDHHMMSSWithSymbolSeperator = FormatExpirationToDDHHMMSSWithSymbolSeperator;
    function FormatPetFoodTimeRemaining(expirationDate) {
        let currentDate = Math.trunc(Date.now() / 1000);
        let seconds = expirationDate - currentDate;
        return {
            time: FormatText.SecondsToSignificantTimeString(seconds),
            locString: '#pet_food_time_remaining',
            isExpired: false
        };
    }
    FormatText.FormatPetFoodTimeRemaining = FormatPetFoodTimeRemaining;
    function FormatNumberToNiceString(value, nsigdigits) {
        let strNum = value.toFixed(nsigdigits);
        strNum = strNum.replace('.', $.Localize('#LOC_Number_DecimalPoint'));
        strNum = strNum.replace(/\B(?=(\d{3})+(?!\d))/g, $.Localize("#LOC_Number_Grouping"));
        return strNum;
    }
    FormatText.FormatNumberToNiceString = FormatNumberToNiceString;
})(FormatText || (FormatText = {}));
