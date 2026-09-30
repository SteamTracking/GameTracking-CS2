"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="endofmatch.ts" />
var EOM_Voting;
(function (EOM_Voting) {
    const _m_cP = $('#eom-voting');
    const _m_elVoteItemPanels = {};
    let _m_updateJob = undefined;
    let m_randIdx = 0;
    function _DisplayMe() {
        if (!_m_cP || !_m_cP.IsValid())
            return;
        if (GameStateAPI.IsDemoOrHltv())
            return false;
        const oTime = MockAdapter.GetTimeDataJSO();
        if (!oTime)
            return false;
        $.RegisterForUnhandledEvent('EndOfMatch_Shutdown', _CancelUpdateJob);
        const oMatchEndVoteData = MockAdapter.NextMatchVotingData(_m_cP);
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_slidein', 'MOUSE');
        if (!oMatchEndVoteData || !oMatchEndVoteData.voting_options)
            return false;
        const elMapSelectionList = _m_cP.FindChildInLayoutFile('id-map-selection-list');
        Object.keys(oMatchEndVoteData.voting_options).forEach((key, index) => {
            const type = oMatchEndVoteData.voting_options[key].type;
            if (type == "separator") {
                const elVoteItem = $.CreatePanel("Panel", elMapSelectionList, "");
                elVoteItem.AddClass("vote-item--separator");
            }
            else {
                let text = '';
                const elVoteItem = $.CreatePanel("RadioButton", elMapSelectionList, "id-vote-item--" + key);
                elVoteItem.BLoadLayoutSnippet("MapGroupSelection");
                elVoteItem.Data().m_key = key;
                if (type == "skirmish") {
                    const skirmishId = oMatchEndVoteData.voting_options[key].id;
                    text = $.Localize(GameTypesAPI.GetSkirmishName(skirmishId));
                    const cfg = GameTypesAPI.GetConfig();
                    if (cfg) {
                        const mg = cfg.mapgroups['mg_skirmish_' + GameTypesAPI.GetSkirmishInternalName(skirmishId)];
                        if (mg) {
                            Object.keys(mg.maps).forEach((map, i) => {
                                const elMapImage = $.CreatePanel('Panel', elVoteItem.FindChildInLayoutFile('MapGroupImagesCarousel'), 'MapSelectionScreenshot' + i);
                                elMapImage.AddClass('map-selection-btn__screenshot');
                                const image = 'url("file://{images}/map_icons/screenshots/360p/' + map + '.png")';
                                if (map in cfg.maps) {
                                    elMapImage.style.backgroundImage = image;
                                    elMapImage.style.backgroundPosition = '50% 0%';
                                    elMapImage.style.backgroundSize = 'auto 100%';
                                }
                            });
                        }
                    }
                    const elMapIcon = elVoteItem.FindChildInLayoutFile("id-map-selection-btn__modeicon");
                    const modeIcon = "file://{images}/icons/ui/" + GameTypesAPI.GetSkrimishIcon(skirmishId) + ".svg";
                    elMapIcon.SetImage(modeIcon);
                    elMapIcon.RemoveClass('hidden');
                }
                else if (type == "map") {
                    const internalName = oMatchEndVoteData.voting_options[key].name;
                    text = GameTypesAPI.GetFriendlyMapName(internalName);
                    let image;
                    const elMapImage = $.CreatePanel('Panel', elVoteItem.FindChildInLayoutFile('MapGroupImagesCarousel'), 'MapSelectionScreenshot');
                    elMapImage.AddClass('map-selection-btn__screenshot');
                    const cfg = GameTypesAPI.GetConfig();
                    if (cfg && ('maps' in cfg) && (internalName in cfg.maps)) {
                        image = 'url("file://{images}/map_icons/screenshots/360p/' + internalName + '.png")';
                    }
                    else {
                        image = 'url("file://{images}/map_icons/screenshots/360p/random.png")';
                    }
                    elMapImage.style.backgroundImage = image;
                    elMapImage.style.backgroundPosition = '50% 0%';
                    elMapImage.style.backgroundSize = 'auto 100%';
                }
                elVoteItem.FindChildTraverse("MapGroupName").text = text;
                elVoteItem.Data().m_name = text;
                elVoteItem.SetPanelEvent('onactivate', () => {
                    GameInterfaceAPI.ConsoleCommand("endmatch_votenextmap" + " " + elVoteItem.Data().m_key);
                    elMapSelectionList.FindChildrenWithClassTraverse("map-selection-btn").forEach(btn => btn.enabled = false);
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_select', 'MOUSE');
                });
                _m_elVoteItemPanels[index] = elVoteItem;
            }
        });
        _UpdateVotes();
        return true;
    }
    function _UpdateVotes() {
        _m_updateJob = undefined;
        if (!_m_cP || !_m_cP.IsValid())
            return;
        const oMatchEndVoteData = MockAdapter.NextMatchVotingData(_m_cP);
        if (!oMatchEndVoteData) {
            return;
        }
        function _GetWinningMaps() {
            let arrVoteWinnersKeys = [];
            let highestVote = 0;
            for (let key of Object.keys(oMatchEndVoteData.voting_options)) {
                const nVotes = oMatchEndVoteData.voting_options[key].votes;
                if (nVotes > highestVote)
                    highestVote = nVotes;
            }
            for (let key of Object.keys(oMatchEndVoteData.voting_options)) {
                const nVotes = oMatchEndVoteData.voting_options[key].votes;
                if ((nVotes === highestVote) &&
                    (oMatchEndVoteData.voting_options[key].type != 'separator'))
                    arrVoteWinnersKeys.push(key);
            }
            return arrVoteWinnersKeys;
        }
        if (oMatchEndVoteData) {
            if (oMatchEndVoteData.voting_done) {
                const elMapSelectionList = _m_cP.FindChildInLayoutFile('id-map-selection-list');
                elMapSelectionList.FindChildrenWithClassTraverse("map-selection-btn").forEach(btn => btn.enabled = false);
                const winner = oMatchEndVoteData["voting_winner"];
                if (winner !== -1) {
                    let winningKey = '';
                    for (let key of Object.keys(_m_elVoteItemPanels)) {
                        if (_m_elVoteItemPanels[key].Data().m_key == winner)
                            winningKey = key;
                    }
                    if (winningKey != '' && _m_elVoteItemPanels[winningKey]) {
                        const elCheckmark = _m_elVoteItemPanels[winningKey].FindChildTraverse('id-map-selection-btn__winner');
                        if (!elCheckmark.BHasClass('appear')) {
                            elCheckmark.AddClass("appear");
                            $.DispatchEvent('CSGOPlaySoundEffect', 'mainmenu_press_GO', 'MOUSE');
                        }
                    }
                }
                else {
                    const arrWinners = _GetWinningMaps();
                    if (arrWinners.length == 0)
                        return;
                    if (arrWinners.length == 1) {
                        return;
                    }
                    let randIdx = 0;
                    if (arrWinners.length > 2) {
                        randIdx = Math.floor(Math.random() * arrWinners.length);
                    }
                    if (randIdx == m_randIdx) {
                        m_randIdx++;
                        if (m_randIdx >= arrWinners.length) {
                            m_randIdx = 0;
                        }
                    }
                    else {
                        m_randIdx = randIdx;
                    }
                    const voteidx = arrWinners[m_randIdx];
                    const elVoteItem = _m_elVoteItemPanels[voteidx];
                    if (!elVoteItem || !elVoteItem.IsValid())
                        return;
                    const panelToHilite = elVoteItem.FindChildTraverse("id-map-selection-btn__gradient");
                    if (!panelToHilite || !panelToHilite.IsValid())
                        return;
                    panelToHilite.RemoveClass("map-selection-btn__gradient--whiteout");
                    panelToHilite.AddClass("map-selection-btn__gradient--whiteout");
                    $.DispatchEvent('CSGOPlaySoundEffect', 'buymenu_select', elVoteItem.id);
                }
            }
            else {
                for (let key of Object.keys(_m_elVoteItemPanels)) {
                    const elVoteItem = _m_elVoteItemPanels[key];
                    const oVoteOptions = oMatchEndVoteData.voting_options[_m_elVoteItemPanels[key].Data().m_key];
                    const elVoteCountLabel = elVoteItem.FindChildTraverse("id-map-selection-btn__count");
                    const votes = oVoteOptions.votes;
                    const votesNeeded = oMatchEndVoteData["votes_to_succeed"];
                    if (votes > 0 && votes !== elVoteCountLabel.Data().votecount) {
                        $.DispatchEvent('CSGOPlaySoundEffect', 'tab_settings_settings', elVoteItem.id);
                        elVoteCountLabel.Data().votecount = votes;
                    }
                    elVoteCountLabel.text = "<font color='#ffc130'>" + votes + '</font>/' + votesNeeded;
                }
            }
            _m_updateJob = $.Schedule(0.2, _UpdateVotes);
        }
    }
    function Start() {
        if (MockAdapter.GetMockData() && !MockAdapter.GetMockData().includes('VOTING')) {
            _End();
            return;
        }
        if (_DisplayMe()) {
            EndOfMatch.SwitchToPanel('eom-voting');
        }
        else {
            _End();
        }
    }
    function _End() {
        _CancelUpdateJob();
        EndOfMatch.ShowNextPanel();
    }
    function _CancelUpdateJob() {
        if (_m_updateJob != undefined) {
            $.CancelScheduled(_m_updateJob);
            _m_updateJob = undefined;
        }
    }
    function Shutdown() {
    }
    {
        EndOfMatch.RegisterPanelObject({
            name: 'eom-voting',
            Start: Start,
            Shutdown: Shutdown
        });
    }
})(EOM_Voting || (EOM_Voting = {}));
