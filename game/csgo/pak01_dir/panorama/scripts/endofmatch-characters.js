"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="endofmatch.ts" />
/// <reference path="scoreboard.ts" />
/// <reference path="player_stats_card.ts" />
/// <reference path="mock_adapter.ts" />
var EOM_Characters;
(function (EOM_Characters) {
    let _m_arrAllPlayersMatchDataJSO = [];
    let _m_localPlayer = null;
    let _m_teamToShow = null;
    const ACCOLADE_START_TIME = 1;
    const DELAY_PER_PLAYER = 0.5;
    let m_bNoGimmeAccolades = false;
    function _GetSnippetForMode(mode) {
        switch (mode) {
            case 'scrimcomp2v2':
                return 'snippet-eom-chars__layout--scrimcomp2v2';
            case 'competitive':
            case 'cooperative':
            case 'casual':
            case 'teamdm':
            case 'rush':
                return 'snippet-eom-chars__layout--classic';
            case 'training':
            case 'deathmatch':
            case 'ffadm':
            case 'gungameprogressive':
                return 'snippet-eom-chars__layout--ffa';
            default:
                return 'snippet-eom-chars__layout--classic';
        }
    }
    function _SetTeamLogo(team) {
        let elRoot = $('#id-eom-characters-root');
        let teamLogoPath = 'file://{images}/icons/ui/' + (team == 'ct' ? 'ct_logo_1c.svg' : 't_logo_1c.svg');
        let elTeamLogo = elRoot.FindChildTraverse('id-eom-chars__layout__logo--' + team);
        if (elTeamLogo) {
            elTeamLogo.SetImage(teamLogoPath);
        }
    }
    function _SetupPanel(mode) {
        let elRoot = $('#id-eom-characters-root');
        let snippet = _GetSnippetForMode(mode);
        elRoot.RemoveAndDeleteChildren();
        elRoot.BLoadLayoutSnippet(snippet);
        _SetTeamLogo('t');
        _SetTeamLogo('ct');
    }
    function _CollectPlayersForMode(mode) {
        let arrPlayerList = [];
        switch (mode) {
            case 'deathmatch':
            case 'ffadm':
            case 'gungameprogressive':
                {
                    let arrPlayerXuids = Scoreboard.GetFreeForAllTopThreePlayers();
                    if (MockAdapter.GetMockData() != undefined) {
                        arrPlayerXuids = ['1', '2', '3'];
                    }
                    arrPlayerList[0] = _m_arrAllPlayersMatchDataJSO.filter(o => o['xuid'] == arrPlayerXuids[0])[0];
                    arrPlayerList[1] = _m_arrAllPlayersMatchDataJSO.filter(o => o['xuid'] == arrPlayerXuids[1])[0];
                    arrPlayerList[2] = _m_arrAllPlayersMatchDataJSO.filter(o => o['xuid'] == arrPlayerXuids[2])[0];
                    m_bNoGimmeAccolades = true;
                    break;
                }
            case 'training':
            case 'scrimcomp2v2':
                {
                    let listCT = _CollectPlayersOfTeam('CT').slice(0, 2);
                    let listT = _CollectPlayersOfTeam('TERRORIST').slice(0, 2);
                    arrPlayerList = listCT.concat(listT);
                    m_bNoGimmeAccolades = false;
                    break;
                }
            case 'rush':
                {
                    let listCT = _CollectPlayersOfTeam('CT').slice(0, 3);
                    let listT = _CollectPlayersOfTeam('TERRORIST').slice(0, 3);
                    arrPlayerList = listCT.concat(listT);
                    m_bNoGimmeAccolades = false;
                    break;
                }
            case 'competitive':
            case 'casual':
            case 'cooperative':
            case 'teamdm':
            default:
                {
                    arrPlayerList = _CollectPlayersOfTeam(_m_teamToShow);
                    arrPlayerList = arrPlayerList.sort(_SortByScoreFn);
                    m_bNoGimmeAccolades = false;
                    if (_m_localPlayer) {
                        arrPlayerList = arrPlayerList.filter(player => player['xuid'] != _m_localPlayer['xuid']);
                        arrPlayerList.splice(0, 0, _m_localPlayer);
                    }
                    break;
                }
        }
        if (arrPlayerList)
            arrPlayerList = arrPlayerList.slice(0, _GetNumCharsToShowForMode(mode));
        return arrPlayerList;
    }
    function _CollectPlayersOfTeam(teamName) {
        let teamNum = 0;
        switch (teamName) {
            case 'TERRORIST':
                teamNum = 2;
                break;
            case 'CT':
                teamNum = 3;
                break;
        }
        return _m_arrAllPlayersMatchDataJSO.filter(o => o['teamnumber'] == teamNum);
    }
    function _GetNumCharsToShowForMode(mode) {
        switch (mode) {
            case 'scrimcomp2v2':
                return 4;
            case 'competitive':
                return 5;
            case 'rush':
                return 6;
            case 'casual':
            case 'teamdm':
                return 5;
            case 'cooperative':
                return 2;
            case 'deathmatch':
            case 'ffadm':
            case 'gungameprogressive':
                return 3;
            case 'training':
                return 1;
            default:
                return 5;
        }
    }
    function GetModeForEndOfMatchPurposes() {
        let mode = MockAdapter.GetGameModeInternalName(false);
        if (mode == 'deathmatch') {
            if (GameInterfaceAPI.GetSettingString('mp_teammates_are_enemies') !== '0') {
                mode = 'ffadm';
            }
            else if (GameInterfaceAPI.GetSettingString('mp_dm_teammode') !== '0') {
                mode = 'teamdm';
            }
        }
        return mode;
    }
    EOM_Characters.GetModeForEndOfMatchPurposes = GetModeForEndOfMatchPurposes;
    function ShowWinningTeam(mode) {
        return false;
    }
    EOM_Characters.ShowWinningTeam = ShowWinningTeam;
    function _DisplayMe() {
        if (GameStateAPI.IsOverwatch()) {
            return false;
        }
        let data = MockAdapter.GetAllPlayersMatchDataJSO();
        if (data && data.allplayerdata && data.allplayerdata.length > 0) {
            _m_arrAllPlayersMatchDataJSO = data.allplayerdata;
        }
        else {
            return false;
        }
        let localPlayerSet = _m_arrAllPlayersMatchDataJSO.filter(oPlayer => oPlayer['xuid'] == MockAdapter.GetLocalPlayerXuid());
        let localPlayer = (localPlayerSet.length > 0) ? localPlayerSet[0] : undefined;
        let oMatchEndData = MockAdapter.GetMatchEndWinDataJSO();
        let teamNumToShow = 3;
        let losingTeamNum = oMatchEndData ? oMatchEndData.losing_team_number : 0;
        let mode = GetModeForEndOfMatchPurposes();
        if (localPlayer && !ShowWinningTeam(mode)) {
            _m_localPlayer = localPlayer;
            teamNumToShow = _m_localPlayer['teamnumber'];
        }
        else {
            if (oMatchEndData)
                teamNumToShow = oMatchEndData['winning_team_number'];
            if (!teamNumToShow && localPlayer) {
                _m_localPlayer = localPlayer;
                teamNumToShow = _m_localPlayer['teamnumber'];
            }
        }
        if (teamNumToShow == 2) {
            _m_teamToShow = 'TERRORIST';
        }
        else {
            _m_teamToShow = 'CT';
        }
        _SetupPanel(mode);
        let arrPlayerList = _CollectPlayersForMode(mode);
        arrPlayerList = _SortPlayers(mode, arrPlayerList);
        let cheerSet = new Set();
        let localPlayerCheer = '';
        if (_m_localPlayer) {
            let arrLocalPlayer = _m_localPlayer.hasOwnProperty('items') ? _m_localPlayer.items.filter(oItem => ItemInfo.IsCharacter(oItem.itemid)) : [];
            let localPlayerModel = arrLocalPlayer[0];
            if (localPlayerModel) {
                if (_m_localPlayer['teamnumber'] == losingTeamNum) {
                    if (GameInterfaceAPI.GetSettingString('eom_local_player_defeat_anim_enabled') !== '0')
                        localPlayerCheer = ItemInfo.GetDefaultDefeat(localPlayerModel['itemid']);
                }
                else {
                    localPlayerCheer = ItemInfo.GetDefaultCheer(localPlayerModel['itemid']);
                }
            }
            cheerSet.add(localPlayerCheer);
        }
        let gapIndex = -1;
        if (mode == 'scrimcomp2v2' && arrPlayerList.length > 0) {
            let firstTeamNum = arrPlayerList[0].teamnumber;
            gapIndex = arrPlayerList.findIndex(player => player.teamnumber != firstTeamNum);
        }
        $.GetContextPanel().SetPlayerCount(arrPlayerList.length + (gapIndex >= 0 ? 1 : 0));
        arrPlayerList.forEach((oPlayer, index) => {
            if (oPlayer) {
                if (index >= gapIndex && gapIndex >= 0)
                    index += 1;
                let sAgentItemId = '';
                let sGlovesItemId = '';
                let sWeaponItemId = '';
                let cheer = '';
                let sPetItemId = '';
                if ('items' in oPlayer) {
                    let agentItem = oPlayer['items'].filter(oItem => ItemInfo.IsCharacter(oItem['itemid']))[0];
                    if (agentItem) {
                        sAgentItemId = agentItem['itemid'];
                        if (oPlayer.teamnumber == losingTeamNum)
                            cheer = ItemInfo.GetDefaultDefeat(sAgentItemId);
                        else
                            cheer = ItemInfo.GetDefaultCheer(sAgentItemId);
                    }
                    let glovesItem = oPlayer['items'].filter(oItem => ItemInfo.IsGloves(oItem['itemid']))[0];
                    if (glovesItem) {
                        sGlovesItemId = glovesItem['itemid'];
                    }
                    let weaponItem = oPlayer['items'].filter(oItem => ItemInfo.IsWeapon(oItem['itemid']) || ItemInfo.IsMelee(oItem['itemid']))[0];
                    if (weaponItem) {
                        sWeaponItemId = weaponItem['itemid'];
                    }
                    let items = oPlayer['items'];
                    let petItem = oPlayer['items'].filter(oItem => ItemInfo.IsPet(oItem['itemid']))[0];
                    if (petItem) {
                        sPetItemId = petItem['itemid'];
                    }
                }
                if (oPlayer === _m_localPlayer)
                    cheer = localPlayerCheer;
                else if (cheerSet.has(cheer))
                    cheer = '';
                cheerSet.add(cheer);
                let label = oPlayer['xuid'];
                $.GetContextPanel().AddPlayer(index, label, sAgentItemId, sGlovesItemId, sWeaponItemId, cheer, sPetItemId);
            }
        });
        _CreatePlayerStatCards(arrPlayerList, gapIndex, m_bNoGimmeAccolades);
        return true;
    }
    ;
    function _DisplayPlayerStatsCard(elCardContainer, index, nPlayerCount) {
        let elEndOfMatch = $.GetContextPanel();
        let w = elEndOfMatch.actuallayoutwidth;
        let h = elEndOfMatch.actuallayoutheight;
        let xMin = 1080 * (w / h) * 0.5 - 720;
        let x = xMin + 1440 * ((index + 1) / (nPlayerCount + 1));
        let charPos = { x: x, y: 540 };
        if (elCardContainer && elCardContainer.IsValid()) {
            elCardContainer.style.x = charPos.x + 'px;';
            let elCard = elCardContainer.FindChildTraverse('card');
            elCardContainer.AddClass('reveal');
            $.Schedule(0.3, () => PlayerStatsCard.RevealStats(elCard));
        }
        if (!$.GetContextPanel().BAscendantHasClass('scoreboard-visible')) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.stats_reveal', 'MOUSE');
        }
    }
    function _CreatePlayerStatCards(arrPlayerList, gapIndex, bNoGimmes) {
        if (!arrPlayerList || arrPlayerList.length == 0)
            return;
        let arrBestStats = [
            { stat: 'adr', value: null, elCard: null },
            { stat: 'hsp', value: null, elCard: null },
            { stat: 'enemiesflashed', value: null, elCard: null },
            { stat: 'utilitydamage', value: null, elCard: null }
        ];
        let nPlayerCount = arrPlayerList.length + (gapIndex >= 0 ? 1 : 0);
        let elRoot = $('#id-eom-characters-root');
        for (let oPlayer of arrPlayerList) {
            if (!oPlayer)
                continue;
            let oTitle = oPlayer.nomination;
            let index = arrPlayerList.indexOf(oPlayer);
            if (index >= gapIndex && gapIndex >= 0)
                index += 1;
            if (oTitle != undefined) {
                let xuid = oPlayer.xuid;
                let elCardContainer = $.CreatePanel('Panel', elRoot, 'cardcontainer-' + xuid);
                elCardContainer.AddClass('player-stats-card-container');
                elCardContainer.style.zIndex = (index * 10).toString();
                let elCard = PlayerStatsCard.Init(elCardContainer, xuid, index);
                let accName = GameStateAPI.GetAccoladeLocalizationString(Number(oTitle.eaccolade));
                let showAccolade = !(bNoGimmes && accName.includes('gimme_'));
                if (showAccolade) {
                    let accValue = oTitle.value.toString();
                    let accPosition = oTitle.position.toString();
                    PlayerStatsCard.SetAccolade(elCard, accValue, accName, accPosition);
                }
                PlayerStatsCard.SetStats(elCard, xuid, arrBestStats);
                PlayerStatsCard.SetFlair(elCard, xuid);
                PlayerStatsCard.SetSkillGroup(elCard, xuid);
                PlayerStatsCard.SetAvatar(elCard, xuid);
                PlayerStatsCard.SetTeammateColor(elCard, xuid);
                $.Schedule(ACCOLADE_START_TIME + (index * DELAY_PER_PLAYER), _DisplayPlayerStatsCard.bind(undefined, elCardContainer, index, nPlayerCount));
            }
            else {
            }
        }
        for (let oBest of arrBestStats) {
            if (oBest.elCard)
                PlayerStatsCard.HighlightStat(oBest.elCard, oBest.stat);
        }
    }
    function _SortByTeamFn(a, b) {
        let team_a = Number(a['teamnumber']);
        let team_b = Number(b['teamnumber']);
        let index_a = Number(a['slot']);
        let index_b = Number(b['slot']);
        if (team_a != team_b) {
            return team_b - team_a;
        }
        else {
            return index_a - index_b;
        }
    }
    function _SortByScoreFn(a, b) {
        let score_a = MockAdapter.GetPlayerScore(a['xuid']);
        let score_b = MockAdapter.GetPlayerScore(b['xuid']);
        let index_a = Number(a['slot']);
        let index_b = Number(b['slot']);
        if (score_a != score_b) {
            return score_b - score_a;
        }
        else {
            return index_a - index_b;
        }
    }
    function _SortPlayers(mode, arrPlayerList) {
        let midpoint;
        let localPlayerPosition;
        switch (mode) {
            case 'scrimcomp2v2':
                arrPlayerList.sort(_SortByTeamFn);
                break;
            case 'no longer used but force local player to the middle':
                if (_m_localPlayer &&
                    _m_localPlayer.hasOwnProperty('xuid') &&
                    (arrPlayerList.filter(p => p.xuid == _m_localPlayer.xuid).length > 0)) {
                    midpoint = Math.floor(arrPlayerList.length / 2);
                    arrPlayerList = arrPlayerList.filter(player => player['xuid'] != _m_localPlayer['xuid']);
                    arrPlayerList.splice(midpoint, 0, _m_localPlayer);
                }
                break;
            case 'no longer used but force player to have a spot':
                if (_m_localPlayer && arrPlayerList.includes(_m_localPlayer)) {
                    localPlayerPosition = Math.min(arrPlayerList.indexOf(_m_localPlayer), 7);
                    arrPlayerList = arrPlayerList.filter(player => player['xuid'] != _m_localPlayer['xuid']);
                    arrPlayerList.splice(localPlayerPosition, 0, _m_localPlayer);
                }
                break;
            case 'deathmatch':
            case 'ffadm':
            case 'casual':
            case 'teamdm':
            case 'rush':
            default:
                break;
        }
        return arrPlayerList;
    }
    function _RankRevealAll() {
        let mode = GetModeForEndOfMatchPurposes();
        let arrPlayerList = _CollectPlayersForMode(mode);
        for (let oPlayer of arrPlayerList) {
            if (!oPlayer)
                continue;
            let xuid = oPlayer.xuid;
            let elCardContainer = $.GetContextPanel().FindChildTraverse('cardcontainer-' + xuid);
            if (elCardContainer) {
                let elCard = PlayerStatsCard.GetCard(elCardContainer);
                PlayerStatsCard.SetSkillGroup(elCard, xuid);
            }
        }
    }
    function Start() {
        _DisplayMe();
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gameover_show', 'MOUSE');
    }
    EOM_Characters.Start = Start;
    function Shutdown() {
        $('#id-eom-characters-root').FindChildrenWithClassTraverse('eom-chars__accolade').forEach(el => el.DeleteAsync(.0));
        $('#id-eom-characters-root').RemoveAndDeleteChildren();
    }
    EOM_Characters.Shutdown = Shutdown;
    {
        $.RegisterForUnhandledEvent('GameState_RankRevealAll', _RankRevealAll);
    }
})(EOM_Characters || (EOM_Characters = {}));
