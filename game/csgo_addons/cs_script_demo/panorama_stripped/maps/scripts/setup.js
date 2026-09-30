import { CSDamageFlags, CSDamageTypes, Entity, Instance } from "cs_script/point_script";

Instance.ServerCommand("sv_cheats 1");
Instance.ServerCommand("mp_warmup_offline_enabled 1");
Instance.ServerCommand("mp_warmup_pausetimer 1");

let bFirstActivate = true;
Instance.OnPlayerActivate(({ player }) => {
    if (bFirstActivate) {
        bFirstActivate = false;
        player.JoinTeam(2);
        Instance.ServerCommand("bot_stop 1");
        Instance.ServerCommand("bot_add");
    }

    ShowWelcome(player.GetPlayerSlot());
});

Instance.OnModifyPlayerDamage(({ player }) => {
    if (player.GetOriginalPlayerController().IsBot()) {
        return { damageFlags: CSDamageFlags.PREVENT_DEATH };
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
        welcomeLayout = Instance.FindEntitiesByName("welcome_layout")[0];
    }
    return Instance.FindEntitiesByName("welcome_layout")[0];
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

Instance.RegisterCheatCommand("script_zoo_show_welcome", () => {
    for (const player of Instance.GetAllPlayerControllers()) {
        ShowWelcome(player.GetPlayerSlot());
    }
});
