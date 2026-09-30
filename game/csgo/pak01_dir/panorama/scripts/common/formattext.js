"use strict";
/// <reference path="../csgo.d.ts" />
var CFormattedText = class {
    tag;
    vars;
    constructor(strLocTag, mapDialogVars) {
        this.tag = strLocTag;
        // clone vars to avoid reference mutation behind our back
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
            // TODO: Add 'ClearDialogVariable' to remove a dvar from a panel
            elLabel.SetDialogVariable(varName, '');
        }
        // remove key
        delete elLabel.fmtTextVars;
    }
    /////// time convertions ///////
    function SecondsToDDHHMMSSWithSymbolSeperator(rawSeconds) {
        const time = ConvertSecondsToDaysHoursMinSec(rawSeconds);
        const timeText = [];
        let returnRemaining = false;
        for (const key in time) {
            const value = time[key];
            // Always return minutes and seconds.
            // Don't return empty days hours.
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
            // See if we should bump up the value for better "rounding" purposes
            // and select a different locstring
            let lockey = '#SFUI_Store_Timer_Day:f';
            if (key == 'days') {
                if (time['hours'] > 16)
                    ++value; // round up 17,18,...,23 hours to an extra day
            }
            else if (key == 'hours') {
                lockey = '#SFUI_Store_Timer_Hour:f';
                if (time['minutes'] > 40)
                    ++value; // round up 40+ minutes to an hour
            }
            else if (key == 'minutes') {
                lockey = '#SFUI_Store_Timer_Min:f';
                if (time['seconds'] > 40)
                    ++value; // round up 40+ seconds to a minute
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
        // missing feature: negative number support
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
        // scale the number
        const scaledNumber = number / scale;
        // allow decimals if scaled number is a single digit
        const decimals = scaledNumber < 10.0 ? 1 : 0;
        // trim to one decimal digit, remove ".0", and add the symbol suffix.
        const finalNum = scaledNumber.toFixed(fixed).replace(/\.0+$/, '');
        return [finalNum, $.Localize(stringToken)];
    }
    FormatText.SplitAbbreviateNumber = SplitAbbreviateNumber;
    // this uses language conventions to express large numbers, i.e. "5236.6" as "5.2K"
    // Looks for token "NumberAbbreviation_E" in localization file.
    function AbbreviateNumber(number) {
        // missing feature: negative number support
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
        // scale the number
        const scaledNumber = number / scale;
        // allow decimals if scaled number is a single digit
        const decimals = scaledNumber < 10.0 ? 1 : 0;
        // trim to one decimal digit, remove ".0", and add the symbol suffix.
        const finalNum = scaledNumber.toFixed(decimals).replace(/\.0+$/, '');
        $.GetContextPanel().SetDialogVariable('abbreviated_number', finalNum);
        const result = $.Localize(stringToken, $.GetContextPanel());
        $.Msg(number + " : " + scaledNumber + " : " + result);
        return result;
    }
    FormatText.AbbreviateNumber = AbbreviateNumber;
    function FormatRentalTime(expirationDate) {
        // get total seconds between the times
        let currentDate = Math.trunc(Date.now() / 1000); // Js returns in milliseconds
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
        // get total seconds between the times
        let currentDate = Math.trunc(Date.now() / 1000); // Js returns in milliseconds
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
        // get total seconds between the times
        let currentDate = Math.trunc(Date.now() / 1000); // Js returns in milliseconds
        let seconds = expirationDate - currentDate;
        return {
            time: FormatText.SecondsToSignificantTimeString(seconds),
            locString: '#pet_food_time_remaining',
            isExpired: false
        };
    }
    FormatText.FormatPetFoodTimeRemaining = FormatPetFoodTimeRemaining;
    // localizes decimal points, thousands delimiters, and sets significant digits
    function FormatNumberToNiceString(value, nsigdigits) {
        // sig digits
        let strNum = value.toFixed(nsigdigits);
        // localize decimal
        strNum = strNum.replace('.', $.Localize('#LOC_Number_DecimalPoint'));
        // localize thousanfs
        strNum = strNum.replace(/\B(?=(\d{3})+(?!\d))/g, $.Localize("#LOC_Number_Grouping"));
        return strNum;
    }
    FormatText.FormatNumberToNiceString = FormatNumberToNiceString;
})(FormatText || (FormatText = {}));
