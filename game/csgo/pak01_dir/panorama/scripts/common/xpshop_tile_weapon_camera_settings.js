"use strict";
/// <reference path="..\csgo.d.ts" />
var XpShopWeaponCameraSettings;
(function (XpShopWeaponCameraSettings) {
    XpShopWeaponCameraSettings.CameraSettings = JSON.parse(InventoryAPI.GetCameraDataJson()).weapons;
    // export let CameraSettings: oXpShopWeaponCameraSettings[] = [
    //     // 0 default, 1 far, 2 close, 3 closer, 4 even closer
    //     //rifles
    //     // 5,6,7 for narrow weapons
    //     { type: 'weapon_awp', camera: '1' },
    //     { type: 'weapon_aug', camera: '2' },
    //     { type: 'weapon_sg556', camera: '0' },
    //     { type: 'weapon_ssg08', camera: '1' },
    //     { type: 'weapon_ak47', camera: '0' },
    //     { type: 'weapon_m4a1_silencer', camera: '1' },
    //     { type: 'weapon_famas', camera: '0' },
    //     { type: 'weapon_g3sg1', camera: '1'},
    //     { type: 'weapon_galilar', camera: '2'},
    //     { type: 'weapon_m4a1', camera: '0'},
    //     { type: 'weapon_scar20', camera: '1' },
    //     //mid
    //     { type: 'weapon_mp5sd', camera: '0' },
    //     { type: 'weapon_mac10', camera: '5' },
    //     { type: 'weapon_xm1014', camera: '2'},
    //     { type: 'weapon_m249', camera: '1' },
    //     { type: 'weapon_ump45', camera: '0'},
    //     { type: 'weapon_bizon', camera: '2' },
    //     { type: 'weapon_mag7', camera: '2'},
    //     { type: 'weapon_nova', camera: '1' },
    //     { type: 'weapon_sawedoff', camera: '2'},
    //     { type: 'weapon_negev', camera: '1' },
    //     { type: 'weapon_p90', camera: '3' },
    //     { type: 'weapon_mp9', camera: '5' },
    //     { type: 'weapon_mp7', camera: '5' },
    //     //pistols
    //     { type: 'weapon_usp_silencer', camera: '4' },
    //     { type: 'weapon_cz75a', camera: '6' },
    //     { type: 'weapon_elite', camera: '5' },
    //     { type: 'weapon_tec9', camera: '5' },
    //     { type: 'weapon_revolver', camera: '6' },
    //     { type: 'weapon_fiveseven', camera: '7' },
    //     { type: 'weapon_p250', camera: '7' },
    //     { type: 'weapon_glock', camera: '7' },
    //     { type: 'weapon_deagle', camera: '6' },
    //     { type: 'weapon_hkp2000', camera: '6' },
    //     //misc
    //     { type: 'weapon_c4', camera: '2' },
    //     { type: 'weapon_taser', camera: '5' },
    //     //knife
    //     // { type: 'weapon_knife', camera: '4' },
    // ];
})(XpShopWeaponCameraSettings || (XpShopWeaponCameraSettings = {}));
