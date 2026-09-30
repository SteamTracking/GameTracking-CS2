"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="rating_emblem.ts" />
$.LogChannel('p.mock', "LV_OFF");
var MockAdapter = (function () {
    const k_GetMatchEndWinDataJSO = "k_GetMatchEndWinDataJSO";
    const k_GetScoreDataJSO = "k_GetScoreDataJSO";
    const k_GetPlayerName = "k_GetPlayerName";
    const k_IsFakePlayer = "k_IsFakePlayer";
    const k_XpDataJSO = "k_XpDataJSO";
    const k_XpShopDataJSO = "k_XpShopDataJSO";
    const k_GetGameModeInternalName = "k_GetGameModeInternalName";
    const k_GetGameModeName = "k_GetGameModeName";
    const k_SkillgroupDataJSO = "k_SkillgroupDataJSO";
    const k_DropListJSO = "k_DropListJSO";
    const k_GetTimeDataJSO = "k_GetTimeDataJSO";
    const k_NextMatchVotingData = "k_NextMatchVotingData";
    const k_GetPlayerStatsJSO = "k_GetPlayerStatsJSO";
    const k_GetPlayerDataJSO = "k_GetPlayerDataJSO";
    const k_IsTournamentMatch = "k_IsTournamentMatch";
    const k_GetServerName = "k_GetServerName";
    const k_GetMapName = "k_GetMapName";
    const k_GetTournamentEventStage = "k_GetTournamentEventStage";
    const k_GetGameModeImagePath = "k_GetGameModeImagePath";
    const k_GetMapBSPName = "k_GetMapBSPName";
    const k_GetPlayerTeamName = "k_GetPlayerTeamName";
    const k_GetPlayerTeamNumber = "k_GetPlayerTeamNumber";
    const k_GetTeamNextRoundLossBonus = "k_GetTeamNextRoundLossBonus";
    const k_AreTeamsPlayingSwitchedSides = "k_AreTeamsPlayingSwitchedSides";
    const k_AreTeamsPlayingSwitchedSidesInRound = "k_AreTeamsPlayingSwitchedSidesInRound";
    const k_HasHalfTime = "k_HasHalfTime";
    const k_IsDemoOrHltv = "k_IsDemoOrHltv";
    const k_IsHLTVAutodirectorOn = "k_IsHLTVAutodirectorOn";
    const k_GetTeamLogoImagePath = "k_GetTeamLogoImagePath";
    const k_GetTeamLivingPlayerCount = "k_GetTeamLivingPlayerCount";
    const k_GetTeamTotalPlayerCount = "k_GetTeamTotalPlayerCount";
    const k_GetTeamClanName = "k_GetTeamClanName";
    const k_IsXuidValid = "k_IsXuidValid";
    const k_GetPlayerSlot = "k_GetPlayerSlot";
    const k_GetLocalPlayerXuid = "k_GetLocalPlayerXuid";
    const k_IsLocalPlayerHLTV = "k_IsLocalPlayerHLTV";
    const k_GetPlayerStatus = "k_GetPlayerStatus";
    const k_GetPlayerCommendsLeader = "k_GetPlayerCommendsLeader";
    const k_GetPlayerCommendsFriendly = "k_GetPlayerCommendsFriendly";
    const k_GetPlayerCommendsTeacher = "k_GetPlayerCommendsTeacher";
    const k_GetPlayerCompetitiveRanking = "k_GetPlayerCompetitiveRanking";
    const k_GetPlayerCompetitiveWins = "k_GetPlayerCompetitiveWins";
    const k_GetPlayerXpLevel = "k_GetPlayerXpLevel";
    const k_GetPlayerScore = "k_GetPlayerScore";
    const k_GetPlayerMVPs = "k_GetPlayerMVPs";
    const k_GetPlayerKills = "k_GetPlayerKills";
    const k_GetPlayerRoundKills = "k_GetPlayerRoundKills";
    const k_GetPlayerAssists = "k_GetPlayerAssists";
    const k_GetPlayerDeaths = "k_GetPlayerDeaths";
    const k_GetPlayerPing = "k_GetPlayerPing";
    const k_GetPlayerColor = "k_GetPlayerColor";
    const k_HasCommunicationAbuseMute = "k_HasCommunicationAbuseMute";
    const k_IsSelectedPlayerMuted = "IsSelectedPlayerMuted";
    const k_IsPlayerConnected = "k_IsPlayerConnected";
    const k_ArePlayersEnemies = "k_ArePlayersEnemies";
    const k_GetPlayerClanTag = "k_GetPlayerClanTag";
    const k_GetPlayerMoney = "k_GetPlayerMoney";
    const k_GetPlayerActiveWeaponItemId = "k_GetPlayerActiveWeaponItemId";
    const k_GetPlayerModel = "k_GetPlayerModel";
    const k_GetPlayerItemCT = "k_GetPlayerItemCT";
    const k_GetPlayerItemTerrorist = "k_GetPlayerItemTerrorist";
    const k_AccoladesJSO = "k_AccoladesJSO";
    const k_GetCharacterDefaultCheerByXuid = "k_GetCharacterDefaultCheerByXuid";
    const k_GetAllPlayersMatchDataJSO = "k_GetAllPlayersMatchDataJSO";
    const k_GetPlayerCharacterItemID = "k_GetPlayerCharacterItemID";
    const k_GetFauxItemIDFromDefAndPaintIndex = "k_GetFauxItemIDFromDefAndPaintIndex";
    const k_GetPlayerCompetitiveRankType = "k_GetPlayerCompetitiveRankType";
    const k_bSkillgroupDataReady = "k_bSkillgroupDataReady";
    const k_GetPipRankCount = "k_GetPipRankCount";
    const k_GetPlayerPremierRankStatsObject = "k_GetPlayerPremierRankStatsObject";
    const k_bXpDataReady = "k_bXpDataReady";
    const k_bXpShopDataReady = "k_bXpShopDataReady";
    var _m_mockData = _GetMockData();
    function _GetRootPanel() {
        let parent = $.GetContextPanel().GetParent();
        let newParent = parent.GetParent();
        while (newParent) {
            parent = newParent;
            newParent = parent.GetParent();
        }
        return parent;
    }
    function _SetMockData(dummydata) {
        let elRoot = _GetRootPanel();
        elRoot.Data().m_mockData = dummydata;
    }
    function _GetMockData() {
        let elRoot = _GetRootPanel();
        if (!elRoot.Data().hasOwnProperty('m_mockData'))
            return undefined;
        else
            return elRoot.Data().m_mockData;
    }
    function _GetMockTables() {
        let elRoot = _GetRootPanel();
        if (!elRoot.Data().hasOwnProperty('m_mockTables'))
            return undefined;
        else
            return elRoot.Data().m_mockTables;
    }
    function _AddTable(name, table) {
        let elRoot = _GetRootPanel();
        if (!elRoot.Data().hasOwnProperty('m_mockTables'))
            elRoot.Data().m_mockTables = {};
        elRoot.Data().m_mockTables[name] = table;
    }
    function FindMockTable(key) {
        const arrTablesInUse = _m_mockData.split(',');
        for (let group of arrTablesInUse) {
            let mockTables = _GetMockTables();
            if (mockTables && mockTables.hasOwnProperty(group) && mockTables[group].hasOwnProperty(key)) {
                return mockTables[group];
            }
        }
        return undefined;
    }
    function _APIAccessor(val, key, xuid = -1) {
        if (!_m_mockData) {
            return val;
        }
        const table = FindMockTable(key);
        if (!table) {
            return val;
        }
        let tableVal;
        if (xuid !== -1 && table[key].hasOwnProperty(xuid)) {
            tableVal = table[key][xuid];
        }
        else if (xuid !== -1 && !table[key].hasOwnProperty(xuid)) {
            tableVal = table[key][0];
        }
        else {
            tableVal = table[key];
        }
        if (tableVal && typeof tableVal === "function") {
            return tableVal(xuid);
        }
        else {
            return tableVal;
        }
    }
    const _getLoadoutWeapons = function (team) {
        const list = [];
        const slotStrings = LoadoutAPI.GetLoadoutSlotNames(false);
        const slots = JSON.parse(slotStrings);
        slots.forEach(slot => {
            const itemId = LoadoutAPI.GetItemID(team, slot);
            const bIsWeapon = ItemInfo.IsWeapon(itemId) || ItemInfo.IsMelee(itemId);
            if (bIsWeapon) {
                list.push(itemId);
            }
        });
        return list;
    };
    function _GetRandomWeaponFromLoadout() {
        const team = (_m_mockData.search('team_ct') !== -1) ? 'ct' : 't';
        const list = _getLoadoutWeapons(team);
        return list[_r(0, list.length)];
    }
    function _GetRandomPlayerStatsJSO(xuid) {
        const oPlayerStats = { "damage": 0, "kills": 0, "assists": 0, "deaths": 0, "adr": 0, "kdr": 0, "3k": 0, "4k": 0, "5k": 0, "headshotkills": 0, "hsp": 0, "worth": 0, "killreward": 0, "cashearned": 99, "livetime": 0, "objective": 0, "utilitydamage": 0, "enemiesflashed": 0 };
        Object.keys(oPlayerStats).forEach(stat => {
            oPlayerStats[stat] = _r();
        });
        return oPlayerStats;
    }
    function _r(min = 0, max = 100) {
        return Math.round(Math.random() * ((max - min) + min) + 0.5);
    }
    ;
    function _GetRandomXP() {
        const ret = {
            xp_earned: {
                "2": _r(0, 1000),
                "6": _r(0, 1000),
            },
            current_level: _r(0, 39),
            current_xp: _r(0, 4999),
        };
        return ret;
    }
    function _GetRandomSkillGroup() {
        const oldrank = _r(1, 18);
        const newrank = oldrank + _r(-1, 1);
        const ret = {
            "old_rank": oldrank,
            "new_rank": newrank,
            "num_wins": _r(10, 1000),
            "rank_change": newrank - oldrank,
            "rank_type": "Premier"
        };
        return ret;
    }
    function _GetRandomPlayerModel(team) {
        const PlayerModels = {
            "ct": [
                "agents/models/ctm_fbi/ctm_fbi.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_varianta.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_variantb.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_variantc.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_variantd.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_variante.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_varianth.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_variantf.vmdl",
                "agents/models/ctm_fbi/ctm_fbi_variantg.vmdl",
                "agents/models/ctm_st6.vmdl",
                "agents/models/ctm_st6_varianta.vmdl",
                "agents/models/ctm_st6_variantb.vmdl",
                "agents/models/ctm_st6_variantc.vmdl",
                "agents/models/ctm_st6_variantd.vmdl",
                "agents/models/ctm_st6_varianti.vmdl",
                "agents/models/ctm_st6_variantm.vmdl",
                "agents/models/ctm_st6_variantg.vmdl",
                "agents/models/ctm_st6_variantk.vmdl",
                "agents/models/ctm_st6_variante.vmdl",
                "agents/models/ctm_gign/ctm_gign.vmdl",
                "agents/models/ctm_gign/ctm_gign_varianta.vmdl",
                "agents/models/ctm_gign/ctm_gign_variantb.vmdl",
                "agents/models/ctm_gign/ctm_gign_variantc.vmdl",
                "agents/models/ctm_gign/ctm_gign_variantd.vmdl",
                "agents/models/ctm_gsg9.vmdl",
                "agents/models/ctm_gsg9_varianta.vmdl",
                "agents/models/ctm_gsg9_variantb.vmdl",
                "agents/models/ctm_gsg9_variantc.vmdl",
                "agents/models/ctm_gsg9_variantd.vmdl",
                "agents/models/ctm_idf/ctm_idf.vmdl",
                "agents/models/ctm_idf/ctm_idf_variantb.vmdl",
                "agents/models/ctm_idf/ctm_idf_variantc.vmdl",
                "agents/models/ctm_idf/ctm_idf_variantd.vmdl",
                "agents/models/ctm_idf/ctm_idf_variante.vmdl",
                "agents/models/ctm_idf/ctm_idf_variantf.vmdl",
                "agents/models/ctm_sas/ctm_sas.vmdl",
                "agents/models/ctm_sas/ctm_sas_variantf.vmdl",
                "agents/models/ctm_swat/ctm_swat.vmdl",
                "agents/models/ctm_swat/ctm_swat_varianta.vmdl",
                "agents/models/ctm_swat/ctm_swat_variantb.vmdl",
                "agents/models/ctm_swat/ctm_swat_variantc.vmdl",
                "agents/models/ctm_swat/ctm_swat_variantd.vmdl",
                "agents/models/ctm_heavy/ctm_heavy.vmdl",
            ],
            "t": [
                "agents/models/tm_balkan/tm_balkan_variante.vmdl",
                "agents/models/tm_balkan/tm_balkan_varianta.vmdl",
                "agents/models/tm_balkan/tm_balkan_variantb.vmdl",
                "agents/models/tm_balkan/tm_balkan_variantc.vmdl",
                "agents/models/tm_balkan/tm_balkan_variantd.vmdl",
                "agents/models/tm_balkan/tm_balkan_variantf.vmdl",
                "agents/models/tm_balkan/tm_balkan_variantg.vmdl",
                "agents/models/tm_balkan/tm_balkan_varianth.vmdl",
                "agents/models/tm_balkan/tm_balkan_varianti.vmdl",
                "agents/models/tm_balkan/tm_balkan_variantj.vmdl",
                "agents/models/tm_leet/tm_leet_variante.vmdl",
                "agents/models/tm_leet/tm_leet_varianta.vmdl",
                "agents/models/tm_leet/tm_leet_variantb.vmdl",
                "agents/models/tm_leet/tm_leet_variantc.vmdl",
                "agents/models/tm_leet/tm_leet_variantd.vmdl",
                "agents/models/tm_leet/tm_leet_variantf.vmdl",
                "agents/models/tm_leet/tm_leet_varianth.vmdl",
                "agents/models/tm_leet/tm_leet_variantg.vmdl",
                "agents/models/tm_leet/tm_leet_varianti.vmdl",
                "agents/models/tm_anarchist/tm_anarchist.vmdl",
                "agents/models/tm_anarchist/tm_anarchist_varianta.vmdl",
                "agents/models/tm_anarchist/tm_anarchist_variantb.vmdl",
                "agents/models/tm_anarchist/tm_anarchist_variantc.vmdl",
                "agents/models/tm_anarchist/tm_anarchist_variantd.vmdl",
                "agents/models/tm_phoenix/tm_phoenix.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_varianta.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_variantb.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_variantc.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_variantd.vmdl",
                "agents/models/tm_pirate/tm_pirate.vmdl",
                "agents/models/tm_pirate/tm_pirate_varianta.vmdl",
                "agents/models/tm_pirate/tm_pirate_variantb.vmdl",
                "agents/models/tm_pirate/tm_pirate_variantc.vmdl",
                "agents/models/tm_pirate/tm_pirate_variantd.vmdl",
                "agents/models/tm_professional/tm_professional.vmdl",
                "agents/models/tm_professional_const1.vmdl",
                "agents/models/tm_professional_const2.vmdl",
                "agents/models/tm_professional_const3.vmdl",
                "agents/models/tm_professional_const4.vmdl",
                "agents/models/tm_separatist/tm_separatist.vmdl",
                "agents/models/tm_separatist/tm_separatist_varianta.vmdl",
                "agents/models/tm_separatist/tm_separatist_variantb.vmdl",
                "agents/models/tm_separatist/tm_separatist_variantc.vmdl",
                "agents/models/tm_separatist/tm_separatist_variantd.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_variantg.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_variante.vmdl",
                "agents/models/tm_phoenix/tm_phoenix_variantf.vmdl",
                "agents/models/tm_phoenix_heavy/tm_phoenix_heavy.vmdl",
            ]
        };
        return PlayerModels[team][Math.floor(Math.random() * PlayerModels[team].length)];
    }
    function _GetRandomAccolades() {
        function _GetRandomAccoladeTitle() {
            const titles = [
                "kills",
                "damage",
                "adr",
                "mvps",
                "assists",
                "hsp",
                "3k",
                "4k",
                "5k",
                "headshotkills",
                "killreward",
                "utilitydamage",
                "enemiesflashed",
                "objective",
                "worth",
                "score",
                "livetime",
                "deaths",
                "nopurchasewins",
                "clutchkills",
                "footsteps",
                "pistolkills",
                "firstkills",
                "sniperkills",
                "roundssurvived",
                "chickenskilled",
                "killswhileblind",
                "bombcarrierkills",
                "burndamage",
                "cashspent",
                "uniqueweaponkills",
                "gimme_01",
                "gimme_02",
                "gimme_03",
                "gimme_04",
                "gimme_05",
                "gimme_06",
            ];
            return titles[Math.floor(Math.random() * titles.length)];
        }
        function _GetRandomAccolade(xuid) {
            const name = _GetRandomAccoladeTitle();
            const pos = name.includes("gimme_") ? 1 : 1 + Math.floor(Math.random() * 2);
            const accolade = {
                accolade: name,
                value: Math.floor(Math.random() * 1000),
                xuid: xuid,
                position: pos
            };
            return accolade;
        }
        const oAccolades = {
            titles: [
                _GetRandomAccolade(1),
                _GetRandomAccolade(3),
                _GetRandomAccolade(5),
                _GetRandomAccolade(7),
                _GetRandomAccolade(9),
                _GetRandomAccolade(2),
                _GetRandomAccolade(4),
                _GetRandomAccolade(6),
                _GetRandomAccolade(8),
                _GetRandomAccolade(10),
                _GetRandomAccolade(11),
                _GetRandomAccolade(13),
                _GetRandomAccolade(15),
                _GetRandomAccolade(17),
                _GetRandomAccolade(19),
                _GetRandomAccolade(12),
                _GetRandomAccolade(14),
                _GetRandomAccolade(16),
                _GetRandomAccolade(18),
                _GetRandomAccolade(20),
            ]
        };
        return oAccolades;
    }
    function _InternalGetFauxItemId(defid, paintid) {
        return String(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defid, paintid));
    }
    function _GetRandomModelDefIndex(teamnum) {
        const models = [
            [],
            [],
            [
                4780,
                4777,
                4774,
            ],
            [
                4771,
                4757,
                4751
            ],
        ];
        const random = _r(0, 2);
        return (models[teamnum][random]);
    }
    let MOCK_TABLE = {};
    return {
        AddTable: _AddTable,
        GetMatchEndWinDataJSO: function _APIGetMatchEndWinDataJSO() { return _APIAccessor(GameStateAPI.GetMatchEndWinDataJSO(), k_GetMatchEndWinDataJSO); },
        GetScoreDataJSO: function _GetScoreDataJSO() { return _APIAccessor(GameStateAPI.GetScoreDataJSO(), k_GetScoreDataJSO); },
        GetPlayerName: function _GetPlayerName(xuid) { return _APIAccessor(GameStateAPI.GetPlayerName(xuid), k_GetPlayerName, xuid); },
        IsFakePlayer: function _IsFakePlayer(xuid) { return _APIAccessor(GameStateAPI.IsFakePlayer(xuid), k_IsFakePlayer); },
        XPDataJSO: function _XPDataJSO(panel) { return _APIAccessor(panel.XpDataJSO, k_XpDataJSO); },
        XPShopDataJSO: function _XPShopDataJSO(panel) { return _APIAccessor(panel.XpShopDataJSO, k_XpShopDataJSO); },
        GetGameModeInternalName: function _GetGameModeInternalName(bUseSkirmishName) { return _APIAccessor(GameStateAPI.GetGameModeInternalName(bUseSkirmishName), k_GetGameModeInternalName); },
        GetGameModeName: function _GetGameModeName(bUseSkirmishName) { return _APIAccessor(GameStateAPI.GetGameModeName(bUseSkirmishName), k_GetGameModeName); },
        SkillgroupDataJSO: function _SkillgroupDataJSO(panel) { return _APIAccessor(panel.SkillgroupDataJSO, k_SkillgroupDataJSO); },
        DropListJSO: function _DropListJSO(panel) { return _APIAccessor(panel.DropListJSO, k_DropListJSO); },
        GetTimeDataJSO: function _GetTimeDataJSO() { return _APIAccessor(GameStateAPI.GetTimeDataJSO(), k_GetTimeDataJSO); },
        NextMatchVotingData: function _NextMatchVotingData(panel) { return _APIAccessor(panel.NextMatchVotingData, k_NextMatchVotingData); },
        GetPlayerStatsJSO: function _GetPlayerStatsJSO(xuid) { return _APIAccessor(MatchStatsAPI.GetPlayerStatsJSO(xuid), k_GetPlayerStatsJSO, xuid); },
        GetPlayerDataJSO: function _GetPlayerDataJSO() { return _APIAccessor(GameStateAPI.GetPlayerDataJSO(), k_GetPlayerDataJSO); },
        IsTournamentMatch: function _IsTournamentMatch() { return _APIAccessor(MatchStatsAPI.IsTournamentMatch(), k_IsTournamentMatch); },
        GetServerName: function _GetServerName() { return _APIAccessor(GameStateAPI.GetServerName(), k_GetServerName); },
        GetMapName: function _GetMapName() { return _APIAccessor(GameStateAPI.GetMapName(), k_GetMapName); },
        GetTournamentEventStage: function _GetTournamentEventStage() { return _APIAccessor(GameStateAPI.GetTournamentEventStage(), k_GetTournamentEventStage); },
        GetGameModeImagePath: function _GetGameModeImagePath() {
            const path = GameStateAPI.GetGameModeImagePath();
            const modPath = _APIAccessor(path, k_GetGameModeImagePath);
            if (typeof modPath === 'string') {
                return modPath;
            }
            return path;
        },
        GetMapBSPName: function _GetMapBSPName() { return _APIAccessor(GameStateAPI.GetMapBSPName(), k_GetMapBSPName); },
        GetPlayerTeamName: function _GetPlayerTeamName(xuid) { return _APIAccessor(GameStateAPI.GetPlayerTeamName(xuid), k_GetPlayerTeamName, xuid); },
        GetPlayerTeamNumber: function _GetPlayerTeamNumber(xuid) { return _APIAccessor(GameStateAPI.GetPlayerTeamNumber(xuid), k_GetPlayerTeamNumber, xuid); },
        GetTeamNextRoundLossBonus: function _GetTeamNextRoundLossBonus(team) { return _APIAccessor(GameStateAPI.GetTeamNextRoundLossBonus(team), k_GetTeamNextRoundLossBonus); },
        AreTeamsPlayingSwitchedSides: function _AreTeamsPlayingSwitchedSides() { return _APIAccessor(GameStateAPI.AreTeamsPlayingSwitchedSides(), k_AreTeamsPlayingSwitchedSides); },
        AreTeamsPlayingSwitchedSidesInRound: function _AreTeamsPlayingSwitchedSidesInRound(rnd) { return _APIAccessor(GameStateAPI.AreTeamsPlayingSwitchedSidesInRound(rnd), k_AreTeamsPlayingSwitchedSidesInRound); },
        HasHalfTime: function _HasHalfTime() { return _APIAccessor(GameStateAPI.HasHalfTime(), k_HasHalfTime); },
        IsDemoOrHltv: function _IsDemoOrHltv() { return _APIAccessor(GameStateAPI.IsDemoOrHltv(), k_IsDemoOrHltv); },
        IsHLTVAutodirectorOn: function _IsHLTVAutodirectorOn() { return _APIAccessor(GameStateAPI.IsHLTVAutodirectorOn(), k_IsHLTVAutodirectorOn); },
        GetTeamLogoImagePath: function _GetTeamLogoImagePath(team) { return _APIAccessor(GameStateAPI.GetTeamLogoImagePath(team), k_GetTeamLogoImagePath); },
        GetTeamLivingPlayerCount: function _GetTeamLivingPlayerCount(team) { return _APIAccessor(GameStateAPI.GetTeamLivingPlayerCount(team), k_GetTeamLivingPlayerCount); },
        GetTeamTotalPlayerCount: function _GetTeamTotalPlayerCount(team) { return _APIAccessor(GameStateAPI.GetTeamTotalPlayerCount(team), k_GetTeamTotalPlayerCount); },
        GetTeamClanName: function _GetTeamClanName(team) { return _APIAccessor(GameStateAPI.GetTeamClanName(team), k_GetTeamClanName, team); },
        IsXuidValid: function _IsXuidValid(xuid) { return _APIAccessor(GameStateAPI.IsXuidValid(xuid), k_IsXuidValid); },
        GetPlayerSlot: function _GetPlayerSlot(xuid) { return _APIAccessor(GameStateAPI.GetPlayerSlot(xuid), k_GetPlayerSlot, xuid); },
        GetLocalPlayerXuid: function _GetLocalPlayerXuid() { return _APIAccessor(GameStateAPI.GetLocalPlayerXuid(), k_GetLocalPlayerXuid); },
        IsLocalPlayerHLTV: function _IsLocalPlayerHLTV() { return _APIAccessor(GameStateAPI.IsLocalPlayerHLTV(), k_IsLocalPlayerHLTV); },
        GetPlayerStatus: function _GetPlayerStatus(xuid) { return _APIAccessor(GameStateAPI.GetPlayerStatus(xuid), k_GetPlayerStatus); },
        GetPlayerCommendsLeader: function _GetPlayerCommendsLeader(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCommendsLeader(xuid), k_GetPlayerCommendsLeader); },
        GetPlayerCommendsFriendly: function _GetPlayerCommendsFriendly(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCommendsFriendly(xuid), k_GetPlayerCommendsFriendly); },
        GetPlayerCommendsTeacher: function _GetPlayerCommendsTeacher(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCommendsTeacher(xuid), k_GetPlayerCommendsTeacher); },
        GetPlayerCompetitiveRanking: function _GetPlayerCompetitiveRanking(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCompetitiveRanking(xuid), k_GetPlayerCompetitiveRanking); },
        GetPlayerCompetitiveWins: function _GetPlayerCompetitiveWins(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCompetitiveWins(xuid), k_GetPlayerCompetitiveWins); },
        GetPlayerXpLevel: function _GetPlayerXpLevel(xuid) { return _APIAccessor(GameStateAPI.GetPlayerXpLevel(xuid), k_GetPlayerXpLevel, xuid); },
        GetPlayerScore: function _GetPlayerScore(xuid) { return _APIAccessor(GameStateAPI.GetPlayerScore(xuid), k_GetPlayerScore, xuid); },
        GetPlayerMVPs: function _GetPlayerMVPs(xuid) { return _APIAccessor(GameStateAPI.GetPlayerMVPs(xuid), k_GetPlayerMVPs, xuid); },
        GetPlayerKills: function _GetPlayerKills(xuid) { return _APIAccessor(GameStateAPI.GetPlayerKills(xuid), k_GetPlayerKills, xuid); },
        GetPlayerRoundKills: function GetPlayerRoundKills(xuid) { return _APIAccessor(GameStateAPI.GetPlayerRoundKills(xuid), k_GetPlayerRoundKills, xuid); },
        GetPlayerAssists: function _GetPlayerAssists(xuid) { return _APIAccessor(GameStateAPI.GetPlayerAssists(xuid), k_GetPlayerAssists, xuid); },
        GetPlayerDeaths: function _GetPlayerDeaths(xuid) { return _APIAccessor(GameStateAPI.GetPlayerDeaths(xuid), k_GetPlayerDeaths, xuid); },
        GetPlayerPing: function _GetPlayerPing(xuid) { return _APIAccessor(GameStateAPI.GetPlayerPing(xuid), k_GetPlayerPing, xuid); },
        GetPlayerColor: function _GetPlayerColor(xuid) { return _APIAccessor(GameStateAPI.GetPlayerColor(xuid), k_GetPlayerColor, xuid); },
        HasCommunicationAbuseMute: function _HasCommunicationAbuseMute(xuid) { return _APIAccessor(GameStateAPI.HasCommunicationAbuseMute(xuid), k_HasCommunicationAbuseMute); },
        IsSelectedPlayerMuted: function _IsSelectedPlayerMuted(xuid) { return _APIAccessor(GameStateAPI.IsSelectedPlayerMuted(xuid), k_IsSelectedPlayerMuted); },
        IsPlayerConnected: function _IsPlayerConnected(xuid) { return _APIAccessor(GameStateAPI.IsPlayerConnected(xuid), k_IsPlayerConnected); },
        ArePlayersEnemies: function _ArePlayersEnemies(xuid1, xuid2) { return _APIAccessor(GameStateAPI.ArePlayersEnemies(xuid1, xuid2), k_ArePlayersEnemies); },
        GetPlayerClanTag: function _GetPlayerClanTag(xuid) { return _APIAccessor(GameStateAPI.GetPlayerClanTag(xuid), k_GetPlayerClanTag); },
        GetPlayerMoney: function _GetPlayerMoney(xuid) { return _APIAccessor(GameStateAPI.GetPlayerMoney(xuid), k_GetPlayerMoney); },
        GetPlayerActiveWeaponItemId: function _GetPlayerActiveWeaponItemId(xuid) { return _APIAccessor(GameStateAPI.GetPlayerActiveWeaponItemId(xuid), k_GetPlayerActiveWeaponItemId, xuid); },
        GetPlayerModel: function _GetPlayerModel(xuid) { return _APIAccessor(GameStateAPI.GetPlayerModel(xuid), k_GetPlayerModel, xuid); },
        GetPlayerItemCT: function _GetPlayerItemCT(panel) { return _APIAccessor(panel.GetPlayerItemCT(), k_GetPlayerItemCT); },
        GetPlayerItemTerrorist: function _GetPlayerItemTerrorist(panel) { return _APIAccessor(panel.GetPlayerItemTerrorist(), k_GetPlayerItemTerrorist); },
        GetCharacterDefaultCheerByXuid: function _GetCharacterDefaultCheerByXuid(xuid) { return _APIAccessor(GameStateAPI.GetCharacterDefaultCheerByXuid(xuid), k_GetCharacterDefaultCheerByXuid, xuid); },
        GetCharacterDefaultDefeatByXuid: function _GetCharacterDefaultDefeatByXuid(xuid) { return _APIAccessor(GameStateAPI.GetCharacterDefaultDefeatByXuid(xuid), k_GetCharacterDefaultCheerByXuid, xuid); },
        GetAllPlayersMatchDataJSO: function _GetAllPlayersMatchDataJSO() { return _APIAccessor(GameStateAPI.GetAllPlayersMatchDataJSO(), k_GetAllPlayersMatchDataJSO); },
        GetPlayerCharacterItemID: function _GetPlayerCharacterItemID(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCharacterItemID(xuid), k_GetPlayerCharacterItemID); },
        GetFauxItemIDFromDefAndPaintIndex: function _GetFauxItemIDFromDefAndPaintIndex(defindex, paintid) { return _APIAccessor(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defindex, paintid), k_GetFauxItemIDFromDefAndPaintIndex); },
        GetPlayerCompetitiveRankType: function _GetPlayerCompetitiveRankType(xuid) { return _APIAccessor(GameStateAPI.GetPlayerCompetitiveRankType(xuid), k_GetPlayerCompetitiveRankType, xuid); },
        bSkillgroupDataReady: function _bSkillgroupDataReady(panel) { return _APIAccessor(panel.bSkillgroupDataReady, k_bSkillgroupDataReady); },
        bXpDataReady: function _bXpDataReady(panel) { return _APIAccessor(panel.bXpDataReady, k_bXpDataReady); },
        bXpShopDataReady: function _bXpShopDataReady(panel) { return _APIAccessor(panel.bXpShopDataReady, k_bXpShopDataReady); },
        GetPipRankCount: function _GetPipRankCount(type) { return _APIAccessor(MyPersonaAPI.GetPipRankCount(type), k_GetPipRankCount); },
        GetPlayerPremierRankStatsObject: function (xuid) { return _APIAccessor(GameStateAPI.GetPlayerPremierRankStatsObject(xuid), k_GetPlayerPremierRankStatsObject, xuid); },
        SetMockData: _SetMockData,
        GetMockData: _GetMockData,
    };
})();
(function () {
})();
