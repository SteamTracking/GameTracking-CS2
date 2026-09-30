"use strict";
/// <reference path="..\csgo.d.ts" />
var XpShopWeaponCameraSettings;
(function (XpShopWeaponCameraSettings) {
    XpShopWeaponCameraSettings.CameraSettings = JSON.parse(InventoryAPI.GetCameraDataJson()).weapons;
})(XpShopWeaponCameraSettings || (XpShopWeaponCameraSettings = {}));
