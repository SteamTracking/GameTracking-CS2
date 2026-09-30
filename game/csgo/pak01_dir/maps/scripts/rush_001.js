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

// -------------------------------------------------------------------------------------------
// Rush 001- linear tug-of-war. Seven rooms; T push toward index 6, CT toward index 0.
// -------------------------------------------------------------------------------------------

var _roomIds = [];
var _currentRoomIndex = -1;
var _roomStates = [];
var _roundOver = false;
var _tenSecondWarningPlayed = false;
// Game time the next terminal beep is due, how many have gone out this countdown (the tempo is
// counted off that), and whether the clock-expiry sound has played
var _timerBeepNextTime = 0;
var _timerBeepCount = 0;
var _timerEndPlayed = false;
// Gates round activity only; layout reseeding watches _lastRoundsPlayed instead.
var _gameOver = false;

// Round count at the last round start. The engine zeroes it on a new match, so a drop means
// the match restarted under us.
var _lastRoundsPlayed = 0;

// Round wins this match; the script API exposes no team score, so count them here.
var _teamWins = {};

var _teamEliminated = false;
var _legitimateKillsPerTeamThisRound = {}; 

var ROUNDS_TO_WIN = 8; // must match (mp_maxrounds + 1) / 2, used to select the convoy map

const END_ROUND_ON_TEAM_ELIMINATION = false;

const THINK_FREQUENCY_SECONDS = 0.1;

// point_soundevent in prefabs/rush_001/rush_playersetup.vmap, fired once per round
const TEN_SECOND_WARNING_ENTITY = "ten.second.warning";
const TEN_SECOND_WARNING_SECONDS = 10;


// minimum round time to set once a team is eliminated
const COUNTDOWN_TIME_SECONDS = 7;
const COUNTDOWN_TIME_END_ROOMS_SECONDS = 14;

// point_soundevents in prefabs/rush_001/rush_playersetup.vmap, played per team
const SOUND_CONTROL_GAINED = "poss.gained";
const SOUND_CONTROL_LOST = "poss.lost";

// One shared set for the whole map, repointed at the active room's button each round.
const BEACON_IDLE_ENTITY_NAME = "beacon.idle";
const BEACON_PRESS_ENTITY_NAME = "beacon.press";
const BEACON_ERROR_ENTITY_NAME = "beacon.error";

// Terminal countdown, also repointed at the active room's button. The beep is restarted once
// per beep, stepping up a tempo at a time as the clock runs out.
const BEACON_TIMER_BEEP_ENTITY_NAME = "beacon.timer.beep";
const BEACON_TIMER_END_ENTITY_NAME = "beacon.timer.end";

const MATCH_POINT_ENTITY = "match.point";

// Tempos, slowest first. Counted in beeps rather than seconds, so a tempo change lands on a
// beat instead of wherever the clock happens to cross a threshold. The counted stages come to
// 8s; the last one is uncounted and eats whatever is left of the window. The two fastest run
// finer than THINK_FREQUENCY_SECONDS, so the think pulls itself in to keep them honest.
const TIMER_BEEP_STAGES = [
	{ beeps: 4, interval: 1.0 },
	{ beeps: 4, interval: 0.5 },
	{ beeps: 8, interval: 0.25 },
	{ interval: 0.125 },
];

const TIMER_BEEP_SECONDS = 10;

// Half a tick at 64Hz. Thinks only run on tick boundaries, so a beat counts as due once we are
// within this of it rather than strictly past it.
const TIMER_BEEP_TOLERANCE_SECONDS = 1 / 128;

const WIN_MONEY = 2500;

// Room progression panel. The slide-in is per team: the same move reads forward for one side,
// backward for the other.
const SOUND_SLIDE_IN_FORWARD = "ui.slidein.forward";
const SOUND_SLIDE_IN_BACKWARD = "ui.slidein.backward";
const SOUND_SLIDE_OUT = "ui.slideout";

const TEAM_NONE = 0;
const TEAM_SPECTATOR = 1;
const TEAM_T = 2;
const TEAM_CT = 3;

// Last round's winner, or TEAM_NONE if the frontline didn't move. Only the UI slide-in reads it.
// Note: a const is in its temporal dead zone until its line, so this has to follow the TEAM_ ids.
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

// Candidates per room index. _roomIds is indexed by position, so this must stay dense and in order.
const ROOM_IDS = [
	[401], // T base
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[101, 102, 103, 104], // Start
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
	[301], // CT base
];

const ROOM_COUNT = ROOM_IDS.length;

// The decider room is used when the score is 9-9. It isn't eligible for a random roll, so it's kept out of ROOM_IDS.
const DECIDER_ROOM_ID = "convoy";

// Round length per room. The base rooms are a last stand, so they get longer.
const ROUND_SECONDS_BASE_ROOM = 60;
const ROUND_SECONDS_MID_ROOM = 40;

var _uiEntity = null;

Instance.OnActivate(() =>
{
	// Instance.ServerCommand("exec gamemode_rush.cfg");

	ResetGameState();
});

function ResetGameState() {
	_gameOver = false;
	_teamWins = { [TEAM_T]: 0, [TEAM_CT]: 0 };

	UIClear();

	// a fresh match has progressed from nowhere, so its first slide-in gets the no-progress cue
	_lastRoundWinner = TEAM_NONE;

	RandomizeRooms();

	// clear first, or SetRoomControl's early-out leaves the previous match's state showing
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

	// RestartRound latches mp_roundtime (cs_gamerules.cpp:8571) before it fires the round_start
	// this hooks (:9105), so setting it from there lands a round late. Set it a round ahead.
	Instance.ServerCommand(`mp_roundtime ${RoundTimeMinutesForRoom(roomIndex)}`);
}

// the engine truncates (int)( minutes * 60 ), so bias by half a second against float error
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
		// bail per pair, so a map-side typo doesn't take the round transition down with it
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
	// anything failing below must not stop the round timer, so kick it off first
	Instance.SetNextThink(Instance.GetGameTime() + THINK_FREQUENCY_SECONDS);

	_roundOver = false;
	_tenSecondWarningPlayed = false;
	ResetTimerBeepState();
	_countdownActive = false;
	_teamEliminated = false;
	_legitimateKillsPerTeamThisRound = {};

	// The engine restarts matches rather than reloading the map, so this is the only thing that
	// reseeds the layout and the tallies. Every reset zeroes the round counter
	// (cs_gamerules.cpp:8567), warmup ending and mp_restartgame and the match-end restart
	// included, and stale _teamWins ends matches early, so key on the counter going backwards
	// rather than on _gameOver.
	const roundsPlayed = Instance.GetRoundsPlayed();
	if (roundsPlayed < _lastRoundsPlayed) {
		ResetGameState();
	}
	_lastRoundsPlayed = roundsPlayed;

	// TEAM_NONE in warmup: nobody is on team 0, so nobody reads as holding the room. Guarded like
	// UIOnRoundStart below, same player list and the same failure.
	UIUpdateRoomControl( _roomStates[_currentRoomIndex] );

	if (!Instance.IsWarmupPeriod()) {
		const roundNum = roundsPlayed + 1;
		Instance.ServerCommand(
			`mp_default_team_winner_no_objective ${_roomStates[_currentRoomIndex]}`,
		);

		UIOnRoundStart();

		// play final round sounds on the end rooms
		if (IsFinalRoom(_currentRoomIndex) &&
			_teamWins[TEAM_CT] < ROUNDS_TO_WIN - 1 &&
			_teamWins[TEAM_T] < ROUNDS_TO_WIN - 1)
		{
			StartSoundEntity(MATCH_POINT_ENTITY);
		}

		Instance.ServerCommand("mp_ignore_round_win_conditions 1");

		// mp_roundtime is already locked in for this round; GoToRoom sets it a round ahead
	} else {
		Instance.ServerCommand("mp_ignore_round_win_conditions 0");
	}

	// the reset above can pick a new layout, so run this after it and we always see the room we
	// will actually play
	SetRoomFog(_currentRoomIndex);
	MoveAntennaToRoom(_roomIds[_currentRoomIndex]);
	SetRoomLights( _currentRoomIndex, _roomStates[_currentRoomIndex] );

	// after the move. This runs inside freezetime; the think loop switches the glow off.
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

// A wipe takes the round outright; possession still moves, from OnRoundEnd's SetRoomControl.
// A mutual wipe is settled by the room: whoever held it, or a draw if neither did.
function CheckEliminationRoundEnd() {
	// kill events keep firing through the post-round, when a wipe can no longer matter
	if (IsRoundDecided()) return;

	const tWiped = IsTeamEliminated(TEAM_T);
	const ctWiped = IsTeamEliminated(TEAM_CT);

	if (!tWiped && !ctWiped) return;

	// decided by the room, not by whichever death arrived last (one grenade can wipe both teams)
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

	// Warmup rounds end constantly, and as draws, which would overwrite the seeded room control.
	if (Instance.IsWarmupPeriod()) return;

	// spectators can't win
	if (args.winningTeam == TEAM_SPECTATOR)
		args.winningTeam = TEAM_NONE;

	_roundOver = true;

	// a draw awards nothing, matching FireWinCondition (mapinfo.cpp:140)
	if (args.winningTeam == TEAM_T || args.winningTeam == TEAM_CT) {
		++_teamWins[args.winningTeam];
	}

	// Repainting now would read as the room being taken with nobody near the button, so possession
	// moves and the antenna's color stays put. The next OnRoundStart colors it. A real press in
	// the frames before this handler runs still gets to recolor it.
	SetRoomControl(_currentRoomIndex, args.winningTeam, /* playSound */ false, /* updateLights */ false);

	if (args.winningTeam != TEAM_NONE) {
		Instance.AddTeamMoney( args.winningTeam, IsTeamEliminated( OtherTeam( args.winningTeam ) )
			? ( ( args.winningTeam == TEAM_CT )
					? CSTeamMoneyReason.ELIMINATION_HOSTAGE_MAP_CT
					: CSTeamMoneyReason.ELIMINATION_HOSTAGE_MAP_T )
			: CSTeamMoneyReason.WIN_BY_TIME_RUNNING_OUT_HOSTAGE, WIN_MONEY );
		// CSTeamMoneyReason.LOSER_BONUS does not have to be added,  loser bonus is managed automatically by the game rules
		// ... and there can never be a draw in the real match
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

	// this is the line that decides it, so record it here; UIOnRoundStart reads it next round
	_lastRoundWinner = args.winningTeam;

	// mp_roundtime for the next room comes from the GoToRoom below; EndMatch handles the rest

	if (nextRoomIndex < T_FINAL_ROOM || nextRoomIndex > CT_FINAL_ROOM)
	{
		// a team broke through the far base, so they win outright
		EndMatch(args.winningTeam);
	}
	else
	{
		MaybeSwapInDeciderRoom(nextRoomIndex);
		GoToRoom(nextRoomIndex);
	}
});

// Both teams one win short: the round about to be played takes the match either way, so it gets
// the decider room. Repoints the frontline slot rather than adding an index. Always ends the game.
function MaybeSwapInDeciderRoom(roomIndex) {

	const forced = _forceDeciderNextRound;
	_forceDeciderNextRound = false;

	if (!forced) {
		if (_teamWins[TEAM_T] != ROUNDS_TO_WIN - 1) return;
		if (_teamWins[TEAM_CT] != ROUNDS_TO_WIN - 1) return;
	}

	_roomIds[roomIndex] = DECIDER_ROOM_ID;
}

// Rounds ran out with both bases standing. The match is a race, so whoever got closer takes
// it; ground held only breaks a level score, and level is a genuine draw.
function WinnerOnRoundsExhausted(frontlineRoomIndex) {
	if (_teamWins[TEAM_T] != _teamWins[TEAM_CT]) {
		return _teamWins[TEAM_T] > _teamWins[TEAM_CT] ? TEAM_T : TEAM_CT;
	}

	// T advance to the high indices and CT to the low ones, so the side of START_ROOM says who pushed
	if (frontlineRoomIndex > START_ROOM) return TEAM_T;
	if (frontlineRoomIndex < START_ROOM) return TEAM_CT;

	return TEAM_NONE;
}

function EndMatch(winningTeam) {
	_gameOver = true;

	// ResetGameState runs from OnRoundStart, after m_iRoundTime is latched, so set it here instead.
	Instance.ServerCommand(`mp_roundtime ${RoundTimeMinutesForRoom(START_ROOM)}`);
	Instance.ServerCommand(`mp_maxrounds ${Instance.GetRoundsPlayed()}`);
}

// Fires a sound entity for everyone.
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

		// > 0 so a round expiring this tick does not also fire the warning on its way out
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

	// round has gone live, drop the glow. No round_freeze_end callback, so watch the edge.
	if (_antennaGlowing && !Instance.IsFreezePeriod()) {
		SetAntennaGlow(false);
	}

	UIThink();

	// The fastest beep tempos are shorter than the think interval, so a due beep pulls the next
	// think in; otherwise 0.25s and 0.125s would land on 0.3s and 0.2s. Only ever moves the think
	// forward, and only while a beep is actually pending.
	let nextThink = Instance.GetGameTime() + THINK_FREQUENCY_SECONDS;
	if (_timerBeepNextTime > 0) {
		// aimed a hair before the beat, so the think that fires the beep cannot land past it
		const beepThink = _timerBeepNextTime - TIMER_BEEP_TOLERANCE_SECONDS;
		if (beepThink > Instance.GetGameTime() && beepThink < nextThink) nextThink = beepThink;
	}

	Instance.SetNextThink(nextThink);
});

// OnRoundEnd needs the antenna's color to hold still while the room changes hands, so
// updateLights splits the possession change from the look of it. See the call there.
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

// EntFire wants a string and Glow wants a ColorArg object, so hold the object and stringify.
// None of these can be pure black: (0,0,0) reads as no override at all (glowproperty.cpp:130).
const TEAM_COLORS = {
	[TEAM_NONE]: { r: 255, g: 240, b: 200 },
	[TEAM_T]: { r: 255, g: 100, b: 0 },
	[TEAM_CT]: { r: 0, g: 100, b: 255 },
};

// the "R G B" string an entity input expects; SetColor and Color don't take objects
function ColorInputValue(color) {
	return `${color.r} ${color.g} ${color.b}`;
}

// Material group indices for the Skin input (basemodelentity.cpp:4000), i.e. positions in the
// vmdl's MaterialGroupList. Note T before CT, the reverse of the team numbering.
const TEAM_ANTENNA_SKINS = {
	[TEAM_NONE]: 0, // Team_None
	[TEAM_T]: 1, // Team_T
	[TEAM_CT]: 2, // Team_CT
};

// OnRoundEnd moves possession without repainting, so _roomStates isn't what the antenna is
// showing. This is, and anything answering a press goes by it.
var _antennaTeam = TEAM_NONE;

// Colors the one antenna standing in the active room. See MoveAntennaToRoom.
function SetRoomLights(roomIndex, team) {
	// ResetGameState seeds all seven states before GoToRoom sets an index, so calls for rooms
	// other than the active one are the common case. One antenna can only show one owner.
	if (roomIndex != _currentRoomIndex) return;

	const teamColor = TEAM_COLORS[team];
	const antennaSkin = TEAM_ANTENNA_SKINS[team];
	if (teamColor === undefined || antennaSkin === undefined) {
		return;
	}

	const lightColor = ColorInputValue(teamColor);

	ApplyAntennaLights(team);

	// The skins live on the entities the teleport moves; a missing root already warns there.
	// Skinning the switched-off top as well costs nothing, and OnRoundStart doesn't run this
	// after MoveAntennaToRoom, so it's worth not depending on the order.
	ANTENNA_ROOT_TARGETS.forEach(([rootName]) => {
		const root = FindPrefabEntity(rootName);
		if (!root) return;

		Instance.EntFireAtTarget({ target: root, input: "Skin", value: antennaSkin });
	});

	// the flags are the one piece still copied per room, so the leading-* match tints all of them
	Instance.EntFireAtName({ name: "*flag", input: "Color", value: lightColor });

	// past both early-outs, so this is what the antenna was actually asked to show
	_antennaTeam = team;

	// tell any live smoke grenade clouds to update their baked lighting
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

	// last team standing takes the round, however the victim died
	CheckEliminationRoundEnd();

	// check whether we should start the countdown 
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

	// an unpopulated team is not eliminated, or every round ends the moment it starts in testing
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

// StartSoundOnSingleClient takes a slot (soundevent.cpp:294), so this is one fire per player
function PlaySoundForTeam(soundName, team) {
	// TEAM_NONE would fan the possession sound out to unassigned players
	if (team != TEAM_T && team != TEAM_CT) return;

	// warn: a fire at a name that matches nothing just vanishes
	if (!Instance.FindEntityByName(soundName)) {
		return;
	}

	GetAllPlayerControllersOfTeam(team).forEach((controller) => {
		// With stopOnNew, a dead fire mid-list silences the teammate before it, so this is not just
		// an optimization. Bots have no client and a disconnected slot has no controller.
		if (controller.IsBot()) return;
		if (!controller.IsConnected()) return;

		Instance.EntFireAtName({
			name: soundName,
			input: "StartSoundOnSingleClient",
			value: controller.GetPlayerSlot(),
		});
	});
}

// -------------------------------------------------------------------------------------------
// Fog
// -------------------------------------------------------------------------------------------

// The env_gradient_fog in rush_playersetup.vmap. Needs this targetname set in Hammer.
const FOG_ENTITY_NAME = "fog";

// Named looks. Omit a field to leave that parameter as the entity spawned with it.
const FOG_PRESETS = {
	exterior: { color: "160 172 188", start:  100, end: 6000, maxOpacity: 0.70, falloff: 1.0 },
	interior: { color: "120 118 112", start:  100, end: 3000, maxOpacity: 0.50, falloff: 1.5 },
	tunnel:   { color:  "80  88  84", start:   50, end:  900, maxOpacity: 0.80, falloff: 3.0 },
	base:     { color: "150 160 175", start:  100, end: 6000, maxOpacity: 0.60, falloff: 1.0 },
	clear:    { maxOpacity: 0.0 },
};

const FOG_DEFAULT_PRESET = "exterior";

// roomId -> preset name. Rooms absent from this map fall back to FOG_DEFAULT_PRESET.
const ROOM_FOG = {
	101: "interior",  // Spire
	102: "interior",  // Wallbang
	103: "interior",  // Big Box
	104: "interior",  // Madhouse
	201: "tunnel",    // Sewer
	202: "exterior",  // Dogleg
	203: "interior",  // Trainyard
	204: "exterior",  // Crane
	205: "exterior",  // Block Party
	206: "tunnel",  // Hydra
	207: "exterior",  // Complex
	208: "interior",  // Lore
	209: "interior",  // U-Turn
	210: "exterior",  // Steel
	211: "exterior",  // Container
	212: "interior",  // Drop
	301: "base",      // CT Castle
	401: "base",      // T Castle
	convoy: "exterior", // Convoy: the rare 9-9 decider room
};

// Preset field -> env_gradient_fog input. Order is the order they get fired.
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

	// an EntFireAtName nothing matches is silently dropped, so check up front
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

// -------------------------------------------------------------------------------------------
// Antenna
// -------------------------------------------------------------------------------------------

// One shared antenna assembly in rush_playersetup.vmap, teleported into the active room each
// round; the ant.base.<room id> / ant.top.<room id> entities in the room prefabs are markers,
// not antennas. Only the roots move; the button and lights are parented to them and come
// along (BuildTeleportList_r, baseentity_shared.cpp:697). Pairs are [root, marker prefix], base
// first so a top parented to it is corrected by its own teleport. The markers are read for
// their placed transform only; nothing fires their Teleport input.
const ANTENNA_BASE_ENTITY_NAME = "ant.base.main";
const ANTENNA_BASE_RADAR_NAME = "ant.base.radar";
const ANTENNA_BASE_OBSRV_NAME = "ant.base.observable";
const ANTENNA_BASE_MARKER_PREFIX = "ant.base.";

// Two interchangeable tops, sharing the one ant.top.<room id> marker per room: rooms too low for
// the full-height mast stand the short model up instead. Both are always teleported, and the one
// not in use is switched off where it stands rather than parked somewhere: the side lights are
// parented to a top, so leaving one behind would leave them behind too.
const ANTENNA_TOP_TALL_ENTITY_NAME = "ant.top.main";
const ANTENNA_TOP_SHORT_ENTITY_NAME = "ant.top.short";
const ANTENNA_TOP_MARKER_PREFIX = "ant.top.";

// Room ids that get the short top. These are numbers and Number("convoy") is NaN, which matches
// nothing here, so a non-numeric id like the decider's takes the tall one.
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

// Which top is currently standing. The move_antenna cheat can stand one up off-index, so this is
// recorded by MoveAntennaToRoom rather than derived from _currentRoomIndex.
var _antennaTopRootName = ANTENNA_TOP_TALL_ENTITY_NAME;

// The base and whichever top is up. The other top is nodraw, and whether a nodraw prop still
// reaches the client's glow pass is not worth relying on.
function GlowingAntennaRootNames() {
	return [ANTENNA_BASE_ENTITY_NAME, _antennaTopRootName];
}

// The light_barn side lights that show the owning team's color. Two per room, living in that
// room's own prefab as ant.side.light.<room id>.a and .b, so each pair is placed against the
// antenna marker and mast height of the room it belongs to. Names are resolved one at a time and
// a second light sharing a name would never be reached, hence the per-light suffix.
// SetColor, SetStyle, Enable and Disable are all light_barn inputs (light_barn.cpp:133); an
// input a class lacks is a silent no-op.
const ANTENNA_LIGHT_ENTITY_PREFIX = "ant.side.light.";
const ANTENNA_LIGHT_ENTITY_SUFFIXES = ["a", "b"];

const ANTENNA_STYLE = "fast_strobe,on";

// Lights the active room's side lights in the possessing team's color and switches every other
// room's off, so the eighteen rooms nobody is playing are not each burning dynamic lights. Every
// room owns its own lights now and which top is standing doesn't come into it, so this keys off
// the room rather than off the mast.
function ApplyAntennaLights(team) {
	const lightColor = ColorInputValue(TEAM_COLORS[team] ?? TEAM_COLORS[TEAM_NONE]);

	// undefined before GoToRoom sets an index, which leaves every light switched off
	const activeRoomId = _roomIds[_currentRoomIndex];

	// ROOM_NAMES is the one place every room id is listed, the decider's included
	Object.keys(ROOM_NAMES).forEach((roomId) => {
		// loose compare on purpose: Object.keys hands back strings, and _roomIds holds numbers for
		// every room except the decider, which is the string "convoy"
		const lit = roomId == activeRoomId;

		ANTENNA_LIGHT_ENTITY_SUFFIXES.forEach((suffix) => {
			const name = `${ANTENNA_LIGHT_ENTITY_PREFIX}${roomId}.${suffix}`;

			// A bare name may not reach into a prefab, and EntFireAtName at nothing says nothing, so
			// fire at the resolved entity.
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

// The func_button on the shared assembly, parented to ant.base.main so it moves with it.
const ANTENNA_BUTTON_ENTITY_NAME = "ant.button";

// A root whose marker is missing holds its last position, so the failure shows up in game.
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

		// object form; the positional overload is deprecated (point_script.d.ts:632)

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

	// after the teleports, so the top that is going away is already out of the last room
	SetAntennaTopEnabled(ANTENNA_TOP_TALL_ENTITY_NAME, _antennaTopRootName == ANTENNA_TOP_TALL_ENTITY_NAME);
	SetAntennaTopEnabled(ANTENNA_TOP_SHORT_ENTITY_NAME, _antennaTopRootName == ANTENNA_TOP_SHORT_ENTITY_NAME);
}

// Disable only adds EF_NODRAW and deliberately leaves collision alone (dynamicprop.cpp:1219), so
// a top hidden without DisableCollision stays solid in the middle of the room. Both are
// prop_dynamic inputs and both are needed. Fired in both directions every round rather
// than only on a change; the round restart respawns the prop back to its authored state.
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

// temp for testing decider room. Run: sv_cheats 1; rush_force_decider
var _forceDeciderNextRound = false;
Instance.RegisterCheatCommand( "rush_force_decider", () => {
	_forceDeciderNextRound = true;
} );

// temp for generating screenshots
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

// A fresh round's antenna has never glowed, so "already off" and "the round just restarted" read
// identically through IsGlowing(). Keep the flag instead.
var _antennaGlowing = false;

// Outlines the antenna in the holding team's colors for the length of freezetime. Not cleaned
// up at round end; the round restart destroys the prefab entity (dynamicprop.cpp:320).
function SetAntennaGlow(enabled) {
	const glow = enabled || _forceAntennaGlow;
	if (glow == _antennaGlowing)
		return;

	_antennaGlowing = glow;

	// read possession the way the button does, so warmup is TEAM_NONE and no state is neutral
	const team = _roomStates[_currentRoomIndex];
	const glowColor = TEAM_COLORS[team] ?? TEAM_COLORS[TEAM_NONE];

	// the glow lives on the entities standing in the room, re-resolved every call
	GlowingAntennaRootNames().forEach((rootName) => {
		const root = FindPrefabEntity(rootName);
		if (!root) {
			return;
		}

		// Glow/Unglow are BaseModelEntity methods, so a root with no model won't have them, and a
		// throw here would take out a round transition or the think loop.
		if (typeof root.Glow != "function" || typeof root.Unglow != "function")
		{
			return;
		}

		if (enabled) {
			// alpha left off: a missing 'a' fills with 255 (cs_base_script.cpp:203), an explicit 0
			// would glow invisibly
			root.Glow(glowColor);
		} else {
			root.Unglow();
		}
	});
}

// Prefab name fixup leaves an entity reachable as 'name' or, by leading-* suffix match, as
// '<instance>-name'. This script needs both forms, so try each.
function FindPrefabEntity(name) {
	const direct = Instance.FindEntityByName(name);
	if (direct) return direct;

	const wildcard = Instance.FindEntityByName(`*${name}`);
	return wildcard;
}

// -------------------------------------------------------------------------------------------
// Button
// -------------------------------------------------------------------------------------------

var _buttonOutputId = null;

// The one button on the shared assembly; no per-room copies left to fall back to, so a failed
// lookup means the round cannot change hands. Prefab entities are not preserved, so the round
// restart leaves any held handle or connection stale and this has to look up fresh every round.
function ButtonOnRoundStart() {
	// the connection stays up through the post-round, so drop it here rather than at round end
	DisconnectButtonOutput();

	const buttonEnt = FindPrefabEntity(ANTENNA_BUTTON_ENTITY_NAME);
	if (!buttonEnt) {
		return;
	}

	const outputId = Instance.ConnectOutput(buttonEnt, "OnPressed", OnButtonPressed);
	_buttonOutputId = outputId === undefined ? null : outputId;

	// loop the beacon on this round's button for the length of the round

	PlayBeaconAtButton(BEACON_IDLE_ENTITY_NAME, buttonEnt);

	// the countdown beeps and the expiry sound come off the same button, started from the think
	PointBeaconAtButton(BEACON_TIMER_BEEP_ENTITY_NAME, buttonEnt);
	PointBeaconAtButton(BEACON_TIMER_END_ENTITY_NAME, buttonEnt);
}

// Repoints a shared beacon at a button and starts it. SetSourceEntity re-resolves the name on
// every fire (soundevent.cpp:280), so repointing is all it takes.
function PlayBeaconAtButton(beaconName, buttonEnt) {
	if (!PointBeaconAtButton(beaconName, buttonEnt)) return;

	// queued behind the SetSourceEntity, so the sound starts at the new source
	Instance.EntFireAtName({ name: beaconName, input: "StartSound" });
}

// The repoint on its own, for beacons started later in the round rather than at round start.
function PointBeaconAtButton(beaconName, buttonEnt) {
	if (!Instance.FindEntityByName(beaconName)) {
		return false;
	}

	// the button's own targetname; the name it was looked up with may have been a leading-* match
	Instance.EntFireAtName({
		name: beaconName,
		input: "SetSourceEntity",
		value: buttonEnt.GetEntityName(),
	});

	return true;
}

// Restarts the terminal beep on its own schedule, stepping through TIMER_BEEP_STAGES as the
// clock runs out.
function TimerBeepThink() {
	const now = Instance.GetGameTime();

	// tolerant of landing a hair early; the alternative is waiting out another whole think, which
	// puts the beep most of THINK_FREQUENCY_SECONDS late
	if (now < _timerBeepNextTime - TIMER_BEEP_TOLERANCE_SECONDS) return;

	Instance.EntFireAtName({ name: BEACON_TIMER_BEEP_ENTITY_NAME, input: "StartSound" });

	// the interval trails the beep it follows, so the count is bumped after the lookup
	const interval = TimerBeepInterval(_timerBeepCount);

	// Measured from the beat this beep was due on, not from when the think actually ran. A think
	// that lands late would otherwise push every beep after it, and the error would pile up over
	// the countdown. A beat missed by more than its own interval means the server hitched, so the
	// schedule re-anchors to now rather than firing a burst to catch up.
	const dueTime =
		_timerBeepNextTime > 0 && now - _timerBeepNextTime < interval
			? _timerBeepNextTime
			: now;

	_timerBeepNextTime = dueTime + interval;
	_timerBeepCount++;
}

// A leftover beep count reads as a later stage and the beeps would open at the fastest tempo, so
// put it all back to untouched and a countdown always starts on the slowest stage.
function ResetTimerBeepState() {
	_timerBeepNextTime = 0;
	_timerBeepCount = 0;
	_timerEndPlayed = false;
}

// How long to wait after beep number beepIndex, walking the stages until one still has beeps
// owing. A stage with no count takes everything from there on, which is how the table ends.
function TimerBeepInterval(beepIndex) {
	let n = beepIndex;

	for (const stage of TIMER_BEEP_STAGES) {
		if (stage.beeps === undefined || n < stage.beeps) return stage.interval;

		n -= stage.beeps;
	}

	// only reachable if every stage is counted, which leaves the tail of the window unscheduled
	return TIMER_BEEP_STAGES[TIMER_BEEP_STAGES.length - 1].interval;
}

// Fires once, and only on a round the clock actually ran out on; an elimination win ends the
// round before the think reaches zero.
function PlayTimerEndSound() {
	if (_timerEndPlayed) return;
	_timerEndPlayed = true;

	Instance.EntFireAtName({ name: BEACON_TIMER_BEEP_ENTITY_NAME, input: "StopSound" });
	StartSoundEntity(BEACON_TIMER_END_ENTITY_NAME);
}

// Nothing from here on can change the outcome. The time check covers the frames after EndRound
// queues its win condition but before OnRoundEnd sets _roundOver.
function IsRoundDecided() {
	return _roundOver || _gameOver || Instance.GetRoundRemainingTime() <= 0;
}

function GetActiveRoomTowerSpottingState( team ) {
	switch ( team )
	{
		default: return CSRadarColor.GRAY;		// generic tower
		case TEAM_CT: return CSRadarColor.CT;	// CT-controlled tower
		case TEAM_T: return CSRadarColor.T;		// T-controlled tower
	}
}

function OnButtonPressed(inputData) {
	var buttonActivator = inputData.activator;
	if (!(buttonActivator instanceof CSPlayerPawn)) return;

	const activatorTeam = buttonActivator.GetTeamNumber();
	const roundOver = IsRoundDecided();

	// A press errors only when the antenna is already this team's color. Measured against
	// _antennaTeam, so a winner pressing post-round gets the color change rather than an error.
	const beaconName =
		( ( _antennaTeam == activatorTeam )
		|| ( roundOver && !END_ROUND_ON_TEAM_ELIMINATION ) ) // If the round is over, then hitting the button does nothing
			? BEACON_ERROR_ENTITY_NAME
			: BEACON_PRESS_ENTITY_NAME;

	
	// caller is the button that fired OnPressed (buttons.cpp:958), and is optional; a missing one
	// skips the sound, not the gameplay below.
	if (inputData.caller) PlayBeaconAtButton(beaconName, inputData.caller);

	if (roundOver) {
		if ( !END_ROUND_ON_TEAM_ELIMINATION ) return; // After the round was decided we just play beep-no-no

		// Cosmetic only: repaint the antenna and stop, no room state and no win check. _currentRoomIndex
		// is already the next round's room, which is what satisfies SetRoomLights' guard.
		SetRoomLights(_currentRoomIndex, activatorTeam);
		return;
	}

	if (Instance.IsWarmupPeriod()) {
		SetRoomLights(_currentRoomIndex, activatorTeam);
		UIUpdateRoomControl(activatorTeam);
	} else {
		// a press is the one thing meant to recolor the antenna, elimination frames included
		SetRoomControl(_currentRoomIndex, activatorTeam, true);

		// Backstop for the wipe no kill event announces: the last living player on a team disconnecting.
		CheckEliminationRoundEnd();
	}
}

// The idle loop stops, but the OnPressed connection stays up so post-round presses are still
// answered; the next ButtonOnRoundStart drops it.
function ButtonOnRoundEnd() {
	Instance.EntFireAtName({ name: BEACON_IDLE_ENTITY_NAME, input: "StopSound" });

	// a win taken before the clock ran out leaves a beep mid-play
	Instance.EntFireAtName({ name: BEACON_TIMER_BEEP_ENTITY_NAME, input: "StopSound" });
}

// Safe on a connection whose button is already destroyed; DisconnectOutput clears its own
// bookkeeping when the handle goes stale (cs_point_script.cpp:1445).
function DisconnectButtonOutput() {
	// a connection id of 0 is valid and falsy, so check for null explicitly
	if (_buttonOutputId === null) return;

	Instance.DisconnectOutput(_buttonOutputId);
	_buttonOutputId = null;
}

// -------------------------------------------------------------------------------------------
// UI
// -------------------------------------------------------------------------------------------
let _uiActive = false;
// UIThink's minimize branch re-runs every think until freezetime ends, so only the edge matters.
let _uiMinimized = false;
let _countdownActive = false;
const UI_DURATION_SECONDS = 5;
const UI_ENTITY_NAME = 'rush_ui';

// Every room class a progression panel can carry, so UIShowProgression can clear the ones it is
// not setting. Derived from ROOM_NAMES, which is the one place every room id is listed.
const ROOM_PANEL_CLASSES = Object.keys(ROOM_NAMES).map((id) => `room_${id}`);

// rush_ui isn't preserved across the round restart, so re-resolve it every use. A throw would
// take out a capture or the round timer, so this returns undefined and callers must check.
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

	// clearing 'hidden' starts the slide (hudrush.css), so the cue goes with it. The direction is
	// per team, hence two sounds.
	if (_lastRoundWinner == TEAM_T || _lastRoundWinner == TEAM_CT)
	{
		PlaySoundForTeam(SOUND_SLIDE_IN_FORWARD, _lastRoundWinner);
		PlaySoundForTeam(SOUND_SLIDE_IN_BACKWARD, OtherTeam(_lastRoundWinner));
	}
	else
	{
		// Nothing moved and it's a draw or the opening round.
		// Note: passing explicit team ids because PlaySoundForTeam drops when OtherTeam(TEAM_NONE) is 0.
		PlaySoundForTeam(SOUND_SLIDE_IN_BACKWARD, TEAM_T);
		PlaySoundForTeam(SOUND_SLIDE_IN_BACKWARD, TEAM_CT);
	}

	// set the room states
	for (let i = 0; i < ROOM_COUNT; ++i)
	{
		const roomId = _roomIds[i];
		const roomName = ROOM_NAMES[roomId];
		const roomPanelId = `rush_room_${i}`;

		_uiEntity.SetDialogVariableString(roomPanelId, 'room_name', roomName);
		_uiEntity.SetHasClass(roomPanelId, 'ct', _roomStates[i] == TEAM_CT);
		_uiEntity.SetHasClass(roomPanelId, 't',  _roomStates[i] == TEAM_T);
		_uiEntity.SetHasClass(roomPanelId, 'current', _currentRoomIndex == i);

		// Make sure slots don't carry more than one room image class.
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

	// each player sees their own side of the room (hudrush.css)
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

	// controlling team's color shows for everyone, not just spectators
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
