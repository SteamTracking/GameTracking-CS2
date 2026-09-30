"use strict";
/// <reference path="csgo.d.ts" />
var ParticleControls;
(function (ParticleControls) {
    function GetAllChildren(panel) {
        const children = panel.Children();
        return [...children, ...children.flatMap(GetAllChildren)];
    }
    function IsParticleScenePanel(panel) {
        return panel.type === "ParticleScenePanel";
    }
    ParticleControls.IsParticleScenePanel = IsParticleScenePanel;
    function GetWorldExtendsFromCamFov(fov, xpos, ypos, zpos, pheight, pwidth) {
        let height = Math.tan(fov * .5) * Math.sqrt((xpos * xpos) + (ypos * ypos) + (zpos * zpos));
        let width = (pwidth / pheight) * height;
        return { height, width };
    }
    function StartAllChildrenParticles(elContainerPanel) {
        const AllPanels = GetAllChildren(elContainerPanel);
        for (const panel of AllPanels) {
            if (IsParticleScenePanel(panel)) {
                panel.StopParticlesImmediately(true);
                panel.StartParticles();
            }
        }
    }
    ParticleControls.StartAllChildrenParticles = StartAllChildrenParticles;
    function StopAllChildrenParticlesImmediately(elContainerPanel) {
        const AllPanels = GetAllChildren(elContainerPanel);
        for (const panel of AllPanels) {
            if (IsParticleScenePanel(panel))
                panel.StopParticlesImmediately(true);
        }
    }
    ParticleControls.StopAllChildrenParticlesImmediately = StopAllChildrenParticlesImmediately;
    function StopParticlesWithEndCap(panelId) {
        if (panelId && IsParticleScenePanel(panelId))
            panelId.StopParticlesWithEndcaps();
    }
    ParticleControls.StopParticlesWithEndCap = StopParticlesWithEndCap;
    function SetPanelParticleControlPoint(panelId, cp, x, y, z) {
        const AllPanels = GetAllChildren($(panelId));
        for (const panel of AllPanels) {
            if (panel && IsParticleScenePanel(panel)) {
                panel.StopParticlesImmediately(true);
                panel.StartParticles();
                panel.SetControlPoint(cp, x, y, z);
            }
        }
    }
    ParticleControls.SetPanelParticleControlPoint = SetPanelParticleControlPoint;
    function SetPanelParticleControlPointDirect(panelId, cp, x, y, z) {
        if (panelId && IsParticleScenePanel(panelId)) {
            panelId.SetControlPoint(cp, x + 1, y, z);
            panelId.SetControlPoint(cp, x, y, z);
        }
    }
    ParticleControls.SetPanelParticleControlPointDirect = SetPanelParticleControlPointDirect;
    function ForcePanelToParticleName(panelId, particleName) {
        if (panelId && IsParticleScenePanel(panelId)) {
            panelId.SetParticleNameAndRefresh(particleName);
        }
    }
    ParticleControls.ForcePanelToParticleName = ForcePanelToParticleName;
    function RestartStatusRank(panelId, x, y, z) {
        const panel = $(panelId);
        if (panel && IsParticleScenePanel(panel)) {
            panel.StopParticlesImmediately(true);
            panel.StartParticles();
            panel.SetControlPoint(3, x, y, z);
        }
    }
    ParticleControls.RestartStatusRank = RestartStatusRank;
    function UpdateMainMenuTopBar(elPanel, curTabID) {
        let g_RadioButtonIdLookup = {
            JsInventory: "#MainMenuNavBarInventory",
            JsLoadout: "#MainMenuNavBarLoadout",
            JsPlay: "#MainMenuNavBarPlay",
            JsMainMenuStore: "#MainMenuNavBarStore",
            JsPlayerStats: "#MainMenuNavBarStats",
            JsMainMenuNews: "#MainMenuNavBarNews",
        };
        const Color = [85, 212, 238];
        const HColor = [0, 255, 212];
        if (g_RadioButtonIdLookup[curTabID] == null) {
            elPanel.SetControlPoint(1, 1, 1, 1);
            elPanel.SetControlPoint(1, 0, 0, 0);
            elPanel.SetControlPoint(2, 96, 0, .75);
            elPanel.SetControlPoint(16, Color[0], Color[1], Color[2]);
            elPanel.SetControlPoint(17, HColor[0], HColor[1], HColor[2]);
            return;
        }
        const elContainer = $("#MainMenuNavBarCenterContainer");
        let curTabButton = $(g_RadioButtonIdLookup[curTabID]);
        const particleWidthInGameUnits = 32 * 35;
        if (curTabButton && elContainer) {
            const particlePanelScalar = particleWidthInGameUnits / elPanel.actuallayoutwidth;
            curTabButton.checked = true;
            const curLabel = curTabButton.FindChildrenWithClassTraverse("mainmenu-top-navbar__radio-btn__label")[0];
            let center = ((elContainer.actuallayoutwidth * .5) - (curTabButton.actualxoffset + (curTabButton.actuallayoutwidth * .5)));
            center *= (particlePanelScalar);
            const buffer = 20;
            const width = (curLabel.actuallayoutwidth * .5 + buffer) * particlePanelScalar;
            elPanel.SetControlPoint(1, center + 1, 0, 0);
            elPanel.SetControlPoint(1, center, 0, 0);
            elPanel.SetControlPoint(2, width, .1, .25);
        }
        else {
            elPanel.SetControlPoint(1, 0, 0, 0);
            elPanel.SetControlPoint(2, 96, 0, .25);
            elPanel.SetControlPoint(16, Color[0], Color[1], Color[2]);
            elPanel.SetControlPoint(17, HColor[0], HColor[1], HColor[2]);
        }
    }
    ParticleControls.UpdateMainMenuTopBar = UpdateMainMenuTopBar;
    function InitMainMenuTopBar(elPanel) {
        const Color = [85, 212, 238];
        const HColor = [0, 255, 212];
        elPanel.SetControlPoint(16, Color[0], Color[1], Color[2]);
    }
    ParticleControls.InitMainMenuTopBar = InitMainMenuTopBar;
    function UpdateActionBar(elPanel, curTabID) {
        const myParent = elPanel.GetParent();
        const marginx = 20;
        const ButtonBg = myParent.FindChildrenWithClassTraverse('play-menu__playbtn__bg')[0];
        const buttonWidth = ButtonBg.actuallayoutwidth + 2;
        const lookat = [550, 0, 70];
        let g_RadioButtonIdLookup = {
            RmoveBtnEffects: "#PartyCancelBtn",
            StartMatchBtn: "#StartMatchBtn",
        };
        if (g_RadioButtonIdLookup[curTabID] == null)
            return;
        if (g_RadioButtonIdLookup[curTabID] == "#StartMatchBtn") {
            const buttonHeight = ButtonBg.actuallayoutheight;
            const camOffsetFromLookat = [0, 330, 0];
            let PanelWorldSize = GetWorldExtendsFromCamFov(120, camOffsetFromLookat[0], camOffsetFromLookat[1], camOffsetFromLookat[2], elPanel.actuallayoutheight, elPanel.actuallayoutwidth);
            let gametoWorldScalar = (PanelWorldSize.width * 2) / elPanel.actuallayoutwidth;
            const Color = [15, 231, 15];
            elPanel.StartParticleSystem("particles/ui/ui_mainmenu_playaction_active.vpcf");
            elPanel.StartParticles();
            const col = 17;
            const row = Math.floor((buttonHeight * gametoWorldScalar) / 32);
            elPanel.SetControlPoint(1, (buttonWidth * .5 - marginx) * gametoWorldScalar + Math.random(), 0, lookat[2]);
            elPanel.SetControlPoint(2, col, row, .25);
            elPanel.SetControlPoint(5, 1, 20, 0);
            elPanel.SetControlPoint(16, Color[0], Color[1], Color[2]);
        }
        else if (g_RadioButtonIdLookup[curTabID] == "#PartyCancelBtn") {
            const Color = [0, 0, 0];
            elPanel.SetControlPoint(16, Color[0], Color[1], Color[2]);
            elPanel.StopParticlesImmediately(true);
        }
        else {
            const Color = [60, 60, 60];
            elPanel.SetControlPoint(5, 0, 0, 0);
            elPanel.SetControlPoint(2, 17, 3, .25);
            elPanel.SetControlPoint(16, Color[0], Color[1], Color[2]);
            elPanel.StopParticlesImmediately(true);
        }
    }
    ParticleControls.UpdateActionBar = UpdateActionBar;
})(ParticleControls || (ParticleControls = {}));
