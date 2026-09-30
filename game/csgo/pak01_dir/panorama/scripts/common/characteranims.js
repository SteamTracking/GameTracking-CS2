"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="iteminfo.ts" />
var CharacterAnims;
(function (CharacterAnims) {
    function NormalizeTeamName(team, bShort = false) {
        team = String(team).toLowerCase();
        switch (team) {
            case '2':
            case 't':
            case 'terrorist':
            case 'team_t':
                return bShort ? 't' : 'terrorist';
            case '3':
            case 'ct':
            case 'counter-terrorist':
            case 'team_ct':
                return 'ct';
            default:
                return '';
        }
    }
    CharacterAnims.NormalizeTeamName = NormalizeTeamName;
    function PlayAnimsOnPanel(importedSettings, bDontStompModel = false, makeDeepCopy = true) {
        if (importedSettings === null) {
            return;
        }
        const settings = makeDeepCopy ? ItemInfo.DeepCopyVanityCharacterSettings(importedSettings) : importedSettings;
        if (!settings.team || settings.team == "")
            settings.team = 'ct';
        settings.team = NormalizeTeamName(settings.team);
        if (settings.modelOverride) {
            settings.model = settings.modelOverride;
        }
        else {
            settings.model = ItemInfo.GetModelPlayer(settings.charItemId);
            if (!settings.model) {
                if (settings.team == 'ct')
                    settings.model = "agents/models/ctm_sas/ctm_sas.vmdl";
                else
                    settings.model = "agents/models/tm_phoenix/tm_phoenix.vmdl";
            }
        }
        const wid = settings.weaponItemId;
        const playerPanel = settings.panel;
        CancelScheduledAnim(playerPanel);
        ResetLastRandomAnimHandle(playerPanel);
        if (settings.manifest)
            playerPanel.SetScene(settings.manifest, settings.model, false);
        if (!bDontStompModel) {
            playerPanel.SetPlayerCharacterItemID(settings.charItemId);
            playerPanel.SetPlayerModel(settings.model);
        }
        playerPanel.EquipPlayerWithItem(wid);
        playerPanel.EquipPlayerWithItem(settings.glovesItemId);
        playerPanel.EquipPlayerWithPet(settings.petItemId);
        if (settings.cheer != null) {
            playerPanel.ApplyCheer(settings.cheer);
        }
        let cam = 1;
        if (settings.cameraPreset != null) {
            cam = settings.cameraPreset;
        }
    }
    CharacterAnims.PlayAnimsOnPanel = PlayAnimsOnPanel;
    function CancelScheduledAnim(playerPanel) {
        if (playerPanel.Data().handle) {
            $.CancelScheduled(playerPanel.Data().handle);
            playerPanel.Data().handle = null;
        }
    }
    CharacterAnims.CancelScheduledAnim = CancelScheduledAnim;
    function ResetLastRandomAnimHandle(playerPanel) {
        if (playerPanel.Data().lastRandomAnim !== -1) {
            playerPanel.Data().lastRandomAnim = -1;
        }
    }
    function GetValidCharacterModels(bUniquePerTeamModelsOnly) {
        InventoryAPI.SetInventorySortAndFilters('inv_sort_rarity', false, 'customplayer', '', '');
        const count = InventoryAPI.GetInventoryCount();
        let aAllItems = [];
        for (let i = 0; i < count; i++) {
            const itemId = InventoryAPI.GetInventoryItemIDByIndex(i);
            aAllItems.push(itemId);
        }
        let loadoutItemId = LoadoutAPI.GetItemID('ct', 'customplayer');
        aAllItems.unshift(loadoutItemId);
        loadoutItemId = LoadoutAPI.GetItemID('t', 'customplayer');
        aAllItems.unshift(loadoutItemId);
        const itemsList = [];
        const uniqueTracker = {};
        const allItemsCount = aAllItems.length;
        for (let i = 0; i < allItemsCount; i++) {
            const itemId = aAllItems[i];
            const modelplayer = ItemInfo.GetModelPlayer(itemId);
            if (!modelplayer)
                continue;
            const team = (InventoryAPI.GetItemTeam(itemId).search('Team_T') === -1) ? 'ct' : 't';
            if (bUniquePerTeamModelsOnly) {
                if (uniqueTracker.hasOwnProperty(team + modelplayer))
                    continue;
                uniqueTracker[team + modelplayer] = 1;
            }
            const label = InventoryAPI.GetItemName(itemId);
            const entry = {
                label: label,
                team: team,
                itemId: itemId
            };
            itemsList.push(entry);
        }
        return itemsList;
    }
    CharacterAnims.GetValidCharacterModels = GetValidCharacterModels;
})(CharacterAnims || (CharacterAnims = {}));
