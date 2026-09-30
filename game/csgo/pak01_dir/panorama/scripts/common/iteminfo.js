"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="formattext.ts" />
/// <reference path="characteranims.ts" />
var ItemInfo;
(function (ItemInfo) {
    function GetFormattedName(id) {
        const strName = InventoryAPI.GetItemNameUncustomized(id);
        const strCustomName = InventoryAPI.GetItemNameCustomized(id);
        if (InventoryAPI.HasCustomName(id)) {
            const splitLoc = strName.indexOf('|');
            let strWeaponName;
            let strPaintName;
            if (splitLoc >= 0) {
                strWeaponName = strName.substring(0, splitLoc).trim();
                strPaintName = strName.substring(splitLoc + 1).trim();
                return new CFormattedText('#CSGO_ItemName_Custom_Painted', { item_name: strWeaponName, paintkit_name: strPaintName, custom_item_name: strCustomName });
            }
            else
                return new CFormattedText('#CSGO_ItemName_Custom_Simple', { item_name: strName, custom_item_name: strCustomName });
        }
        else {
            const splitLoc = strName.indexOf('|');
            if (splitLoc >= 0) {
                const strWeaponName = strName.substring(0, splitLoc).trim();
                const strPaintName = strName.substring(splitLoc + 1).trim();
                return new CFormattedText('#CSGO_ItemName_Painted', { item_name: strWeaponName, paintkit_name: strPaintName });
            }
            return new CFormattedText('#CSGO_ItemName_Base', { item_name: strName });
        }
    }
    ItemInfo.GetFormattedName = GetFormattedName;
    function GetEquippedSlot(id, szTeam) {
        let defIndex = InventoryAPI.GetItemDefinitionIndex(id);
        return LoadoutAPI.GetSlotEquippedWithDefIndex(szTeam, defIndex);
    }
    ItemInfo.GetEquippedSlot = GetEquippedSlot;
    function IsSpraySealed(id) {
        return InventoryAPI.DoesItemMatchDefinitionByName(id, 'spray');
    }
    ItemInfo.IsSpraySealed = IsSpraySealed;
    function IsSprayPaint(id) {
        return InventoryAPI.DoesItemMatchDefinitionByName(id, 'spraypaint');
    }
    ItemInfo.IsSprayPaint = IsSprayPaint;
    function IsTradeUpContract(id) {
        return InventoryAPI.DoesItemMatchDefinitionByName(id, 'Recipe Trade Up');
    }
    ItemInfo.IsTradeUpContract = IsTradeUpContract;
    function ItemHasCapability(id, capName) {
        const caps = [];
        const capCount = InventoryAPI.GetItemCapabilitiesCount(id);
        for (let i = 0; i < capCount; i++) {
            caps.push(InventoryAPI.GetItemCapabilityByIndex(id, i));
        }
        return caps.includes(capName);
    }
    ItemInfo.ItemHasCapability = ItemHasCapability;
    function GetKeyForCaseInXray(caseId) {
        const numActionItems = InventoryAPI.GetChosenActionItemsCount(caseId, 'decodable');
        if (numActionItems > 0) {
            const aKeyIds = [];
            for (let i = 0; i < numActionItems; i++) {
                aKeyIds.push(InventoryAPI.GetChosenActionItemIDByIndex(caseId, 'decodable', i));
            }
            aKeyIds.sort();
            return aKeyIds[0];
        }
        return '';
    }
    ItemInfo.GetKeyForCaseInXray = GetKeyForCaseInXray;
    function GetItemsInXray() {
        InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'xraymachine', '', '');
        const count = InventoryAPI.GetInventoryCount();
        if (count === 0) {
            return {};
        }
        let xrayCaseId = '';
        let xrayRewardId = '';
        for (let i = 0; i < count; i++) {
            const id = InventoryAPI.GetInventoryItemIDByIndex(i);
            xrayRewardId = i === 0 ? id : xrayRewardId;
            xrayCaseId = i === 1 ? id : xrayCaseId;
        }
        return { case: xrayCaseId, reward: xrayRewardId };
    }
    ItemInfo.GetItemsInXray = GetItemsInXray;
    function GetLoadoutWeapons(team) {
        let teamName = CharacterAnims.NormalizeTeamName(team, true);
        const list = [];
        const slotStrings = LoadoutAPI.GetLoadoutSlotNames(false);
        const slots = JSON.parse(slotStrings);
        for (let slot of slots) {
            const weaponItemId = LoadoutAPI.GetItemID(teamName, slot);
            const bIsLoadoutWeapon = ItemInfo.IsWeapon(weaponItemId) || ItemInfo.IsMelee(weaponItemId);
            if (bIsLoadoutWeapon) {
                list.push([slot, weaponItemId]);
            }
        }
        return list;
    }
    ItemInfo.GetLoadoutWeapons = GetLoadoutWeapons;
    function DeepCopyVanityCharacterSettings(inVanityCharacterSettings) {
        const modelRenderSettingsOneOffTempCopy = JSON.parse(JSON.stringify(inVanityCharacterSettings));
        modelRenderSettingsOneOffTempCopy.panel = inVanityCharacterSettings.panel;
        return modelRenderSettingsOneOffTempCopy;
    }
    ItemInfo.DeepCopyVanityCharacterSettings = DeepCopyVanityCharacterSettings;
    function PrecacheVanityCharacterSettings(inVanityCharacterSettings) {
        if (inVanityCharacterSettings.weaponItemId)
            InventoryAPI.PrecacheCustomMaterials(inVanityCharacterSettings.weaponItemId);
        if (inVanityCharacterSettings.glovesItemId)
            InventoryAPI.PrecacheCustomMaterials(inVanityCharacterSettings.glovesItemId);
    }
    ItemInfo.PrecacheVanityCharacterSettings = PrecacheVanityCharacterSettings;
    function GetOrUpdateVanityCharacterSettings(optionalCharacterItemId, optionalState) {
        const oSettings = {
            panel: undefined,
            team: undefined,
            charItemId: undefined,
            loadoutSlot: undefined,
            weaponItemId: undefined,
            glovesItemId: undefined,
            petItemId: undefined,
            cameraPreset: undefined
        };
        if (optionalCharacterItemId && InventoryAPI.IsValidItemID(optionalCharacterItemId)) {
            const charTeam = InventoryAPI.GetItemTeam(optionalCharacterItemId);
            if (charTeam.search('Team_CT') !== -1)
                oSettings.team = 'ct';
            else if (charTeam.search('Team_T') !== -1)
                oSettings.team = 't';
            if (oSettings.team)
                oSettings.charItemId = optionalCharacterItemId;
        }
        if (!oSettings.team) {
            oSettings.team = GameInterfaceAPI.GetSettingString('ui_vanitysetting_team');
            if (oSettings.team !== 'ct' && oSettings.team !== 't') {
                oSettings.team = (Math.round(Math.random()) > 0) ? 'ct' : 't';
                GameInterfaceAPI.SetSettingString('ui_vanitysetting_team', oSettings.team);
            }
        }
        function RollRandomLoadoutSlotAndWeapon(strTeam) {
            const myResult = {
                loadoutSlot: '',
                weaponItemId: ''
            };
            const slots = JSON.parse(LoadoutAPI.GetLoadoutSlotNames(false));
            while (slots.length > 0) {
                slots.splice(slots.indexOf('heavy3'), 1);
                slots.splice(slots.indexOf('heavy4'), 1);
                const nRandomSlotIndex = Math.floor(Math.random() * slots.length);
                myResult.loadoutSlot = slots.splice(nRandomSlotIndex, 1)[0];
                myResult.weaponItemId = LoadoutAPI.GetItemID(strTeam, myResult.loadoutSlot);
                if (ItemInfo.IsWeapon(myResult.weaponItemId) || ItemInfo.IsMelee(myResult.weaponItemId))
                    break;
            }
            return myResult;
        }
        ;
        oSettings.loadoutSlot = GameInterfaceAPI.GetSettingString('ui_vanitysetting_loadoutslot_' + oSettings.team);
        if (!JSON.parse(LoadoutAPI.GetLoadoutSlotNames(false)).includes(oSettings.loadoutSlot))
            oSettings.loadoutSlot = '';
        oSettings.weaponItemId = LoadoutAPI.GetItemID(oSettings.team, oSettings.loadoutSlot);
        if (!(ItemInfo.IsWeapon(oSettings.weaponItemId) || ItemInfo.IsMelee(oSettings.weaponItemId))) {
            const randomResult = RollRandomLoadoutSlotAndWeapon(oSettings.team);
            oSettings.loadoutSlot = randomResult.loadoutSlot;
            oSettings.weaponItemId = randomResult.weaponItemId;
            GameInterfaceAPI.SetSettingString('ui_vanitysetting_loadoutslot_' + oSettings.team, oSettings.loadoutSlot);
        }
        oSettings.glovesItemId = LoadoutAPI.GetItemID(oSettings.team, 'clothing_hands');
        oSettings.petItemId = InventoryAPI.GetPetItemID();
        if (!oSettings.charItemId)
            oSettings.charItemId = LoadoutAPI.GetItemID(oSettings.team, 'customplayer');
        if (optionalState && optionalState === 'unowned') {
            const randomResult = RollRandomLoadoutSlotAndWeapon(oSettings.team);
            oSettings.loadoutSlot = randomResult.loadoutSlot;
            oSettings.weaponItemId = LoadoutAPI.GetDefaultItem(oSettings.team, oSettings.loadoutSlot);
            oSettings.glovesItemId = LoadoutAPI.GetDefaultItem(oSettings.team, 'clothing_hands');
        }
        return oSettings;
    }
    ItemInfo.GetOrUpdateVanityCharacterSettings = GetOrUpdateVanityCharacterSettings;
    function GetitemStickerList(id) {
        const count = InventoryAPI.GetItemStickerCount(id);
        const stickerList = [];
        for (let i = 0; i < count; i++) {
            const oStickerInfo = {
                image: InventoryAPI.GetItemStickerImageByIndex(id, i),
                name: InventoryAPI.GetItemStickerNameByIndex(id, i)
            };
            stickerList.push(oStickerInfo);
        }
        return stickerList;
    }
    ItemInfo.GetitemStickerList = GetitemStickerList;
    function GetitemKeychainList(id) {
        const count = InventoryAPI.GetItemKeychainCount(id);
        const keychainList = [];
        for (let i = 0; i < count; i++) {
            const jsdata = InventoryAPI.GetItemKeychainJsonByIndex(id, i);
            if (jsdata) {
                const o = JSON.parse(jsdata);
                if (o)
                    keychainList.push(o);
            }
        }
        return keychainList;
    }
    ItemInfo.GetitemKeychainList = GetitemKeychainList;
    function GetStoreOriginalPrice(id, count, rules) {
        return StoreAPI.GetStoreItemOriginalPrice(id, count, rules ? rules : '');
    }
    ItemInfo.GetStoreOriginalPrice = GetStoreOriginalPrice;
    function GetStoreSalePrice(id, count, rules) {
        return StoreAPI.GetStoreItemSalePrice(id, count, rules ? rules : '');
    }
    ItemInfo.GetStoreSalePrice = GetStoreSalePrice;
    function IsStatTrak(id) {
        return Number(InventoryAPI.GetRawDefinitionKey(id, "will_produce_stattrak")) === 1;
    }
    ItemInfo.IsStatTrak = IsStatTrak;
    function IsEquippalbleButNotAWeapon(id) {
        const subSlot = InventoryAPI.GetDefaultSlot(id);
        return (subSlot === "flair0" || subSlot === "musickit" || subSlot === "spray0" || subSlot === "customplayer" || subSlot === "pet");
    }
    ItemInfo.IsEquippalbleButNotAWeapon = IsEquippalbleButNotAWeapon;
    function IsEquippableThroughContextMenu(id) {
        const subSlot = InventoryAPI.GetDefaultSlot(id);
        return (subSlot === "flair0" || subSlot === "musickit" || subSlot === "spray0");
    }
    ItemInfo.IsEquippableThroughContextMenu = IsEquippableThroughContextMenu;
    function IsWeapon(id) {
        const itemSchemaDef = BuildItemSchemaDef(id);
        return (itemSchemaDef["craft_class"] === "weapon");
    }
    ItemInfo.IsWeapon = IsWeapon;
    function IsMelee(id) {
        return InventoryAPI.GetLoadoutCategory(id) === "melee";
    }
    ItemInfo.IsMelee = IsMelee;
    function IsCase(id) {
        return ItemInfo.ItemHasCapability(id, 'decodable') && InventoryAPI.GetAssociatedItemsCount(id) > 0;
    }
    ItemInfo.IsCase = IsCase;
    function IsCharacter(id) {
        return InventoryAPI.GetDefaultSlot(id) === "customplayer";
    }
    ItemInfo.IsCharacter = IsCharacter;
    function IsGloves(id) {
        return InventoryAPI.GetDefaultSlot(id) === "clothing_hands";
    }
    ItemInfo.IsGloves = IsGloves;
    function IsItemCt(id) {
        return InventoryAPI.GetItemTeam(id) === '#CSGO_Inventory_Team_CT';
    }
    ItemInfo.IsItemCt = IsItemCt;
    function IsItemT(id) {
        return InventoryAPI.GetItemTeam(id) === '#CSGO_Inventory_Team_T';
    }
    ItemInfo.IsItemT = IsItemT;
    function IsItemAnyTeam(id) {
        return InventoryAPI.GetItemTeam(id) === '#CSGO_Inventory_Team_Any';
    }
    ItemInfo.IsItemAnyTeam = IsItemAnyTeam;
    function ItemDefinitionNameSubstrMatch(id, defSubstr) {
        const itemDefName = InventoryAPI.GetItemDefinitionName(id);
        return (!!itemDefName && (itemDefName.indexOf(defSubstr) != -1));
    }
    ItemInfo.ItemDefinitionNameSubstrMatch = ItemDefinitionNameSubstrMatch;
    function ItemDefinitionNameStartsWith(id, defSubstr) {
        const itemDefName = InventoryAPI.GetItemDefinitionName(id);
        return (!!itemDefName && (itemDefName.startsWith(defSubstr)));
    }
    ItemInfo.ItemDefinitionNameStartsWith = ItemDefinitionNameStartsWith;
    function GetFauxReplacementItemID(id, purpose) {
        if (purpose === 'graffiti') {
            if (ItemDefinitionNameSubstrMatch(id, 'tournament_journal_')) {
                return GetFauxItemIdForGraffiti(parseInt(InventoryAPI.GetItemAttributeValue(id, 'sticker slot 0 id')));
            }
        }
        return id;
    }
    ItemInfo.GetFauxReplacementItemID = GetFauxReplacementItemID;
    function GetFauxItemIdForGraffiti(stickestickerid_graffiti) {
        return InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1349, stickestickerid_graffiti);
    }
    ItemInfo.GetFauxItemIdForGraffiti = GetFauxItemIdForGraffiti;
    function GetItemIdForItemEquippedInSlot(team, slot) {
        return LoadoutAPI.GetItemID(team, slot);
    }
    ItemInfo.GetItemIdForItemEquippedInSlot = GetItemIdForItemEquippedInSlot;
    function GetGifter(id) {
        const xuid = InventoryAPI.GetItemGifterXuid(id);
        return xuid !== undefined ? xuid : '';
    }
    ItemInfo.GetGifter = GetGifter;
    function GetSet(id) {
        const setName = InventoryAPI.GetSet(id);
        return setName !== undefined ? setName : '';
    }
    ItemInfo.GetSet = GetSet;
    function GetModelPath(id, itemSchemaDef) {
        const isMusicKit = InventoryAPI.DoesItemMatchDefinitionByName(id, 'musickit');
        const issMusicKitDefault = InventoryAPI.DoesItemMatchDefinitionByName(id, 'musickit_default');
        const isSpray = itemSchemaDef.name === 'spraypaint';
        const isSprayPaint = itemSchemaDef.name === 'spray';
        const isFanTokenOrShieldItem = itemSchemaDef.name && itemSchemaDef.name.indexOf('tournament_journal_') != -1;
        const isPet = InventoryAPI.DoesItemMatchDefinitionByName(id, 'pet');
        if (isSpray || isSprayPaint || isFanTokenOrShieldItem)
            return 'vmt://spraypreview_' + id;
        else if (IsSticker(id) || IsPatch(id))
            return 'vmt://stickerpreview_' + id;
        else if (itemSchemaDef.hasOwnProperty("model_player") || isMusicKit || issMusicKitDefault || isPet || IsKeychain(id))
            return 'img://inventory_' + id;
    }
    function BuildItemSchemaDef(id) {
        const schemaString = InventoryAPI.BuildItemSchemaDefJSON(id);
        return JSON.parse(schemaString);
    }
    ItemInfo.BuildItemSchemaDef = BuildItemSchemaDef;
    function GetModelPlayer(id) {
        const itemSchemaDef = BuildItemSchemaDef(id);
        return itemSchemaDef["model_player"];
    }
    ItemInfo.GetModelPlayer = GetModelPlayer;
    function IsKeychain(itemId) {
        return InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'keychain');
    }
    ItemInfo.IsKeychain = IsKeychain;
    function IsSticker(itemId) {
        return InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'sticker');
    }
    ItemInfo.IsSticker = IsSticker;
    function IsDisplayItem(itemId) {
        return InventoryAPI.GetDefaultSlot(itemId) == 'flair0';
    }
    ItemInfo.IsDisplayItem = IsDisplayItem;
    function IsPatch(itemId) {
        return InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'patch');
    }
    ItemInfo.IsPatch = IsPatch;
    function IsPet(itemId) {
        return InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'pet') ||
            InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'chicken_egg') ||
            InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'chicken_feed');
    }
    ItemInfo.IsPet = IsPet;
    function GetDefaultCheer(id) {
        const itemSchemaDef = BuildItemSchemaDef(id);
        if (itemSchemaDef["default_cheer"])
            return itemSchemaDef["default_cheer"];
        else
            return "";
    }
    ItemInfo.GetDefaultCheer = GetDefaultCheer;
    function GetDefaultDefeat(id) {
        const itemSchemaDef = BuildItemSchemaDef(id);
        if (itemSchemaDef["default_defeat"])
            return itemSchemaDef["default_defeat"];
        else
            return "";
    }
    ItemInfo.GetDefaultDefeat = GetDefaultDefeat;
    function GetModelPathFromJSONOrAPI(id) {
        if (id === '' || id === undefined || id === null) {
            return '';
        }
        let pedistalModel = '';
        const itemSchemaDef = BuildItemSchemaDef(id);
        if (InventoryAPI.GetDefaultSlot(id) === "flair0") {
            pedistalModel = itemSchemaDef.hasOwnProperty('attributes') ? itemSchemaDef.attributes["pedestal display model"] : '';
        }
        else if (ItemHasCapability(id, 'decodable')) {
            pedistalModel = itemSchemaDef.hasOwnProperty("model_player") ? itemSchemaDef.model_player : '';
        }
        return (pedistalModel === '') ? GetModelPath(id, itemSchemaDef) : pedistalModel;
    }
    ItemInfo.GetModelPathFromJSONOrAPI = GetModelPathFromJSONOrAPI;
    function GetMarketLinkForLootlistItem(id) {
        const appID = SteamOverlayAPI.GetAppID();
        const communityUrl = SteamOverlayAPI.GetSteamCommunityURL();
        const strName = InventoryAPI.GetItemName(id);
        return communityUrl + "/market/search?appid=" + appID + "&lock_appid=" + appID + "&q=" + strName;
    }
    ItemInfo.GetMarketLinkForLootlistItem = GetMarketLinkForLootlistItem;
    function FindAnyUserOwnedCharacterItemID() {
        InventoryAPI.SetInventorySortAndFilters('inv_sort_rarity', false, 'customplayer,not_base_item', '', '');
        const count = InventoryAPI.GetInventoryCount();
        return (count > 0) ? InventoryAPI.GetInventoryItemIDByIndex(0) : '';
    }
    ItemInfo.FindAnyUserOwnedCharacterItemID = FindAnyUserOwnedCharacterItemID;
    function IsFauxOrRentalOrPreviewTool(id) {
        if ((id && id.length == 19 && id.startsWith('922323129721890'))
            || InventoryAPI.IsFauxItemID(id)
            || InventoryAPI.IsRental(id))
            return true;
        else
            return false;
    }
    ItemInfo.IsFauxOrRentalOrPreviewTool = IsFauxOrRentalOrPreviewTool;
    function IsPreviewable(id) {
        return !!InventoryAPI.GetDefaultSlot(id) || IsSticker(id) || IsPatch(id) || IsSpraySealed(id) || IsKeychain(id);
    }
    ItemInfo.IsPreviewable = IsPreviewable;
    function IsNameTag(id) {
        return InventoryAPI.DoesItemMatchDefinitionByName(id, 'name tag');
    }
    ItemInfo.IsNameTag = IsNameTag;
    function IsRecipe(id) {
        return InventoryAPI.DoesItemMatchDefinitionByName(id, 'recipe');
    }
    ItemInfo.IsRecipe = IsRecipe;
    ItemInfo.NUM_BACKPACK_SLOTS = 1000;
})(ItemInfo || (ItemInfo = {}));
