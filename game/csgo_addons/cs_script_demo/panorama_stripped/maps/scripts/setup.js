import { CSDamageFlags, CSDamageTypes, Entity, Instance, Console, Entities } from "cs_script/point_script";

Console.SetConvar("sv_cheats", true);
Console.SetConvar("mp_warmup_offline_enabled", true);
Console.SetConvar("mp_warmup_pausetimer", 1);

let bFirstActivate = true;
Instance.OnPlayerActivate(({ player }) => {
    if (bFirstActivate) {
        bFirstActivate = false;
        player.JoinTeam(2);
        Console.SetConvar("bot_stop", "1");
        Console.ServerCommand("bot_add");
    }

    ShowWelcome(player.GetPlayerSlot());
});

Instance.OnModifyPlayerDamage(({ player, damageTypes }) => {
    if (player.GetOriginalPlayerController().IsBot() && !(damageTypes & CSDamageTypes.BLAST)) {
        return { damageFlags: CSDamageFlags.PREVENT_DEATH };
    }
});

Instance.OnPlayerKill(async ({ player }) => {
    await Instance.Delay(1);
    if (player.IsValid() && !player.IsAlive()) {
        player.Reset();
    }
});

Instance.OnPlayerDamage((event) => {
    if (event.damageTypes == CSDamageTypes.SLASH) {
        Instance.QueueAfterThinks(() => {
            const velocity = event.player.GetAbsVelocity();
            velocity.z += 500;
            event.player.Teleport({ velocity });
        });
    }
});

let welcomeLayout = null;
function GetWelcomeLayout() {
    if (!(welcomeLayout instanceof Entity) || !welcomeLayout.IsValid()) {
        [welcomeLayout] = Entities.FindByName("welcome_layout");
    }
    return Entities.FindByName("welcome_layout")[0];
}

function ShowWelcome(playerSlot) {
    GetWelcomeLayout().SetHasClassForPlayer(playerSlot, "dialog", "Dismissed", false);
    GetWelcomeLayout().SetInputCaptureEnabled(playerSlot, true);
}

function HideWelcome(playerSlot) {
    GetWelcomeLayout().SetHasClassForPlayer(playerSlot, "dialog", "Dismissed", true);
    GetWelcomeLayout().SetInputCaptureEnabled(playerSlot, false);
}

Instance.OnCustomHudClicked((event) => {
    if (event.layout === GetWelcomeLayout() && event.buttonId === "dismiss_button") {
        HideWelcome(event.player.GetPlayerSlot());
    }
});

Console.RegisterCheatCommand("script_zoo_show_welcome", () => {
    for (const player of Instance.GetAllPlayerControllers()) {
        ShowWelcome(player.GetPlayerSlot());
    }
});
