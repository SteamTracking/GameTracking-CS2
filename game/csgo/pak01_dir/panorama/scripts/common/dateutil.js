"use strict";
/// <reference path="../csgo.d.ts" />
var DateUtil;
(function (DateUtil) {
    function PopulateDateFormatStrings(panel, date) {
        panel.SetDialogVariableInt('M', date.getMonth() + 1);
        const monthPaddedNumber = ('0' + (date.getMonth() + 1)).slice(-2);
        panel.SetDialogVariable('MM', monthPaddedNumber);
        panel.SetDialogVariable('MMM', $.Localize('#MonthName' + monthPaddedNumber + '_Short'));
        panel.SetDialogVariable('MMMM', $.Localize('#MonthName' + monthPaddedNumber + '_Long'));
        panel.SetDialogVariableInt('d', date.getDate());
        const dayPaddedNumber = ('0' + (date.getDate())).slice(-2);
        panel.SetDialogVariable('dd', dayPaddedNumber);
        panel.SetDialogVariable('ddd', $.Localize('#LOC_Date_DayShort' + date.getDay()));
        panel.SetDialogVariable('dddd', $.Localize('#LOC_Date_Day' + date.getDay()));
    }
    DateUtil.PopulateDateFormatStrings = PopulateDateFormatStrings;
})(DateUtil || (DateUtil = {}));
