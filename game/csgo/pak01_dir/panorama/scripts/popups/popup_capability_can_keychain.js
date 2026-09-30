"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="popup_can_apply_pick_slot.ts" />
/// <reference path="popup_inspect_async-bar.ts" />
var CapabilityCanKeychain;
(function (CapabilityCanKeychain) {
    function ResetPos() {
        const m_pos = 0;
        const m_prevCameraSlot = 0;
        const m_firstCameraAnim = false;
    }
    CapabilityCanKeychain.ResetPos = ResetPos;
})(CapabilityCanKeychain || (CapabilityCanKeychain = {}));
