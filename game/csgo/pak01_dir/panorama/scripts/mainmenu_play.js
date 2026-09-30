"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/scheduler.ts" />
/// <reference path="avatar.ts" />
/// <reference path="particle_controls.ts" />
/// <reference path="util_gamemodeflags.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="common/icon.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="common/sessionutil.ts" />
/// <reference path="rating_emblem.ts" />
$.LogChannel("p.mainmenu", "LV_OFF");
var PlayMenu;
(function (PlayMenu) {
    const k_workshopPanelId = 'gameModeButtonContainer_workshop';
    let _m_inventoryUpdatedHandler;
    // Holds handles to panels containing game mode selection buttons.
    const m_mapSelectionButtonContainers = {};
    // Game mode configs from GameModes.txt.
    let m_gameModeConfigs = {};
    // Array of game mode selection radio button panels.
    let m_arrGameModeRadios = [];
    // Helper functions that get implemented in Init
    let GetMGDetails;
    let GetGameType;
    const m_bPerfectWorld = (MyPersonaAPI.GetLauncherType() === 'perfectworld');
    let m_activeMapGroupSelectionPanelID = null;
    // for regular game modes (m_workshop = false)
    let m_serverSetting = '';
    let m_gameModeSetting = '';
    let m_singleSkirmishMapGroup = null;
    let m_arrSingleSkirmishMapGroups = [];
    // HACK: per-mode selected map state stored directly on the button panels that are children of m_mapSelectionButtonContainers[mode_panel_id]
    const m_gameModeFlags = {};
    // for workshop maps
    let m_isWorkshop = false;
    let m_jsTimerUpdateHandle = false;
    // private queue key.
    let m_challengeKey = '';
    let m_bDidShowActiveMapSelectionTab = false;
    let m_selectedPracticeMap = '';
    const k_workshopModes = {
        classic: 'casual,competitive',
        casual: 'casual',
        competitive: 'competitive',
        wingman: 'scrimcomp2v2',
        deathmatch: 'deathmatch',
        training: 'training',
        coopstrike: 'coopmission',
        armsrace: 'gungameprogressive',
        rush: 'rush',
        custom: 'custom',
        // skirmish modes
        flyingscoutsman: 'flyingscoutsman',
        retakes: 'retakes'
    };
    const m_PlayMenuActionBarParticleFX = $('#PlayMenuActionBar_Searching_particles');
    // Create a Table of control point positions
    ParticleControls.InitMainMenuTopBar(m_PlayMenuActionBarParticleFX);
    function inDirectChallenge() {
        return _GetDirectChallengeKey() != '';
    }
    function StartSearch() {
        const btnStartSearch = $('#StartMatchBtn');
        if (btnStartSearch === null)
            return;
        btnStartSearch.AddClass('pressed');
        $.DispatchEvent('CSGOPlaySoundEffect', 'mainmenu_press_GO', 'MOUSE');
        ParticleControls.UpdateActionBar(m_PlayMenuActionBarParticleFX, "StartMatchBtn");
        if (inDirectChallenge()) {
            _DirectChallengeStartSearch();
            return;
        }
        if (m_isWorkshop) {
            _DisplayWorkshopModePopup();
        }
        else {
            if (m_gameModeSetting !== 'premier') {
                // even though settings are guaranteed to have valid maps/mapgroups, we still don't want a user to start matchmaking without an explicit map selection.
                if (!_CheckContainerHasAnyChildChecked(_GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID)) && !m_isWorkshop) {
                    _NoMapSelectedPopup();
                    btnStartSearch.RemoveClass('pressed');
                    return;
                }
            }
            // force the user to make some decisions here
            if (GameModeFlags.DoesModeUseFlags(_RealGameMode()) && !m_gameModeFlags[m_serverSetting + _RealGameMode()]) // flags entry exists but we dont have one set
             {
                btnStartSearch.RemoveClass('pressed');
                const resumeSearchFnHandle = UiToolkitAPI.RegisterJSCallback(StartSearch);
                _OnGameModeFlagsBtnClicked(resumeSearchFnHandle);
                return;
            }
            let stage = _GetTournamentStage();
            LobbyAPI.StartMatchmaking(MyPersonaAPI.GetMyOfficialTournamentName(), MyPersonaAPI.GetMyOfficialTeamName(), _GetTournamentOpponent(), stage);
        }
    }
    function _Init() {
        // Get map groups for modes out of gamemodes.txt
        const cfg = GameTypesAPI.GetConfig();
        // Game type is not helpful. Nobody cares about a mode being 'classic'. Dig out useful subkeys and
        // store them in a local object for easier access.
        for (const type in cfg.gameTypes) {
            for (const mode in cfg.gameTypes[type].gameModes) {
                let obj = cfg.gameTypes[type].gameModes[mode];
                m_gameModeConfigs[mode] = obj;
            }
        }
        // Helper to dig up the game type string for a given mode based on gamemodes.txt.
        // 'Game type' isn't very useful... trying to use it only when required and talk about modes by 'game mode' as often as possible.
        GetGameType = (mode) => {
            for (const gameType in cfg.gameTypes) {
                if (cfg.gameTypes[gameType].gameModes.hasOwnProperty(mode))
                    return gameType;
            }
        };
        GetMGDetails = (mg) => {
            return cfg.mapgroups[mg];
        };
        // Apply the settings from the preferences we read to the session so when we get the update we are
        // in sync with the sessions and not using the session defaults.
        const elGameModeSelectionRadios = $('#GameModeSelectionRadios');
        if (elGameModeSelectionRadios !== null) {
            m_arrGameModeRadios = elGameModeSelectionRadios.Children();
        }
        m_arrGameModeRadios = m_arrGameModeRadios.filter(elPanel => !elPanel.BHasClass('mainmenu-top-navbar__play_seperator'));
        for (let entry of m_arrGameModeRadios) {
            entry.SetPanelEvent('onactivate', () => {
                m_isWorkshop = false;
                _LoadGameModeFlagsFromSettings();
                // clear skirmish
                if (!_IsSingleSkirmishString(entry.id)) {
                    m_singleSkirmishMapGroup = null;
                }
                if (entry.id === "JsDirectChallengeBtn") {
                    m_gameModeSetting = 'competitive';
                    _OnDirectChallengeBtn();
                    return;
                }
                else if (_IsSingleSkirmishString(entry.id)) {
                    m_gameModeSetting = 'skirmish';
                    m_singleSkirmishMapGroup = _GetSingleSkirmishMapGroupFromSingleSkirmishString(entry.id);
                }
                else {
                    m_gameModeSetting = entry.id;
                }
                const alert = entry.FindChild('GameModeAlert');
                if ((entry.id === "competitive" || entry.id === 'scrimcomp2v2') && alert && !alert.BHasClass('hidden')) {
                    if (GameInterfaceAPI.GetSettingString('ui_show_unlock_competitive_alert') !== '1') {
                        GameInterfaceAPI.SetSettingString('ui_show_unlock_competitive_alert', '1');
                    }
                }
                // reset the key without triggering a bunch of session update callbacks,
                // it will be pushed into the session settings in _ApplySessionSettings
                m_challengeKey = '';
                _ApplySessionSettings();
            });
        }
        for (let entry of m_arrGameModeRadios) {
            if (_IsSingleSkirmishString(entry.id)) {
                m_arrSingleSkirmishMapGroups.push(_GetSingleSkirmishMapGroupFromSingleSkirmishString(entry.id));
            }
        }
        _SetUpGameModeFlagsRadioButtons();
        // Set up Permissions btn
        const elBtnContainer = $('#PermissionsSettings');
        const elPermissionsButton = elBtnContainer.FindChild("id-slider-btn");
        elPermissionsButton.SetPanelEvent('onactivate', () => {
            const bCurrentlyPrivate = (LobbyAPI.GetSessionSettings().system.access === "private");
            const sNewAccessSetting = bCurrentlyPrivate ? "public" : "private";
            const settings = {
                update: {
                    system: {
                        access: sNewAccessSetting
                    }
                }
            };
            GameInterfaceAPI.SetSettingString('lobby_default_privacy_bits', (sNewAccessSetting === "public") ? "1" : "0");
            LobbyAPI.UpdateSessionSettings(settings);
            $.DispatchEvent('UIPopupButtonClicked', '');
        });
        // Set up practice settings
        const elPracticeSettingsContainer = $('#id-play-menu-practicesettings-container');
        for (let elChild of elPracticeSettingsContainer.Children()) {
            if (!elChild.id.startsWith('id-play-menu-practicesettings-'))
                continue;
            let strFeatureName = elChild.id;
            strFeatureName = strFeatureName.replace('id-play-menu-practicesettings-', '');
            strFeatureName = strFeatureName.replace('-tooltip', '');
            // "id-play-menu-practicesettings-grenades-tooltip" => '#practicesettings_*grenades*_button'
            const elFeatureFrame = elChild.FindChildTraverse('id-play-menu-practicesettings-' + strFeatureName);
            const elFeatureSliderBtn = elFeatureFrame.FindChildTraverse('id-slider-btn');
            elFeatureSliderBtn.text = $.Localize('#practicesettings_' + strFeatureName + '_button');
            elFeatureSliderBtn.SetPanelEvent('onactivate', () => {
                UiToolkitAPI.HideTextTooltip();
                const sessionSettings = LobbyAPI.GetSessionSettings();
                const curvalue = (sessionSettings && sessionSettings.options && sessionSettings.options.hasOwnProperty('practicesettings_' + strFeatureName))
                    ? sessionSettings.options['practicesettings_' + strFeatureName] : 0;
                // flip the value
                const newvalue = curvalue ? 0 : 1;
                // update the UI CVAR first 
                GameInterfaceAPI.SetSettingString('ui_playsettings_listen_' + strFeatureName, newvalue ? '1' : '0');
                // then the settings second
                const setting = 'practicesettings_' + strFeatureName;
                const newSettings = { update: { options: {} } };
                newSettings.update.options[setting] = newvalue;
                LobbyAPI.UpdateSessionSettings(newSettings);
            });
        }
        //Set up StartSearch Button
        const btnStartSearch = $('#StartMatchBtn');
        btnStartSearch.SetPanelEvent('onactivate', StartSearch);
        const btnCancel = $.GetContextPanel().FindChildInLayoutFile('PartyCancelBtn');
        btnCancel.SetPanelEvent('onactivate', () => {
            LobbyAPI.StopMatchmaking();
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
            ParticleControls.UpdateActionBar(m_PlayMenuActionBarParticleFX, "RmoveBtnEffects");
        });
        const elWorkshopSearch = $("#WorkshopSearchTextEntry");
        elWorkshopSearch.SetPanelEvent('ontextentrychange', _UpdateWorkshopMapFilter);
        // Set initial state to our session settings
        _SyncDialogsFromSessionSettings(LobbyAPI.GetSessionSettings());
        _ApplySessionSettings();
        // if favorites preset button is empty, save whatever we have right now.
        const strFavoriteMaps = GameInterfaceAPI.GetSettingString('ui_playsettings_custom_preset');
        if (strFavoriteMaps === '') {
            SaveMapSelectionToCustomPreset(true);
        }
        _UpdateGameModeFlagsBtn();
        _UpdateDirectChallengePage();
    }
    function _SetUpGameModeFlagsRadioButtons() {
        const oFlags = GameModeFlags.GetFlags();
        for (let key of Object.keys(oFlags)) {
            const elParent = $.GetContextPanel().FindChildInLayoutFile('id-gamemode-flag-' + key);
            const mode = oFlags[key];
            for (let flag of mode.flags) {
                if (!elParent.FindChildInLayoutFile(elParent.id + '-' + flag)) {
                    const btn = $.CreatePanel('RadioButton', elParent, elParent.id + '-' + flag, {
                        class: 'gamemode-setting-radiobutton',
                        group: 'game_mode_flag_' + key,
                        text: '#play_settings_' + key + '_dialog_' + flag
                    });
                    btn.SetPanelEvent('onactivate', () => _OnGameModeFlagOptionActivate(flag));
                    let btnId = btn.id;
                    btn.SetPanelEvent('onmouseover', () => {
                        if (key === 'competitive') {
                            UiToolkitAPI.ShowTextTooltip(btnId, '#play_settings_competitive_dialog_' + flag + '_desc');
                        }
                    });
                    btn.SetPanelEvent('onmouseout', UiToolkitAPI.HideTextTooltip);
                }
            }
        }
    }
    function _RevertForceDirectChallengeSettings() {
        _LoadGameModeFlagsFromSettings();
    }
    function _TurnOffDirectChallenge() {
        _SetDirectChallengeKey('');
        _RevertForceDirectChallengeSettings();
        _ApplySessionSettings();
        Scheduler.Cancel("directchallenge");
    }
    function _OnDirectChallengeBtn() {
        if (!inDirectChallenge()) {
            // when opening the direct challenge panel, use the saved code, if we have one
            const savedKey = GameInterfaceAPI.GetSettingString('ui_playsettings_directchallengekey');
            if (!savedKey)
                _SetDirectChallengeKey(CompetitiveMatchAPI.GetDirectChallengeCode());
            else
                _SetDirectChallengeKey(savedKey);
            _ApplySessionSettings();
        }
    }
    function _SetDirectChallengeKey(key) {
        let keySource;
        let keySourceLabel;
        let type, id, id32;
        if (key != '') {
            const oReturn = { value: [] };
            const bValid = _IsChallengeKeyValid(key, oReturn, 'set');
            type = oReturn.value[2]; // u for user, g for group
            id = oReturn.value[3]; // xuid if user, clanid if group
            id32 = parseInt(oReturn.value[4]); // 32-bit id of the clan
            if (bValid) {
                switch (type) {
                    case 'u':
                        keySource = FriendsListAPI.GetFriendName(id);
                        keySourceLabel = $.Localize('#DirectChallenge_CodeSourceLabelUser2');
                        break;
                    case 'g':
                        keySource = FriendsListAPI.GetClanInfoById32Bit(id32, 'name');
                        keySourceLabel = $.Localize('#DirectChallenge_CodeSourceLabelClan2');
                        if (!keySource) {
                            keySource = $.Localize("#DirectChallenge_UnknownSource");
                        }
                        break;
                }
            }
            GameInterfaceAPI.SetSettingString('ui_playsettings_directchallengekey', key);
        }
        // toggle the checkbox
        const DirectChallengeCheckBox = $.GetContextPanel().FindChildTraverse('JsDirectChallengeBtn');
        DirectChallengeCheckBox.checked = key != '';
        if (type !== undefined && id != undefined)
            _SetDirectChallengeIcons(type, id);
        $.GetContextPanel().SetDialogVariable('queue-code', key);
        if (keySource)
            $.GetContextPanel().SetDialogVariable('code-source', keySource);
        if (keySourceLabel)
            $.GetContextPanel().SetDialogVariable('code-source-label', keySourceLabel);
        if (id)
            $.GetContextPanel().SetAttributeString('code-xuid', id);
        if (type)
            $.GetContextPanel().SetAttributeString('code-type', type);
        if (key && (m_challengeKey != key)) {
            // do this one frame later
            $.Schedule(0.01, () => {
                const elHeader = $.GetContextPanel().FindChildTraverse("JsDirectChallengeKey");
                if (elHeader && elHeader.IsValid())
                    elHeader.TriggerClass('directchallenge-status__header__queuecode');
            });
        }
        // set style on root
        $.GetContextPanel().SetHasClass('directchallenge', key != '');
        $.Msg("-- challenge key updated: " + key);
        m_challengeKey = key;
    }
    function _ClansInfoUpdated() {
        if (m_challengeKey && $.GetContextPanel().GetAttributeString('code-type', '') === 'g') {
            _SetDirectChallengeKey(m_challengeKey);
        }
    }
    function _AddOpenPlayerCardAction(elAvatar, xuid) {
        elAvatar.SetPanelEvent("onactivate", () => {
            // Tell the sidebar to stay open and ignore its on mouse event while the context menu is open
            $.DispatchEvent('SidebarContextMenuActive', true);
            if (xuid !== '') {
                const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => $.DispatchEvent('SidebarContextMenuActive', false));
                contextMenuPanel.AddClass("ContextMenu_NoArrow");
            }
        });
    }
    function _SetDirectChallengeIcons(type, id) {
        const btn = $("#JsDirectChallengeBtn");
        if (!btn.checked)
            return;
        const elAvatar = $.GetContextPanel().FindChildInLayoutFile('JsDirectChallengeAvatar');
        if (!elAvatar) {
            $.Schedule(0.1, () => _SetDirectChallengeIcons(type, id));
            return;
        }
        elAvatar.PopulateFromSteamID(id);
        if (!type || !id) {
            elAvatar.SetPanelEvent('onactivate', () => { });
        }
        switch (type) {
            case 'u':
                _AddOpenPlayerCardAction(elAvatar, id);
                break;
            case 'g':
                _AddGoToClanPageAction(elAvatar, id);
                break;
        }
    }
    function _AddGoToClanPageAction(elAvatar, id) {
        elAvatar.SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser("https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/gid/" + id);
        });
    }
    function _GetDirectChallengeKey() {
        return m_challengeKey;
    }
    function _OnDirectChallengeRandom() {
        UiToolkitAPI.ShowGenericPopupOkCancel($.Localize('#DirectChallenge_CreateNewKey2'), $.Localize('#DirectChallenge_CreateNewKeyMsg'), '', () => {
            _SetDirectChallengeKey(CompetitiveMatchAPI.GenerateDirectChallengeCode());
            _ApplySessionSettings();
        }, () => { });
    }
    function _GetChallengeKeyType(key) {
        const oReturn = { value: [] };
        if (_IsChallengeKeyValid(key.toUpperCase(), oReturn, '')) {
            return oReturn.value[2]; // u for user, g for group
        }
        else {
            return '';
        }
    }
    function _OnDirectChallengeEdit() {
        const submitCallback = UiToolkitAPI.RegisterJSCallback((value) => {
            _SetDirectChallengeKey(value.toUpperCase());
            _ApplySessionSettings();
            StartSearch();
        });
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_directchallenge_join.xml', '&' + 'submitCallback=' + submitCallback);
    }
    function _OnDirectChallengeCopy() {
        SteamOverlayAPI.CopyTextToClipboard(_GetDirectChallengeKey());
        UiToolkitAPI.ShowTextTooltip('CopyChallengeKey', '#DirectChallenge_Copied2');
    }
    function _IsChallengeKeyValid(key, oReturn = { string: [] }, how = '') {
        const code = CompetitiveMatchAPI.ValidateDirectChallengeCode(key, how);
        const bValid = (typeof code === 'string') && code.includes(',');
        if (bValid) {
            oReturn.value = code.split(',');
        }
        return bValid;
    }
    function _DirectChallengeStartSearch() {
        const oReturn = { value: [] };
        const bValid = _IsChallengeKeyValid(m_challengeKey.toUpperCase(), oReturn, 'set');
        if (!bValid) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'mainmenu_press_GO', 'MOUSE');
            return;
        }
        _OnPrivateQueuesUpdate();
        LobbyAPI.StartMatchmaking('', oReturn.value[0], oReturn.value[1], '1');
    }
    function _NoMapSelectedPopup() {
        //No connection to GC so show a message
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#no_maps_selected_title'), $.Localize('#no_maps_selected_text'), '', () => { });
    }
    function _SetGameModeRadioButtonAvailableTooltip(gameMode, isAvailable, txtTooltip) {
        const elGameModeSelectionRadios = $('#GameModeSelectionRadios');
        const elTab = elGameModeSelectionRadios ? elGameModeSelectionRadios.FindChildInLayoutFile(gameMode) : null;
        if (elTab) {
            if (!isAvailable && txtTooltip) {
                let targetLevel = 2;
                let showbar = true;
                if (gameMode === 'premier') {
                    targetLevel = 10;
                    if (!MyPersonaAPI.IsConnectedToGC()) {
                        txtTooltip += '_nogcconnection';
                        showbar = false;
                    }
                    else if (MyPersonaAPI.GetElevatedState() !== 'elevated') {
                        txtTooltip += '_nonprime';
                        showbar = false;
                    }
                    else if (TournamentsAPI.IsPremierSeasonOffseason()) {
                        txtTooltip += '_offseason';
                        showbar = false;
                    }
                }
                elTab.SetPanelEvent('onmouseover', () => {
                    UiToolkitAPI.ShowCustomLayoutParametersTooltip(elTab.id, 'GamemodesLockedneedPrime', 'file://{resources}/layout/tooltips/tooltip_title_progressbar.xml', 'titletext=' + '#PlayMenu_unavailable_locked_mode_title' +
                        '&' + 'bodytext=' + txtTooltip +
                        '&' + 'usexp=' + 'true' +
                        '&' + 'targetlevel=' + targetLevel +
                        '&' + 'showbar=' + (showbar ? 'true' : 'false'));
                });
                elTab.SetPanelEvent('onmouseout', () => {
                    UiToolkitAPI.HideCustomLayoutTooltip('GamemodesLockedneedPrime');
                });
            }
            else {
                elTab.SetPanelEvent('onmouseover', () => { });
                elTab.SetPanelEvent('onmouseout', () => { });
            }
        }
    }
    function _SetGameModeRadioButtonVisible(gameMode, isVisible) {
        const elGameModeSelectionRadios = $('#GameModeSelectionRadios');
        const elTab = elGameModeSelectionRadios ? elGameModeSelectionRadios.FindChildInLayoutFile(gameMode) : null;
        if (elTab) {
            elTab.visible = isVisible;
        }
    }
    function _IsGameModeAvailable(serverType, gameMode) {
        let isAvailable = true;
        if (gameMode === "cooperative" || gameMode === "coopmission") {
            _SetGameModeRadioButtonVisible(gameMode, false);
            return false;
        }
        else if (m_gameModeConfigs[gameMode] &&
            _GetAvailableMapGroups(gameMode, _IsValveOfficialServer(serverType)).length == 0) {
            _SetGameModeRadioButtonAvailableTooltip(gameMode, false, '');
            return false;
        }
        // Rest of this flow deals with disabled/enabled buttons for Private Rank 2
        if (_IsValveOfficialServer(serverType) && // possibly disable the game modes for all matchmaking, for now disable them in official only
            LobbyAPI.BIsHost()) {
            // new user experimental funneling
            // end result : unrestricted mode is best, default to casual
            //
            // Make sure this code matches :: uicomponent_settings.cpp
            // UI_SETTINGS_CVAR_ALIAS_WITH_GET_FILTER_FUNC( ui_playsettings_mode_official
            //
            if (gameMode === 'premier') {
                isAvailable = ((MyPersonaAPI.GetElevatedState() === 'elevated') &&
                    (MyPersonaAPI.HasPrestige() || MyPersonaAPI.GetCurrentLevel() >= 10)) &&
                    !TournamentsAPI.IsPremierSeasonOffseason();
            }
            else if (MyPersonaAPI.HasPrestige()) {
                isAvailable = true;
            }
            else if (MyPersonaAPI.GetCurrentLevel() < 2) // check user is at least Private Rank 2
             {
                isAvailable = (gameMode == 'deathmatch' || gameMode == 'casual' || gameMode == 'gungameprogressive' || gameMode == 'retakes');
            }
        }
        else if (!_IsValveOfficialServer(serverType)) {
            (isAvailable = (gameMode != 'premier'));
        }
        // Must always call this function to manage enabled state in order to turn off the tooltip
        _SetGameModeRadioButtonAvailableTooltip(gameMode, isAvailable, _IsPlayingOnValveOfficial() ? '#PlayMenu_unavailable_newuser_2' : '');
        return isAvailable;
    }
    function _GetTournamentOpponent() {
        const elTeamDropdown = $.GetContextPanel().FindChildInLayoutFile('TournamentTeamDropdown');
        if (elTeamDropdown.GetSelected() === null)
            return '';
        return elTeamDropdown.GetSelected().GetAttributeString('data', '');
    }
    function _GetTournamentStage() {
        const elStageDropdown = $.GetContextPanel().FindChildInLayoutFile('TournamentStageDropdown');
        if (elStageDropdown.GetSelected() === null)
            return '';
        return elStageDropdown.GetSelected().GetAttributeString('data', '');
    }
    function _UpdateStartSearchBtn(isSearchingForTournament) {
        const btnStartSearch = $.GetContextPanel().FindChildInLayoutFile('StartMatchBtn');
        btnStartSearch.enabled = isSearchingForTournament ? (_GetTournamentOpponent() != '' && _GetTournamentStage() != '') : true;
    }
    function _UpdateTournamentButton(isHost) {
        const bIsOfficialCompetitive = _RealGameMode() === "competitive" && _IsPlayingOnValveOfficial();
        const strTeamName = MyPersonaAPI.GetMyOfficialTeamName();
        const strTournament = MyPersonaAPI.GetMyOfficialTournamentName();
        const isInTournament = isHost && strTeamName != "" && strTournament != "";
        $.GetContextPanel().SetHasClass("play-menu__tournament", isInTournament);
        const isSearchingForTournament = bIsOfficialCompetitive && isInTournament;
        const elTeamDropdown = $.GetContextPanel().FindChildInLayoutFile('TournamentTeamDropdown');
        const elStageDropdown = $.GetContextPanel().FindChildInLayoutFile('TournamentStageDropdown');
        if (isInTournament) {
            function AddDropdownOption(elDropdown, entryID, strText, strData, strSelectedData) {
                const newEntry = $.CreatePanel('Label', elDropdown, entryID, { data: strData });
                newEntry.text = strText;
                elDropdown.AddOption(newEntry);
                // set selected
                if (strSelectedData === strData) {
                    elDropdown.SetSelected(entryID);
                }
            }
            const strCurrentOpponent = _GetTournamentOpponent();
            const strCurrentStage = _GetTournamentStage();
            // generate team dropdown
            elTeamDropdown.RemoveAllOptions();
            AddDropdownOption(elTeamDropdown, 'PickOpponent', $.Localize('#SFUI_Tournament_Pick_Opponent'), '', strCurrentOpponent);
            const teamCount = CompetitiveMatchAPI.GetTournamentTeamCount(strTournament);
            for (let i = 0; i < teamCount; i++) {
                const strTeam = CompetitiveMatchAPI.GetTournamentTeamNameByIndex(strTournament, i);
                // don't need to add your own team
                if (strTeamName === strTeam)
                    continue;
                AddDropdownOption(elTeamDropdown, 'team_' + i, strTeam, strTeam, strCurrentOpponent);
            }
            elTeamDropdown.SetPanelEvent('oninputsubmit', () => _UpdateStartSearchBtn(isSearchingForTournament));
            // generate stage dropdown
            elStageDropdown.RemoveAllOptions();
            AddDropdownOption(elStageDropdown, 'PickStage', $.Localize('#SFUI_Tournament_Stage'), '', strCurrentStage);
            const stageCount = CompetitiveMatchAPI.GetTournamentStageCount(strTournament);
            for (let i = 0; i < stageCount; i++) {
                const strStage = CompetitiveMatchAPI.GetTournamentStageNameByIndex(strTournament, i);
                AddDropdownOption(elStageDropdown, 'stage_' + i, strStage, strStage, strCurrentStage);
            }
            elStageDropdown.SetPanelEvent('oninputsubmit', () => _UpdateStartSearchBtn(isSearchingForTournament));
        }
        elTeamDropdown.enabled = isSearchingForTournament;
        elStageDropdown.enabled = isSearchingForTournament;
        _UpdateStartSearchBtn(isSearchingForTournament);
        _ShowActiveMapSelectionTab(!isSearchingForTournament);
    }
    function _SyncDialogsFromSessionSettings(settings) {
        if (!settings || !settings.game || !settings.system) {
            return;
        }
        m_serverSetting = settings.options.server;
        m_gameModeSetting = settings.game.mode_ui;
        $.GetContextPanel().SetHasClass('premier', m_gameModeSetting === 'premier');
        _SetDirectChallengeKey(settings.options.hasOwnProperty('challengekey') ? settings.options.challengekey : '');
        _setAndSaveGameModeFlags(parseInt(settings.game.gamemodeflags));
        // add the mode and server to the root as a class so we can branch css
        $.GetContextPanel().SwitchClass("gamemode", m_isWorkshop ? "workshop" : _RealGameMode());
        $.GetContextPanel().SwitchClass("serversetting", m_serverSetting);
        $.GetContextPanel().SetHasClass("directchallenge", inDirectChallenge());
        // Figure out if this refers to a single skirmish tab
        m_singleSkirmishMapGroup = null;
        if (m_gameModeSetting === 'skirmish' && settings.game.mapgroupname && m_arrSingleSkirmishMapGroups.includes(settings.game.mapgroupname)) {
            m_singleSkirmishMapGroup = settings.game.mapgroupname;
        }
        const isHost = LobbyAPI.BIsHost();
        const isSearching = _IsSearching();
        const isEnabled = !isSearching && isHost ? true : false;
        const elPlayCommunity = $('#PlayCommunity');
        elPlayCommunity.enabled = !isSearching;
        if (m_isWorkshop) {
            _SwitchToWorkshopTab(isEnabled);
            _SelectMapButtonsFromSettings(settings);
        }
        else if (m_gameModeSetting) {
            // Set game mode radio to current game mode
            for (let i = 0; i < m_arrGameModeRadios.length; ++i) {
                const strGameModeForButton = m_arrGameModeRadios[i].id;
                // set tab index to the currently selected mode
                if (inDirectChallenge()) {
                    m_arrGameModeRadios[i].checked = m_arrGameModeRadios[i].id === 'JsDirectChallengeBtn';
                }
                else if (m_singleSkirmishMapGroup) {
                    if (_IsSingleSkirmishString(strGameModeForButton)) {
                        if (m_singleSkirmishMapGroup === _GetSingleSkirmishMapGroupFromSingleSkirmishString(strGameModeForButton)) {
                            m_arrGameModeRadios[i].checked = true;
                        }
                    }
                }
                else if (!_IsSingleSkirmishString(strGameModeForButton)) {
                    if (strGameModeForButton === m_gameModeSetting) {
                        m_arrGameModeRadios[i].checked = true;
                    }
                }
                if (strGameModeForButton === 'competitive' || strGameModeForButton === 'scrimcomp2v2') {
                    const bHide = GameInterfaceAPI.GetSettingString('ui_show_unlock_competitive_alert') === '1' ||
                        MyPersonaAPI.HasPrestige() ||
                        MyPersonaAPI.GetCurrentLevel() !== 2 ||
                        !_IsPlayingOnValveOfficial();
                    if (m_arrGameModeRadios[i].FindChildInLayoutFile('GameModeAlert')) {
                        m_arrGameModeRadios[i].FindChildInLayoutFile('GameModeAlert').SetHasClass('hidden', bHide);
                    }
                }
                // if you are a client or searching, or if the mode isn't allowed, disable the button
                const isAvailable = _IsGameModeAvailable(m_serverSetting, strGameModeForButton);
                m_arrGameModeRadios[i].enabled = isAvailable && isEnabled;
                m_arrGameModeRadios[i].SetHasClass('locked', !isAvailable || !isEnabled);
            }
            // We may have changed active radio above, refresh mapgroup buttons
            _UpdateMapGroupButtons(isEnabled, isSearching, isHost);
            // For Survival we the GC selects the game mode so.
            _CancelRotatingMapGroupSchedule();
            if (settings.game.mode === "survival") {
                _GetRotatingMapGroupStatus(_RealGameMode(), m_singleSkirmishMapGroup, settings.game.mapgroupname);
            }
            _SelectMapButtonsFromSettings(settings);
        }
        else {
            // Default first radio to checked when we don't yet have
            // a game mode sent by session settings. This should be corrected in
            // later session updates but we need some default check to avoid JS errors.
            m_arrGameModeRadios[0].checked = true;
        }
        _ShowHideStartSearchBtn(isSearching, isHost);
        _ShowCancelSearchButton(isSearching, isHost);
        // Update tournament button
        _UpdateTournamentButton(isHost);
        // Set prime button
        _UpdatePrimeBtn(isSearching, isHost);
        _UpdatePermissionBtnText(settings, isEnabled);
        _UpdatePracticeSettingsBtns(isSearching, isHost);
        // Update LeaderBoards button
        _UpdateLeaderboardBtn(m_gameModeSetting);
        // Update Survival Auto-Fill Squad button
        _UpdateSurvivalAutoFillSquadBtn(m_gameModeSetting);
        _UpdateRushFriendLeaderboards(m_gameModeSetting);
        //update play type radio
        _SelectActivePlayPlayTypeBtn();
        // _UpdateTopNavRadioBtns();
        // Update Replay New User Training button
        _UpdateReplayNewUserTrainingBtn(m_gameModeSetting);
        //_UpdateBotDifficultyButton();
        _UpdateDirectChallengePage(isSearching, isHost);
        _UpdateGameModeFlagsBtn();
        const elPlayTypeNav = $('#PlayTypeTopNav');
        const aPlayTypeBtns = elPlayTypeNav.Children();
        const bIsTopNavBtsEnabled = IsTopNavBtsEnabled();
        aPlayTypeBtns.forEach(btn => btn.enabled = bIsTopNavBtsEnabled);
        _SetClientViewLobbySettingsTitle(isHost);
        function IsTopNavBtsEnabled() {
            if (_IsPlayingOnValveOfficial() &&
                (m_gameModeSetting === "cooperative" || m_gameModeSetting === "coopmission"))
                return false;
            else
                return isEnabled;
        }
        _OnPrivateQueuesUpdate();
        _PipRankUpdate();
    }
    function _UpdateDirectChallengePage(isSearching = false, isHost = true) {
        const elBtn = $('#JsDirectChallengeBtn');
        elBtn.enabled = (m_serverSetting === "official") && !m_isWorkshop ? true : false;
        if (m_serverSetting !== "official" || m_isWorkshop) {
            return;
        }
        const fnEnableKey = (id, bEnable) => { const p = $(id); if (p)
            p.enabled = bEnable; };
        const bEnable = !isSearching && isHost;
        fnEnableKey("#RandomChallengeKey", bEnable);
        fnEnableKey("#EditChallengeKey", bEnable);
        fnEnableKey("#ClanChallengeKey", bEnable);
        fnEnableKey("#JsDirectChallengeBtn", bEnable && (MyPersonaAPI.HasPrestige() || (MyPersonaAPI.GetCurrentLevel() >= 2)));
    }
    function _OnClanChallengeKeySelected(key) {
        _SetDirectChallengeKey(key);
        _ApplySessionSettings();
        StartSearch();
    }
    function _OnChooseClanKeyBtn() {
        if (MyPersonaAPI.GetMyClanCount() == 0) {
            UiToolkitAPI.ShowGenericPopupThreeOptions('#DirectChallenge_no_steamgroups', '#DirectChallenge_no_steamgroups_desc', '', '#DirectChallenge_create_steamgroup', () => {
                SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser("https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/actions/GroupCreate");
            }, '#DirectChallenge_openurl2', () => {
                SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser("https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/search/groups");
            }, '#UI_OK', () => { });
            return;
        }
        const clanKey = _GetChallengeKeyType(m_challengeKey) == 'g' ? m_challengeKey : '';
        const elClanSelector = UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup_directchallenge_steamgroups', 'file://{resources}/layout/popups/popup_directchallenge_steamgroups.xml', 'currentkey=' + clanKey);
        elClanSelector.AddClass("ContextMenu_NoArrow");
    }
    function _CreatePlayerTile(elTile, xuid, delay = 0) {
        $.Msg("DC _CreatePlayerTile ( " + elTile.id + ", " + xuid + " )");
        elTile.BLoadLayout('file://{resources}/layout/simple_player_tile.xml', false, false);
        // This gives the panel enough time to load so we call the init
        $.Schedule(.1, () => {
            if (!elTile || !elTile.IsValid())
                return;
            const elAvatar = elTile.FindChildTraverse('JsAvatarImage');
            elAvatar.PopulateFromSteamID(xuid);
            const strName = FriendsListAPI.GetFriendName(xuid);
            elTile.SetDialogVariable('player_name', strName);
            _AddOpenPlayerCardAction(elTile, xuid);
            Scheduler.Schedule(delay, () => {
                if (elTile && elTile.IsValid())
                    elTile.RemoveClass('hidden');
            }, "directchallenge");
        });
    }
    function _OnPlayerNameChangedUpdate(xuid) {
        $.Msg("MainMenuPlay :: _OnPlayerNameChangedUpdate " + xuid);
        let strName = null;
        const strCodeXuid = $.GetContextPanel().GetAttributeString('code-xuid', '');
        if (strCodeXuid === xuid) {
            if (!strName) // cached resolve
                strName = FriendsListAPI.GetFriendName(xuid);
            $.GetContextPanel().SetDialogVariable('code-source', strName);
        }
        const elMembersContainer = $('#DirectChallengeQueueMembers');
        if (!elMembersContainer)
            return;
        const elUserTile = elMembersContainer.FindChildTraverse(xuid);
        if (!elUserTile)
            return;
        if (!strName) // cached resolve
            strName = FriendsListAPI.GetFriendName(xuid);
        elUserTile.SetDialogVariable('player_name', strName);
        $.Msg("MainMenuPlay :: _OnPlayerNameChangedUpdate :: UPDATED " + strName);
    }
    function _GetPartyID(partyXuid, arrMembers = []) {
        let partyId = '';
        const partySize = PartyBrowserAPI.GetPartyMembersCount(partyXuid);
        for (let j = 0; j < partySize; j++) {
            const memberXuid = PartyBrowserAPI.GetPartyMemberXuid(partyXuid, j);
            partyId += '_' + memberXuid;
            arrMembers.push(memberXuid);
        }
        return partyId;
    }
    function _OnPrivateQueuesUpdate() {
        $.Msg("DC _OnPrivateQueuesUpdate");
        const elMembersContainer = $.GetContextPanel().FindChildTraverse('DirectChallengeQueueMembers');
        if (!elMembersContainer)
            return;
        const elExplanation = $("#id-directchallenge-explanation");
        if (elExplanation)
            elExplanation.SetHasClass('hidden', _IsSearching());
        const elQueueMembers = $("#id-directchallenge-status__queue-members");
        if (elQueueMembers)
            elQueueMembers.SetHasClass('hidden', !_IsSearching());
        // not searching, clear the display and exit
        if (!_IsSearching()) {
            Scheduler.Cancel("directchallenge");
            const elStatus = $('#id-directchallenge-status');
            if (elStatus)
                elStatus.text = '';
            if (elMembersContainer)
                elMembersContainer.RemoveAndDeleteChildren();
            return;
        }
        const NumberOfParties = PartyBrowserAPI.GetPrivateQueuesCount();
        const NumberOfPlayers = PartyBrowserAPI.GetPrivateQueuesPlayerCount();
        const NumberOfMorePartiesNotShown = PartyBrowserAPI.GetPrivateQueuesMoreParties();
        // set the status line
        const elStatus = $('#id-directchallenge-status');
        if (elStatus) {
            $.GetContextPanel().SetDialogVariableInt('directchallenge_players', NumberOfPlayers);
            $.GetContextPanel().SetDialogVariableInt('directchallenge_moreparties', NumberOfMorePartiesNotShown);
            let strStatus = $.Localize(LobbyAPI.GetMatchmakingStatusString());
            if (NumberOfParties > 0) {
                strStatus += "\t";
                strStatus += $.Localize((NumberOfMorePartiesNotShown > 0) ? "#DirectChallenge_SearchingMembersAndMoreParties2" : "#DirectChallenge_SearchingMembersLabel2", $.GetContextPanel());
            }
            elStatus.text = strStatus;
        }
        // Mark children for sweep
        for (let child of elMembersContainer.Children()) {
            $.Msg("DC Marking party " + child.id + " for delete");
            child.SetAttributeInt("marked_for_delete", 1);
        }
        let delay = 0;
        for (let i = NumberOfParties; i-- > 0;) {
            const DELAY_INCREMENT = 0.25;
            const arrMembers = [];
            const partyXuid = PartyBrowserAPI.GetPrivateQueuePartyXuidByIndex(i);
            const partyId = _GetPartyID(partyXuid, arrMembers) /*+ h*/;
            let elParty = elMembersContainer.FindChild(partyId);
            if (!elParty) {
                elParty = $.CreatePanel('Panel', elMembersContainer, partyId, { class: 'directchallenge__party hidden' });
                elParty.SetHasClass('multi', arrMembers.length > 1);
                elMembersContainer.MoveChildBefore(elParty, elMembersContainer.Children()[0]);
                elParty.SetAttributeString("xuid", partyXuid);
                $.Msg("DC Creating party " + partyXuid + " " + partyId);
                Scheduler.Schedule(delay, () => {
                    if (elParty && elParty.IsValid())
                        elParty.RemoveClass('hidden');
                }, "directchallenge");
                //make tiles for the party members
                for (let xuid of arrMembers) {
                    if (elParty) {
                        const elTile = $.CreatePanel('Panel', elParty, xuid /*+ u*/, { class: "directchallenge__party__member" });
                        _CreatePlayerTile(elTile, xuid, delay);
                    }
                    delay += DELAY_INCREMENT;
                }
            }
            else {
                $.Msg("DC found party " + elParty.id + " " + _GetPartyID(partyXuid) + " and flagging it to keep");
            }
            elParty.SetAttributeInt("marked_for_delete", 0);
        }
        // now remove parties that are no longer in the queue
        for (let child of elMembersContainer.Children()) {
            if (child.GetAttributeInt("marked_for_delete", 0) !== 0) {
                $.Msg("DC deleting party " + child.id + " because it's marked for delete");
                child.DeleteAsync(0.0);
            }
        }
    }
    function _SetClientViewLobbySettingsTitle(isHost) {
        const elPanel = $.GetContextPanel().FindChildInLayoutFile('play-lobby-leader-panel');
        if (!elPanel || !elPanel.IsValid()) {
            return;
        }
        if (isHost) {
            elPanel.visible = false;
            return;
        }
        elPanel.visible = true;
        const elTitle = elPanel.FindChildInLayoutFile('play-lobby-leader-text');
        const xuid = PartyListAPI.GetPartySystemSetting("xuidHost");
        const leaderName = FriendsListAPI.GetFriendName(xuid);
        elTitle.text = leaderName;
        const elAvatar = elPanel.FindChildInLayoutFile('lobby-leader-avatar');
        elAvatar.PopulateFromSteamID(xuid);
    }
    function _GetAvailableMapGroups(gameMode, isPlayingOnValveOfficial) {
        // bad gameMode, return empty array
        const gameModeCfg = m_gameModeConfigs[gameMode];
        if (gameModeCfg === undefined)
            return [];
        const mapgroup = isPlayingOnValveOfficial ? gameModeCfg.mapgroupsMP : gameModeCfg.mapgroupsSP;
        if (mapgroup !== undefined && mapgroup !== null) {
            // remove premier
            delete mapgroup['mg_lobby_mapveto'];
            return Object.keys(mapgroup);
        }
        return [];
    }
    function _GetMapGroupPanelID() {
        if (inDirectChallenge()) {
            return "gameModeButtonContainer_directchallenge";
        }
        else if (m_gameModeSetting === 'premier') {
            return "gameModeButtonContainer_premier";
        }
        const gameModeId = _RealGameMode() + (m_singleSkirmishMapGroup ? '@' + m_singleSkirmishMapGroup : '');
        const panelID = 'gameModeButtonContainer_' + gameModeId + '_' + m_serverSetting;
        return panelID;
    }
    function _OnActivateMapOrMapGroupButton(mapgroupButton) {
        const mapGroupNameClicked = mapgroupButton.GetAttributeString("mapname", '');
        if ($.GetContextPanel().BHasClass('play-menu__lobbymapveto_activated') && mapGroupNameClicked !== 'mg_lobby_mapveto') { // don't allow clicking mapgroups if lobby map veto is activated
            return;
        }
        if (mapgroupButton.checked) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'submenu_leveloptions_select', 'MOUSE');
        }
        else {
            $.DispatchEvent('CSGOPlaySoundEffect', 'submenu_leveloptions_deselect', 'MOUSE');
        }
        // Special check for the sibling button between unranked scrimmage and ranked to uncheck the sibling
        let mapGroupName = mapGroupNameClicked;
        if (mapGroupName) {
            const siblingSuffix = '_scrimmagemap';
            if (mapGroupName.toLowerCase().endsWith(siblingSuffix))
                mapGroupName = mapGroupName.substring(0, mapGroupName.length - siblingSuffix.length);
            else
                mapGroupName = mapGroupName + siblingSuffix;
            // Traverse the two-tiered children
            let elParent = mapgroupButton.GetParent();
            if (elParent)
                elParent = elParent.GetParent();
            if (elParent && elParent.GetAttributeString('hassections', '')) {
                for (let section of elParent.Children()) {
                    for (let tile of section.Children()) {
                        const mapGroupNameSibling = tile.GetAttributeString("mapname", '');
                        if (mapGroupNameSibling.toLowerCase() === mapGroupName.toLowerCase()) { // uncheck the sibling tile
                            tile.checked = false;
                        }
                    }
                }
            }
        }
        _MatchMapSelectionWithQuickSelect();
        if (_CheckContainerHasAnyChildChecked(_GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID))) {
            _ApplySessionSettings();
        }
    }
    function _ShowActiveMapSelectionTab(isEnabled) {
        const panelID = m_activeMapGroupSelectionPanelID;
        for (const key in m_mapSelectionButtonContainers) {
            const elButtonContainer = m_mapSelectionButtonContainers[key];
            // Skip the first transition
            if (!m_bDidShowActiveMapSelectionTab) {
                elButtonContainer.AddClass("skip-transition");
            }
            if (key !== panelID) {
                elButtonContainer.AddClass("hidden");
            }
            else {
                // GetSelectedMapButton( key );
                elButtonContainer.RemoveClass("hidden");
                elButtonContainer.visible = true;
                // Disable if you are client or searching
                elButtonContainer.enabled = isEnabled;
            }
            elButtonContainer.RemoveClass("skip-transition");
        }
        const isWorkshop = panelID === k_workshopPanelId;
        $('#WorkshopSearchBar').visible = isWorkshop;
        for (let element of $('#GameModeSelectionRadios').Children()) {
            element.enabled = element.enabled && !isWorkshop && !_IsSearching() && LobbyAPI.BIsHost();
        }
        // also show/hide 'visit workshop' button
        $('#WorkshopVisitButton').visible = isWorkshop;
        $('#WorkshopVisitButton').enabled = SteamOverlayAPI.IsEnabled();
        m_bDidShowActiveMapSelectionTab = true;
    }
    function _GetMapTileContainer() {
        return $.GetContextPanel().FindChildInLayoutFile(_GetMapGroupPanelID());
    }
    function CSGOOpenSteamWorkshop_helper(tag) {
        $.DispatchEvent('CSGOOpenSteamWorkshop', tag);
    }
    PlayMenu.CSGOOpenSteamWorkshop_helper = CSGOOpenSteamWorkshop_helper;
    // toggle all of the maps referenced by this quick selection map group
    function OnMapQuickSelect(mgName) {
        // these are the maps we want to toggle on
        const arrMapsToSelect = _GetMapsFromQuickSelectMapGroup(mgName);
        let bScrolled = false;
        const prevSelection = _GetSelectedMapsForServerTypeAndGameMode(m_serverSetting, _RealGameMode(), true);
        const elMapGroupContainer = _GetMapTileContainer();
        for (let elMapBtn of elMapGroupContainer.Children()) {
            let bFound = false;
            // short circuit the search if we clicked on "all"
            if (mgName === "all") {
                bFound = true;
            }
            else if (mgName === "none") {
                bFound = false;
            }
            else {
                for (let mapname of arrMapsToSelect) {
                    if (elMapBtn.GetAttributeString("mapname", "") == mapname) {
                        bFound = true;
                    }
                }
            }
            elMapBtn.checked = bFound;
            // scroll to the first hit.
            if (bFound && !bScrolled) {
                elMapBtn.ScrollParentToMakePanelFit(2, false);
                bScrolled = true;
            }
        }
        // if we changed any maps...
        const newSelection = _GetSelectedMapsForServerTypeAndGameMode(m_serverSetting, _RealGameMode(), true);
        if (prevSelection != newSelection) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'submenu_leveloptions_select', 'MOUSE');
            // update the highlight state
            _MatchMapSelectionWithQuickSelect();
            if (_CheckContainerHasAnyChildChecked(_GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID))) {
                _ApplySessionSettings();
            }
        }
    }
    PlayMenu.OnMapQuickSelect = OnMapQuickSelect;
    // remove maps that aren't available from the list and return it
    function _ValidateMaps(arrMapList) {
        let arrMapTileNames = [];
        // make an array of current maptile names
        const arrMapButtons = _GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID);
        arrMapButtons.forEach(elMapTile => arrMapTileNames.push(elMapTile.GetAttributeString("mapname", "")));
        // filter the input maplist against the current maptile name list
        const filteredMapList = arrMapList.filter(strMap => arrMapTileNames.includes(strMap));
        return filteredMapList;
    }
    function _GetMapGroupsWithAttribute(strAttribute, strValue) {
        const arrNewMapgroups = [];
        const elMapGroupContainer = _GetMapTileContainer();
        $.Msg("NewMapsArray building from " + elMapGroupContainer.Children().length + " children for " + strAttribute + " = " + strValue);
        for (let elMapBtn of elMapGroupContainer.Children()) {
            const mgName = elMapBtn.GetAttributeString("mapname", "");
            if (GameTypesAPI.GetMapGroupAttribute(mgName, strAttribute) === strValue) {
                $.Msg("NewMapsArray adding " + mgName);
                arrNewMapgroups.push(mgName);
            }
        }
        $.Msg("NewMapsArray built " + arrNewMapgroups.length + " map groups");
        return arrNewMapgroups;
    }
    function _GetMapsFromQuickSelectMapGroup(mgName) {
        if (mgName === ("favorites")) {
            const mapsAsString = GameInterfaceAPI.GetSettingString('ui_playsettings_custom_preset');
            if (mapsAsString === '')
                return [];
            else {
                const arrMapList = mapsAsString.split(',');
                const filteredMapList = _ValidateMaps(arrMapList);
                // save filtered array
                if (arrMapList.length != filteredMapList.length)
                    GameInterfaceAPI.SetSettingString('ui_playsettings_custom_preset', filteredMapList.length > 0 ? filteredMapList.join(',') : "");
                return filteredMapList;
            }
        }
        else if (mgName === "new") {
            return _GetMapGroupsWithAttribute('showtagui', 'new');
        }
        else if (mgName === "hostage") {
            return _GetMapGroupsWithAttribute('icontag', 'hostage');
        }
        else if (mgName === "activeduty") {
            return _GetMapGroupsWithAttribute('grouptype', 'active').filter(x => x !== 'mg_lobby_mapveto');
        }
        else {
            return [];
        }
    }
    // see if any of the quick select buttons matches the current state of selections
    function _MatchMapSelectionWithQuickSelect() {
        // iterate through quick select buttons
        const elQuickSelectContainer = $.GetContextPanel().FindChildInLayoutFile("JsQuickSelectParent");
        if (!elQuickSelectContainer || m_isWorkshop)
            return;
        for (let elQuickBtn of elQuickSelectContainer.FindChildrenWithClassTraverse('preset-button')) {
            // get the maps from the button.
            const arrQuickSelectMaps = _GetMapsFromQuickSelectMapGroup(elQuickBtn.id);
            let bMatch = true;
            // go through all of the maps and compare select state with quickselect
            const elMapGroupContainer = _GetMapTileContainer();
            for (let i = 0; i < elMapGroupContainer.Children().length; i++) {
                const elMapBtn = elMapGroupContainer.Children()[i];
                const mapName = elMapBtn.GetAttributeString("mapname", "");
                if (elQuickBtn.id == "none") {
                    if (elMapBtn.checked) {
                        bMatch = false;
                        break;
                    }
                }
                else if (elQuickBtn.id == "all") {
                    if (!elMapBtn.checked) {
                        bMatch = false;
                        break;
                    }
                }
                else {
                    if (elMapBtn.checked != (arrQuickSelectMaps.includes(mapName))) {
                        bMatch = false;
                        break;
                    }
                }
            }
            elQuickBtn.checked = bMatch;
        }
    }
    function _LazyCreateMapListPanel() {
        const serverType = m_serverSetting;
        const gameMode = _RealGameMode();
        const panelID = _GetMapGroupPanelID();
        if (panelID in m_mapSelectionButtonContainers) {
            let bAllowReuseExistingContainer = true;
            const elExistingContainer = m_mapSelectionButtonContainers[panelID];
            // Also check if we should refresh an embedded leaderboard
            const elFriendLeaderboards = elExistingContainer ? elExistingContainer.FindChildTraverse("FriendLeaderboards") : null;
            if (elFriendLeaderboards) {
                const strEmbeddedLeaderboardName = elFriendLeaderboards.GetAttributeString("type", '');
                if (strEmbeddedLeaderboardName) {
                    LeaderboardsAPI.Refresh(strEmbeddedLeaderboardName);
                }
            }
            if (bAllowReuseExistingContainer)
                return panelID; // we can safely reuse the existing container (most of the time)
            else
                elExistingContainer.DeleteAsync(0.0); // delete old container, and fall through to recreate it
        }
        const container = $.CreatePanel("Panel", $('#MapSelectionList'), panelID, {
            class: 'map-selection-list map-selection-list--inner hidden'
        });
        container.AddClass('map-selection-list--' + serverType + '-' + gameMode);
        $.Msg("LazyCreateMapList added a container: " + gameMode + "/" + serverType + " (panel id = " + panelID + ")");
        m_mapSelectionButtonContainers[panelID] = container;
        // If there is a snippet with the required name, then load it in
        let strSnippetNameOverride;
        if (inDirectChallenge()) {
            strSnippetNameOverride = "MapSelectionContainer_directchallenge";
        }
        else if (m_gameModeSetting === 'premier') {
            strSnippetNameOverride = "MapSelectionContainer_premier";
        }
        else {
            strSnippetNameOverride = "MapSelectionContainer_" + serverType + "_" + gameMode;
        }
        if (container.BHasLayoutSnippet(strSnippetNameOverride)) { // Load the snippet since it exists to override
            $.Msg("LazyCreateMapList loading explicit container snippet: " + gameMode + "/" + serverType + " (panel id = " + panelID + ") = " + strSnippetNameOverride);
            container.BLoadLayoutSnippet(strSnippetNameOverride);
            const elMapTile = container.FindChildTraverse("MapTile");
            if (elMapTile)
                elMapTile.BLoadLayoutSnippet("MapGroupSelection");
        }
        else { // Flag that we didn't load the snippet, so we can use default layout assumptions
            strSnippetNameOverride = '';
        }
        const isPlayingOnValveOfficial = _IsValveOfficialServer(serverType);
        const arrMapGroups = _GetAvailableMapGroups(gameMode, isPlayingOnValveOfficial);
        const numTiles = arrMapGroups.length;
        if (gameMode === 'skirmish' && m_singleSkirmishMapGroup) {
            _UpdateOrCreateMapGroupTile(m_singleSkirmishMapGroup, container, null, panelID + m_singleSkirmishMapGroup, numTiles);
        }
        else {
            arrMapGroups.forEach((item, index, aMapGroups) => {
                if (gameMode === 'skirmish' && m_arrSingleSkirmishMapGroups.includes(aMapGroups[index])) {
                    return;
                }
                let elSectionContainer = null;
                elSectionContainer = container;
                if (strSnippetNameOverride)
                    elSectionContainer = container.FindChildTraverse("MapTile");
                if (elSectionContainer)
                    _UpdateOrCreateMapGroupTile(aMapGroups[index], elSectionContainer, null, panelID + aMapGroups[index], numTiles);
            });
        }
        // Handler that catches OnPropertyTransitionEndEvent event for this panel.
        $.RegisterEventHandler('PropertyTransitionEnd', container, (panel, propertyName) => {
            if (container === panel && propertyName === 'opacity' &&
                !container.id.startsWith("FriendLeaderboards")) {
                // Panel is visible and fully transparent
                if (container.visible === true && container.BIsTransparent()) {
                    container.visible = false;
                    return true;
                }
            }
            return false;
        });
        return panelID;
    }
    function _PopulateQuickSelectBar(isSearching, isHost) {
        $.Msg("---------------------- populating quick select");
        const elQuickSelectContainer = $.GetContextPanel().FindChildInLayoutFile("jsQuickSelectionSetsContainer");
        if (!elQuickSelectContainer)
            return;
        if (m_isWorkshop)
            return;
        _MatchMapSelectionWithQuickSelect();
        _EnableDisableQuickSelectBtns(isSearching, isHost);
    }
    function _EnableDisableQuickSelectBtns(isSearching, isHost) {
        const bEnable = !isSearching && isHost;
        const elQuickSelectContainer = $.GetContextPanel().FindChildInLayoutFile("JsQuickSelectParent");
        elQuickSelectContainer.FindChildrenWithClassTraverse('preset-button').forEach(element => element.enabled = bEnable);
    }
    function SaveMapSelectionToCustomPreset(bSilent = false) {
        // skip if direct challenge mode
        if (inDirectChallenge())
            return;
        //skip if in premier
        if (m_gameModeSetting === 'premier')
            return;
        if (!LobbyAPI.BIsHost())
            return;
        const selectedMaps = _GetSelectedMapsForServerTypeAndGameMode(m_serverSetting, _RealGameMode(), true);
        if (selectedMaps === "") {
            if (!bSilent)
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
            _NoMapSelectedPopup();
            return;
        }
        GameInterfaceAPI.SetSettingString('ui_playsettings_custom_preset', selectedMaps);
        if (!bSilent) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
            $.GetContextPanel().FindChildInLayoutFile("jsQuickSelectionSave").TriggerClass('save');
        }
        _MatchMapSelectionWithQuickSelect();
    }
    PlayMenu.SaveMapSelectionToCustomPreset = SaveMapSelectionToCustomPreset;
    function _GetPanelTypeForMapGroupTile(gameMode, singleSkirmishMapGroup) {
        const bIsCompetitive = gameMode === 'competitive';
        const bIsWingman = gameMode === 'scrimcomp2v2';
        return (((bIsCompetitive || bIsWingman) && _IsValveOfficialServer(m_serverSetting)) ? "ToggleButton" : "RadioButton");
    }
    function _UpdateOrCreateMapGroupTile(mapGroupName, container, elTilePanel, newTileID, numTiles) {
        const mg = GetMGDetails(mapGroupName);
        if (!mg)
            return;
        let p = elTilePanel;
        if (!p) {
            const panelType = _GetPanelTypeForMapGroupTile(_RealGameMode(), m_singleSkirmishMapGroup);
            const panelID = newTileID ? newTileID : (container.id + mapGroupName);
            p = $.CreatePanel(panelType, container, panelID);
            p.BLoadLayoutSnippet("MapGroupSelection");
            if (panelType === "RadioButton") {
                // What is my radio group ID?
                let radioGroupID;
                if (panelID.endsWith(mapGroupName))
                    radioGroupID = panelID.substring(0, panelID.length - mapGroupName.length);
                else
                    radioGroupID = container.id;
                const group = "radiogroup_" + radioGroupID;
                p.SetAttributeString("group", group);
            }
        }
        p.SetAttributeString("mapname", mapGroupName);
        p.SetPanelEvent('onactivate', () => _OnActivateMapOrMapGroupButton(p));
        p.SetHasClass('map-selection-btn-activedutymap', mg.grouptype === 'active');
        p.FindChildInLayoutFile('ActiveGroupIcon').visible = mg.grouptype === 'active';
        p.FindChildInLayoutFile('MapGroupName').text = $.Localize(mg.nameID);
        UpdateIconsAndScreenshots(p, numTiles, mapGroupName, mg);
        return p;
    }
    function _UpdateRatingEmblem(p, mapGroupName) {
        let elRatingEmblem = p.FindChildTraverse('jsRatingEmblem');
        if (!elRatingEmblem || !elRatingEmblem.IsValid())
            return;
        elRatingEmblem.visible = m_serverSetting == 'official' &&
            m_gameModeSetting === 'competitive' &&
            !m_isWorkshop &&
            LobbyAPI.GetSessionSettings() &&
            LobbyAPI.GetSessionSettings().hasOwnProperty('game') &&
            LobbyAPI.GetSessionSettings().game.hasOwnProperty('prime') &&
            LobbyAPI.GetSessionSettings().game.prime;
        let pmso = MyPersonaAPI.GetCompetitivePerMapStatsObject();
        let score = pmso[mapGroupName] ? pmso[mapGroupName]["skillgroup"] : -1;
        let wins = pmso[mapGroupName] ? pmso[mapGroupName]["wins"] : -1;
        let options = {
            root_panel: p,
            //	xuid: MyPersonaAPI.GetXuid(),
            //	api: 'mypersona',
            rating_type: 'Competitive',
            rating_map: mapGroupName,
            full_details: true,
            leaderboard_details: { score: score, matchesWon: wins },
            local_player: true
        };
        RatingEmblem.SetXuid(options);
        let winCountString = RatingEmblem.GetWinCountString(p);
        p.SetDialogVariable('map-win-count', winCountString);
        p.SetHasClass('show-win-count', winCountString != '');
    }
    function UpdateIconsAndScreenshots(p, numTiles, mapGroupName, mg) {
        const keysList = Object.keys(mg.maps);
        const iconSize = 200; // HACK make them big enough so they can be resized
        const iconPath = mapGroupName === 'random_classic' ? 'file://{images}/icons/ui/random_map.svg' : 'file://{images}/' + mg.icon_image_path + '.svg';
        let mapGroupIcon = p.FindChildInLayoutFile('MapSelectionButton').FindChildInLayoutFile('MapGroupCollectionIcon');
        if (keysList.length < 2) {
            if (mapGroupIcon) {
                mapGroupIcon.SetImage(iconPath);
            }
            else {
                mapGroupIcon = $.CreatePanel('Image', p.FindChildInLayoutFile('MapSelectionButton'), 'MapGroupCollectionIcon', {
                    defaultsrc: 'file://{images}/icons/ui/random_map.svg',
                    texturewidth: iconSize,
                    textureheight: iconSize,
                    src: iconPath,
                    class: 'map-selection-btn__map-icon'
                });
                p.FindChildInLayoutFile('MapSelectionButton').MoveChildBefore(mapGroupIcon, p.FindChildInLayoutFile('MapGroupCollectionMultiIcons'));
            }
        }
        let mapImage = null;
        let mapIcon = null;
        if (mapGroupName === 'random_classic') {
            mapImage = p.FindChildInLayoutFile('MapGroupImagesCarousel').FindChildInLayoutFile('MapSelectionScreenshot');
            if (!mapImage) {
                mapImage = $.CreatePanel('Panel', p.FindChildInLayoutFile('MapGroupImagesCarousel'), 'MapSelectionScreenshot');
                mapImage.AddClass('map-selection-btn__screenshot');
            }
            mapImage.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/360p/random.png")';
            mapImage.style.backgroundPosition = '50% 0%';
            mapImage.style.backgroundSize = 'auto 100%';
        }
        _SetMapGroupModifierLabelElements(mapGroupName, p);
        // Add map images to carousel.
        for (let i = 0; i < keysList.length; i++) {
            mapImage = p.FindChildInLayoutFile('MapGroupImagesCarousel').FindChildInLayoutFile('MapSelectionScreenshot' + i);
            if (!mapImage) {
                mapImage = $.CreatePanel('Panel', p.FindChildInLayoutFile('MapGroupImagesCarousel'), 'MapSelectionScreenshot' + i);
                mapImage.AddClass('map-selection-btn__screenshot');
            }
            if (m_gameModeSetting === 'survival' || m_gameModeSetting === 'rush') {
                mapImage.style.backgroundImage = 'url("file://{resources}/videos/' + keysList[i] + '_preview.webm")';
            }
            else {
                mapImage.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/720p/' + keysList[i] + '.png")';
            }
            mapImage.style.backgroundPosition = '50% 0%';
            mapImage.style.backgroundSize = 'auto 100%';
            // This is for map groups icons
            if (keysList.length > 1) {
                const mapIconsContainer = p.FindChildInLayoutFile('MapGroupCollectionMultiIcons');
                mapIconsContainer.SetHasClass('left-right-flow-wrap', numTiles === 1);
                mapIconsContainer.SetHasClass('top-bottom-flow-wrap', numTiles > 1);
                const subMapIconImagePanelID = 'MapIcon' + i;
                mapIcon = mapIconsContainer.FindChildInLayoutFile(subMapIconImagePanelID);
                if (!mapIcon) {
                    mapIcon = $.CreatePanel('Image', mapIconsContainer, subMapIconImagePanelID, {
                        defaultsrc: 'file://{images}/map_icons/map_icon_NONE.png',
                        texturewidth: iconSize,
                        textureheight: iconSize,
                        src: 'file://{images}/map_icons/map_icon_' + keysList[i] + '.svg'
                    });
                }
                mapIcon.AddClass('map-selection-btn__map-icon');
                IconUtil.SetupFallbackMapIcon(mapIcon, 'file://{images}/map_icons/map_icon_' + keysList[i]);
            }
        }
        // Tooltip
        if (mg.tooltipID) {
            let pid = p.id;
            let tooltipID = mg.tooltipID;
            p.SetPanelEvent('onmouseover', () => OnMouseOverMapTile(pid, tooltipID, keysList));
            p.SetPanelEvent('onmouseout', OnMouseOutMapTile);
        }
    }
    function OnMouseOverMapTile(id, tooltipText, mapsList) {
        tooltipText = $.Localize(tooltipText);
        const mapNamesList = [];
        if (mapsList.length > 1) {
            for (let element of mapsList) {
                mapNamesList.push($.Localize('#SFUI_Map_' + element));
            }
            const mapGroupsText = mapNamesList.join(', ');
            tooltipText = tooltipText + '<br><br>' + mapGroupsText;
        }
        UiToolkitAPI.ShowTextTooltip(id, tooltipText);
    }
    function OnMouseOutMapTile() {
        UiToolkitAPI.HideTextTooltip();
    }
    let m_timerMapGroupHandler = null;
    function _GetRotatingMapGroupStatus(gameMode, singleSkirmishMapGroup, mapgroupname) {
        m_timerMapGroupHandler = null;
        const strSchedule = CompetitiveMatchAPI.GetRotatingOfficialMapGroupCurrentState(gameMode);
        const elTimer = m_mapSelectionButtonContainers[m_activeMapGroupSelectionPanelID].FindChildInLayoutFile('PlayMenuMapRotationTimer');
        if (elTimer) {
            if (strSchedule) {
                const strCurrentMapGroup = strSchedule.split("+")[0];
                const numSecondsRemaining = strSchedule.split("+")[1].split("=")[0];
                const strNextMapGroup = strSchedule.split("=")[1];
                const numWait = FormatText.SecondsToDDHHMMSSWithSymbolSeperator(numSecondsRemaining);
                if (!numWait) {
                    elTimer.AddClass('hidden');
                    return;
                }
                elTimer.RemoveClass('hidden');
                elTimer.SetDialogVariable('map-rotate-timer', numWait);
                const mg = GetMGDetails(strNextMapGroup);
                elTimer.SetDialogVariable('next-mapname', $.Localize(mg.nameID));
                // Find the existing map panel.
                // When the we switch maps recreate the map tile with the appropriate strCurrentMapGroup content.
                const mapGroupPanelID = _GetMapGroupPanelID() + strCurrentMapGroup;
                const mapGroupContainer = m_mapSelectionButtonContainers[m_activeMapGroupSelectionPanelID].FindChildTraverse('MapTile');
                const mapGroupPanel = mapGroupContainer.FindChildInLayoutFile(mapGroupPanelID);
                if (!mapGroupPanel) {
                    mapGroupContainer.RemoveAndDeleteChildren();
                    const btnMapGroup = _UpdateOrCreateMapGroupTile(strCurrentMapGroup, mapGroupContainer, null, mapGroupPanelID, 1);
                    // Since this is the only map group in the survival category then select it.
                    btnMapGroup.checked = true;
                    _UpdateSurvivalAutoFillSquadBtn(m_gameModeSetting);
                }
                m_timerMapGroupHandler = $.Schedule(1, () => _GetRotatingMapGroupStatus(gameMode, singleSkirmishMapGroup, mapgroupname));
            }
            else {
                elTimer.AddClass('hidden');
            }
        }
    }
    function _StartRotatingMapGroupTimer() {
        _CancelRotatingMapGroupSchedule();
        const activeMapGroup = m_activeMapGroupSelectionPanelID;
        if (_RealGameMode() === "survival"
            && m_mapSelectionButtonContainers && m_mapSelectionButtonContainers[activeMapGroup]
            && m_mapSelectionButtonContainers[activeMapGroup].Children()) {
            const btnSelectedMapGroup = m_mapSelectionButtonContainers[activeMapGroup].Children().filter(entry => entry.GetAttributeString('mapname', '') !== '');
            if (btnSelectedMapGroup[0]) {
                const mapSelectedGroupName = btnSelectedMapGroup[0].GetAttributeString('mapname', '');
                if (mapSelectedGroupName) {
                    _GetRotatingMapGroupStatus(_RealGameMode(), m_singleSkirmishMapGroup, mapSelectedGroupName);
                }
            }
        }
    }
    function _CancelRotatingMapGroupSchedule() {
        if (m_timerMapGroupHandler) {
            $.CancelScheduled(m_timerMapGroupHandler);
            m_timerMapGroupHandler = null;
        }
    }
    function _SetMapGroupModifierLabelElements(mapName, elMapPanel) {
        const isNew = (GameTypesAPI.GetMapGroupAttribute(mapName, 'showtagui') === 'new');
        elMapPanel.FindChildInLayoutFile('MapGroupNewTag').SetHasClass('hidden', !isNew || mapName === "mg_lobby_mapveto");
        elMapPanel.FindChildInLayoutFile('MapSelectionTopRowIcons').SetHasClass('tall', mapName === "mg_lobby_mapveto");
    }
    function _ReloadLeaderboardLayoutGivenSettings(container, lbName, strTitleOverride, strPointsTitle) {
        const elFriendLeaderboards = container.FindChildTraverse("FriendLeaderboards");
        $.Msg("Reloading embedded friends leaderboard " + lbName + " title=" + (strTitleOverride ? strTitleOverride : "<none>") + " (points = " + (strPointsTitle ? strPointsTitle : "<default>") + ")");
        elFriendLeaderboards.SetAttributeString("type", lbName + ".friends");
        if (strPointsTitle)
            elFriendLeaderboards.SetAttributeString("points-title", strPointsTitle);
        if (strTitleOverride)
            elFriendLeaderboards.SetAttributeString("titleoverride", strTitleOverride);
        elFriendLeaderboards.BLoadLayout('file://{resources}/layout/popups/popup_leaderboards.xml', true, false);
        elFriendLeaderboards.AddClass('leaderboard_embedded');
        elFriendLeaderboards.RemoveClass('Hidden');
    }
    function _UpdateMapGroupButtons(isEnabled, isSearching, isHost) {
        const panelID = _LazyCreateMapListPanel();
        // Update wait time for queued modes
        switch (_IsPlayingOnValveOfficial() ? _RealGameMode() : '') {
            case 'competitive':
            case 'scrimcomp2v2':
            case 'rush':
                _UpdateWaitTime(_GetMapListForServerTypeAndGameMode(panelID));
                break;
        }
        if (!inDirectChallenge())
            _SetEnabledStateForMapBtns(m_mapSelectionButtonContainers[panelID], isSearching, isHost);
        // Select this panel
        m_activeMapGroupSelectionPanelID = panelID;
        _ShowActiveMapSelectionTab(isEnabled);
        _PopulateQuickSelectBar(isSearching, isHost);
    }
    function _SelectMapButtonsFromSettings(settings) {
        m_selectedPracticeMap = '';
        // Set mapgroup from selected panels on active map selection list
        const mapsGroups = settings.game.mapgroupname.split(',');
        const aListMaps = _GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID);
        for (let e of aListMaps) {
            // For all buttons who represent a mapgroup that is currently selected
            const mapName = e.GetAttributeString("mapname", "invalid");
            e.checked = mapsGroups.includes(mapName);
            if (m_serverSetting === 'listen' && e.checked) {
                // save the selected practice map for annotations
                m_selectedPracticeMap = mapName.replace(/^mg_/, '');
            }
        }
    }
    function _ShowHideStartSearchBtn(isSearching, isHost) {
        let bShow = !isSearching && isHost ? true : false;
        const btnStartSearch = $.GetContextPanel().FindChildInLayoutFile('StartMatchBtn');
        // 'pressed' and 'hidden' both control the visiblilty of the Button.
        // 'pressed' plays an animation that fades the button out so if we are in that state we
        // and want to show we want to remove that class.
        if (bShow) {
            if (btnStartSearch.BHasClass('pressed')) {
                btnStartSearch.RemoveClass('pressed');
            }
            btnStartSearch.RemoveClass('hidden');
        }
        // If we are already hiding the button by the user having 'pressed' it then don't hide it immediately
        // because the pressed anim will not finish.
        else if (!btnStartSearch.BHasClass('pressed')) {
            btnStartSearch.AddClass('hidden');
        }
    }
    function _ShowCancelSearchButton(isSearching, isHost) {
        const btnCancel = $.GetContextPanel().FindChildInLayoutFile('PartyCancelBtn');
        btnCancel.enabled = (isSearching && isHost);
        if (!btnCancel.enabled)
            ParticleControls.UpdateActionBar(m_PlayMenuActionBarParticleFX, "RmoveBtnEffects");
    }
    function _UpdatePracticeSettingsBtns(isSearching, isHost) {
        // Set up practice settings
        let elPracticeSettingsContainer = $('#id-play-menu-practicesettings-container');
        let sessionSettings = LobbyAPI.GetSessionSettings();
        let bForceHidden = (m_serverSetting !== 'listen') || m_isWorkshop || !LobbyAPI.IsSessionActive() || !sessionSettings;
        let bAnnotationAvailable = true; // GameInterfaceAPI.IsMapAnnotationAvailable( m_selectedPracticeMap );
        let bAnnotationSelected = GameInterfaceAPI.GetSettingString('ui_playsettings_listen_annotations') === '1';
        let elAnnotationDropDown = $('#id-play-menu-practicesettings-annotations-dropdown');
        elAnnotationDropDown.RebuildOptions(m_selectedPracticeMap, false);
        let elAnnotationsDropDown = elPracticeSettingsContainer.FindChildTraverse('id-play-menu-practicesettings-annotations-dropdown');
        for (let elChild of elPracticeSettingsContainer.Children()) {
            if (!elChild.id.startsWith('id-play-menu-practicesettings-'))
                continue;
            let strFeatureName = elChild.id;
            strFeatureName = strFeatureName.replace('id-play-menu-practicesettings-', '');
            strFeatureName = strFeatureName.replace('-tooltip', '');
            // "id-play-menu-practicesettings-grenades-tooltip" => '#practicesettings_*grenades*_button'
            let elFeatureFrame = elChild.FindChildTraverse('id-play-menu-practicesettings-' + strFeatureName);
            let elFeatureSliderBtn = elFeatureFrame.FindChildTraverse('id-slider-btn');
            // We hide and exit if you are not playing offline pracitce
            if (strFeatureName === "annotations") {
                elAnnotationsDropDown.enabled = bAnnotationAvailable && bAnnotationSelected;
            }
            if (bForceHidden || (sessionSettings.game.type !== 'classic')) {
                elChild.visible = false;
                continue;
            }
            if (strFeatureName === "annotations" && !bAnnotationAvailable) {
                elChild.visible = true;
                elFeatureSliderBtn.enabled = false;
                elFeatureSliderBtn.checked = false;
                continue;
            }
            elChild.visible = true;
            elFeatureSliderBtn.enabled = isHost && !isSearching;
            let curvalue = 0;
            if (sessionSettings && sessionSettings.options && sessionSettings.options.hasOwnProperty('practicesettings_' + strFeatureName)) {
                // already set which means both sessions setting and CVAR are in sync
                curvalue = sessionSettings.options['practicesettings_' + strFeatureName];
            }
            else {
                // get it from ui convar
                curvalue = GameInterfaceAPI.GetSettingString('ui_playsettings_listen_' + strFeatureName) === '1' ? 1 : 0;
                if (curvalue === 1) {
                    // only need to update the session setting if CVAR is not the default value 0
                    const setting = 'practicesettings_' + strFeatureName;
                    const newSettings = { update: { options: {} } };
                    newSettings.update.options[setting] = curvalue;
                    LobbyAPI.UpdateSessionSettings(newSettings);
                }
            }
            elFeatureSliderBtn.checked = curvalue ? true : false;
            if (strFeatureName === "grenades" || strFeatureName === "infammo" || strFeatureName === "infwarmup") {
                if (bAnnotationAvailable && bAnnotationSelected) {
                    elFeatureSliderBtn.enabled = false;
                    elFeatureSliderBtn.checked = true;
                }
            }
        }
    }
    function _UpdatePrimeBtn(isSearching, isHost) {
        const elPrimePanel = $('#PrimeStatusPanel');
        const elGetPrimeBtn = $('#id-play-menu-get-prime');
        const elPrimeStatus = $('#PrimeStatusLabelContainer');
        // We hide and exit if you are not playing official or you are not connected to GC
        if (!_IsPlayingOnValveOfficial() || !MyPersonaAPI.IsInventoryValid() || inDirectChallenge() || m_isWorkshop) {
            elPrimePanel.visible = false;
            return;
        }
        const LocalPlayerHasPrime = PartyListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid());
        // Show panel
        elPrimePanel.visible = true;
        elPrimePanel.SetHasClass('play-menu-prime-logo-bg', LocalPlayerHasPrime);
        // Show or hide the prime relevent panels based on if you have prime
        elGetPrimeBtn.visible = !LocalPlayerHasPrime;
        elPrimeStatus.visible = LocalPlayerHasPrime;
        // Don't have prime show set the upsell button
        if (!LocalPlayerHasPrime) {
            const sPrice = StoreAPI.GetStoreItemSalePrice(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1353, 0), 1, '');
            elGetPrimeBtn.SetDialogVariable("price", sPrice ? sPrice : '$0');
            elGetPrimeBtn.SetPanelEvent('onactivate', () => {
                UiToolkitAPI.HideTextTooltip();
                UiToolkitAPI.ShowCustomLayoutPopup('prime_status', 'file://{resources}/layout/popups/popup_prime_status.xml');
            });
        }
    }
    function _UpdatePermissionBtnText(settings, isEnabled) {
        let elBtnContainer = $('#PermissionsSettings');
        let elBtn = elBtnContainer.FindChild("id-slider-btn");
        elBtn.SetDialogVariable('slide_toggle_text', $.Localize("#permissions_open_party"));
        elBtn.SetSelected(settings.system.access === 'public');
        // Disable if you are a client or searching
        elBtn.enabled = isEnabled;
    }
    function _UpdateLeaderboardBtn(gameMode, isOfficalMatchmaking = false) {
        const elLeaderboardButton = $('#PlayMenulLeaderboards');
        //DEVONLY{
        if (gameMode === 'survival' && _IsPlayingOnValveOfficial()) {
            elLeaderboardButton.visible = true;
            function _OnActivate() {
                UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_leaderboards.xml', 'type=official_leaderboard_survival_squads,official_leaderboard_survival_solo' +
                    '&' + 'titleoverride=#CSGO_official_leaderboard_survival_title' +
                    '&' + 'showglobaloverride=false' +
                    '&' + 'points-title=#Cstrike_TitlesTXT_WINS');
            }
            ;
            elLeaderboardButton.SetPanelEvent('onactivate', _OnActivate);
        }
        else 
        //}DEVONLY
        {
            elLeaderboardButton.visible = false;
        }
    }
    function _UpdateReplayNewUserTrainingBtn(gameMode) {
        const elButton = $('#PlayMenuReplayNewUserTrainingButton');
        if (gameMode === 'competitive' && m_serverSetting === 'listen' && !m_isWorkshop) {
            elButton.visible = true;
            elButton.SetPanelEvent('onactivate', () => {
                UiToolkitAPI.ShowGenericPopupOkCancel('#ForceNewUserTraining_title', '#ForceNewUserTraining_text', '', () => $.Schedule(0.1, () => {
                    const settings = {
                        update: {
                            Options: {
                                action: 'custommatch',
                                server: 'listen',
                            },
                            Game: {
                                mode: 'new_user_training',
                                type: 'classic',
                                mapgroupname: 'mg_de_dust2',
                                map: 'de_dust2'
                            }
                        },
                        delete: {}
                    };
                    LobbyAPI.UpdateSessionSettings(settings);
                    LobbyAPI.StartMatchmaking('', '', '', '');
                }), () => { });
            });
        }
        else {
            elButton.visible = false;
        }
    }
    function _UpdateSurvivalAutoFillSquadBtn(gameMode) {
        const elBtn = $('#SurvivalAutoSquadToggle');
        if (!elBtn) {
            return;
        }
        if (gameMode === 'survival' && _IsPlayingOnValveOfficial() && (PartyListAPI.GetCount() <= 1)) {
            elBtn.visible = true;
            const bAutoFill = !(GameInterfaceAPI.GetSettingString('ui_playsettings_survival_solo') === '1');
            elBtn.checked = bAutoFill;
            elBtn.enabled = !_IsSearching();
            function _OnActivate() {
                const bAutoFill = !(GameInterfaceAPI.GetSettingString('ui_playsettings_survival_solo') === '1');
                GameInterfaceAPI.SetSettingString('ui_playsettings_survival_solo', bAutoFill ? '1' : '0');
                _UpdateSurvivalAutoFillSquadBtn('survival');
            }
            elBtn.SetPanelEvent('onactivate', _OnActivate);
        }
        else {
            elBtn.visible = false;
        }
        if (gameMode === 'survival') {
            const lbType = ((elBtn.visible && !elBtn.checked) ? 'solo' : 'squads');
            const lbName = "official_leaderboard_survival_" + lbType;
            const container = elBtn.GetParent().GetParent();
            const elFriendLeaderboards = container.FindChildTraverse("FriendLeaderboards");
            const sPreviousType = elFriendLeaderboards.GetAttributeString("type", '');
            if (!sPreviousType || !sPreviousType.startsWith(lbName)) {
                $.Msg("Reloading survival leaderboard (old type = " + sPreviousType + ", new type = " + lbName + ")");
                _ReloadLeaderboardLayoutGivenSettings(container, lbName, "#CSGO_official_leaderboard_survival_" + lbType, "#Cstrike_TitlesTXT_WINS");
            }
        }
    }
    function _UpdateRushFriendLeaderboards(gameMode) {
        const elRoot = $('#gameModeButtonContainer_rush_official');
        if (!elRoot)
            return;
        if (gameMode === 'rush') {
            const lbType = 'solo'; // ( ( elBtn.visible && !elBtn.checked ) ? 'solo' : 'squads' );
            const lbName = "official_leaderboard_rush_" + lbType;
            const elFriendLeaderboards = elRoot.FindChildTraverse("FriendLeaderboards");
            const sPreviousType = elFriendLeaderboards.GetAttributeString("type", '');
            if (!sPreviousType || !sPreviousType.startsWith(lbName)) {
                $.Msg("Reloading rush leaderboard (old type = " + sPreviousType + ", new type = " + lbName + ")");
                _ReloadLeaderboardLayoutGivenSettings(elRoot, lbName, "#CSGO_official_leaderboard_rush_" + lbType, "#Cstrike_TitlesTXT_WINS");
            }
        }
    }
    function _SetEnabledStateForMapBtns(elMapList, isSearching, isHost) {
        elMapList.SetHasClass('is-client', (isSearching || !isHost));
        const childrenList = _GetMapListForServerTypeAndGameMode();
        const bEnable = !isSearching && isHost;
        for (let element of childrenList) {
            if (!element.BHasClass('no-lock')) {
                element.enabled = bEnable;
            }
        }
    }
    function _UpdateWaitTime(elMapList) {
        const childrenList = elMapList;
        for (let i = 0; i < childrenList.length; i++) {
            const elWaitTime = childrenList[i].FindChildTraverse('MapGroupWaitTime');
            const mapName = childrenList[i].GetAttributeString("mapname", "invalid");
            if (mapName === 'invalid') {
                continue;
            }
            const seconds = LobbyAPI.GetMapWaitTimeInSeconds(_RealGameMode(), mapName);
            const numWait = FormatText.SecondsToDDHHMMSSWithSymbolSeperator(seconds);
            if (numWait) {
                elWaitTime.SetDialogVariable("time", numWait);
                elWaitTime.FindChild('MapGroupWaitTimeLabel').text = $.Localize('#matchmaking_expected_wait_time', elWaitTime);
                elWaitTime.RemoveClass('hidden');
            }
            else {
                elWaitTime.AddClass('hidden');
            }
        }
    }
    function _SelectActivePlayPlayTypeBtn() {
        const aPlayTypeBtns = $('#PlayTypeTopNav').Children();
        for (let btn of aPlayTypeBtns) {
            if (m_activeMapGroupSelectionPanelID === k_workshopPanelId) {
                btn.checked = btn.id === 'PlayWorkshop';
            }
            else {
                btn.checked = btn.id === 'Play-' + m_serverSetting;
            }
        }
    }
    function _IsValveOfficialServer(serverType) {
        return serverType === "official" ? true : false;
    }
    function _IsPlayingOnValveOfficial() {
        return _IsValveOfficialServer(m_serverSetting);
    }
    function _IsSearching() {
        const searchingStatus = LobbyAPI.GetMatchmakingStatusString();
        return searchingStatus !== '' && searchingStatus !== undefined ? true : false;
    }
    // Reads the state of the buttons and returns the maplist
    function _GetSelectedMapsForServerTypeAndGameMode(serverType, gameMode, bDontToggleMaps = false) {
        const isPlayingOnValveOfficial = _IsValveOfficialServer(serverType);
        const aListMapPanels = _GetMapListForServerTypeAndGameMode();
        // After fresh game launch if we go to a different game mode tab then initialize buttons from our preferences
        if (!_CheckContainerHasAnyChildChecked(aListMapPanels)) {
            let preferencesMapsForThisMode = GameInterfaceAPI.GetSettingString('ui_playsettings_maps_' + serverType + '_' + gameMode);
            // if no settings for this mode that's ok?
            if (!preferencesMapsForThisMode)
                preferencesMapsForThisMode = '';
            const savedMapIds = preferencesMapsForThisMode.split(',');
            for (let strMapNameIndividual of savedMapIds) {
                const mapsWithThisName = aListMapPanels.filter((map) => {
                    const mapName = map.GetAttributeString("mapname", "invalid");
                    return mapName === strMapNameIndividual;
                });
                if (mapsWithThisName.length > 0) {
                    if (!bDontToggleMaps)
                        mapsWithThisName[0].checked = true;
                }
            }
            if (aListMapPanels.length > 0 && !_CheckContainerHasAnyChildChecked(aListMapPanels)) {
                if (!bDontToggleMaps)
                    aListMapPanels[0].checked = true;
            }
        }
        // Rush displays a single tile, but queue is for all map groups
        if ((serverType === 'official' && gameMode === 'survival')
            || (gameMode === 'rush')) { // THIS DOES NOT CARE ABOUT SELECTED TILES IN THE UI
            return GameInterfaceAPI.GetSettingString('ui_playsettings_maps_' + serverType + '_' + gameMode);
        }
        const selectedMaps = aListMapPanels.filter((e) => {
            // For all selected maps (only >1 in competitive queues)
            return e.checked;
        })
            .reduce((accumulator, e) => {
            // make a comma delimited string of selections
            const mapName = e.GetAttributeString("mapname", "invalid");
            return (accumulator) ? (accumulator + "," + mapName) : mapName;
        }, '');
        return selectedMaps;
    }
    function _GetMapListForServerTypeAndGameMode(mapGroupOverride = null) {
        const mapGroupPanelID = !mapGroupOverride ? _LazyCreateMapListPanel() : mapGroupOverride;
        const elParent = m_mapSelectionButtonContainers[mapGroupPanelID];
        if (_RealGameMode() === 'competitive' && elParent.GetAttributeString('hassections', '')) {
            let aListMapPanels = [];
            for (let section of elParent.Children()) {
                for (let tile of section.Children()) {
                    if (tile.id != 'play-maps-section-header-container') {
                        aListMapPanels.push(tile);
                    }
                }
            }
            return aListMapPanels;
        }
        else if ((_IsPlayingOnValveOfficial() && (_RealGameMode() === 'survival'
            || _RealGameMode() === 'cooperative'
            || _RealGameMode() === 'coopmission'))
            || (_RealGameMode() === 'rush')) {
            let elMapTile = elParent.FindChildTraverse("MapTile");
            if (elMapTile)
                return elMapTile.Children();
            else
                return elParent.Children();
        }
        else {
            return elParent.Children();
        }
    }
    function _GetSelectedWorkshopMapButtons() {
        const mapGroupPanelID = _LazyCreateWorkshopTab();
        const mapContainer = m_mapSelectionButtonContainers[mapGroupPanelID];
        const children = mapContainer.Children();
        if (children.length == 0 || !children[0].GetAttributeString('group', "")) {
            // No workshop maps
            return [];
        }
        // After fresh game launch if we go to a different game mode tab then initialize buttons from our preferences
        if (!_CheckContainerHasAnyChildChecked(children)) {
            let preferencesMapsForThisMode = GameInterfaceAPI.GetSettingString('ui_playsettings_maps_workshop');
            // if no settings for this mode that's ok?
            if (!preferencesMapsForThisMode)
                preferencesMapsForThisMode = '';
            const savedMapIds = preferencesMapsForThisMode.split(',');
            for (let strMapNameIndividual of savedMapIds) {
                const mapsWithThisName = children.filter((map) => {
                    const mapName = map.GetAttributeString("mapname", "invalid");
                    return mapName === strMapNameIndividual;
                });
                if (mapsWithThisName.length > 0) {
                    mapsWithThisName[0].checked = true;
                }
            }
            if (!_CheckContainerHasAnyChildChecked(children) && children.length > 0) {
                children[0].checked = true;
            }
        }
        const selectedMaps = children.filter((e) => {
            // For all selected maps (only >1 in competitive queues)
            return e.checked;
        });
        return Array.from(selectedMaps);
    }
    function _GetSelectedWorkshopMap() {
        const mapButtons = _GetSelectedWorkshopMapButtons();
        const selectedMaps = mapButtons.reduce((accumulator, e) => {
            // make a comma delimited string of selections
            const mapName = e.GetAttributeString("mapname", "invalid");
            return (accumulator) ? (accumulator + "," + mapName) : mapName;
        }, '');
        return selectedMaps;
    }
    function _GetSingleSkirmishIdFromMapGroup(mapGroup) {
        return mapGroup.replace('mg_skirmish_', '');
    }
    function _GetSingleSkirmishMapGroupFromId(skirmishId) {
        return 'mg_skirmish_' + skirmishId;
    }
    function _GetSingleSkirmishIdFromSingleSkirmishString(entry) {
        return entry.replace('skirmish_', '');
    }
    function _GetSingleSkirmishMapGroupFromSingleSkirmishString(entry) {
        return _GetSingleSkirmishMapGroupFromId(_GetSingleSkirmishIdFromSingleSkirmishString(entry));
    }
    function _IsSingleSkirmishString(entry) {
        return entry.startsWith('skirmish_');
    }
    //--------------------------------------------------------------------------------------------------
    // Check if container has any child buttons selected
    //--------------------------------------------------------------------------------------------------
    function _CheckContainerHasAnyChildChecked(aMapList) {
        if (aMapList.length < 1)
            return false;
        return aMapList.filter(map => map.checked).length > 0;
    }
    //--------------------------------------------------------------------------------------------------
    // Validates session settings and fixes any problems
    //--------------------------------------------------------------------------------------------------
    function _ValidateSessionSettings() {
        if (m_isWorkshop) {
            // workshop is only available offline
            m_serverSetting = "listen";
        }
        if (!_IsGameModeAvailable(m_serverSetting, m_gameModeSetting)) {
            // Try to get an available game mode from the user setting first
            m_gameModeSetting = GameInterfaceAPI.GetSettingString("ui_playsettings_mode_" + m_serverSetting);
            m_singleSkirmishMapGroup = null;
            if (_IsSingleSkirmishString(_RealGameMode())) {
                m_singleSkirmishMapGroup = _GetSingleSkirmishMapGroupFromSingleSkirmishString(_RealGameMode());
                m_gameModeSetting = 'skirmish';
            }
            if (!_IsGameModeAvailable(m_serverSetting, m_gameModeSetting)) {
                $.Msg('_ValidateSessionSettings doing brute force search because [[ ' + m_serverSetting + ' ' + m_gameModeSetting + ' ]] is unavailable');
                //
                // Make sure this code matches :: uicomponent_settings.cpp
                // UI_SETTINGS_CVAR_ALIAS_WITH_GET_FILTER_FUNC( ui_playsettings_mode_official
                //
                // illegal server/mode combination.
                //
                // find an available mode (using double-quotes to copy/paste with C++)
                const modes = [
                    "premier",
                    "competitive",
                    "scrimcomp2v2",
                    "casual",
                    "deathmatch",
                ];
                for (let i = 0; i < modes.length; i++) {
                    if (_IsGameModeAvailable(m_serverSetting, modes[i])) {
                        m_gameModeSetting = modes[i];
                        m_singleSkirmishMapGroup = null;
                        break;
                    }
                }
            }
        }
        // we don't have a valid setting so read one from disk
        if (!m_gameModeFlags[m_serverSetting + _RealGameMode()])
            _LoadGameModeFlagsFromSettings();
        // filter gamemodeflag values if this mode uses flags
        if (GameModeFlags.DoesModeUseFlags(_RealGameMode())) {
            if (!GameModeFlags.AreFlagsValid(_RealGameMode(), m_gameModeFlags[m_serverSetting + _RealGameMode()])) {
                _setAndSaveGameModeFlags(0);
                $.Msg("Bad gamemodeflag for " + _RealGameMode() + ": " + m_gameModeFlags[m_serverSetting + _RealGameMode()]);
            }
        }
    }
    function _LoadGameModeFlagsFromSettings() {
        m_gameModeFlags[m_serverSetting + _RealGameMode()] = parseInt(GameInterfaceAPI.GetSettingString('ui_playsettings_flags_' + m_serverSetting + '_' + _RealGameMode()));
    }
    //--------------------------------------------------------------------------------------------------
    // Applies all the session settings
    //--------------------------------------------------------------------------------------------------
    function _ApplySessionSettings() {
        if (m_serverSetting === 'official' && !m_isWorkshop && !inDirectChallenge()) {
            if (m_gameModeSetting === 'scrimcomp2v2') { // Ensure that my rank for Wingman is fetched before I advertise as a player for hire
                MyPersonaAPI.HintLoadPipRanks('wingman');
            }
            else if (m_gameModeSetting === 'competitive') {
                MyPersonaAPI.HintLoadPipRanks('competitive');
            }
        }
        if (!LobbyAPI.BIsHost()) {
            return;
        }
        // Fix any problem settings (invalid game modes, etc)
        _ValidateSessionSettings();
        const serverType = m_serverSetting;
        let gameMode = _RealGameMode();
        let gameModeFlags = m_gameModeFlags[m_serverSetting + gameMode] ? m_gameModeFlags[m_serverSetting + gameMode] : 0;
        let primePreference = PartyListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid()) ? 1 : 0;
        let selectedMaps;
        if (m_isWorkshop)
            selectedMaps = _GetSelectedWorkshopMap();
        else if (inDirectChallenge()) {
            selectedMaps = 'mg_lobby_mapveto'; // force mg_lobby_mapveto
            gameModeFlags = 16; // force long match
            primePreference = 0; // force unranked via settings update below
        }
        else if (m_gameModeSetting === 'premier') {
            selectedMaps = 'mg_lobby_mapveto'; // force mg_lobby_mapveto
            primePreference = 1; // force ranked
            m_challengeKey = ''; // clear direct challenge key
        }
        else if (m_singleSkirmishMapGroup) {
            selectedMaps = m_singleSkirmishMapGroup;
        }
        else {
            selectedMaps = _GetSelectedMapsForServerTypeAndGameMode(serverType, gameMode);
        }
        const settings = {
            update: {
                Options: {
                    action: "custommatch",
                    server: serverType,
                    challengekey: _GetDirectChallengeKey(),
                },
                Game: {
                    mode: gameMode,
                    mode_ui: m_gameModeSetting,
                    type: GetGameType(gameMode),
                    mapgroupname: selectedMaps,
                    gamemodeflags: gameModeFlags,
                    prime: primePreference,
                    map: ''
                }
            },
            delete: {}
        };
        if (!inDirectChallenge()) {
            // we're not in direct challenge so delete the key from the session
            settings.delete = {
                Options: {
                    challengekey: 1
                }
            };
        }
        // TERRIBLE HACK: Ok so the random map feature has been broken for a long time, probably since panorama shipped and maybe even before.
        // It is very rarely used and might have appeared to work because it just loads whatever map is in the 'map' session key when it fails
        // This is the simplest way to just pick a random map from the offline map group entry in GameModes.txt without adding more work
        // to fix this very low value feature. This is fragile, relies on naming conventions in that file and is generally all around terrible
        // but I can't justify doing much more to keep this around. Alternative is to cut it. `
        if (selectedMaps.startsWith("random_")) {
            const arrMapGroups = _GetAvailableMapGroups(gameMode, false);
            const idx = 1 + Math.floor((Math.random() * (arrMapGroups.length - 1)));
            settings.update.Game.map = arrMapGroups[idx].substring(3);
        }
        // Save current choices
        // REI TODO: refactor, doesn't really belong here?
        if (m_isWorkshop) {
            GameInterfaceAPI.SetSettingString('ui_playsettings_maps_workshop', selectedMaps);
        }
        else {
            let singleSkirmishSuffix = '';
            if (m_singleSkirmishMapGroup) {
                singleSkirmishSuffix = '_' + _GetSingleSkirmishIdFromMapGroup(m_singleSkirmishMapGroup);
            }
            GameInterfaceAPI.SetSettingString('ui_playsettings_mode_' + serverType, m_gameModeSetting + singleSkirmishSuffix);
            if (!inDirectChallenge() && m_gameModeSetting !== 'premier') { // do not save the maps for "private queues", otherwise we will overwrite user preferences with "mg_lobby_mapveto"
                GameInterfaceAPI.SetSettingString('ui_playsettings_maps_' + serverType + '_' + m_gameModeSetting + singleSkirmishSuffix, selectedMaps);
            }
        }
        // Broadcast current settings to all clients (including ourselves)
        // This will call back into us via _SessionSettingsUpdate() so we can set up our new state
        LobbyAPI.UpdateSessionSettings(settings);
    }
    //--------------------------------------------------------------------------------------------------
    // Functions called from outside
    //--------------------------------------------------------------------------------------------------
    function _SessionSettingsUpdate(sessionState) {
        // force all controls to match their associated session settings
        if (sessionState === "ready") {
            if (m_jsTimerUpdateHandle && typeof m_jsTimerUpdateHandle === "number") {
                $.CancelScheduled(m_jsTimerUpdateHandle);
                m_jsTimerUpdateHandle = false;
            }
            _Init(); // late init, needed to create session before populating controls
        }
        // Host changed settings, update our controls to match
        else if (sessionState === "updated") {
            const settings = LobbyAPI.GetSessionSettings();
            _SyncDialogsFromSessionSettings(settings);
        }
        else if (sessionState === "closed") {
            // Queue hide content panel for a half second as we are going to go into the loading screen, and
            // we don't need dueling transitions.
            m_jsTimerUpdateHandle = $.Schedule(0.5, _HalfSecondDelay_HideContentPanel);
            $.Msg("[p.mainmenu]", "Queue HideContentPanel");
        }
    }
    function _PipRankUpdate() {
        if (m_serverSetting == 'official' &&
            m_gameModeSetting === 'competitive') {
            const activeMapGroup = m_activeMapGroupSelectionPanelID;
            const btnSelectedMapGroup = m_mapSelectionButtonContainers[activeMapGroup].Children();
            for (let elPanel of btnSelectedMapGroup) {
                const mapGroupName = elPanel.GetAttributeString('mapname', '').replace(/^mg_/, '');
                $.Msg('MAPS: ' + mapGroupName);
                _UpdateRatingEmblem(elPanel, mapGroupName);
            }
        }
    }
    function _HalfSecondDelay_HideContentPanel() {
        m_jsTimerUpdateHandle = false;
        $.Msg("[p.mainmenu]", "Dispatch HideContentPanel");
        $.DispatchEvent('HideContentPanel');
    }
    function _ReadyForDisplay() {
        _StartRotatingMapGroupTimer();
        _m_inventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _InventoryUpdated);
        // We don't run this when the play menu's offscreen, so run it now.
        _InventoryUpdated();
    }
    function _UnreadyForDisplay() {
        _CancelRotatingMapGroupSchedule();
        if (_m_inventoryUpdatedHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _m_inventoryUpdatedHandler);
            _m_inventoryUpdatedHandler = null;
        }
    }
    function _OnHideMainMenu() {
        for (let entry of $('#MapSelectionList').FindChildrenWithClassTraverse("map-selection-btn__carousel")) {
            entry.SetAutoScrollEnabled(false);
        }
    }
    function _OnShowMainMenu() {
        for (let entry of $('#MapSelectionList').FindChildrenWithClassTraverse("map-selection-btn__carousel")) {
            entry.SetAutoScrollEnabled(true);
        }
    }
    function _InitializeWorkshopTags(panel, mapInfo) {
        const mapTags = mapInfo.tags ? mapInfo.tags.split(",") : [];
        // Find game modes in tags
        const rawModes = [];
        const modes = [];
        const tags = [];
        for (let i = 0; i < mapTags.length; ++i) {
            // Check if matches a game mode
            // (Use lowercase with spaces and hyphens removed)
            const modeTag = mapTags[i].toLowerCase().split(' ').join('').split('-').join('');
            if (modeTag in k_workshopModes) {
                const gameTypes = k_workshopModes[modeTag].split(',');
                for (let iType = 0; iType < gameTypes.length; ++iType) {
                    if (!rawModes.includes(gameTypes[iType]))
                        rawModes.push(gameTypes[iType]);
                }
                modes.push($.Localize('#CSGO_Workshop_Mode_' + modeTag));
            }
            else {
                tags.push($.HTMLEscape(mapTags[i]));
            }
        }
        // Generate tooltip
        let tooltip = mapInfo.desc ? $.HTMLEscape(mapInfo.desc) : '';
        if (modes.length > 0) {
            if (tooltip)
                tooltip += '<br><br>';
            tooltip += $.Localize("#CSGO_Workshop_Modes");
            tooltip += ' ';
            tooltip += modes.join(', ');
        }
        if (tags.length > 0) {
            if (tooltip)
                tooltip += '<br><br>';
            tooltip += $.Localize("#CSGO_Workshop_Tags");
            tooltip += ' ';
            tooltip += tags.join(', ');
        }
        panel.SetAttributeString('data-tooltip', tooltip); // also used for search filter
        panel.SetAttributeString('data-workshop-modes', rawModes.join(','));
    }
    function _ShowWorkshopMapInfoTooltip(panel) {
        const text = panel.GetAttributeString('data-tooltip', '');
        if (text)
            UiToolkitAPI.ShowTextTooltip(panel.id, text);
    }
    function _HideWorkshopMapInfoTooltip() {
        UiToolkitAPI.HideTextTooltip();
    }
    function _LazyCreateWorkshopTab() {
        const panelId = k_workshopPanelId;
        if (panelId in m_mapSelectionButtonContainers)
            return panelId;
        // create workshop tab
        const container = $.CreatePanel("Panel", $('#MapSelectionList'), panelId, {
            class: 'map-selection-list map-selection-list--inner hidden'
        });
        container.AddClass('map-selection-list--workshop');
        $.Msg("LazyCreateWorkshopTab added a container: (panel id = " + panelId + ")");
        m_mapSelectionButtonContainers[panelId] = container;
        const arrMaps = WorkshopAPI.GetAvailableWorkshopMaps();
        for (let idxMap = 0; idxMap < arrMaps.length; ++idxMap) {
            const mapInfo = arrMaps[idxMap];
            if (typeof mapInfo !== 'object') {
                continue;
            }
            const p = $.CreatePanel('RadioButton', container, panelId + '_' + idxMap);
            p.BLoadLayoutSnippet('MapGroupSelection');
            p.SetAttributeString('group', 'radiogroup_' + panelId);
            if (!mapInfo.hasOwnProperty('imageUrl') || !mapInfo.imageUrl)
                mapInfo.imageUrl = 'file://{images}/map_icons/screenshots/360p/random.png';
            p.SetAttributeString('mapname', '@workshop/' + mapInfo.workshop_id + '/' + mapInfo.map);
            p.SetAttributeString('addon', mapInfo.workshop_id);
            p.SetPanelEvent('onactivate', () => _OnActivateMapOrMapGroupButton(p));
            p.FindChildInLayoutFile('ActiveGroupIcon').visible = false;
            p.FindChildInLayoutFile('MapGroupName').text = mapInfo.name;
            const mapImage = $.CreatePanel('Panel', p.FindChildInLayoutFile('MapGroupImagesCarousel'), 'MapSelectionScreenshot0');
            mapImage.AddClass('map-selection-btn__screenshot');
            mapImage.style.backgroundImage = 'url("' + mapInfo.imageUrl + '")';
            mapImage.style.backgroundPosition = '50% 0%';
            mapImage.style.backgroundSize = 'auto 100%';
            _InitializeWorkshopTags(p, mapInfo);
            p.SetPanelEvent('onmouseover', () => _ShowWorkshopMapInfoTooltip(p));
            p.SetPanelEvent('onmouseout', () => _HideWorkshopMapInfoTooltip());
        }
        if (arrMaps.length == 0) {
            const p = $.CreatePanel('Panel', container, undefined);
            p.BLoadLayoutSnippet('NoWorkshopMaps');
        }
        // filter panels with the current filter
        _UpdateWorkshopMapFilter();
        return panelId;
    }
    function _SwitchToWorkshopTab(isEnabled) {
        const panelId = _LazyCreateWorkshopTab();
        m_activeMapGroupSelectionPanelID = panelId;
        _ShowActiveMapSelectionTab(isEnabled);
    }
    function _UpdateGameModeFlagsBtn() {
        const elPanel = $.GetContextPanel().FindChildTraverse('id-gamemode-flag-' + _RealGameMode());
        if (!elPanel || !GameModeFlags.DoesModeUseFlags(_RealGameMode()) || m_isWorkshop) {
            return;
        }
        else {
            let elFlag = (m_gameModeFlags[m_serverSetting + _RealGameMode()]) ? elPanel.FindChildInLayoutFile('id-gamemode-flag-' + _RealGameMode() + '-' + m_gameModeFlags[m_serverSetting + _RealGameMode()]) : null;
            if (elFlag && elFlag.IsValid()) {
                elFlag.checked = true;
            }
            else {
                for (let element of elPanel.Children()) {
                    element.checked = false;
                }
            }
        }
        for (let element of elPanel.Children()) {
            element.enabled = !inDirectChallenge() && !_IsSearching() && LobbyAPI.BIsHost();
        }
    }
    function _setAndSaveGameModeFlags(value) {
        $.Msg('_setAndSaveGameModeFlags ' + value);
        m_gameModeFlags[m_serverSetting + _RealGameMode()] = value;
        _UpdateGameModeFlagsBtn();
        if (!inDirectChallenge())
            GameInterfaceAPI.SetSettingString('ui_playsettings_flags_' + m_serverSetting + '_' + _RealGameMode(), m_gameModeFlags[m_serverSetting + _RealGameMode()].toString());
    }
    function _OnGameModeFlagOptionActivate(value) {
        _setAndSaveGameModeFlags(value);
        _ApplySessionSettings();
    }
    function _OnGameModeFlagsBtnClicked(resumeMatchmakingHandle) {
        function _Callback(value, resumeMatchmakingHandle = '') {
            _setAndSaveGameModeFlags(parseInt(value));
            _ApplySessionSettings();
            if (resumeMatchmakingHandle) {
                UiToolkitAPI.InvokeJSCallback(parseInt(resumeMatchmakingHandle));
                UiToolkitAPI.UnregisterJSCallback(parseInt(resumeMatchmakingHandle));
            }
        }
        const callback = UiToolkitAPI.RegisterJSCallback(_Callback);
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_play_gamemodeflags.xml', '&callback=' + callback +
            '&searchfn=' + resumeMatchmakingHandle +
            '&textToken=' + '#play_settings_' + _RealGameMode() + '_dialog' +
            GameModeFlags.GetOptionsString(_RealGameMode()) +
            '&currentvalue=' + m_gameModeFlags[m_serverSetting + _RealGameMode()]);
    }
    function OnPressOfficialServers() {
        m_isWorkshop = false;
        m_serverSetting = 'official';
        _TurnOffDirectChallenge();
        _ApplySessionSettings();
    }
    PlayMenu.OnPressOfficialServers = OnPressOfficialServers;
    function OnPressListenServers() {
        m_isWorkshop = false;
        m_serverSetting = 'listen';
        _TurnOffDirectChallenge();
        _ApplySessionSettings();
    }
    PlayMenu.OnPressListenServers = OnPressListenServers;
    function OnPressWorkshop() {
        m_isWorkshop = true;
        _SetPlayDropdownToWorkshop();
        _TurnOffDirectChallenge();
        _UpdateDirectChallengePage(_IsSearching(), LobbyAPI.BIsHost());
        _UpdateGameModeFlagsBtn();
        _SelectActivePlayPlayTypeBtn();
    }
    PlayMenu.OnPressWorkshop = OnPressWorkshop;
    function OnPressServerBrowser() {
        if ('0' === GameInterfaceAPI.GetSettingString('player_nevershow_communityservermessage')) {
            UiToolkitAPI.ShowCustomLayoutPopup('server_browser_popup', 'file://{resources}/layout/popups/popup_serverbrowser.xml');
        }
        else {
            if (m_bPerfectWorld) {
                SteamOverlayAPI.OpenURL('https://csgo.wanmei.com/communityserver');
            }
            else {
                SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser('steam://open/servers');
            }
        }
    }
    PlayMenu.OnPressServerBrowser = OnPressServerBrowser;
    function BotDifficultyChanged() {
        const elDropDownEntry = $('#BotDifficultyDropdown').GetSelected();
        const botDiff = elDropDownEntry.id;
        GameTypesAPI.SetCustomBotDifficulty(parseInt(botDiff));
        // save the change to archive cvar
        GameInterfaceAPI.SetSettingString('player_botdifflast_s', botDiff);
    }
    PlayMenu.BotDifficultyChanged = BotDifficultyChanged;
    function _DisplayWorkshopModePopup() {
        // Figure out valid modes
        const elSelectedMaps = _GetSelectedWorkshopMapButtons();
        let modes = [];
        if (elSelectedMaps.length === 0) {
            UiToolkitAPI.ShowGenericPopupTwoOptions($.Localize('#SFUI_Maps_Workshop_Title'), $.Localize('#SFUI_No_Subscribed_Maps_Desc'), '', '#CSGO_Workshop_Visit', () => $.DispatchEvent('CSGOOpenSteamWorkshop', 'Map'), "OK", () => { });
            $('#StartMatchBtn').RemoveClass('pressed');
            return;
        }
        for (let iMap = 0; iMap < elSelectedMaps.length; ++iMap) {
            const mapModes = elSelectedMaps[iMap].GetAttributeString('data-workshop-modes', '').split(',');
            // only include modes that are valid for all selected maps
            if (iMap == 0)
                modes = mapModes;
            else
                modes = modes.filter(mode => mapModes.includes(mode));
        }
        const strModes = modes.join(',');
        UiToolkitAPI.ShowCustomLayoutPopupParameters('workshop_map_mode', 'file://{resources}/layout/popups/popup_workshop_mode_select.xml', 'workshop-modes=' + $.HTMLEscape(strModes));
        $('#StartMatchBtn').RemoveClass('pressed');
    }
    function _UpdateWorkshopMapFilter() {
        const elTextLabel = $('#WorkshopSearchTextEntry');
        const filter = $.HTMLEscape(elTextLabel.text).toLowerCase();
        const container = m_mapSelectionButtonContainers[k_workshopPanelId];
        const elCanelBtn = $('#WorkshopSearchTextEntryCanel');
        if (elCanelBtn) {
            elCanelBtn.SetHasClass('hide', filter == '');
            elCanelBtn.SetPanelEvent('onactivate', () => { elTextLabel.text = ''; _UpdateWorkshopMapFilter(); });
        }
        if (!container) {
            return; // not initialized yet
        }
        const children = container.Children();
        for (let i = 0; i < children.length; ++i) {
            const panel = children[i];
            // skip things that aren't map buttons (e.g. "no maps subscribed" label)
            const mapname = panel.GetAttributeString('mapname', '');
            if (mapname === '')
                continue;
            // if no filter, always visible
            if (filter === '') {
                panel.visible = true;
                continue;
            }
            // compare the raw ASCII map filename (e.g. "over" matches "de_overpass")
            if (mapname.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            // compare the raw ASCII playable modes (e.g. "flyingscoutsman")
            const modes = panel.GetAttributeString('data-workshop-modes', '');
            if (modes.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            // compare all the text in the tooltip, which includes localized mode names and unlocalized
            // description and tags directly from the map
            const tooltip = panel.GetAttributeString('data-tooltip', '');
            if (tooltip.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            // compare the map name, which (TODO) should be localized if it's an official map,
            // and otherwise the unlocalized name specified by the mapper
            const elMapNameLabel = panel.FindChildTraverse('MapGroupName');
            if (elMapNameLabel && elMapNameLabel.text && elMapNameLabel.text.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            panel.visible = false;
        }
    }
    function _SetPlayDropdownToWorkshop() {
        // only offline available for workshop maps
        m_serverSetting = 'listen';
        m_isWorkshop = true;
        _UpdatePrimeBtn(false, LobbyAPI.BIsHost());
        _UpdatePracticeSettingsBtns(false, LobbyAPI.BIsHost());
        if (_GetSelectedWorkshopMap()) {
            _ApplySessionSettings();
        }
        else {
            // User has no workshop maps, can't apply session settings but still show UI for workshop tab
            _SwitchToWorkshopTab(true);
        }
        $.GetContextPanel().SwitchClass("gamemode", 'workshop');
        $.GetContextPanel().SwitchClass("serversetting", m_serverSetting);
    }
    function _WorkshopSubscriptionsChanged() {
        const panel = m_mapSelectionButtonContainers[k_workshopPanelId];
        if (panel) {
            panel.DeleteAsync(0.0);
            // remove from map
            delete m_mapSelectionButtonContainers[k_workshopPanelId];
        }
        if (m_activeMapGroupSelectionPanelID != k_workshopPanelId) {
            // We'll lazy-recreate the panel the next time the user switches to it.
            return;
        }
        if (!LobbyAPI.IsSessionActive()) {
            // We can't sync session settings if we don't have a session when this event triggers, and this seems to happen when
            // entering a workshop map, during loading.
            // we are now in an inconsistent state? since m_activeMapGroupSelectionPanelID now points to a deleted panel
            // everything seems to work but we should keep an eye on this.
            m_activeMapGroupSelectionPanelID = null;
            return;
        }
        // for now just re-update from session settings.
        _SyncDialogsFromSessionSettings(LobbyAPI.GetSessionSettings());
        // If we are the host, re-apply our curernt settings. This will select a new map if the user unsubscribed from the current selection.
        if (LobbyAPI.BIsHost()) {
            _ApplySessionSettings();
            // you were on the workshop tab, force yourself back there if something caused it to switch (e.g. you had no selected map)
            _SetPlayDropdownToWorkshop();
        }
    }
    function _WorkshopAnnotationSubscriptionsChanged() {
        _UpdatePracticeSettingsBtns(_IsSearching(), LobbyAPI.BIsHost());
    }
    function _InventoryUpdated() {
        _UpdatePrimeBtn(_IsSearching(), LobbyAPI.BIsHost());
        _UpdatePracticeSettingsBtns(_IsSearching(), LobbyAPI.BIsHost());
    }
    function _RealGameMode() {
        if (m_gameModeSetting === 'premier')
            return 'competitive';
        else if (m_gameModeSetting == 'gungameprogressive' && _IsPlayingOnValveOfficial())
            return 'skirmish';
        return m_gameModeSetting;
    }
    function OnClearFilterText() {
        const elTextLabel = $('#WorkshopSearchTextEntry');
        const elCanelBtn = $('#WorkshopSearchTextEntryCanel');
        elCanelBtn.SetPanelEvent('onactivate', () => { elTextLabel.text = ''; _UpdateWorkshopMapFilter(); });
    }
    PlayMenu.OnClearFilterText = OnClearFilterText;
    function _SwitchGameModeTab(gameMode) {
        $('#GameModeSelectionRadios');
        for (let element of $('#GameModeSelectionRadios').Children()) {
            if (element.id === gameMode) {
                $.DispatchEvent("Activated", element, "mouse");
            }
        }
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        _Init();
        $.RegisterEventHandler("ReadyForDisplay", $.GetContextPanel(), _ReadyForDisplay);
        $.RegisterEventHandler("UnreadyForDisplay", $.GetContextPanel(), _UnreadyForDisplay);
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _SessionSettingsUpdate);
        $.RegisterForUnhandledEvent("CSGOHideMainMenu", _OnHideMainMenu);
        $.RegisterForUnhandledEvent("CSGOHidePauseMenu", _OnHideMainMenu);
        $.RegisterForUnhandledEvent("CSGOShowMainMenu", _OnShowMainMenu);
        $.RegisterForUnhandledEvent("CSGOShowPauseMenu", _OnShowMainMenu);
        $.RegisterForUnhandledEvent("CSGOWorkshopSubscriptionsChanged", _WorkshopSubscriptionsChanged);
        $.RegisterForUnhandledEvent("CSGOWorkshopAnnotationSubscriptionsChanged", _WorkshopAnnotationSubscriptionsChanged);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_ClansInfoUpdated', _ClansInfoUpdated);
        $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', _OnPlayerNameChangedUpdate);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_PipRankUpdate', _PipRankUpdate);
        $.RegisterForUnhandledEvent('PlayMenu_SwitchGameModeTab', _SwitchGameModeTab);
        // direct challenge
        $.RegisterForUnhandledEvent('DirectChallenge_GenRandomKey', _OnDirectChallengeRandom);
        $.RegisterForUnhandledEvent('DirectChallenge_EditKey', _OnDirectChallengeEdit);
        $.RegisterForUnhandledEvent('DirectChallenge_CopyKey', _OnDirectChallengeCopy);
        $.RegisterForUnhandledEvent('DirectChallenge_ChooseClanKey', _OnChooseClanKeyBtn);
        $.RegisterForUnhandledEvent('DirectChallenge_ClanChallengeKeySelected', _OnClanChallengeKeySelected);
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_PrivateQueuesUpdate', _OnPrivateQueuesUpdate);
        WorkshopAPI.QueryUGCItemSubscriptions();
    }
})(PlayMenu || (PlayMenu = {}));
