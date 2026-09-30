"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="iteminfo.ts" />
var TintSprayIcon;
(function (TintSprayIcon) {
    function CheckIsSprayAndTint(itemId, elImage) {
        if (ItemInfo.IsSprayPaint(itemId) || ItemInfo.IsSpraySealed(itemId)) {
            const colorTint = InventoryAPI.GetSprayTintColorCode(itemId);
            if (colorTint) {
                elImage.style.washColor = colorTint.toString();
            }
            else {
                elImage.style.washColor = 'none';
            }
        }
        else {
            elImage.style.washColor = 'none';
        }
    }
    TintSprayIcon.CheckIsSprayAndTint = CheckIsSprayAndTint;
})(TintSprayIcon || (TintSprayIcon = {}));
