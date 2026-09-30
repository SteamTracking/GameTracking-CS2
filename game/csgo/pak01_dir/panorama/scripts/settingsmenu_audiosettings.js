"use strict";
/// <reference path="csgo.d.ts" />
var SettingsMenuAudioSettings;
(function (SettingsMenuAudioSettings) {
    const k_MusicModePanelIds = [
        'SettingsMusicModeCompetitive',
        'SettingsMusicModeCasual',
        'SettingsMusicModeArmsRace',
        'SettingsMusicModeDeathmatch',
        'SettingsMusicModeRush',
    ];
    function OnMusicModeChange() {
        let nMode = parseInt(GameInterfaceAPI.GetSettingString('snd_music_settings_mode'));
        if (!isFinite(nMode) || nMode < 0 || nMode >= k_MusicModePanelIds.length) {
            nMode = 0;
        }
        for (let i = 0; i < k_MusicModePanelIds.length; i++) {
            const elPanel = $('#' + k_MusicModePanelIds[i]);
            if (elPanel) {
                elPanel.visible = (i === nMode);
            }
        }
    }
    SettingsMenuAudioSettings.OnMusicModeChange = OnMusicModeChange;
    function ApplyCompetitiveVolumesToAllModes() {
        $.DispatchEvent('CSGOMusicApplyCompetitiveVolumesToAllModes');
    }
    SettingsMenuAudioSettings.ApplyCompetitiveVolumesToAllModes = ApplyCompetitiveVolumesToAllModes;
    {
        OnMusicModeChange();
    }
})(SettingsMenuAudioSettings || (SettingsMenuAudioSettings = {}));
