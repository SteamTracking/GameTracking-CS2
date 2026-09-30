"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/async.ts" />
var HudEdgePositions;
(function (HudEdgePositions) {
    const m_CP = $.GetContextPanel();
    const m_Edge = $('#HudEdge');
    const m_XSlider = $('#HudEdgeX');
    const m_YSlider = $('#HudEdgeY');
    async function Init() {
        m_XSlider.OnShow();
        m_YSlider.OnShow();
        await Async.NextFrame();
        HudEdgePositions.Update();
    }
    HudEdgePositions.Init = Init;
    function Update() {
        const height = m_CP.actuallayoutheight / m_CP.actualuiscale_y;
        const width = m_CP.actuallayoutwidth / m_CP.actualuiscale_x;
        const minHeight = m_YSlider.actualvalue * height;
        m_XSlider.min = minHeight / width;
        if (m_XSlider.actualvalue < m_XSlider.min)
            m_XSlider.actualvalue = m_XSlider.min;
        m_XSlider.min = Math.max(m_XSlider.min, OptionsMenuAPI.GetHudSafeZoneXMin());
        m_Edge.style.margin = `${(1 - m_YSlider.actualvalue) * 100 / 2}% ${(1 - m_XSlider.actualvalue) * 100 / 2}%`;
    }
    HudEdgePositions.Update = Update;
    ;
})(HudEdgePositions || (HudEdgePositions = {}));
