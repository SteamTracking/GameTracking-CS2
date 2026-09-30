"use strict";
/// <reference path="../csgo.d.ts" />
var HudMissions;
(function (HudMissions) {
    var _m_HudMissions = $.GetContextPanel();
    function UpdateQuestUI() {
        const missionDetails = MissionsAPI.GetActiveRecurringMission();
        if (missionDetails === undefined || GameStateAPI.GetMapBSPName() === 'lobby_mapveto') {
            _m_HudMissions.AddClass("hidden");
            return;
        }
        _m_HudMissions.RemoveClass("hidden");
        _m_HudMissions.FindChildInLayoutFile('MissionLabel').text = missionDetails.loc_description;
        _m_HudMissions.SetDialogVariableInt("progress", missionDetails.progress_saved);
        _m_HudMissions.SetDialogVariableInt("goal", missionDetails.goal_points.slice(-1)[0]);
        if (missionDetails.string_tokens) {
            for (const k in missionDetails.string_tokens) {
                const val = missionDetails.string_tokens[k];
                _m_HudMissions.SetDialogVariableLocString(k, val);
            }
        }
    }
    {
        $.RegisterForUnhandledEvent("GameState_OnMatchStart", UpdateQuestUI);
        $.RegisterForUnhandledEvent("OnQuestProgressMade", UpdateQuestUI);
    }
})(HudMissions || (HudMissions = {}));
