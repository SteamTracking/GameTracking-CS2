"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../avatar.ts" />
/// <reference path="../digitpanel.ts" />
/// <reference path="../particle_controls.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../common/scheduler.ts" />
/// <reference path="../common/teamcolor.ts" />
var MvpBackgroundMap;
(function (MvpBackgroundMap) {
    function SetUpMapWinPanel(xuid, reason, team, elParent) {
        let strTeam = team === 3 ? 'ct' : 't';
        let mvpCharItemId = GameStateAPI.GetPlayerCharacterItemID(xuid);
        let oSettings;
        let isNonPremier;
        if (!mvpCharItemId)
            mvpCharItemId = LoadoutAPI.GetItemID(strTeam, 'customplayer');
        let teamOverride = $.GetContextPanel().Data().teamOverride;
        if (teamOverride) {
            $.GetContextPanel().SetHasClass('WinPanelRoot--Win--T', $.GetContextPanel().Data().teamOverride === 2);
            $.GetContextPanel().SetHasClass('WinPanelRoot--Win--CT', $.GetContextPanel().Data().teamOverride === 3);
        }
        let mode = $.GetContextPanel().Data().gameModeOverride;
        if (mode && !GameStateAPI.IsQueuedMatchmaking()) {
            mode = $.GetContextPanel().Data().gameModeOverride;
        }
        else {
            if (mode === 'competitive' && GameStateAPI.GetPlayerCompetitiveRankType(xuid) === 'Premier') {
                mode = 'premier';
            }
            else {
                mode = GameStateAPI.GetGameModeInternalName(false);
            }
        }
        isNonPremier = mode.toLowerCase() !== 'premier';
        $.GetContextPanel().SetHasClass('non-premier', isNonPremier);
        let backgroundCharModel = "";
        if (strTeam === 't')
            backgroundCharModel = "agents/models/ctm_sas/ctm_sas.vmdl";
        else
            backgroundCharModel = "agents/models/tm_phoenix/tm_phoenix.vmdl";
        oSettings = {
            mapPanel: elParent.FindChild('id-match-mvp-map'),
            numTeam: team,
            mvpTeam: strTeam,
            mvpCharModel: ItemInfo.GetModelPlayer(mvpCharItemId),
            backgroundCharModel,
            backgroundEntities: ['background_particles_squares', 'background_particles_basic', 'background_particles_vertical']
        };
        SetFlairModel(oSettings, xuid);
        if (isNonPremier) {
            _MvpMapPanelLogicNonPremier(oSettings);
        }
        else {
            switch (reason) {
                case 1:
                    _MvpMapPanelLogicCelebrate(oSettings);
                    break;
                case 2:
                    _MvpMapPanelLogicCelebrate(oSettings);
                    break;
                case 3:
                    _MvpMapPanelLogicCelebrate(oSettings);
                    break;
                case 4:
                    _MvpMapPanelLogicCelebrate(oSettings);
                    break;
                case 5:
                    _MvpMapPanelLogicCelebrate(oSettings);
                    break;
                case 7:
                    _MvpMapPanelLogicCelebrate(oSettings);
                    break;
                case 9:
                    _MvpMapPanelLogicAceRound(oSettings);
                    break;
                case 10:
                    _MvpMapPanelLogicBurnDamage(oSettings);
                    break;
                case 11:
                    _MvpMapPanelLogicBlastDamage(oSettings);
                    break;
                case 12:
                    break;
                case 13:
                    _MvpMapPanelLogicBombPlant(oSettings);
                    break;
                case 14:
                    _MvpMapPanelLogicBombDefuse(oSettings);
                    break;
                case 15:
                    _MvpMapPanelLogicThreeKills(oSettings);
                    break;
                case 16:
                    _MvpMapPanelLogicFourKills(oSettings);
                    break;
            }
        }
    }
    MvpBackgroundMap.SetUpMapWinPanel = SetUpMapWinPanel;
    function MakeMvpMapPanel(elParent) {
        if (elParent.FindChildInLayoutFile('id-match-mvp-map')) {
            elParent.RemoveAndDeleteChildren();
        }
        return $.CreatePanel('MapPlayerPreviewPanel', elParent, 'id-match-mvp-map', {
            "require-composition-layer": "true",
            "pin-fov": "vertical",
            "transparent-background": "false",
            class: 'mvp_map',
            camera: 'camera',
            map: 'ui/match_mvp',
            mouse_rotate: false,
            playername: "mvp_char",
            animgraphcharactermode: "mvp-banner"
        });
    }
    function _MvpMapPanelLogicAceRound(oSettings) {
        let elMap = oSettings.mapPanel;
        let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName('weapon_awp'), 0);
        elMap.TransitionToCamera('camera_start', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(0);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.EquipPlayerWithItem(itemId);
        elMap.PlayBannerAnimation('banner_awp_ace_gun');
        let model = oSettings.backgroundCharModel;
        elMap.SetActiveCharacter(1);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_awp_ace_a');
        elMap.SetActiveCharacter(2);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_awp_ace_b');
        elMap.SetActiveCharacter(3);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_awp_ace_c');
        elMap.SetActiveCharacter(4);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_awp_ace_d');
        elMap.SetActiveCharacter(5);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_awp_ace_e');
        oSettings.playerIndexes = [0, 1, 2, 3, 4, 5];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
        elMap.FireEntityInput("env_effects_ace", "start");
        $.Schedule(1.1, () => {
            elMap.TransitionToCamera('camera', 1.2);
        });
        $.Schedule(1.8, () => {
            elMap.FireEntityInput("card", "Enable");
            elMap.FireEntityInput("card", "SetAnimationNotLooping", "ace_card_anim");
        });
        $.Schedule(2.8, () => {
            elMap.FireEntityInput('mvp_awp_blast', 'Stop');
            elMap.FireEntityInput('mvp_awp_blast', 'Start');
        });
        $.Schedule(2.8, () => {
            elMap.TransitionToCamera('camera_card', .1);
        });
        $.Schedule(10.0, () => {
            elMap.FireEntityInput("card", "Disable");
            elMap.FireEntityInput("card", "SetAnimationNotLooping", "idle_offscreen");
        });
    }
    function _MvpMapPanelLogicThreeKills(oSettings) {
        let elMap = oSettings.mapPanel;
        let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName('weapon_p250'), 0);
        elMap.TransitionToCamera('camera_start', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(0);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.EquipPlayerWithItem(itemId);
        elMap.PlayBannerAnimation('banner_pistol3shot');
        let model = oSettings.backgroundCharModel;
        elMap.SetActiveCharacter(1);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_3shot_a');
        elMap.SetActiveCharacter(2);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_3shot_b');
        elMap.SetActiveCharacter(3);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_3shot_c');
        oSettings.playerIndexes = [0, 1, 2, 3];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
        elMap.FireEntityInput("env_effects_multikill", "Start");
        $.Schedule(1.2, () => {
            elMap.TransitionToCamera('camera', 1);
        });
    }
    function _MvpMapPanelLogicFourKills(oSettings) {
        let elMap = oSettings.mapPanel;
        let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName('weapon_p250'), 0);
        elMap.TransitionToCamera('camera_start', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(0);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.EquipPlayerWithItem(itemId);
        elMap.PlayBannerAnimation('banner_pistol4shot');
        let model = oSettings.backgroundCharModel;
        elMap.SetActiveCharacter(1);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_4shot_a');
        elMap.SetActiveCharacter(2);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_4shot_b');
        elMap.SetActiveCharacter(3);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_4shot_c');
        elMap.SetActiveCharacter(4);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_4shot_d');
        oSettings.playerIndexes = [0, 1, 2, 3, 4];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
        elMap.FireEntityInput("env_effects_multikill", "Start");
        $.Schedule(1.2, () => {
            elMap.TransitionToCamera('camera_4_kill', 1);
        });
    }
    function _MvpMapPanelLogicCelebrate(oSettings) {
        let elMap = oSettings.mapPanel;
        elMap.TransitionToCamera('camera_celebrate', 0);
        HideCharacters(oSettings);
        $.Schedule(.1, () => {
            elMap.TransitionToCamera('camera_start', 3);
        });
        elMap.SetActiveCharacter(6);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.PlayBannerAnimation('celebrate_stretch_noweap_idle0' + (Math.round(Math.random() * 3) + 1));
        oSettings.playerIndexes = [6];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 1;
        SharedMapLogic(oSettings);
    }
    function _MvpMapPanelLogicBombPlant(oSettings) {
        let elMap = oSettings.mapPanel;
        let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName('weapon_c4'), 0);
        elMap.TransitionToCamera('camera_plant', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(12);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.EquipPlayerWithItem(itemId);
        elMap.PlayBannerAnimation('banner_bomb_plant');
        elMap.FireEntityInput('mvp_char12', 'Alpha');
        elMap.SetActiveCharacter(13);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.EquipPlayerWithItem(itemId);
        elMap.PlayBannerAnimation('banner_bomb_plant');
        elMap.FireEntityInput('mvp_background_particles', 'SetControlPoint', '20: 0 0 ' + oSettings.numTeam);
        oSettings.playerIndexes = [13];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
        elMap.FireEntityInput('mvp_chicken', 'Start');
        $.Schedule(3.8, () => {
            elMap.FireEntityInput('mvp_char12', 'Alpha', '255');
        });
        $.Schedule(4.0, () => {
            elMap.FireEntityInput('mvp_bomb_light', 'start');
        });
    }
    function _MvpMapPanelLogicBombDefuse(oSettings) {
        let elMap = oSettings.mapPanel;
        let itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName('weapon_c4'), 0);
        elMap.TransitionToCamera('camera_defuse', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(1);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.EquipPlayerWithItem(itemId);
        elMap.PlayBannerAnimation('banner_bomb_defusal_ver' + (Math.round(Math.random()) + 1));
        elMap.FireEntityInput('mvp_background_particles', 'SetControlPoint', '20: 0 0 ' + oSettings.numTeam);
        oSettings.playerIndexes = [1];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
    }
    function _MvpMapPanelLogicBurnDamage(oSettings) {
        let elMap = oSettings.mapPanel;
        let model = oSettings.backgroundCharModel;
        elMap.TransitionToCamera('camera_start', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(7);
        elMap.SetPlayerModel(model);
        elMap.PlayBannerAnimation('banner_fire');
        elMap.SetActiveCharacter(6);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.PlayBannerAnimation('celebrate_stretch_noweap_idle0' + (Math.round(Math.random() * 3) + 1));
        oSettings.playerIndexes = [6, 7];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
        elMap.FireEntityInput('mvp_burndamage_effects', 'start');
    }
    function _MvpMapPanelLogicBlastDamage(oSettings) {
        let elMap = oSettings.mapPanel;
        elMap.TransitionToCamera('camera_grenade_start', 0);
        HideCharacters(oSettings);
        elMap.SetActiveCharacter(11);
        elMap.SetPlayerModel(oSettings.mvpCharModel);
        elMap.PlayBannerAnimation('banner_bomb_blast_toss');
        elMap.SetActiveCharacter(8);
        elMap.SetPlayerModel(oSettings.backgroundCharModel);
        elMap.PlayBannerAnimation('banner_bomb_blast01');
        elMap.SetActiveCharacter(9);
        elMap.SetPlayerModel(oSettings.backgroundCharModel);
        elMap.PlayBannerAnimation('banner_bomb_blast02');
        elMap.SetActiveCharacter(10);
        elMap.SetPlayerModel(oSettings.backgroundCharModel);
        elMap.PlayBannerAnimation('banner_bomb_blast03');
        oSettings.playerIndexes = [8, 9, 10];
        ShowCharacters(oSettings);
        oSettings.backgroundIndex = 2;
        SharedMapLogic(oSettings);
        $.Schedule(2, () => {
            elMap.TransitionToCamera('camera_grenade', 1);
            elMap.FireEntityInput('mvp_char11', 'Alpha', '255');
        });
        $.Schedule(5, () => {
            elMap.FireEntityInput('mvp_char10', 'Alpha', '0');
        });
    }
    function _MvpMapPanelLogicNonPremier(oSettings) {
        let elMap = oSettings.mapPanel;
        elMap.TransitionToCamera('camera_start', 0);
        $.Schedule(.1, () => {
            elMap.TransitionToCamera('camera_non_premier', 3);
        });
        oSettings.playerIndexes = [];
        HideCharacters(oSettings);
        oSettings.backgroundIndex = 0;
        SharedMapLogic(oSettings);
    }
    function SharedMapLogic(oSettings) {
        let ctLightColor = '67 162 230';
        let tLightColor = '129 107 28';
        oSettings.mapPanel.FireEntityInput('mvp_burndamage_effects', 'Stop');
        oSettings.mapPanel.FireEntityInput("env_effects_multikill", "Stop");
        oSettings.mapPanel.FireEntityInput("env_effects_ace", "Stop");
        oSettings.mapPanel.FireEntityInput('mvp_bomb_light', 'Stop');
        oSettings.mapPanel.FireEntityInput('mvp_chicken', 'Stop');
        oSettings.mapPanel.FireEntityInput('env_effects_basic', 'Stop');
        oSettings.mapPanel.FireEntityInput('mvp_light_spot', 'SetColor', oSettings.mvpTeam === 'ct' ? ctLightColor : tLightColor);
        oSettings.mapPanel.FireEntityInput('mvp_light_spot2', 'SetColor', oSettings.mvpTeam === 'ct' ? ctLightColor : tLightColor);
        SetBackgroundParticles(oSettings);
    }
    function SetBackgroundParticles(oSettings) {
        oSettings.backgroundEntities.forEach(entry => { oSettings.mapPanel.FireEntityInput(entry, 'Stop'); });
        oSettings.mapPanel.FireEntityInput(oSettings.backgroundEntities[oSettings.backgroundIndex], 'Start');
        oSettings.mapPanel.FireEntityInput(oSettings.backgroundEntities[oSettings.backgroundIndex], 'SetControlPoint', '20: 0 0 ' + oSettings.numTeam);
    }
    function HideCharacters(oSettings) {
        let numChars = 13;
        for (let i = 0; i <= numChars; i++) {
            oSettings.mapPanel.FireEntityInput('mvp_char' + i, 'Alpha', '0');
            oSettings.mapPanel.SetActiveCharacter(i);
            oSettings.mapPanel.PlayBannerAnimation('idle_offscreen');
        }
    }
    function ShowCharacters(oSettings) {
        for (let i = 0; i < oSettings.playerIndexes.length; i++) {
            oSettings.mapPanel.FireEntityInput('mvp_char' + oSettings.playerIndexes[i], 'Alpha', '255');
        }
    }
    function SetFlairModel(oSettings, xuid) {
        let flairItemId = InventoryAPI.GetFlairItemId(xuid);
        oSettings.mapPanel.FireEntityInput("item", "SetItem", flairItemId);
    }
})(MvpBackgroundMap || (MvpBackgroundMap = {}));
