"use strict";
/// <reference path="..//csgo.d.ts" />
var PopupWorkshopModeSelect;
(function (PopupWorkshopModeSelect) {
    let m_elPopup = null;
    let m_elButtonContainer;
    let m_elButtons = [];
    function Init() {
        // Load mode buttons from parameters
        m_elButtons = [];
        m_elPopup = $.GetContextPanel();
        m_elButtonContainer = m_elPopup.FindChildTraverse('popup-workshop-mode-items');
        // enable buttons
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
        // delete all buttons
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
            // find checked button and its mode
            let elSelectedButton = m_elButtons.find(elButton => elButton.checked);
            if (elSelectedButton)
                strGameMode = elSelectedButton.GetAttributeString('data-mode', strGameMode);
        }
        // Look up game type from mode
        let strGameType = GameTypesAPI.GetGameModeType(strGameMode);
        if (!strGameType) {
            // Try looking up skirmish mode
            nSkirmishId = GameTypesAPI.GetSkirmishIdFromInternalName(strGameMode);
            if (nSkirmishId !== 0) {
                strGameMode = 'skirmish';
                strGameType = 'skirmish';
            }
        }
        if (!strGameType) {
            $.Msg("Can't find game mode '" + strGameMode + "'\n");
            // just fall back to casual (should never happen)
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
        // TODO: make 'go' button reappear
    }
    ;
})(PopupWorkshopModeSelect || (PopupWorkshopModeSelect = {}));
/*
    Options {
        anytypemode 0
        server official
        action custommatch
        conteammatch int( 1 = 0x1 )
    }
    Game {
        type classic
        state lobby
        map cs_agency
        search_key k13600
        ark int( 0 = 0x0 )
        apr int( 1 = 0x1 )
        loc
        hosted int( 1 = 0x1 )
        prime int( 1 = 0x1 )
        mode competitive
        mapgroupname mg_de_lite,mg_de_shipped,mg_de_thrill
    }
    System {
        access public
        network LIVE
    }
    members {
        numMachines int( 1 = 0x1 )
        numPlayers int( 1 = 0x1 )
        numSlots int( 5 = 0x5 )
        machine0 {
            id u64( 148618791998277666 = 0x210000100014822 )
            flags u64( 0 = 0x0 )
            numPlayers int( 1 = 0x1 )
            dlcmask u64( 0 = 0x0 )
            tuver 00000000
            ping int( 0 = 0x0 )
            player0 {
                xuid u64( 148618791998277666 = 0x210000100014822 )
                name Gautam
                    game {
                        clanID int( 0 = 0x0 )
                        ranking int( 0 = 0x0 )
                        wins int( 111 = 0x6F )
                        level int( 8 = 0x8 )
                        xppts int( 327683213 = 0x13880C8D )
                        commends [f5][t1][l2]
                        teamcolor int( 0 = 0x0 )
                        prime int( 1 = 0x1 )
                        loc
                    }
                }
            }
        }
    }
*/ 
