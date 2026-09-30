"use strict";
/// <reference path="../csgo.d.ts" />
var HudSpecatorBg;
(function (HudSpecatorBg) {
    const m_elBg = $.GetContextPanel().FindChildTraverse('AnimBackground');
    function PickBg(xuid) {
        if (!m_elBg || !m_elBg.IsValid()) {
            return;
        }
        m_elBg.PopulateFromSteamID(xuid);
    }
    HudSpecatorBg.PickBg = PickBg;
})(HudSpecatorBg || (HudSpecatorBg = {}));
