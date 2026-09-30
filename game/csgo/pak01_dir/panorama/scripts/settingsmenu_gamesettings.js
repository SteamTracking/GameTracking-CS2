"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="settingsmenu_shared.ts" />
var SettingsMenuGameSettings;
(function (SettingsMenuGameSettings) {
    function _InitGameSettings() {
        if (GameInterfaceAPI.IsConsoleEnabledByCommandLine()) {
            $("#enableconsoledropdown-container").visible = false;
        }
        else {
            $("#enableconsoledropdowncmdline-container").visible = false;
        }
        if (!GameInterfaceAPI.ShowThreadPoolOptions()) {
            $("#ThreadPoolOptions").visible = false;
            $("#ThreadPoolOptionsQuit").visible = false;
            GameInterfaceAPI.SetSettingString('thread_pool_option', '3');
        }
        else {
            let option = parseInt(GameInterfaceAPI.GetSettingString('thread_pool_option'));
            if (option !== 0 && option !== 2 && option !== 3) {
                GameInterfaceAPI.SetSettingString('thread_pool_option', '3');
            }
        }
        _RefreshDatacentersList();
    }
    function _RefreshDatacentersList() {
        let elContainer = $('#DatacenterListContainer');
        elContainer.RemoveAndDeleteChildren();
        const dcs = LobbyAPI.GetReachableDatacenters();
        const samples = dcs.samples;
        let numSamplesAdded = 0;
        for (let k = 0; k < 10; ++k) {
            if (!samples || !samples.hasOwnProperty('sample' + k))
                break;
            const ss = samples['sample' + k];
            let elPanel = $.CreatePanel("Panel", elContainer, String(ss.ping));
            elPanel.BLoadLayoutSnippet("snippet_datacenter_entry");
            elPanel.SetDialogVariable('name', ss.name);
            elPanel.SetDialogVariableInt('ping', ss.ping);
            ++numSamplesAdded;
        }
        if (numSamplesAdded == 0) {
            let elPanel = $.CreatePanel("Panel", elContainer, '0');
            elPanel.BLoadLayoutSnippet("snippet_datacenter_entry");
            elPanel.SetDialogVariable('name', $.Localize("#SFUI_UserAlert_Unreachable"));
            elPanel.SetDialogVariableInt('ping', 0);
        }
        elContainer.SetHasClass('no-data-centers', numSamplesAdded == 0);
    }
    {
        _InitGameSettings();
        SettingsMenuShared.ChangeBackground(0);
        $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_ReachableDatacentersUpdated', _RefreshDatacentersList);
    }
})(SettingsMenuGameSettings || (SettingsMenuGameSettings = {}));
