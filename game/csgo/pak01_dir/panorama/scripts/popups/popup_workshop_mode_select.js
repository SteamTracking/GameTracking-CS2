"use strict";
/// <reference path="..//csgo.d.ts" />
var PopupWorkshopModeSelect;
(function (PopupWorkshopModeSelect) {
    let m_elPopup = null;
    let m_elButtonContainer;
    let m_elButtons = [];
    function Init() {
        m_elButtons = [];
        m_elPopup = $.GetContextPanel();
        m_elButtonContainer = m_elPopup.FindChildTraverse('popup-workshop-mode-items');
        m_elPopup.FindChildTraverse('GoButton').SetPanelEvent('onactivate', _Apply);
        m_elPopup.FindChildTraverse('CancelButton').SetPanelEvent('onactivate', _Cancel);
        let strModes = m_elPopup.GetAttributeString('workshop-modes', '');
        if (!strModes)
            strModes = 'casual';
        let modes = [];
        modes = strModes.split(',');
        if (modes.length <= 1) {
            _Apply(modes[0]);
            return;
        }
        _InitModes(modes);
    }
    PopupWorkshopModeSelect.Init = Init;
    function _InitModes(modes) {
        m_elButtons.forEach(elButton => elButton.DeleteAsync(0.0));
        m_elButtons = [];
        for (let i = 0; i < modes.length; ++i) {
            let strMode = modes[i];
            if (!strMode) {
                continue;
            }
            let elButton = $.CreatePanel('RadioButton', m_elButtonContainer, undefined);
            elButton.BLoadLayoutSnippet('workshop-mode-item');
            elButton.SetAttributeString('data-mode', strMode);
            elButton.SetDialogVariable('workshop-mode-item-name', $.Localize('#CSGO_Workshop_Mode_' + strMode));
            if (i === 0)
                elButton.checked = true;
            m_elButtons.push(elButton);
        }
    }
    function _Apply(singleModeOverride = '') {
        let strGameMode = 'casual';
        let nSkirmishId = 0;
        if (singleModeOverride !== '') {
            strGameMode = singleModeOverride;
        }
        else {
            let elSelectedButton = m_elButtons.find(elButton => elButton.checked);
            if (elSelectedButton)
                strGameMode = elSelectedButton.GetAttributeString('data-mode', strGameMode);
        }
        let strGameType = GameTypesAPI.GetGameModeType(strGameMode);
        if (!strGameType) {
            nSkirmishId = GameTypesAPI.GetSkirmishIdFromInternalName(strGameMode);
            if (nSkirmishId !== 0) {
                strGameMode = 'skirmish';
                strGameType = 'skirmish';
            }
        }
        if (!strGameType) {
            strGameType = 'classic';
            strGameMode = 'casual';
        }
        let settings = {
            update: {
                Game: {
                    type: strGameType,
                    mode: strGameMode,
                }
            }
        };
        if (nSkirmishId !== 0) {
            settings.update.Game.skirmishmode = nSkirmishId;
        }
        else {
            settings.delete = {
                Game: {
                    skirmishmode: '#empty#'
                }
            };
        }
        $.DispatchEvent('UIPopupButtonClicked', '');
        LobbyAPI.UpdateSessionSettings(settings);
        LobbyAPI.StartMatchmaking("", "", "", "");
    }
    ;
    function _Cancel() {
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    ;
})(PopupWorkshopModeSelect || (PopupWorkshopModeSelect = {}));
