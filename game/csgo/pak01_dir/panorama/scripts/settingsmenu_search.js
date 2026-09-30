"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/promoted_settings.ts" />
var SettingsMenuSearch;
(function (SettingsMenuSearch) {
    let m_SettingsSearchTextEntry = $("#SettingsSearchTextEntry");
    let m_ResultsContainer = $("#SearchResultsContainer");
    function _Init() {
        $.RegisterEventHandler('ReadyForDisplay', m_SettingsSearchTextEntry, _OnReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', m_SettingsSearchTextEntry, _OnUnreadyForDisplay);
        m_SettingsSearchTextEntry.RegisterForReadyEvents(true);
        m_SettingsSearchTextEntry.SetReadyForDisplay(true);
        m_SettingsSearchTextEntry.SetPanelEvent('ontextentrychange', OnTextEntryChanged);
        OnTextEntryChanged();
    }
    function _OnReadyForDisplay() {
        m_SettingsSearchTextEntry.SetFocus();
        m_SettingsSearchTextEntry.RaiseChangeEvents(true);
    }
    function _OnUnreadyForDisplay() {
        m_SettingsSearchTextEntry.GetParent().SetFocus();
        m_SettingsSearchTextEntry.RaiseChangeEvents(false);
    }
    function OnTextEntryChanged() {
        m_ResultsContainer.RemoveAndDeleteChildren();
        let hasText = /.*\S.*/;
        if (!hasText.test(m_SettingsSearchTextEntry.text)) {
            PopulateWithPromotedSettings();
            return;
        }
        let arrStrings = m_SettingsSearchTextEntry.text.split(/\s/).filter(s => /^\w+$/.test(s));
        let searchableMenus = [
            'GameSettings',
            'AudioSettings',
            'video_settings',
            'advanced_video',
            'KeybdMouseSettings',
            'CrosshairSettings',
            'ControllerSettings'
        ];
        let arrMatches = [];
        let elSettingsMenu = $.GetContextPanel().GetParent();
        let curMenuTab = null;
        searchableMenus.forEach(id => {
            curMenuTab = id;
            let elRootPanel = elSettingsMenu.FindChildTraverse(id);
            if (!elRootPanel || !elRootPanel.IsValid())
                return;
            TraverseChildren(elRootPanel, SearchSettingText);
            function TraverseChildren(elRoot, fnSearch) {
                if (typeof elRoot.Children !== 'function')
                    return;
                elRoot.Children().forEach(c => { TraverseChildren(c, fnSearch); fnSearch(c); });
            }
            function SearchSettingText(setting) {
                if (ShouldSearchPanelText(setting)) {
                    let bPass = arrStrings.every(s => {
                        let search = new RegExp(s, "giu");
                        return search.test(setting.text);
                    });
                    if (bPass) {
                        let curSubMenu = '';
                        if (curMenuTab.includes('video')) {
                            curSubMenu = curMenuTab.includes('advanced') ? 'AdvancedVideoSettingsRadio' : 'SimpleVideoSettingsRadio';
                            curMenuTab = 'VideoSettings';
                        }
                        arrMatches.push({
                            panel: setting.GetParent(),
                            text: setting.text,
                            menu: curMenuTab,
                            submenu: curSubMenu
                        });
                    }
                }
                function ShouldSearchPanelText(setting) {
                    if (!setting.hasOwnProperty('text'))
                        return false;
                    if (setting.paneltype === 'TextEntry')
                        return false;
                    if (setting.BHasClass('DropDownChild'))
                        return false;
                    if (setting.BHasClass('BindingRowButton'))
                        return false;
                    if (setting.GetParent().paneltype === ('RadioButton'))
                        return false;
                    return true;
                }
            }
        });
        for (let searchResult of arrMatches) {
            CreateSearchResultPanel(searchResult.text, searchResult.menu, searchResult.submenu, searchResult.panel);
        }
    }
    function CreateSearchResultPanel(text, menuid, submenu, panel) {
        let elSearchResult = $.CreatePanel("Panel", m_ResultsContainer, "setting_result_link");
        if (elSearchResult.BLoadLayoutSnippet("SearchResult")) {
            elSearchResult.FindChild("ResultString").SetAlreadyLocalizedText(text);
            elSearchResult.SetPanelEvent('onactivate', () => {
                $.DispatchEvent("SettingsMenu_NavigateToSettingPanel", menuid, submenu, panel);
            });
        }
    }
    function PopulateWithPromotedSettings() {
        let elTitle = $.CreatePanel("Label", m_ResultsContainer, "promoted_settings_title");
        elTitle.text = $.Localize("#GameUI_Settings_Promoted");
        elTitle.AddClass("SettingsSectionTitleLabel");
        elTitle.AddClass("setting-search-recently-added-header");
        g_PromotedSettings.forEach(s => {
            let elSettingsMenu = $.GetContextPanel().GetParent();
            let elPanel = elSettingsMenu.FindChildTraverse(s.id);
            if (elPanel) {
                CreateSearchResultPanel($.Localize(s.loc_name), s.section, s.subsection || "", elPanel);
            }
        });
    }
    {
        _Init();
    }
})(SettingsMenuSearch || (SettingsMenuSearch = {}));
