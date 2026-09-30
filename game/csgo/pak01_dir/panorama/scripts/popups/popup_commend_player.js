"use strict";
/// <reference path="../csgo.d.ts" />
var PopupCommendPlayer;
(function (PopupCommendPlayer) {
    let m_loadingJob = 0;
    let m_elStatus = null;
    let m_elCommend = null;
    function Init() {
        m_elStatus = $("#id-commend-status");
        m_elCommend = $("#id-commend");
        let xuid = $.GetContextPanel().GetAttributeString("xuid", "");
        $.GetContextPanel().SetDialogVariable("target_player", $.HTMLEscape(GameStateAPI.GetPlayerName(xuid)));
        _Update();
    }
    PopupCommendPlayer.Init = Init;
    function _CancelLoading() {
        m_loadingJob = 0;
        if (m_elStatus && m_elStatus.IsValid()) {
            m_elStatus.text = $.Localize('#SFUI_PlayerDetails_Loading_Failed');
        }
        m_elCommend.visible = false;
    }
    function _ReceivedCommendationFromServer() {
        if (m_loadingJob) {
            $.CancelScheduled(m_loadingJob);
            m_loadingJob = 0;
        }
        _Update();
    }
    function _Update() {
        let xuid = $.GetContextPanel().GetAttributeString("xuid", "");
        let bAskedServersForCommendation = GameStateAPI.QueryServersForCommendation(xuid);
        if (bAskedServersForCommendation) {
            let numTokens = GameStateAPI.GetCommendationTokensAvailable();
            if (numTokens == 0) {
                if (m_elStatus && m_elStatus.IsValid()) {
                    m_elStatus.text = $.Localize("#SFUI_PlayerDetails_NoCommendations_Left");
                }
                m_elCommend.visible = false;
            }
            else {
                if (m_elStatus && m_elStatus.IsValid()) {
                    m_elStatus.SetDialogVariableInt("num_token", numTokens);
                    m_elStatus.text = $.Localize("#Panorama_PlayerDetails_Commendations_Left:f", m_elStatus);
                }
                m_elCommend.visible = true;
            }
            if (m_elCommend.visible) {
                let oCommends = GameStateAPI.GetMyCommendationsJSOForUser(xuid);
                if (oCommends['valid']) {
                    let bHasPrevCommendations = false;
                    $.GetContextPanel().FindChildInLayoutFile("id-commend").Children().forEach(el => {
                        let category = el.GetAttributeString("data-category", "");
                        if (oCommends[category]) {
                            el.checked = true;
                            bHasPrevCommendations = true;
                        }
                    });
                    if (bHasPrevCommendations) {
                        m_elStatus.text = $.Localize("#SFUI_PlayerDetails_Previously_Submitted");
                    }
                }
            }
        }
        else {
            m_loadingJob = $.Schedule(10, _CancelLoading);
            if (m_elStatus && m_elStatus.IsValid()) {
                m_elStatus.text = $.Localize("#SFUI_PlayerDetails_Loading");
            }
            m_elCommend.visible = false;
        }
        $("#id-commend-submit").visible = m_elCommend.visible;
    }
    function Submit() {
        let xuid = $.GetContextPanel().GetAttributeString("xuid", "");
        let commendString = "";
        $.GetContextPanel().FindChildInLayoutFile("id-commend").Children().forEach(el => {
            let category = el.GetAttributeString("data-category", "");
            if (el.checked) {
                commendString += category + ",";
            }
        });
        GameStateAPI.SubmitCommendation(xuid, commendString);
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupCommendPlayer.Submit = Submit;
    {
        $.RegisterForUnhandledEvent("GameState_CommendPlayerQueryResponse", _ReceivedCommendationFromServer);
    }
})(PopupCommendPlayer || (PopupCommendPlayer = {}));
