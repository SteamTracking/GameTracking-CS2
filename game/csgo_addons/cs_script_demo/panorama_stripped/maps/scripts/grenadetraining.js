import { Entity, Instance } from "cs_script/point_script";

let Rounds = 0;
let Hits = 0;
let Target = 0;

let TargetEasy = "targetbox.ez";
let TargetMedium = "targetbox.med";
let TargetHard = "targetbox.hard";

function SetNextTarget() {
    Rounds++;

    Instance.EntFireAtName({ name: "worldtext.rounds", input: "SetMessage", value: Rounds });
    Instance.EntFireAtName({ name: "cover.*", input: "Enable" });
    Instance.EntFireAtName({ name: "tele.reset", input: "Teleport" });

                                                              
    let NewTarget = Math.floor(Math.random() * 11) + 1;
    if (NewTarget === Target) NewTarget = 12;
    Target = NewTarget;

    let difficulty = "ez";
    if (Rounds > 7) difficulty = "hard";
    else if (Rounds > 4) difficulty = "med";

    Instance.EntFireAtName({ name: `cover.${Target}`, input: "Disable" });
    Instance.EntFireAtName({ name: `tele.${Target}`, input: "TeleportEntity", value: `targetbox.${difficulty}` });
}

                                                
Instance.OnScriptInput("ResetAndCleanUp", () => {
    Instance.EntFireAtName({ name: "trigger.start", input: "Enable" });
    Instance.EntFireAtName({ name: "trigger.end_early", input: "Disable" });
    Instance.EntFireAtName({ name: "worldtext.go_here", input: "Enable" });
    Instance.EntFireAtName({ name: "relay.start_countdown", input: "CancelPending" });

    Instance.EntFireAtName({ name: "worldtext.training_countdown_dyn", input: "SetMessage", value: "3" });
    Instance.EntFireAtName({ name: "worldtext.training_countdown_static", input: "Disable" });
    Instance.EntFireAtName({ name: "worldtext.training_countdown_dyn", input: "Disable" });
    Instance.EntFireAtName({ name: "board.timer", input: "Disable" });
    Instance.EntFireAtName({ name: "board.timer", input: "ResetTimer" });
    Instance.EntFireAtName({ name: "snd.tick", input: "StopSound" });
    Instance.EntFireAtName({ name: "tele.reset", input: "Teleport" });
    Instance.EntFireAtName({ name: "cover.*", input: "Enable" });
    Instance.EntFireAtName({ name: "worldtext.hits", input: "SetMessage", value: "0" });
    Instance.EntFireAtName({ name: "worldtext.rounds", input: "SetMessage", value: "0" });

    Instance.ServerCommand("sv_infinite_ammo 0");
    const player = Instance.GetPlayerController(0)?.GetPlayerPawn();
    player?.DestroyWeapons();
    Instance.ClientCommand(0, "slot3");
});

Instance.OnScriptInput("StartTraining", () => {
    Instance.EntFireAtName({ name: "trigger.start", input: "Disable" });
    Instance.EntFireAtName({ name: "trigger.end_early", input: "Enable" });
    Instance.EntFireAtName({ name: "worldtext.go_here", input: "Disable" });
    Instance.EntFireAtName({ name: "relay.start_countdown", input: "Trigger" });

    Instance.ServerCommand("sv_infinite_ammo 1");
    const player = Instance.GetPlayerController(0)?.GetPlayerPawn();
    player?.DestroyWeapons();
    player?.GiveNamedItem("weapon_hegrenade", true);

    Rounds = 0;
    Hits = 0;
});

                                                 
Instance.OnScriptInput("GrenadeHit", () => {
    Hits++;
    Instance.EntFireAtName({ name: "snd.hit", input: "StartSound" });
    Instance.EntFireAtName({ name: "worldtext.hits", input: "SetMessage", value: Hits });
    if (trackedProjectile && trackedProjectile.IsValid()) {
        trackedProjectile.Remove();
        trackedProjectile = undefined;
    }
});

                                                        
Instance.OnScriptInput("SetNextTarget", () => {
    if (Rounds < 10) {
        SetNextTarget();
    } else {
        Instance.EntFireAtName({ name: "snd.end", input: "StartSound" });
        Instance.EntFireAtName({ name: "board.timer", input: "Disable" });
        Instance.EntFireAtName({ name: "board.timer", input: "ResetTimer" });
        Instance.EntFireAtName({ name: "tele.reset", input: "Teleport" });
        Instance.EntFireAtName({ name: "cover.*", input: "Enable" });
    }
});

                                 
let trackedProjectile;
                                                      
let trackedPos;
Instance.OnGrenadeThrow(({ projectile }) => {
    Instance.ClientCommand(0, "slot6");
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
