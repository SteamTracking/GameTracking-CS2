import { Console, Entity, Instance, Entities } from "cs_script/point_script";

let Rounds = 0;
let Hits = 0;
let Target = 0;

let TargetEasy = "targetbox.ez";
let TargetMedium = "targetbox.med";
let TargetHard = "targetbox.hard";

function SetNextTarget() {
    Rounds++;

    Entities.FireInput({ name: "worldtext.rounds", input: "SetMessage", value: Rounds });
    Entities.FireInput({ name: "cover.*", input: "Enable" });
    Entities.FireInput({ name: "tele.reset", input: "Teleport" });

    // Roll 1-11, if it duplicates last value choose value 12.
    let NewTarget = Math.floor(Math.random() * 11) + 1;
    if (NewTarget === Target) NewTarget = 12;
    Target = NewTarget;

    let difficulty = "ez";
    if (Rounds > 7) difficulty = "hard";
    else if (Rounds > 4) difficulty = "med";

    Entities.FireInput({ name: `cover.${Target}`, input: "Disable" });
    Entities.FireInput({ name: `tele.${Target}`, input: "TeleportEntity", value: `targetbox.${difficulty}` });
}

// called if player leaves play area at any time
Instance.OnScriptInput("ResetAndCleanUp", () => {
    Entities.FireInput({ name: "trigger.start", input: "Enable" });
    Entities.FireInput({ name: "trigger.end_early", input: "Disable" });
    Entities.FireInput({ name: "worldtext.go_here", input: "Enable" });
    Entities.FireInput({ name: "relay.start_countdown", input: "CancelPending" });

    Entities.FireInput({ name: "worldtext.training_countdown_dyn", input: "SetMessage", value: "3" });
    Entities.FireInput({ name: "worldtext.training_countdown_static", input: "Disable" });
    Entities.FireInput({ name: "worldtext.training_countdown_dyn", input: "Disable" });
    Entities.FireInput({ name: "board.timer", input: "Disable" });
    Entities.FireInput({ name: "board.timer", input: "ResetTimer" });
    Entities.FireInput({ name: "snd.tick", input: "StopSound" });
    Entities.FireInput({ name: "tele.reset", input: "Teleport" });
    Entities.FireInput({ name: "cover.*", input: "Enable" });
    Entities.FireInput({ name: "worldtext.hits", input: "SetMessage", value: "0" });
    Entities.FireInput({ name: "worldtext.rounds", input: "SetMessage", value: "0" });

    Console.SetConvar("sv_infinite_ammo", 0);
    const player = Instance.GetPlayerController(0)?.GetPlayerPawn();
    player?.DestroyWeapons();
    Console.ClientCommand(0, "slot3");
});

Instance.OnScriptInput("StartTraining", () => {
    Entities.FireInput({ name: "trigger.start", input: "Disable" });
    Entities.FireInput({ name: "trigger.end_early", input: "Enable" });
    Entities.FireInput({ name: "worldtext.go_here", input: "Disable" });
    Entities.FireInput({ name: "relay.start_countdown", input: "Trigger" });

    Console.SetConvar("sv_infinite_ammo", 1);
    const player = Instance.GetPlayerController(0)?.GetPlayerPawn();
    player?.DestroyWeapons();
    player?.GiveNamedItem("weapon_hegrenade", true);

    Rounds = 0;
    Hits = 0;
});

// called from grenade trigger inside target area
Instance.OnScriptInput("GrenadeHit", () => {
    Hits++;
    Entities.FireInput({ name: "snd.hit", input: "StartSound" });
    Entities.FireInput({ name: "worldtext.hits", input: "SetMessage", value: Hits });
    if (trackedProjectile && trackedProjectile.IsValid()) {
        trackedProjectile.Remove();
        trackedProjectile = undefined;
    }
});

// called from logic_timer "board.timer", 3 sec interval
Instance.OnScriptInput("SetNextTarget", () => {
    if (Rounds < 10) {
        SetNextTarget();
    } else {
        Entities.FireInput({ name: "snd.end", input: "StartSound" });
        Entities.FireInput({ name: "board.timer", input: "Disable" });
        Entities.FireInput({ name: "board.timer", input: "ResetTimer" });
        Entities.FireInput({ name: "tele.reset", input: "Teleport" });
        Entities.FireInput({ name: "cover.*", input: "Enable" });
    }
});

/** @type {Entity | undefined} */
let trackedProjectile;
/** @type {import("cs_script/point_script").Vector} */
let trackedPos;
Instance.OnGrenadeThrow(({ projectile }) => {
    Console.ClientCommand(0, "slot6");
    trackedProjectile = projectile;
    trackedPos = trackedProjectile.GetAbsOrigin();
    Instance.SetNextThink(Instance.GetGameTime());
});
Instance.SetThink(() => {
    if (trackedProjectile && trackedProjectile.IsValid()) {
        Instance.DebugLine({ start: trackedPos, end: trackedProjectile.GetAbsOrigin(), duration: 1, color: { r: 0, g: 0, b: 255 } });
        trackedPos = trackedProjectile.GetAbsOrigin();
        Instance.SetNextThink(Instance.GetGameTime());
    }
});
