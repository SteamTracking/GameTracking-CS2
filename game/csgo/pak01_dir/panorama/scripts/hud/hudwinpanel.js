"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../avatar.ts" />
/// <reference path="../digitpanel.ts" />
/// <reference path="../particle_controls.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/scheduler.ts" />
/// <reference path="../common/teamcolor.ts" />
/// <reference path="../hud/hudwinpanel_background_map.ts" />
var HudWinPanel;
(function (HudWinPanel) {
    let _m_elCanvas;
    let _m_elPlotContainer;
    let _m_canvasHeightInPixels;
    let _m_canvasWidthInPixels;
    let _m_teamPerspective;
    let _m_localXuid;
    let _m_timeslice;
    let _m_bInit = false;
    let _m_xRange;
    let _m_prevChance;
    let _m_ListeningForGameEvents = false;
    let _m_bCanvasIsReady = false;
    let _m_arrTimelineEvents = [];
    let _m_arrPersonalDamageEvents = [];
    let _m_winningTeam;
    const TOTAL_TIME_REVEAL = 5;
    const BEAM_ONLY_ON_DAMAGE = false;
    function _Init() {
        if (_m_bInit)
            return;
        $.RegisterForUnhandledEvent('HudWinPanel_ShowRoundEndReport', _ShowRoundEndReport);
        $.RegisterForUnhandledEvent('Player_Hurt', _OnReceivePlayerHurt);
        $.RegisterForUnhandledEvent('Player_Death', _OnReceivePlayerDeath);
        _m_bInit = true;
    }
    function _SetMVP(xuid, reason, team) {
        const avatar = $("#MVPAvatar");
        avatar.PopulateFromPlayerSlot(GameStateAPI.GetPlayerSlot(xuid));
        avatar.SetHasClass("team--TERRORIST", team === 2);
        avatar.SetHasClass("team--CT", team === 3);
        $.GetContextPanel().SetDialogVariableInt('player_slot', GameStateAPI.GetPlayerSlot(xuid));
        let sMvpReasonToken = "#Panorama_winpanel_mvp_award";
        let elMapContainer = $.GetContextPanel().FindChildInLayoutFile('id-match-mvp-map-container');
        MvpBackgroundMap.SetUpMapWinPanel(xuid, reason, team, elMapContainer);
        switch (reason) {
            case 1:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_kills";
                break;
            case 2:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_bombplant";
                break;
            case 3:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_bombdefuse";
                break;
            case 4:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_rescue";
                break;
            case 5:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_gungame";
                break;
            case 7:
                sMvpReasonToken = "#Panorama_winpanel_mvp_winner";
                break;
            case 9:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_ace";
                break;
            case 10:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_inferno";
                break;
            case 11:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_blast";
                break;
            case 12:
                sMvpReasonToken = "#Panorama_winpanel_mvp_winner";
                break;
            case 13:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_bombplant_clutch";
                break;
            case 14:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_bombdefuse_clutch";
                break;
            case 15:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_kills_three";
                break;
            case 16:
                sMvpReasonToken = "#Panorama_winpanel_mvp_award_kills_four";
                break;
        }
        $.GetContextPanel().SetDialogVariable("mvp_name_and_reason", $.Localize(sMvpReasonToken, $.GetContextPanel()));
        const jsHonorIcon = $("#jsHonorIcon");
        jsHonorIcon.Set(GameStateAPI.GetPlayerXpTrailLevel(xuid), false);
    }
    function _OnReceivePlayerHurt(attackerXuid, victimXuid, damage) {
        if (!_m_ListeningForGameEvents)
            return;
        if (!_m_bCanvasIsReady) {
            $.Schedule(0.5, () => _OnReceivePlayerHurt(attackerXuid, victimXuid, damage));
            return;
        }
        if (_m_localXuid != attackerXuid && _m_localXuid != victimXuid)
            return;
        const wasDamageGiven = _m_localXuid == attackerXuid;
        const healthRemoved = wasDamageGiven ? damage : 0;
        const numHits = wasDamageGiven ? 1 : 0;
        const returnedHealthRemoved = wasDamageGiven ? 0 : damage;
        const returnHits = wasDamageGiven ? 0 : 1;
        _UpdateDamage(wasDamageGiven ? victimXuid : attackerXuid, healthRemoved, numHits, returnedHealthRemoved, returnHits);
    }
    function _OnReceivePlayerDeath(xuid) {
        if (!_m_ListeningForGameEvents)
            return;
        if (!_m_bCanvasIsReady) {
            $.Schedule(0.5, () => _OnReceivePlayerDeath(xuid));
            return;
        }
        const elEvent = $.GetContextPanel().FindChildTraverse('Event-' + xuid);
        if (!elEvent)
            return;
        const elDeath = elEvent.FindChildTraverse('Death');
        if (!elDeath)
            return;
        elDeath.visible = true;
    }
    function _TransformPointIntoCanvasSpace(point) {
        const denom = _m_xRange;
        const x = _m_canvasWidthInPixels / denom * point[0];
        const y = _m_canvasHeightInPixels - (_m_canvasHeightInPixels / 100 * point[1]);
        return [x, y];
    }
    function _FlipY(plotPoint) {
        return [plotPoint[0], _m_canvasHeightInPixels - plotPoint[1]];
    }
    function _ConvertToLocalOdds(terroristOdds) {
        if (_m_teamPerspective == 2)
            return terroristOdds;
        else
            return (100 - terroristOdds);
    }
    function _ShowRoundEndReport(msg) {
        if (!msg)
            return;
        _Reset();
        _m_ListeningForGameEvents = true;
        if (!_m_elCanvas.IsSizeValid()) {
            $.Schedule(0.5, () => _ShowRoundEndReport.bind(msg));
            return;
        }
        _m_bCanvasIsReady = true;
        $.GetContextPanel().SetDialogVariable('player_name', GameStateAPI.GetPlayerName(_m_localXuid));
        _m_canvasHeightInPixels = _m_elCanvas.actuallayoutheight / _m_elCanvas.actualuiscale_y;
        _m_canvasWidthInPixels = _m_elCanvas.actuallayoutwidth / _m_elCanvas.actualuiscale_x;
        const oInitialConditions = msg.init_conditions;
        const nStartingOdds = oInitialConditions.terrorist_odds;
        const arrEvents = msg.all_rer_event_data;
        _m_arrTimelineEvents = _ExtractTimelineEvents(arrEvents);
        _m_arrPersonalDamageEvents = _ExtractLivingEnemies(arrEvents);
        _m_winningTeam = '';
        if (_m_arrTimelineEvents.length > 0) {
            const FinalTOdds = _m_arrTimelineEvents[_m_arrTimelineEvents.length - 1]['terrorist_odds'];
            _m_winningTeam = FinalTOdds == 100 ? 2 : FinalTOdds == 0 ? 3 : '';
        }
        _m_xRange = _m_arrTimelineEvents.length + _m_arrPersonalDamageEvents.length + 1.5;
        _m_timeslice = TOTAL_TIME_REVEAL / _m_xRange;
        const x = 0;
        const y = _ConvertToLocalOdds(nStartingOdds);
        const startPoint = [x, y];
        const startPlotPoint = _TransformPointIntoCanvasSpace(startPoint);
        const points = [];
        points.push(startPoint);
        const plotPoints = [];
        plotPoints.push(startPlotPoint);
        _PlotStartingOdds(nStartingOdds, startPlotPoint);
        _ProcessTimelineEvents(_m_arrTimelineEvents, points, plotPoints, nStartingOdds);
        const finalPoint = points[points.length - 1];
        _ProcessDamageEvents(_m_arrPersonalDamageEvents, finalPoint[0]);
        const bCT = _m_teamPerspective == 3;
        const drawColor = bCT ? '#B5D4EEaa' : '#EAD18Aaa';
        _m_elCanvas.DrawSoftLinePointsJS(plotPoints.length, plotPoints.flat(), 4, 1.0, drawColor);
        _m_elCanvas.TriggerClass('show-canvas');
        const graphWidth = (_m_arrTimelineEvents.length) / _m_xRange * 100;
        const elGraphGuides = $.GetContextPanel().FindChildTraverse('GraphGuides');
        elGraphGuides.style.width = graphWidth + "%";
        const elLivingBG = $.GetContextPanel().FindChildTraverse('LivingBG');
        elLivingBG.style.width = 100 - graphWidth + "%";
        _Colorize();
        const freezetime = Number(GameInterfaceAPI.GetSettingString('mp_freezetime'));
        const roundRestartDelay = Number(GameInterfaceAPI.GetSettingString('mp_round_restart_delay'));
        const shutdownDelay = roundRestartDelay + freezetime - 1;
        Scheduler.Schedule(shutdownDelay, () => {
            _m_ListeningForGameEvents = false;
            _m_bCanvasIsReady = false;
        });
    }
    function _ExtractTimelineEvents(arrEvents) {
        const arrResults = [];
        for (let oEvent of arrEvents) {
            const oVictimData = oEvent['victim_data'];
            const isLivingPlayer = oVictimData && !oVictimData['is_dead'];
            if (!isLivingPlayer)
                arrResults.push(oEvent);
        }
        return arrResults;
    }
    function _ExtractLivingEnemies(arrEvents) {
        const arrResults = [];
        for (let oEvent of arrEvents) {
            const oVictimData = oEvent['victim_data'];
            const isLivingPlayer = oVictimData && !oVictimData['is_dead'];
            const localTeam = GameStateAPI.GetAssociatedTeamNumber(_m_localXuid);
            const isEnemy = oVictimData && oVictimData['team_number'] != localTeam && (localTeam == 2 || localTeam == 3);
            if (isLivingPlayer && isEnemy)
                arrResults.push(oEvent);
        }
        return arrResults;
    }
    function _ProcessTimelineEvents(arrEvents, points, plotPoints, nStartingOdds) {
        let loopingSfxHandle = null;
        for (let index = 0; index < arrEvents.length; ++index) {
            const oEvent = arrEvents[index];
            const x = index + 1;
            const y = _ConvertToLocalOdds(oEvent['terrorist_odds']);
            const point = [x, y];
            const plotPoint = _TransformPointIntoCanvasSpace(point);
            points.push(point);
            plotPoints.push(plotPoint);
            let delta = 0;
            if (index == 0)
                delta = oEvent['terrorist_odds'] - nStartingOdds;
            else
                delta = oEvent['terrorist_odds'] - arrEvents[index - 1]['terrorist_odds'];
            const sfx = delta < 0 ? "UIPanorama.round_report_line_down" : "UIPanorama.round_report_line_up";
            const delay = index * _m_timeslice;
            Scheduler.Schedule(delay, () => {
                _AddDamageToDamagePanel(oEvent, plotPoint);
                _DecoratePoint(oEvent, plotPoint);
                if (loopingSfxHandle)
                    UiToolkitAPI.StopSoundEvent(loopingSfxHandle, 0.1);
                loopingSfxHandle = UiToolkitAPI.PlaySoundEvent(sfx);
            });
        }
        Scheduler.Schedule(_m_arrTimelineEvents.length * _m_timeslice, () => {
            if (loopingSfxHandle)
                UiToolkitAPI.StopSoundEvent(loopingSfxHandle, 0.1);
        });
    }
    function _ProcessDamageEvents(arrEvents, startX) {
        for (let index = 0; index < arrEvents.length; ++index) {
            const oEvent = arrEvents[index];
            const x = startX + index + 1;
            const y = 50;
            const plotPoint = _TransformPointIntoCanvasSpace([x, y]);
            const delay = (_m_arrTimelineEvents.length + index) * _m_timeslice;
            Scheduler.Schedule(delay, () => {
                _AddDamageToDamagePanel(oEvent, plotPoint);
                _DecoratePoint(oEvent, plotPoint);
            });
        }
    }
    function _Colorize() {
        const bCT = _m_winningTeam == 3;
        for (let el of $.GetContextPanel().FindChildrenWithClassTraverse('team-colorize')) {
            el.SetHasClass('color-ct', bCT);
            el.SetHasClass('color-t', !bCT);
        }
    }
    function _FindDamageDataForPlayer(oEvent, xuid) {
        const oDamageData = oEvent.all_damage_data;
        const returnObj = {};
        for (let i = 0; i < oDamageData.length; i++) {
            if (oDamageData[i].other_xuid.toString() == xuid)
                Object.assign(returnObj, oDamageData[i]);
        }
        return returnObj;
    }
    function _UpdateDamage(xuid, healthRemoved, numHits, returnHealthRemoved, returnHits) {
        const elDamage = $.GetContextPanel().FindChildTraverse('Damage-' + xuid);
        if (!elDamage)
            return;
        elDamage.healthRemoved += healthRemoved;
        elDamage.healthRemoved = Math.min(elDamage.healthRemoved, 100);
        elDamage.numHits += numHits;
        elDamage.returnHealthRemoved += returnHealthRemoved;
        elDamage.returnHealthRemoved = Math.min(elDamage.returnHealthRemoved, 100);
        elDamage.returnHits += returnHits;
        if ((elDamage.returnHealthRemoved > 0) || (elDamage.healthRemoved > 0)) {
            const elDGiven = elDamage.FindChildTraverse('DamageGiven');
            const elDTaken = elDamage.FindChildTraverse('DamageTaken');
            elDGiven.SetDialogVariable('health_removed', elDamage.healthRemoved.toString());
            elDGiven.SetDialogVariable('num_hits', elDamage.numHits.toString());
            elDTaken.SetDialogVariable('health_removed', elDamage.returnHealthRemoved.toString());
            elDTaken.SetDialogVariable('num_hits', elDamage.returnHits.toString());
            elDGiven.visible = elDamage.healthRemoved > 0;
            elDTaken.visible = elDamage.returnHealthRemoved > 0;
            if (BEAM_ONLY_ON_DAMAGE) {
                const elTeamColorBar = $.GetContextPanel().FindChildTraverse('bar-' + xuid);
                if (elTeamColorBar) {
                    elTeamColorBar.RemoveClass('prereveal');
                }
            }
            const dmgDelay = 0.1;
            Scheduler.Schedule(dmgDelay, () => {
                if (elDamage && elDamage.IsValid())
                    elDamage.RemoveClass('prereveal');
            });
        }
    }
    function _AddDamageToDamagePanel(oEvent, plotPoint) {
        const elDamageContainer = $.GetContextPanel().FindChildTraverse('DamageContainer');
        const oDamage = _FindDamageDataForPlayer(oEvent, _m_localXuid);
        const victimData = oEvent['victim_data'];
        const objectiveData = oEvent['objective_data'];
        if (objectiveData)
            return;
        const elDamage = $.CreatePanel('Panel', elDamageContainer, 'Damage-' + victimData['xuid']);
        elDamage.BLoadLayoutSnippet('snippet-damage');
        elDamage.healthRemoved = 0;
        elDamage.numHits = 0;
        elDamage.returnHealthRemoved = 0;
        elDamage.returnHits = 0;
        elDamage.style.x = plotPoint[0] + "px";
        if (BEAM_ONLY_ON_DAMAGE) {
            const bCT = _m_winningTeam == 3;
            const elTeamColorBar = $.CreatePanel('Panel', _m_elPlotContainer, 'bar-' + victimData['xuid']);
            elTeamColorBar.AddClass('ris-graph__bar');
            elTeamColorBar.AddClass('prereveal');
            elTeamColorBar.SetHasClass('color-ct', bCT);
            elTeamColorBar.SetHasClass('color-t', !bCT);
            elTeamColorBar.style.x = plotPoint[0] + "px";
            elTeamColorBar.style.height = _FlipY(plotPoint)[1] + 70 + "px";
        }
        if (oDamage) {
            const healthRemoved = oDamage.health_removed || 0;
            const nHits = oDamage.num_hits || 0;
            const returnedHealthRemoved = oDamage.return_health_removed || 0;
            const nReturnHits = oDamage.return_num_hits || 0;
            _UpdateDamage(victimData['xuid'], healthRemoved, nHits, returnedHealthRemoved, nReturnHits);
        }
    }
    function _PlotStartingOdds(nStartingOdds, startPlotPoint) {
        const elStartPlot = $.CreatePanel("Panel", _m_elPlotContainer, 'Start');
        elStartPlot.BLoadLayoutSnippet('snippet-starting-odds');
        elStartPlot.style.y = startPlotPoint[1] + "px";
        $.GetContextPanel().SetDialogVariable('starting_chance', _ConvertToLocalOdds(nStartingOdds) + '%');
        _m_prevChance = nStartingOdds;
    }
    function _DecoratePoint(oEvent, plotPoint) {
        const victimData = oEvent['victim_data'];
        const objectiveData = oEvent['objective_data'];
        const key = objectiveData ? objectiveData['type'] : victimData ? victimData['xuid'] : '';
        const elEventPlot = $.CreatePanel("Panel", _m_elPlotContainer, 'Event-' + key);
        elEventPlot.BLoadLayoutSnippet('snippet-event');
        const elEventIcon = elEventPlot.FindChildTraverse('EventIcon');
        const elEventBG = elEventPlot.FindChildTraverse('EventBG');
        const elEventChance = elEventPlot.FindChildTraverse('EventChance');
        const elEventMain = elEventPlot.FindChildTraverse('EventMain');
        const elDeath = elEventPlot.FindChildTraverse('Death');
        const chance = _ConvertToLocalOdds(oEvent['terrorist_odds']);
        if (victimData) {
            const xuid = victimData['xuid'];
            const isBot = victimData['is_bot'];
            const teamNumber = victimData['team_number'];
            const color = victimData['color'];
            const isDead = victimData['is_dead'];
            elEventChance.visible = isDead;
            elDeath.visible = isDead;
            elEventIcon.SetImage("file://{images}/icons/ui/kill.svg");
            elEventIcon.visible = false;
            const elAvatarImage = elEventPlot.FindChildTraverse('Avatar');
            elAvatarImage.PopulateFromPlayerSlot(GameStateAPI.GetPlayerSlot(xuid.toString()));
            const bCT = teamNumber == 3;
            elAvatarImage.SwitchClass('teamstyle', 'team--' + (bCT ? 'CT' : 'TERRORIST'));
            if (!BEAM_ONLY_ON_DAMAGE) {
                const elTeamColorBar = $.CreatePanel('Panel', _m_elPlotContainer, 'bar-' + victimData['xuid']);
                elTeamColorBar.AddClass('ris-graph__bar');
                elTeamColorBar.SetHasClass('color-ct', bCT);
                elTeamColorBar.SetHasClass('color-t', !bCT);
                elTeamColorBar.style.x = plotPoint[0] + "px";
                elTeamColorBar.style.height = _FlipY(plotPoint)[1] + 70 + "px";
            }
            const rgbColor = TeamColor.GetTeamColor(Number(color));
            elEventMain.FindChildTraverse('JsAvatarTeamColor').style.washColor = 'rgb(' + rgbColor + ')';
        }
        else if (objectiveData) {
            const elAvatarImage = elEventPlot.FindChildTraverse('Avatar');
            elAvatarImage.visible = false;
            let src = "";
            let bEventCT = false;
            switch (objectiveData['type']) {
                case 0:
                    src = "file://{images}/icons/ui/bomb_c4.svg";
                    bEventCT = false;
                    break;
                case 1:
                    src = "file://{images}/icons/ui/bomb.svg";
                    bEventCT = false;
                    break;
                case 2:
                    src = "file://{images}/icons/equipment/defuser.svg";
                    bEventCT = true;
                    break;
                case 3:
                    src = "file://{images}/icons/ui/time_exp.svg";
                    bEventCT = true;
                    break;
            }
            elEventIcon.SetImage(src);
            elEventIcon.AddClass('event__icon--objective');
            elEventBG.SetHasClass('color-ct', bEventCT);
            elEventBG.SetHasClass('color-t', !bEventCT);
        }
        const delta = chance - _m_prevChance;
        const deltaSymbol = delta < 0 ? "▼" : delta > 0 ? "▲" : "";
        if (chance == 100) {
            elEventPlot.SetDialogVariable('chance', $.Localize('#ris_win'));
            elEventChance.FindChildTraverse('EventChanceNumber').style.color = '#ffffff';
        }
        else if (chance == 0) {
            elEventPlot.SetDialogVariable('chance', $.Localize('#ris_loss'));
            elEventChance.FindChildTraverse('EventChanceNumber').style.color = '#ffffff';
        }
        else {
            elEventPlot.SetDialogVariable('chance', deltaSymbol + chance + '%');
            elEventChance.FindChildTraverse('EventChanceNumber').style.color = _RemapToTeamColorRGB(chance - _m_prevChance, -20, 20);
        }
        elEventPlot.style.x = plotPoint[0] + "px";
        elEventPlot.style.y = plotPoint[1] + "px";
        if (elEventMain && elEventMain.IsValid())
            elEventMain.RemoveClass('prereveal');
        if (elEventChance && elEventChance.IsValid())
            elEventChance.RemoveClass('prereveal');
        if (elDeath && elDeath.IsValid())
            elDeath.RemoveClass('prereveal');
        const sfx = delta > 0 ? "UIPanorama.round_report_odds_up" : delta < 0 ? "UIPanorama.round_report_odds_dn" : "UIPanorama.round_report_odds_none";
        UiToolkitAPI.PlaySoundEvent(sfx);
        _m_prevChance = chance;
    }
    function _RemapToTeamColorRGB(val, min, max) {
        let frac = Math.min(1, Math.max(0, (val - min) / (max - min)));
        const bCTWon = _m_winningTeam == 3;
        if (bCTWon)
            frac = 1 - frac;
        const R = frac * (234 - 122) + 122;
        const G = 210;
        const B = (1 - frac) * (238 - 139) + 139;
        return 'rgb(' + R + "," + G + "," + B + ")";
    }
    function _Reset() {
        const localTeamNumber = GameStateAPI.GetAssociatedTeamNumber(_m_localXuid);
        const bUseInEye = GameStateAPI.IsDemoOrHltv() || (localTeamNumber != 2 && localTeamNumber != 3);
        _m_localXuid = bUseInEye ? GameStateAPI.GetHudPlayerXuid() : GameStateAPI.GetLocalPlayerXuid();
        _m_teamPerspective = (localTeamNumber == 2 || localTeamNumber == 3) ? localTeamNumber : 2;
        const bCT = _m_teamPerspective == 3;
        _m_elCanvas = $.GetContextPanel().FindChildTraverse('RisCanvas');
        _m_elPlotContainer = $.GetContextPanel().FindChildTraverse('RisPlotContainer');
        Scheduler.Cancel();
        _m_arrTimelineEvents = [];
        _m_arrPersonalDamageEvents = [];
        _m_elPlotContainer.RemoveAndDeleteChildren();
        const elDamageContainer = $.GetContextPanel().FindChildTraverse('DamageContainer');
        elDamageContainer.RemoveAndDeleteChildren();
        _m_elCanvas.ClearJS('rgba(0,0,0,0)');
        $.GetContextPanel().SetDialogVariable('team', GameStateAPI.GetTeamClanName(bCT ? 'CT' : 'TERRORIST'));
        const elTeamLogo = $.GetContextPanel().FindChildTraverse('RisTeamLogo');
        if (elTeamLogo) {
            elTeamLogo.SetImage(bCT ? "file://{images}/icons/ui/ct_logo_1c.svg" : "file://{images}/icons/ui/t_logo_1c.svg");
        }
        _Colorize();
    }
    {
        $.RegisterEventHandler('HudWinPanel_MVP', $.GetContextPanel(), _SetMVP);
        _Init();
    }
})(HudWinPanel || (HudWinPanel = {}));
