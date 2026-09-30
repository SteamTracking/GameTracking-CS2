"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/teamcolor.ts" />
/// <reference path="common/formattext.ts"/>
var PremierMapWinRecord;
(function (PremierMapWinRecord) {
    const m_numMaps = 7;
    const spiderGraph = $('#jsMapWinsSpiderGraph');
    var m_LobbyPlayerUpdatedEventHandler;
    var m_LeaderboardHoverPlayerEventHandler;
    var m_bEventsRegistered = false;
    function Init() {
        RegisterEventHandlers();
        if (spiderGraph.BCanvasReady()) {
            Draw();
        }
        else {
            $.Schedule(0.1, Init);
        }
    }
    function RegisterEventHandlers() {
        if (!m_bEventsRegistered) {
            m_LobbyPlayerUpdatedEventHandler = $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_PlayerUpdated", Draw);
            m_LeaderboardHoverPlayerEventHandler = $.RegisterForUnhandledEvent("LeaderboardHoverPlayer", _HighlightPlayer);
            $.RegisterForUnhandledEvent("CSGOHideMainMenu", UnregisterEventHandlers);
            $.RegisterForUnhandledEvent("CSGOShowMainMenu", RegisterEventHandlers);
            $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), Draw);
            m_bEventsRegistered = true;
        }
    }
    function UnregisterEventHandlers() {
        if (m_bEventsRegistered) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_Lobby_PlayerUpdated', m_LobbyPlayerUpdatedEventHandler);
            $.UnregisterForUnhandledEvent('LeaderboardHoverPlayer', m_LeaderboardHoverPlayerEventHandler);
            m_bEventsRegistered = false;
        }
    }
    function Draw() {
        _DrawParty();
        _MakeMapPanels();
    }
    PremierMapWinRecord.Draw = Draw;
    function _HighlightPlayer(xuid) {
        _DrawParty(xuid);
    }
    const oAlpha = {
        'normal': { 'outer': 0.5, 'inner': 0.1 },
        'dim': { 'outer': 0.2, 'inner': 0 },
        'hilit': { 'outer': 1, 'inner': 0.2 },
    };
    function _DrawPlayerPlot(arrValues, rgb, max, plotType = 'normal') {
        let rgbColorOuter = 'rgba(' + rgb + ',' + oAlpha[plotType].outer + ')';
        let rgbColorInner = 'rgba(' + rgb + ',' + oAlpha[plotType].inner + ')';
        arrValues = arrValues.map(a => a / max);
        const options = {
            line_color: rgbColorOuter,
            line_thickness: 3,
            line_softness: 10,
            fill_color_inner: rgbColorInner,
            fill_color_outer: rgbColorInner,
        };
        spiderGraph.DrawGraphPoly(arrValues, options);
    }
    function _GetMapsList() {
        return Object.keys(FriendsListAPI.GetFriendCompetitivePremierWindowStatsObject("0"));
    }
    function _DrawGuides(maxWinsInASingleMap) {
        spiderGraph.ClearJS('rgba(0,0,0,0)');
        const options = {
            bkg_color: "#00000080",
            spokes_color: '#ffffff10',
            spoke_thickness: 2,
            spoke_softness: 100,
            spoke_length_scale: 1.2,
            guideline_color: '#ffffff10',
            guideline_thickness: 2,
            guideline_softness: 100,
            guideline_count: maxWinsInASingleMap + 1,
            deadzone_percent: 0.1,
            scale: 0.70
        };
        spiderGraph.SetGraphOptions(options);
        spiderGraph.DrawGraphBackground(m_numMaps);
    }
    function _SetTitle(totalWins) {
        const pLabel = $('#jsMapWinsLabel');
        pLabel.text = $.ConstructString("#mapwinrecord_graph_title:f", { wins: totalWins });
    }
    function _DrawParty(highlightedPlayerXuid = '') {
        if (LobbyAPI.IsSessionActive()) {
            const party = LobbyAPI.GetSessionSettings().members;
            const nPlayers = party.numPlayers;
            let totalWins = 0;
            let maxWinsInASingleMap = 3;
            let mapList = _GetMapsList();
            let wso = [];
            let lbFallbackName = LeaderboardsAPI.GetCurrentSeasonPremierLeaderboard() + '.party';
            for (let p = 0; p < nPlayers; p++) {
                let xuid = party['machine' + p].player0.xuid;
                let playerObj = null;
                if (PartyListAPI.GetFriendCompetitiveRankType(xuid) === "Premier") {
                    var partyScore = PartyListAPI.GetFriendCompetitiveRank(xuid);
                    var partyWins = PartyListAPI.GetFriendCompetitiveWins(xuid);
                    if (partyScore || partyWins)
                        playerObj = PartyListAPI.GetFriendCompetitivePremierWindowStatsObject(xuid);
                }
                if (!playerObj) {
                    let objLbRow = LeaderboardsAPI.GetEntryDetailsObjectByXuid(lbFallbackName, xuid);
                    if (objLbRow && objLbRow.XUID && objLbRow.rankWindowStats)
                        playerObj = objLbRow.rankWindowStats;
                }
                if (!playerObj)
                    playerObj = PartyListAPI.GetFriendCompetitivePremierWindowStatsObject(xuid);
                wso.push(playerObj);
            }
            for (let p = 0; p < nPlayers; p++) {
                let RankWindowObject = wso[p];
                let playerWins = mapList.map((mapName) => { return mapName.startsWith('de_') ? Number(RankWindowObject[mapName] | 0) : 0; });
                totalWins = totalWins + playerWins.reduce((a, b) => a + b, 0);
                maxWinsInASingleMap = Math.max(maxWinsInASingleMap, Math.max.apply(null, playerWins));
            }
            _DrawGuides(maxWinsInASingleMap);
            _SetTitle(totalWins);
            for (let p = 0; p < nPlayers; p++) {
                let xuid = party['machine' + p].player0.xuid;
                let RankWindowObject = wso[p];
                let playerWins = mapList.map((mapName) => { return mapName.startsWith('de_') ? Number(RankWindowObject[mapName] | 0) : 0; });
                const teamColorIdx = PartyListAPI.GetPartyMemberSetting(xuid, 'game/teamcolor');
                const teamColorRgb = TeamColor.GetTeamColor(Number(teamColorIdx));
                let hilite = highlightedPlayerXuid === '' ? 'normal' : highlightedPlayerXuid === xuid ? 'hilit' : 'dim';
                _DrawPlayerPlot(playerWins, teamColorRgb, maxWinsInASingleMap, hilite);
            }
        }
    }
    function _MakeMapPanels() {
        let arrMaps = _GetMapsList();
        let elMapContainer = $.GetContextPanel().FindChildTraverse('jsMapWinsSpiderGraph');
        elMapContainer.RemoveAndDeleteChildren();
        for (let s = 0; s < m_numMaps; s++) {
            let elMap = $.CreatePanel('Panel', elMapContainer, String(s));
            elMap.BLoadLayoutSnippet('snippet-mwr-map');
            let elMapImage = elMap.FindChildInLayoutFile('mwr-map__image');
            let imageName = arrMaps[s];
            elMapImage.SetImage("file://{images}/map_icons/map_icon_" + imageName + ".svg");
            elMapImage.style.backgroundPosition = '50% 50%';
            elMapImage.style.backgroundSize = 'auto 150%';
            elMap.style.flowChildren = 'up';
            elMap.SetDialogVariable('map-name', $.Localize('#SFUI_Map_' + imageName));
            let vPos = spiderGraph.GraphPositionToUIPosition(s, 1.3);
            elMap.SetPositionInPixels(vPos.x, vPos.y, 0);
        }
    }
    {
        Init();
    }
})(PremierMapWinRecord || (PremierMapWinRecord = {}));
