import { Instance, BaseModelEntity, Console, Entities } from "cs_script/point_script";

function GetProp() {
    const [ent] = Entities.FindByName("mdlchange.prop_dyn");
    if (ent instanceof BaseModelEntity) return ent;
}
function Init() {
    const prop = GetProp();
    if (prop) {
        prop.Unglow();
    }
}
Instance.OnActivate(Init);
Instance.OnScriptReload({ after: Init });

let scale = 1.0;
Instance.OnScriptInput("ScaleUp", () => {
    const prop = GetProp();
    if (prop) {
        scale *= 1.25;
        prop.SetModelScale(scale);
    }
});

Instance.OnScriptInput("ScaleDown", () => {
    const prop = GetProp();
    if (prop) {
        scale /= 1.25;
        prop.SetModelScale(scale);
    }
});

Instance.OnScriptInput("SetModelVar1", () => SetModel("models/de_overpass/construction/ladder/ladder_stand_open_1.vmdl"));
Instance.OnScriptInput("SetModelVar2", () => SetModel("models/de_overpass/overpass_bike/bike_01.vmdl"));
Instance.OnScriptInput("SetModelVar3", () => SetModel("models/generic/terrace_set_01/terrace_chair_01.vmdl"));

Instance.OnScriptInput("GlowToggle", () => {
    const prop = GetProp();
    if (prop) {
        if (!prop.IsGlowing()) prop.Glow();
        else prop.Unglow();
    }
});

const precaches = new Map();

async function SetModel(model) {
    const prop = GetProp();
    if (!prop) return;

    let precache = precaches.get(model);
    if (!precache) {
        precache = Instance.Precache({ resources: [model] });
        if (!precache) return;
        precaches.set(model, precache);
    }
    while (!precache.IsLoadedForAll()) {
                                     
        await Instance.Delay(0);
    }

    prop.SetModel(model);
    prop.Unglow();
}
