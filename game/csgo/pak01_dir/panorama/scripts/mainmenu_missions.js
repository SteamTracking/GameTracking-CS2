"use strict";
/// <reference path="csgo.d.ts" />
var MainMenuMissions;
(function (MainMenuMissions) {
    const _m_missionPanel = $.GetContextPanel();
    function Init() {
        UpdateMissionEntries();
    }
    function UpdateMissionEntries() {
        let missionInfo = MissionsAPI.GetRecurringMission();
        const missionContainer = $("#mission-container-root");
        if (!missionContainer)
            return;
        missionContainer.RemoveAndDeleteChildren();
        if (missionInfo != undefined) {
            if (missionContainer) {
                $.GetContextPanel().RemoveClass('hidden');
                const elMissionPanel = $.CreatePanel('Button', missionContainer, missionInfo.name);
                elMissionPanel.BLoadLayoutSnippet("mission");
                const elNameLabel = elMissionPanel.FindChildTraverse("name");
                elNameLabel.text = missionInfo.loc_description;
                elMissionPanel.SetDialogVariableInt("progress", missionInfo.progress_saved);
                elMissionPanel.SetDialogVariableInt("points", missionInfo.goal_points[0]);
                elMissionPanel.SetDialogVariableInt("xp", Number(missionInfo.xp_reward[0]));
                elMissionPanel.SetPanelEvent("onactivate", PlayMission.bind(undefined, missionInfo));
                function ExtractStringTokens(string_tokens) {
                    for (const k in string_tokens) {
                        if (typeof string_tokens[k] === 'object' && !Array.isArray(string_tokens[k]) && string_tokens[k] !== null) {
                            ExtractStringTokens(string_tokens[k]);
                        }
                        const val = string_tokens[k];
                        elMissionPanel.SetDialogVariableLocString(k, val);
                    }
                }
                if (missionInfo.string_tokens) {
                    ExtractStringTokens(missionInfo.string_tokens);
                    let imagePath = 'undefined';
                    if (missionInfo.hasOwnProperty('mapgroup') && missionInfo.mapgroup != '') {
                        const cfg = GameTypesAPI.GetConfig();
                        const mg = cfg.mapgroups[missionInfo['mapgroup']];
                        const keysList = Object.keys(mg.maps);
                        imagePath = keysList[0];
                    }
                    else if (missionInfo.hasOwnProperty('map') && missionInfo.map != '' && missionInfo.map) {
                        imagePath = missionInfo.map;
                    }
                    const elBg = $.GetContextPanel().FindChildTraverse('id-mission-art');
                    elBg.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/720p/' + (imagePath) + '.png")';
                }
            }
        }
        else {
            $.GetContextPanel().AddClass('hidden');
        }
    }
    function PlayMission(m) {
        LobbyAPI.CreateSession();
        const gameMode = m.gamemode;
        let gameType = "classic";
        let gmFlags = 0;
        if (gameMode === "deathmatch") {
            gameType = "gungame";
            gmFlags = 32;
        }
        let mg = m.mapgroup;
        if (gameMode == "competitive") {
            mg = "mg_" + m.map;
            gmFlags = 16;
        }
        var settings = {
            update: {
                Options: {
                    action: "custommatch",
                    server: "official"
                },
                Game: {
                    mode: gameMode,
                    type: gameType,
                    mapgroupname: mg,
                    map: m.map,
                    gamemodeflags: gmFlags,
                },
            },
            delete: {
                Options: {
                    challengekey: 1
                }
            }
        };
        LobbyAPI.UpdateSessionSettings(settings);
        LobbyAPI.StartMatchmaking('', '', '', '');
    }
    {
        Init();
        $.RegisterForUnhandledEvent('OnRecurringMissionsReceived', Init);
        $.RegisterForUnhandledEvent('OnRecurringMissionsChanged', Init);
    }
})(MainMenuMissions || (MainMenuMissions = {}));
