"use strict";
/// <reference path="csgo.d.ts" />
var watchTile;
(function (watchTile) {
    let TEAMS = ['CT', 'TERRORIST'];
    function SetParentActive(elTile, value = false) {
        if (!elTile.Data().markForDelete) {
            let elLogo = elTile.FindChildTraverse('gotvicon');
            if (elLogo) {
                if (value) {
                    elLogo.AddClass('GOTV-Icon--ParentActive');
                }
                else {
                    elLogo.RemoveClass('GOTV-Icon--ParentActive');
                }
            }
        }
    }
    watchTile.SetParentActive = SetParentActive;
    function Delete(elTile) {
        $.DispatchEvent('DeletePanel', elTile);
    }
    watchTile.Delete = Delete;
    function _CheckPlayerParticipatedInMatch(elTile) {
        let bPlayerParticipated = false;
        let myTeam = 0;
        for (let t = 0; t < 2; t++) {
            for (let n = 0; n < 5; n++) {
                let playerXuid = MatchInfoAPI.GetMatchPlayerXuidByIndexForTeam(elTile.Data().matchId, t, n);
                if (playerXuid === elTile.Data().myXuid) {
                    bPlayerParticipated = true;
                    myTeam = t;
                }
            }
        }
        return { bPlayerParticipated: bPlayerParticipated, myTeam: myTeam };
    }
    function Init(elTile) {
        let bPlayerParticipated = false;
        let matchState = MatchInfoAPI.GetMatchState(elTile.Data().matchId);
        let matchTileDescriptor = 'player';
        let myTeam = 0;
        if (elTile.id == 'live_gotv')
            matchTileDescriptor = 'gotv';
        let isLive = Boolean(MatchInfoAPI.IsLive(elTile.Data().matchId));
        let tournamentName = MatchInfoAPI.GetMatchTournamentName(elTile.Data().matchId);
        if ((tournamentName != undefined) && (tournamentName != "")) {
            matchTileDescriptor = 'tournament';
        }
        else if (matchState == 'live') {
            matchTileDescriptor = 'live';
        }
        let _multiresult = _CheckPlayerParticipatedInMatch(elTile);
        bPlayerParticipated = _multiresult.bPlayerParticipated;
        myTeam = _multiresult.myTeam;
        let rawModeName = MatchInfoAPI.GetMatchMode(elTile.Data().matchId);
        let mapName = MatchInfoAPI.GetMatchMap(elTile.Data().matchId);
        elTile.BLoadLayout("file://{resources}/layout/matchtiles/" + matchTileDescriptor + ".xml", true, false);
        let elTileMenu = elTile.FindChildTraverse('MatchTileMenu');
        let elDownloadingButton = undefined;
        let elDownloadButton = undefined;
        let elShareButton = undefined;
        let elMoreButton = undefined;
        let elDownloadFailedButton = undefined;
        let elWatchButton = undefined;
        if (elTileMenu) {
            if (elTile.Data().matchListDescriptor === 'live') {
            }
            else {
            }
        }
        let elMatchMapLabel = elTile.FindChildInLayoutFile('mapname');
        let elMatchMapIcon = elTile.FindChildInLayoutFile('mapicon');
        let elMatchModeIcon = elTile.FindChildInLayoutFile('modeicon');
        let elSkillGroupImg = elTile.FindChildInLayoutFile('skillgroup');
        let elScore0Label = elTile.FindChildInLayoutFile('score_team0');
        let elVsLabel = elTile.FindChildInLayoutFile('vs');
        let elScore1Label = elTile.FindChildInLayoutFile('score_team1');
        let elViewersLabel = elTile.FindChildInLayoutFile('viewers');
        let elOutcomeLabel = elTile.FindChildInLayoutFile('outcome');
        let elTimestampLabel = elTile.FindChildInLayoutFile('timestamp');
        if (elMatchMapLabel) {
            let mapLabelText = "#SFUI_Map_" + mapName;
            let mapLabelLocalizedText = $.Localize("#SFUI_Map_" + mapName);
            if (mapLabelText === mapLabelLocalizedText) {
                elMatchMapLabel.text = mapName;
            }
            else {
                elMatchMapLabel.text = mapLabelLocalizedText;
            }
        }
        let team0 = 0;
        let team1 = 1;
        if (bPlayerParticipated && (myTeam != 0)) {
            team0 = 1;
            team1 = 0;
        }
        let vsText = '-';
        if (matchTileDescriptor === 'tournament') {
            let elTournamentNameLabel = elTile.FindChildInLayoutFile('tournamentname');
            let elTournamentTeam0Icon = elTile.FindChildInLayoutFile('team0');
            let elTournamentTeam1Icon = elTile.FindChildInLayoutFile('team1');
            vsText = '-' + $.Localize("#WatchMenu_Tournament_Versus") + '-';
            elTournamentNameLabel.text = $.Localize(MatchInfoAPI.GetMatchTournamentStageName(elTile.Data().matchId));
            let setDefaultTeamImage = function (teamIcon) {
                teamIcon.SetImage("file://{images}/tournaments/teams/nologo.svg");
            };
            $.RegisterEventHandler('ImageFailedLoad', elTournamentTeam0Icon, setDefaultTeamImage.bind(undefined, elTournamentTeam0Icon));
            $.RegisterEventHandler('ImageFailedLoad', elTournamentTeam1Icon, setDefaultTeamImage.bind(undefined, elTournamentTeam1Icon));
            let icon0Filename = 'file://{images}/tournaments/teams/' + MatchInfoAPI.GetMatchTournamentTeamTag(elTile.Data().matchId, team0).toLowerCase() + '.svg';
            let icon1Filename = 'file://{images}/tournaments/teams/' + MatchInfoAPI.GetMatchTournamentTeamTag(elTile.Data().matchId, team1).toLowerCase() + '.svg';
            if (elTournamentTeam0Icon)
                elTournamentTeam0Icon.SetImage(icon0Filename);
            if (elTournamentTeam1Icon)
                elTournamentTeam1Icon.SetImage(icon1Filename);
        }
        if (elScore0Label) {
            elScore0Label.text = MatchInfoAPI.GetMatchRoundScoreForTeam(elTile.Data().matchId, team0).toString();
            if (matchTileDescriptor != 'tournament') {
                elScore0Label.AddClass('tint--' + TEAMS[team0]);
            }
        }
        if (elVsLabel) {
            elVsLabel.text = vsText;
        }
        if (elScore1Label) {
            elScore1Label.text = MatchInfoAPI.GetMatchRoundScoreForTeam(elTile.Data().matchId, team1).toString();
            if (matchTileDescriptor != 'tournament') {
                elScore1Label.AddClass('tint--' + TEAMS[team1]);
            }
        }
        if (elViewersLabel) {
            let spectatorCount = MatchInfoAPI.GetMatchSpectators(elTile.Data().matchId);
            if (!spectatorCount) {
                spectatorCount = 0;
            }
            elTile.SetDialogVariableInt('spectatorCount', spectatorCount);
            elViewersLabel.SetHasClass('hide', spectatorCount === 0);
        }
        if (bPlayerParticipated) {
            if (elOutcomeLabel) {
                let outcomeCode = MatchInfoAPI.GetMatchOutcome(elTile.Data().matchId);
                if (outcomeCode == undefined) {
                    elOutcomeLabel.AddClass('MatchInfo--Hide');
                }
                else {
                    if (myTeam != 0) {
                        if (outcomeCode == 1)
                            outcomeCode = 2;
                        else if (outcomeCode == 2)
                            outcomeCode = 1;
                    }
                    switch (outcomeCode) {
                        case 0:
                            elTile.AddClass('MatchTied');
                            elOutcomeLabel.text = $.Localize("#WatchMenu_Outcome_Tied", elOutcomeLabel);
                            break;
                        case 1:
                            elTile.AddClass('MatchVictory');
                            elOutcomeLabel.text = $.Localize("#WatchMenu_Outcome_Won", elOutcomeLabel);
                            break;
                        case 2:
                            elTile.AddClass('MatchLoss');
                            elOutcomeLabel.text = $.Localize("#WatchMenu_Outcome_Lost", elOutcomeLabel);
                            break;
                        case 3:
                            elOutcomeLabel.text = $.Localize("#WatchMenu_Outcome_Abandon");
                            break;
                    }
                }
            }
        }
        if (elTimestampLabel) {
            if (isLive)
                elTimestampLabel.text = $.Localize("#CSGO_Watch_Cat_LiveMatches");
            else
                elTimestampLabel.text = MatchInfoAPI.GetMatchTimestamp(elTile.Data().matchId);
        }
        let setDefaultMapImage = function (mapIcon) {
            mapIcon.SetImage("file://{images}/map_icons/map_icon_NONE.png");
        };
        if (elMatchMapIcon) {
            $.RegisterEventHandler('ImageFailedLoad', elMatchMapIcon, setDefaultMapImage.bind(undefined, elMatchMapIcon));
            elMatchMapIcon.SetImage("file://{images}/map_icons/map_icon_" + mapName + ".svg");
        }
        let setDefaultModeImage = function (mapIcon) {
            mapIcon.SetImage("file://{images}/icons/ui/competitive.vsvg");
        };
        if (elMatchModeIcon) {
            $.RegisterEventHandler('ImageFailedLoad', elMatchModeIcon, setDefaultModeImage.bind(undefined, elMatchModeIcon));
            elMatchModeIcon.SetImage("file://{images}/icons/ui/" + rawModeName + ".svg");
        }
        if (elSkillGroupImg) {
            let skillgroup = MatchInfoAPI.GetMatchSkillGroup(elTile.Data().matchId);
            if (skillgroup)
                elSkillGroupImg.SetImage("file://{images}/icons/skillgroups/skillgroup" + skillgroup + ".svg");
        }
    }
    watchTile.Init = Init;
    function Refresh(elTile) {
        Init(elTile);
    }
    watchTile.Refresh = Refresh;
    function SetDownloadHandler(elTile, handle = null) {
        elTile.Data().downloadStateHandler = handle;
    }
    watchTile.SetDownloadHandler = SetDownloadHandler;
    function GetDownloadHandler(elTile, handle = null) {
        return elTile.Data().downloadStateHandler;
    }
    watchTile.GetDownloadHandler = GetDownloadHandler;
})(watchTile || (watchTile = {}));
