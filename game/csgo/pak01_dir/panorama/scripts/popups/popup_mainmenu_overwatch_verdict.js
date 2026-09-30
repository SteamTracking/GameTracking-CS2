"use strict";
/// <reference path="../csgo.d.ts" />
var overwatch_verdict;
(function (overwatch_verdict) {
    var _verdictTypes = [
        { type: "aimbot", classification: "#Panorama_Overwatch_Major_Disruption", title: "#Panorama_Overwatch_Res_AimHacking", desc: "#SFUI_Overwatch_Res_AimHacking_Desc" },
        // { type:"wallhack",  classification: "#Panorama_Overwatch_Major_Disruption", title:"#Panorama_Overwatch_Res_WallHacking",  desc:"#SFUI_Overwatch_Res_WallHacking_Desc" },
        // { type:"speedhack", classification: "#Panorama_Overwatch_Major_Disruption", title:"#Panorama_Overwatch_Res_SpeedHacking", desc:"#SFUI_Overwatch_Res_SpeedHacking_Desc" },
        // { type:"grief",     classification: "#Panorama_Overwatch_Minor_Disruption", title:"#Panorama_Overwatch_Res_Griefing",     desc:"#SFUI_Overwatch_Res_Griefing_Desc" }
    ];
    var _finalVerdict = "";
    function Init() {
        var elVerdictTypes = $.GetContextPanel().FindChildInLayoutFile('VerdictTypes');
        if (elVerdictTypes === undefined || elVerdictTypes === null)
            return;
        elVerdictTypes.RemoveAndDeleteChildren();
        _verdictTypes.forEach(function (verdict, i) {
            var elVerdict = $.CreatePanel('Panel', elVerdictTypes, 'Verdict' + i);
            elVerdict.BLoadLayoutSnippet('verdict_type');
            elVerdict.SetDialogVariable('verdict_classification', $.Localize(verdict.classification));
            elVerdict.SetDialogVariable('verdict_title', $.Localize(verdict.title));
            elVerdict.SetDialogVariable('verdict_desc', $.Localize(verdict.desc));
            _SetupVerdictButtons(elVerdict.FindChildInLayoutFile('verdict_btn_not_guilty'), verdict);
            // _SetupVerdictButtons( elVerdict.FindChildInLayoutFile( 'verdict_btn_maybe_guilty' ) as RadioButton_t, verdict );
            _SetupVerdictButtons(elVerdict.FindChildInLayoutFile('verdict_btn_guilty'), verdict);
        });
    }
    overwatch_verdict.Init = Init;
    function _SetupVerdictButtons(elButton, verdict) {
        if (elButton === undefined || elButton === null)
            return;
        elButton.group = verdict.type;
        elButton.SetPanelEvent('onselect', _UpdateSubmitButton);
    }
    function _UpdateFinalVerdict() {
        // reset verdict
        _finalVerdict = "";
        var bHasAllVerdict = true;
        _verdictTypes.forEach(function (verdict, i) {
            var elVerdict = $.GetContextPanel().FindChildInLayoutFile('Verdict' + i);
            if (elVerdict === undefined || elVerdict === null)
                return false;
            if (elVerdict.FindChildInLayoutFile('verdict_btn_not_guilty').checked) {
                _finalVerdict += verdict.type + ":dismiss;";
            }
            // else if ( elVerdict.FindChildInLayoutFile( 'verdict_btn_maybe_guilty' ).checked )
            // {
            //     _finalVerdict += verdict.type + ":inconclusive;";
            // }            
            else if (elVerdict.FindChildInLayoutFile('verdict_btn_guilty').checked) {
                _finalVerdict += verdict.type + ":convict;";
            }
            else {
                // didn't select this verdict, stop the loop now
                bHasAllVerdict = false;
                return true;
            }
        });
        return bHasAllVerdict;
    }
    function _UpdateSubmitButton() {
        var btnSubmitVerdict = $.GetContextPanel().FindChildInLayoutFile('SubmitVerdictBtn');
        if (btnSubmitVerdict === undefined || btnSubmitVerdict === null || btnSubmitVerdict.enabled == true)
            return;
        btnSubmitVerdict.enabled = _UpdateFinalVerdict();
    }
    function SubmitVerdict() {
        OverwatchAPI.SubmitCaseVerdict(_finalVerdict);
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    overwatch_verdict.SubmitVerdict = SubmitVerdict;
    ;
})(overwatch_verdict || (overwatch_verdict = {}));
//--------------------------------------------------------------------------------------------------
// Entry point called when panel is created
//--------------------------------------------------------------------------------------------------
(function () {
    overwatch_verdict.Init();
})();
