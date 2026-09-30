"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="common/gamerules_constants.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="match_stakes.ts" />
/// <reference path="context_menus/context_menu_playercard.ts" />
var Scoreboard;
(function (Scoreboard) {
    const _m_cP = $.GetContextPanel();
    class PanelCache_t {
        m_elTimelineRoundLabel = null;
        m_elTimelineScoreOt = null;
        m_elMusicKitUnborrow = null;
        m_elMetaLabelsModeMap = null;
        m_elPlayersTableAny = null;
        m_elMouseBinding = null;
        m_elFooterWebsite = null;
        m_elTimelineSegments = null;
        m_elRoundLossBonus = null;
        m_elMuteImage = null;
        m_elBlockUgcImage = null;
        m_elRounds = [];
        m_metaModeImage = null;
        m_metaLabelsMap = null;
        m_coopStats = null;
        m_elMusicKit = null;
        m_namedPanels = {};
        ClearAll() {
            this.m_elTimelineRoundLabel = null;
            this.m_elTimelineScoreOt = null;
            this.m_elMusicKitUnborrow = null;
            this.m_elMetaLabelsModeMap = null;
            this.m_elPlayersTableAny = null;
            this.m_elMouseBinding = null;
            this.m_elFooterWebsite = null;
            this.m_elTimelineSegments = null;
            this.m_elRoundLossBonus = null;
            this.m_elMuteImage = null;
            this.m_elBlockUgcImage = null;
            this.m_elRounds = [];
            this.m_metaModeImage = null;
            this.m_metaLabelsMap = null;
            this.m_coopStats = null;
            this.m_elMusicKit = null;
            this.m_namedPanels = {};
        }
        CacheScoreboard(scoreBoard) {
            this.ClearAll();
            if (scoreBoard && scoreBoard.IsValid()) {
                this.m_elTimelineRoundLabel = this.GetAndCacheChildPanel(scoreBoard, 'id-sb-timeline__round-label');
                this.m_elTimelineScoreOt = this.GetAndCacheChildPanel(scoreBoard, 'id-sb-timeline__score_ot');
                this.m_elMusicKitUnborrow = this.GetAndCacheChildPanel(scoreBoard, 'id-sb-meta__musickit-unborrow');
                this.m_elMetaLabelsModeMap = this.GetAndCacheChildPanel(scoreBoard, 'id-sb-meta__labels__mode-map');
                this.m_elPlayersTableAny = this.GetAndCacheLayoutPanel(scoreBoard, 'players-table-ANY');
                this.m_elMouseBinding = this.GetAndCacheLayoutPanel(scoreBoard, 'id-sb-mouse-instructions');
                this.m_elFooterWebsite = this.GetAndCacheLayoutPanel(scoreBoard, 'id-sb-footer-server-website');
                this.m_elTimelineSegments = this.GetAndCacheLayoutPanel(scoreBoard, 'id-sb-timeline__segments');
                this.m_elRoundLossBonus = this.GetAndCacheLayoutPanel(scoreBoard, 'id-sb-timeline__round-loss-bonus-money');
                this.m_elMuteImage = this.GetAndCacheLayoutPanel(scoreBoard, 'id-sb-meta__mutevoice__image');
                this.m_elBlockUgcImage = this.GetAndCacheLayoutPanel(scoreBoard, 'id-sb-meta__blockugc__image');
                this.m_elRounds = [];
                this.m_metaModeImage = this.GetAndCacheContextPanel('#id-sb-meta__mode__image');
                this.m_metaLabelsMap = this.GetAndCacheContextPanel('#sb-meta__labels__map');
                this.m_coopStats = this.GetAndCacheContextPanel('#CoopStats');
                this.m_elMusicKit = this.GetAndCacheContextPanel('#id-sb-meta__musickit');
            }
        }
        GetPanel(name) {
            let result = null;
            if (name in this.m_namedPanels) {
                result = this.m_namedPanels[name];
            }
            return result;
        }
        static GetChildPanelOrNull(scoreBoard, name) {
            let elPanel = null;
            if (name) {
                let elFound = scoreBoard.FindChildTraverse(name);
                elPanel = ((elFound && elFound.IsValid()) ? elFound : null);
            }
            return elPanel;
        }
        static GetLayoutPanelOrNull(scoreBoard, name) {
            let elPanel = null;
            if (name) {
                let elFound = scoreBoard.FindChildInLayoutFile(name);
                elPanel = ((elFound && elFound.IsValid()) ? elFound : null);
            }
            return elPanel;
        }
        static GetContextPanelOrNull(name) {
            let elPanel = null;
            if (name) {
                let elFound = $(name);
                elPanel = ((elFound && elFound.IsValid()) ? elFound : null);
            }
            return elPanel;
        }
        GetAndCacheChildPanel(scoreBoard, name) {
            let elPanel = PanelCache_t.GetChildPanelOrNull(scoreBoard, name);
            if (name) {
                this.m_namedPanels[name] = elPanel;
            }
            return elPanel;
        }
        GetAndCacheLayoutPanel(scoreBoard, name) {
            let elPanel = PanelCache_t.GetLayoutPanelOrNull(scoreBoard, name);
            if (name) {
                this.m_namedPanels[name] = elPanel;
            }
            return elPanel;
        }
        GetAndCacheContextPanel(name) {
            let elPanel = PanelCache_t.GetContextPanelOrNull(name);
            if (name) {
                this.m_namedPanels[name] = elPanel;
            }
            return elPanel;
        }
    }
    let _m_panelCache = new PanelCache_t();
    let _m_LocalPlayerID = '';
    function GetLocalPlayerId() {
        if (_m_LocalPlayerID === '')
            _m_LocalPlayerID = GameStateAPI.GetLocalPlayerXuid();
        return _m_LocalPlayerID;
    }
    const _commendNames = ['leader', 'teacher', 'friendly'];
    const _statNames = ['teamname', 'dc', 'score', 'risc', 'mvps', 'kills', 'assists', 'deaths', 'rank', 'idx', 'damage', 'avgrisc', 'money', 'hsp', 'kdr', 'adr', 'utilitydamage', 'enemiesflashed', 'musickit', 'skillgroup', 'ping', '3k', '4k', '5k', 'status', 'name', 'flair', 'avatar', 'gglevel', 'knifekills', 'taserkills', 'honoricon', ..._commendNames];
    class Team_t {
        static GetOrCreateTeam(scoreBoard, teamName) {
            if (!_m_oTeams[teamName]) {
                _m_oTeams[teamName] = new Team_t(teamName, scoreBoard);
            }
            return _m_oTeams[teamName];
        }
        static GetTeam(teamName) {
            return _m_oTeams[teamName];
        }
        m_CommendLeaderboards = {
            'leader': [],
            'teacher': [],
            'friendly': [],
        };
        m_teamName;
        m_teamLogoImagePath;
        m_elPlayersTable;
        m_elLogoChildren;
        constructor(teamName, scoreBoard) {
            this.m_teamName = teamName;
            this.m_teamLogoImagePath = '';
            let elPlayersTable = scoreBoard.FindChildInLayoutFile('players-table-' + teamName);
            this.m_elPlayersTable = (elPlayersTable && elPlayersTable.IsValid()) ? elPlayersTable : undefined;
            let elTeamLogoChildren = [];
            if (scoreBoard && scoreBoard.IsValid()) {
                const children_ = scoreBoard.FindChildrenWithClassTraverse('sb-team-logo-background--' + teamName);
                for (let child of children_) {
                    if (child && child.IsValid()) {
                        elTeamLogoChildren.push(child);
                    }
                }
            }
            this.m_elLogoChildren = elTeamLogoChildren;
        }
        CalculateAllCommends() {
            let leader = this.m_CommendLeaderboards["leader"];
            let teacher = this.m_CommendLeaderboards["teacher"];
            let friendly = this.m_CommendLeaderboards["friendly"];
            leader.sort((a, b) => b.m_value - a.m_value);
            teacher.sort((a, b) => b.m_value - a.m_value);
            friendly.sort((a, b) => b.m_value - a.m_value);
            let bestLeaderXuid = '';
            {
                bestLeaderXuid = leader[0] ? leader[0].m_xuid : "0";
            }
            let bestTeacherXuid = '';
            {
                let teacher0 = teacher[0] ? teacher[0].m_xuid : "0";
                let teacher1 = teacher[1] ? teacher[1].m_xuid : "0";
                if (teacher0 != bestLeaderXuid) {
                    bestTeacherXuid = teacher0;
                }
                else {
                    bestTeacherXuid = teacher1;
                }
            }
            let bestFriendlyXuid = '';
            {
                let friendly0 = friendly[0] ? friendly[0].m_xuid : "0";
                let friendly1 = friendly[1] ? friendly[1].m_xuid : "0";
                let friendly2 = friendly[2] ? friendly[2].m_xuid : "0";
                if (friendly0 != bestLeaderXuid && friendly0 != bestTeacherXuid) {
                    bestFriendlyXuid = friendly0;
                }
                else if (friendly1 != bestLeaderXuid && friendly1 != bestTeacherXuid) {
                    bestFriendlyXuid = friendly1;
                }
                else {
                    bestFriendlyXuid = friendly2;
                }
            }
            {
                let oldTop = _m_TopCommends2.leader;
                let newTop = bestLeaderXuid;
                _m_TopCommends2.leader = newTop;
                if (newTop != oldTop) {
                    let stat = "leader";
                    this._ChangeCommendDisplay(oldTop, stat, false);
                    this._ChangeCommendDisplay(newTop, stat, true);
                }
            }
            {
                let oldTop = _m_TopCommends2.teacher;
                let newTop = bestTeacherXuid;
                _m_TopCommends2.teacher = newTop;
                if (newTop != oldTop) {
                    let stat = "teacher";
                    this._ChangeCommendDisplay(oldTop, stat, false);
                    this._ChangeCommendDisplay(newTop, stat, true);
                }
            }
            {
                let oldTop = _m_TopCommends2.friendly;
                let newTop = bestFriendlyXuid;
                _m_TopCommends2.friendly = newTop;
                if (newTop != oldTop) {
                    let stat = "friendly";
                    this._ChangeCommendDisplay(oldTop, stat, false);
                    this._ChangeCommendDisplay(newTop, stat, true);
                }
            }
        }
        UpdateCommendForPlayer(xuid, stat, value) {
            if (value == 0)
                return;
            let playerCommend = this.m_CommendLeaderboards[stat].find(p => p.m_xuid === xuid);
            if (!playerCommend) {
                this.m_CommendLeaderboards[stat].push({ m_xuid: xuid, m_value: value });
            }
            else {
                playerCommend.m_value = value;
            }
        }
        DeletePlayerFromCommendsLeaderboards(xuid) {
            for (let stat of ['leader', 'teacher', 'friendly']) {
                let index = this.m_CommendLeaderboards[stat].findIndex(p => p.m_xuid === xuid);
                if (index != -1) {
                    this.m_CommendLeaderboards[stat].splice(index, 1);
                }
            }
        }
        _ChangeCommendDisplay(xuid, stat, turnon) {
            let oPlayer = _m_oPlayers.GetPlayerByXuid(xuid);
            if (!oPlayer)
                return;
            let elPlayer = oPlayer.m_elPlayer;
            if (!elPlayer || !elPlayer.IsValid())
                return;
            let elCommendationImage = elPlayer.FindChildTraverse('id-sb-name__commendations__' + stat);
            if (!elCommendationImage || !elCommendationImage.IsValid())
                return;
            elCommendationImage.SetHasClass('hidden', !turnon);
        }
    }
    class Player_t {
        static m_defaulPlayerGameStats = {
            is_fake_player: false,
            is_valid_xuid: false,
            is_muted: false,
            is_enemy: false,
            has_abuse_mute: false,
            team_name: "",
            team_number: 0,
            slot: 0,
            color: "",
            status: 0,
            comp_ranking: -1,
            comp_type: "",
            comp_wins: -1,
            ping: -1,
            kills: -1,
            round_kills: -1,
            assists: -1,
            deaths: -1,
            mvps: -1,
            money: 0,
            score: -1,
            xp_trail_level: 0,
            commend_leader: 0,
            commend_teacher: 0,
            commend_friendly: 0,
        };
        m_xuid;
        m_elPlayer = undefined;
        m_elTeam = undefined;
        m_oStats = {};
        m_oElStats = {};
        m_isMuted = false;
        m_oMatchStats = undefined;
        m_oGameStats = undefined;
        m_xp_trail_level;
        m_team = undefined;
        constructor(xuid) {
            this.m_xuid = xuid;
        }
        GetStatNum(stat, dflt = 0) {
            const val = this.m_oStats[stat];
            return typeof val === "number" && isFinite(val) ? val : dflt;
        }
        GetStatText(stat, dflt = "") {
            const val = this.m_oStats[stat];
            return typeof val === "string" ? val : val != null ? val.toString() : dflt;
        }
        RetrieveGameStats() {
            this.m_oMatchStats = MatchStatsAPI.GetPlayerStatsJSO(this.m_xuid);
            this.m_oGameStats = GameStateAPI.GetPlayerStatsJSO(this.m_xuid);
        }
        GetGameStat(member) {
            const gameStats = (this.m_oGameStats ? this.m_oGameStats : Player_t.m_defaulPlayerGameStats);
            return gameStats[member];
        }
        UpdateAndSort(updateStatNames, bSilent) {
            this.RetrieveGameStats();
            _UpdateAllStatsForPlayer(this, updateStatNames, bSilent);
            _SortPlayer(this);
        }
    }
    class AllPlayers_t {
        m_arrPlayers = [];
        AddPlayer(xuid) {
            let newPlayer = new Player_t(xuid);
            let teamName = (xuid ? GameStateAPI.GetPlayerTeamName(xuid) : '');
            if (IsTeamASpecTeam(teamName))
                teamName = 'Spectator';
            let team = Team_t.GetTeam(teamName);
            let elTeam = team ? team.m_elPlayersTable : undefined;
            if (!elTeam || !elTeam.IsValid()) {
                elTeam = (_m_panelCache.m_elPlayersTableAny ? _m_panelCache.m_elPlayersTableAny : undefined);
            }
            newPlayer.m_elTeam = elTeam;
            newPlayer.m_team = _m_oTeams[teamName];
            this.m_arrPlayers.push(newPlayer);
            return newPlayer;
        }
        GetPlayerByIndex(i) {
            return this.m_arrPlayers[i];
        }
        GetPlayerByXuid(xuid) {
            return this.m_arrPlayers.find(p => p.m_xuid === xuid);
        }
        GetPlayerIndexByPlayerSlot(slot) {
            let xuid = GameStateAPI.GetPlayerXuidStringFromPlayerSlot(slot);
            return this.GetPlayerIndexByXuid(xuid);
        }
        GetPlayerIndexByXuid(xuid) {
            return this.m_arrPlayers.findIndex(p => p.m_xuid === xuid);
        }
        GetCount() {
            return this.m_arrPlayers.length;
        }
        DeletePlayerByXuid(xuid) {
            let oPlayer = this.GetPlayerByXuid(xuid);
            const teamName = oPlayer?.m_oStats?.teamname;
            if (teamName && _m_oTeams[teamName]) {
                _m_oTeams[teamName].DeletePlayerFromCommendsLeaderboards(xuid);
            }
            let i = this.GetPlayerIndexByXuid(xuid);
            if (this.m_arrPlayers[i].m_elPlayer && this.m_arrPlayers[i].m_elPlayer.IsValid()) {
                this.m_arrPlayers[i].m_elPlayer.m_elSkillGroup = undefined;
                this.m_arrPlayers[i].m_elPlayer.DeleteAsync(.0);
            }
            this.m_arrPlayers.splice(i, 1);
        }
        DeleteMissingPlayers(oPlayerData) {
            const xuids = oPlayerData.players.map(p => p.xuid);
            for (const player of this.m_arrPlayers) {
                if (!xuids.includes(player.m_xuid)) {
                    this.DeletePlayerByXuid(player.m_xuid);
                }
            }
        }
    }
    let _m_bInit = false;
    let _m_bRowLabelsCreated = false;
    let _m_oAllUpdateStatNames = [];
    let _m_oUpdateStatNames = [];
    let _m_updatePlayerIndex = 0;
    let _m_oTeams = {};
    let _m_arrSortingPausedRefGetCounter = 0;
    let _m_hDenyInputToGame = null;
    let _m_dataSetCurrent = 0;
    let _m_dataSetGetCount = 0;
    let _m_areTeamsSwapped = false;
    let _m_maxRounds = 0;
    let _m_oPlayers;
    let _m_RoundUpdated = {};
    let _m_TopCommends = {
        'leader': "0",
        'teacher': "0",
        'friendly': "0",
    };
    ;
    let _m_TopCommends2 = {
        leader: "0",
        teacher: "0",
        friendly: "0",
    };
    let _m_overtime = 0;
    let _m_updatePlayerHandler = null;
    let _m_haveViewers = false;
    let FAKEMODE = '';
    const sortOrder_default = {
        'dc': 0,
        'score': 0,
        'risc': 0,
        'mvps': 0,
        'kills': 0,
        'assists': 0,
        'deaths': -1,
        'leader': 0,
        'teacher': 0,
        'friendly': 0,
        'rank': 0,
        'idx': -1,
        'damage': 0,
        'avgrisc': 0,
        'money': 0,
        'hsp': 0,
        'kdr': 0,
        'adr': 0,
        'utilitydamage': 0,
        'enemiesflashed': 0,
    };
    const sortOrder_reverse = {
        'dc': 0,
        'score': -1,
        'risc': -1,
        'mvps': -1,
        'kills': -1,
        'assists': -1,
        'deaths': 0,
        'leader': -1,
        'teacher': -1,
        'friendly': -1,
        'rank': -1,
        'idx': 0,
        'damage': 0,
        'avgrisc': 0,
        'money': 0,
        'hsp': 0,
        'kdr': 0,
        'adr': 0,
        'utilitydamage': 0,
        'enemiesflashed': 0,
    };
    const sortOrder_dm = {
        'dc': 0,
        'score': 0,
        'kills': 0,
        'kdr': 0,
        'damage': 0,
        'hsp': 0,
        'idx': -1,
        'assists': 0,
        'deaths': -1,
    };
    const sortOrder_gg = {
        'dc': 0,
        'gglevel': 0,
        'knifekills': 0,
        'taserkills': 0,
        'kills': 0,
        'kdr': 0,
        'hsp': 0,
        'idx': -1,
        'assists': 0,
        'deaths': -1,
    };
    const sortOrder_tmm = {
        'dc': 0,
        'damage': 0,
        'kills': 0,
        'risc': 0,
        'mvps': 0,
        'assists': 0,
        'deaths': -1,
        'leader': 0,
        'teacher': 0,
        'friendly': 0,
        'rank': 0,
        'idx': -1,
        'score': 0,
        'avgrisc': 0,
        'money': 0,
        'hsp': 0,
        'kdr': 0,
        'adr': 0,
        'utilitydamage': 0,
        'enemiesflashed': 0,
    };
    let _m_sortOrder = sortOrder_default;
    _Reset();
    function _Reset() {
        _m_bInit = false;
        _m_bRowLabelsCreated = false;
        _m_oPlayers = new AllPlayers_t();
        _m_oUpdateStatNames = [];
        _m_updatePlayerIndex = 0;
        _m_oTeams = {};
        _m_arrSortingPausedRefGetCounter = 0;
        _m_hDenyInputToGame = null;
        _m_dataSetCurrent = 0;
        _m_dataSetGetCount = 0;
        _m_areTeamsSwapped = false;
        _m_maxRounds = 0;
        _m_sortOrder = sortOrder_default;
        _m_overtime = 0;
        _m_RoundUpdated = {};
        _m_TopCommends = {
            'leader': "0",
            'teacher': "0",
            'friendly': "0",
        };
        _m_TopCommends2 = {
            leader: "0",
            teacher: "0",
            friendly: "0",
        };
        _m_panelCache.ClearAll();
        _m_cP.RemoveAndDeleteChildren();
        _m_cP.m_matchInfo = undefined;
        _m_cP.m_bSnippetLoaded = false;
    }
    function _Helper_LoadSnippet(element, snippet) {
        if (element && !element.m_bSnippetLoaded) {
            element.BLoadLayoutSnippet(snippet);
            element.m_bSnippetLoaded = true;
        }
    }
    function _PopulatePlayerList(oPlayerData) {
        if (oPlayerData.teams.length === 0)
            return;
        for (const team of oPlayerData.teams) {
            if (team.player_count > 0) {
                Team_t.GetOrCreateTeam(_m_cP, team.name);
            }
        }
        Team_t.GetOrCreateTeam(_m_cP, 'CT');
        Team_t.GetOrCreateTeam(_m_cP, 'TERRORIST');
        let highlightSortStatLabel = false;
        for (let p of oPlayerData.players) {
            const xuid = p.xuid;
            if (xuid == null || xuid == '' || xuid === "0")
                continue;
            const teamName = oPlayerData.teams[p.team].name;
            const oPlayer = _m_oPlayers.GetPlayerByXuid(xuid);
            if (!oPlayer) {
                let oNewPlayer = _m_oPlayers.AddPlayer(xuid);
                _NewPlayerPanel(oNewPlayer);
                oNewPlayer.UpdateAndSort(_m_oUpdateStatNames, true);
                highlightSortStatLabel = true;
            }
            else if (oPlayer.m_oStats['teamname'] != teamName) {
                _ChangeTeams(oPlayer, teamName);
            }
        }
        if (highlightSortStatLabel) {
            let sortOrder = Object.keys(_m_sortOrder)[1];
            _HighlightSortStatLabel(sortOrder);
        }
    }
    function _ChangeTeams(oPlayer, newTeamName) {
        if (oPlayer.m_oStats['teamname'] == newTeamName)
            return false;
        let xuid = oPlayer.m_xuid;
        let oldTeam = oPlayer.m_oStats['teamname'];
        let elPlayer = oPlayer.m_elPlayer;
        oPlayer.m_oStats['teamname'] = newTeamName;
        if (oldTeam in _m_oTeams) {
            _m_oTeams[oldTeam].DeletePlayerFromCommendsLeaderboards(xuid);
        }
        if (newTeamName in _m_oTeams) {
            oPlayer.m_team = _m_oTeams[newTeamName];
        }
        else {
            oPlayer.m_team = undefined;
        }
        oPlayer.m_oStats['leader'] = -1;
        oPlayer.m_oStats['teacher'] = -1;
        oPlayer.m_oStats['friendly'] = -1;
        if (!elPlayer || !elPlayer.IsValid())
            return true;
        if (oldTeam)
            elPlayer.RemoveClass('sb-team--' + oldTeam);
        elPlayer.AddClass('sb-team--' + newTeamName);
        if (IsTeamASpecTeam(newTeamName) && MatchStatsAPI.IsTournamentMatch()) {
            elPlayer.AddClass('hidden');
            return true;
        }
        let team = oPlayer.m_team;
        let elTeam = team ? team.m_elPlayersTable : null;
        if (!elTeam && !IsTeamASpecTeam(newTeamName)) {
            elTeam = _m_panelCache.m_elPlayersTableAny;
        }
        if (elTeam && elTeam.IsValid()) {
            oPlayer.m_elTeam = elTeam;
            elPlayer.SetParent(elTeam);
            elPlayer.RemoveClass('hidden');
        }
        else {
            elPlayer.AddClass('hidden');
        }
        return true;
    }
    function _UpdateNextPlayer() {
        const oPlayerData = GameStateAPI.GetPlayerDataJSO();
        _m_oPlayers.DeleteMissingPlayers(oPlayerData);
        if (_m_updatePlayerIndex >= _m_oPlayers.GetCount()) {
            _PopulatePlayerList(oPlayerData);
            _m_updatePlayerIndex = 0;
        }
        _UpdatePlayer(_m_updatePlayerIndex);
        _m_updatePlayerIndex++;
    }
    function _UpdateAllPlayers_delayed() {
        $.Schedule(0.01, _UpdateAllPlayers);
    }
    function _UpdateAllPlayers(bInitialCreate = false) {
        if (!_m_bInit)
            return;
        const bSilent = true;
        const oPlayerData = GameStateAPI.GetPlayerDataJSO();
        _m_oPlayers.DeleteMissingPlayers(oPlayerData);
        _PopulatePlayerList(oPlayerData);
        _m_updatePlayerIndex = 0;
        if (!bInitialCreate) {
            for (let i = 0; i < _m_oPlayers.GetCount(); i++) {
                let elPlayer = _m_oPlayers.GetPlayerByIndex(i).m_elPlayer;
                if (elPlayer && elPlayer.IsValid())
                    elPlayer.RemoveClass('sb-row--transition');
            }
            for (let i = 0; i < _m_oPlayers.GetCount(); i++) {
                _UpdatePlayer(i, bSilent);
            }
            for (let i = 0; i < _m_oPlayers.GetCount(); i++) {
                let elPlayer = _m_oPlayers.GetPlayerByIndex(i).m_elPlayer;
                if (elPlayer && elPlayer.IsValid())
                    elPlayer.AddClass('sb-row--transition');
            }
        }
    }
    function _Pulse(el) {
        el.RemoveClass('sb-pulse-highlight');
        el.AddClass('sb-pulse-highlight');
    }
    function _UpdatePlayerByPlayerSlot(slot) {
        let index = _m_oPlayers.GetPlayerIndexByPlayerSlot(slot);
        _UpdatePlayer(index, true);
    }
    function _UpdatePlayerByPlayerSlot_delayed(slot) {
        $.Schedule(0.01, () => _UpdatePlayerByPlayerSlot(slot));
    }
    function _UpdatePlayer(idx, bSilent = false) {
        let oPlayer = _m_oPlayers.GetPlayerByIndex(idx);
        if (!oPlayer)
            return;
        bSilent = bSilent && _m_cP.visible;
        oPlayer.UpdateAndSort(_m_oUpdateStatNames, bSilent);
    }
    function _UpdateSpectatorButtons() {
        let elButtonPanel = $('#spec-button-group');
        if (!elButtonPanel || !elButtonPanel.IsValid())
            return;
        let nCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_autodirector_cameraman'));
        let bQ = (GameStateAPI.IsLocalPlayerHLTV() && nCameraMan > -1);
        if (bQ) {
            elButtonPanel.visible = true;
            UpdateCasterButtons();
        }
        else {
            elButtonPanel.visible = false;
        }
    }
    function _lessthan(x, y) {
        x = Number(x);
        y = Number(y);
        if (isNaN(x))
            return (!isNaN(y));
        if (isNaN(y))
            return false;
        return (x < y);
    }
    function _SortPlayer(oPlayer) {
        if (_m_arrSortingPausedRefGetCounter != 0)
            return;
        let elTeam = oPlayer.m_elTeam;
        if (!elTeam || !elTeam.IsValid())
            return;
        let elPlayer = oPlayer.m_elPlayer;
        if (!elPlayer || !elPlayer.IsValid())
            return;
        let children = elTeam.Children();
        for (let i = 0; i < children.length; i++) {
            if (oPlayer.m_xuid === children[i].m_xuid)
                continue;
            let oCompareTargetPlayer = _m_oPlayers.GetPlayerByXuid(children[i].m_xuid);
            if (!oCompareTargetPlayer)
                continue;
            for (let stat in _m_sortOrder) {
                let p1stat = oPlayer.m_oStats[stat];
                let p2stat = oCompareTargetPlayer.m_oStats[stat];
                if (_m_sortOrder[stat] === -1) {
                    let tmp = p1stat;
                    p1stat = p2stat;
                    p2stat = tmp;
                }
                if (_lessthan(p2stat, p1stat)) {
                    if (children[i - 1] != elPlayer) {
                        elTeam.MoveChildBefore(elPlayer, children[i]);
                    }
                    return;
                }
                else if (_lessthan(p1stat, p2stat)) {
                    break;
                }
            }
        }
    }
    function IsTeamASpecTeam(teamname) {
        return (teamname === 'Spectator' ||
            teamname === 'Unassigned' ||
            teamname === 'Unknown' ||
            teamname === 'UNKNOWN TEAM' ||
            teamname === '');
    }
    function _UpdateAllStatsForPlayer(oPlayer, oUpdateStatNames, bSilent = false) {
        const bIsUpdatingAllStats = true;
        for (let stat of oUpdateStatNames) {
            _UpdatePlayerStat(oPlayer, stat, bIsUpdatingAllStats, bSilent);
        }
    }
    function _GenericUpdateStat(oPlayer, stat, fnGetStat, bSilent = false) {
        let elPanel = oPlayer.m_oElStats[stat];
        if (!elPanel || !elPanel.IsValid())
            return;
        let newStatValue = fnGetStat(oPlayer.m_xuid);
        if (newStatValue !== oPlayer.m_oStats[stat]) {
            let elLabel = elPanel.m_elLabel;
            const validLabel = (elLabel && elLabel.IsValid()) ? true : false;
            if (!bSilent) {
                if (validLabel) {
                    _Pulse(elLabel);
                }
            }
            oPlayer.m_oStats[stat] = newStatValue;
            if (validLabel) {
                elLabel.text = newStatValue.toString();
            }
        }
    }
    function _GenericUpdateStatDirect(oPlayer, stat, val, bSilent = false) {
        let elPanel = oPlayer.m_oElStats[stat];
        if (!elPanel || !elPanel.IsValid())
            return;
        let newStatValue = val;
        if (newStatValue !== oPlayer.m_oStats[stat]) {
            let elLabel = elPanel.m_elLabel;
            const validLabel = (elLabel && elLabel.IsValid()) ? true : false;
            if (!bSilent) {
                if (validLabel) {
                    _Pulse(elLabel);
                }
            }
            oPlayer.m_oStats[stat] = newStatValue;
            if (validLabel) {
                elLabel.text = newStatValue.toString();
            }
        }
    }
    function _GetMatchStatFn(stat) {
        function _fn(xuid) {
            let oPlayer = _m_oPlayers.GetPlayerByXuid(xuid);
            if (oPlayer) {
                let allstats = oPlayer.m_oMatchStats;
                if (allstats)
                    return (allstats[stat] == -1) ? '-' : allstats[stat];
            }
            return '-';
        }
        return _fn;
    }
    function _UpdatePlayerStat(oPlayer, stat, bIsUpdatingAllStats, bSilent = false) {
        switch (stat) {
            case 'musickit':
                {
                    if (oPlayer.GetGameStat('is_fake_player')) {
                        return;
                    }
                    let ownerXuid = oPlayer.m_xuid;
                    let isLocalPlayer = oPlayer.m_xuid == GetLocalPlayerId();
                    let isBorrowed = false;
                    let borrowedXuid = "0";
                    let borrowedPlayerSlot = parseInt(GameInterfaceAPI.GetSettingString('cl_borrow_music_from_player_slot'));
                    if (borrowedPlayerSlot >= 0 && isLocalPlayer) {
                        borrowedXuid = GameStateAPI.GetPlayerXuidStringFromPlayerSlot(borrowedPlayerSlot);
                        if (MockAdapter.IsPlayerConnected(borrowedXuid)) {
                            ownerXuid = borrowedXuid;
                            isBorrowed = true;
                        }
                    }
                    let newStatValue = InventoryAPI.GetMusicIDForPlayer(ownerXuid);
                    if (newStatValue !== oPlayer.m_oStats[stat]) {
                        oPlayer.m_oStats[stat] = newStatValue;
                        if (isLocalPlayer) {
                            let elMusicKit = _m_panelCache.m_elMusicKit;
                            if (!elMusicKit || !elMusicKit.IsValid())
                                return;
                            let isValidMusicKit = newStatValue > 0;
                            elMusicKit.SetHasClass('hidden', !isValidMusicKit);
                            if (isValidMusicKit) {
                                if (_m_panelCache.m_elMusicKitUnborrow) {
                                    _m_panelCache.m_elMusicKitUnborrow.SetHasClass('hidden', !isBorrowed);
                                }
                                let imagepath = 'file://{images}/' + InventoryAPI.GetItemInventoryImageFromMusicID(newStatValue) + '.png';
                                let elMusicKitImage = $('#id-sb-meta__musickit-image');
                                if (elMusicKitImage) {
                                    elMusicKitImage.SetImage(imagepath);
                                }
                                let elMusicKitName = $('#id-sb-meta__musickit-name');
                                if (elMusicKitName) {
                                    elMusicKitName.text = $.Localize(InventoryAPI.GetMusicNameFromMusicID(newStatValue));
                                }
                            }
                        }
                    }
                    let elPlayer = oPlayer.m_elPlayer;
                    if (elPlayer && elPlayer.IsValid()) {
                        let elMusicKitIcon = elPlayer.FindChildTraverse('id-sb-name__musickit');
                        if (elMusicKitIcon && elMusicKitIcon.IsValid()) {
                            elMusicKitIcon.SetHasClass('hidden', newStatValue <= 1);
                        }
                    }
                }
                break;
            case 'teamname':
                {
                    const newTeam = (oPlayer.GetGameStat('team_name'));
                    const bChangedTeams = _ChangeTeams(oPlayer, newTeam);
                    if (bChangedTeams && !bIsUpdatingAllStats) {
                        _UpdateAllStatsForPlayer(oPlayer, _m_oUpdateStatNames, true);
                        _SortPlayer(oPlayer);
                    }
                }
                break;
            case 'ping':
                {
                    let elPlayer = oPlayer.m_elPlayer;
                    if (!elPlayer || !elPlayer.IsValid())
                        return;
                    let elPanel = oPlayer.m_oElStats[stat];
                    if (!elPanel || !elPanel.IsValid())
                        return;
                    let elLabel = elPanel.m_elLabel;
                    if (!elLabel)
                        return;
                    oPlayer.m_elPlayer?.SetHasClass('bot', oPlayer.GetGameStat('is_fake_player'));
                    let szCustomLabel = _GetCustomStatTextValue('ping', oPlayer);
                    elLabel.SetHasClass('sb-row__cell--ping__label--bot', !!szCustomLabel);
                    if (szCustomLabel) {
                        elLabel.text = $.Localize(szCustomLabel);
                        oPlayer.m_oStats[stat] = szCustomLabel;
                    }
                    else {
                        _GenericUpdateStatDirect(oPlayer, stat, oPlayer.GetGameStat('ping'), true);
                    }
                }
                break;
            case 'kills':
                {
                    _GenericUpdateStatDirect(oPlayer, stat, oPlayer.GetGameStat('kills'), bSilent);
                }
                break;
            case 'assists':
                {
                    _GenericUpdateStatDirect(oPlayer, stat, oPlayer.GetGameStat('assists'), bSilent);
                }
                break;
            case 'deaths':
                {
                    _GenericUpdateStatDirect(oPlayer, stat, oPlayer.GetGameStat('deaths'), bSilent);
                }
                break;
            case '3k':
            case '4k':
            case '5k':
            case 'adr':
            case 'hsp':
            case 'utilitydamage':
            case 'enemiesflashed':
            case 'damage':
            case 'knifekills':
            case 'taserkills':
                {
                    _GenericUpdateStat(oPlayer, stat, _GetMatchStatFn(stat), bSilent);
                }
                break;
            case 'kdr':
                {
                    let kdr;
                    if (_m_overtime == 0) {
                        let kdrFn = _GetMatchStatFn('kdr');
                        kdr = kdrFn(oPlayer.m_xuid);
                        if (typeof kdr == 'number' && kdr > 0) {
                            kdr = kdr / 100.0;
                        }
                    }
                    else {
                        let denom = oPlayer.GetStatNum('deaths') || 1;
                        kdr = oPlayer.GetStatNum('kills') / denom;
                    }
                    if (typeof kdr == 'number') {
                        kdr = kdr.toFixed(2);
                    }
                    _GenericUpdateStat(oPlayer, stat, () => { return kdr; }, bSilent);
                }
                break;
            case 'mvps':
                {
                    let newStatValue = oPlayer.GetGameStat('mvps');
                    if (newStatValue !== oPlayer.m_oStats[stat]) {
                        let elMVPPanel = oPlayer.m_oElStats[stat];
                        if (!elMVPPanel || !elMVPPanel.IsValid())
                            return;
                        let elMVPStarImage = elMVPPanel.FindChildTraverse('star-image');
                        if (!elMVPStarImage || !elMVPStarImage.IsValid())
                            return;
                        let elMVPStarNumberLabel = elMVPPanel.FindChildTraverse('star-count');
                        if (!elMVPStarNumberLabel || !elMVPStarNumberLabel.IsValid())
                            return;
                        oPlayer.m_oStats[stat] = newStatValue;
                        elMVPStarImage.SetHasClass('hidden', newStatValue == 0);
                        elMVPStarNumberLabel.SetHasClass('hidden', newStatValue == 0);
                        elMVPStarNumberLabel.text = newStatValue.toString();
                        if (!bSilent) {
                            _Pulse(elMVPStarImage);
                            _Pulse(elMVPStarNumberLabel);
                        }
                    }
                }
                break;
            case 'status':
                {
                    let newStatValue = oPlayer.GetGameStat('status');
                    if (newStatValue !== oPlayer.m_oStats[stat]) {
                        oPlayer.m_oStats[stat] = newStatValue;
                        let elPlayer = oPlayer.m_elPlayer;
                        if (!elPlayer || !elPlayer.IsValid())
                            return;
                        elPlayer.SetHasClass('sb-player-status-dead', newStatValue === 1);
                        elPlayer.SetHasClass('sb-player-status-disconnected', newStatValue === 15);
                        oPlayer.m_oStats['dc'] = newStatValue === 15 ? 0 : 1;
                        let elPanel = oPlayer.m_oElStats[stat];
                        if (!elPanel || !elPanel.IsValid())
                            return;
                        let elStatusImage = elPanel.m_elImage;
                        if (!elStatusImage || !elStatusImage.IsValid())
                            return;
                        elStatusImage.SetImage(dictPlayerStatusImage[newStatValue]);
                    }
                }
                break;
            case 'score':
                {
                    _GenericUpdateStatDirect(oPlayer, stat, oPlayer.GetGameStat('score'));
                }
                break;
            case 'gglevel':
                {
                    _GenericUpdateStat(oPlayer, stat, () => Math.floor(oPlayer.GetGameStat('score') / 2));
                }
                break;
            case 'money':
                {
                    let elPanel = oPlayer.m_oElStats[stat];
                    if (!elPanel || !elPanel.IsValid())
                        return;
                    let elLabel = elPanel.m_elLabel;
                    if (!elLabel || !elLabel.IsValid())
                        return;
                    let newStatValue = oPlayer.GetGameStat('money');
                    if (newStatValue !== oPlayer.m_oStats[stat]) {
                        if (newStatValue >= 0) {
                            elLabel.SetHasClass('hidden', false);
                            elLabel.SetDialogVariableInt('stat_d_money', newStatValue);
                        }
                        else {
                            elLabel.SetHasClass('hidden', true);
                        }
                        oPlayer.m_oStats[stat] = newStatValue;
                    }
                }
                break;
            case 'name':
                {
                    if (!oPlayer.m_elPlayer || !oPlayer.m_elPlayer.IsValid())
                        return;
                    oPlayer.m_elPlayer.SetHasClass('sb-row--localplayer', oPlayer.m_xuid === GetLocalPlayerId());
                    let elPanel = oPlayer.m_oElStats[stat];
                    if (!elPanel || !elPanel.IsValid())
                        return;
                    oPlayer.m_elPlayer.SetDialogVariableInt('player_slot', oPlayer.GetGameStat('slot'));
                }
                break;
            case 'honoricon':
                {
                    if (!oPlayer.m_elPlayer || !oPlayer.m_elPlayer.IsValid())
                        return;
                    const xp_trail_level = oPlayer.GetGameStat('xp_trail_level');
                    if (oPlayer.m_xp_trail_level != xp_trail_level) {
                        const elHonorIcon = oPlayer.m_elPlayer.FindChildTraverse('jsHonorIcon');
                        if (elHonorIcon)
                            elHonorIcon.Set(xp_trail_level, false);
                        oPlayer.m_xp_trail_level = xp_trail_level;
                    }
                }
                break;
            case 'leader':
            case 'teacher':
            case 'friendly':
                {
                    let localPlayer = _m_oPlayers.GetPlayerByXuid(GetLocalPlayerId());
                    let teamName = localPlayer?.m_team?.m_teamName || '';
                    if (GameStateAPI.IsDemoOrHltv() || IsTeamASpecTeam(teamName))
                        return;
                    let newStatValue;
                    if (!oPlayer.GetGameStat('is_valid_xuid')) {
                        return;
                    }
                    else {
                        switch (stat) {
                            case 'leader':
                                newStatValue = oPlayer.GetGameStat('commend_leader');
                                break;
                            case 'teacher':
                                newStatValue = oPlayer.GetGameStat('commend_teacher');
                                break;
                            case 'friendly':
                                newStatValue = oPlayer.GetGameStat('commend_friendly');
                                break;
                        }
                    }
                    if (oPlayer.m_oStats[stat] != newStatValue) {
                        oPlayer.m_oStats[stat] = newStatValue;
                        if (oPlayer.m_team)
                            oPlayer.m_team.UpdateCommendForPlayer(oPlayer.m_xuid, stat, newStatValue);
                    }
                }
                break;
            case 'flair':
                {
                    if (GameStateAPI.IsLatched()) {
                        return;
                    }
                    let newStatValue = InventoryAPI.GetFlairItemId(oPlayer.m_xuid);
                    if (oPlayer.m_oStats[stat] !== newStatValue) {
                        oPlayer.m_oStats[stat] = newStatValue;
                        let elPanel = oPlayer.m_oElStats[stat];
                        if (!elPanel || !elPanel.IsValid())
                            return;
                        let elFlairImage = elPanel.m_elImage;
                        if (!elFlairImage || !elFlairImage.IsValid())
                            return;
                        let imagepath = InventoryAPI.GetFlairItemImage(oPlayer.m_xuid);
                        if (imagepath !== '') {
                            elFlairImage.SetImage('file://{images}' + imagepath + '_small.png');
                        }
                    }
                }
                break;
            case 'avatar':
                {
                    let elPanel = oPlayer.m_oElStats[stat];
                    if (!elPanel || !elPanel.IsValid())
                        return;
                    let elAvatarImage = elPanel.m_elImage;
                    if (!elAvatarImage || !elAvatarImage.IsValid())
                        return;
                    const slot = oPlayer.GetGameStat('slot');
                    if (slot >= 0) {
                        elAvatarImage.PopulateFromPlayerSlot(slot);
                    }
                    const team = oPlayer.m_team?.m_teamName || '';
                    elAvatarImage.SwitchClass('teamstyle', 'team--' + team);
                    if (elAvatarImage.m_elPlayerColor == undefined) {
                        elAvatarImage.m_elPlayerColor = elAvatarImage.FindChildTraverse('player-color');
                    }
                    let elPlayerColor = elAvatarImage.m_elPlayerColor;
                    if (elPlayerColor && elPlayerColor.IsValid()) {
                        let teamColor = oPlayer.GetGameStat('color');
                        if ((elAvatarImage.m_playerCol == undefined) || (teamColor !== elAvatarImage.m_playerCol)) {
                            elAvatarImage.m_playerCol = teamColor;
                            if (teamColor !== '') {
                                elPlayerColor.style.washColor = teamColor;
                                elPlayerColor.RemoveClass('hidden');
                            }
                            else {
                                elPlayerColor.AddClass('hidden');
                            }
                        }
                    }
                    let isMuted = oPlayer.GetGameStat('is_muted');
                    oPlayer.m_isMuted = isMuted;
                    let isEnemyTeamMuted = GameInterfaceAPI.GetSettingString("cl_mute_enemy_team") == "1";
                    let isEnemy = oPlayer.GetGameStat('is_enemy');
                    let hasComAbusePenalty = oPlayer.GetGameStat('has_abuse_mute');
                    let isLocalPlayer = oPlayer.m_xuid == GetLocalPlayerId();
                    oPlayer.m_elPlayer.SetHasClass('muted', isMuted || (isEnemy && isEnemyTeamMuted) || (isLocalPlayer && hasComAbusePenalty));
                }
                break;
            case 'skillgroup':
                {
                    const elPlayer = oPlayer.m_elPlayer;
                    if (!elPlayer || !elPlayer.IsValid())
                        return;
                    let elSkillgroup = elPlayer.m_elSkillGroup;
                    if (elSkillgroup && elSkillgroup.IsValid()) {
                        let newStatValue = oPlayer.GetGameStat('comp_ranking');
                        if (newStatValue > 0) {
                            elSkillgroup.visible = true;
                            if (oPlayer.m_oStats[stat] !== newStatValue) {
                                oPlayer.m_oStats[stat] = newStatValue;
                                const rating_type = oPlayer.GetGameStat('comp_type');
                                const score = oPlayer.GetGameStat('comp_ranking');
                                const wins = oPlayer.GetGameStat('comp_wins');
                                let options = {
                                    root_panel: elSkillgroup,
                                    full_details: false,
                                    rating_type: rating_type,
                                    leaderboard_details: { score: score, matchesWon: wins },
                                    local_player: oPlayer.m_xuid === MyPersonaAPI.GetXuid()
                                };
                                RatingEmblem.SetXuid(options);
                            }
                        }
                        else {
                            elSkillgroup.visible = false;
                        }
                    }
                }
                break;
            case 'rank':
                {
                    let newStatValue = MockAdapter.GetPlayerXpLevel(oPlayer.m_xuid);
                    if (oPlayer.m_oStats[stat] !== newStatValue) {
                        oPlayer.m_oStats[stat] = newStatValue;
                        let elPanel = oPlayer.m_oElStats[stat];
                        if (!elPanel || !elPanel.IsValid())
                            return;
                        let elRankImage = elPanel.m_elImage;
                        if (!elRankImage || !elRankImage.IsValid())
                            return;
                        let imagepath = '';
                        if (newStatValue > 0) {
                            imagepath = 'file://{images}/icons/xp/level' + newStatValue + '.png';
                        }
                        else {
                            imagepath = '';
                        }
                        elRankImage.SetImage(imagepath);
                    }
                }
                break;
            default:
                {
                }
                break;
        }
    }
    function _InitializeStatUpdateFuncs() {
        try {
            for (let stat of _statNames) {
                _m_oAllUpdateStatNames.push(stat);
            }
            _UpdateJob();
        }
        catch {
        }
    }
    function _RegisterStatUpdate(stat) {
        if (_m_oAllUpdateStatNames.includes(stat) && !_m_oUpdateStatNames.includes(stat)) {
            _m_oUpdateStatNames.push(stat);
        }
    }
    function _GetPlayerRowForGameMode() {
        let mode = MockAdapter.GetGameModeInternalName(false);
        let skirmish = MockAdapter.GetGameModeInternalName(true);
        if (GameStateAPI.IsQueuedMatchmakingMode_Team()) {
            return 'snippet_scoreboard-classic__row--premier';
        }
        switch (mode) {
            case 'scrimcomp2v2':
                return 'snippet_scoreboard-classic__row--wingman';
            case 'competitive':
            case 'premier':
            case 'rush':
                return 'snippet_scoreboard-classic__row--comp';
            case 'training':
                return 'snippet_scoreboard__row--training';
            case 'deathmatch':
                return 'snippet_scoreboard__row--deathmatch';
            case 'gungameprogressive':
                return 'snippet_scoreboard__row--armsrace';
            case 'coopmission':
            case 'cooperative':
                return 'snippet_scoreboard__row--cooperative';
            case 'casual':
                if (skirmish == 'flyingscoutsman')
                    return 'snippet_scoreboard__row--flyingscoutsman';
                else
                    return 'snippet_scoreboard-classic__row--casual';
            default:
                return 'snippet_scoreboard-classic__row--casual';
        }
    }
    function _HighlightSortStatLabel(stat) {
        for (let el of _m_cP.FindChildrenWithClassTraverse('sb-row__cell')) {
            if (el && el.IsValid()) {
                if (el.BHasClass('sb-row__cell--' + stat)) {
                    el.AddClass('sortstat');
                }
                else {
                    el.RemoveClass('sortstat');
                }
            }
        }
    }
    function _CreateLabelForStat(stat, set, isHidden) {
        let elLabelRow = $('#id-sb-players-table__labels-row__inner');
        if (!elLabelRow || !elLabelRow.IsValid())
            return;
        let elLabelRowOrSet = elLabelRow;
        if (set !== '') {
            let labelSetContainerId = 'id-sb-row__set-container';
            let elLabelSetContainer = $('#' + labelSetContainerId);
            if (!elLabelSetContainer || !elLabelSetContainer.IsValid()) {
                elLabelSetContainer = $.CreatePanel('Panel', elLabelRow, labelSetContainerId);
                elLabelSetContainer.BLoadLayoutSnippet('snippet_sb-label-set-container');
                if ($('#id-sb-row__set-container')) {
                    $('#id-sb-meta__cycle').RemoveClass('hidden');
                }
            }
            let elSetLabels = elLabelSetContainer.FindChildTraverse('id-sb-row__sets');
            let LabelSetId = 'id-sb-labels-set-' + set;
            let elLabelSet = elSetLabels.FindChildTraverse(LabelSetId);
            let elLabelSetClasses = [];
            if (!elLabelSet || !elLabelSet.IsValid()) {
                _m_dataSetGetCount++;
                elLabelSet = $.CreatePanel('Panel', elSetLabels, LabelSetId);
                elLabelSetClasses.push('sb-row__set', 'no-hover');
            }
            elLabelRowOrSet = elLabelSet;
            if (set != _m_dataSetCurrent.toString()) {
                elLabelSetClasses.push('hidden');
            }
            if (elLabelSetClasses.length > 0) {
                elLabelSet.AddClasses(elLabelSetClasses);
            }
        }
        let elStatPanel = elLabelRowOrSet.FindChildInLayoutFile('id-sb-' + stat);
        if (!elStatPanel || !elStatPanel.IsValid()) {
            let statPanelClasses = ['sb-row__cell', 'sb-row__cell--' + stat, 'sb-row__cell--label'].join(" ");
            elStatPanel = $.CreatePanel('Button', elLabelRowOrSet, 'id-sb-' + stat, { class: statPanelClasses });
            let elStatLabel;
            if (stat === 'ping') {
                elStatLabel = $.CreatePanel('Image', elStatPanel, 'label-' + elStatPanel.id);
                elStatLabel.SetImage('file://{images}/icons/ui/ping_4.svg');
            }
            else {
                elStatLabel = $.CreatePanel('Label', elStatPanel, 'label-' + elStatPanel.id);
                if (isHidden == '1') {
                    elStatLabel.text = '';
                }
                else {
                    elStatLabel.text = $.Localize('#Scoreboard_' + stat);
                }
            }
            let toolTipString = $.Localize('#Scoreboard_' + stat + '_tooltip');
            if (toolTipString !== '') {
                elStatLabel.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip(elStatLabel.id, toolTipString));
                elStatLabel.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
            }
            elStatPanel.SetPanelEvent('onactivate', () => {
                let newSortOrder = { 'dc': 0 };
                let modeDefaultSortOrder = _GetSortOrderForMode(MockAdapter.GetGameModeInternalName(false));
                if (stat in modeDefaultSortOrder)
                    newSortOrder[stat] = modeDefaultSortOrder[stat];
                else
                    return;
                _HighlightSortStatLabel(stat);
                for (let s in modeDefaultSortOrder) {
                    if (s == stat)
                        continue;
                    if (s == 'dc')
                        continue;
                    newSortOrder[s] = modeDefaultSortOrder[s];
                }
                _m_sortOrder = newSortOrder;
                for (let i = 0; i < _m_oPlayers.GetCount(); i++) {
                    let oPlayer = _m_oPlayers.GetPlayerByIndex(i);
                    _SortPlayer(oPlayer);
                }
            });
        }
    }
    function _GetCustomStatTextValue(stat, oPlayer) {
        let szCustomLabel = null;
        if (stat === 'ping') {
            if (oPlayer.GetGameStat('status') == 15) {
                szCustomLabel = '#SFUI_scoreboard_lbl_dc';
            }
            else if (IsTeamASpecTeam(oPlayer.m_team?.m_teamName || '')) {
                szCustomLabel = '#SFUI_scoreboard_lbl_spec';
            }
        }
        return szCustomLabel;
    }
    function _CreatePlayerButtons(oPlayer) {
        if ((oPlayer.m_xuid == '') || MockAdapter.IsFakePlayer(oPlayer.m_xuid))
            return;
        const xuid = oPlayer.m_elPlayer ? oPlayer.m_elPlayer.m_xuid : '';
        for (let entry of ContextmenuPlayerCard.ContextMenus) {
            if (entry.AvailableForItem(xuid)) {
                if (!oPlayer.m_oElStats.hasOwnProperty(entry.name))
                    continue;
                const elContextMenuBtns = oPlayer.m_oElStats[entry.name];
                if ('xml' in entry) {
                    let elEntryBtn = $.CreatePanel('Panel', elContextMenuBtns, entry.name, {
                        class: 'cell__button',
                        style: 'tooltip-position: bottom;'
                    });
                    elEntryBtn.BLoadLayout(entry.xml, false, false);
                }
                else {
                    let elEntryBtn = $.CreatePanel('Button', elContextMenuBtns, entry.name + '_' + xuid, {
                        class: 'cell__button',
                        style: 'tooltip-position: bottom;'
                    });
                    $.CreatePanel('Image', elEntryBtn, entry.name, { src: 'file://{images}/icons/ui/' + entry.icon + '.svg' });
                    let tooltip = '#tooltip_' + entry.name;
                    if ('IsDisabled' in entry) {
                        if (entry.IsDisabled()) {
                            elEntryBtn.enabled = false;
                            tooltip = '#tooltip_disabled_' + entry.name;
                        }
                        else {
                            elEntryBtn.enabled = true;
                        }
                    }
                    let onSelected = entry.OnSelected;
                    elEntryBtn.SetPanelEvent('onactivate', () => onSelected(xuid, ''));
                    {
                        elEntryBtn.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip(elEntryBtn.id, tooltip));
                        elEntryBtn.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
                    }
                }
            }
        }
    }
    function _NewPlayerPanel(oPlayer) {
        if (!oPlayer.m_elTeam || !oPlayer.m_elTeam.IsValid())
            return;
        oPlayer.m_elPlayer = $.CreatePanel('Panel', oPlayer.m_elTeam, 'player-' + oPlayer.m_xuid);
        oPlayer.m_elPlayer.m_xuid = oPlayer.m_xuid;
        _Helper_LoadSnippet(oPlayer.m_elPlayer, _GetPlayerRowForGameMode());
        _CreateLabelsForRow(oPlayer.m_elPlayer);
        oPlayer.m_elPlayer.m_elSkillGroup = oPlayer.m_elPlayer.FindChildTraverse('jsRatingEmblem');
        {
            _RegisterStatUpdate('teamname');
            _RegisterStatUpdate('musickit');
            _RegisterStatUpdate('status');
            _RegisterStatUpdate('skillgroup');
            _RegisterStatUpdate('leader');
            _RegisterStatUpdate('teacher');
            _RegisterStatUpdate('friendly');
            _RegisterStatUpdate('honoricon');
        }
        let idx = 0;
        function _InitStatCell(elStatCell, oPlayer) {
            if (!elStatCell || !elStatCell.IsValid())
                return;
            const stat = elStatCell.GetAttributeString('data-stat', '');
            let children = elStatCell.Children();
            for (let i = 0; i < children.length; i++) {
                _InitStatCell(children[i], oPlayer);
            }
            if (stat === '') {
                return;
            }
            oPlayer.m_oElStats[stat] = elStatCell;
            if (oPlayer.m_oElStats[stat]) {
                let elLabel = oPlayer.m_oElStats[stat].FindChildTraverse('label');
                oPlayer.m_oElStats[stat].m_elLabel = elLabel;
                let elImg = oPlayer.m_oElStats[stat].FindChildTraverse('image');
                oPlayer.m_oElStats[stat].m_elImage = elImg;
            }
            let elStatCellClasses = ['sb-row__cell', 'sb-row__cell--' + stat];
            const set = elStatCell.GetAttributeString('data-set', '');
            if (set !== '') {
                let SetContainerId = 'id-sb-row__set-container';
                let elParent = elStatCell.GetParent();
                let elSetContainer = oPlayer.m_elPlayer.FindChildTraverse(SetContainerId);
                if (!elSetContainer || !elSetContainer.IsValid()) {
                    elSetContainer = $.CreatePanel('Panel', elParent, SetContainerId);
                    elParent.MoveChildAfter(elSetContainer, elStatCell);
                }
                let setId = 'id-sb-set-' + set;
                let elSetClasses = [];
                let elSet = elSetContainer.FindChildTraverse(setId);
                if (!elSet || !elSet.IsValid) {
                    elSet = $.CreatePanel('Panel', elSetContainer, setId);
                    elSetClasses.push('sb-row__set', 'no-hover');
                    idx = 0;
                }
                elStatCell.SetParent(elSet);
                if (set != _m_dataSetCurrent.toString()) {
                    elSetClasses.push('hidden');
                }
                if (elSetClasses.length > 0) {
                    elSet.AddClasses(elSetClasses);
                }
            }
            if (idx++ % 2)
                elStatCellClasses.push('sb-row__cell--dark');
            elStatCell.AddClasses(elStatCellClasses);
            const isHidden = elStatCell.GetAttributeString('data-hidden', '');
            if (!isHidden) {
                _RegisterStatUpdate(stat);
            }
        }
        const elStatCells = oPlayer.m_elPlayer.Children();
        for (let i = 0; i < elStatCells.length; i++) {
            _InitStatCell(elStatCells[i], oPlayer);
        }
        _CreatePlayerButtons(oPlayer);
        oPlayer.m_oStats = {};
        oPlayer.m_oStats['idx'] = GameStateAPI.GetPlayerSlot(oPlayer.m_xuid);
        oPlayer.m_elPlayer.SetPanelEvent('onmouseover', () => { _m_arrSortingPausedRefGetCounter++; });
        oPlayer.m_elPlayer.SetPanelEvent('onmouseout', () => { _m_arrSortingPausedRefGetCounter--; });
        if (MockAdapter.IsXuidValid(oPlayer.m_xuid)) {
            oPlayer.m_elPlayer.SetPanelEvent('onactivate', () => {
                _m_arrSortingPausedRefGetCounter++;
                let elPlayerCardContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEventSetFocus('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + oPlayer.m_xuid, _OnPlayerCardDismiss, false);
                if (elPlayerCardContextMenu) {
                    elPlayerCardContextMenu.AddClass('ContextMenu_NoArrow');
                }
                if (!_m_hDenyInputToGame) {
                    _m_hDenyInputToGame = UiToolkitAPI.AddDenyInputFlagsToGame(elPlayerCardContextMenu, 'ScoreboardPlayercard', 'CaptureMouse');
                }
            });
        }
        return oPlayer.m_elPlayer;
    }
    function _OnPlayerCardDismiss() {
        _m_arrSortingPausedRefGetCounter--;
        if (_m_hDenyInputToGame) {
            UiToolkitAPI.ReleaseDenyInputFlagsToGame(_m_hDenyInputToGame);
            _m_hDenyInputToGame = null;
        }
    }
    function _UpdateMatchInfo() {
        if (!_m_bInit)
            return;
        let updateMapLabel = false;
        let queueChanged = false;
        let imagePathChanged = false;
        const mi = GameStateAPI.GetMatchInfoJSO();
        const server_name = _m_haveViewers ? '' : mi.server_name;
        const map_name = mi.map_name;
        const map_bsp_name = mi.map_bsp_name;
        const gamemode_name = mi.gamemode_name;
        const gamemode_internal_name = mi.gamemode_internal_name;
        const gamemode_image_path = mi.gamemode_image_path;
        const tournament_stage = mi.tournament_stage;
        const is_queued_mm_team = mi.is_queued_mm_team;
        const is_demo_or_hltv = mi.is_demo_or_hltv;
        if (_m_cP.m_matchInfo == undefined) {
            updateMapLabel = true;
            queueChanged = true;
            imagePathChanged = true;
            _m_cP.m_matchInfo = { ...mi };
        }
        else {
            if ((_m_cP.m_matchInfo.server_name !== server_name)
                || (_m_cP.m_matchInfo.map_name !== map_name)
                || (_m_cP.m_matchInfo.gamemode_name !== gamemode_name)
                || (_m_cP.m_matchInfo.tournament_stage !== tournament_stage)
                || (_m_cP.m_matchInfo.map_bsp_name !== map_bsp_name)
                || (_m_cP.m_matchInfo.gamemode_internal_name !== gamemode_internal_name)) {
                updateMapLabel = true;
            }
            if (_m_cP.m_matchInfo.gamemode_image_path !== gamemode_image_path) {
                imagePathChanged = true;
            }
            if (_m_cP.m_matchInfo.is_queued_mm_team !== is_queued_mm_team) {
                updateMapLabel = true;
                queueChanged = true;
            }
            if (updateMapLabel || imagePathChanged || queueChanged || (_m_cP.m_matchInfo.is_demo_or_hltv !== is_demo_or_hltv)) {
                _m_cP.m_matchInfo = { ...mi };
            }
        }
        if (updateMapLabel) {
            _m_cP.SetDialogVariable('server_name', server_name);
            _m_cP.SetDialogVariable('map_name', map_name);
            _m_cP.SetDialogVariable('gamemode_name', gamemode_name);
            _m_cP.SetDialogVariable('tournament_stage', tournament_stage);
            const elMapLabel = _m_panelCache.m_elMetaLabelsModeMap;
            if (elMapLabel) {
                if (MatchStatsAPI.IsTournamentMatch()) {
                    const labelText = $.Localize('{s:tournament_stage} | {s:map_name}', _m_cP);
                    elMapLabel.text = labelText;
                }
                else {
                    let strLocalizeScoreboardTitle = '{s:gamemode_name} | {s:map_name}';
                    const mode = gamemode_internal_name;
                    if ((mode === 'competitive' || mode === 'premier') &&
                        (GameTypesAPI.GetMapGroupAttribute('mg_' + map_bsp_name, 'competitivemod') === 'unranked')) {
                        strLocalizeScoreboardTitle = $.Localize('#SFUI_RankType_Modifier_Unranked', _m_cP) + ' | {s:map_name}';
                    }
                    else if (is_queued_mm_team) {
                        let sMapName = '{s:map_name}';
                        if (map_bsp_name === 'lobby_mapveto')
                            sMapName = $.Localize('#matchdraft_arena_name', _m_cP);
                        strLocalizeScoreboardTitle = $.Localize('#SFUI_GameModeCompetitiveTeams', _m_cP) + ' | ' + sMapName;
                    }
                    const labelText = $.Localize(strLocalizeScoreboardTitle, _m_cP);
                    elMapLabel.text = labelText;
                }
            }
        }
        const elMetaModeImage = _m_panelCache.m_metaModeImage;
        const updateModeImage = (queueChanged || (!is_queued_mm_team && imagePathChanged));
        if (elMetaModeImage && updateModeImage) {
            if (is_queued_mm_team)
                elMetaModeImage.SetImage('file://{images}/icons/ui/competitive_teams.svg');
            else
                elMetaModeImage.SetImage(gamemode_image_path);
        }
        const elMetaLabelsMap = _m_panelCache.m_metaLabelsMap;
        if (elMetaLabelsMap) {
            elMetaLabelsMap.SetImage('file://{images}/map_icons/map_icon_' + map_bsp_name + '.svg');
        }
        const elCoopStats = _m_panelCache.m_coopStats;
        if (elCoopStats) {
            let questID = GameStateAPI.GetActiveQuestID();
            if (questID > 0) {
                elCoopStats.AddClass('show-mission-desc');
                let elLabel = elCoopStats.FindChildInLayoutFile('MissionDescriptionLabel');
                if (elLabel) {
                    let strMissionDescriptionToken = MissionsAPI.GetQuestDefinitionField(questID, 'loc_description');
                    elLabel.text = $.Localize(strMissionDescriptionToken, elCoopStats);
                }
            }
        }
        if (!is_demo_or_hltv) {
            let oPlayer = _m_oPlayers.GetPlayerByXuid(GetLocalPlayerId());
            if (oPlayer && oPlayer.m_team) {
                oPlayer.m_team.CalculateAllCommends();
            }
        }
        const elMouseBinding = _m_panelCache.m_elMouseBinding;
        if (elMouseBinding && elMouseBinding.IsValid()) {
            let bind = GameInterfaceAPI.GetSettingString('cl_scoreboard_mouse_enable_binding');
            if (bind.charAt(0) == '+' || bind.charAt(0) == '-')
                bind = bind.substring(1);
            if ((elMouseBinding.m_bindStr == undefined) || (bind != elMouseBinding.m_bindStr)) {
                elMouseBinding.m_bindStr = bind;
                elMouseBinding.SetDialogVariable('scoreboard_mouse_enable_bind', $.Localize(`{s:bind_${bind}}`, elMouseBinding));
                let strinstruction = $.Localize('#Scoreboard_Mouse_Enable_Instruction', elMouseBinding);
                elMouseBinding.text = $.Localize('#Scoreboard_Mouse_Enable_Instruction', elMouseBinding);
            }
        }
        const elFooterWebsite = _m_panelCache.m_elFooterWebsite;
        if (elFooterWebsite && elFooterWebsite.IsValid()) {
            const strWebsiteURL = MatchStatsAPI.GetServerWebsiteURL(false);
            if (strWebsiteURL) {
                elFooterWebsite.SetHasClass('hidden', false);
                elFooterWebsite.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip('id-sb-footer-server-website', strWebsiteURL));
                elFooterWebsite.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
            }
            else {
                elFooterWebsite.SetHasClass('hidden', true);
            }
        }
    }
    function _UpdateHLTVViewerNumber(nViewers) {
        _m_cP.SetDialogVariableInt('viewers', nViewers);
        _m_haveViewers = nViewers > 0;
        _m_cP.SetDialogVariable('hltv_viewers', _m_haveViewers ? $.Localize('#Scoreboard_Viewers', _m_cP) : '');
    }
    function _UpdateRound(rnd, oScoreData, jsoTime) {
        if (!_SupportsTimeline(jsoTime))
            return;
        if (!oScoreData)
            return;
        if (!jsoTime)
            return;
        if (!('teamdata' in oScoreData))
            return;
        let elTimeline = _m_panelCache.m_elTimelineSegments;
        if (!elTimeline || !elTimeline.IsValid())
            return;
        let elRnd = ((rnd >= 0) && (rnd < _m_panelCache.m_elRounds.length)) ? _m_panelCache.m_elRounds[rnd] : undefined;
        if (!elRnd || !elRnd.IsValid())
            return;
        let elRndTop = elRnd.m_elRndTop;
        let elRndBot = elRnd.m_elRndBot;
        let elRndTick = elRnd.m_elRndTick;
        let elRndTickLabel = elRnd.m_elRndTickLabel;
        let elTick = elRndTick;
        elRndTop.m_elResult.SetImage('');
        elRndBot.m_elResult.SetImage('');
        elRndTop.SetDialogVariable('sb_clinch', '');
        elRndBot.SetDialogVariable('sb_clinch', '');
        if (elTick && elTick.IsValid()) {
            elTick.SetHasClass('hilite', rnd <= jsoTime.rounds_played + 1);
        }
        if (rnd > jsoTime.rounds_played) {
            let bCanClinch = jsoTime.can_clinch;
            if (bCanClinch) {
                let numToClinch = jsoTime.num_wins_to_clinch;
                let topClinchRound = jsoTime.rounds_played + numToClinch - m_topScore;
                let bThisRoundIsClinchTop = rnd == topClinchRound;
                let botClinchRound = jsoTime.rounds_played + numToClinch - m_botScore;
                let bThisRoundIsClinchBot = rnd == botClinchRound;
                let bShowClinchTop = (bThisRoundIsClinchTop && topClinchRound <= botClinchRound);
                let bShowClinchBot = (bThisRoundIsClinchBot && botClinchRound <= topClinchRound);
                let thisRoundIsClinchAndShowIt = false;
                if (bShowClinchTop) {
                    elRndTop.m_elResult.SetImage(dictRoundResultImage['win']);
                    thisRoundIsClinchAndShowIt = true;
                }
                if (bShowClinchBot) {
                    elRndBot.m_elResult.SetImage(dictRoundResultImage['win']);
                    thisRoundIsClinchAndShowIt = true;
                }
                let roundIsPastClinch = (rnd > topClinchRound || rnd > botClinchRound);
                elRnd.SetHasClass('past-clinch', roundIsPastClinch);
                elRnd.SetHasClass('clinch-round', thisRoundIsClinchAndShowIt);
            }
            elRndTick.RemoveClasses(['sb-team--CT', 'sb-team--TERRORIST']);
            elRndTickLabel.RemoveClasses(['sb-team--CT', 'sb-team--TERRORIST']);
            function _ClearCasualties(elRnd) {
                for (let i = 1; i <= 5; i++) {
                    let img = elRnd.m_elCasualties[i];
                    if (!img)
                        break;
                    img.AddClass('hidden');
                }
            }
            ;
            _ClearCasualties(elRndTop);
            _ClearCasualties(elRndBot);
            return;
        }
        let bFlippedSides = false;
        if (MockAdapter.AreTeamsPlayingSwitchedSides() !== MockAdapter.AreTeamsPlayingSwitchedSidesInRound(rnd)) {
            bFlippedSides = true;
            let elTemp = elRndTop;
            elRndTop = elRndBot;
            elRndBot = elTemp;
        }
        elRndTop.AddClass('sb-team--CT');
        elRndBot.AddClass('sb-team--TERRORIST');
        const roundData = oScoreData.rounddata[rnd];
        if (typeof roundData !== 'object') {
            return;
        }
        let result = roundData.result;
        if (result.charAt(0) === 'c') {
            if (bFlippedSides)
                m_botScore++;
            else
                m_topScore++;
            if ((result.charAt(1) === 't') && (result.charAt(2) === '_')) {
                result = result.substring(3);
            }
            if ((MockAdapter.GetGameModeInternalName(false) == 'rush')) {
                result = "win_rush";
            }
            elRndTop.m_elResult.SetImage(dictRoundResultImage[result]);
            elRndTop.m_elResult.AddClass('sb-timeline__segment__round--active');
            elRndBot.m_elResult.SetImage('');
            elRndBot.m_elResult.RemoveClass('sb-timeline__segment__round--active');
            elRndTick.AddClass('sb-team--CT');
            elRndTickLabel.AddClass('sb-team--CT');
            elRndTick.RemoveClass('sb-team--TERRORIST');
            elRndTickLabel.RemoveClass('sb-team--TERRORIST');
        }
        else if (result.charAt(0) === 't') {
            if (bFlippedSides)
                m_topScore++;
            else
                m_botScore++;
            if (result.charAt(1) === '_') {
                result = result.substring(2);
            }
            if ((MockAdapter.GetGameModeInternalName(false) == 'rush')) {
                result = "win_rush";
            }
            elRndBot.m_elResult.SetImage(dictRoundResultImage[result]);
            elRndBot.m_elResult.AddClass('sb-timeline__segment__round--active');
            elRndTop.m_elResult.SetImage('');
            elRndTop.m_elResult.RemoveClass('sb-timeline__segment__round--active');
            elRndTick.AddClass('sb-team--TERRORIST');
            elRndTickLabel.AddClass('sb-team--TERRORIST');
            elRndTick.RemoveClass('sb-team--CT');
            elRndTickLabel.RemoveClass('sb-team--CT');
        }
        let _UpdateCasualties = (teamName, elRnd, nPlayers) => {
            if (_m_oTeams[teamName]) {
                let livingCount = teamName === 'CT' ? roundData.players_alive_CT : roundData.players_alive_TERRORIST;
                for (let i = 1; i <= nPlayers; i++) {
                    let img = elRnd.m_elCasualties[i];
                    if (!img)
                        break;
                    img.RemoveClass('hidden');
                    if (i > livingCount) {
                        img.AddClass('dead-casualty');
                    }
                    else {
                        img.RemoveClass('dead-casualty');
                    }
                }
            }
        };
        let nPlayers = 5;
        if (MockAdapter.GetGameModeInternalName(false) == 'scrimcomp2v2') {
            nPlayers = 2;
        }
        _UpdateCasualties('CT', elRndTop, nPlayers);
        _UpdateCasualties('TERRORIST', elRndBot, nPlayers);
    }
    function _ShowSurvivors(hide = false) {
        let elTimeline = _m_panelCache.m_elTimelineSegments;
        if (!elTimeline || !elTimeline.IsValid())
            return;
        let arrPanelsToToggleTransparency = elTimeline.FindChildrenWithAttributeTraverse('data-casualty-mouse-over-toggle-transparency');
        arrPanelsToToggleTransparency.forEach(el => el.SetHasClass('transparent', hide));
    }
    function _Casualties_OnMouseOver() {
        if (GameInterfaceAPI.GetSettingString('cl_scoreboard_survivors_always_on') == '0') {
            _ShowSurvivors();
        }
    }
    function _Casualties_OnMouseOut() {
        if (GameInterfaceAPI.GetSettingString('cl_scoreboard_survivors_always_on') == '0') {
            _ShowSurvivors(true);
        }
        UiToolkitAPI.HideCustomLayoutTooltip('id-tooltip-sb-casualties');
    }
    function _RoundLossBonusMoneyForTeam(teamname) {
        let nLossAmount = MockAdapter.GetTeamNextRoundLossBonus(teamname);
        let nMaxLoss = parseInt(GameInterfaceAPI.GetSettingString('mp_consecutive_loss_max'));
        if (nLossAmount > nMaxLoss) {
            nLossAmount = nMaxLoss;
        }
        if (nLossAmount < 0) {
            nLossAmount = 0;
        }
        let nBaseAmount = parseInt(GameInterfaceAPI.GetSettingString('cash_team_loser_bonus'));
        let nConsecutiveBonus = parseInt(GameInterfaceAPI.GetSettingString('cash_team_loser_bonus_consecutive_rounds'));
        let nTotalAmount = nBaseAmount + (nLossAmount * nConsecutiveBonus);
        return nTotalAmount;
    }
    function _RoundLossBonusMoney_OnMouseOver_CT() {
        _m_cP.SetDialogVariable('round_loss_income_team', $.Localize('#counter-terrorists'));
        _m_cP.SetDialogVariableInt('round_loss_income_amount', _RoundLossBonusMoneyForTeam('CT'));
        let sTooltipText = $.Localize('#Scoreboard_lossmoneybonus_tooltip', _m_cP);
        UiToolkitAPI.ShowTextTooltip('id-sb-timeline__round-loss-bonus-money', sTooltipText);
    }
    function _RoundLossBonusMoney_OnMouseOut_CT() {
        UiToolkitAPI.HideTextTooltip();
    }
    function _RoundLossBonusMoney_OnMouseOver_TERRORIST() {
        _m_cP.SetDialogVariable('round_loss_income_team', $.Localize('#terrorists'));
        _m_cP.SetDialogVariableInt('round_loss_income_amount', _RoundLossBonusMoneyForTeam('TERRORIST'));
        let sTooltipText = $.Localize('#Scoreboard_lossmoneybonus_tooltip', _m_cP);
        UiToolkitAPI.ShowTextTooltip('id-sb-timeline__round-loss-bonus-money', sTooltipText);
    }
    function _RoundLossBonusMoney_OnMouseOut_TERRORIST() {
        UiToolkitAPI.HideTextTooltip();
    }
    const defaultScoreTeamData = {
        team_name: '',
        team_number: 0,
        team_logo_image_path: '',
        clan_id: 0,
        clan_name: '',
        flag: '',
        logo: '',
        map_victories: 0,
        player_count: 0,
        alive_count: -1,
        score: 0,
        score_1h: undefined,
        score_2h: undefined,
        score_ot: undefined,
        surrendered: undefined,
        next_round_loss_bonus: 0,
    };
    function _UpdateTeamInfo(teamName, teamInfo) {
        let team = Team_t.GetOrCreateTeam(_m_cP, teamName);
        let clanName = teamInfo.clan_name;
        let teamLogoImagePath = teamInfo.team_logo_image_path;
        let total = teamInfo.player_count;
        let living = teamInfo.alive_count;
        let updateLogo = (teamLogoImagePath != team.m_teamLogoImagePath) && (teamLogoImagePath != '');
        team.m_teamLogoImagePath = teamLogoImagePath;
        _m_cP.SetDialogVariable('sb_team_name--' + teamName, clanName);
        _m_cP.SetDialogVariableInt(teamName + '_alive', living);
        _m_cP.SetDialogVariableInt(teamName + '_total', total);
        if (updateLogo) {
            const elLogoChildren = team.m_elLogoChildren;
            for (const elTeamLogoBackground of elLogoChildren) {
                elTeamLogoBackground.style.backgroundImage = `url("file://{images}${teamLogoImagePath}")`;
                elTeamLogoBackground.AddClass('sb-team-logo-bg');
            }
        }
    }
    function _UpdateTeams(oScoreData) {
        function TeamInfoForName(name, teamdata) {
            let info = defaultScoreTeamData;
            for (let td of teamdata) {
                if (td.team_name == name) {
                    info = td;
                    break;
                }
            }
            return info;
        }
        const teamdata = (oScoreData ? oScoreData.teamdata : []);
        for (const teamName in _m_oTeams) {
            const teamData = TeamInfoForName(teamName, teamdata);
            _UpdateTeamInfo(teamName, teamData);
            if (teamData) {
                _m_cP.SetDialogVariableInt('sb_team_score--' + teamName, teamData.score);
                if (teamData.score_1h !== undefined) {
                    _m_cP.SetDialogVariableInt('sb_team_score_2--' + teamName, teamData.score_1h);
                }
                if (teamData.score_2h !== undefined) {
                    _m_cP.SetDialogVariableInt('sb_team_score_3--' + teamName, teamData.score_2h);
                }
                let hideOt = true;
                if (teamData.score_ot !== undefined) {
                    hideOt = false;
                    _m_cP.SetDialogVariableInt('sb_team_score_ot--' + teamName, teamData.score_ot);
                }
                let elOTScore = _m_panelCache.m_elTimelineScoreOt;
                if (elOTScore) {
                    elOTScore.SetHasClass('hidden', hideOt);
                    elOTScore.SetHasClass('fade', hideOt);
                }
            }
        }
    }
    function _InitClassicTeams() {
        _UpdateTeamInfo('TERRORIST', defaultScoreTeamData);
        _UpdateTeamInfo('CT', defaultScoreTeamData);
    }
    let m_topScore = 0;
    let m_botScore = 0;
    function _UpdateAllRounds(oScoreData, jsoTime) {
        if (!jsoTime)
            return;
        if (!oScoreData)
            return;
        if (!_SupportsTimeline(jsoTime))
            return;
        let firstRound = jsoTime.first_round_this_period;
        let lastRound = jsoTime.last_round_this_period;
        m_topScore = 0;
        m_botScore = 0;
        if (jsoTime.overtime > 0) {
            m_topScore = (jsoTime.maxrounds + (jsoTime.overtime - 1) * jsoTime.maxrounds_overtime) / 2;
            m_botScore = (jsoTime.maxrounds + (jsoTime.overtime - 1) * jsoTime.maxrounds_overtime) / 2;
        }
        for (let rnd = firstRound; rnd <= lastRound; rnd++) {
            _UpdateRound(rnd, oScoreData, jsoTime);
        }
    }
    function _UpdateScore_Classic() {
        if (Object.keys(_m_oTeams).length === 0) {
            _InitClassicTeams();
        }
        let oScoreData = MockAdapter.GetScoreDataJSO();
        let jsoTime = MockAdapter.GetTimeDataJSO();
        _UpdateTeams(oScoreData);
        if (!jsoTime)
            return;
        let currentRound = jsoTime.rounds_played + 1;
        _m_cP.SetDialogVariable('match_phase', $.Localize('#gamephase_' + jsoTime.gamephase));
        _m_cP.SetDialogVariableInt('rounds_remaining', jsoTime.rounds_remaining);
        _m_cP.SetDialogVariableInt('scoreboard_ot', jsoTime.overtime);
        _m_cP.SetHasClass('sb-tournament-match', MatchStatsAPI.IsTournamentMatch());
        let bResetTimeline = false;
        if (_m_maxRounds != jsoTime.maxrounds_this_period) {
            bResetTimeline = true;
            _m_maxRounds = jsoTime.maxrounds_this_period;
        }
        if (_m_areTeamsSwapped !== MockAdapter.AreTeamsPlayingSwitchedSides()) {
            bResetTimeline = true;
            _m_areTeamsSwapped = MockAdapter.AreTeamsPlayingSwitchedSides();
        }
        if (!_SupportsTimeline(jsoTime)) {
            bResetTimeline = true;
        }
        if (_m_overtime != jsoTime.overtime) {
            _m_overtime = jsoTime.overtime;
            bResetTimeline = true;
        }
        if (bResetTimeline || !(currentRound in _m_RoundUpdated)) {
            if (bResetTimeline) {
                let shouldUpdateRounds = false;
                _ResetTimeline(oScoreData, jsoTime, shouldUpdateRounds);
            }
            _UpdateAllRounds(oScoreData, jsoTime);
            _m_RoundUpdated[currentRound] = true;
        }
        else {
            if (oScoreData) {
                _UpdateRound(currentRound - 1, oScoreData, jsoTime);
            }
        }
        _UpdateRoundLossBonus(oScoreData.teamdata);
    }
    function _InsertTimelineDivider() {
        let elTimeline = _m_panelCache.m_elTimelineSegments;
        if (!elTimeline || !elTimeline.IsValid())
            return;
        let elDivider = $.CreatePanel('Panel', elTimeline, 'id-sb-timeline__divider');
        elDivider.AddClass('sb-timeline__divider');
    }
    function _InitTimelineSegment(startRound, endRound, phase) {
        let elTimeline = _m_panelCache.m_elTimelineSegments;
        if (!elTimeline || !elTimeline.IsValid())
            return;
        elTimeline.AddClass('sb-team-tint');
        let id = 'id-sb-timeline__segment--' + phase;
        let elSegment = elTimeline.FindChildTraverse(id);
        if (!elSegment || !elSegment.IsValid()) {
            elSegment = $.CreatePanel('Panel', elTimeline, id);
            elSegment.BLoadLayoutSnippet('snippet_scoreboard-classic__timeline__segment');
        }
        let elRoundContainer = elSegment.FindChildTraverse('id-sb-timeline__round-container');
        if (elRoundContainer && elRoundContainer.IsValid()) {
            for (let rnd = startRound; rnd <= endRound; rnd++) {
                const rndStr = rnd.toString();
                let elRnd = elSegment.FindChildTraverse(rndStr);
                if (!elRnd || !elRnd.IsValid()) {
                    elRnd = $.CreatePanel('Panel', elRoundContainer, rndStr);
                    elRnd.BLoadLayoutSnippet('snippet_scoreboard-classic__timeline__segment__round');
                    let elTop = elRnd.FindChildTraverse('id-sb-timeline__segment__round--top');
                    elTop.BLoadLayoutSnippet('snippet_scoreboard-classic__timeline__segment__round__data');
                    let elBot = elRnd.FindChildTraverse('id-sb-timeline__segment__round--bot');
                    elBot.BLoadLayoutSnippet('snippet_scoreboard-classic__timeline__segment__round__data');
                    let elRndTickLabel = elRnd.FindChildTraverse('id-sb-timeline__segment__round__tick__label');
                    if (rnd % 5 == 0) {
                        elRndTickLabel.text = rndStr;
                    }
                    elTop.SetDialogVariable('sb_clinch', '');
                    elBot.SetDialogVariable('sb_clinch', '');
                    let elRndCache = elRnd;
                    elRndCache.m_elRndTop = elTop;
                    elRndCache.m_elRndBot = elBot;
                    elRndCache.m_elRndTop.m_elResult = elRndCache.m_elRndTop.FindChildTraverse('result');
                    elRndCache.m_elRndBot.m_elResult = elRndCache.m_elRndBot.FindChildTraverse('result');
                    _InitCasualties(elRndCache.m_elRndTop);
                    _InitCasualties(elRndCache.m_elRndBot);
                    function _InitCasualties(elRndSeg) {
                        elRndSeg.m_elCasualties = [];
                        elRndSeg.m_elCasualties.push(null);
                        for (let i = 1; i <= 5; i++) {
                            elRndSeg.m_elCasualties.push(elRndSeg.FindChildTraverse('casualty-' + i));
                        }
                    }
                    elRndCache.m_elRndTick = elRnd.FindChildTraverse('id-sb-timeline__segment__round__tick');
                    elRndCache.m_elRndTickLabel = elRndTickLabel;
                    _m_panelCache.m_elRounds[rnd] = elRndCache;
                }
            }
        }
        if (MockAdapter.AreTeamsPlayingSwitchedSides() !== MockAdapter.AreTeamsPlayingSwitchedSidesInRound(endRound)) {
            let elCTScore = elSegment.FindChildTraverse('id-sb-timeline__segment__score__ct');
            let elTScore = elSegment.FindChildTraverse('id-sb-timeline__segment__score__t');
            if (elCTScore && elCTScore.IsValid()) {
                elCTScore.RemoveClass('sb-color--CT');
                elCTScore.AddClass('sb-color--TERRORIST');
            }
            if (elTScore && elTScore.IsValid()) {
                elTScore.RemoveClass('sb-color--TERRORIST');
                elTScore.AddClass('sb-color--CT');
            }
        }
    }
    function _SupportsTimeline(jsoTime) {
        if (jsoTime == undefined)
            jsoTime = MockAdapter.GetTimeDataJSO();
        let roundCountToEvaluate = jsoTime.maxrounds_this_period;
        return (roundCountToEvaluate <= 30);
    }
    function _UpdateRoundLossBonus(teamdata) {
        let elRoundLossBonusMoney = _m_panelCache.m_elRoundLossBonus;
        if (elRoundLossBonusMoney && elRoundLossBonusMoney.IsValid()) {
            let hideRoundLossPanel = true;
            if (parseInt(GameInterfaceAPI.GetSettingString('mp_consecutive_loss_max')) > 0 &&
                parseInt(GameInterfaceAPI.GetSettingString('cash_team_loser_bonus_consecutive_rounds')) > 0) {
                let nLossT = -1;
                let nLossCT = -1;
                if (teamdata) {
                    for (const td of teamdata) {
                        if (td.team_name == 'TERRORIST') {
                            nLossT = td.next_round_loss_bonus;
                        }
                        else if (td.team_name == 'CT') {
                            nLossCT = td.next_round_loss_bonus;
                        }
                    }
                }
                else {
                    nLossT = MockAdapter.GetTeamNextRoundLossBonus('TERRORIST');
                    nLossCT = MockAdapter.GetTeamNextRoundLossBonus('CT');
                }
                if (nLossT >= 0 && nLossCT >= 0) {
                    hideRoundLossPanel = false;
                    for (let nClassIdx = 1; nClassIdx <= 4; ++nClassIdx) {
                        elRoundLossBonusMoney.SetHasClass('sb-timeline__round-loss-bonus-money__TERRORIST' + nClassIdx, nLossT >= nClassIdx);
                    }
                    for (let nClassIdx = 1; nClassIdx <= 4; ++nClassIdx) {
                        elRoundLossBonusMoney.SetHasClass('sb-timeline__round-loss-bonus-money__CT' + nClassIdx, nLossCT >= nClassIdx);
                    }
                }
            }
            if (hideRoundLossPanel) {
                elRoundLossBonusMoney.AddClass('hidden');
            }
            else {
                elRoundLossBonusMoney.RemoveClass('hidden');
            }
        }
    }
    function _ResetTimeline(oScoreData, jsoTime, updateRounds = true) {
        _UpdateRoundLossBonus();
        let elTimeline = _m_panelCache.m_elTimelineSegments;
        if (!elTimeline || !elTimeline.IsValid())
            return;
        elTimeline.RemoveAndDeleteChildren();
        if (!jsoTime)
            return;
        if (!_SupportsTimeline(jsoTime))
            return;
        let firstRound;
        let lastRound;
        let midRound;
        firstRound = jsoTime.first_round_this_period;
        lastRound = jsoTime.last_round_this_period;
        let elLabel = _m_panelCache.m_elTimelineRoundLabel;
        if (elLabel && elLabel.IsValid()) {
            elLabel.SetHasClass('hidden', jsoTime.overtime == 0);
        }
        midRound = firstRound + Math.ceil((lastRound - firstRound) / 2) - 1;
        _m_panelCache.m_elRounds = new Array(lastRound + 1).fill(null);
        if (MockAdapter.HasHalfTime()) {
            _InitTimelineSegment(firstRound, midRound, 'first-half');
            _InsertTimelineDivider();
            _InitTimelineSegment(midRound + 1, lastRound, 'second-half');
        }
        else {
            _InitTimelineSegment(firstRound, lastRound, 'no-halves');
        }
        if (updateRounds) {
            _UpdateAllRounds(oScoreData, jsoTime);
        }
        if (GameInterfaceAPI.GetSettingString('cl_scoreboard_survivors_always_on') == '1')
            _ShowSurvivors();
    }
    function _UnborrowMusicKit() {
        GameInterfaceAPI.SetSettingString('cl_borrow_music_from_player_slot', '-1');
        let oLocalPlayer = _m_oPlayers.GetPlayerByXuid(GetLocalPlayerId());
        _UpdatePlayerStat(oLocalPlayer, 'musickit', false, true);
    }
    function UpdateCasterButtons() {
        for (let i = 0; i < 4; i++) {
            let buttonName = '#spec-button' + (i + 1);
            let bActive = true;
            switch (i) {
                default:
                case 0:
                    bActive = !!GetCasterIsCameraman();
                    break;
                case 1:
                    bActive = !!GetCasterIsHeard();
                    break;
                case 2:
                    bActive = !!GetCasterControlsXray();
                    break;
                case 3:
                    bActive = !!GetCasterControlsUI();
                    break;
            }
            ToggleCasterButtonActive(buttonName, bActive);
        }
    }
    function ToggleCasterButtonActive(buttonName, bActive) {
        let button = $(buttonName);
        if (button == null)
            return;
        if (bActive == false && button.BHasClass('sb-spectator-control-button-notactive') == false) {
            button.AddClass('sb-spectator-control-button-notactive');
        }
        else if (bActive == true && button.BHasClass('sb-spectator-control-button-notactive') == true) {
            button.RemoveClass('sb-spectator-control-button-notactive');
        }
    }
    function _ToggleSetCasterIsCameraman() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'generic_button_press', 'MOUSE');
        let nCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_autodirector_cameraman'));
        if (GetCasterIsCameraman()) {
            GameStateAPI.SetCasterIsCameraman(0);
        }
        else {
            GameStateAPI.SetCasterIsCameraman(nCameraMan);
        }
        UpdateCasterButtons();
    }
    function _ToggleSetCasterIsHeard() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'generic_button_press', 'MOUSE');
        let nCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_autodirector_cameraman'));
        if (GetCasterIsHeard()) {
            GameStateAPI.SetCasterIsHeard(0);
        }
        else {
            GameStateAPI.SetCasterIsHeard(nCameraMan);
        }
        UpdateCasterButtons();
    }
    function _ToggleSetCasterControlsXray() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'generic_button_press', 'MOUSE');
        let nCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_autodirector_cameraman'));
        if (GetCasterControlsXray()) {
            GameStateAPI.SetCasterControlsXray(0);
            ToggleCasterButtonActive('#spec-button3', false);
        }
        else {
            GameStateAPI.SetCasterControlsXray(nCameraMan);
            ToggleCasterButtonActive('#spec-button3', true);
        }
    }
    function _ToggleSetCasterControlsUI() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'generic_button_press', 'MOUSE');
        let nCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_autodirector_cameraman'));
        if (GetCasterControlsUI()) {
            GameStateAPI.SetCasterControlsUI(0);
        }
        else {
            GameStateAPI.SetCasterControlsUI(nCameraMan);
        }
        UpdateCasterButtons();
    }
    function _CycleStats() {
        if (_m_dataSetGetCount === 0)
            return;
        {
            _m_dataSetCurrent++;
            if (_m_dataSetCurrent >= _m_dataSetGetCount)
                _m_dataSetCurrent = 0;
        }
        let elLabelSets = $('#id-sb-row__sets');
        let labelSetsChildren = elLabelSets.Children();
        for (let i = 0; i < labelSetsChildren.length; i++) {
            let elChild = labelSetsChildren[i];
            if (elChild.id == 'id-sb-labels-set-' + _m_dataSetCurrent) {
                elChild.RemoveClass('hidden');
            }
            else {
                elChild.AddClass('hidden');
            }
        }
        for (let i = 0; i < _m_oPlayers.GetCount(); i++) {
            let elPlayer = _m_oPlayers.GetPlayerByIndex(i).m_elPlayer;
            if (elPlayer && elPlayer.IsValid()) {
                let elSetContainer = elPlayer.FindChildTraverse('id-sb-row__set-container');
                if (elSetContainer && elSetContainer.IsValid()) {
                    let containerChildren = elSetContainer.Children();
                    for (let j = 0; j < containerChildren.length; j++) {
                        let elChild = containerChildren[j];
                        if (elChild.id == 'id-sb-set-' + _m_dataSetCurrent) {
                            elChild.RemoveClass('hidden');
                        }
                        else {
                            elChild.AddClass('hidden');
                        }
                    }
                }
            }
        }
    }
    function _MuteVoice() {
        GameInterfaceAPI.ConsoleCommand('voice_modenable_toggle');
        $.Schedule(0.1, _UpdateMuteVoiceState);
    }
    function _UpdateMuteVoiceState() {
        let muteState = GameInterfaceAPI.GetSettingString('voice_modenable') === '1';
        let elMuteImage = _m_panelCache.m_elMuteImage;
        if (!elMuteImage)
            return;
        if (muteState) {
            elMuteImage.SetImage('file://{images}/icons/ui/unmuted.svg');
        }
        else {
            elMuteImage.SetImage('file://{images}/icons/ui/muted.svg');
        }
    }
    function _BlockUgc() {
        let ugcBlockState = GameInterfaceAPI.GetSettingString('cl_hide_avatar_images') !== '0' ||
            GameInterfaceAPI.GetSettingString('cl_sanitize_player_names') !== '0';
        if (ugcBlockState) {
            GameInterfaceAPI.SetSettingString('cl_sanitize_player_names', '0');
            GameInterfaceAPI.SetSettingString('cl_hide_avatar_images', '0');
        }
        else {
            GameInterfaceAPI.SetSettingString('cl_sanitize_player_names', '1');
            GameInterfaceAPI.SetSettingString('cl_hide_avatar_images', '2');
        }
        $.Schedule(0.1, _UpdateUgcState);
    }
    function _UpdateUgcState() {
        let ugcBlockState = GameInterfaceAPI.GetSettingString('cl_hide_avatar_images') !== '0' ||
            GameInterfaceAPI.GetSettingString('cl_sanitize_player_names') !== '0';
        let elBlockUgcImage = _m_panelCache.m_elBlockUgcImage;
        if (!elBlockUgcImage)
            return;
        if (ugcBlockState) {
            elBlockUgcImage.SetImage('file://{images}/icons/ui/votekick.svg');
        }
        else {
            elBlockUgcImage.SetImage('file://{images}/icons/ui/player.svg');
        }
    }
    function _CreateLabelsForRow(panel) {
        if (!panel || !panel.IsValid()) {
            return;
        }
        if (_m_bRowLabelsCreated) {
            return;
        }
        let dataStatChildren = panel.FindChildrenWithAttributeTraverse('data-stat');
        for (let i = 0; i < dataStatChildren.length; i++) {
            let el = dataStatChildren[i];
            if (el && el.IsValid()) {
                let stat = el.GetAttributeString('data-stat', '');
                let set = el.GetAttributeString('data-set', '');
                let isHidden = el.GetAttributeString('data-hidden', '');
                const noLabel = el.GetAttributeString('no-label', 'false');
                if (stat != '' && !(noLabel === 'true')) {
                    _CreateLabelForStat(stat, set, isHidden);
                }
            }
        }
        _m_bRowLabelsCreated = true;
    }
    function _GetSortOrderForMode(mode) {
        if (GameStateAPI.IsQueuedMatchmakingMode_Team())
            return sortOrder_tmm;
        switch (mode) {
            case 'deathmatch':
                if (GameInterfaceAPI.GetSettingString('mp_dm_teammode') !== '0') {
                    return sortOrder_default;
                }
                return sortOrder_dm;
            case 'competitive':
            case 'premier':
            case 'rush':
                return sortOrder_tmm;
            case 'gungameprogressive':
                return sortOrder_gg;
            default:
                return sortOrder_default;
        }
    }
    function _Initialize() {
        _Reset();
        let jsoTime = MockAdapter.GetTimeDataJSO();
        if (!jsoTime) {
            return;
        }
        _LoadScoreboardTemplate();
        _m_bRowLabelsCreated = false;
        let temp = $.CreatePanel('Panel', _m_cP, 'temp');
        _Helper_LoadSnippet(temp, _GetPlayerRowForGameMode());
        temp.visible = false;
        _CreateLabelsForRow(temp);
        temp.DeleteAsync(.0);
        let oScoreData = MockAdapter.GetScoreDataJSO();
        _ResetTimeline(oScoreData, jsoTime);
        _m_bInit = true;
        _m_cP.SetDialogVariable('server_name', '');
        _UpdateHLTVViewerNumber(0);
        _UpdateMatchInfo();
    }
    function _RankRevealAll() {
        for (let i = 0; i < _m_oPlayers.GetCount(); i++) {
            let oPlayer = _m_oPlayers.GetPlayerByIndex(i);
            _UpdatePlayerStat(oPlayer, 'skillgroup', false, true);
        }
    }
    function _UpdateScore() {
        switch (MockAdapter.GetGameModeInternalName(false)) {
            case 'competitive':
            case 'premier':
                _UpdateScore_Classic();
                break;
            case 'deathmatch':
                if (GameInterfaceAPI.GetSettingString('mp_dm_teammode') !== '0') {
                    _UpdateScore_Classic();
                }
                break;
            default:
            case 'casual':
                _UpdateScore_Classic();
                break;
        }
    }
    function _UpdateJob() {
        if (_m_bInit) {
            _UpdateMatchInfo();
            _UpdateScore();
            _UpdateNextPlayer();
        }
    }
    function _UpdateEverything(bInitialCreate = false) {
        if (!_m_bInit) {
            _Initialize();
        }
        _UpdateMuteVoiceState();
        _UpdateUgcState();
        if (bInitialCreate) {
            _UpdateAllPlayers(bInitialCreate);
        }
        else {
            _UpdateAllPlayers_delayed();
        }
        _UpdateMatchInfo();
        _UpdateScore();
        _UpdateSpectatorButtons();
    }
    function _CloseScoreboard() {
        if (_m_updatePlayerHandler) {
            $.UnregisterForUnhandledEvent('Scoreboard_UpdatePlayerByPlayerSlot', _m_updatePlayerHandler);
            _m_updatePlayerHandler = null;
        }
        $.DispatchEvent('DismissAllContextMenus');
        UiToolkitAPI.HideTextTooltip();
        _UnregisterEvents();
    }
    function _OpenScoreboard() {
        _UpdateEverything();
        _ShowSurvivors((GameInterfaceAPI.GetSettingString('cl_scoreboard_survivors_always_on') == '0'));
        if (!_m_updatePlayerHandler) {
            _m_updatePlayerHandler = $.RegisterForUnhandledEvent('Scoreboard_UpdatePlayerByPlayerSlot', _UpdatePlayerByPlayerSlot_delayed);
        }
        _RegisterEvents();
    }
    function GetFreeForAllTopThreePlayers() {
        _UpdateEverything();
        if (!_m_cP)
            return [undefined, undefined, undefined];
        let elTeam = _m_cP.FindChildInLayoutFile('players-table-ANY');
        if (elTeam && elTeam.IsValid()) {
            const players = elTeam.Children();
            return [players[0]?.m_xuid || '0', players[1]?.m_xuid || '0', players[2]?.m_xuid || '0'];
        }
        return [undefined, undefined, undefined];
    }
    Scoreboard.GetFreeForAllTopThreePlayers = GetFreeForAllTopThreePlayers;
    function GetCasterIsCameraman() {
        let nCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_autodirector_cameraman'));
        let bQ = (MockAdapter.IsDemoOrHltv() && nCameraMan != 0 && MockAdapter.IsHLTVAutodirectorOn());
        return bQ;
    }
    function GetCasterIsHeard() {
        if (MockAdapter.IsDemoOrHltv()) {
            return !!parseInt(GameInterfaceAPI.GetSettingString('voice_caster_enable'));
        }
        return false;
    }
    function GetCasterControlsXray() {
        let bXRay = MockAdapter.IsDemoOrHltv() && parseInt(GameInterfaceAPI.GetSettingString('spec_cameraman_xray'));
        return bXRay;
    }
    function GetCasterControlsUI() {
        let bSpecCameraMan = parseInt(GameInterfaceAPI.GetSettingString('spec_cameraman_ui'));
        let bQ = (MockAdapter.IsDemoOrHltv() && bSpecCameraMan);
        return bQ;
    }
    function _ApplyPlayerCrosshairCode(panel, xuid) {
        UiToolkitAPI.ShowGenericPopupYesNo($.Localize('#tooltip_copycrosshair'), $.Localize('#GameUI_Xhair_Copy_Code_Confirm'), '', () => { let code = GameStateAPI.GetCrosshairCode(xuid); MyPersonaAPI.BApplyCrosshairCode(code); }, () => { });
    }
    const events = [
        ['Scoreboard_UnborrowMusicKit', _UnborrowMusicKit],
        ['Scoreboard_Casualties_OnMouseOver', _Casualties_OnMouseOver],
        ['Scoreboard_Casualties_OnMouseOut', _Casualties_OnMouseOut],
        ['Scoreboard_RoundLossBonusMoney_OnMouseOver_CT', _RoundLossBonusMoney_OnMouseOver_CT],
        ['Scoreboard_RoundLossBonusMoney_OnMouseOut_CT', _RoundLossBonusMoney_OnMouseOut_CT],
        ['Scoreboard_RoundLossBonusMoney_OnMouseOver_TERRORIST', _RoundLossBonusMoney_OnMouseOver_TERRORIST],
        ['Scoreboard_RoundLossBonusMoney_OnMouseOut_TERRORIST', _RoundLossBonusMoney_OnMouseOut_TERRORIST],
        ['Scoreboard_MuteVoice', _MuteVoice],
        ['Scoreboard_BlockUgc', _BlockUgc],
        ['Scoreboard_ApplyPlayerCrosshairCode', _ApplyPlayerCrosshairCode]
    ];
    let eventHandles = [];
    function _RegisterEvents() {
        const msg = $.GetContextPanel().id + ' registering ';
        events.forEach(function (arrEvent, idx) {
            eventHandles[idx] = $.RegisterForUnhandledEvent(arrEvent[0], arrEvent[1]);
        });
    }
    function _UnregisterEvents() {
        const msg = $.GetContextPanel().id + ' unregistering ';
        events.forEach(function (arrEvent, idx) {
            $.UnregisterForUnhandledEvent(arrEvent[0], eventHandles[idx]);
        });
    }
    function _LoadScoreboardTemplate() {
        let scoreboardTemplate;
        let mode = MockAdapter.GetGameModeInternalName(false);
        let skirmish = MockAdapter.GetGameModeInternalName(true);
        if (mode == 'deathmatch') {
            if (GameInterfaceAPI.GetSettingString('mp_teammates_are_enemies') !== '0') {
                skirmish = 'ffadm';
            }
            else if (GameInterfaceAPI.GetSettingString('mp_dm_teammode') !== '0') {
                skirmish = 'teamdm';
            }
        }
        switch (mode.toLowerCase()) {
            case 'premier':
            case 'competitive':
            case 'scrimcomp2v2':
                scoreboardTemplate = 'snippet_scoreboard-classic--with-timeline--half-times';
                break;
            case 'deathmatch':
                if (skirmish == 'teamdm') {
                    scoreboardTemplate = 'snippet_scoreboard-classic--no-timeline';
                }
                else {
                    scoreboardTemplate = 'snippet_scoreboard--no-teams';
                }
                break;
            case 'gungameprogressive':
            case 'training':
                scoreboardTemplate = 'snippet_scoreboard--no-teams';
                break;
            case 'cooperative':
                scoreboardTemplate = 'snippet_scoreboard--cooperative';
                break;
            case 'coopmission':
                scoreboardTemplate = 'snippet_scoreboard--coopmission';
                break;
            case 'casual':
                scoreboardTemplate = 'snippet_scoreboard-classic--no-timeline';
                break;
            case 'rush':
                scoreboardTemplate = 'snippet_scoreboard-classic--with-timeline--no-half-times';
                break;
            default:
                scoreboardTemplate = 'snippet_scoreboard-classic--no-timeline';
                break;
        }
        _m_panelCache.ClearAll();
        _Helper_LoadSnippet(_m_cP, scoreboardTemplate);
        _m_panelCache.CacheScoreboard(_m_cP);
        if (MockAdapter.IsDemoOrHltv())
            _m_cP.AddClass('IsDemoOrHltv');
        if (MatchStatsAPI.IsTournamentMatch())
            _m_cP.AddClass('IsTournamentMatch');
        _m_sortOrder = _GetSortOrderForMode(mode);
    }
    function _CreateAndInitializeFunc() {
        _Reset();
        let jsoTime = MockAdapter.GetTimeDataJSO();
        if (!jsoTime) {
            return;
        }
        let loadedScoreboardTemplate = _LoadScoreboardTemplate();
        _m_bRowLabelsCreated = false;
        _m_bInit = true;
        const bInitialCreate = true;
        _UpdateEverything(bInitialCreate);
        if (!_m_bRowLabelsCreated) {
            let temp = $.CreatePanel('Panel', _m_cP, 'temp');
            _Helper_LoadSnippet(temp, _GetPlayerRowForGameMode());
            temp.visible = false;
            _CreateLabelsForRow(temp);
            temp.DeleteAsync(.0);
        }
        _m_cP.SetDialogVariable('server_name', '');
        _UpdateHLTVViewerNumber(0);
        $.DispatchEvent('DismissAllContextMenus');
        UiToolkitAPI.HideTextTooltip();
    }
    function _CreateAndInitialize(bImmediately = false) {
        if (bImmediately) {
            _CreateAndInitializeFunc();
        }
        else {
            $.Schedule(0.01, _CreateAndInitializeFunc);
        }
    }
    {
        _m_oAllUpdateStatNames = [];
        _InitializeStatUpdateFuncs();
        $.RegisterEventHandler('OnOpenScoreboard', $.GetContextPanel(), _OpenScoreboard);
        $.RegisterEventHandler('OnCloseScoreboard', $.GetContextPanel(), _CloseScoreboard);
        $.RegisterEventHandler('Scoreboard_UpdateJob', $.GetContextPanel(), _UpdateJob);
        $.RegisterEventHandler('Scoreboard_ResetAndInit', $.GetContextPanel(), _Initialize);
        $.RegisterEventHandler('Scoreboard_CreateAndInit', $.GetContextPanel(), _CreateAndInitialize);
        $.RegisterForUnhandledEvent('GameState_OnLevelLoad', _Initialize);
        $.RegisterForUnhandledEvent('Scoreboard_CycleStats', _CycleStats);
        $.RegisterForUnhandledEvent('Scoreboard_ToggleSetCasterIsCameraman', _ToggleSetCasterIsCameraman);
        $.RegisterForUnhandledEvent('Scoreboard_ToggleSetCasterIsHeard', _ToggleSetCasterIsHeard);
        $.RegisterForUnhandledEvent('Scoreboard_ToggleSetCasterControlsXray', _ToggleSetCasterControlsXray);
        $.RegisterForUnhandledEvent('Scoreboard_ToggleSetCasterControlsUI', _ToggleSetCasterControlsUI);
        $.RegisterForUnhandledEvent('GameState_RankRevealAll', _RankRevealAll);
        $.RegisterForUnhandledEvent('Scoreboard_UpdateHLTVViewers', _UpdateHLTVViewerNumber);
    }
})(Scoreboard || (Scoreboard = {}));
