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
        //
        // Structure for this object when passed in is returned
        // from ItemInfo.GetOrUpdateVanityCharacterSettings
        //
        // If we're just trying to update the animations and don't want to clear out the models,
        // e.g. when we're previewing a patch and doing this would throw the patch away,
        // we use bDontStompModel
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
            // Determine the model based off the character item id
            settings.model = ItemInfo.GetModelPlayer(settings.charItemId);
            // we don't use the local agent model. Revert to phoenix or sas
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
            $.Msg("characteranims camera preset " + cam);
        }
    }
    CharacterAnims.PlayAnimsOnPanel = PlayAnimsOnPanel;
    function CancelScheduledAnim(playerPanel) {
        // if we have ever scheduled an animation on this panel then cancel the pending scheduled one
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
        // Get items from loadout, we want to put them first to make sure they are in the list
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
            if (bUniquePerTeamModelsOnly) { // reduce down to one unique model per team
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
