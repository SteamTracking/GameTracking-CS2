"use strict";
/// <reference path="csgo.d.ts" />
var SettingsMenuAudioSettings;
(function (SettingsMenuAudioSettings) {
    // Index into this array IS snd_music_settings_mode, and matches MusicMode_t in
    // clientmode_csnormal.cpp and the mode switch in soundstacks_csgo_music.vsndstck.
    const k_MusicModePanelIds = [
        'SettingsMusicModeCompetitive',
        'SettingsMusicModeCasual',
        'SettingsMusicModeArmsRace',
        'SettingsMusicModeDeathmatch',
        'SettingsMusicModeRush',
    ];
    // Shows only the picked mode's slider set. One set per mode because a settings
    // slider resolves its convar at parse time and cannot be rebound later.
    function OnMusicModeChange() {
        // Fall back to competitive rather than hiding every set.
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
    // Copies the competitive set onto the other four. The copy itself runs in
    // CCSGO_AudioSettingsScreen, which also refreshes the hidden slider sets.
    function ApplyCompetitiveVolumesToAllModes() {
        $.DispatchEvent('CSGOMusicApplyCompetitiveVolumesToAllModes');
    }
    SettingsMenuAudioSettings.ApplyCompetitiveVolumesToAllModes = ApplyCompetitiveVolumesToAllModes;
    // On creation
    {
        OnMusicModeChange();
    }
})(SettingsMenuAudioSettings || (SettingsMenuAudioSettings = {}));
