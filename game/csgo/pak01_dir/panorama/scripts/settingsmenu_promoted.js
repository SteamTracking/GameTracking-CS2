"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/promoted_settings.ts" />
var SettingsMenuPromoted;
(function (SettingsMenuPromoted) {
    class CreatePromotedSettingEntry {
        id;
        loc_name;
        loc_desc;
        setting;
        elRoot;
        elemID;
        constructor(setting) {
            this.id = setting.id;
            this.loc_name = setting.loc_name;
            this.loc_desc = setting.loc_desc;
            this.setting = setting;
            this.elRoot = $('#SettingContainer');
            this.elemID = "PromotedSetting__" + setting.id;
        }
        view() {
            $.DispatchEvent("SettingsMenu_NavigateToSetting", this.setting.section, this.setting.subsection ?? '', this.setting.id);
        }
        createPanel() {
            let elNewSetting = $.CreatePanel("Panel", this.elRoot, this.elemID);
            if (elNewSetting.BLoadLayoutSnippet("PromotedSetting")) {
                elNewSetting.FindChild("SettingName").text = $.Localize(this.loc_name);
                elNewSetting.FindChild("SettingDesc").text = $.Localize(this.loc_desc);
                elNewSetting.FindChildTraverse("ViewSetting").SetPanelEvent('onactivate', () => this.view());
                if (this.setting.highlight) {
                    elNewSetting.AddClass("Highlight");
                }
            }
        }
    }
    function _Init() {
        let arrUnacknowledgedSettings = PromotedSettingsUtil.GetUnacknowledgedPromotedSettings();
        arrUnacknowledgedSettings.forEach(setting => setting.highlight = true);
        for (const setting of g_PromotedSettings) {
            const now = new Date();
            if (setting.end_date > now && setting.start_date <= now) {
                let elGoToSettingPanel = new CreatePromotedSettingEntry(setting);
                elGoToSettingPanel.createPanel();
            }
        }
        if (arrUnacknowledgedSettings.length > 0) {
            $.DispatchEvent("MainMenu_PromotedSettingsViewed");
        }
    }
    {
        _Init();
    }
})(SettingsMenuPromoted || (SettingsMenuPromoted = {}));
