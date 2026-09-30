"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="rating_emblem.ts" />
$.LogChannel('p.mock', "LV_OFF");
// pass game accessors through here to be able to inject dummy data in test cases.
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
        $.Msg('[p.mock] looking for ' + String(key));
        const arrTablesInUse = _m_mockData.split(',');
        for (let group of arrTablesInUse) {
            let mockTables = _GetMockTables();
            if (mockTables && mockTables.hasOwnProperty(group) && mockTables[group].hasOwnProperty(key)) {
                $.Msg('[p.mock] found ' + String(key) + ' in ' + String(group));
                return mockTables[group];
            }
        }
        // if ( MOCK_TABLE[ 'defaults' ]!.hasOwnProperty( key ) )
        // {
        // 	return MOCK_TABLE[ 'defaults' ];
        // }
        // else
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
        // is this a table with per player data?
        if (xuid !== -1 && table[key].hasOwnProperty(xuid)) {
            tableVal = table[key][xuid];
        }
        else if (xuid !== -1 && !table[key].hasOwnProperty(xuid)) // xuid isn't in the table, just take the first entry
         {
            tableVal = table[key][0];
        }
        else {
            tableVal = table[key];
        }
        // if the entry is a function, evaluate the function
        if (tableVal && typeof tableVal === "function") {
            return tableVal(xuid);
        }
        else {
            return tableVal;
        }
    }
    const _getLoadoutWeapons = function (team) {
        //	$.Msg( '_getLoadoutWeapons' );
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
        //	return "17293822569102704672";
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
        // for ( const i = 0; i < 50; i++ )
        // {
        // 	$.Msg( _r( 0, 2 ) );
        // }
        return (models[teamnum][random]);
    }
    let MOCK_TABLE = {
        //DEVONLY{
        "defaults": {
            k_GetTeamClanName: {
                TERRORIST: "Terrorists",
                CT: "Counter-Terrorists"
            },
            k_GetMapBSPName: "de_mirage",
            k_GetMatchEndWinDataJSO: {
                "text": "#Scoreboard_Final_Won",
                "winning_team_number": 2,
                "losing_team_number": 3,
                "winning_player": "0"
            },
            k_GetLocalPlayerXuid: "1",
            k_GetTeamLogoImagePath: "/icons/ct_logo.svg",
            k_GetPlayerItemCT: "agents/models/ctm_st6_variantd.vmdl",
            k_GetPlayerItemTerrorist: "agents/models/tm_balkan/tm_balkan_variante.vmdl",
            k_IsPlayerConnected: true,
            k_IsFakePlayer: false,
            k_GetTimeDataJSO: {
                "gamephase": 5,
                "has_halftime": false,
                "maxrounds": 1,
                "maxrounds_overtime": 6,
                "maxrounds_this_period": 1,
                "first_round_this_period": 1,
                "last_round_this_period": 1,
                "overtime": 0,
                "roundtime": 135,
                "maptime": 0,
                "roundtime_remaining": 131,
                "roundtime_elapsed": 3,
                "maptime_remaining": -1,
                "maptime_elapsed": 45,
                "rounds_remaining": -1,
                "rounds_played": 2,
                "num_wins_to_clinch": 1,
                "num_wins_to_clinch_this_period": 1,
                "can_clinch": 1,
                "time": 953,
                "hide": false,
            },
            k_GetPlayerSlot: {
                "1": "1",
                "3": "3",
                "5": "5",
                "7": "7",
                "9": "9",
                "2": "2",
                "4": "4",
                "6": "6",
                "8": "8",
                "10": "10",
                "11": "11",
                "13": "13",
                "15": "15",
                "17": "17",
                "19": "19",
                "12": "12",
                "14": "14",
                "16": "16",
                "18": "18",
                "20": "20"
            },
            k_GetPlayerStatus: 0,
            k_GetPlayerDataJSO: {
                "teams": [
                    { "name": "Unassigned", "player_count": 0 },
                    { "name": "Spectator", "player_count": 0 },
                    { "name": "CT", "player_count": 10 },
                    { "name": "TERRORIST", "player_count": 10 },
                ],
                "players": [
                    { "team": 2, "slot": 1, "xuid": "1" },
                    { "team": 2, "slot": 3, "xuid": "3" },
                    { "team": 2, "slot": 5, "xuid": "5" },
                    { "team": 2, "slot": 7, "xuid": "7" },
                    { "team": 2, "slot": 9, "xuid": "9" },
                    { "team": 2, "slot": 11, "xuid": "11" },
                    { "team": 2, "slot": 13, "xuid": "13" },
                    { "team": 2, "slot": 15, "xuid": "15" },
                    { "team": 2, "slot": 17, "xuid": "17" },
                    { "team": 2, "slot": 19, "xuid": "19" },
                    { "team": 3, "slot": 2, "xuid": "2" },
                    { "team": 3, "slot": 4, "xuid": "4" },
                    { "team": 3, "slot": 6, "xuid": "6" },
                    { "team": 3, "slot": 8, "xuid": "8" },
                    { "team": 3, "slot": 10, "xuid": "10" },
                    { "team": 3, "slot": 12, "xuid": "12" },
                    { "team": 3, "slot": 14, "xuid": "14" },
                    { "team": 3, "slot": 16, "xuid": "16" },
                    { "team": 3, "slot": 18, "xuid": "18" },
                    { "team": 3, "slot": 20, "xuid": "20" },
                ],
            },
            k_GetPlayerTeamName: {
                "1": "CT",
                "3": "CT",
                "5": "CT",
                "7": "CT",
                "9": "CT",
                "11": "CT",
                "13": "CT",
                "15": "CT",
                "17": "CT",
                "19": "CT",
                "2": "TERRORIST",
                "4": "TERRORIST",
                "6": "TERRORIST",
                "8": "TERRORIST",
                "10": "TERRORIST",
                "12": "TERRORIST",
                "14": "TERRORIST",
                "16": "TERRORIST",
                "18": "TERRORIST",
                "20": "TERRORIST"
            },
            k_GetPlayerTeamNumber: {
                "1": 3,
                "3": 3,
                "5": 3,
                "7": 3,
                "9": 3,
                "11": 3,
                "13": 3,
                "15": 3,
                "17": 3,
                "19": 3,
                "2": 2,
                "4": 2,
                "6": 2,
                "8": 2,
                "10": 2,
                "12": 2,
                "14": 2,
                "16": 2,
                "18": 2,
                "20": 2
            },
            k_GetPlayerName: {
                "1": "apple appleappleappleapple",
                "3": "banana bananabananabanana",
                "5": "pear pearpearpearpearpear",
                "7": "durian durianduriandurian",
                "9": "grape",
                "2": "kiwi",
                "4": "melon",
                "6": "strawberry",
                "8": "kumquat",
                "10": "orange",
                "11": "apple2",
                "13": "banana2",
                "15": "pear2",
                "17": "durian2",
                "19": "grape2",
                "12": "kiwi2",
                "14": "melon2",
                "16": "strawberry2",
                "18": "kumquat2",
                "20": "orange2",
            },
            k_GetPlayerActiveWeaponItemId: _GetRandomWeaponFromLoadout,
            k_GetPlayerModel: {
                "1": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "3": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "5": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "7": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "9": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "2": _GetRandomPlayerModel.bind(undefined, 't'),
                "4": _GetRandomPlayerModel.bind(undefined, 't'),
                "6": _GetRandomPlayerModel.bind(undefined, 't'),
                "8": _GetRandomPlayerModel.bind(undefined, 't'),
                "10": _GetRandomPlayerModel.bind(undefined, 't'),
                "11": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "13": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "15": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "17": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "19": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "12": _GetRandomPlayerModel.bind(undefined, 't'),
                "14": _GetRandomPlayerModel.bind(undefined, 't'),
                "16": _GetRandomPlayerModel.bind(undefined, 't'),
                "18": _GetRandomPlayerModel.bind(undefined, 't'),
                "20": _GetRandomPlayerModel.bind(undefined, 't'),
            },
            k_GetPlayerColor: {
                "1": "",
                "3": "",
                "5": "",
                "7": "",
                "9": "",
                "2": "",
                "4": "",
                "6": "",
                "8": "",
                "10": "",
                "11": "",
                "13": "",
                "15": "",
                "17": "",
                "19": "",
                "12": "",
                "14": "",
                "16": "",
                "18": "",
                "20": "", //"255 155 37",
            },
            k_GetPlayerStatsJSO: {
                "1": _GetRandomPlayerStatsJSO,
                "3": _GetRandomPlayerStatsJSO,
                "5": _GetRandomPlayerStatsJSO,
                "7": _GetRandomPlayerStatsJSO,
                "9": _GetRandomPlayerStatsJSO,
                "2": _GetRandomPlayerStatsJSO,
                "4": _GetRandomPlayerStatsJSO,
                "6": _GetRandomPlayerStatsJSO,
                "8": _GetRandomPlayerStatsJSO,
                "10": _GetRandomPlayerStatsJSO,
                "11": _GetRandomPlayerStatsJSO,
                "13": _GetRandomPlayerStatsJSO,
                "15": _GetRandomPlayerStatsJSO,
                "17": _GetRandomPlayerStatsJSO,
                "19": _GetRandomPlayerStatsJSO,
                "12": _GetRandomPlayerStatsJSO,
                "14": _GetRandomPlayerStatsJSO,
                "16": _GetRandomPlayerStatsJSO,
                "18": _GetRandomPlayerStatsJSO,
                "20": _GetRandomPlayerStatsJSO,
            },
            k_GetPlayerMVPs: {
                "1": _r(),
                "3": _r(),
                "5": _r(),
                "7": _r(),
                "9": _r(),
                "2": _r(),
                "4": _r(),
                "6": _r(),
                "8": _r(),
                "10": _r(),
                "11": _r(),
                "13": _r(),
                "15": _r(),
                "17": _r(),
                "19": _r(),
                "12": _r(),
                "14": _r(),
                "16": _r(),
                "18": _r(),
                "20": _r(),
            },
            k_GetPlayerScore: {
                "1": _r(),
                "3": _r(),
                "5": _r(),
                "7": _r(),
                "9": _r(),
                "2": _r(),
                "4": _r(),
                "6": _r(),
                "8": _r(),
                "10": _r(),
                "11": _r(),
                "13": _r(),
                "15": _r(),
                "17": _r(),
                "19": _r(),
                "12": _r(),
                "14": _r(),
                "16": _r(),
                "18": _r(),
                "20": _r(),
            },
            k_GetPlayerAssists: {
                "1": _r(),
                "3": _r(),
                "5": _r(),
                "7": _r(),
                "9": _r(),
                "2": _r(),
                "4": _r(),
                "6": _r(),
                "8": _r(),
                "10": _r(),
                "11": _r(),
                "13": _r(),
                "15": _r(),
                "17": _r(),
                "19": _r(),
                "12": _r(),
                "14": _r(),
                "16": _r(),
                "18": _r(),
                "20": _r(),
            },
            k_GetPlayerDeaths: {
                "1": _r(),
                "3": _r(),
                "5": _r(),
                "7": _r(),
                "9": _r(),
                "2": _r(),
                "4": _r(),
                "6": _r(),
                "8": _r(),
                "10": _r(),
                "11": _r(),
                "13": _r(),
                "15": _r(),
                "17": _r(),
                "19": _r(),
                "12": _r(),
                "14": _r(),
                "16": _r(),
                "18": _r(),
                "20": _r(),
            },
            k_AccoladesJSO: _GetRandomAccolades(),
            k_GetAllPlayersMatchDataJSO: {
                allplayerdata: [
                    {
                        entindex: "1",
                        isbot: true,
                        xuid: "1",
                        name: "Miller",
                        teamnumber: 2,
                        nomination: {
                            eaccolade: "9",
                            value: "102",
                            position: "2"
                        },
                        items: [
                            { itemid: _InternalGetFauxItemId(_GetRandomModelDefIndex(2), 0), defindex: _GetRandomModelDefIndex(2) },
                            { itemid: "17293822569102704644", defindex: "4" }
                        ]
                    },
                    {
                        entindex: "2", isbot: true, xuid: "2", name: "Nate", teamnumber: 3, nomination: { eaccolade: "5", value: "0", position: "1" },
                        items: [
                            { itemid: _InternalGetFauxItemId(_GetRandomModelDefIndex(3), 0), defindex: _GetRandomModelDefIndex(3) },
                            { itemid: "17293822569102704644", defindex: "4" }
                        ]
                    },
                    {
                        entindex: "3",
                        isbot: true,
                        xuid: "3",
                        name: "Steve",
                        teamnumber: 2,
                        nomination: {
                            eaccolade: "33",
                            value: "5",
                            position: "1"
                        },
                        items: [
                            { itemid: _InternalGetFauxItemId(5504, 0), defindex: "5504" },
                            { itemid: "17293822569102704699", defindex: "59", paintindex: "0", rarity: "0", quality: "0", stickers: [], origin: "4294967295", }
                        ]
                    },
                    { entindex: "5", isbot: true, xuid: "4", name: "Mark", teamnumber: 3, nomination: { eaccolade: "24", value: "1", position: "2" }, },
                    {
                        entindex: "6",
                        isbot: true,
                        xuid: "5",
                        name: "Colin",
                        teamnumber: 2,
                        nomination: {
                            eaccolade: "11",
                            value: "23",
                            position: "1"
                        },
                        items: [
                            { itemid: _InternalGetFauxItemId(5106, 0), defindex: "5106" },
                            { itemid: _InternalGetFauxItemId(9, 736), defindex: "5029", paintindex: "0", rarity: "1", quality: "0", stickers: [], origin: "4294967295", },
                            { itemid: "17293822569102704682", defindex: "42", paintindex: "0", rarity: "0", quality: "0", stickers: [], origin: "4294967295", }
                        ]
                    },
                    { entindex: "7", isbot: true, xuid: "6", name: "Will", teamnumber: 3, nomination: { eaccolade: "24", value: "1", position: "2" }, },
                    {
                        entindex: "8",
                        isbot: true,
                        xuid: "7",
                        name: "Jason",
                        teamnumber: 2,
                        nomination: {
                            eaccolade: "38",
                            value: "11",
                            position: "2"
                        },
                        items: [
                            { itemid: _InternalGetFauxItemId(5503, 0), defindex: "5503" },
                            { itemid: _InternalGetFauxItemId(28, 763), defindex: "", paintindex: "0", rarity: "1", quality: "0", stickers: [], origin: "4294967295", },
                        ]
                    },
                    { entindex: "9", isbot: true, xuid: "8", name: "Doug", teamnumber: 3, nomination: { eaccolade: "4", value: "0", position: "1" }, },
                    {
                        entindex: "10",
                        isbot: true,
                        xuid: "9",
                        name: "Adam",
                        teamnumber: 2,
                        nomination: {
                            eaccolade: "10",
                            value: "8",
                            position: "1"
                        },
                        items: [
                            { itemid: _InternalGetFauxItemId(5502, 0), defindex: "5502" },
                            { itemid: _InternalGetFauxItemId(518, 38), defindex: "5028", paintindex: "0", rarity: "1", quality: "0", stickers: [], origin: "4294967295", },
                        ]
                    },
                    { entindex: "11", isbot: true, xuid: "10", name: "Mike", teamnumber: 3, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "12", isbot: true, xuid: "11", name: "Mike", teamnumber: 2, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "13", isbot: true, xuid: "12", name: "Mike", teamnumber: 3, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "14", isbot: true, xuid: "13", name: "Mike", teamnumber: 2, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "15", isbot: true, xuid: "14", name: "Mike", teamnumber: 3, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "16", isbot: true, xuid: "15", name: "Mike", teamnumber: 2, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "17", isbot: true, xuid: "16", name: "Mike", teamnumber: 3, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "18", isbot: true, xuid: "17", name: "Mike", teamnumber: 2, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "19", isbot: true, xuid: "18", name: "Mike", teamnumber: 3, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "20", isbot: true, xuid: "19", name: "Mike", teamnumber: 2, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                    { entindex: "21", isbot: true, xuid: "20", name: "Mike", teamnumber: 3, nomination: { eaccolade: "3", value: "0", position: "1" }, },
                ],
                scene: 5,
            }
        },
        "char_balkan": {
            k_GetPlayerModel: {
                "1": "agents/models/tm_balkan/tm_balkan_varianth.vmdl",
                "3": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "5": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "7": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "9": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "2": "agents/models/tm_balkan/tm_balkan_varianth.vmdl",
                "4": _GetRandomPlayerModel.bind(undefined, 't'),
                "6": _GetRandomPlayerModel.bind(undefined, 't'),
                "8": _GetRandomPlayerModel.bind(undefined, 't'),
                "10": _GetRandomPlayerModel.bind(undefined, 't'),
                "11": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "13": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "15": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "17": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "19": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "12": _GetRandomPlayerModel.bind(undefined, 't'),
                "14": _GetRandomPlayerModel.bind(undefined, 't'),
                "16": _GetRandomPlayerModel.bind(undefined, 't'),
                "18": _GetRandomPlayerModel.bind(undefined, 't'),
                "20": _GetRandomPlayerModel.bind(undefined, 't'),
            },
            k_GetCharacterDefaultCheerByXuid: {
                "1": "punching",
                "3": "",
                "5": "",
                "7": "",
                "9": "",
                "2": "punching",
                "4": "",
                "6": "",
                "8": "",
                "10": "",
                "11": "",
                "13": "",
                "15": "",
                "17": "",
                "19": "",
                "12": "",
                "14": "",
                "16": "",
                "18": "",
                "20": "",
            },
        },
        "char_elite": {
            k_GetPlayerModel: {
                "1": "agents/models/tm_leet/tm_leet_variantf.vmdl",
                "3": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "5": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "7": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "9": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "2": "agents/models/tm_leet/tm_leet_variantf.vmdl",
                "4": _GetRandomPlayerModel.bind(undefined, 't'),
                "6": _GetRandomPlayerModel.bind(undefined, 't'),
                "8": _GetRandomPlayerModel.bind(undefined, 't'),
                "10": _GetRandomPlayerModel.bind(undefined, 't'),
                "11": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "13": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "15": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "17": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "19": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "12": _GetRandomPlayerModel.bind(undefined, 't'),
                "14": _GetRandomPlayerModel.bind(undefined, 't'),
                "16": _GetRandomPlayerModel.bind(undefined, 't'),
                "18": _GetRandomPlayerModel.bind(undefined, 't'),
                "20": _GetRandomPlayerModel.bind(undefined, 't'),
            },
            k_GetCharacterDefaultCheerByXuid: {
                "1": "swagger",
                "3": "",
                "5": "",
                "7": "",
                "9": "",
                "2": "swagger",
                "4": "",
                "6": "",
                "8": "",
                "10": "",
                "11": "",
                "13": "",
                "15": "",
                "17": "",
                "19": "",
                "12": "",
                "14": "",
                "16": "",
                "18": "",
                "20": "",
            },
        },
        "char_fbi": {
            k_GetPlayerModel: {
                "1": "agents/models/ctm_fbi/ctm_fbi_variantb.vmdl",
                "3": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "5": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "7": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "9": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "2": "agents/models/ctm_fbi/ctm_fbi_variantb.vmdl",
                "4": _GetRandomPlayerModel.bind(undefined, 't'),
                "6": _GetRandomPlayerModel.bind(undefined, 't'),
                "8": _GetRandomPlayerModel.bind(undefined, 't'),
                "10": _GetRandomPlayerModel.bind(undefined, 't'),
                "11": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "13": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "15": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "17": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "19": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "12": _GetRandomPlayerModel.bind(undefined, 't'),
                "14": _GetRandomPlayerModel.bind(undefined, 't'),
                "16": _GetRandomPlayerModel.bind(undefined, 't'),
                "18": _GetRandomPlayerModel.bind(undefined, 't'),
                "20": _GetRandomPlayerModel.bind(undefined, 't'),
            },
            k_GetCharacterDefaultCheerByXuid: {
                "1": "stretch",
                "3": "",
                "5": "",
                "7": "",
                "9": "",
                "2": "stretch",
                "4": "",
                "6": "",
                "8": "",
                "10": "",
                "11": "",
                "13": "",
                "15": "",
                "17": "",
                "19": "",
                "12": "",
                "14": "",
                "16": "",
                "18": "",
                "20": "",
            },
        },
        "char_st6": {
            k_GetPlayerModel: {
                "1": "agents/models/ctm_st6_varianti.vmdl",
                "3": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "5": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "7": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "9": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "2": "agents/models/ctm_st6_varianti.vmdl",
                "4": _GetRandomPlayerModel.bind(undefined, 't'),
                "6": _GetRandomPlayerModel.bind(undefined, 't'),
                "8": _GetRandomPlayerModel.bind(undefined, 't'),
                "10": _GetRandomPlayerModel.bind(undefined, 't'),
                "11": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "13": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "15": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "17": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "19": _GetRandomPlayerModel.bind(undefined, 'ct'),
                "12": _GetRandomPlayerModel.bind(undefined, 't'),
                "14": _GetRandomPlayerModel.bind(undefined, 't'),
                "16": _GetRandomPlayerModel.bind(undefined, 't'),
                "18": _GetRandomPlayerModel.bind(undefined, 't'),
                "20": _GetRandomPlayerModel.bind(undefined, 't'),
            },
            k_GetCharacterDefaultCheerByXuid: {
                "1": "dropdown",
                "3": "",
                "5": "",
                "7": "",
                "9": "",
                "2": "dropdown",
                "4": "",
                "6": "",
                "8": "",
                "10": "",
                "11": "",
                "13": "",
                "15": "",
                "17": "",
                "19": "",
                "12": "",
                "14": "",
                "16": "",
                "18": "",
                "20": "",
            },
        },
        "team_ct": {
            k_GetLocalPlayerXuid: "2",
        },
        "team_t": {
            k_GetLocalPlayerXuid: "1",
        },
        "vs5ct": {
            k_GetLocalPlayerXuid: "1",
            k_GetGameModeInternalName: "competitive",
        },
        "vs5t": {
            k_GetLocalPlayerXuid: "2",
            k_GetGameModeInternalName: "competitive",
        },
        "vs2ct": {
            k_GetLocalPlayerXuid: "1",
            k_GetGameModeInternalName: "cooperative",
        },
        "vs2t": {
            k_GetLocalPlayerXuid: "2",
            k_GetGameModeInternalName: "cooperative",
        },
        "mode_wingman": {
            k_GetGameModeInternalName: "scrimcomp2v2",
            k_GetGameModeName: "wingman",
            k_GetTeamLivingPlayerCount: 2,
            k_GetPlayerDataJSO: {
                "teams": [
                    { "name": "Unassigned", "player_count": 0 },
                    { "name": "Spectator", "player_count": 0 },
                    { "name": "CT", "player_count": 2 },
                    { "name": "TERRORIST", "player_count": 2 },
                ],
                "players": [
                    { "team": 2, "slot": 1, "xuid": "1" },
                    { "team": 2, "slot": 3, "xuid": "3" },
                    { "team": 3, "slot": 2, "xuid": "2" },
                    { "team": 3, "slot": 4, "xuid": "4" },
                ],
            },
            k_GetMatchEndWinDataJSO: {
                "text": "#Scoreboard_Final_Won",
                "winning_team_number": 3,
                "losing_team_number": 2,
                "winning_player": "0"
            },
            k_GetScoreDataJSO: {
                "teamdata": [
                    {
                        "team_name": "Unassigned",
                        "team_number": 0,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "Unassigned",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "Spectator",
                        "team_number": 1,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "SPECTATORS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "TERRORIST",
                        "team_number": 2,
                        "team_logo_image_path": "/icons/t_logo.svg",
                        "clan_id": 0,
                        "clan_name": "TERRORISTS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 1,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "CT",
                        "team_number": 3,
                        "team_logo_image_path": "/icons/ct_logo.svg",
                        "clan_id": 20,
                        "clan_name": "VALVE",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 1,
                        "score_1h": 1,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                ],
                "rounddata": [
                    { // round 0
                    },
                    {
                        "round": 1,
                        "result": "t_win_elimination",
                        "players_alive_CT": 0,
                        "players_alive_TERRORIST": 1
                    },
                ],
            },
            k_GetTimeDataJSO: {
                "gamephase": 5,
                "has_halftime": false,
                "maxrounds": 1,
                "maxrounds_overtime": 6,
                "maxrounds_this_period": 1,
                "first_round_this_period": 1,
                "last_round_this_period": 1,
                "overtime": 0,
                "roundtime": 135,
                "maptime": 0,
                "roundtime_remaining": 131,
                "roundtime_elapsed": 3,
                "maptime_remaining": -1,
                "maptime_elapsed": 45,
                "rounds_remaining": -1,
                "rounds_played": 2,
                "num_wins_to_clinch": 1,
                "num_wins_to_clinch_this_period": 1,
                "can_clinch": 1,
                "time": 953,
                "hide": false,
            },
        },
        "mode_guardian": {
            k_GetLocalPlayerXuid: "2",
            k_GetGameModeInternalName: "cooperative",
            k_GetGameModeName: "cooperative",
            k_GetTeamLivingPlayerCount: 2,
            k_GetPlayerDataJSO: {
                "teams": [
                    { "name": "Unassigned", "player_count": 0 },
                    { "name": "Spectator", "player_count": 0 },
                    { "name": "CT", "player_count": 2 },
                    { "name": "TERRORIST", "player_count": 2 },
                ],
                "players": [
                    { "team": 2, "slot": 1, "xuid": "1" },
                    { "team": 2, "slot": 3, "xuid": "3" },
                    { "team": 3, "slot": 2, "xuid": "2" },
                    { "team": 3, "slot": 4, "xuid": "4" },
                ],
            },
            k_GetMatchEndWinDataJSO: {
                "text": "#Scoreboard_Final_Won",
                "winning_team_number": 3,
                "losing_team_number": 2,
                "winning_player": "0"
            },
            k_GetScoreDataJSO: {
                "teamdata": [
                    {
                        "team_name": "Unassigned",
                        "team_number": 0,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "Unassigned",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "Spectator",
                        "team_number": 1,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "SPECTATORS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "TERRORIST",
                        "team_number": 2,
                        "team_logo_image_path": "/icons/t_logo.svg",
                        "clan_id": 0,
                        "clan_name": "TERRORISTS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "CT",
                        "team_number": 3,
                        "team_logo_image_path": "/icons/ct_logo.svg",
                        "clan_id": 20,
                        "clan_name": "VALVE",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 1,
                        "score_1h": 1,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                ],
                "rounddata": [
                    { // round 0
                    },
                    {
                        "round": 1,
                        "result": "t_win_elimination",
                        "players_alive_CT": 0,
                        "players_alive_TERRORIST": 1
                    },
                ],
            },
            k_GetTimeDataJSO: {
                "gamephase": 5,
                "has_halftime": false,
                "maxrounds": 1,
                "maxrounds_overtime": 6,
                "maxrounds_this_period": 1,
                "first_round_this_period": 1,
                "last_round_this_period": 1,
                "overtime": 0,
                "roundtime": 135,
                "maptime": 0,
                "roundtime_remaining": 131,
                "roundtime_elapsed": 3,
                "maptime_remaining": -1,
                "maptime_elapsed": 45,
                "rounds_remaining": -1,
                "rounds_played": 2,
                "num_wins_to_clinch": 1,
                "num_wins_to_clinch_this_period": 1,
                "can_clinch": 1,
                "time": 953,
                "hide": false,
            },
        },
        "mode_comp": {
            k_GetGameModeInternalName: "competitive",
            k_GetGameModeName: "competitive",
            k_GetTeamLivingPlayerCount: 5,
            k_GetPlayerDataJSO: {
                "teams": [
                    { "name": "Unassigned", "player_count": 0 },
                    { "name": "Spectator", "player_count": 0 },
                    { "name": "CT", "player_count": 5 },
                    { "name": "TERRORIST", "player_count": 5 },
                ],
                "players": [
                    { "team": 2, "slot": 1, "xuid": "1" },
                    { "team": 2, "slot": 3, "xuid": "3" },
                    { "team": 2, "slot": 5, "xuid": "5" },
                    { "team": 2, "slot": 7, "xuid": "7" },
                    { "team": 2, "slot": 9, "xuid": "9" },
                    { "team": 3, "slot": 2, "xuid": "2" },
                    { "team": 3, "slot": 4, "xuid": "4" },
                    { "team": 3, "slot": 6, "xuid": "6" },
                    { "team": 3, "slot": 8, "xuid": "8" },
                    { "team": 3, "slot": 10, "xuid": "10" },
                ],
            },
            k_GetMatchEndWinDataJSO: {
                "text": "#Scoreboard_Final_Won",
                "winning_team_number": 2,
                "losing_team_number": 3,
                "winning_player": "0"
            },
            k_GetScoreDataJSO: {
                "teamdata": [
                    {
                        "team_name": "Unassigned",
                        "team_number": 0,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "Unassigned",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "Spectator",
                        "team_number": 1,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "SPECTATORS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "TERRORIST",
                        "team_number": 2,
                        "team_logo_image_path": "/icons/t_logo.svg",
                        "clan_id": 0,
                        "clan_name": "TERRORISTS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "CT",
                        "team_number": 3,
                        "team_logo_image_path": "/icons/ct_logo.svg",
                        "clan_id": 20,
                        "clan_name": "VALVE",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 1,
                        "score_1h": 1,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                ],
                "rounddata": [
                    { // round 0
                    },
                    {
                        "round": 1,
                        "result": "t_win_elimination",
                        "players_alive_CT": 0,
                        "players_alive_TERRORIST": 1
                    },
                ],
            },
            k_GetTimeDataJSO: {
                "gamephase": 5,
                "has_halftime": false,
                "maxrounds": 1,
                "maxrounds_overtime": 6,
                "maxrounds_this_period": 1,
                "first_round_this_period": 1,
                "last_round_this_period": 1,
                "overtime": 0,
                "roundtime": 135,
                "maptime": 0,
                "roundtime_remaining": 131,
                "roundtime_elapsed": 3,
                "maptime_remaining": -1,
                "maptime_elapsed": 45,
                "rounds_remaining": -1,
                "rounds_played": 2,
                "num_wins_to_clinch": 1,
                "num_wins_to_clinch_this_period": 1,
                "can_clinch": 1,
                "time": 953,
                "hide": false,
            },
            k_GetPlayerColor: {
                "1": "#F8F62D",
                "3": "#A119F0",
                "5": "#00B562",
                "7": "#5CA8FF",
                "9": "#FF9B25",
                "2": "#F8F62D",
                "4": "#A119F0",
                "6": "#00B562",
                "8": "#5CA8FF",
                "10": "#FF9B25", //"255 155 37",
            }
        },
        "mode_cas": {
            k_GetGameModeInternalName: "casual",
            k_GetGameModeName: "casual",
            k_GetTeamLivingPlayerCount: 10,
            k_GetMatchEndWinDataJSO: {
                "text": "#Scoreboard_Final_Won",
                "winning_team_number": 3,
                "losing_team_number": 2,
                "winning_player": "0"
            },
            k_GetScoreDataJSO: {
                "teamdata": [
                    {},
                    {
                        "team_name": "Unassigned",
                        "team_number": 0,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "Unassigned",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "Spectator",
                        "team_number": 1,
                        "team_logo_image_path": "",
                        "clan_id": 0,
                        "clan_name": "SPECTATORS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 0,
                        "score_1h": 0,
                        "score_2h": 0,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "TERRORIST",
                        "team_number": 2,
                        "team_logo_image_path": "/icons/t_logo.svg",
                        "clan_id": 0,
                        "clan_name": "TERRORISTS",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 12,
                        "score_1h": 8,
                        "score_2h": 4,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                    {
                        "team_name": "CT",
                        "team_number": 3,
                        "team_logo_image_path": "/icons/ct_logo.svg",
                        "clan_id": 20,
                        "clan_name": "VALVE",
                        "flag": "",
                        "logo": "",
                        "map_victories": 0,
                        "player_count": 0,
                        "alive_count": 0,
                        "score": 16,
                        "score_1h": 7,
                        "score_2h": 9,
                        "score_ot": 0,
                        "surrendered": false,
                        "next_round_loss_bonus": 0,
                    },
                ],
                "rounddata": [
                    { // round 0
                    },
                    {
                        "round": 1,
                        "result": "t_win_elimination",
                        "players_alive_CT": 0,
                        "players_alive_TERRORIST": 1
                    },
                ],
            },
            k_GetTimeDataJSO: {
                "gamephase": 5,
                "has_halftime": false,
                "maxrounds": 16,
                "maxrounds_overtime": 6,
                "maxrounds_this_period": 1,
                "first_round_this_period": 1,
                "last_round_this_period": 1,
                "overtime": 0,
                "roundtime": 135,
                "maptime": 0,
                "roundtime_remaining": 131,
                "roundtime_elapsed": 3,
                "maptime_remaining": -1,
                "maptime_elapsed": 45,
                "rounds_remaining": -1,
                "rounds_played": 28,
                "num_wins_to_clinch": 1,
                "num_wins_to_clinch_this_period": 1,
                "can_clinch": 1,
                "time": 953,
                "hide": false,
            },
        },
        "RANK_up": {
            k_XpDataJSO: _GetRandomXP,
        },
        "SKILLGROUP_up": {
            k_SkillgroupDataJSO: _GetRandomSkillGroup,
        },
        "DROPS": {
            k_DropListJSO: {
                "0": {
                    "item_id": "17221764975064776756",
                    "owner_xuid": "148618791998203739",
                    "display_time": 3.5,
                    "faux_item_id": "17293822569125249033",
                    "owner_team": 3,
                    "rarity": 1,
                    "is_local": 1,
                    "reason": 0
                },
                "1": {
                    "item_id": "17221764975064776755",
                    "owner_xuid": "148618791998203739",
                    "display_time": 3.5,
                    "faux_item_id": "17293822569125249033",
                    "owner_team": 3,
                    "rarity": 1,
                    "is_local": 1,
                    "reason": 0
                },
                "2": {
                    "item_id": "17221764975064776759",
                    "owner_xuid": "148618791998203739",
                    "display_time": 2,
                    "faux_item_id": "17293822569125249033",
                    "owner_team": 2,
                    "rarity": 3,
                    "is_local": 1,
                    "reason": 0
                },
                "3": {
                    "item_id": "17221764975064776753",
                    "owner_xuid": "148618791998203739",
                    "display_time": 1,
                    "faux_item_id": "17293822569125249033",
                    "owner_team": 2,
                    "rarity": 3,
                    "is_local": 1,
                    "reason": 0
                },
                "4": {
                    "item_id": "17221764975064776757",
                    "owner_xuid": "148618791998203739",
                    "display_time": 0.5,
                    "faux_item_id": "17293822569125249033",
                    "owner_team": 2,
                    "rarity": 5,
                    "is_local": 1,
                    "reason": 0
                },
            },
        },
        "VOTING": {
            k_NextMatchVotingData: {
                "votes_to_succeed": 4,
                "voting_done": 0,
                "voting_winner": -1,
                "voting_options": {
                    "0": {
                        "type": "map",
                        "name": "de_mirage",
                        "votes": 0
                    },
                    "1": {
                        "type": "map",
                        "name": "de_inferno",
                        "votes": 1
                    },
                    "2": {
                        "type": "map",
                        "name": "de_overpass",
                        "votes": 2
                    },
                    "3": {
                        "type": "map",
                        "name": "de_nuke",
                        "votes": 3
                    },
                    "4": {
                        "type": "map",
                        "name": "de_train",
                        "votes": 4
                    },
                    "5": {
                        "type": "map",
                        "name": "de_cache",
                        "votes": 0
                    },
                },
            },
        },
        //}DEVONLY	
    };
    /* Public interface */
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
        // GetMusicIDForPlayer: function _GetMusicIDForPlayer ( xuid: string ) { return _APIAccessor( InventoryAPI.GetMusicIDForPlayer( xuid ), k_GetMusicIDForPlayer, xuid ); },
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
        // AccoladesJSO: function _AccoladesJSO ( panel ) { return _APIAccessor( panel.AccoladesJSO, k_AccoladesJSO ); },
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
//--------------------------------------------------------------------------------------------------
// Entry point called when panel is created
//--------------------------------------------------------------------------------------------------
(function () {
})();
