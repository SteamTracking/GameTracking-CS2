"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/teamcolor.ts" />
/// <reference path="../rating_emblem.ts" />
var PopupSeasonStats;
(function (PopupSeasonStats) {
    const _m_cp = $.GetContextPanel();
    const _m_spiderGraph = $('#id-wins-spider-graph');
    let _m_seasonId;
    let _m_timeoutHandle;
    let _m_elSelectedMap;
    let _m_selectedGridStat;
    function Init() {
        let seasonid = $.GetContextPanel().GetAttributeString('seasonid', '') ? parseInt($.GetContextPanel().GetAttributeString('seasonid', '')) : -1;
        if (seasonid < 1) {
            ClosePopup();
            return;
        }
        _ReadyForDisplay();
    }
    PopupSeasonStats.Init = Init;
    function _ReadyForDisplay() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        let seasonid = $.GetContextPanel().GetAttributeString('seasonid', '') ? parseInt($.GetContextPanel().GetAttributeString('seasonid', '')) : -1;
        if (seasonid < 1) {
            return;
        }
        _m_seasonId = seasonid;
        _m_cp.SetHasClass('season-' + _m_seasonId, true);
        _UpdateSeasonData(seasonid);
    }
    function _UpdateSeasonData(seasonid) {
        if (seasonid !== _m_seasonId) {
            ClosePopup();
            return;
        }
        let seasonData = TournamentsAPI.GetPremierSeasonSummaryJSO(seasonid);
        if (!seasonData) {
            _CancelWaitForCallBack();
            _m_timeoutHandle = $.Schedule(5, () => {
                _TimeoutPopup();
            });
        }
        else {
            _CancelWaitForCallBack();
            _SetModelPanel();
            _SetGlobalStats(seasonData);
            _SetUpPerMapStats(seasonData);
            _SetUpStatsPanelTypeButtons();
            _SetUpSpiderGraph(seasonData);
            _SetRank(seasonData);
            $.Schedule(.25, () => { _m_cp.SetHasClass('stats-loaded', true); });
        }
    }
    function _UnreadyForDisplay() {
    }
    function ClosePopup() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        _m_cp.SetReadyForDisplay(false);
        UiToolkitAPI.HideCustomLayoutTooltip('tooltip-season-rank');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('ContextMenuEvent', '');
        UiToolkitAPI.HideTextTooltip();
    }
    PopupSeasonStats.ClosePopup = ClosePopup;
    function _CancelWaitForCallBack() {
        if (_m_timeoutHandle) {
            $.CancelScheduled(_m_timeoutHandle);
            _m_timeoutHandle = null;
        }
    }
    ;
    function _TimeoutPopup() {
        _CancelWaitForCallBack();
        ClosePopup();
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', function () {
        });
    }
    ;
    function _SetModelPanel() {
        let itemId = $.GetContextPanel().GetAttributeString('itemid', '');
        if (!itemId || !InventoryAPI.IsValidItemID(itemId)) {
            return;
        }
        _m_cp.FindChildInLayoutFile('id-season-medal-model').SetActiveItem(0);
        _m_cp.FindChildInLayoutFile('id-season-medal-model').SetItemItemId(itemId, '');
        _m_cp.FindChildInLayoutFile('id-medal-model-zoom-btn').SetPanelEvent('onactivate', () => {
            $.DispatchEvent("InventoryItemPreview", itemId, '');
            ClosePopup();
        });
    }
    function _SetGlobalStats(seasonData) {
        let oTotals_data_for_display = {
            wins: 0,
            ties: 0,
            losses: 0,
            rounds: 0,
            kills: 0,
            headshots: 0,
            assists: 0,
            deaths: 0,
            mvps: 0,
            rounds_3k: 0,
            rounds_4k: 0,
            rounds_5k: 0,
            map_id: 0,
            map_name: ''
        };
        Object.entries(oTotals_data_for_display).forEach(([key, value]) => {
            if (_IsSimpleStat(key, value)) {
                let total = 0;
                seasonData.data_per_map.forEach(dataPerMap => {
                    let stat = dataPerMap[key];
                    total = stat + total;
                });
                oTotals_data_for_display[key] = total;
                _SetSimpleStat(key, 'id-global-stat-', total);
            }
        });
        _SetKDRatio(_m_cp.FindChildInLayoutFile('id-global-stat-k-d'), oTotals_data_for_display.kills, oTotals_data_for_display.deaths);
        _SetKillPerRound(_m_cp.FindChildInLayoutFile('id-global-stat-kpr'), oTotals_data_for_display.kills, oTotals_data_for_display.rounds);
        _SetMatchesPlayed(_m_cp.FindChildInLayoutFile('id-global-stat-matches-played'), oTotals_data_for_display.wins, oTotals_data_for_display.losses, oTotals_data_for_display.ties);
        _SetWinPercentStat(_m_cp.FindChildInLayoutFile('id-global-stat-win-percent'), oTotals_data_for_display.wins, oTotals_data_for_display.losses, oTotals_data_for_display.ties);
        _SetHeadshotPercentStat(_m_cp.FindChildInLayoutFile('id-global-stat-hs-percent'), oTotals_data_for_display.headshots, oTotals_data_for_display.kills);
        let elBar = _m_cp.FindChildInLayoutFile('id-global-bar-container');
        _SetWinsBar(elBar, {
            wins: oTotals_data_for_display.wins,
            ties: oTotals_data_for_display.ties,
            losses: oTotals_data_for_display.losses
        });
        $.Schedule(.5, () => {
            _PositionTiesLabel(_m_cp.FindChildInLayoutFile('id-global-stat-ties'), elBar.FindChild('id-bar-ties'), oTotals_data_for_display.ties);
        });
    }
    ;
    function _IsSimpleStat(key, value) {
        return key !== 'map_name' && key !== 'map_id' && typeof value === 'number';
    }
    function _SetSimpleStat(statName, prefix, value, mapStatPanel = null) {
        let elStat = mapStatPanel && mapStatPanel.IsValid() ?
            mapStatPanel.FindChildInLayoutFile(prefix + statName) :
            _m_cp.FindChildInLayoutFile(prefix + statName);
        if (elStat && elStat.IsValid()) {
            if (elStat.FindChild('stat-title')) {
                elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_' + statName));
            }
            if (elStat.FindChild('stat-icon')) {
                elStat.FindChild('stat-icon').SetImage('file://{images}/icons/ui/stat_' + statName + '.svg');
            }
            var displayValue = FormatText.FormatNumberToNiceString(value, 0);
            elStat.SetDialogVariable('stat-value', displayValue);
        }
    }
    function _SetKillPerRound(elStat, kills, rounds) {
        let nStatKPR = ((kills / Math.max(1, rounds)).toFixed(3));
        elStat.Data().value = nStatKPR;
        elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_kpr'));
        elStat.SetDialogVariable('stat-value', nStatKPR);
    }
    function _SetKDRatio(elStat, kills, deaths) {
        let nStat = ((kills / Math.max(1, deaths))).toFixed(3);
        elStat.Data().value = nStat;
        elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_kd'));
        elStat.SetDialogVariable('kdratio', nStat);
        elStat.FindChild('stat-value').text = $.Localize('#season_stat_value_kd', elStat);
    }
    function _SetMatchesPlayed(elStat, wins, losses, ties) {
        let nStatMatchesTotal = (wins + losses + ties);
        elStat.Data().value = nStatMatchesTotal;
        elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_matches_played'));
        elStat.SetDialogVariable('stat-value', FormatText.FormatNumberToNiceString(nStatMatchesTotal, 0));
    }
    function _SetWinPercentStat(elStat, wins, losses, ties) {
        let nWinPercent = ((wins / Math.max(1, losses + wins + ties)) * 100).toFixed(1);
        elStat.Data().value = nWinPercent;
        elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_win_percent'));
        elStat.SetDialogVariable('win-percent', nWinPercent);
        elStat.FindChild('stat-value').text = $.Localize('#season_stat_value_win_percent', elStat);
    }
    function _SetHeadshotPercentStat(elStat, headshots, kills) {
        let nHsPercent = ((headshots / kills) * 100).toFixed(1);
        elStat.Data().value = nHsPercent;
        elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_hs_percent'));
        elStat.SetDialogVariable('hs-percent', nHsPercent);
        elStat.FindChild('stat-value').text = $.Localize('#season_stat_value_hs_percent', elStat);
        if (elStat.FindChild('stat-icon')) {
            elStat.FindChild('stat-icon').SetImage('file://{images}/icons/ui/stat_headshots.svg');
        }
    }
    function _SetWinsBar(elBarContainer, oData) {
        const totalValue = (oData.wins + oData.ties + oData.losses);
        elBarContainer.FindChildInLayoutFile('id-bar-wins').style.width = Math.ceil((oData.wins / totalValue) * 100).toString() + '%';
        elBarContainer.FindChildInLayoutFile('id-bar-losses').style.width = Math.ceil((oData.losses / totalValue) * 100).toString() + '%';
        elBarContainer.FindChildInLayoutFile('id-bar-ties').style.width = Math.ceil((oData.ties / totalValue) * 100).toString() + '%';
    }
    function _PositionTiesLabel(elTies, elTiesBar, nTies) {
        elTies.visible = nTies > 0;
        if (nTies > 0) {
            let nXPos = Math.floor(elTiesBar.actualxoffset / elTiesBar.actualuiscale_x);
            if (nXPos > 1920 || nXPos <= 0) {
                elTies.visible = false;
                return;
            }
            elTies.style.x = nXPos + 'px;';
        }
    }
    function _SetRank(seasonData) {
        let nRank = 0;
        let weekName = '';
        seasonData.data_per_week.forEach(data_per_week => {
            if (data_per_week.rank_id > nRank) {
                nRank = data_per_week.rank_id;
                weekName = data_per_week.week_name;
            }
        });
        const options = {
            root_panel: _m_cp.FindChildInLayoutFile('id-premier-rating'),
            do_fx: true,
            full_details: false,
            rating_type: 'Premier',
            leaderboard_details: { score: nRank },
            local_player: false
        };
        RatingEmblem.SetXuid(options);
        let elStat = _m_cp.FindChildInLayoutFile('id-global-stat-week');
        elStat.SetDialogVariable('stat-title', $.Localize('#season_stat_title_achieved_week'));
        elStat.SetDialogVariable('stat-value', $.Localize(weekName));
    }
    function _SetUpPerMapStats(seasonData) {
        let elBtns = _m_cp.FindChildInLayoutFile('id-stats-per-map-btns');
        let elRows = _m_cp.FindChildInLayoutFile('id-stats-mode-grid-rows');
        let mostPlayedMap = '';
        let mostPlayedMapCount = 0;
        let aMapList = TournamentsAPI.GetPremierSeasonMaps(_m_seasonId).split(',');
        let oEmptyMap = {
            wins: 0,
            ties: 0,
            losses: 0,
            rounds: 0,
            kills: 0,
            headshots: 0,
            assists: 0,
            deaths: 0,
            mvps: 0,
            rounds_3k: 0,
            rounds_4k: 0,
            rounds_5k: 0,
            map_id: 0,
            map_name: ''
        };
        if (elBtns.Children().length < 1) {
            let elHeaderRow = $.CreatePanel('Panel', elRows, 'id-stat-map-row-header');
            elHeaderRow.BLoadLayoutSnippet('grid-row');
            elHeaderRow.SetHasClass('row-header', true);
            _FillOutMapRow(elHeaderRow, oEmptyMap);
            aMapList.forEach((mapName, idx) => {
                let map = seasonData.data_per_map.find(function (element) {
                    return element.map_name === mapName;
                });
                if (map && map.hasOwnProperty('map_name')) {
                    let elBtn = _MakeMapRadioButton(elBtns, map.map_name, true);
                    _MapBtnOnPanelEvents(elBtns, elBtn, map);
                    _MakeMapStatsRow(elRows, map.map_name, map);
                    if ((map.wins + map.losses + map.ties) > mostPlayedMapCount) {
                        mostPlayedMapCount = (map.wins + map.losses + map.ties);
                        mostPlayedMap = map.map_name;
                    }
                }
                else {
                    let elBtn = _MakeMapRadioButton(elBtns, mapName, false);
                    _MapBtnOnPanelEvents(elBtns, elBtn, null);
                    oEmptyMap.map_name = mapName;
                    _MakeMapStatsRow(elRows, mapName, oEmptyMap);
                }
            });
        }
        if (mostPlayedMap) {
            let defaultBtn = elBtns.FindChild('id-stat-map-btn-' + mostPlayedMap);
            defaultBtn.checked = true;
            $.DispatchEvent("Activated", defaultBtn, "mouse");
            let defaultGridStat = elRows.Children()[0].FindChild('id-row-stat-wins');
            defaultGridStat.checked = true;
            $.DispatchEvent("Activated", defaultGridStat, "mouse");
        }
    }
    function _MakeMapRadioButton(elBtns, mapName, isEnabled) {
        let elBtn = $.CreatePanel('RadioButton', elBtns, 'id-stat-map-btn-' + mapName, {
            text: $.Localize('#SFUI_Map_' + mapName),
            class: 'stats-panel-map-btn',
            group: 'stat-maps'
        });
        let btnImg = $.CreatePanel('Image', elBtn, '', { textureheight: '48px', texturewidth: '-1' });
        btnImg.SetImage("file://{images}/map_icons/map_icon_" + mapName + ".svg");
        elBtn.enabled = isEnabled;
        return elBtn;
    }
    function _MapBtnOnPanelEvents(elBtns, elBtn, map) {
        if (!map) {
            elBtn.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip(elBtn.id, '#tooltip-no-map-stats');
            });
            elBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
            return;
        }
        let elStatsPanelsParent = _m_cp.FindChildInLayoutFile('id-stats-panel-all-maps-container');
        let prefixMapStatPanel = 'id-stat-map-stats-';
        elBtn.SetPanelEvent('onactivate', () => {
            let elPanel = elStatsPanelsParent.FindChild(prefixMapStatPanel + map.map_name);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elStatsPanelsParent, prefixMapStatPanel + map.map_name);
                elPanel.BLoadLayoutSnippet('single-map-stats');
                elPanel.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/360p/' + map.map_name + '.png")';
                elPanel.style.backgroundPosition = '50% 50%';
                elPanel.style.backgroundSize = 'clip_then_cover';
                elPanel.style.backgroundImgOpacity = '.035';
                _FillOutPerMapStats(elPanel, map);
            }
            let aBtns = elBtns.Children();
            aBtns.forEach(element => { element.hittest = false; });
            if (_m_elSelectedMap && _m_elSelectedMap.IsValid() && _m_elSelectedMap !== elPanel) {
                _m_elSelectedMap.SwitchClass('show-page', 'map-hide');
            }
            if (_m_elSelectedMap !== elPanel) {
                elPanel.SwitchClass('show-page', 'map-reset');
            }
            $.Schedule(.16, () => {
                elPanel?.SwitchClass('show-page', 'map-selected');
                aBtns.forEach(element => { element.hittest = true; });
            });
            _m_elSelectedMap = elPanel;
        });
    }
    function _MakeMapStatsRow(elRows, mapName, map) {
        let elRow = $.CreatePanel('Panel', elRows, 'id-stat-map-row-' + mapName);
        elRow.BLoadLayoutSnippet('grid-row');
        _FillOutMapRow(elRow, map);
    }
    function _FillOutPerMapStats(elPanel, mapData) {
        Object.entries(mapData).forEach(([key, value]) => {
            if (_IsSimpleStat(key, value)) {
                _SetSimpleStat(key, 'id-map-stat-', value, elPanel);
            }
        });
        _SetMatchesPlayed(elPanel.FindChildInLayoutFile('id-map-stat-matches-played'), mapData.wins, mapData.losses, mapData.ties);
        _SetWinPercentStat(elPanel.FindChildInLayoutFile('id-map-stat-win-percent'), mapData.wins, mapData.losses, mapData.ties);
        _SetKDRatio(elPanel.FindChildInLayoutFile('id-map-stat-k-d'), mapData.kills, mapData.deaths);
        _SetKillPerRound(elPanel.FindChildInLayoutFile('id-map-stat-kpr'), mapData.kills, mapData.rounds);
        _SetHeadshotPercentStat(elPanel.FindChildInLayoutFile('id-map-stat-hs-percent'), mapData.headshots, mapData.kills);
        let elBar = elPanel.FindChildInLayoutFile('id-bar-container');
        _SetWinsBar(elBar, {
            wins: mapData.wins,
            ties: mapData.ties,
            losses: mapData.losses
        });
        let elTies = elPanel.FindChildInLayoutFile('id-map-stat-ties');
        elTies.visible = false;
        $.Schedule(.8, () => {
            _PositionTiesLabel(elTies, elBar.FindChild('id-bar-ties'), mapData.ties);
        });
    }
    function _SetUpStatsPanelTypeButtons() {
        _m_cp.FindChildInLayoutFile('id-stats-mode-row-btn').SetPanelEvent('onactivate', () => {
            _ShowStatsPanelType('row');
            _m_cp.FindChildInLayoutFile('id-map-stats-header').visible = true;
        });
        _m_cp.FindChildInLayoutFile('id-stats-mode-grid-btn').SetPanelEvent('onactivate', () => {
            _ShowStatsPanelType('grid');
            _m_cp.FindChildInLayoutFile('id-map-stats-header').visible = false;
        });
        $.DispatchEvent("Activated", _m_cp.FindChildInLayoutFile('id-stats-mode-row-btn'), "mouse");
    }
    function _ShowStatsPanelType(type) {
        let elGridPanel = _m_cp.FindChildInLayoutFile('id-stats-mode-grid');
        let elRowPanel = _m_cp.FindChildInLayoutFile('id-stats-mode-row');
        elGridPanel.SetHasClass('show', type === 'grid');
        elRowPanel.SetHasClass('show', type === 'row');
    }
    function _FillOutMapRow(elRow, mapData) {
        let isHeader = mapData.map_id === 0 && mapData.map_name == '';
        let hasNoData = mapData.map_id === 0 && mapData.map_name !== '';
        Object.entries(mapData).forEach(([key, value]) => {
            if (_IsSimpleStat(key, value)) {
                if (key !== 'headshots') {
                    if (!isHeader) {
                        _CreateRowEntry(elRow, 'Panel', 'id-row-stat-', key, value);
                        if (!hasNoData)
                            _SetSimpleStat(key, 'id-row-stat-', value, elRow);
                    }
                    else {
                        _CreateRowEntry(elRow, 'RadioButton', 'id-row-stat-', key, value);
                        elRow.FindChild('id-row-stat-' + key).SetDialogVariable('stat-value', $.Localize('#season_stat_title_' + key));
                    }
                }
            }
        });
        let elEntry;
        let panelType = isHeader ? 'RadioButton' : 'Panel';
        elEntry = _CreateRowEntry(elRow, panelType, 'id-row-stat-', 'matches-played');
        elEntry = _CreateRowEntry(elRow, panelType, 'id-row-stat-', 'win-percent');
        elEntry = _CreateRowEntry(elRow, panelType, 'id-row-stat-', 'k-d');
        elEntry = _CreateRowEntry(elRow, panelType, 'id-row-stat-', 'kpr');
        elEntry = _CreateRowEntry(elRow, panelType, 'id-row-stat-', 'hs-percent');
        _MoveEntryToCorrectPosition(elRow);
        if (!isHeader) {
            elRow.FindChildInLayoutFile('map-icon').SetImage("file://{images}/map_icons/map_icon_" + mapData.map_name + ".svg");
            let aEntries = elRow?.Children();
            aEntries?.[1].SetHasClass('has-mask', true);
            aEntries?.[aEntries.length - 1].SetHasClass('has-mask-reverse', true);
            if (hasNoData) {
                elRow.SetDialogVariable('stat-value', '-');
                elRow.Data().isEmpty = true;
                return;
            }
            _SetMatchesPlayed(elRow.FindChildInLayoutFile('id-row-stat-matches-played'), mapData.wins, mapData.losses, mapData.ties);
            _SetWinPercentStat(elRow.FindChildInLayoutFile('id-row-stat-win-percent'), mapData.wins, mapData.losses, mapData.ties);
            _SetKDRatio(elRow.FindChildInLayoutFile('id-row-stat-k-d'), mapData.kills, mapData.deaths);
            _SetKillPerRound(elRow.FindChildInLayoutFile('id-row-stat-kpr'), mapData.kills, mapData.rounds);
            _SetHeadshotPercentStat(elRow.FindChildInLayoutFile('id-row-stat-hs-percent'), mapData.headshots, mapData.kills);
        }
        else {
            elRow.FindChild('id-row-stat-matches-played').SetDialogVariable('stat-value', $.Localize('#season_stat_title_matches_played'));
            elRow.FindChild('id-row-stat-win-percent').SetDialogVariable('stat-value', $.Localize('#season_stat_title_win_percent'));
            elRow.FindChild('id-row-stat-k-d').SetDialogVariable('stat-value', $.Localize('#season_stat_title_kd'));
            elRow.FindChild('id-row-stat-kpr').SetDialogVariable('stat-value', $.Localize('#season_stat_title_kpr'));
            elRow.FindChild('id-row-stat-hs-percent').SetDialogVariable('stat-value', $.Localize('#season_stat_title_hs_percent'));
        }
    }
    function _CreateRowEntry(elRow, type, prefix, key, value = -1) {
        let elEntry;
        if (type === 'Panel') {
            elEntry = $.CreatePanel('Panel', elRow, prefix + key);
            elEntry.BLoadLayoutSnippet('grid-row-entry');
            elEntry.Data().value = value > 0 ? value : 0;
            elEntry.Data().key = key;
        }
        else {
            elEntry = $.CreatePanel('RadioButton', elRow, prefix + key, { group: 'row-sort-btn' });
            elEntry.BLoadLayoutSnippet('grid-row-entry');
            elEntry.Data().key = key;
            elEntry.SetPanelEvent('onactivate', () => {
                if (!_m_selectedGridStat || _m_selectedGridStat !== elEntry) {
                    let elParent = elRow.GetParent();
                    let aRows = elParent.Children();
                    aRows.slice(1);
                    let aNewSort = _SortRows(aRows, prefix, key);
                    aNewSort.forEach((row, idx) => {
                        elParent.MoveChildAfter(row, elParent.Children()[0]);
                        row.Children().forEach(entry => {
                            entry.SetHasClass('highlight-entry', entry.Data().key === key);
                        });
                    });
                    elParent.Children().forEach((row, idx) => {
                        row.SetHasClass('no-background', (idx % 2) == 1);
                    });
                    _m_selectedGridStat = elEntry;
                }
            });
        }
        return elEntry;
    }
    function _SortRows(aRows, prefix, key) {
        return aRows.sort((a, b) => {
            if (a.Data().isEmpty) {
                return -1;
            }
            if (key === 'losses' || key === 'deaths') {
                return a.FindChild(prefix + key)?.Data().value > b.FindChild(prefix + key)?.Data().value ? -1 :
                    a.FindChild(prefix + key)?.Data().value < b.FindChild(prefix + key)?.Data().value ? 1 : 0;
            }
            return a.FindChild(prefix + key)?.Data().value < b.FindChild(prefix + key)?.Data().value ? -1 :
                a.FindChild(prefix + key)?.Data().value > b.FindChild(prefix + key)?.Data().value ? 1 : 0;
        });
    }
    function _MoveEntryToCorrectPosition(elRow) {
        const aOrder = [
            'matches-played',
            'win-percent',
            'wins',
            'losses',
            'ties',
            'kills',
            'deaths',
            'assists',
            'rounds',
            'k-d',
            'kpr',
            'hs-percent',
            'mvps',
            'rounds_5k',
            'rounds_4k',
            'rounds_3k'
        ];
        let elChildren = elRow.Children();
        for (let i = 0; i < aOrder.length; i++) {
            let elPanel = elRow.FindChild('id-row-stat-' + aOrder[i]);
            if (elPanel && elPanel.IsValid()) {
                if (i == 0) {
                    elRow?.MoveChildAfter(elRow.FindChild('id-row-stat-' + aOrder[i]), elChildren[0]);
                }
                else {
                    elRow?.MoveChildAfter(elRow.FindChild('id-row-stat-' + aOrder[i]), elRow.FindChild('id-row-stat-' + aOrder[i - 1]));
                }
            }
        }
    }
    function _SetUpSpiderGraph(seasonData) {
        if (_m_spiderGraph.BCanvasReady()) {
            _DrawSpiderGraph(seasonData);
            _CreateRanksHistoryGraph(seasonData.data_per_week);
            _CreateMatchesBarGraph(seasonData.data_per_week);
            _m_cp.SetDialogVariableInt('week_min', 1);
            _m_cp.SetDialogVariableInt('week_max', seasonData.data_per_week.length);
        }
        else {
            $.Schedule(0.1, () => { _SetUpSpiderGraph(seasonData); });
        }
    }
    function _DrawSpiderGraph(seasonData) {
        let maxWins = 0;
        let aMapList = TournamentsAPI.GetPremierSeasonMaps(_m_seasonId).split(',');
        var playerWins = {};
        seasonData.data_per_map.forEach(dataPerMap => {
            maxWins = dataPerMap.wins > maxWins ? dataPerMap.wins : maxWins;
            playerWins[dataPerMap.map_name] = dataPerMap.wins;
        });
        _DrawSpiderGraphGuides(maxWins, aMapList.length);
        let winsForDisplay = aMapList.map((map_name) => { return map_name.startsWith('de_') ? Number(playerWins[map_name] | 0) : 0; });
        _DrawSpiderGraphPlayerPlot(winsForDisplay, maxWins);
        _MakeSpiderGraphMapPanels(aMapList);
    }
    function _DrawSpiderGraphGuides(maxWins, numMaps) {
        _m_spiderGraph.ClearJS('rgba(0,0,0,0)');
        const options = {
            bkg_color: "#00000090",
            spokes_color: '#27628581',
            spoke_thickness: 2,
            spoke_softness: 100,
            spoke_length_scale: 1.2,
            guideline_color: '#1b455e62',
            guideline_thickness: 2,
            guideline_softness: 100,
            guideline_count: maxWins > 20 ? 20 : maxWins + 1,
            deadzone_percent: 0.03,
            scale: 0.68
        };
        _m_spiderGraph.SetGraphOptions(options);
        _m_spiderGraph.DrawGraphBackground(numMaps);
    }
    function _DrawSpiderGraphPlayerPlot(arrValues, max) {
        const teamColorIdx = PartyListAPI.GetPartyMemberSetting(MyPersonaAPI.GetXuid(), 'game/teamcolor');
        const teamColorRgb = TeamColor.GetTeamColor(Number(teamColorIdx));
        let rgbColorLine = 'rgba(' + teamColorRgb + ',' + '1' + ')';
        let rgbColorInner = 'rgba(' + teamColorRgb + ',' + '.1' + ')';
        let rgbColorOuter = 'rgba(' + teamColorRgb + ',' + '.2' + ')';
        arrValues = arrValues.map(a => a / max);
        const options = {
            line_color: rgbColorLine,
            line_thickness: 3,
            line_softness: 10,
            fill_color_inner: rgbColorInner,
            fill_color_outer: rgbColorOuter,
        };
        _m_spiderGraph.DrawGraphPoly(arrValues, options);
    }
    function _MakeSpiderGraphMapPanels(arrMaps) {
        let elMapContainer = _m_spiderGraph;
        elMapContainer.RemoveAndDeleteChildren();
        for (let s = 0; s < arrMaps.length; s++) {
            let elMap = $.CreatePanel('Panel', elMapContainer, String(s));
            elMap.BLoadLayoutSnippet('snippet-mwr-map');
            let elMapImage = elMap.FindChildInLayoutFile('mwr-map__image');
            let imageName = arrMaps[s];
            elMapImage.SetImage('file://{images}/map_icons/map_icon_' + imageName + ".svg");
            elMapImage.style.backgroundPosition = '50% 50%';
            elMapImage.style.backgroundSize = 'auto 150%';
            elMap.style.flowChildren = 'up';
            elMap.SetDialogVariable('map-name', $.Localize('#SFUI_Map_' + imageName));
            let vPos = _m_spiderGraph.GraphPositionToUIPosition(s, 1.3);
            elMap.SetPositionInPixels(vPos.x, vPos.y, 0);
        }
    }
    function _CreateRanksHistoryGraph(aDataPerWeek) {
        const lineGraph = $('#id-rank-history-line-graph');
        let aRankData = [];
        let aWeeks = [];
        let aWeekNames = [];
        let minRank = 0;
        let maxRank = 0;
        aDataPerWeek.forEach((week, idx) => {
            aRankData.push(week.rank_id);
            aWeeks.push(idx);
            aWeekNames.push(week.week_name);
            if (week.rank_id > 0) {
                if (minRank <= 0)
                    minRank = week.rank_id;
                if (week.rank_id < minRank)
                    minRank = week.rank_id;
                if (maxRank <= 0)
                    maxRank = week.rank_id;
                if (week.rank_id > maxRank)
                    maxRank = week.rank_id;
            }
        });
        if (minRank > 0)
            minRank = Math.floor(minRank / 5000) * 5000;
        maxRank = Math.ceil(maxRank / 5000) * 5000;
        if (maxRank <= minRank) {
            if (minRank > 0)
                minRank -= 5000;
            else
                maxRank += 5000;
        }
        const xvals = aWeeks;
        const yvals = aRankData;
        const options = {
            draw_guidelines: true,
            guideline_color: "#1b48638a",
            guideline_thick: 2,
            guideline_soft: 1,
            guideline_count: 5,
            line_color: "#68B5DF",
            line_thickness: 2,
            line_softness: 1,
            draw_points: true,
            point_size: 3,
            point_color: "#68B5DF",
            yaxis_min: minRank,
            yaxis_max: maxRank,
            yaxis_interp: 0,
            xaxis_centroidcoords: true,
            gradient_color: "#42619133;",
        };
        lineGraph.SetGraphOptions(options);
        lineGraph.SetData(xvals, yvals);
        lineGraph.Show();
        _AddYAxisRanks(lineGraph);
        _MakeDots(lineGraph, aWeekNames.filter((word, index) => aRankData[index] !== 0), aWeeks.filter((word, index) => aRankData[index] !== 0), aRankData.filter(rank => rank !== 0));
    }
    function _AddYAxisRanks(lineGraph) {
        const guidelineYPositions = lineGraph.GetGuidelinePositions();
        guidelineYPositions.forEach((posData, index) => {
            let elParent = _m_cp.FindChildInLayoutFile('id-line-graph-y-axis');
            let elRating = $.CreatePanel('Panel', elParent, 'id-rating-y-' + posData.x);
            elRating.BLoadLayout('file://{resources}/layout/rating_emblem.xml', false, false);
            elRating.SetHasClass('y-axis-premier-rating', true);
            const options = {
                root_panel: elRating,
                do_fx: false,
                full_details: false,
                rating_type: 'Premier',
                leaderboard_details: { score: posData.x },
                local_player: false
            };
            RatingEmblem.SetXuid(options);
            elRating.style.y = posData.y + 'px;';
        });
    }
    function _MakeDots(lineGraph, aWeekNames, aWeeks, aRanks) {
        const pointPositions = lineGraph.GetDataPointPositions();
        let highestRank = Math.max(...aRanks);
        pointPositions.forEach((posData, index) => {
            let elPoint = $.CreatePanel('Panel', lineGraph, 'id-point-' + index, { class: 'stats-rank-line-graph-dot' });
            elPoint.style.x = posData.x + 'px;';
            elPoint.style.y = posData.y + 'px;';
            elPoint.SetHasClass('highest-rank', highestRank === aRanks[index]);
            elPoint.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowCustomLayoutParametersTooltip(elPoint.id, 'tooltip-season-rank', 'file://{resources}/layout/tooltips/tooltip_stat_season_rank.xml', 'rank=' + aRanks[index].toString() + '&' +
                    'week_name=' + aWeekNames[index] + '&' +
                    'week_idx=' + (aWeeks[index] + 1));
            });
            elPoint.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideCustomLayoutTooltip('tooltip-season-rank');
            });
        });
    }
    function _CreateMatchesBarGraph(aDataPerWeek) {
        const barGraph = $('#stats-panel-matches-bar-graph');
        const textHeight = 15;
        const graphHeight = (barGraph.actuallayoutheight / barGraph.actualuiscale_y) - textHeight;
        const graphWidth = (barGraph.actuallayoutwidth / barGraph.actualuiscale_x);
        let maxMatches = 0;
        aDataPerWeek.forEach((week) => {
            maxMatches = week.matches_played > maxMatches ? week.matches_played : maxMatches;
        });
        let singleMatchHeight = maxMatches > 10 ? graphHeight / maxMatches : 10;
        let singleMatchWidth = graphWidth / aDataPerWeek.length;
        aDataPerWeek.forEach((week, idx) => {
            let elBar = barGraph.FindChild('id-weekly-bar-' + week.week_id);
            if (!elBar && week.matches_played > 0) {
                elBar = $.CreatePanel('Panel', barGraph, 'id-weekly-bar-' + week.week_id);
                elBar.BLoadLayoutSnippet('graph-bar');
                elBar.FindChild('id-bar-inner').style.height = (singleMatchHeight * week.matches_played) + 'px';
                elBar.style.x = (singleMatchWidth * idx) + 'px';
                elBar.SetDialogVariableInt('num-matches', week.matches_played);
                elBar.SetHasClass('angle-text', maxMatches > 99);
                elBar.SetPanelEvent('onmouseover', () => {
                    UiToolkitAPI.ShowCustomLayoutParametersTooltip(elBar.id, 'tooltip-season-rank', 'file://{resources}/layout/tooltips/tooltip_stat_season_rank.xml', 'rank=' + '&' +
                        'week_name=' + week.week_name + '&' +
                        'week_idx=' + (idx + 1));
                });
                elBar.SetPanelEvent('onmouseout', () => {
                    UiToolkitAPI.HideCustomLayoutTooltip('tooltip-season-rank');
                });
            }
        });
    }
    {
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_Tournaments_PremierSeasonSummaryReceived', _UpdateSeasonData);
        $.RegisterEventHandler('ReadyForDisplay', _m_cp, _ReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', _m_cp, _UnreadyForDisplay);
    }
})(PopupSeasonStats || (PopupSeasonStats = {}));
