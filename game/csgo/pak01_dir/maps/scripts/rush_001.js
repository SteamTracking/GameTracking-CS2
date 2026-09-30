/// <reference path="../../../csgo_addons/cs_script_demo/maps/scripts/point_script.d.ts" />

import {
	CSPlayerPawn,
	CSRadarColor,
	CSRadarPoint,
	CSObservablePoint,
	CSRoundEndReason,
	CSTeamMoneyReason,
	Instance,
	CSRadarIcon,
} from "cs_script/point_script";

                                                                                              
                                                                                      
                                                                                              

var _roomIds = [];
var _currentRoomIndex = -1;
var _roomStates = [];
var _roundOver = false;
var _tenSecondWarningPlayed = false;
                                                                                               
                                                                   
var _timerBeepNextTime = 0;
var _timerBeepCount = 0;
var _timerEndPlayed = false;
                                                                                 
var _gameOver = false;

                                                                                            
                                
var _lastRoundsPlayed = 0;

                                                                                   
var _teamWins = {};

var _teamEliminated = false;
var _legitimateKillsPerTeamThisRound = {}; 

var ROUNDS_TO_WIN = 8;                                                                    

const END_ROUND_ON_TEAM_ELIMINATION = false;

const THINK_FREQUENCY_SECONDS = 0.1;

                                                                                   
const TEN_SECOND_WARNING_ENTITY = "ten.second.warning";
const TEN_SECOND_WARNING_SECONDS = 10;


                                                      
const COUNTDOWN_TIME_SECONDS = 7;
const COUNTDOWN_TIME_END_ROOMS_SECONDS = 14;

                                                                               
const SOUND_CONTROL_GAINED = "poss.gained";
const SOUND_CONTROL_LOST = "poss.lost";

                                                                                      
const BEACON_IDLE_ENTITY_NAME = "beacon.idle";
const BEACON_PRESS_ENTITY_NAME = "beacon.press";
const BEACON_ERROR_ENTITY_NAME = "beacon.error";

                                                                                             
                                                                 
const BEACON_TIMER_BEEP_ENTITY_NAME = "beacon.timer.beep";
const BEACON_TIMER_END_ENTITY_NAME = "beacon.timer.end";

const MATCH_POINT_ENTITY = "match.point";

                                                                                            
                                                                                              
                                                                                             
                                                                                        
const TIMER_BEEP_STAGES = [
	{ beeps: 4, interval: 1.0 },
	{ beeps: 4, interval: 0.5 },
	{ beeps: 8, interval: 0.25 },
	{ interval: 0.125 },
];

const TIMER_BEEP_SECONDS = 10;

                                                                                               
                                                  
const TIMER_BEEP_TOLERANCE_SECONDS = 1 / 128;

const WIN_MONEY = 2500;

                                                                                              
                          
const SOUND_SLIDE_IN_FORWARD = "ui.slidein.forward";
const SOUND_SLIDE_IN_BACKWARD = "ui.slidein.backward";
const SOUND_SLIDE_OUT = "ui.slideout";

const TEAM_NONE = 0;
const TEAM_SPECTATOR = 1;
const TEAM_T = 2;
const TEAM_CT = 3;

                                                                                                 
                                                                                                  
var _lastRoundWinner = TEAM_NONE;

const START_ROOM = 3;
const T_FINAL_ROOM = 0;
const CT_FINAL_ROOM = 6;

const ROOM_NAMES =
{
	101: "room_101",
	102: "room_102",
	103: "room_103",
	104: "room_104",
	201: "room_201",
	202: "room_202",
	203: "room_203",
	204: "room_204",
	205: "room_205",
	206: "room_206",
	207: "room_207",
	208: "room_208",
	209: "room_209",
	210: "room_210",
	211: "room_211",
	212: "room_212",
	301: "room_301",
	401: "room_401",
	convoy: "Convoy"
};

                                                                                                    
const ROOM_IDS = [
	[401],          
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[101, 102, 103, 104],         
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[301],           
];

const ROOM_COUNT = ROOM_IDS.length;

                                                                                                                     
const DECIDER_ROOM_ID = "convoy";

                                                                              
const ROUND_SECONDS_BASE_ROOM = 60;
const ROUND_SECONDS_MID_ROOM = 40;

var _uiEntity = null;

Instance.OnActivate(() =>
{
	                                                    

	ResetGameState();
});

function ResetGameState() {
	_gameOver = false;
	_teamWins = { [TEAM_T]: 0, [TEAM_CT]: 0 };

	UIClear();

	                                                                                            
	_lastRoundWinner = TEAM_NONE;

	RandomizeRooms();

	                                                                                       
	_roomStates = [];

	SetRoomControl(0, TEAM_T, false);
	SetRoomControl(1, TEAM_T, false);
	SetRoomControl(2, TEAM_T, false);
	SetRoomControl(3, TEAM_CT, false);
	SetRoomControl(4, TEAM_CT, false);
	SetRoomControl(5, TEAM_CT, false);
	SetRoomControl(6, TEAM_CT, false);

	GoToRoom(START_ROOM);
}


function RandomizeRooms() {

	_roomIds = [];

	ROOM_IDS.forEach((possibilities, roomIndex) => {
		const remaining = possibilities.filter((item) => !_roomIds.includes(item));

		if (remaining.length == 0) {
			_roomIds.push(possibilities[0]);
			return;
		}

		const randomIndex = Math.floor(Math.random() * remaining.length);
		_roomIds.push(remaining[randomIndex]);
	});
}

function GoToRoom(roomIndex) {
	const roomId = _roomIds[roomIndex];
	MoveSpawnsToRooms(roomId, roomId);

	_currentRoomIndex = roomIndex;

	                                                                                            
	                                                                                         
	Instance.ServerCommand(`mp_roundtime ${RoundTimeMinutesForRoom(roomIndex)}`);
}

                                                                                           
function RoundTimeMinutesForRoom(roomIndex) {
	const seconds = IsFinalRoom(roomIndex) || _roomIds[roomIndex] == DECIDER_ROOM_ID
		? ROUND_SECONDS_BASE_ROOM
		: ROUND_SECONDS_MID_ROOM;

	return (seconds + 0.5) / 60;
}

function CountdownTimeSecondsForRoom(roomIndex) {
	const seconds = IsFinalRoom(roomIndex) || _roomIds[roomIndex] == DECIDER_ROOM_ID
		? COUNTDOWN_TIME_END_ROOMS_SECONDS
		: COUNTDOWN_TIME_SECONDS;

	return seconds;
}


function MoveSpawnsToRooms(tRoom, ctRoom) {
	TeleportEntitiesToTargets(new Map([
		["tspawn1", `t1room.${tRoom}`],
		["tspawn2", `t2room.${tRoom}`],
		["tspawn3", `t3room.${tRoom}`],
		["ctspawn1", `ct1room.${ctRoom}`],
		["ctspawn2", `ct2room.${ctRoom}`],
		["ctspawn3", `ct3room.${ctRoom}`],
	]));
}

function TeleportEntitiesToTargets(entityTargetMap) {
	for (const [entityName, targetName] of entityTargetMap) {
		                                                                                   
		const target = Instance.FindEntityByName(targetName);
		if (!target) {
			continue;
		}

		const entity = Instance.FindEntityByName(entityName);
		if (!entity) {
			continue;
		}

		entity.Teleport(target.GetAbsOrigin(), target.GetAbsAngles());
	}
}

Instance.OnRoundStart(() => {
	                                                                             
	Instance.SetNextThink(Instance.GetGameTime() + THINK_FREQUENCY_SECONDS);

	_roundOver = false;
	_tenSecondWarningPlayed = false;
	ResetTimerBeepState();
	_countdownActive = false;
	_teamEliminated = false;
	_legitimateKillsPerTeamThisRound = {};

	                                                                                            
	                                                                           
	                                                                                      
	                                                                                          
	                            
	const roundsPlayed = Instance.GetRoundsPlayed();
	if (roundsPlayed < _lastRoundsPlayed) {
		ResetGameState();
	}
	_lastRoundsPlayed = roundsPlayed;

	                                                                                              
	                                                               
	UIUpdateRoomControl( _roomStates[_currentRoomIndex] );

	if (!Instance.IsWarmupPeriod()) {
		const roundNum = roundsPlayed + 1;
		Instance.ServerCommand(
			`mp_default_team_winner_no_objective ${_roomStates[_currentRoomIndex]}`,
		);

		UIOnRoundStart();

		                                           
		if (IsFinalRoom(_currentRoomIndex) &&
			_teamWins[TEAM_CT] < ROUNDS_TO_WIN - 1 &&
			_teamWins[TEAM_T] < ROUNDS_TO_WIN - 1)
		{
			StartSoundEntity(MATCH_POINT_ENTITY);
		}

		Instance.ServerCommand("mp_ignore_round_win_conditions 1");

		                                                                                   
	} else {
		Instance.ServerCommand("mp_ignore_round_win_conditions 0");
	}

	                                                                                            
	                     
	SetRoomFog(_currentRoomIndex);
	MoveAntennaToRoom(_roomIds[_currentRoomIndex]);
	SetRoomLights( _currentRoomIndex, _roomStates[_currentRoomIndex] );

	                                                                                     
	SetAntennaGlow(true);

	ButtonOnRoundStart();
});

function IsFinalRoom(roomIndex) {
	return roomIndex == T_FINAL_ROOM || roomIndex == CT_FINAL_ROOM;
}

function EndRound(winningTeam) {
	let endReason;
	switch (winningTeam)
	{
		case TEAM_NONE: endReason = CSRoundEndReason.DRAW; break;
		case TEAM_T: endReason = CSRoundEndReason.TERRORISTS_WIN; break;
		case TEAM_CT: endReason = CSRoundEndReason.CTS_WIN; break;
	}

	Instance.EntFireAtName({
		name: "map_params",
		input: "FireWinCondition",
		value: endReason,
	});
}

                                                                                             
                                                                                   
function CheckEliminationRoundEnd() {
	                                                                                   
	if (IsRoundDecided()) return;

	const tWiped = IsTeamEliminated(TEAM_T);
	const ctWiped = IsTeamEliminated(TEAM_CT);

	if (!tWiped && !ctWiped) return;

	                                                                                             
	if (tWiped && ctWiped) {
		EndRound(_roomStates[_currentRoomIndex]);
		return;
	}

	if (END_ROUND_ON_TEAM_ELIMINATION)
	{
		EndRound(tWiped ? TEAM_CT : TEAM_T);
	}
	else
	{
		const survivingTeam = tWiped ? TEAM_CT : TEAM_T;
		if (_roomStates[_currentRoomIndex] == survivingTeam)
		{
			EndRound(survivingTeam);
		}
	}

	_teamEliminated = true;
}

Instance.OnRoundEnd((args) => {

	                                                                                             
	if (Instance.IsWarmupPeriod()) return;

	                       
	if (args.winningTeam == TEAM_SPECTATOR)
		args.winningTeam = TEAM_NONE;

	_roundOver = true;

	                                                                     
	if (args.winningTeam == TEAM_T || args.winningTeam == TEAM_CT) {
		++_teamWins[args.winningTeam];
	}

	                                                                                               
	                                                                                            
	                                                                
	SetRoomControl(_currentRoomIndex, args.winningTeam,                 false,                    false);

	if (args.winningTeam != TEAM_NONE) {
		Instance.AddTeamMoney( args.winningTeam, IsTeamEliminated( OtherTeam( args.winningTeam ) )
			? ( ( args.winningTeam == TEAM_CT )
					? CSTeamMoneyReason.ELIMINATION_HOSTAGE_MAP_CT
					: CSTeamMoneyReason.ELIMINATION_HOSTAGE_MAP_T )
			: CSTeamMoneyReason.WIN_BY_TIME_RUNNING_OUT_HOSTAGE, WIN_MONEY );
		                                                                                                                   
		                                                      
	}

	ButtonOnRoundEnd();
	UIOnRoundEnd();

	let nextRoomIndex = _currentRoomIndex;
	if (args.winningTeam == TEAM_T)
	{
		++nextRoomIndex;
	}
	else if (args.winningTeam == TEAM_CT)
	{
		--nextRoomIndex;
	}

	                                                                                          
	_lastRoundWinner = args.winningTeam;

	                                                                                          

	if (nextRoomIndex < T_FINAL_ROOM || nextRoomIndex > CT_FINAL_ROOM)
	{
		                                                          
		EndMatch(args.winningTeam);
	}
	else
	{
		MaybeSwapInDeciderRoom(nextRoomIndex);
		GoToRoom(nextRoomIndex);
	}
});

                                                                                                
                                                                                                   
function MaybeSwapInDeciderRoom(roomIndex) {

	const forced = _forceDeciderNextRound;
	_forceDeciderNextRound = false;

	if (!forced) {
		if (_teamWins[TEAM_T] != ROUNDS_TO_WIN - 1) return;
		if (_teamWins[TEAM_CT] != ROUNDS_TO_WIN - 1) return;
	}

	_roomIds[roomIndex] = DECIDER_ROOM_ID;
}

                                                                                            
                                                                          
function WinnerOnRoundsExhausted(frontlineRoomIndex) {
	if (_teamWins[TEAM_T] != _teamWins[TEAM_CT]) {
		return _teamWins[TEAM_T] > _teamWins[TEAM_CT] ? TEAM_T : TEAM_CT;
	}

	                                                                                                  
	if (frontlineRoomIndex > START_ROOM) return TEAM_T;
	if (frontlineRoomIndex < START_ROOM) return TEAM_CT;

	return TEAM_NONE;
}

function EndMatch(winningTeam) {
	_gameOver = true;

	                                                                                                
	Instance.ServerCommand(`mp_roundtime ${RoundTimeMinutesForRoom(START_ROOM)}`);
	Instance.ServerCommand(`mp_maxrounds ${Instance.GetRoundsPlayed()}`);
}

                                     
function StartSoundEntity(entityName) {
	if (!Instance.FindEntityByName(entityName)) {
		return;
	}

	Instance.EntFireAtName({ name: entityName, input: "StartSound" });
}

function IsInActiveRound() {
	if (Instance.IsWarmupPeriod()) return false;
	if (Instance.IsFreezePeriod()) return false;
	if (_gameOver) return false;
	if (_roundOver) return false;

	return true;
}

Instance.SetThink(() => {
	if (IsInActiveRound()) {
		const remaining = Instance.GetRoundRemainingTime();

		                                                                                  
		if (remaining > 0 && remaining <= TEN_SECOND_WARNING_SECONDS && !_tenSecondWarningPlayed) {
			_tenSecondWarningPlayed = true;
			StartSoundEntity(TEN_SECOND_WARNING_ENTITY);
		}

		if (remaining > 0 && remaining <= TIMER_BEEP_SECONDS) {
			TimerBeepThink();
		}

		if (remaining <= 0) {
			PlayTimerEndSound();
			EndRound(_roomStates[_currentRoomIndex]);
		}
	}

	                                                                                       
	if (_antennaGlowing && !Instance.IsFreezePeriod()) {
		SetAntennaGlow(false);
	}

	UIThink();

	                                                                                            
	                                                                                              
	                                                      
	let nextThink = Instance.GetGameTime() + THINK_FREQUENCY_SECONDS;
	if (_timerBeepNextTime > 0) {
		                                                                                     
		const beepThink = _timerBeepNextTime - TIMER_BEEP_TOLERANCE_SECONDS;
		if (beepThink > Instance.GetGameTime() && beepThink < nextThink) nextThink = beepThink;
	}

	Instance.SetNextThink(nextThink);
});

                                                                                      
                                                                                     
function SetRoomControl(roomIndex, team, playSound, updateLights = true) {
	if (_roomStates[roomIndex] == team) return;

	if (updateLights) SetRoomLights(roomIndex, team);

	if (roomIndex == _currentRoomIndex) {
		Instance.ServerCommand(`mp_default_team_winner_no_objective ${team}`);
		UIUpdateRoomControl(team);
	}
	_roomStates[roomIndex] = team;

	if (playSound) {
		PlaySoundForTeam(SOUND_CONTROL_GAINED, team);
		PlaySoundForTeam(SOUND_CONTROL_LOST, OtherTeam(team));
	}
}

                                                                                             
                                                                                               
const TEAM_COLORS = {
	[TEAM_NONE]: { r: 255, g: 240, b: 200 },
	[TEAM_T]: { r: 255, g: 100, b: 0 },
	[TEAM_CT]: { r: 0, g: 100, b: 255 },
};

                                                                                    
function ColorInputValue(color) {
	return `${color.r} ${color.g} ${color.b}`;
}

                                                                                              
                                                                                 
const TEAM_ANTENNA_SKINS = {
	[TEAM_NONE]: 0,             
	[TEAM_T]: 1,          
	[TEAM_CT]: 2,           
};

                                                                                           
                                                               
var _antennaTeam = TEAM_NONE;

                                                                             
function SetRoomLights(roomIndex, team) {
	                                                                                          
	                                                                                      
	if (roomIndex != _currentRoomIndex) return;

	const teamColor = TEAM_COLORS[team];
	const antennaSkin = TEAM_ANTENNA_SKINS[team];
	if (teamColor === undefined || antennaSkin === undefined) {
		return;
	}

	const lightColor = ColorInputValue(teamColor);

	ApplyAntennaLights(team);

	                                                                                         
	                                                                                         
	                                                                     
	ANTENNA_ROOT_TARGETS.forEach(([rootName]) => {
		const root = FindPrefabEntity(rootName);
		if (!root) return;

		Instance.EntFireAtTarget({ target: root, input: "Skin", value: antennaSkin });
	});

	                                                                                              
	Instance.EntFireAtName({ name: "*flag", input: "Color", value: lightColor });

	                                                                               
	_antennaTeam = team;

	                                                                    
	NotifySmokeLightingChanged();
}

async function NotifySmokeLightingChanged() {
	await Instance.Delay(0.1);
	Instance.ServerCommand("sv_smoke_lighting_changed");
}

Instance.OnPlayerKill((event) => {
	if (Instance.IsWarmupPeriod()) return;
	if (event.player && event.attacker && event.attacker instanceof CSPlayerPawn)
	{
		const victimTeam = event.player.GetPlayerController().GetTeamNumber();
		const killerTeam = event.attacker.GetPlayerController().GetTeamNumber();
		if (killerTeam == OtherTeam(victimTeam))
		{
			_legitimateKillsPerTeamThisRound[killerTeam] = (_legitimateKillsPerTeamThisRound[killerTeam] ?? 0) + 1;
		}
	}

	                                                              
	CheckEliminationRoundEnd();

	                                               
	const owningTeam = _roomStates[_currentRoomIndex];
	if (!END_ROUND_ON_TEAM_ELIMINATION && IsTeamEliminated(_roomStates[_currentRoomIndex]) && !_countdownActive)
	{
		if (_legitimateKillsPerTeamThisRound[OtherTeam(owningTeam)] && _legitimateKillsPerTeamThisRound[OtherTeam(owningTeam)] > 0)
		{
		_countdownActive = true;
		const newRoundTime = Math.min(Instance.GetRoundRemainingTime(), CountdownTimeSecondsForRoom(_currentRoomIndex));
		Instance.SetRoundRemainingTime(newRoundTime);
		}
	}
});

function GetAllPlayerControllersOfTeam(team) {
	return Instance.GetAllPlayerControllers().filter((controller) => controller.GetTeamNumber() == team);
}

function IsTeamEliminated(team) {
	const teamPlayers = GetAllPlayerControllersOfTeam(team);

	                                                                                             
	if (teamPlayers.length == 0) return false;

	return teamPlayers.filter((controller) => controller.GetPlayerPawn() && controller.GetPlayerPawn().IsAlive()).length == 0;
}

function OtherTeam(team)
{
	if (team == TEAM_CT)
		return TEAM_T;
	if (team == TEAM_T)
		return TEAM_CT;

	return 0;
}

                                                                                             
function PlaySoundForTeam(soundName, team) {
	                                                                     
	if (team != TEAM_T && team != TEAM_CT) return;

	                                                            
	if (!Instance.FindEntityByName(soundName)) {
		return;
	}

	GetAllPlayerControllersOfTeam(team).forEach((controller) => {
		                                                                                            
		                                                                                  
		if (controller.IsBot()) return;
		if (!controller.IsConnected()) return;

		Instance.EntFireAtName({
			name: soundName,
			input: "StartSoundOnSingleClient",
			value: controller.GetPlayerSlot(),
		});
	});
}

                                                                                              
      
                                                                                              

                                                                                      
const FOG_ENTITY_NAME = "fog";

                                                                                   
const FOG_PRESETS = {
	exterior: { color: "160 172 188", start:  100, end: 6000, maxOpacity: 0.70, falloff: 1.0 },
	interior: { color: "120 118 112", start:  100, end: 3000, maxOpacity: 0.50, falloff: 1.5 },
	tunnel:   { color:  "80  88  84", start:   50, end:  900, maxOpacity: 0.80, falloff: 3.0 },
	base:     { color: "150 160 175", start:  100, end: 6000, maxOpacity: 0.60, falloff: 1.0 },
	clear:    { maxOpacity: 0.0 },
};

const FOG_DEFAULT_PRESET = "exterior";

                                                                                     
const ROOM_FOG = {
	101: "interior",          
	102: "interior",             
	103: "interior",            
	104: "interior",             
	201: "tunnel",            
	202: "exterior",           
	203: "interior",              
	204: "exterior",          
	205: "exterior",                
	206: "tunnel",          
	207: "exterior",            
	208: "interior",         
	209: "interior",           
	210: "exterior",          
	211: "exterior",              
	212: "interior",         
	301: "base",                  
	401: "base",                 
	convoy: "exterior",                                     
};

                                                                             
const FOG_INPUTS = [
	["color",        "SetFogColor"],
	["start",        "SetFogStartDistance"],
	["end",          "SetFogEndDistance"],
	["maxOpacity",   "SetFogMaxOpacity"],
	["falloff",      "SetFogFalloffExponent"],
	["strength",     "SetFogStrength"],
	["startHeight",  "SetFogStartHeight"],
	["endHeight",    "SetFogEndHeight"],
	["verticalExp",  "SetFogVerticalExponent"],
];

function SetRoomFog(roomIndex) {
	const roomId = _roomIds[roomIndex];
	if (roomId === undefined) {
		return;
	}

	                                                                          
	if (!Instance.FindEntityByName(FOG_ENTITY_NAME)) {
		return;
	}

	const presetName = ROOM_FOG[roomId] ?? FOG_DEFAULT_PRESET;
	const preset = FOG_PRESETS[presetName];
	if (!preset) {
		return;
	}

	FOG_INPUTS.forEach(([field, input]) => {
		const value = preset[field];
		if (value === undefined) return;

		Instance.EntFireAtName({ name: FOG_ENTITY_NAME, input: input, value: value });
	});
}

                                                                                              
          
                                                                                              

                                                                                             
                                                                                              
                                                                                         
                                                                                                
                                                                                           
                                                                   
const ANTENNA_BASE_ENTITY_NAME = "ant.base.main";
const ANTENNA_BASE_RADAR_NAME = "ant.base.radar";
const ANTENNA_BASE_OBSRV_NAME = "ant.base.observable";
const ANTENNA_BASE_MARKER_PREFIX = "ant.base.";

                                                                                                 
                                                                                                 
                                                                                               
                                                                        
const ANTENNA_TOP_TALL_ENTITY_NAME = "ant.top.main";
const ANTENNA_TOP_SHORT_ENTITY_NAME = "ant.top.short";
const ANTENNA_TOP_MARKER_PREFIX = "ant.top.";

                                                                                                
                                                                           
const ANTENNA_SHORT_TOP_ROOM_IDS = [101, 102, 103, 301];

const ANTENNA_ROOT_TARGETS = [
	[ANTENNA_BASE_ENTITY_NAME, ANTENNA_BASE_MARKER_PREFIX],
	[ANTENNA_BASE_RADAR_NAME, ANTENNA_BASE_MARKER_PREFIX],
	[ANTENNA_BASE_OBSRV_NAME, ANTENNA_BASE_MARKER_PREFIX],
	[ANTENNA_TOP_TALL_ENTITY_NAME, ANTENNA_TOP_MARKER_PREFIX],
	[ANTENNA_TOP_SHORT_ENTITY_NAME, ANTENNA_TOP_MARKER_PREFIX],
];

function AntennaTopForRoom(roomId) {
	return ANTENNA_SHORT_TOP_ROOM_IDS.includes(Number(roomId))
		? ANTENNA_TOP_SHORT_ENTITY_NAME
		: ANTENNA_TOP_TALL_ENTITY_NAME;
}

                                                                                                 
                                                                            
var _antennaTopRootName = ANTENNA_TOP_TALL_ENTITY_NAME;

                                                                                             
                                                          
function GlowingAntennaRootNames() {
	return [ANTENNA_BASE_ENTITY_NAME, _antennaTopRootName];
}

                                                                                             
                                                                                             
                                                                                                 
                                                                                    
                                                                                            
                                         
const ANTENNA_LIGHT_ENTITY_PREFIX = "ant.side.light.";
const ANTENNA_LIGHT_ENTITY_SUFFIXES = ["a", "b"];

const ANTENNA_STYLE = "fast_strobe,on";

                                                                                               
                                                                                                 
                                                                                                
                                     
function ApplyAntennaLights(team) {
	const lightColor = ColorInputValue(TEAM_COLORS[team] ?? TEAM_COLORS[TEAM_NONE]);

	                                                                                 
	const activeRoomId = _roomIds[_currentRoomIndex];

	                                                                              
	Object.keys(ROOM_NAMES).forEach((roomId) => {
		                                                                                           
		                                                              
		const lit = roomId == activeRoomId;

		ANTENNA_LIGHT_ENTITY_SUFFIXES.forEach((suffix) => {
			const name = `${ANTENNA_LIGHT_ENTITY_PREFIX}${roomId}.${suffix}`;

			                                                                                         
			                               
			const entity = FindPrefabEntity(name);
			if (!entity) {
				return;
			}

			Instance.EntFireAtTarget({ target: entity, input: lit ? "Enable" : "Disable" });
			if (!lit) return;

			Instance.EntFireAtTarget({ target: entity, input: "SetColor", value: lightColor });
			Instance.EntFireAtTarget({ target: entity, input: "SetStyle", value: ANTENNA_STYLE });
		});
	});
}

                                                                                         
const ANTENNA_BUTTON_ENTITY_NAME = "ant.button";

                                                                                           
function MoveAntennaToRoom(roomId) {
	_antennaTopRootName = AntennaTopForRoom(roomId);

	ANTENNA_ROOT_TARGETS.forEach(([rootName, markerPrefix]) => {
		const root = FindPrefabEntity(rootName);
		if (!root) {
			return;
		}

		const markerName = `${markerPrefix}${roomId}`;
		const marker = FindPrefabEntity(markerName);
		if (!marker) {
			return;
		}

		                                                                             

		let pos = marker.GetAbsOrigin();
		if ( root instanceof CSRadarPoint ) {
			root.SetColor( GetActiveRoomTowerSpottingState( _roomStates[_currentRoomIndex] ) );
			pos.z += 16;
		}
		else if ( root instanceof CSObservablePoint ) {
			root.SetObservableModelEntity( FindPrefabEntity( ANTENNA_BASE_ENTITY_NAME ), 0 );
			root.SetObservableModelEntity( FindPrefabEntity(
				( _antennaTopRootName == ANTENNA_TOP_TALL_ENTITY_NAME )
				? ANTENNA_TOP_TALL_ENTITY_NAME
				: ANTENNA_TOP_SHORT_ENTITY_NAME
				), 1 );
			pos.z += 72;
		}
		root.Teleport({ position: pos, angles: marker.GetAbsAngles() });
	});

	                                                                                     
	SetAntennaTopEnabled(ANTENNA_TOP_TALL_ENTITY_NAME, _antennaTopRootName == ANTENNA_TOP_TALL_ENTITY_NAME);
	SetAntennaTopEnabled(ANTENNA_TOP_SHORT_ENTITY_NAME, _antennaTopRootName == ANTENNA_TOP_SHORT_ENTITY_NAME);
}

                                                                                                 
                                                                                        
                                                                                       
                                                                                         
function SetAntennaTopEnabled(rootName, enabled) {
	const root = FindPrefabEntity(rootName);
	if (!root) {
		return;
	}

	Instance.EntFireAtTarget({ target: root, input: enabled ? "Enable" : "Disable" });
	Instance.EntFireAtTarget({
		target: root,
		input: enabled ? "EnableCollision" : "DisableCollision",
	});
}

function DistanceSquared( a, b ) {
	const dx = a.x - b.x;
	const dy = a.y - b.y;
	const dz = a.z - b.z;
	return dx * dx + dy * dy + dz * dz;
}

                                                                      
var _forceDeciderNextRound = false;
Instance.RegisterCheatCommand( "rush_force_decider", () => {
	_forceDeciderNextRound = true;
} );

                                  
let _forceAntennaGlow = false;
Instance.RegisterCheatCommand( "move_antenna", () => {

	let cameraPosition = null;
	for ( const controller of Instance.GetAllPlayerControllers() ) {
		if ( controller.IsBot() ) continue;

		const pawn = controller.GetPlayerPawn();
		if ( pawn && pawn.IsValid() && pawn.IsAlive() )
		{
			cameraPosition = pawn.GetEyePosition();
			break;
		}

		const observerPawn = controller.GetObserverPawn();
		if ( observerPawn && observerPawn.IsValid() )
		{
			cameraPosition = observerPawn.GetEyePosition();
			break;
		}
	}

	if ( !cameraPosition ) 
		return;

	const markerPrefix = ANTENNA_BASE_MARKER_PREFIX;

	let closestId = -1;
	let closestDistSq = 0;

	for (const roomId of Object.keys(ROOM_NAMES))
	{
		const markerName = `${markerPrefix}${roomId}`;
		const marker = FindPrefabEntity( markerName );
		if ( !marker ) {
			continue;
		}

		const distSq = DistanceSquared( cameraPosition, marker.GetAbsOrigin() );
		if ( closestId < 0 || distSq < closestDistSq ) {
			closestId = roomId;
			closestDistSq = distSq;
		}
	}

	if ( closestId < 0 ) {
		return;
	}

	MoveAntennaToRoom( closestId );
	SetAntennaGlow( true );
	_forceAntennaGlow = true;
} );

                                                                                                 
                                                          
var _antennaGlowing = false;

                                                                                              
                                                                                       
function SetAntennaGlow(enabled) {
	const glow = enabled || _forceAntennaGlow;
	if (glow == _antennaGlowing)
		return;

	_antennaGlowing = glow;

	                                                                                          
	const team = _roomStates[_currentRoomIndex];
	const glowColor = TEAM_COLORS[team] ?? TEAM_COLORS[TEAM_NONE];

	                                                                              
	GlowingAntennaRootNames().forEach((rootName) => {
		const root = FindPrefabEntity(rootName);
		if (!root) {
			return;
		}

		                                                                                          
		                                                                  
		if (typeof root.Glow != "function" || typeof root.Unglow != "function")
		{
			return;
		}

		if (enabled) {
			                                                                                       
			                       
			root.Glow(glowColor);
		} else {
			root.Unglow();
		}
	});
}

                                                                                           
                                                                
function FindPrefabEntity(name) {
	const direct = Instance.FindEntityByName(name);
	if (direct) return direct;

	const wildcard = Instance.FindEntityByName(`*${name}`);
	return wildcard;
}

                                                                                              
         
                                                                                              

var _buttonOutputId = null;

                                                                                              
                                                                                              
                                                                                                
function ButtonOnRoundStart() {
	                                                                                           
	DisconnectButtonOutput();

	const buttonEnt = FindPrefabEntity(ANTENNA_BUTTON_ENTITY_NAME);
	if (!buttonEnt) {
		return;
	}

	const outputId = Instance.ConnectOutput(buttonEnt, "OnPressed", OnButtonPressed);
	_buttonOutputId = outputId === undefined ? null : outputId;

	                                                                     

	PlayBeaconAtButton(BEACON_IDLE_ENTITY_NAME, buttonEnt);

	                                                                                            
	PointBeaconAtButton(BEACON_TIMER_BEEP_ENTITY_NAME, buttonEnt);
	PointBeaconAtButton(BEACON_TIMER_END_ENTITY_NAME, buttonEnt);
}

                                                                                              
                                                                  
function PlayBeaconAtButton(beaconName, buttonEnt) {
	if (!PointBeaconAtButton(beaconName, buttonEnt)) return;

	                                                                           
	Instance.EntFireAtName({ name: beaconName, input: "StartSound" });
}

                                                                                             
function PointBeaconAtButton(beaconName, buttonEnt) {
	if (!Instance.FindEntityByName(beaconName)) {
		return false;
	}

	                                                                                              
	Instance.EntFireAtName({
		name: beaconName,
		input: "SetSourceEntity",
		value: buttonEnt.GetEntityName(),
	});

	return true;
}

                                                                                            
                  
function TimerBeepThink() {
	const now = Instance.GetGameTime();

	                                                                                              
	                                                     
	if (now < _timerBeepNextTime - TIMER_BEEP_TOLERANCE_SECONDS) return;

	Instance.EntFireAtName({ name: BEACON_TIMER_BEEP_ENTITY_NAME, input: "StartSound" });

	                                                                                   
	const interval = TimerBeepInterval(_timerBeepCount);

	                                                                                             
	                                                                                             
	                                                                                              
	                                                                     
	const dueTime =
		_timerBeepNextTime > 0 && now - _timerBeepNextTime < interval
			? _timerBeepNextTime
			: now;

	_timerBeepNextTime = dueTime + interval;
	_timerBeepCount++;
}

                                                                                                 
                                                                                   
function ResetTimerBeepState() {
	_timerBeepNextTime = 0;
	_timerBeepCount = 0;
	_timerEndPlayed = false;
}

                                                                                             
                                                                                            
function TimerBeepInterval(beepIndex) {
	let n = beepIndex;

	for (const stage of TIMER_BEEP_STAGES) {
		if (stage.beeps === undefined || n < stage.beeps) return stage.interval;

		n -= stage.beeps;
	}

	                                                                                            
	return TIMER_BEEP_STAGES[TIMER_BEEP_STAGES.length - 1].interval;
}

                                                                                             
                                       
function PlayTimerEndSound() {
	if (_timerEndPlayed) return;
	_timerEndPlayed = true;

	Instance.EntFireAtName({ name: BEACON_TIMER_BEEP_ENTITY_NAME, input: "StopSound" });
	StartSoundEntity(BEACON_TIMER_END_ENTITY_NAME);
}

                                                                                               
                                                                  
function IsRoundDecided() {
	return _roundOver || _gameOver || Instance.GetRoundRemainingTime() <= 0;
}

function GetActiveRoomTowerSpottingState( team ) {
	switch ( team )
	{
		default: return CSRadarColor.GRAY;		                
		case TEAM_CT: return CSRadarColor.CT;	                      
		case TEAM_T: return CSRadarColor.T;		                     
	}
}

function OnButtonPressed(inputData) {
	var buttonActivator = inputData.activator;
	if (!(buttonActivator instanceof CSPlayerPawn)) return;

	const activatorTeam = buttonActivator.GetTeamNumber();
	const roundOver = IsRoundDecided();

	                                                                                      
	                                                                                            
	const beaconName =
		( ( _antennaTeam == activatorTeam )
		|| ( roundOver && !END_ROUND_ON_TEAM_ELIMINATION ) )                                                              
			? BEACON_ERROR_ENTITY_NAME
			: BEACON_PRESS_ENTITY_NAME;

	
	                                                                                              
	                                           
	if (inputData.caller) PlayBeaconAtButton(beaconName, inputData.caller);

	if (roundOver) {
		if ( !END_ROUND_ON_TEAM_ELIMINATION ) return;                                                       

		                                                                                                 
		                                                                                  
		SetRoomLights(_currentRoomIndex, activatorTeam);
		return;
	}

	if (Instance.IsWarmupPeriod()) {
		SetRoomLights(_currentRoomIndex, activatorTeam);
		UIUpdateRoomControl(activatorTeam);
	} else {
		                                                                                     
		SetRoomControl(_currentRoomIndex, activatorTeam, true);

		                                                                                                 
		CheckEliminationRoundEnd();
	}
}

                                                                                             
                                                  
function ButtonOnRoundEnd() {
	Instance.EntFireAtName({ name: BEACON_IDLE_ENTITY_NAME, input: "StopSound" });

	                                                              
	Instance.EntFireAtName({ name: BEACON_TIMER_BEEP_ENTITY_NAME, input: "StopSound" });
}

                                                                                          
                                                                     
function DisconnectButtonOutput() {
	                                                                        
	if (_buttonOutputId === null) return;

	Instance.DisconnectOutput(_buttonOutputId);
	_buttonOutputId = null;
}

                                                                                              
     
                                                                                              
let _uiActive = false;
                                                                                                 
let _uiMinimized = false;
let _countdownActive = false;
const UI_DURATION_SECONDS = 5;
const UI_ENTITY_NAME = 'rush_ui';

                                                                                                
                                                                                        
const ROOM_PANEL_CLASSES = Object.keys(ROOM_NAMES).map((id) => `room_${id}`);

                                                                                              
                                                                                           
function GetUIEntity()
{
	_uiEntity = Instance.FindEntityByName(UI_ENTITY_NAME);
	return _uiEntity;
}

function UIClear()
{
	if (!GetUIEntity())
		return;

	_uiEntity.SetHasClass('rush_matchstate', 'hidden', true);


	for (const controller of Instance.GetAllPlayerControllers()) 
	{
		_uiEntity.SetDialogVariableStringForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'attack_defend' );
		_uiEntity.SetDialogVariableStringForPlayer(controller.GetPlayerSlot(), 'rush_countdown', 'countdown_message' );
	}
	_uiEntity.SetDialogVariableString('rush_attack_defend', 'attack_defend', '');
	_uiEntity.SetDialogVariableString('rush_countdown', 'countdown_message', '');
}

async function UIOnRoundStart()
{
	_countdownActive = false;

	while (!Instance.IsFreezePeriod() || Instance.IsTeamIntroPeriod())
		await Instance.Delay(0);

	UIShowProgression();
	await Instance.Delay(UI_DURATION_SECONDS);

	UIMinimizeProgression();
	while (Instance.IsFreezePeriod())
		await Instance.Delay(0);

	UIHideProgression();
}

async function UIShowProgression()
{
	if (!GetUIEntity())
		return;

	if (_uiActive)
		return;

	_uiEntity.SetHasClass('rush_matchstate', 'minimized', false);
	_uiEntity.SetHasClass('rush_matchstate', 'hidden', false);
 
	for (const controller of Instance.GetAllPlayerControllers()) 
	{
		_uiEntity.SetHasClassForPlayer(
			controller.GetPlayerSlot(),
			'rush_matchstate',
			'reverse-direction',
			controller.GetTeamNumber() == TEAM_CT
		);
	};

	                                                                                              
	                              
	if (_lastRoundWinner == TEAM_T || _lastRoundWinner == TEAM_CT)
	{
		PlaySoundForTeam(SOUND_SLIDE_IN_FORWARD, _lastRoundWinner);
		PlaySoundForTeam(SOUND_SLIDE_IN_BACKWARD, OtherTeam(_lastRoundWinner));
	}
	else
	{
		                                                      
		                                                                                                 
		PlaySoundForTeam(SOUND_SLIDE_IN_BACKWARD, TEAM_T);
		PlaySoundForTeam(SOUND_SLIDE_IN_BACKWARD, TEAM_CT);
	}

	                      
	for (let i = 0; i < ROOM_COUNT; ++i)
	{
		const roomId = _roomIds[i];
		const roomName = ROOM_NAMES[roomId];
		const roomPanelId = `rush_room_${i}`;

		_uiEntity.SetDialogVariableString(roomPanelId, 'room_name', roomName);
		_uiEntity.SetHasClass(roomPanelId, 'ct', _roomStates[i] == TEAM_CT);
		_uiEntity.SetHasClass(roomPanelId, 't',  _roomStates[i] == TEAM_T);
		_uiEntity.SetHasClass(roomPanelId, 'current', _currentRoomIndex == i);

		                                                              
		const roomClass = `room_${roomId}`;
		ROOM_PANEL_CLASSES.forEach((name) => {
			if (name != roomClass) _uiEntity.SetHasClass(roomPanelId, name, false);
		});
		_uiEntity.SetHasClass(roomPanelId, roomClass, true );

		_uiEntity.SetHasClass( roomPanelId, 'arrow-ct', ( _currentRoomIndex == i )
			&& ( Instance.GetRoundsPlayed() > 0 )
			&& ( _roomStates[i] == TEAM_T ) );
		_uiEntity.SetHasClass( roomPanelId, 'arrow-t', ( _currentRoomIndex == i )
			&& ( Instance.GetRoundsPlayed() > 0 )
			&& ( _roomStates[i] == TEAM_CT ) );
	}

	                                                            
	GetAllPlayerControllersOfTeam(TEAM_T).forEach((controller) => {
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_matchstate', 'view-t', true);
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_matchstate', 'view-ct', false);
	});

	GetAllPlayerControllersOfTeam(TEAM_CT).forEach((controller) => {
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_matchstate', 'view-ct', true);
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_matchstate', 'view-t', false);
	});

	_uiActive = true;
	_uiMinimized = false;
}

function UIMinimizeProgression()
{
	if (!GetUIEntity())
		return;

	if (!_uiActive)
		return;

	if (_uiMinimized)
		return;

	_uiEntity.SetHasClass('rush_matchstate', 'minimized', true);
	StartSoundEntity(SOUND_SLIDE_OUT);
	_uiMinimized = true;
}

function UIHideProgression()
{
	if (!GetUIEntity())
		return;

	if (!_uiActive)
		return;

	_uiEntity.SetHasClass('rush_matchstate', 'hidden', true);
	StartSoundEntity(SOUND_SLIDE_OUT);
	_uiActive = false;
}

function UIOnRoundEnd()
{
	if (_uiEntity)
	{
		_uiEntity.SetHasClass('rush_countdown', 'visible', false);
		_countdownActive = false;
	}
}

function UIThink()
{
	if (_uiEntity && IsInActiveRound() && _teamEliminated)
	{
		_uiEntity.SetHasClass('rush_countdown', 'visible', true);

		const timeLeft = Math.round(Instance.GetRoundRemainingTime());
		_uiEntity.SetDialogVariableString('rush_countdown', 'countdown_time', String(timeLeft));

		const spectatorString = _roomStates[_currentRoomIndex] == TEAM_T ? "#rush_countdown_capture_ct" : "#rush_countdown_capture_t";

		for (const controller of Instance.GetAllPlayerControllers()) 
		{
			const teamNum = controller.GetTeamNumber();
			let countdownString = spectatorString;
			if (teamNum == _roomStates[_currentRoomIndex])
				countdownString = "#rush_countdown_capture_enemy";
			else if (teamNum == OtherTeam(_roomStates[_currentRoomIndex]))
				countdownString = "#rush_countdown_capture";

			_uiEntity.SetDialogVariableStringForPlayer(controller.GetPlayerSlot(), 'rush_countdown', 'countdown_message', countdownString); 
		};

		_countdownActive = true;
	}
}

function UIUpdateAntennaOwningTeam( team )
{
	ANTENNA_ROOT_TARGETS.forEach(([rootName]) => {
		const root = FindPrefabEntity(rootName);
		if ( root && ( root instanceof CSRadarPoint ) )
			root.SetColor( GetActiveRoomTowerSpottingState( team ) );
	});
}

function UIUpdateRoomControl(team)
{
	UIUpdateAntennaOwningTeam( team );

	if (!GetUIEntity())
		return;


	for (const controller of Instance.GetAllPlayerControllers())
	{
		UISetRoomControlUIForPlayer(controller, team);
	};
}

function UISetRoomControlUIForPlayer(controller, teamInControl)
{
	if (!controller)
		return;

	const teamNum = controller.GetTeamNumber();

	const attackText = "#rush_hint_enemy_tower";
	const defendText = "#rush_hint_your_tower";
	const spectateText = teamInControl == TEAM_CT ? "#rush_hint_ct_tower" : "#rush_hint_t_tower";

	                                                                   
	_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'ct',	teamInControl == TEAM_CT);
	_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 't',	teamInControl == TEAM_T);

	if (teamNum == TEAM_SPECTATOR || teamNum == TEAM_NONE)
	{
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'attack', 	false);
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'defend', 	false);
		_uiEntity.SetDialogVariableStringForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'attack_defend', spectateText);
	}
	else
	{
		const hasControl = teamNum == teamInControl;

		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'attack', !hasControl);
		_uiEntity.SetHasClassForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'defend', hasControl);

		const text = hasControl ? defendText : attackText;
		_uiEntity.SetDialogVariableStringForPlayer(controller.GetPlayerSlot(), 'rush_attack_defend', 'attack_defend', text);
	}
}

Instance.OnPlayerTeamChanged(({ player, oldTeam }) =>
{
	if (!player)
		return;

	UISetRoomControlUIForPlayer(player.GetPlayerController(), _roomStates[_currentRoomIndex]);
});
