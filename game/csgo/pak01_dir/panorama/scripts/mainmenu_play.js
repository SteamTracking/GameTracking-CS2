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
    const m_mapSelectionButtonContainers = {};
    let m_gameModeConfigs = {};
    let m_arrGameModeRadios = [];
    let GetMGDetails;
    let GetGameType;
    const m_bPerfectWorld = (MyPersonaAPI.GetLauncherType() === 'perfectworld');
    let m_activeMapGroupSelectionPanelID = null;
    let m_serverSetting = '';
    let m_gameModeSetting = '';
    let m_singleSkirmishMapGroup = null;
    let m_arrSingleSkirmishMapGroups = [];
    const m_gameModeFlags = {};
    let m_isWorkshop = false;
    let m_jsTimerUpdateHandle = false;
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
        flyingscoutsman: 'flyingscoutsman',
        retakes: 'retakes'
    };
    const m_PlayMenuActionBarParticleFX = $('#PlayMenuActionBar_Searching_particles');
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
                if (!_CheckContainerHasAnyChildChecked(_GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID)) && !m_isWorkshop) {
                    _NoMapSelectedPopup();
                    btnStartSearch.RemoveClass('pressed');
                    return;
                }
            }
            if (GameModeFlags.DoesModeUseFlags(_RealGameMode()) && !m_gameModeFlags[m_serverSetting + _RealGameMode()]) {
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
        const cfg = GameTypesAPI.GetConfig();
        for (const type in cfg.gameTypes) {
            for (const mode in cfg.gameTypes[type].gameModes) {
                let obj = cfg.gameTypes[type].gameModes[mode];
                m_gameModeConfigs[mode] = obj;
            }
        }
        GetGameType = (mode) => {
            for (const gameType in cfg.gameTypes) {
                if (cfg.gameTypes[gameType].gameModes.hasOwnProperty(mode))
                    return gameType;
            }
        };
        GetMGDetails = (mg) => {
            return cfg.mapgroups[mg];
        };
        const elGameModeSelectionRadios = $('#GameModeSelectionRadios');
        if (elGameModeSelectionRadios !== null) {
            m_arrGameModeRadios = elGameModeSelectionRadios.Children();
        }
        m_arrGameModeRadios = m_arrGameModeRadios.filter(elPanel => !elPanel.BHasClass('mainmenu-top-navbar__play_seperator'));
        for (let entry of m_arrGameModeRadios) {
            entry.SetPanelEvent('onactivate', () => {
                m_isWorkshop = false;
                _LoadGameModeFlagsFromSettings();
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
        const elPracticeSettingsContainer = $('#id-play-menu-practicesettings-container');
        for (let elChild of elPracticeSettingsContainer.Children()) {
            if (!elChild.id.startsWith('id-play-menu-practicesettings-'))
                continue;
            let strFeatureName = elChild.id;
            strFeatureName = strFeatureName.replace('id-play-menu-practicesettings-', '');
            strFeatureName = strFeatureName.replace('-tooltip', '');
            const elFeatureFrame = elChild.FindChildTraverse('id-play-menu-practicesettings-' + strFeatureName);
            const elFeatureSliderBtn = elFeatureFrame.FindChildTraverse('id-slider-btn');
            elFeatureSliderBtn.text = $.Localize('#practicesettings_' + strFeatureName + '_button');
            elFeatureSliderBtn.SetPanelEvent('onactivate', () => {
                UiToolkitAPI.HideTextTooltip();
                const sessionSettings = LobbyAPI.GetSessionSettings();
                const curvalue = (sessionSettings && sessionSettings.options && sessionSettings.options.hasOwnProperty('practicesettings_' + strFeatureName))
                    ? sessionSettings.options['practicesettings_' + strFeatureName] : 0;
                const newvalue = curvalue ? 0 : 1;
                GameInterfaceAPI.SetSettingString('ui_playsettings_listen_' + strFeatureName, newvalue ? '1' : '0');
                const setting = 'practicesettings_' + strFeatureName;
                const newSettings = { update: { options: {} } };
                newSettings.update.options[setting] = newvalue;
                LobbyAPI.UpdateSessionSettings(newSettings);
            });
        }
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
        _SyncDialogsFromSessionSettings(LobbyAPI.GetSessionSettings());
        _ApplySessionSettings();
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
            type = oReturn.value[2];
            id = oReturn.value[3];
            id32 = parseInt(oReturn.value[4]);
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
            $.Schedule(0.01, () => {
                const elHeader = $.GetContextPanel().FindChildTraverse("JsDirectChallengeKey");
                if (elHeader && elHeader.IsValid())
                    elHeader.TriggerClass('directchallenge-status__header__queuecode');
            });
        }
        $.GetContextPanel().SetHasClass('directchallenge', key != '');
        m_challengeKey = key;
    }
    function _ClansInfoUpdated() {
        if (m_challengeKey && $.GetContextPanel().GetAttributeString('code-type', '') === 'g') {
            _SetDirectChallengeKey(m_challengeKey);
        }
    }
    function _AddOpenPlayerCardAction(elAvatar, xuid) {
        elAvatar.SetPanelEvent("onactivate", () => {
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
            return oReturn.value[2];
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
        if (_IsValveOfficialServer(serverType) &&
            LobbyAPI.BIsHost()) {
            if (gameMode === 'premier') {
                isAvailable = ((MyPersonaAPI.GetElevatedState() === 'elevated') &&
                    (MyPersonaAPI.HasPrestige() || MyPersonaAPI.GetCurrentLevel() >= 10)) &&
                    !TournamentsAPI.IsPremierSeasonOffseason();
            }
            else if (MyPersonaAPI.HasPrestige()) {
                isAvailable = true;
            }
            else if (MyPersonaAPI.GetCurrentLevel() < 2) {
                isAvailable = (gameMode == 'deathmatch' || gameMode == 'casual' || gameMode == 'gungameprogressive' || gameMode == 'retakes');
            }
        }
        else if (!_IsValveOfficialServer(serverType)) {
            (isAvailable = (gameMode != 'premier'));
        }
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
                if (strSelectedData === strData) {
                    elDropdown.SetSelected(entryID);
                }
            }
            const strCurrentOpponent = _GetTournamentOpponent();
            const strCurrentStage = _GetTournamentStage();
            elTeamDropdown.RemoveAllOptions();
            AddDropdownOption(elTeamDropdown, 'PickOpponent', $.Localize('#SFUI_Tournament_Pick_Opponent'), '', strCurrentOpponent);
            const teamCount = CompetitiveMatchAPI.GetTournamentTeamCount(strTournament);
            for (let i = 0; i < teamCount; i++) {
                const strTeam = CompetitiveMatchAPI.GetTournamentTeamNameByIndex(strTournament, i);
                if (strTeamName === strTeam)
                    continue;
                AddDropdownOption(elTeamDropdown, 'team_' + i, strTeam, strTeam, strCurrentOpponent);
            }
            elTeamDropdown.SetPanelEvent('oninputsubmit', () => _UpdateStartSearchBtn(isSearchingForTournament));
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
        $.GetContextPanel().SwitchClass("gamemode", m_isWorkshop ? "workshop" : _RealGameMode());
        $.GetContextPanel().SwitchClass("serversetting", m_serverSetting);
        $.GetContextPanel().SetHasClass("directchallenge", inDirectChallenge());
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
            for (let i = 0; i < m_arrGameModeRadios.length; ++i) {
                const strGameModeForButton = m_arrGameModeRadios[i].id;
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
                const isAvailable = _IsGameModeAvailable(m_serverSetting, strGameModeForButton);
                m_arrGameModeRadios[i].enabled = isAvailable && isEnabled;
                m_arrGameModeRadios[i].SetHasClass('locked', !isAvailable || !isEnabled);
            }
            _UpdateMapGroupButtons(isEnabled, isSearching, isHost);
            _CancelRotatingMapGroupSchedule();
            if (settings.game.mode === "survival") {
                _GetRotatingMapGroupStatus(_RealGameMode(), m_singleSkirmishMapGroup, settings.game.mapgroupname);
            }
            _SelectMapButtonsFromSettings(settings);
        }
        else {
            m_arrGameModeRadios[0].checked = true;
        }
        _ShowHideStartSearchBtn(isSearching, isHost);
        _ShowCancelSearchButton(isSearching, isHost);
        _UpdateTournamentButton(isHost);
        _UpdatePrimeBtn(isSearching, isHost);
        _UpdatePermissionBtnText(settings, isEnabled);
        _UpdatePracticeSettingsBtns(isSearching, isHost);
        _UpdateLeaderboardBtn(m_gameModeSetting);
        _UpdateSurvivalAutoFillSquadBtn(m_gameModeSetting);
        _UpdateRushFriendLeaderboards(m_gameModeSetting);
        _SelectActivePlayPlayTypeBtn();
        _UpdateReplayNewUserTrainingBtn(m_gameModeSetting);
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
        elTile.BLoadLayout('file://{resources}/layout/simple_player_tile.xml', false, false);
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
        let strName = null;
        const strCodeXuid = $.GetContextPanel().GetAttributeString('code-xuid', '');
        if (strCodeXuid === xuid) {
            if (!strName)
                strName = FriendsListAPI.GetFriendName(xuid);
            $.GetContextPanel().SetDialogVariable('code-source', strName);
        }
        const elMembersContainer = $('#DirectChallengeQueueMembers');
        if (!elMembersContainer)
            return;
        const elUserTile = elMembersContainer.FindChildTraverse(xuid);
        if (!elUserTile)
            return;
        if (!strName)
            strName = FriendsListAPI.GetFriendName(xuid);
        elUserTile.SetDialogVariable('player_name', strName);
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
        const elMembersContainer = $.GetContextPanel().FindChildTraverse('DirectChallengeQueueMembers');
        if (!elMembersContainer)
            return;
        const elExplanation = $("#id-directchallenge-explanation");
        if (elExplanation)
            elExplanation.SetHasClass('hidden', _IsSearching());
        const elQueueMembers = $("#id-directchallenge-status__queue-members");
        if (elQueueMembers)
            elQueueMembers.SetHasClass('hidden', !_IsSearching());
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
        for (let child of elMembersContainer.Children()) {
            child.SetAttributeInt("marked_for_delete", 1);
        }
        let delay = 0;
        for (let i = NumberOfParties; i-- > 0;) {
            const DELAY_INCREMENT = 0.25;
            const arrMembers = [];
            const partyXuid = PartyBrowserAPI.GetPrivateQueuePartyXuidByIndex(i);
            const partyId = _GetPartyID(partyXuid, arrMembers);
            let elParty = elMembersContainer.FindChild(partyId);
            if (!elParty) {
                elParty = $.CreatePanel('Panel', elMembersContainer, partyId, { class: 'directchallenge__party hidden' });
                elParty.SetHasClass('multi', arrMembers.length > 1);
                elMembersContainer.MoveChildBefore(elParty, elMembersContainer.Children()[0]);
                elParty.SetAttributeString("xuid", partyXuid);
                Scheduler.Schedule(delay, () => {
                    if (elParty && elParty.IsValid())
                        elParty.RemoveClass('hidden');
                }, "directchallenge");
                for (let xuid of arrMembers) {
                    if (elParty) {
                        const elTile = $.CreatePanel('Panel', elParty, xuid, { class: "directchallenge__party__member" });
                        _CreatePlayerTile(elTile, xuid, delay);
                    }
                    delay += DELAY_INCREMENT;
                }
            }
            else {
            }
            elParty.SetAttributeInt("marked_for_delete", 0);
        }
        for (let child of elMembersContainer.Children()) {
            if (child.GetAttributeInt("marked_for_delete", 0) !== 0) {
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
        const gameModeCfg = m_gameModeConfigs[gameMode];
        if (gameModeCfg === undefined)
            return [];
        const mapgroup = isPlayingOnValveOfficial ? gameModeCfg.mapgroupsMP : gameModeCfg.mapgroupsSP;
        if (mapgroup !== undefined && mapgroup !== null) {
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
        if ($.GetContextPanel().BHasClass('play-menu__lobbymapveto_activated') && mapGroupNameClicked !== 'mg_lobby_mapveto') {
            return;
        }
        if (mapgroupButton.checked) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'submenu_leveloptions_select', 'MOUSE');
        }
        else {
            $.DispatchEvent('CSGOPlaySoundEffect', 'submenu_leveloptions_deselect', 'MOUSE');
        }
        let mapGroupName = mapGroupNameClicked;
        if (mapGroupName) {
            const siblingSuffix = '_scrimmagemap';
            if (mapGroupName.toLowerCase().endsWith(siblingSuffix))
                mapGroupName = mapGroupName.substring(0, mapGroupName.length - siblingSuffix.length);
            else
                mapGroupName = mapGroupName + siblingSuffix;
            let elParent = mapgroupButton.GetParent();
            if (elParent)
                elParent = elParent.GetParent();
            if (elParent && elParent.GetAttributeString('hassections', '')) {
                for (let section of elParent.Children()) {
                    for (let tile of section.Children()) {
                        const mapGroupNameSibling = tile.GetAttributeString("mapname", '');
                        if (mapGroupNameSibling.toLowerCase() === mapGroupName.toLowerCase()) {
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
            if (!m_bDidShowActiveMapSelectionTab) {
                elButtonContainer.AddClass("skip-transition");
            }
            if (key !== panelID) {
                elButtonContainer.AddClass("hidden");
            }
            else {
                elButtonContainer.RemoveClass("hidden");
                elButtonContainer.visible = true;
                elButtonContainer.enabled = isEnabled;
            }
            elButtonContainer.RemoveClass("skip-transition");
        }
        const isWorkshop = panelID === k_workshopPanelId;
        $('#WorkshopSearchBar').visible = isWorkshop;
        for (let element of $('#GameModeSelectionRadios').Children()) {
            element.enabled = element.enabled && !isWorkshop && !_IsSearching() && LobbyAPI.BIsHost();
        }
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
    function OnMapQuickSelect(mgName) {
        const arrMapsToSelect = _GetMapsFromQuickSelectMapGroup(mgName);
        let bScrolled = false;
        const prevSelection = _GetSelectedMapsForServerTypeAndGameMode(m_serverSetting, _RealGameMode(), true);
        const elMapGroupContainer = _GetMapTileContainer();
        for (let elMapBtn of elMapGroupContainer.Children()) {
            let bFound = false;
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
            if (bFound && !bScrolled) {
                elMapBtn.ScrollParentToMakePanelFit(2, false);
                bScrolled = true;
            }
        }
        const newSelection = _GetSelectedMapsForServerTypeAndGameMode(m_serverSetting, _RealGameMode(), true);
        if (prevSelection != newSelection) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'submenu_leveloptions_select', 'MOUSE');
            _MatchMapSelectionWithQuickSelect();
            if (_CheckContainerHasAnyChildChecked(_GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID))) {
                _ApplySessionSettings();
            }
        }
    }
    PlayMenu.OnMapQuickSelect = OnMapQuickSelect;
    function _ValidateMaps(arrMapList) {
        let arrMapTileNames = [];
        const arrMapButtons = _GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID);
        arrMapButtons.forEach(elMapTile => arrMapTileNames.push(elMapTile.GetAttributeString("mapname", "")));
        const filteredMapList = arrMapList.filter(strMap => arrMapTileNames.includes(strMap));
        return filteredMapList;
    }
    function _GetMapGroupsWithAttribute(strAttribute, strValue) {
        const arrNewMapgroups = [];
        const elMapGroupContainer = _GetMapTileContainer();
        for (let elMapBtn of elMapGroupContainer.Children()) {
            const mgName = elMapBtn.GetAttributeString("mapname", "");
            if (GameTypesAPI.GetMapGroupAttribute(mgName, strAttribute) === strValue) {
                arrNewMapgroups.push(mgName);
            }
        }
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
    function _MatchMapSelectionWithQuickSelect() {
        const elQuickSelectContainer = $.GetContextPanel().FindChildInLayoutFile("JsQuickSelectParent");
        if (!elQuickSelectContainer || m_isWorkshop)
            return;
        for (let elQuickBtn of elQuickSelectContainer.FindChildrenWithClassTraverse('preset-button')) {
            const arrQuickSelectMaps = _GetMapsFromQuickSelectMapGroup(elQuickBtn.id);
            let bMatch = true;
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
            const elFriendLeaderboards = elExistingContainer ? elExistingContainer.FindChildTraverse("FriendLeaderboards") : null;
            if (elFriendLeaderboards) {
                const strEmbeddedLeaderboardName = elFriendLeaderboards.GetAttributeString("type", '');
                if (strEmbeddedLeaderboardName) {
                    LeaderboardsAPI.Refresh(strEmbeddedLeaderboardName);
                }
            }
            if (bAllowReuseExistingContainer)
                return panelID;
            else
                elExistingContainer.DeleteAsync(0.0);
        }
        const container = $.CreatePanel("Panel", $('#MapSelectionList'), panelID, {
            class: 'map-selection-list map-selection-list--inner hidden'
        });
        container.AddClass('map-selection-list--' + serverType + '-' + gameMode);
        m_mapSelectionButtonContainers[panelID] = container;
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
        if (container.BHasLayoutSnippet(strSnippetNameOverride)) {
            container.BLoadLayoutSnippet(strSnippetNameOverride);
            const elMapTile = container.FindChildTraverse("MapTile");
            if (elMapTile)
                elMapTile.BLoadLayoutSnippet("MapGroupSelection");
        }
        else {
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
        $.RegisterEventHandler('PropertyTransitionEnd', container, (panel, propertyName) => {
            if (container === panel && propertyName === 'opacity' &&
                !container.id.startsWith("FriendLeaderboards")) {
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
        if (inDirectChallenge())
            return;
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
        const iconSize = 200;
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
                const mapGroupPanelID = _GetMapGroupPanelID() + strCurrentMapGroup;
                const mapGroupContainer = m_mapSelectionButtonContainers[m_activeMapGroupSelectionPanelID].FindChildTraverse('MapTile');
                const mapGroupPanel = mapGroupContainer.FindChildInLayoutFile(mapGroupPanelID);
                if (!mapGroupPanel) {
                    mapGroupContainer.RemoveAndDeleteChildren();
                    const btnMapGroup = _UpdateOrCreateMapGroupTile(strCurrentMapGroup, mapGroupContainer, null, mapGroupPanelID, 1);
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
        switch (_IsPlayingOnValveOfficial() ? _RealGameMode() : '') {
            case 'competitive':
            case 'scrimcomp2v2':
            case 'rush':
                _UpdateWaitTime(_GetMapListForServerTypeAndGameMode(panelID));
                break;
        }
        if (!inDirectChallenge())
            _SetEnabledStateForMapBtns(m_mapSelectionButtonContainers[panelID], isSearching, isHost);
        m_activeMapGroupSelectionPanelID = panelID;
        _ShowActiveMapSelectionTab(isEnabled);
        _PopulateQuickSelectBar(isSearching, isHost);
    }
    function _SelectMapButtonsFromSettings(settings) {
        m_selectedPracticeMap = '';
        const mapsGroups = settings.game.mapgroupname.split(',');
        const aListMaps = _GetMapListForServerTypeAndGameMode(m_activeMapGroupSelectionPanelID);
        for (let e of aListMaps) {
            const mapName = e.GetAttributeString("mapname", "invalid");
            e.checked = mapsGroups.includes(mapName);
            if (m_serverSetting === 'listen' && e.checked) {
                m_selectedPracticeMap = mapName.replace(/^mg_/, '');
            }
        }
    }
    function _ShowHideStartSearchBtn(isSearching, isHost) {
        let bShow = !isSearching && isHost ? true : false;
        const btnStartSearch = $.GetContextPanel().FindChildInLayoutFile('StartMatchBtn');
        if (bShow) {
            if (btnStartSearch.BHasClass('pressed')) {
                btnStartSearch.RemoveClass('pressed');
            }
            btnStartSearch.RemoveClass('hidden');
        }
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
        let elPracticeSettingsContainer = $('#id-play-menu-practicesettings-container');
        let sessionSettings = LobbyAPI.GetSessionSettings();
        let bForceHidden = (m_serverSetting !== 'listen') || m_isWorkshop || !LobbyAPI.IsSessionActive() || !sessionSettings;
        let bAnnotationAvailable = true;
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
            let elFeatureFrame = elChild.FindChildTraverse('id-play-menu-practicesettings-' + strFeatureName);
            let elFeatureSliderBtn = elFeatureFrame.FindChildTraverse('id-slider-btn');
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
                curvalue = sessionSettings.options['practicesettings_' + strFeatureName];
            }
            else {
                curvalue = GameInterfaceAPI.GetSettingString('ui_playsettings_listen_' + strFeatureName) === '1' ? 1 : 0;
                if (curvalue === 1) {
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
        if (!_IsPlayingOnValveOfficial() || !MyPersonaAPI.IsInventoryValid() || inDirectChallenge() || m_isWorkshop) {
            elPrimePanel.visible = false;
            return;
        }
        const LocalPlayerHasPrime = PartyListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid());
        elPrimePanel.visible = true;
        elPrimePanel.SetHasClass('play-menu-prime-logo-bg', LocalPlayerHasPrime);
        elGetPrimeBtn.visible = !LocalPlayerHasPrime;
        elPrimeStatus.visible = LocalPlayerHasPrime;
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
        elBtn.enabled = isEnabled;
    }
    function _UpdateLeaderboardBtn(gameMode, isOfficalMatchmaking = false) {
        const elLeaderboardButton = $('#PlayMenulLeaderboards');
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
                _ReloadLeaderboardLayoutGivenSettings(container, lbName, "#CSGO_official_leaderboard_survival_" + lbType, "#Cstrike_TitlesTXT_WINS");
            }
        }
    }
    function _UpdateRushFriendLeaderboards(gameMode) {
        const elRoot = $('#gameModeButtonContainer_rush_official');
        if (!elRoot)
            return;
        if (gameMode === 'rush') {
            const lbType = 'solo';
            const lbName = "official_leaderboard_rush_" + lbType;
            const elFriendLeaderboards = elRoot.FindChildTraverse("FriendLeaderboards");
            const sPreviousType = elFriendLeaderboards.GetAttributeString("type", '');
            if (!sPreviousType || !sPreviousType.startsWith(lbName)) {
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
    function _GetSelectedMapsForServerTypeAndGameMode(serverType, gameMode, bDontToggleMaps = false) {
        const isPlayingOnValveOfficial = _IsValveOfficialServer(serverType);
        const aListMapPanels = _GetMapListForServerTypeAndGameMode();
        if (!_CheckContainerHasAnyChildChecked(aListMapPanels)) {
            let preferencesMapsForThisMode = GameInterfaceAPI.GetSettingString('ui_playsettings_maps_' + serverType + '_' + gameMode);
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
        if ((serverType === 'official' && gameMode === 'survival')
            || (gameMode === 'rush')) {
            return GameInterfaceAPI.GetSettingString('ui_playsettings_maps_' + serverType + '_' + gameMode);
        }
        const selectedMaps = aListMapPanels.filter((e) => {
            return e.checked;
        })
            .reduce((accumulator, e) => {
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
            return [];
        }
        if (!_CheckContainerHasAnyChildChecked(children)) {
            let preferencesMapsForThisMode = GameInterfaceAPI.GetSettingString('ui_playsettings_maps_workshop');
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
            return e.checked;
        });
        return Array.from(selectedMaps);
    }
    function _GetSelectedWorkshopMap() {
        const mapButtons = _GetSelectedWorkshopMapButtons();
        const selectedMaps = mapButtons.reduce((accumulator, e) => {
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
    function _CheckContainerHasAnyChildChecked(aMapList) {
        if (aMapList.length < 1)
            return false;
        return aMapList.filter(map => map.checked).length > 0;
    }
    function _ValidateSessionSettings() {
        if (m_isWorkshop) {
            m_serverSetting = "listen";
        }
        if (!_IsGameModeAvailable(m_serverSetting, m_gameModeSetting)) {
            m_gameModeSetting = GameInterfaceAPI.GetSettingString("ui_playsettings_mode_" + m_serverSetting);
            m_singleSkirmishMapGroup = null;
            if (_IsSingleSkirmishString(_RealGameMode())) {
                m_singleSkirmishMapGroup = _GetSingleSkirmishMapGroupFromSingleSkirmishString(_RealGameMode());
                m_gameModeSetting = 'skirmish';
            }
            if (!_IsGameModeAvailable(m_serverSetting, m_gameModeSetting)) {
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
        if (!m_gameModeFlags[m_serverSetting + _RealGameMode()])
            _LoadGameModeFlagsFromSettings();
        if (GameModeFlags.DoesModeUseFlags(_RealGameMode())) {
            if (!GameModeFlags.AreFlagsValid(_RealGameMode(), m_gameModeFlags[m_serverSetting + _RealGameMode()])) {
                _setAndSaveGameModeFlags(0);
            }
        }
    }
    function _LoadGameModeFlagsFromSettings() {
        m_gameModeFlags[m_serverSetting + _RealGameMode()] = parseInt(GameInterfaceAPI.GetSettingString('ui_playsettings_flags_' + m_serverSetting + '_' + _RealGameMode()));
    }
    function _ApplySessionSettings() {
        if (m_serverSetting === 'official' && !m_isWorkshop && !inDirectChallenge()) {
            if (m_gameModeSetting === 'scrimcomp2v2') {
                MyPersonaAPI.HintLoadPipRanks('wingman');
            }
            else if (m_gameModeSetting === 'competitive') {
                MyPersonaAPI.HintLoadPipRanks('competitive');
            }
        }
        if (!LobbyAPI.BIsHost()) {
            return;
        }
        _ValidateSessionSettings();
        const serverType = m_serverSetting;
        let gameMode = _RealGameMode();
        let gameModeFlags = m_gameModeFlags[m_serverSetting + gameMode] ? m_gameModeFlags[m_serverSetting + gameMode] : 0;
        let primePreference = PartyListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid()) ? 1 : 0;
        let selectedMaps;
        if (m_isWorkshop)
            selectedMaps = _GetSelectedWorkshopMap();
        else if (inDirectChallenge()) {
            selectedMaps = 'mg_lobby_mapveto';
            gameModeFlags = 16;
            primePreference = 0;
        }
        else if (m_gameModeSetting === 'premier') {
            selectedMaps = 'mg_lobby_mapveto';
            primePreference = 1;
            m_challengeKey = '';
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
            settings.delete = {
                Options: {
                    challengekey: 1
                }
            };
        }
        if (selectedMaps.startsWith("random_")) {
            const arrMapGroups = _GetAvailableMapGroups(gameMode, false);
            const idx = 1 + Math.floor((Math.random() * (arrMapGroups.length - 1)));
            settings.update.Game.map = arrMapGroups[idx].substring(3);
        }
        if (m_isWorkshop) {
            GameInterfaceAPI.SetSettingString('ui_playsettings_maps_workshop', selectedMaps);
        }
        else {
            let singleSkirmishSuffix = '';
            if (m_singleSkirmishMapGroup) {
                singleSkirmishSuffix = '_' + _GetSingleSkirmishIdFromMapGroup(m_singleSkirmishMapGroup);
            }
            GameInterfaceAPI.SetSettingString('ui_playsettings_mode_' + serverType, m_gameModeSetting + singleSkirmishSuffix);
            if (!inDirectChallenge() && m_gameModeSetting !== 'premier') {
                GameInterfaceAPI.SetSettingString('ui_playsettings_maps_' + serverType + '_' + m_gameModeSetting + singleSkirmishSuffix, selectedMaps);
            }
        }
        LobbyAPI.UpdateSessionSettings(settings);
    }
    function _SessionSettingsUpdate(sessionState) {
        if (sessionState === "ready") {
            if (m_jsTimerUpdateHandle && typeof m_jsTimerUpdateHandle === "number") {
                $.CancelScheduled(m_jsTimerUpdateHandle);
                m_jsTimerUpdateHandle = false;
            }
            _Init();
        }
        else if (sessionState === "updated") {
            const settings = LobbyAPI.GetSessionSettings();
            _SyncDialogsFromSessionSettings(settings);
        }
        else if (sessionState === "closed") {
            m_jsTimerUpdateHandle = $.Schedule(0.5, _HalfSecondDelay_HideContentPanel);
        }
    }
    function _PipRankUpdate() {
        if (m_serverSetting == 'official' &&
            m_gameModeSetting === 'competitive') {
            const activeMapGroup = m_activeMapGroupSelectionPanelID;
            const btnSelectedMapGroup = m_mapSelectionButtonContainers[activeMapGroup].Children();
            for (let elPanel of btnSelectedMapGroup) {
                const mapGroupName = elPanel.GetAttributeString('mapname', '').replace(/^mg_/, '');
                _UpdateRatingEmblem(elPanel, mapGroupName);
            }
        }
    }
    function _HalfSecondDelay_HideContentPanel() {
        m_jsTimerUpdateHandle = false;
        $.DispatchEvent('HideContentPanel');
    }
    function _ReadyForDisplay() {
        _StartRotatingMapGroupTimer();
        _m_inventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _InventoryUpdated);
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
        const rawModes = [];
        const modes = [];
        const tags = [];
        for (let i = 0; i < mapTags.length; ++i) {
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
        panel.SetAttributeString('data-tooltip', tooltip);
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
        const container = $.CreatePanel("Panel", $('#MapSelectionList'), panelId, {
            class: 'map-selection-list map-selection-list--inner hidden'
        });
        container.AddClass('map-selection-list--workshop');
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
        GameInterfaceAPI.SetSettingString('player_botdifflast_s', botDiff);
    }
    PlayMenu.BotDifficultyChanged = BotDifficultyChanged;
    function _DisplayWorkshopModePopup() {
        const elSelectedMaps = _GetSelectedWorkshopMapButtons();
        let modes = [];
        if (elSelectedMaps.length === 0) {
            UiToolkitAPI.ShowGenericPopupTwoOptions($.Localize('#SFUI_Maps_Workshop_Title'), $.Localize('#SFUI_No_Subscribed_Maps_Desc'), '', '#CSGO_Workshop_Visit', () => $.DispatchEvent('CSGOOpenSteamWorkshop', 'Map'), "OK", () => { });
            $('#StartMatchBtn').RemoveClass('pressed');
            return;
        }
        for (let iMap = 0; iMap < elSelectedMaps.length; ++iMap) {
            const mapModes = elSelectedMaps[iMap].GetAttributeString('data-workshop-modes', '').split(',');
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
            return;
        }
        const children = container.Children();
        for (let i = 0; i < children.length; ++i) {
            const panel = children[i];
            const mapname = panel.GetAttributeString('mapname', '');
            if (mapname === '')
                continue;
            if (filter === '') {
                panel.visible = true;
                continue;
            }
            if (mapname.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            const modes = panel.GetAttributeString('data-workshop-modes', '');
            if (modes.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            const tooltip = panel.GetAttributeString('data-tooltip', '');
            if (tooltip.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            const elMapNameLabel = panel.FindChildTraverse('MapGroupName');
            if (elMapNameLabel && elMapNameLabel.text && elMapNameLabel.text.toLowerCase().includes(filter)) {
                panel.visible = true;
                continue;
            }
            panel.visible = false;
        }
    }
    function _SetPlayDropdownToWorkshop() {
        m_serverSetting = 'listen';
        m_isWorkshop = true;
        _UpdatePrimeBtn(false, LobbyAPI.BIsHost());
        _UpdatePracticeSettingsBtns(false, LobbyAPI.BIsHost());
        if (_GetSelectedWorkshopMap()) {
            _ApplySessionSettings();
        }
        else {
            _SwitchToWorkshopTab(true);
        }
        $.GetContextPanel().SwitchClass("gamemode", 'workshop');
        $.GetContextPanel().SwitchClass("serversetting", m_serverSetting);
    }
    function _WorkshopSubscriptionsChanged() {
        const panel = m_mapSelectionButtonContainers[k_workshopPanelId];
        if (panel) {
            panel.DeleteAsync(0.0);
            delete m_mapSelectionButtonContainers[k_workshopPanelId];
        }
        if (m_activeMapGroupSelectionPanelID != k_workshopPanelId) {
            return;
        }
        if (!LobbyAPI.IsSessionActive()) {
            m_activeMapGroupSelectionPanelID = null;
            return;
        }
        _SyncDialogsFromSessionSettings(LobbyAPI.GetSessionSettings());
        if (LobbyAPI.BIsHost()) {
            _ApplySessionSettings();
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
        $.RegisterForUnhandledEvent('DirectChallenge_GenRandomKey', _OnDirectChallengeRandom);
        $.RegisterForUnhandledEvent('DirectChallenge_EditKey', _OnDirectChallengeEdit);
        $.RegisterForUnhandledEvent('DirectChallenge_CopyKey', _OnDirectChallengeCopy);
        $.RegisterForUnhandledEvent('DirectChallenge_ChooseClanKey', _OnChooseClanKeyBtn);
        $.RegisterForUnhandledEvent('DirectChallenge_ClanChallengeKeySelected', _OnClanChallengeKeySelected);
        $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_PrivateQueuesUpdate', _OnPrivateQueuesUpdate);
        WorkshopAPI.QueryUGCItemSubscriptions();
    }
})(PlayMenu || (PlayMenu = {}));
