"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/characteranims.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="common/promoted_settings.ts" />
/// <reference path="popups/popup_acknowledge_item.ts" />
/// <reference path="new_news_entry_check.ts" />
/// <reference path="inspect.ts" />
/// <reference path="avatar.ts" />
/// <reference path="vanity_player_info.ts" />
/// <reference path="vanity_pet_info.ts" />
/// <reference path="particle_controls.ts" />
/// <reference path="video_setting_recommendations.ts" />
/// <reference path="generated/items_event_current_generated_store.d.ts" />
$.LogChannel('p.mainmenu', "LV_OFF");
var MainMenu;
(function (MainMenu) {
    const _m_bPerfectWorld = (MyPersonaAPI.GetLauncherType() === "perfectworld");
    let _m_activeTab = null;
    let _m_sideBarElementContextMenuActive = false;
    const _m_elContentPanel = $('#JsMainMenuContent');
    let _m_playedInitalFadeUp = false;
    const _m_maxMainMenuDisplayAgents = 5;
    let _m_nPetUpgradeLevel = null;
    const _m_elNotificationsContainer = $('#id-notifications-container');
    let _m_notificationSchedule = false;
    let _m_bVanityAnimationAlreadyStarted = false;
    let _m_bHasPopupNotification = false;
    let _m_popupNotificationCallbackHandle = -1;
    let _m_bMajorStoreBalanceChecked = false;
    let _m_tLastSeenDisconnectedFromGC = 0;
    const _m_NotificationBarColorClasses = [
        "NotificationRed", "NotificationYellow", "NotificationGreen", "NotificationLoggingOn"
    ];
    let _m_LobbyPlayerUpdatedEventHandler = null;
    let _m_LobbyMatchmakingSessionUpdateEventHandler = null;
    let _m_LobbyForceRestartVanityEventHandler = null;
    let _m_LobbyMainMenuSwitchVanityEventHandler = null;
    let _m_UiSceneFrameBoundaryEventHandler = null;
    let _m_equipSlotChangedHandler = null;
    let _m_storePopupElement = null;
    let m_TournamentPickBanPopup = null;
    let _m_jobFetchTournamentData = null;
    const TOURNAMENT_FETCH_DELAY = 10;
    const nNumNewSettings = UpdateSettingsMenuAlert();
    const m_MainMenuTopBarParticleFX = $('#MainMenuNavigateParticles');
    ParticleControls.UpdateMainMenuTopBar(m_MainMenuTopBarParticleFX, '');
    let _m_nActiveFrameCount = 0;
    let _m_bTriedShowVideoSettingRecommendation = false;
    const _m_acknowledgedRentalExpirationCrateIds = new Set();
    let _m_bPreLoadedTabs = false;
    function UpdateSettingsMenuAlert() {
        let elNewSettingsAlert = $("#MainMenuSettingsAlert");
        if (elNewSettingsAlert) {
            let nNewSettings = PromotedSettingsUtil.GetUnacknowledgedPromotedSettings().length;
            elNewSettingsAlert.SetDialogVariable("alert_value", $.Localize("#Store_Price_New"));
            elNewSettingsAlert.SetHasClass('hidden', nNewSettings < 1);
            return nNewSettings;
        }
        return 0;
    }
    if (nNumNewSettings > 0) {
        const hPromotedSettingsViewedEvt = $.RegisterForUnhandledEvent("MainMenu_PromotedSettingsViewed", () => {
            UpdateSettingsMenuAlert();
            $.UnregisterForUnhandledEvent("MainMenu_PromotedSettingsViewed", hPromotedSettingsViewedEvt);
        });
    }
    function _OnInitFadeUp() {
        if (!_m_playedInitalFadeUp) {
            $('#MainMenuContainerPanel').TriggerClass('show');
            _m_playedInitalFadeUp = true;
            _RegisterOnShowEvents();
            _UpdateBackgroundMap();
        }
    }
    function SetHideTranstionOnLeftColumn() {
        const elLeftColumn = $.FindChildInContext('#JsLeftColumn');
        function fnOnPropertyTransitionEndEvent(panel, propertyName) {
            if (elLeftColumn === panel && propertyName === 'opacity') {
                if (elLeftColumn.visible === true && elLeftColumn.BIsTransparent()) {
                    elLeftColumn.SetReadyForDisplay(false);
                    elLeftColumn.visible = false;
                    return true;
                }
            }
            return false;
        }
        $.RegisterEventHandler('PropertyTransitionEnd', elLeftColumn, fnOnPropertyTransitionEndEvent);
    }
    function _FetchTournamentData() {
        if (_m_jobFetchTournamentData)
            return;
        TournamentsAPI.RequestTournaments();
        _m_jobFetchTournamentData = $.Schedule(TOURNAMENT_FETCH_DELAY, () => {
            _m_jobFetchTournamentData = null;
            _FetchTournamentData();
        });
    }
    function _StopFetchingTournamentData() {
        if (_m_jobFetchTournamentData) {
            $.CancelScheduled(_m_jobFetchTournamentData);
            _m_jobFetchTournamentData = null;
        }
    }
    function _UpdateBackgroundMap() {
        let savedMapName = GameInterfaceAPI.GetSettingString('ui_mainmenu_bkgnd_movie');
        let backgroundMap = !savedMapName ? 'de_dust2_vanity' : savedMapName + '_vanity';
        let elMapPanel = $('#JsMainmenu_Vanity');
        if (!(elMapPanel && elMapPanel.IsValid())) {
            elMapPanel = $.CreatePanel('MapVanityPreviewPanel', $('#JsMainmenu_Vanity-Container'), 'JsMainmenu_Vanity', {
                "require-composition-layer": "true",
                "pin-fov": "vertical",
                class: 'align-preview',
                camera: 'cam_default',
                player: "true",
                playermodel: "",
                map: backgroundMap,
                playername: "vanity_character",
                animgraphcharactermode: 'main-menu',
                initial_entity: 'vanity_character',
                mouse_rotate: 'false',
                parallax_degrees: ".5",
                parallax_offset: "200.0",
                hittest: 'false'
            });
            elMapPanel.Data().loadedMap = backgroundMap;
            elMapPanel.Data().parallax_zoomed = 50;
            elMapPanel.Data().parallax_unzoomed = 200;
            m_bRestartBackgroundMapSound = true;
        }
        else if (elMapPanel.Data().loadedMap !== backgroundMap) {
            elMapPanel.SwitchMap(backgroundMap);
            elMapPanel.Data().loadedMap = backgroundMap;
            m_bRestartBackgroundMapSound = true;
            _ResetPetZoom();
        }
        if (m_bRestartBackgroundMapSound) {
            $.Schedule(0.1, function () {
                _PlayBackgroundMapSound(savedMapName);
            });
            m_bRestartBackgroundMapSound = false;
        }
        if (backgroundMap === 'de_nuke_vanity') {
            elMapPanel.FireEntityInput('main_light', 'SetBrightness', '2');
            elMapPanel.FireEntityInput('main_light', 'Enable');
        }
        InspectModelImage.DisableItemLighting(elMapPanel);
        _SetCSMSplitPlane0DistanceOverride(elMapPanel, backgroundMap);
        _SetBarnlightShadowScaleOverride(elMapPanel, backgroundMap);
        _ShowLeaderPet(elMapPanel);
        _SetPetInteractionEnabled(elMapPanel, true);
        return elMapPanel;
    }
    function _SetCSMSplitPlane0DistanceOverride(elPanel, backgroundMap) {
        let flSplitPlane0Distance = 0.0;
        if (backgroundMap === 'de_ancient_vanity') {
            flSplitPlane0Distance = 80.0;
        }
        else if (backgroundMap === 'de_anubis_vanity') {
            flSplitPlane0Distance = 100.0;
        }
        else if (backgroundMap === 'ar_baggage_vanity') {
            flSplitPlane0Distance = 200.0;
        }
        else if (backgroundMap === 'de_dust2_vanity') {
            flSplitPlane0Distance = 130.0;
        }
        else if (backgroundMap === 'de_inferno_vanity') {
            flSplitPlane0Distance = 150.0;
        }
        else if (backgroundMap === 'cs_italy_vanity') {
            flSplitPlane0Distance = 200.0;
        }
        else if (backgroundMap === 'de_mirage_vanity') {
            flSplitPlane0Distance = 120.0;
        }
        else if (backgroundMap === 'de_overpass_vanity') {
            flSplitPlane0Distance = 150.0;
        }
        else if (backgroundMap === 'de_vertigo_vanity') {
            flSplitPlane0Distance = 90.0;
        }
        if (flSplitPlane0Distance > 0.0) {
            elPanel.SetCSMSplitPlane0DistanceOverride(flSplitPlane0Distance);
        }
    }
    function _SetBarnlightShadowScaleOverride(elPanel, backgroundMap) {
        let flBarnlightShadowScale = 4.0;
        if (backgroundMap === 'warehouse_vanity') {
            flBarnlightShadowScale = 1.0;
        }
        else if (backgroundMap === 'de_train_vanity') {
            flBarnlightShadowScale = 1.0;
        }
        if (flBarnlightShadowScale > 0.0) {
            elPanel.SetBarnlightShadowScaleOverride(flBarnlightShadowScale);
        }
    }
    let m_backgroundMapSoundHandle = null;
    let m_bRestartBackgroundMapSound = false;
    function _PlayBackgroundMapSound(backgroundMap) {
        let soundName = 'UIPanorama.BG_' + backgroundMap;
        if (m_backgroundMapSoundHandle) {
            UiToolkitAPI.StopSoundEvent(m_backgroundMapSoundHandle, 0.1);
            m_backgroundMapSoundHandle = null;
        }
        m_backgroundMapSoundHandle = UiToolkitAPI.PlaySoundEvent(soundName);
    }
    function _ShowLeaderPet(elMapPanel) {
        const leaderPetItemId = elMapPanel.GetLeaderPetItemId();
        if (!VanityPetInfo.BShouldKeepZoom(leaderPetItemId)) {
            _ResetPetZoom();
        }
        if (leaderPetItemId === '0') {
            _HidePetEntities(elMapPanel);
        }
        else {
            _ShowPetEntities(elMapPanel, leaderPetItemId);
        }
    }
    function _HidePetEntities(elPanel) {
        _m_nPetUpgradeLevel = null;
        UpdatePetInfoPanel(elPanel, '0');
    }
    function _ShowPetEntities(elPanel, petItemId) {
        _m_nPetUpgradeLevel = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}upgrade level'));
        UpdatePetInfoPanel(elPanel, petItemId);
    }
    function UpdatePetInfoPanel(elMapPanel, petItemId) {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityInfo');
        let elInfoPanel = VanityPetInfo.CreateOrUpdatePetInfoPanel(elParent, petItemId);
        if (elInfoPanel) {
            VanityPetInfo.SetZoomBtns(elMapPanel, elInfoPanel, petItemId);
            $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityParent').AddBlurPanel(elInfoPanel.FindChildInLayoutFile('vanity-pet-actions'));
            $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityParent').AddBlurPanel(elInfoPanel.FindChildInLayoutFile('id-pet-milestone-egg'));
            $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityParent').AddBlurPanel(elInfoPanel.FindChildInLayoutFile('id-pet-milestone-chick'));
            $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityParent').AddBlurPanel(elInfoPanel.FindChildInLayoutFile('id-pet-milestone-pullet'));
            $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityParent').AddBlurPanel(elInfoPanel.FindChildInLayoutFile('id-pet-milestone-hen'));
        }
    }
    function _ResetPetZoom() {
        const vanityPanel = $('#JsMainmenu_Vanity');
        if (vanityPanel && vanityPanel.IsValid()) {
            VanityPetInfo.ResetPetZoom(vanityPanel);
        }
    }
    function _RegisterOnShowEvents() {
        NewNewsEntryCheck.RegisterForRssReceivedEvent();
        if (!_m_LobbyMatchmakingSessionUpdateEventHandler && !GameStateAPI.IsLocalPlayerPlayingMatch()) {
            _m_LobbyMatchmakingSessionUpdateEventHandler = $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _LobbyPlayerUpdated);
            _m_LobbyPlayerUpdatedEventHandler = $.RegisterForUnhandledEvent("PanoramaComponent_PartyList_RebuildPartyList", _LobbyPlayerUpdated);
            _m_LobbyForceRestartVanityEventHandler = $.RegisterForUnhandledEvent("ForceRestartVanity", _ForceRestartVanity);
            _m_LobbyMainMenuSwitchVanityEventHandler = $.RegisterForUnhandledEvent("MainMenuSwitchVanity", _SwitchVanity);
        }
        if (!_m_UiSceneFrameBoundaryEventHandler) {
            _m_UiSceneFrameBoundaryEventHandler = $.RegisterForUnhandledEvent("UISceneFrameBoundary", _OnUISceneFrameBoundary);
        }
        if (!_m_equipSlotChangedHandler) {
            _m_equipSlotChangedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', _UpdateLocalPlayerVanity);
        }
    }
    function _OnShowMainMenu() {
        $.DispatchEvent('PlayMainMenuMusic', true, true);
        GameInterfaceAPI.ResetChickenAudio();
        m_bRestartBackgroundMapSound = true;
        _RegisterOnShowEvents();
        _m_bVanityAnimationAlreadyStarted = false;
        _LobbyPlayerUpdated();
        _OnInitFadeUp();
        $('#MainMenuNavBarPlay').SetHasClass('pausemenu-navbar__btn-small--hidden', false);
        _UpdateOverwatch();
        _UpdateNotifications();
        _UpdateInventoryBtnAlert();
        _UpdateStoreAlert();
        _GcLogonNotificationReceived();
        _CheckPopupNotificationsAtLogon();
        _UpdateUnlockCompAlert();
        _FetchTournamentData();
        _ShowFloatingPanels();
        $('#MainMenuNavBarHome').checked = true;
        if (GameTypesAPI.ShouldShowNewUserPopup()) {
            _NewUser_ShowTrainingCompletePopup();
        }
        if (!_m_bPreLoadedTabs) {
            _LoadTab('JsSettings', 'settings/settings');
            _OpenPlayMenu();
            OnHomeButtonPressed();
            _m_bPreLoadedTabs = true;
        }
        _ResetAnnotationsDropDown();
        _UpdateBackgroundMap();
    }
    function _TournamentDraftUpdate() {
        if (!m_TournamentPickBanPopup || !m_TournamentPickBanPopup.IsValid()) {
            m_TournamentPickBanPopup = UiToolkitAPI.ShowCustomLayoutPopup('tournament_pickban_popup', 'file://{resources}/layout/popups/popup_tournament_pickban.xml');
        }
    }
    let _m_bPopupNotificationAtLogonShown = false;
    function _CheckPopupNotificationsAtLogon() {
        if (_m_bPopupNotificationAtLogonShown)
            return;
        const strNotification = MyPersonaAPI.GetTradeBanNotification();
        if (strNotification) {
            const refTS = 1695849359;
            const numSTill = -NewsAPI.GetNumSecondsTillGcTimestamp(refTS);
            const valSnooze = GameInterfaceAPI.GetSettingString('ui_notification_tb_snooze');
            const numSnooze = valSnooze ? parseInt(valSnooze) : 0;
            if (numSTill && (!numSnooze || Math.abs(numSTill - numSnooze) > (30 * 24 * 3600))) {
                _m_bPopupNotificationAtLogonShown = true;
                UiToolkitAPI.ShowGenericPopupOneOptionBgStyle("#SFUI_LoginPerfectWorld_Title_Info", strNotification, "", "#UI_OK", () => { GameInterfaceAPI.SetSettingString('ui_notification_tb_snooze', '' + numSTill); }, "dim");
            }
        }
    }
    let _m_bGcLogonNotificationReceivedOnce = false;
    function _GcLogonNotificationReceived() {
        if (_m_bGcLogonNotificationReceivedOnce)
            return;
        const strFatalError = MyPersonaAPI.GetClientLogonFatalError();
        if (strFatalError
            && (strFatalError !== "ShowGameLicenseNoOnlineLicensePW")
            && (strFatalError !== "ShowGameLicenseNoOnlineLicense")) {
            _m_bGcLogonNotificationReceivedOnce = true;
            if (strFatalError === "ShowGameLicenseNeedToLinkAccountsWithMoreInfo") {
                UiToolkitAPI.ShowGenericPopupThreeOptionsBgStyle("#CSGO_Purchasable_Game_License_Short", "#SFUI_LoginLicenseAssist_PW_NeedToLinkAccounts_WW_hint", "", "#UI_Yes", () => SteamOverlayAPI.OpenURL("https://community.csgo.com.cn/join/pwlink_csgo"), "#UI_No", () => { }, "#ShowFAQ", () => _OnGcLogonNotificationReceived_ShowFaqCallback(), "dim");
            }
            else if (strFatalError === "ShowGameLicenseNeedToLinkAccounts") {
                _OnGcLogonNotificationReceived_ShowLicenseYesNoBox("#SFUI_LoginLicenseAssist_PW_NeedToLinkAccounts", "https://community.csgo.com.cn/join/pwlink_csgo");
            }
            else if (strFatalError === "ShowGameLicenseHasLicensePW") {
                _OnGcLogonNotificationReceived_ShowLicenseYesNoBox("#SFUI_LoginLicenseAssist_HasLicense_PW", "https://community.csgo.com.cn/join/pwlink_csgo?needlicense=1");
            }
            else if (strFatalError === "ShowGameLicenseNoOnlineLicensePW") {
            }
            else if (strFatalError === "ShowGameLicenseNoOnlineLicense") {
            }
            else {
                UiToolkitAPI.ShowGenericPopupOneOptionBgStyle("#SFUI_LoginPerfectWorld_Title_Error", strFatalError, "", "#GameUI_Quit", () => GameInterfaceAPI.ConsoleCommand("quit"), "dim");
            }
            return;
        }
        const nAntiAddictionTrackingState = MyPersonaAPI.GetTimePlayedTrackingState();
        if (nAntiAddictionTrackingState > 0) {
            _m_bGcLogonNotificationReceivedOnce = true;
            const pszDialogTitle = "#SFUI_LoginPerfectWorld_Title_Info";
            let pszDialogMessageText = "#SFUI_LoginPerfectWorld_AntiAddiction1";
            let pszOverlayUrlToOpen = null;
            if (nAntiAddictionTrackingState != 2) {
                pszDialogMessageText = "#SFUI_LoginPerfectWorld_AntiAddiction2";
                pszOverlayUrlToOpen = "https://community.csgo.com.cn/join/pwcompleteaccountinfo";
            }
            if (pszOverlayUrlToOpen) {
                UiToolkitAPI.ShowGenericPopupYesNo(pszDialogTitle, pszDialogMessageText, "", () => SteamOverlayAPI.OpenURL(pszOverlayUrlToOpen), () => { });
            }
            else {
                UiToolkitAPI.ShowGenericPopup(pszDialogTitle, pszDialogMessageText, "");
            }
            return;
        }
    }
    let _m_numGameMustExitNowForAntiAddictionHandled = 0;
    let _m_panelGameMustExitDialog = null;
    function _GameMustExitNowForAntiAddiction() {
        if (_m_panelGameMustExitDialog && _m_panelGameMustExitDialog.IsValid())
            return;
        if (_m_numGameMustExitNowForAntiAddictionHandled >= 100)
            return;
        ++_m_numGameMustExitNowForAntiAddictionHandled;
        _m_panelGameMustExitDialog =
            UiToolkitAPI.ShowGenericPopupOneOptionBgStyle("#GameUI_QuitConfirmationTitle", "#UI_AntiAddiction_ExitGameNowMessage", "", "#GameUI_Quit", () => GameInterfaceAPI.ConsoleCommand("quit"), "dim");
    }
    function _OnGcLogonNotificationReceived_ShowLicenseYesNoBox(strTextMessage, pszOverlayUrlToOpen) {
        UiToolkitAPI.ShowGenericPopupTwoOptionsBgStyle("#CSGO_Purchasable_Game_License_Short", strTextMessage, "", "#UI_Yes", () => SteamOverlayAPI.OpenURL(pszOverlayUrlToOpen), "#UI_No", () => { }, "dim");
    }
    function _OnGcLogonNotificationReceived_ShowFaqCallback() {
        SteamOverlayAPI.OpenURL("https://support.steampowered.com/kb_article.php?ref=6026-IFKZ-7043&l=schinese");
        _m_bGcLogonNotificationReceivedOnce = false;
        _GcLogonNotificationReceived();
    }
    function _OnHideMainMenu() {
        const vanityPanel = $('#JsMainmenu_Vanity');
        if (vanityPanel) {
            CharacterAnims.CancelScheduledAnim(vanityPanel);
        }
        _m_elContentPanel.RemoveClass('mainmenu-content--animate');
        _m_elContentPanel.AddClass('mainmenu-content--offscreen');
        _CancelNotificationSchedule();
        _UnregisterShowEvents();
        _CloseAllVisiblePopups();
        _StopFetchingTournamentData();
        if (vanityPanel) {
            _SetPetInteractionEnabled(vanityPanel, false);
        }
    }
    function _UnregisterShowEvents() {
        NewNewsEntryCheck.UnRegisterForRssReceivedEvent();
        if (_m_LobbyMatchmakingSessionUpdateEventHandler) {
            $.UnregisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _m_LobbyMatchmakingSessionUpdateEventHandler);
            _m_LobbyMatchmakingSessionUpdateEventHandler = null;
        }
        if (_m_LobbyPlayerUpdatedEventHandler) {
            $.UnregisterForUnhandledEvent("PanoramaComponent_PartyList_RebuildPartyList", _m_LobbyPlayerUpdatedEventHandler);
            _m_LobbyPlayerUpdatedEventHandler = null;
        }
        if (_m_LobbyForceRestartVanityEventHandler) {
            $.UnregisterForUnhandledEvent("ForceRestartVanity", _m_LobbyForceRestartVanityEventHandler);
            _m_LobbyForceRestartVanityEventHandler = null;
        }
        if (_m_LobbyMainMenuSwitchVanityEventHandler) {
            $.UnregisterForUnhandledEvent("MainMenuSwitchVanity", _m_LobbyMainMenuSwitchVanityEventHandler);
            _m_LobbyMainMenuSwitchVanityEventHandler = null;
        }
        if (_m_UiSceneFrameBoundaryEventHandler) {
            $.UnregisterForUnhandledEvent("UISceneFrameBoundary", _m_UiSceneFrameBoundaryEventHandler);
            _m_UiSceneFrameBoundaryEventHandler = null;
        }
        if (_m_equipSlotChangedHandler) {
            $.UnregisterForUnhandledEvent("PanoramaComponent_Loadout_EquipSlotChanged", _m_equipSlotChangedHandler);
            _m_equipSlotChangedHandler = null;
        }
    }
    function _OnShowPauseMenu() {
        const elContextPanel = $.GetContextPanel();
        elContextPanel.AddClass('MainMenuRootPanel--PauseMenuMode');
        elContextPanel.SetHasClass('MainMenuRootPanel--PauseMenuDuringDemoPlayback', GameStateAPI.IsDemoOrHltv());
        $('#id-pausemenu-mission-panel').SetHasClass('hide-non-prime', MyPersonaAPI.GetElevatedState() != 'elevated');
        const bQueuedMatchmaking = GameStateAPI.IsQueuedMatchmaking();
        const bGotvSpectating = elContextPanel.IsGotvSpectating();
        const bIsCommunityServer = !_m_bPerfectWorld && MatchStatsAPI.IsConnectedToCommunityServer();
        $('#MainMenuNavBarPlay').SetHasClass('pausemenu-navbar__btn-small--hidden', true);
        $('#MainMenuNavBarSwitchTeams').SetHasClass('pausemenu-navbar__btn-small--hidden', (bQueuedMatchmaking || bGotvSpectating));
        $('#MainMenuNavBarVote').SetHasClass('pausemenu-navbar__btn-small--hidden', (bGotvSpectating));
        $('#MainMenuNavBarReportServer').SetHasClass('pausemenu-navbar__btn-small--hidden', !bIsCommunityServer);
        OnHomeButtonPressed();
        _SetupAnnotationOptions(false);
    }
    function _ResetAnnotationsDropDown() {
        let elAnnotationDropDown = $('#id-play-menu-pausemenu-annotations-dropdown');
        elAnnotationDropDown.SetSelectedIndex(0);
        elAnnotationDropDown.Data().m_mapBspName = "";
    }
    function _EnableGuidesDropdown() {
        let elAnnotationsInternal = $("#id-play-menu-pausemenu-annotations__internal");
        let elAnnotationDropDown = $('#id-play-menu-pausemenu-annotations-dropdown');
        let elAnnotationsRoundRestrictionLabel = $('#id-play-menu-pausemenu-annotations-roundrestricted');
        elAnnotationsInternal.enabled = true;
        elAnnotationsInternal.visible = true;
        elAnnotationDropDown.visible = true;
        elAnnotationsRoundRestrictionLabel.visible = false;
    }
    function _DisableGuidesDropdown() {
        let elAnnotationsInternal = $("#id-play-menu-pausemenu-annotations__internal");
        let elAnnotationDropDown = $('#id-play-menu-pausemenu-annotations-dropdown');
        let elAnnotationsRoundRestrictionLabel = $('#id-play-menu-pausemenu-annotations-roundrestricted');
        elAnnotationsInternal.enabled = false;
        elAnnotationsInternal.visible = false;
        elAnnotationDropDown.visible = false;
        elAnnotationsRoundRestrictionLabel.visible = false;
    }
    function _RoundRestrictedGuidesDropdown() {
        let elAnnotationsInternal = $("#id-play-menu-pausemenu-annotations__internal");
        let elAnnotationDropDown = $('#id-play-menu-pausemenu-annotations-dropdown');
        let elAnnotationsRoundRestrictionLabel = $('#id-play-menu-pausemenu-annotations-roundrestricted');
        elAnnotationsInternal.enabled = false;
        elAnnotationsInternal.visible = true;
        elAnnotationDropDown.visible = false;
        elAnnotationsRoundRestrictionLabel.visible = true;
        let nMaxRound = GameInterfaceAPI.GetSettingString('sv_annotation_limits_max_rounds_per_half');
        elAnnotationsRoundRestrictionLabel.SetDialogVariable('rounds', nMaxRound);
    }
    function _SetupAnnotationOptions(bForce) {
        switch (GameStateAPI.GetAnnotationsViewingLevel()) {
            case 3:
            case 2:
                _EnableGuidesDropdown();
                break;
            case 1:
                _RoundRestrictedGuidesDropdown();
                break;
            case 0:
                _DisableGuidesDropdown();
                break;
        }
        let elAnnotationDropDown = $('#id-play-menu-pausemenu-annotations-dropdown');
        if (elAnnotationDropDown.Data().m_mapBspName !== GameStateAPI.GetMapBSPName() ||
            bForce) {
            elAnnotationDropDown.RebuildOptions(GameStateAPI.GetMapBSPName(), true);
            elAnnotationDropDown.Data().m_mapBspName = GameStateAPI.GetMapBSPName();
        }
    }
    function _OnHidePauseMenu() {
        $.GetContextPanel().RemoveClass('MainMenuRootPanel--PauseMenuMode');
        $.GetContextPanel().SetHasClass('MainMenuRootPanel--PauseMenuDuringDemoPlayback', false);
        _DeletePauseMenuMissionPanel();
        OnHomeButtonPressed();
    }
    function _BCheckTabCanBeOpenedRightNow(tab) {
        if (tab === 'JsInventory' || tab === 'JsMainMenuStore' || tab === 'JsLoadout') {
            const restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
            if (restrictions !== false) {
                LicenseUtil.ShowLicenseRestrictions(restrictions);
                return false;
            }
        }
        if (tab === 'JsInventory' || tab === 'JsPlayerStats' || tab === 'JsLoadout' || tab === 'JsMainMenuStore') {
            if (!MyPersonaAPI.IsInventoryValid() || !MyPersonaAPI.IsConnectedToGC()) {
                UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => { });
                return false;
            }
        }
        return true;
    }
    function _LoadTab(tab, XmlName, setActiveSection = '') {
        if (!$.GetContextPanel().FindChildInLayoutFile(tab)) {
            const newPanel = $.CreatePanel('Panel', _m_elContentPanel, tab);
            if (setActiveSection !== '') {
                newPanel.SetAttributeString('set-active-section', setActiveSection);
            }
            newPanel.BLoadLayout('file://{resources}/layout/' + XmlName + '.xml', false, false);
            newPanel.SetReadyForDisplay(false);
            newPanel.RegisterForReadyEvents(true);
            $.RegisterEventHandler('PropertyTransitionEnd', newPanel, (panel, propertyName) => {
                if (newPanel.id === panel.id && propertyName === 'opacity') {
                    if (newPanel.visible === true && newPanel.BIsTransparent()) {
                        newPanel.SetReadyForDisplay(false);
                        newPanel.visible = false;
                        return true;
                    }
                    else if (newPanel.visible === true) {
                        $.DispatchEvent('MainMenuTabShown', tab);
                    }
                }
                return false;
            });
            newPanel.AddClass('mainmenu-content--hidden');
            newPanel.visible = false;
        }
    }
    function NavigateToTab(tab, XmlName, setActiveSection = '') {
        if (!_BCheckTabCanBeOpenedRightNow(tab)) {
            OnHomeButtonPressed();
            return;
        }
        if (tab === 'JsPlayerStats') {
            return;
        }
        $.DispatchEvent('PlayMainMenuMusic', true, false);
        GameInterfaceAPI.SetSettingString('panorama_play_movie_ambient_sound', '0');
        _LoadTab(tab, XmlName, setActiveSection);
        ParticleControls.UpdateMainMenuTopBar(m_MainMenuTopBarParticleFX, tab);
        if (_m_activeTab !== tab) {
            if (XmlName && _m_bPreLoadedTabs) {
                let soundName = '';
                if (XmlName === 'mainmenu_store_fullscreen') {
                    if (setActiveSection !== '') {
                        $.GetContextPanel().FindChildInLayoutFile(tab).SetAttributeString('set-active-section', setActiveSection);
                    }
                    soundName = 'UIPanorama.tab_mainmenu_shop';
                    $.DispatchEvent('UpdateXpShop');
                }
                else if (XmlName === 'loadout_grid') {
                    soundName = 'UIPanorama.tab_mainmenu_loadout';
                }
                else {
                    soundName = 'tab_' + XmlName.replace('/', '_');
                }
                $.DispatchEvent('CSGOPlaySoundEffect', soundName, 'MOUSE');
            }
            if (_m_activeTab) {
                $.GetContextPanel().CancelDrag();
                const panelToHide = $.GetContextPanel().FindChildInLayoutFile(_m_activeTab);
                panelToHide.AddClass('mainmenu-content--hidden');
            }
            _m_activeTab = tab;
            const activePanel = $.GetContextPanel().FindChildInLayoutFile(tab);
            activePanel.RemoveClass('mainmenu-content--hidden');
            activePanel.visible = true;
            activePanel.SetReadyForDisplay(true);
        }
        _ShowContentPanel();
    }
    MainMenu.NavigateToTab = NavigateToTab;
    function _UpdateChickenAudioForContentPanel(bContentPanelOpen) {
        GameInterfaceAPI.SetChickenAudioSuppressed('mainmenu_content', bContentPanelOpen);
    }
    function _ShowContentPanel() {
        if (_m_elContentPanel.BHasClass('mainmenu-content--offscreen')) {
            _m_elContentPanel.AddClass('mainmenu-content--animate');
            _m_elContentPanel.RemoveClass('mainmenu-content--offscreen');
            _m_elContentPanel.SetFocus();
        }
        $.GetContextPanel().AddClass("mainmenu-content--open");
        _UpdateChickenAudioForContentPanel(true);
        $.DispatchEvent('ShowContentPanel');
        _DimMainMenuBackground(false);
        _HideFloatingPanels();
    }
    function _OnHideContentPanel() {
        _m_elContentPanel.AddClass('mainmenu-content--animate');
        _m_elContentPanel.AddClass('mainmenu-content--offscreen');
        $.GetContextPanel().RemoveClass("mainmenu-content--open");
        _UpdateChickenAudioForContentPanel(false);
        const elActiveNavBarBtn = _GetActiveNavBarButton();
        if (elActiveNavBarBtn && elActiveNavBarBtn.id !== 'MainMenuNavBarHome') {
            elActiveNavBarBtn.checked = false;
        }
        _DimMainMenuBackground(true);
        if (_m_activeTab) {
            $.GetContextPanel().CancelDrag();
            const panelToHide = $.GetContextPanel().FindChildInLayoutFile(_m_activeTab);
            panelToHide.AddClass('mainmenu-content--hidden');
        }
        _m_activeTab = '';
        _ShowFloatingPanels();
    }
    function _OnShowFullScreenOpaquePopup() {
        $('#MainMenuInput').SetHasClass('HiddenByPopup', true);
    }
    function _OnCloseAllFullScreenOpaquePopups() {
        $('#MainMenuInput').SetHasClass('HiddenByPopup', false);
    }
    function _GetActiveNavBarButton() {
        const elNavBar = $('#MainMenuNavBarTop');
        const children = elNavBar.Children();
        const count = children.length;
        for (let i = 0; i < count; i++) {
            if (children[i].IsSelected()) {
                return children[i];
            }
        }
    }
    function ExpandSidebar(AutoClose = false) {
        const elSidebar = $('#JsMainMenuSidebar');
        if (elSidebar.BHasClass('mainmenu-sidebar--minimized')) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'sidemenu_slidein', 'MOUSE');
        }
        elSidebar.RemoveClass('mainmenu-sidebar--minimized');
        _SlideSearchPartyParticles(true);
        $.DispatchEvent('SidebarIsCollapsed', false);
        _DimMainMenuBackground(false);
        if (AutoClose) {
            $.Schedule(1, MinimizeSidebar);
        }
    }
    MainMenu.ExpandSidebar = ExpandSidebar;
    function MinimizeSidebar() {
        if (_m_elContentPanel == null) {
            return;
        }
        if (_m_sideBarElementContextMenuActive) {
            return;
        }
        const elSidebar = $('#JsMainMenuSidebar');
        if (!elSidebar.BHasClass('mainmenu-sidebar--minimized')) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'sidemenu_slideout', 'MOUSE');
        }
        elSidebar.AddClass('mainmenu-sidebar--minimized');
        _SlideSearchPartyParticles(false);
        $.DispatchEvent('SidebarIsCollapsed', true);
        _DimMainMenuBackground(true);
    }
    MainMenu.MinimizeSidebar = MinimizeSidebar;
    function _OnSideBarElementContextMenuActive(bActive) {
        _m_sideBarElementContextMenuActive = bActive;
        $.Schedule(0.25, () => {
            if (!$('#JsMainMenuSidebar').BHasHoverStyle())
                MinimizeSidebar();
        });
        _DimMainMenuBackground(false);
    }
    function _DimMainMenuBackground(removeDim) {
        if (removeDim && _m_elContentPanel.BHasClass('mainmenu-content--offscreen') &&
            $('#mainmenu-content__blur-target').BHasHoverStyle() === false) {
            $('#MainMenuBackground').RemoveClass('Dim');
        }
        else
            $('#MainMenuBackground').AddClass('Dim');
    }
    function OnHomeButtonPressed() {
        $.DispatchEvent('HideContentPanel');
        ParticleControls.UpdateMainMenuTopBar(m_MainMenuTopBarParticleFX, '');
        const vanityPanel = $('#JsMainmenu_Vanity');
        if (vanityPanel && vanityPanel.IsValid()) {
            vanityPanel.Pause();
            _ResetPetZoom();
        }
        $('#MainMenuNavBarHome').checked = true;
        _CheckRankUpRedemptionStore();
    }
    MainMenu.OnHomeButtonPressed = OnHomeButtonPressed;
    function OnQuitButtonPressed() {
        UiToolkitAPI.ShowGenericPopupOneOptionCustomCancelBgStyle('#UI_ConfirmExitTitle', '#UI_ConfirmExitMessage', '', '#UI_Quit', () => QuitGame('Option1'), '#UI_Return', () => { }, 'dim');
    }
    MainMenu.OnQuitButtonPressed = OnQuitButtonPressed;
    function QuitGame(msg) {
        GameInterfaceAPI.ConsoleCommand('quit');
    }
    function _InitFriendsList() {
        const friendsList = $.CreatePanel('Panel', $.FindChildInContext('#mainmenu-sidebar__blur-target'), 'JsFriendsList');
        friendsList.BLoadLayout('file://{resources}/layout/friendslist.xml', false, false);
    }
    function _HideMainMenuNewsPanel() {
        const elNews = $.FindChildInContext('#JsNewsContainer');
        elNews.SetHasClass('news-panel--hide-news-panel', true);
        elNews.SetHasClass('news-panel-style-feature-panel-visible', false);
    }
    function _ShowFloatingPanels() {
        $.FindChildInContext('#JsLeftColumn').SetHasClass('hidden', false);
        $.FindChildInContext('#JsRightColumn').SetHasClass('hidden', false);
        $.FindChildInContext('#MainMenuVanityInfo').SetHasClass('hidden', false);
    }
    function _HideFloatingPanels() {
        $.FindChildInContext('#JsLeftColumn').SetHasClass('hidden', true);
        $.FindChildInContext('#JsRightColumn').SetHasClass('hidden', true);
        $.FindChildInContext('#MainMenuVanityInfo').SetHasClass('hidden', true);
    }
    function _OnSteamIsPlaying() {
        const elNewsContainer = $.FindChildInContext('#JsNewsContainer');
        if (elNewsContainer) {
            elNewsContainer.SetHasClass('mainmenu-news-container-stream-active', EmbeddedStreamAPI.IsVideoPlaying());
        }
    }
    function _ResetNewsEntryStyle() {
        const elNewsContainer = $.FindChildInContext('#JsNewsContainer');
        if (elNewsContainer) {
            elNewsContainer.RemoveClass('mainmenu-news-container-stream-active');
        }
    }
    function _UpdatePartySearchParticlesType(isPremier) {
        const particle_container = $('#party-search-particles');
        if (isPremier) {
            particle_container.SetParticleNameAndRefresh("particles/ui/ui_mainmenu_active_search_gold.vpcf");
        }
        else {
            particle_container.SetParticleNameAndRefresh("particles/ui/ui_mainmenu_active_search.vpcf");
        }
    }
    function _UpdatePartySearchSetControlPointParticles(cpArray) {
        const particle_container = $('#party-search-particles');
        particle_container.StopParticlesImmediately(true);
        particle_container.StartParticles();
        for (const [cp, xpos, ypos, zpos] of cpArray) {
            particle_container.SetControlPoint(cp, xpos, ypos, zpos);
        }
        m_isParticleActive = true;
    }
    let m_verticalSpread = 0;
    let m_isParticleActive = false;
    function _UpdatePartySearchParticles() {
        const particle_container = $('#party-search-particles');
        if (particle_container.type !== "ParticleScenePanel")
            return;
        let AddServerErrors = 0;
        let serverWarning = NewsAPI.GetCurrentActiveAlertForUser();
        let isWarning = serverWarning !== '' && serverWarning !== undefined ? true : false;
        let bAttemptPremierMode = LobbyAPI.GetSessionSettings()?.game?.mode_ui === 'premier';
        if (isWarning)
            AddServerErrors = 5;
        let strStatus = LobbyAPI.GetMatchmakingStatusString();
        const bShowParticles = strStatus != null && (strStatus.endsWith("searching") || strStatus.endsWith("registering") || strStatus.endsWith("reserved"));
        if (!bShowParticles) {
            if (m_isParticleActive) {
                particle_container.StopParticlesImmediately(true);
                m_isParticleActive = false;
            }
            return;
        }
        let verticlSpread = 14 + (PartyListAPI.GetCount() - 1) * 5 + AddServerErrors;
        if (m_verticalSpread === verticlSpread && m_isParticleActive)
            return;
        _UpdatePartySearchParticlesType(bAttemptPremierMode);
        m_verticalSpread = verticlSpread;
        let CpArray = [
            [1, verticlSpread, .5, 1],
            [2, 1, .25, 0],
            [16, 15, 230, 15],
        ];
        _UpdatePartySearchSetControlPointParticles(CpArray);
    }
    function _ForceRestartVanity() {
        if (GameStateAPI.IsLocalPlayerPlayingMatch()) {
            return;
        }
        _m_bVanityAnimationAlreadyStarted = false;
        _InitVanity();
    }
    let m_aDisplayLobbyVanityData = [];
    function _InitVanity() {
        if (MatchStatsAPI.GetUiExperienceType()) {
            return;
        }
        if (!MyPersonaAPI.IsInventoryValid()) {
            if (MyPersonaAPI.GetClientLogonFatalError()) {
                _ShowVanity();
            }
            return;
        }
        if (_m_bVanityAnimationAlreadyStarted) {
            return;
        }
        _ShowVanity();
    }
    function _ShowVanity() {
        const vanityPanel = $('#JsMainmenu_Vanity');
        if (!vanityPanel) {
            return;
        }
        _m_bVanityAnimationAlreadyStarted = true;
        if (vanityPanel.BHasClass('hidden')) {
            vanityPanel.RemoveClass('hidden');
        }
        _UpdateLocalPlayerVanity();
    }
    function _ShowDebugLobbyModels() {
    }
    function _UpdateLocalPlayerVanity() {
        const oSettings = ItemInfo.GetOrUpdateVanityCharacterSettings();
        const oLocalPlayer = m_aDisplayLobbyVanityData.filter(storedEntry => { return storedEntry.isLocalPlayer === true; });
        if (oLocalPlayer.length > 0 && (oLocalPlayer[0].playeridx > (_m_maxMainMenuDisplayAgents - 1))) {
            return;
        }
        oSettings.playeridx = oLocalPlayer.length > 0 ? oLocalPlayer[0].playeridx : 0;
        oSettings.xuid = MyPersonaAPI.GetXuid();
        oSettings.isLocalPlayer = true;
        _ApplyVanitySettingsToLobbyMetadata(oSettings);
        _UpdatePlayerVanityModel(oSettings);
        _CreateUpdateVanityInfo(oSettings);
    }
    function _ApplyVanitySettingsToLobbyMetadata(oSettings) {
        PartyListAPI.SetLocalPlayerVanityPresence(oSettings.team, oSettings.charItemId, oSettings.glovesItemId, oSettings.loadoutSlot, oSettings.weaponItemId, oSettings.petItemId);
    }
    function _UpdatePlayerVanityModel(oSettings) {
        const vanityPanel = _UpdateBackgroundMap();
        vanityPanel.SetActiveCharacter(oSettings.playeridx);
        oSettings.panel = vanityPanel;
        if (!!oSettings.petItemId && Number(oSettings.petItemId) != 0) {
            if (oSettings.playeridx === 0) {
                _ShowPetEntities(vanityPanel, oSettings.petItemId);
                vanityPanel.SetPetPlacement('main-menu-foreground');
            }
            else
                vanityPanel.SetPetPlacement('main-menu-background');
        }
        else {
            if (oSettings.playeridx === 0)
                _HidePetEntities(vanityPanel);
            vanityPanel.SetPetPlacement('none');
        }
        CharacterAnims.PlayAnimsOnPanel(oSettings);
    }
    function _CreateUpdateVanityInfo(oSettings) {
        $.Schedule(.1, () => {
            const elVanityPlayerInfo = VanityPlayerInfo.CreateOrUpdateVanityInfoPanel($.GetContextPanel().FindChildInLayoutFile('MainMenuVanityInfo'), oSettings);
            if (elVanityPlayerInfo) {
                $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityParent').AddBlurPanel(elVanityPlayerInfo.FindChildInLayoutFile('vanity-info-container'));
                let defName = '';
                let weaponId = oSettings.weaponItemId
                    ? oSettings.weaponItemId
                    : (oSettings.hasOwnProperty('vanity_data') && oSettings.vanity_data)
                        ? oSettings.vanity_data.split(',')[4]
                        : '';
                let team = oSettings.hasOwnProperty('team') && oSettings.team
                    ? oSettings.team
                    : (oSettings.hasOwnProperty('vanity_data') && oSettings.vanity_data)
                        ? oSettings.vanity_data.split(',')[0]
                        : '';
                if (weaponId) {
                    defName = InventoryAPI.GetItemDefinitionName(weaponId);
                }
                elVanityPlayerInfo.SetHasClass('move-up', (defName === 'weapon_negev' || defName === 'weapon_m249') && team === 'ct');
            }
        });
    }
    function _LobbyPlayerUpdated() {
        _UpdatePartySearchParticles();
        let numPlayersActuallyInParty = PartyListAPI.GetCount();
        if (!LobbyAPI.IsSessionActive() || MatchStatsAPI.GetUiExperienceType() || numPlayersActuallyInParty < 1 || !numPlayersActuallyInParty) {
            _ClearLobbyPlayers();
            _m_bVanityAnimationAlreadyStarted = false;
            $.Schedule(.1, _InitVanity);
            return;
        }
        const aCurrentLobbyVanityData = [];
        if (numPlayersActuallyInParty > 0) {
            numPlayersActuallyInParty = (numPlayersActuallyInParty > _m_maxMainMenuDisplayAgents) ? _m_maxMainMenuDisplayAgents : numPlayersActuallyInParty;
            for (let k = 0; k < numPlayersActuallyInParty; k++) {
                const xuid = PartyListAPI.GetXuidByIndex(k);
                aCurrentLobbyVanityData.push({
                    xuid: xuid,
                    isLocalPlayer: xuid === MyPersonaAPI.GetXuid(),
                    playeridx: k,
                    vanity_data: PartyListAPI.GetPartyMemberVanity(xuid)
                });
            }
            _CompareLobbyPlayers(aCurrentLobbyVanityData);
        }
        else {
            _ClearLobbyPlayers();
            _ForceRestartVanity();
        }
    }
    function _CompareLobbyPlayers(aCurrentLobbyVanityData) {
        for (let i = 0; i < _m_maxMainMenuDisplayAgents; i++) {
            if (aCurrentLobbyVanityData[i]) {
                if (!m_aDisplayLobbyVanityData[i]) {
                    m_aDisplayLobbyVanityData[i] = {
                        xuid: "",
                        playeridx: 0,
                        vanity_data: "",
                        isLocalPlayer: false
                    };
                }
                m_aDisplayLobbyVanityData[i].playeridx = aCurrentLobbyVanityData[i].playeridx;
                m_aDisplayLobbyVanityData[i].isLocalPlayer = aCurrentLobbyVanityData[i].isLocalPlayer;
                if (m_aDisplayLobbyVanityData[i].xuid !== aCurrentLobbyVanityData[i].xuid) {
                    VanityPlayerInfo.DeleteVanityInfoPanel($.GetContextPanel().FindChildInLayoutFile('MainMenuVanityInfo'), aCurrentLobbyVanityData[i].playeridx);
                    if (aCurrentLobbyVanityData[i].isLocalPlayer) {
                        _UpdateLocalPlayerVanity();
                    }
                }
                m_aDisplayLobbyVanityData[i].xuid = aCurrentLobbyVanityData[i].xuid;
                if (m_aDisplayLobbyVanityData[i].vanity_data !== aCurrentLobbyVanityData[i].vanity_data) {
                    if (!aCurrentLobbyVanityData[i].isLocalPlayer && aCurrentLobbyVanityData[i].vanity_data) {
                        _UpdateVanityFromLobbyUpdate(aCurrentLobbyVanityData[i].vanity_data, aCurrentLobbyVanityData[i].playeridx, aCurrentLobbyVanityData[i].xuid);
                    }
                }
                _CreateUpdateVanityInfo(aCurrentLobbyVanityData[i]);
                m_aDisplayLobbyVanityData[i].vanity_data = aCurrentLobbyVanityData[i].vanity_data;
            }
            else if (m_aDisplayLobbyVanityData[i]) {
                _ClearLobbyVanityModel(m_aDisplayLobbyVanityData[i].playeridx);
                delete m_aDisplayLobbyVanityData[i];
            }
        }
    }
    function _ClearLobbyPlayers() {
        for (let i = 0; i < m_aDisplayLobbyVanityData.length; ++i) {
            _ClearLobbyVanityModel(i);
        }
        m_aDisplayLobbyVanityData = [];
    }
    function _ClearLobbyVanityModel(index) {
        VanityPlayerInfo.DeleteVanityInfoPanel($.GetContextPanel().FindChildInLayoutFile('MainMenuVanityInfo'), index);
        $('#JsMainmenu_Vanity').SetActiveCharacter(index);
        $('#JsMainmenu_Vanity').RemoveCharacterModel();
    }
    function _UpdateVanityFromLobbyUpdate(strVanityData, index, xuid) {
        const arrVanityInfo = strVanityData.split(',');
        const oSettings = {
            xuid: xuid,
            team: arrVanityInfo[0],
            charItemId: arrVanityInfo[1],
            glovesItemId: arrVanityInfo[2],
            loadoutSlot: arrVanityInfo[3],
            weaponItemId: arrVanityInfo[4],
            petItemId: arrVanityInfo[5],
            playeridx: index
        };
        _UpdatePlayerVanityModel(oSettings);
    }
    function _PlayerActivityVoice(xuid) {
        const vanityPanel = $('#MainMenuVanityInfo');
        const elAvatar = vanityPanel.FindChildTraverse('JsPlayerVanityAvatar-' + xuid);
        if (elAvatar && elAvatar.IsValid()) {
            VanityPlayerInfo.UpdateVoiceIcon(elAvatar, xuid);
        }
    }
    function _OnUISceneFrameBoundary() {
        const elVanityPanel = $('#JsMainmenu_Vanity');
        if (elVanityPanel && elVanityPanel.IsValid()) {
            const elVanityPlayerInfoParent = $.GetContextPanel().FindChildInLayoutFile('MainMenuVanityInfo');
            for (let i = 0; i < _m_maxMainMenuDisplayAgents; i++) {
                if (elVanityPanel.SetActiveCharacter(i) === true) {
                    const oPanelPos = elVanityPanel.GetBonePositionInPanelSpace((i === 0) ? 'pelvis' : 'head_0');
                    oPanelPos.y -= 0.0;
                    VanityPlayerInfo.SetVanityInfoPanelPos(elVanityPlayerInfoParent, i, oPanelPos, "id-player-vanity-info-" + i);
                    if (i === 0) {
                        let oPetPanelPos;
                        if (_m_nPetUpgradeLevel === 0) {
                            oPetPanelPos = elVanityPanel.GetPetBonePositionInPanelSpace('egg');
                            oPetPanelPos.y -= 0.0;
                            VanityPetInfo.SetVanityPetInfoPos(elVanityPlayerInfoParent, oPetPanelPos);
                        }
                        else if (_m_nPetUpgradeLevel && _m_nPetUpgradeLevel > 0) {
                            oPetPanelPos = elVanityPanel.GetPetBonePositionInPanelSpace('root_motion');
                            oPetPanelPos.y -= 0.0;
                            VanityPetInfo.SetVanityPetInfoPos(elVanityPlayerInfoParent, oPetPanelPos);
                        }
                    }
                }
            }
        }
        if (GameInterfaceAPI.IsAppActive()) {
            _m_nActiveFrameCount++;
            if (_m_nActiveFrameCount == 100 && !_m_bTriedShowVideoSettingRecommendation) {
                VideoSettingRecommendations.MaybeShowPopup();
                _m_bTriedShowVideoSettingRecommendation = true;
            }
        }
        else {
            _m_nActiveFrameCount = 0;
        }
    }
    function _OpenPlayMenu() {
        if (MatchStatsAPI.GetUiExperienceType())
            return;
        _InsureSessionCreated();
        NavigateToTab('JsPlay', 'mainmenu_play');
    }
    function _OpenWatchMenu() {
        NavigateToTab('JsWatch', 'mainmenu_watch');
    }
    function _OpenInventory() {
        NavigateToTab('JsInventory', 'mainmenu_inventory');
    }
    function _OpenFullscreenStore(openToSection = '') {
        NavigateToTab('JsMainMenuStore', 'mainmenu_store_fullscreen', openToSection !== '' ? openToSection : 'id-store-nav-coupon');
    }
    function _OpenStatsMenu() {
        NavigateToTab('JsPlayerStats', 'mainmenu_playerstats');
    }
    function _OpenSettingsMenu() {
        NavigateToTab('JsSettings', 'settings/settings');
    }
    var _UpdateOverwatch = function () {
        var strCaseDescription = OverwatchAPI.GetAssignedCaseDescription();
        $('#MainMenuNavBarOverwatch').SetHasClass('pausemenu-navbar__btn-small--hidden', strCaseDescription == "");
    };
    function _OpenSubscriptionUpsell() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_subscription_upsell.xml', '');
    }
    function _ShowLoadoutForItem(itemId) {
        let bLoadoutPanelExisted = !!$.GetContextPanel().FindChildInLayoutFile('JsLoadout');
        $.DispatchEvent("Activated", $.GetContextPanel().FindChildInLayoutFile('MainMenuNavBarLoadout'), "mouse");
        let bLoadoutPanelExists = !!$.GetContextPanel().FindChildInLayoutFile('JsLoadout');
        if (!bLoadoutPanelExisted && bLoadoutPanelExists) {
            $.DispatchEvent("ShowLoadoutForItem", itemId);
        }
    }
    function _OpenSettings() {
        NavigateToTab('JsSettings', 'settings/settings', 'KeybdMouseSettings');
    }
    function _InsureSessionCreated() {
        if (!LobbyAPI.IsSessionActive()) {
            LobbyAPI.CreateSession();
        }
    }
    function OnEscapeKeyPressed() {
        if (_m_activeTab) {
            if (_m_activeTab === 'JsMainMenuStore') {
                const xpStoreMenu = _m_elContentPanel.FindChildInLayoutFile('JsMainMenuStore').FindChildInLayoutFile('id-store-page-xpshop');
                if (xpStoreMenu && xpStoreMenu.IsValid()) {
                    const xpShopNavBar = xpStoreMenu.FindChildInLayoutFile('id-xpshop-top-nav');
                    if (xpShopNavBar && xpShopNavBar.IsValid()) {
                        const navBtns = xpShopNavBar.Children();
                        let selectedTab = navBtns.filter(btn => btn.checked === true);
                        if (selectedTab[0].id !== navBtns[0].id) {
                            $.DispatchEvent('Activated', navBtns[0], 'mouse');
                            return;
                        }
                    }
                }
            }
            OnHomeButtonPressed();
        }
        else
            GameInterfaceAPI.ConsoleCommand("gameui_hide");
    }
    MainMenu.OnEscapeKeyPressed = OnEscapeKeyPressed;
    function _InventoryUpdated() {
        _UpdatePetNotification();
        _ForceRestartVanity();
        if (GameStateAPI.IsLocalPlayerPlayingMatch()) {
            return;
        }
        _UpdateInventoryBtnAlert();
        _UpdateStoreAlert();
    }
    function _RegisterPopupNotificationCallback(fnOnClose) {
        const handle = UiToolkitAPI.RegisterJSCallback(() => {
            UiToolkitAPI.UnregisterJSCallback(handle);
            if (_m_popupNotificationCallbackHandle === handle)
                _m_popupNotificationCallbackHandle = -1;
            fnOnClose();
        });
        _m_popupNotificationCallbackHandle = handle;
        return handle;
    }
    function _CloseAllVisiblePopups() {
        UiToolkitAPI.CloseAllVisiblePopups();
        if (_m_popupNotificationCallbackHandle !== -1) {
            UiToolkitAPI.UnregisterJSCallback(_m_popupNotificationCallbackHandle);
            _m_popupNotificationCallbackHandle = -1;
        }
        _m_bHasPopupNotification = false;
    }
    function _CheckRankUpRedemptionStore() {
        if (_m_bHasPopupNotification)
            return;
        if (GameStateAPI.IsLocalPlayerPlayingMatch())
            return;
        if (!$('#MainMenuNavBarHome').checked)
            return;
        const objStore = InventoryAPI.GetCacheTypeElementJSOByIndex("PersonalStore", 0);
        if (!objStore)
            return;
        if (!MyPersonaAPI.IsConnectedToGC() || !MyPersonaAPI.IsInventoryValid())
            return;
        const genTime = objStore.generation_time;
        const balance = objStore.redeemable_balance;
        const prevClientGenTime = Number(GameInterfaceAPI.GetSettingString("cl_redemption_reset_timestamp"));
        if (prevClientGenTime != genTime && balance > 0) {
            _m_bHasPopupNotification = true;
            const RankUpRedemptionStoreClosedCallbackHandle = _RegisterPopupNotificationCallback(_OnRankUpRedemptionStoreClosed);
            let elPopupPanel = UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_rankup_redemption_store.xml', 'callback=' + RankUpRedemptionStoreClosedCallbackHandle);
            elPopupPanel.Data().elMainMenu = $.GetContextPanel();
        }
    }
    function _CheckMajorStoreBalance() {
        if (_m_bMajorStoreBalanceChecked || _m_bHasPopupNotification)
            return;
        if (GameStateAPI.IsLocalPlayerPlayingMatch())
            return;
        if (!$('#MainMenuNavBarHome').checked)
            return;
        const elPopups = $('#PopupManager');
        if (elPopups && elPopups.BHasClass('HaveActivePopups'))
            return;
        if (!MyPersonaAPI.IsConnectedToGC() || !MyPersonaAPI.IsInventoryValid())
            return;
        _m_bMajorStoreBalanceChecked = true;
        const idxLookup = InventoryAPI.GetCacheTypeElementIndexByKey('SeasonalOperations', g_ActiveTournamentInfo.credits_id);
        if (g_ActiveTournamentInfo.credits_id != InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'season_value'))
            return;
        const nBalance = InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'redeemable_balance') ?? 0;
        if (nBalance < 99)
            return;
        _m_bHasPopupNotification = true;
        const closedCallbackHandle = _RegisterPopupNotificationCallback(() => { _m_bHasPopupNotification = false; });
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_major_store_balance.xml', 'balance=' + nBalance + '&callback=' + closedCallbackHandle);
    }
    function _OnRankUpRedemptionStoreClosed() {
        _m_bHasPopupNotification = false;
    }
    function _UpdateInventoryBtnAlert() {
        const aNewItems = AcknowledgeItems.GetItems();
        const count = aNewItems.length;
        const elNavBar = $.GetContextPanel().FindChildInLayoutFile('MainMenuNavBarTop'), elAlert = elNavBar.FindChildInLayoutFile('MainMenuInvAlert');
        elAlert.SetDialogVariable("alert_value", count.toString());
        elAlert.SetHasClass('hidden', count < 1);
    }
    function _OnInventoryInspect(id, contextmenuparam) {
        let inspectviewfunc = contextmenuparam ? contextmenuparam : 'primary';
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: id,
            inspect_only: true,
            force_inspect_view_type: inspectviewfunc
        };
        elPanel.Data().oSettings = oSettings;
    }
    function _OnShowCustomLayoutPopupParametersAsEvent(dimstyle, xmlname, panelparams) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup(dimstyle, xmlname);
        const aParams = panelparams.split(',');
        let oSettings = { item_id: '' };
        aParams.forEach(entry => {
            const settingPair = entry.split('=');
            oSettings[settingPair[0]] = settingPair[1];
        });
        elPanel.Data().oSettings = oSettings;
    }
    function _OnShowXrayCasePopup(toolid, caseId, bShowPopupWarning = false) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + caseId, 'file://{resources}/layout/popups/popup_capability_decodable.xml');
        let oSettings = {
            item_id: caseId,
            tool_id: toolid,
            work_type: 'decodeable',
            is_xray_machine: true,
            show_xray_warning: bShowPopupWarning
        };
        elPanel.Data().oSettings = oSettings;
    }
    let JsInspectCallback = -1;
    function _OnLootlistItemPreview(id, params) {
        if (JsInspectCallback != -1) {
            UiToolkitAPI.UnregisterJSCallback(JsInspectCallback);
            JsInspectCallback = -1;
        }
        const ParamsList = params.split(',');
        const caseId = ParamsList[0];
        const lootlistNameOverride = ParamsList[3] && ParamsList[3] !== '' ? ParamsList[3] : 'false';
        JsInspectCallback = UiToolkitAPI.RegisterJSCallback(() => {
        });
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-lootlist-item-inspect-' + id, 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: id,
            inspect_only: true,
            hide_all_action_items: true,
            hide_item_cert: true,
            show_market_link: _m_bPerfectWorld ? false : true,
            callback_handle: JsInspectCallback,
            case_id_for_lootlist: caseId,
            lootlist_name_override: lootlistNameOverride
        };
        elPanel.Data().oSettings = oSettings;
    }
    function _WeaponPreviewRequest(id, bWorkshopItemPreview = false) {
        const workshopPreview = bWorkshopItemPreview ? 'true' : 'false';
        _CloseAllVisiblePopups();
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-weapon-preview-inspect-' + id, 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: id,
            inspect_only: true,
            hide_all_action_items: true,
            is_workshop_preview: bWorkshopItemPreview
        };
        elPanel.Data().oSettings = oSettings;
    }
    function _SelectItemForWorkshopPreviewCapability(capability, itemid, itemid2) {
        _CloseAllVisiblePopups();
        _OpenInventory();
        $.DispatchEvent('ShowSelectItemForWorkshopPreviewCapability', capability, itemid, itemid2);
    }
    function _UpdateStoreAlert() {
        let hideAlert;
        const objStore = InventoryAPI.GetCacheTypeElementJSOByIndex("PersonalStore", 0);
        const gcConnection = MyPersonaAPI.IsConnectedToGC();
        const validInventory = MyPersonaAPI.IsInventoryValid();
        hideAlert = !gcConnection || !validInventory || !objStore || objStore.redeemable_balance === 0;
        const elNavBar = $.GetContextPanel().FindChildInLayoutFile('MainMenuNavBarTop');
        const elAlert = elNavBar.FindChildInLayoutFile('MainMenuStoreAlert');
        elAlert.SetDialogVariable("alert_value", $.Localize("#Store_Price_New"));
        elAlert.SetHasClass('hidden', hideAlert);
    }
    function _CancelNotificationSchedule() {
        if (_m_notificationSchedule !== false) {
            $.CancelScheduled(_m_notificationSchedule);
            _m_notificationSchedule = false;
        }
    }
    function _AcknowledgePenaltyNotificationsCallback() {
        CompetitiveMatchAPI.ActionAcknowledgePenalty();
        _m_bHasPopupNotification = false;
    }
    function _AcknowledgeMsgNotificationsCallback() {
        MyPersonaAPI.ActionAcknowledgeNotifications();
        _m_bHasPopupNotification = false;
    }
    let _m_petEventCache = null;
    function GetPetPopupNotification() {
        if (_m_bHasPopupNotification)
            return null;
        if (GameStateAPI.IsLocalPlayerPlayingMatch())
            return null;
        if (!$('#MainMenuNavBarHome').checked)
            return null;
        if (!MyPersonaAPI.IsConnectedToGC() || !MyPersonaAPI.IsInventoryValid())
            return null;
        const petItemId = InventoryAPI.GetPetItemID();
        if (!petItemId && !_m_petEventCache)
            return null;
        let nUpgradeLevelDetected = 0;
        if (petItemId) {
            const nUpgradeLevel = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}upgrade level'));
            if (!_m_petEventCache || petItemId !== _m_petEventCache.petItemId) {
                _m_petEventCache = {
                    petItemId: petItemId,
                    nLastKnownUpgradeLevel: nUpgradeLevel,
                    strExpiryReason: '',
                };
            }
            const strExpectExpiry = InventoryAPI.TryAckPetEventAndCheckExpiration(petItemId);
            if (strExpectExpiry) {
                _m_petEventCache.strExpiryReason = strExpectExpiry;
            }
            else if (nUpgradeLevel > _m_petEventCache.nLastKnownUpgradeLevel) {
                nUpgradeLevelDetected = nUpgradeLevel;
            }
        }
        if (_m_petEventCache && _m_petEventCache.strExpiryReason) {
            if (!petItemId) {
                const ackExpPetItemId = _m_petEventCache.petItemId;
                const savedPetId = InventoryAPI.RestorePetItemData();
                return {
                    title: "#pet_expired_notification_title",
                    msg: "#pet_expired_notification_msg",
                    color_class: "NotificationYellow",
                    callback: () => {
                        _m_bHasPopupNotification = false;
                        if (_m_petEventCache && _m_petEventCache.petItemId === ackExpPetItemId)
                            _m_petEventCache = null;
                    },
                    html: false,
                    rental_id: "",
                    pet_id: savedPetId + ',' + _m_petEventCache.strExpiryReason,
                    ack_exp_pet_id: ackExpPetItemId
                };
            }
            else
                return null;
        }
        if (petItemId && (nUpgradeLevelDetected > 0)) {
            const savedPetId = InventoryAPI.RestorePetItemData();
            return {
                title: "#pet_upgrade_notification_title",
                msg: "#pet_upgrade_notification_msg",
                color_class: "NotificationGreen",
                callback: () => {
                    _m_bHasPopupNotification = false;
                    if (_m_petEventCache && _m_petEventCache.petItemId === petItemId
                        && nUpgradeLevelDetected > _m_petEventCache.nLastKnownUpgradeLevel)
                        _m_petEventCache.nLastKnownUpgradeLevel = nUpgradeLevelDetected;
                },
                html: false,
                rental_id: "",
                pet_id: petItemId + ',' + savedPetId,
            };
        }
        return null;
    }
    let _m_bCheckHasLowAvailableVirtualMemory = true;
    let _m_bCheckHasInsufficientPagefile = true;
    function _GetPopupNotification() {
        const popupNotification = {
            title: "",
            msg: "",
            color_class: "NotificationYellow",
            callback: () => { },
            html: false,
            rental_id: "",
        };
        if (_m_bCheckHasLowAvailableVirtualMemory && GameInterfaceAPI.HasLowAvailableVirtualMemory()) {
            popupNotification.title = "#GameUI_SystemInfo_Title";
            popupNotification.msg = $.Localize("#GameUI_SystemInfo_Attention_Low_System_Memory");
            popupNotification.callback = () => {
                _m_bCheckHasLowAvailableVirtualMemory = _m_bHasPopupNotification = false;
                GameInterfaceAPI.Acknowledged_HasLowAvailableVirtualMemory();
            };
            return popupNotification;
        }
        if (_m_bCheckHasInsufficientPagefile && GameInterfaceAPI.HasInsufficientPagefile()) {
            popupNotification.title = "#GameUI_SystemInfo_Title";
            popupNotification.msg = $.Localize("#GameUI_SystemInfo_Attention_LowDiskSpaceForSwapfile");
            popupNotification.callback = () => {
                _m_bCheckHasInsufficientPagefile = _m_bHasPopupNotification = false;
                GameInterfaceAPI.Acknowledged_HasInsufficientPagefile();
            };
            return popupNotification;
        }
        const nBanRemaining = CompetitiveMatchAPI.GetCooldownSecondsRemaining();
        if (nBanRemaining < 0) {
            popupNotification.title = "#SFUI_MainMenu_Competitive_Ban_Confirm_Title";
            popupNotification.msg = $.Localize("#SFUI_CooldownExplanationReason_Expired_Cooldown") + $.Localize(CompetitiveMatchAPI.GetCooldownReason());
            popupNotification.callback = _AcknowledgePenaltyNotificationsCallback;
            popupNotification.html = true;
            return popupNotification;
        }
        const strNotifications = MyPersonaAPI.GetMyNotifications();
        if (strNotifications !== "") {
            const arrayOfNotifications = strNotifications.split(',');
            for (let notificationType of arrayOfNotifications) {
                if (notificationType !== "6") {
                    popupNotification.color_class = 'NotificationBlue';
                }
                popupNotification.title = '#SFUI_PersonaNotification_Title_' + notificationType;
                popupNotification.msg = '#SFUI_PersonaNotification_Msg_' + notificationType;
                popupNotification.callback = _AcknowledgeMsgNotificationsCallback;
            }
            return popupNotification;
        }
        if (MyPersonaAPI.IsConnectedToGC()) {
            const nRentalHistoryCount = InventoryAPI.GetCacheTypeElementsCount('RentalHistory');
            const nCurrentDate = Math.trunc(Date.now() / 1000);
            for (let i = 0; i < nRentalHistoryCount; ++i) {
                const oRentalHistory = InventoryAPI.GetCacheTypeElementJSOByIndex('RentalHistory', i);
                const crateItemId = oRentalHistory.crate_item_id;
                if (oRentalHistory.expiration_date <= nCurrentDate &&
                    !_m_acknowledgedRentalExpirationCrateIds.has(crateItemId)) {
                    _m_acknowledgedRentalExpirationCrateIds.add(crateItemId);
                    const fauxItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(oRentalHistory.crate_def_index, 0);
                    const crateName = InventoryAPI.GetItemName(fauxItemId);
                    const issueDate = InventoryAPI.LocalizeRentalDate(oRentalHistory.issue_date);
                    const expirationDate = InventoryAPI.LocalizeRentalDate(oRentalHistory.expiration_date);
                    const elContainer = $('#MainMenuContainerPanel');
                    elContainer.SetDialogVariable('rental_expired_crate_name', crateName);
                    elContainer.SetDialogVariable('rental_expired_issue_date', issueDate);
                    elContainer.SetDialogVariable('rental_expired_expiration_date', expirationDate);
                    popupNotification.rental_id = fauxItemId;
                    popupNotification.title = '#RentalExpiredPopupTitle';
                    popupNotification.msg = $.Localize('#RentalExpiredPopupMessage', elContainer);
                    popupNotification.callback = () => {
                        InventoryAPI.AcknowledgeRentalExpiration(crateItemId);
                        _m_bHasPopupNotification = false;
                    };
                    return popupNotification;
                }
            }
        }
        return null;
    }
    function _UpdatePopupnotification() {
        if (!_m_bHasPopupNotification) {
            const popupNotification = _GetPopupNotification();
            if (popupNotification != null) {
                if (popupNotification.rental_id) {
                    const OnCloseRentalExpireNotification = _RegisterPopupNotificationCallback(popupNotification.callback);
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_container_open_confirm.xml', 'action-type=expire'
                        + '&' + 'case=' + popupNotification.rental_id
                        + '&' + 'msg_override=' + popupNotification.msg
                        + '&' + 'callback=' + OnCloseRentalExpireNotification);
                }
                else {
                    const elPopup = UiToolkitAPI.ShowGenericPopupOneOption(popupNotification.title, popupNotification.msg, popupNotification.color_class, '#SFUI_MainMenu_ConfirmBan', popupNotification.callback);
                    if (elPopup) {
                        elPopup.SetPanelEvent('oncancel', () => {
                            $.DispatchEvent('UIPopupButtonClicked', elPopup, '');
                            popupNotification.callback();
                        });
                    }
                    if (popupNotification.html)
                        elPopup.EnableHTML();
                }
                _m_bHasPopupNotification = true;
            }
        }
    }
    function PopUpPetNotification(popupNotification) {
        if (popupNotification != null && popupNotification.pet_id) {
            _m_bHasPopupNotification = true;
            const OnClosePetEventNotification = _RegisterPopupNotificationCallback(popupNotification.callback);
            let Panel = UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_pet_event.xml', 'action-type=expire'
                + '&' + 'title=' + popupNotification.title
                + '&' + 'msg=' + popupNotification.msg
                + '&' + 'pet_id=' + popupNotification.pet_id
                + '&' + 'callback=' + OnClosePetEventNotification
                + '&' + 'ack_exp_pet_id=' + popupNotification.ack_exp_pet_id);
        }
    }
    function _GetNotificationBarData() {
        let aAlerts = [];
        if (LicenseUtil.GetCurrentLicenseRestrictions() === false) {
            const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
            const bIsConnectedToGC = MyPersonaAPI.IsConnectedToGC();
            $('#MainMenuInput').SetHasClass('GameClientConnectingToGC', !bIsConnectedToGC);
            if (bIsConnectedToGC) {
                _m_tLastSeenDisconnectedFromGC = 0;
            }
            else if (!_m_tLastSeenDisconnectedFromGC) {
                _m_tLastSeenDisconnectedFromGC = +new Date();
            }
            else if (Math.abs((+new Date()) - _m_tLastSeenDisconnectedFromGC) > 500) {
                notification.title = $.Localize("#Store_Connecting_ToGc");
                notification.tooltip = $.Localize("#Store_Connecting_ToGc_Tooltip");
                notification.color_class = "";
                notification.icon = "gc-connecting";
                notification.is_gc_connecting = true;
                aAlerts.push(notification);
            }
        }
        if (NewsAPI.IsNewClientAvailable()) {
            const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
            notification.color_class = "yellow-alert";
            notification.icon = "client_update";
            notification.title = $.Localize("#SFUI_MainMenu_Outofdate_Title");
            notification.tooltip = $.Localize("#SFUI_MainMenu_Outofdate_Body");
            aAlerts.push(notification);
        }
        const nIsVacBanned = MyPersonaAPI.IsVacBanned();
        if (nIsVacBanned != 0) {
            const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
            notification.color_class = "red-alert";
            notification.icon = "ban_global";
            if ((nIsVacBanned & 1) == 1) {
                notification.title = $.Localize("#SFUI_MainMenu_Vac_Title");
                notification.tooltip = $.Localize("#SFUI_MainMenu_Vac_Info");
                notification.link = "https://help.steampowered.com/faqs/view/647C-5CC1-7EA9-3C29";
            }
            else if ((nIsVacBanned & 4) == 4) {
                notification.title = $.Localize("#SFUI_MainMenu_AccountLocked_Title");
                notification.tooltip = $.Localize("#SFUI_MainMenu_AccountLocked_Info");
                notification.link = "https://help.steampowered.com/en/faqs/view/4F62-35F9-F395-5C23";
            }
            else {
                notification.title = $.Localize("#SFUI_MainMenu_GameBan_Title");
                notification.tooltip = $.Localize("#SFUI_MainMenu_GameBan_Info");
                notification.link = "https://help.steampowered.com/faqs/view/4E54-0B96-D0A4-1557";
            }
            aAlerts.push(notification);
        }
        else {
            const nPlayBanGlobalRemaining = MyPersonaAPI.GetPlayBanSecondsRemaining();
            if (nPlayBanGlobalRemaining > 0) {
                const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
                notification.tooltip = $.Localize("#CSGO_Purchasable_Game_License_BannedInChina");
                notification.title = $.Localize("#SFUI_MainMenu_GameBan_Title") + ' ' + FormatText.SecondsToSignificantTimeString(nPlayBanGlobalRemaining);
                notification.color_class = "red-alert";
                notification.icon = "ban_global";
                aAlerts.push(notification);
            }
            else {
                const nBanRemaining = CompetitiveMatchAPI.GetCooldownSecondsRemaining();
                if (nBanRemaining > 0) {
                    const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
                    notification.tooltip = CompetitiveMatchAPI.GetCooldownReason();
                    const strType = CompetitiveMatchAPI.GetCooldownType();
                    if (strType == "global") {
                        notification.title = $.Localize("#SFUI_MainMenu_Global_Ban_Title");
                        notification.color_class = "yellow-alert";
                        notification.icon = "ban_competitive";
                    }
                    else if (strType == "green") {
                        notification.title = $.Localize("#SFUI_MainMenu_Temporary_Ban_Title");
                        notification.color_class = "yellow-alert";
                        notification.icon = "ban_competitive";
                    }
                    else if (strType == "competitive") {
                        notification.title = $.Localize("#SFUI_MainMenu_Competitive_Ban_Title");
                        notification.color_class = "yellow-alert";
                        notification.icon = "ban_competitive";
                    }
                    if (!CompetitiveMatchAPI.CooldownIsPermanent()) {
                        const title = notification.title;
                        if (CompetitiveMatchAPI.ShowFairPlayGuidelinesForCooldown()) {
                            notification.link = "https://blog.counter-strike.net/index.php/fair-play-guidelines/";
                        }
                        notification.title = title + ' ' + FormatText.SecondsToSignificantTimeString(nBanRemaining);
                    }
                    aAlerts.push(notification);
                }
            }
        }
        const nCommsMuteRemaining = MyPersonaAPI.GetCommunicationsBanSecondsRemaining();
        if (nCommsMuteRemaining > 0) {
            const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
            notification.tooltip = $.Localize("#GameUI_AccountInfo_CommsBanNagYouIngame");
            notification.title = $.Localize("#tooltip_cannot_unmute") + ' ' + FormatText.SecondsToSignificantTimeString(nCommsMuteRemaining);
            notification.color_class = "yellow-alert";
            notification.icon = "message";
            aAlerts.push(notification);
        }
        const strNotification = MyPersonaAPI.GetTradeBanNotification();
        if (strNotification) {
            const notification = { color_class: "", title: "", tooltip: "", link: "", icon: "" };
            notification.color_class = "yellow-alert";
            notification.icon = "ban_trade";
            const idxspace = strNotification.indexOf(' ', 60);
            notification.title = (idxspace > 0)
                ? strNotification.substring(0, idxspace) + '...'
                : $.Localize('#SFUI_LoginPerfectWorld_Title_Info');
            notification.tooltip = strNotification;
            aAlerts.push(notification);
        }
        return aAlerts;
    }
    function _UpdateNotificationBar() {
        const aNotifications = _GetNotificationBarData();
        _m_elNotificationsContainer.Children().forEach(icon => {
            if (icon && icon.IsValid()) {
                icon.SetHasClass('show', false);
            }
        });
        if (aNotifications?.length < 1) {
            _m_elNotificationsContainer.SetHasClass('show', false);
            return;
        }
        _m_elNotificationsContainer.SetHasClass('show', true);
        aNotifications.forEach(notification => {
            let oNotification = notification;
            let elIcon = _m_elNotificationsContainer.FindChildInLayoutFile('id-alert-navbar-' + oNotification.icon);
            if (oNotification.is_gc_connecting && elIcon) {
                elIcon.SetHasClass('show', true);
            }
            else {
                if (!elIcon) {
                    elIcon = $.CreatePanel(('Image'), _m_elNotificationsContainer, 'id-alert-navbar-' + oNotification.icon, { class: 'mainmenu-top-navbar__radio-btn__icon mainmenu-top-navbar__alerts-icon',
                        src: 'file://{images}/icons/ui/' + oNotification.icon + '.svg'
                    });
                }
                elIcon.SwitchClass('alert-color', oNotification.color_class);
                elIcon.SetHasClass('show', true);
            }
            elIcon.SetPanelEvent('onactivate', () => {
                let gc = oNotification.is_gc_connecting === true ? 'true' : 'false';
                let elContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_navbar_notification.xml', 'icon=' + oNotification.icon + '&' +
                    'color=' + oNotification.color_class + '&' +
                    'title=' + oNotification.title + '&' +
                    'tooltip=' + oNotification.tooltip + '&' +
                    'link=' + oNotification.link + '&' +
                    'gcconnecting=' + gc);
                elContextMenu.AddClass("ContextMenu_NoArrow");
                elContextMenu.SetFocus();
            });
            elIcon.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTitleTextTooltip('id-alert-navbar-' + oNotification.icon, oNotification.title, oNotification.tooltip);
            });
            elIcon.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTitleTextTooltip(); });
        });
    }
    function _UpdateNotifications() {
        if (_m_notificationSchedule == false) {
            _LoopUpdateNotifications();
        }
    }
    function _UpdatePetNotification() {
        if (GameStateAPI.IsLocalPlayerPlayingMatch())
            return;
        const elPopups = $('#PopupManager');
        if (elPopups && elPopups.BHasClass('HaveActivePopups'))
            return;
        const petNotification = GetPetPopupNotification();
        if (petNotification) {
            PopUpPetNotification(petNotification);
        }
    }
    function _LoopUpdateNotifications() {
        _UpdatePopupnotification();
        _UpdateNotificationBar();
        const REDEMPTION_ENABLED = true;
        if (REDEMPTION_ENABLED) {
            _CheckRankUpRedemptionStore();
        }
        _CheckMajorStoreBalance();
        _UpdatePetNotification();
        _m_notificationSchedule = $.Schedule(1, _LoopUpdateNotifications);
    }
    let _m_acknowledgePopupHandler = null;
    function _ShowAcknowledgePopup(type = '', itemid = '') {
        if (type === 'xpgrant') {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_acknowledge_xpgrant.xml', 'none');
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_new_item', 'MOUSE');
            return;
        }
        let updatedItemTypeAndItemid = '';
        if (itemid && type)
            updatedItemTypeAndItemid = 'ackitemid=' + itemid + '&acktype=' + type;
        if (!_m_acknowledgePopupHandler) {
            let jsPopupCallbackHandle;
            jsPopupCallbackHandle = UiToolkitAPI.RegisterJSCallback(_ResetAcknowlegeHandler);
            _m_acknowledgePopupHandler = UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_acknowledge_item.xml', updatedItemTypeAndItemid + '&callback=' + jsPopupCallbackHandle);
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_new_item', 'MOUSE');
        }
    }
    function _ResetAcknowlegeHandler() {
        _m_acknowledgePopupHandler = null;
    }
    function ShowVote() {
        const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('MainMenuNavBarVote', '', 'file://{resources}/layout/context_menus/context_menu_vote.xml', '', () => { });
        contextMenuPanel.AddClass("ContextMenu_NoArrow");
    }
    MainMenu.ShowVote = ShowVote;
    function _HasStoreStatusPanelTrapPopups() {
        let elStorePanels = $.GetContextPanel().FindChildInLayoutFile('PopupManager').
            Children().filter(panel => panel.BHasClass('ShowStoreStatusPanelHandler'));
        return (elStorePanels && (elStorePanels.length > 0));
    }
    function _HideStoreStatusPanelInternal() {
        if (_m_storePopupElement && _m_storePopupElement.IsValid()) {
            _m_storePopupElement.DeleteAsync(0);
        }
        _m_storePopupElement = null;
    }
    function _HideStoreStatusPanel() {
        if (_HasStoreStatusPanelTrapPopups())
            return;
        _HideStoreStatusPanelInternal();
    }
    function _ShowStoreStatusPanel(strText, bAllowClose, bCancel, strOkCmd) {
        _HideStoreStatusPanelInternal();
        let paramclose = '0';
        if (bAllowClose) {
            paramclose = '1';
        }
        let paramcancel = '0';
        if (bCancel) {
            paramcancel = '1';
        }
        if (_HasStoreStatusPanelTrapPopups())
            return;
        _m_storePopupElement = UiToolkitAPI.ShowCustomLayoutPopupParameters('store_popup', 'file://{resources}/layout/popups/popup_store_status.xml', 'text=' + strText +
            '&' + 'allowclose=' + paramclose +
            '&' + 'cancel=' + paramcancel +
            '&' + 'okcmd=' + strOkCmd);
    }
    function _DeletePauseMenuMissionPanel() {
        if ($.GetContextPanel().FindChildInLayoutFile('JsActiveMission')) {
            $.GetContextPanel().FindChildInLayoutFile('JsActiveMission').DeleteAsync(0.0);
        }
    }
    function _SlideSearchPartyParticles(bSlidout) {
        const particle_container = $('#party-search-particles');
        particle_container.SetHasClass("mainmenu-party-search-particle--slide-out", bSlidout);
        particle_container.SetControlPoint(3, 0, 0, 0);
        particle_container.SetControlPoint(3, 1, 0, 0);
    }
    function _OnGcHelloReceived() {
        _CheckPopupNotificationsAtLogon();
        _UpdateUnlockCompAlert();
        VacNetAPI.UpdateReviewerInfo();
    }
    function _OnReviewInfoRecieved(bHasAccess) {
        $.GetContextPanel().SetHasClass('show-vacnet-link', bHasAccess);
    }
    function _UpdateUnlockCompAlert() {
        const btn = $.GetContextPanel().FindChildInLayoutFile('MainMenuNavBarPlay');
        const alert = btn.FindChildInLayoutFile('MainMenuPlayAlert');
        alert.SetDialogVariable("alert_value", $.Localize("#Store_Price_New"));
        if (!MyPersonaAPI.IsConnectedToGC()) {
            alert.AddClass('hidden');
            return;
        }
        const bHide = GameInterfaceAPI.GetSettingString('ui_show_unlock_competitive_alert') === '1' ||
            MyPersonaAPI.HasPrestige() ||
            MyPersonaAPI.GetCurrentLevel() !== 2;
        alert.SetHasClass('hidden', bHide);
    }
    function _SwitchVanity(team) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
        GameInterfaceAPI.SetSettingString('ui_vanitysetting_team', team);
        _ForceRestartVanity();
    }
    function _GoToCharacterLoadout(team) {
        _OpenInventory();
        let teamName = ((team == '2') ? 't' : 'ct');
        $.DispatchEvent("ShowLoadoutForItem", LoadoutAPI.GetItemID(teamName, 'customplayer'));
    }
    function _OnGoToCharacterLoadoutPressed() {
        if (!MyPersonaAPI.IsInventoryValid() || !MyPersonaAPI.IsConnectedToGC()) {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => { });
            return;
        }
        const team = GameInterfaceAPI.GetSettingString('ui_vanitysetting_team') == 't' ? 2 : 3;
        const elVanityContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-vanity-contextmenu', '', 'file://{resources}/layout/context_menus/context_menu_mainmenu_vanity.xml', 'type=catagory' +
            '&' + 'team=' + team, () => { });
        elVanityContextMenu.AddClass("ContextMenu_NoArrow");
    }
    function _OnChangeClanTagPressed() {
        if (!MyPersonaAPI.IsInventoryValid() || !MyPersonaAPI.IsConnectedToGC()) {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => { });
            return;
        }
        const elClanTagContextMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-vanity-contextmenu-clanchange', '', 'file://{resources}/layout/context_menus/context_menu_clan_tags.xml', '', () => { });
        elClanTagContextMenu.AddClass("ContextMenu_NoArrow");
    }
    function _CheckConnection() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            if (!_BCheckTabCanBeOpenedRightNow(_m_activeTab)) {
                OnHomeButtonPressed();
            }
        }
    }
    function OnPlayButtonPressed() {
        if (GameTypesAPI.ShouldForceNewUserTraining()) {
            OnHomeButtonPressed();
            _NewUser_ShowForceTrainingPopup();
        }
        else if (GameTypesAPI.ShouldShowNewUserPopup()) {
            OnHomeButtonPressed();
            _NewUser_ShowTrainingCompletePopup();
        }
        else {
            $.DispatchEvent('OpenPlayMenu');
        }
    }
    MainMenu.OnPlayButtonPressed = OnPlayButtonPressed;
    function _NewUser_ShowForceTrainingPopup() {
        UiToolkitAPI.ShowGenericPopupOkCancel('#ForceNewUserTraining_title', '#ForceNewUserTraining_text', '', () => {
            $.DispatchEvent('OpenPlayMenu');
            $.Schedule(0.1, _NewUser_TrainingMatch);
            GameTypesAPI.OnStartForcedNewUserTraining();
        }, () => { });
    }
    function _NewUser_ShowTrainingCompletePopup() {
        UiToolkitAPI.ShowGenericPopupThreeOptions('#PlayMenu_NewUser_title', '#PlayMenu_NewUser_text', '', '#PlayMenu_NewUser_casual', () => {
            GameTypesAPI.DisableNewUserExperience();
            $.DispatchEvent('OpenPlayMenu');
            $.Schedule(0.1, _NewUser_CasualMatchmaking);
        }, '#PlayMenu_NewUser_training', () => {
            $.DispatchEvent('OpenPlayMenu');
            $.Schedule(0.1, _NewUser_TrainingMatch);
        }, '#PlayMenu_NewUser_other', () => {
            GameTypesAPI.DisableNewUserExperience();
            $.DispatchEvent('OpenPlayMenu');
        });
    }
    function _NewUser_TrainingMatch() {
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
    }
    function _NewUser_CasualMatchmaking() {
        const settings = {
            update: {
                Options: {
                    action: 'custommatch',
                    server: 'official',
                },
                Game: {
                    mode: 'casual',
                    mode_ui: 'casual',
                    type: 'classic',
                    gamemodeflags: 0,
                    mapgroupname: 'mg_casualalpha',
                    map: 'de_dust2'
                }
            },
            delete: {}
        };
        LobbyAPI.UpdateSessionSettings(settings);
        LobbyAPI.StartMatchmaking('', '', '', '');
    }
    function _MainInitBackgroundMovie() {
        _UpdateBackgroundMap();
    }
    function _SetPetInteractionEnabled(mapPanel, bEnabled) {
        mapPanel.hittest = bEnabled;
        mapPanel.SetAcceptsInput(bEnabled);
        mapPanel.SetMapEntitiesCanReceiveInput(bEnabled);
    }
    {
        $.LogChannel("p.mainmenu", "LV_DEFAULT", "#aaff80");
        $.RegisterForUnhandledEvent('HideContentPanel', _OnHideContentPanel);
        $.RegisterForUnhandledEvent('SidebarContextMenuActive', _OnSideBarElementContextMenuActive);
        $.RegisterForUnhandledEvent('OpenPlayMenu', _OpenPlayMenu);
        $.RegisterForUnhandledEvent('OpenInventory', _OpenInventory);
        $.RegisterForUnhandledEvent('OpenWatchMenu', _OpenWatchMenu);
        $.RegisterForUnhandledEvent('OpenStatsMenu', _OpenStatsMenu);
        $.RegisterForUnhandledEvent('OpenSettingsMenu', _OpenSettingsMenu);
        $.RegisterForUnhandledEvent('OpenSubscriptionUpsell', _OpenSubscriptionUpsell);
        $.RegisterForUnhandledEvent('CSGOShowMainMenu', _OnShowMainMenu);
        $.RegisterForUnhandledEvent('CSGOHideMainMenu', _OnHideMainMenu);
        $.RegisterForUnhandledEvent('CSGOShowPauseMenu', _OnShowPauseMenu);
        $.RegisterForUnhandledEvent('CSGOHidePauseMenu', _OnHidePauseMenu);
        $.RegisterForUnhandledEvent('OpenSidebarPanel', ExpandSidebar);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GameMustExitNowForAntiAddiction', _GameMustExitNowForAntiAddiction);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _GcLogonNotificationReceived);
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', _OnGcHelloReceived);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _InventoryUpdated);
        $.RegisterForUnhandledEvent('InventoryItemPreview', _OnInventoryInspect);
        $.RegisterForUnhandledEvent('ShowCustomLayoutPopupParametersAsEvent', _OnShowCustomLayoutPopupParametersAsEvent);
        $.RegisterForUnhandledEvent('LootlistItemPreview', _OnLootlistItemPreview);
        $.RegisterForUnhandledEvent('ShowXrayCasePopup', _OnShowXrayCasePopup);
        $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_WeaponPreviewRequest', _WeaponPreviewRequest);
        $.RegisterForUnhandledEvent('PanoramaComponent_Overwatch_CaseUpdated', _UpdateOverwatch);
        $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_SelectItemForWorkshopPreviewCapability', _SelectItemForWorkshopPreviewCapability);
        $.RegisterForUnhandledEvent("PanoramaComponent_TournamentMatch_DraftUpdate", _TournamentDraftUpdate);
        $.RegisterForUnhandledEvent('ShowLoadoutForItem', _ShowLoadoutForItem);
        $.RegisterForUnhandledEvent('ShowAcknowledgePopup', _ShowAcknowledgePopup);
        $.RegisterForUnhandledEvent('ShowStoreStatusPanel', _ShowStoreStatusPanel);
        $.RegisterForUnhandledEvent('HideStoreStatusPanel', _HideStoreStatusPanel);
        $.RegisterForUnhandledEvent('MainMenu_OnGoToCharacterLoadoutPressed', _OnGoToCharacterLoadoutPressed);
        $.RegisterForUnhandledEvent('MainMenu_OnChangeClanTagPressed', _OnChangeClanTagPressed);
        $.RegisterForUnhandledEvent("PanoramaComponent_EmbeddedStream_VideoPlaying", _OnSteamIsPlaying);
        $.RegisterForUnhandledEvent("StreamPanelClosed", _ResetNewsEntryStyle);
        $.RegisterForUnhandledEvent("HideMainMenuNewsPanel", _HideMainMenuNewsPanel);
        $.RegisterForUnhandledEvent("CSGOMainInitBackgroundMovie", _MainInitBackgroundMovie);
        $.RegisterForUnhandledEvent("MainMenuGoToSettings", _OpenSettings);
        $.RegisterForUnhandledEvent("MainMenuGoToStore", _OpenFullscreenStore);
        $.RegisterForUnhandledEvent("MainMenuGoToCharacterLoadout", _GoToCharacterLoadout);
        $.RegisterForUnhandledEvent("PanoramaComponent_PartyList_PlayerActivityVoice", _PlayerActivityVoice);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _CheckConnection);
        MinimizeSidebar();
        _InitVanity();
        MinimizeSidebar();
        _InitFriendsList();
        $.RegisterForUnhandledEvent('CSGOMainMenuEscapeKeyPressed', OnEscapeKeyPressed);
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', _UpdateLocalPlayerVanity);
        $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_ProfileUpdated', _UpdateLocalPlayerVanity);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_PipRankUpdate', _UpdateLocalPlayerVanity);
        $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', _UpdateLocalPlayerVanity);
        $.RegisterForUnhandledEvent('ShowFullScreenOpaquePopup', _OnShowFullScreenOpaquePopup);
        $.RegisterForUnhandledEvent('CloseAllFullScreenOpaquePopups', _OnCloseAllFullScreenOpaquePopups);
        $.RegisterForUnhandledEvent("CSGOWorkshopAnnotationSubscriptionsChanged", () => _SetupAnnotationOptions(true));
        $.RegisterForUnhandledEvent('VacNet_OnReviewerInfoReceived', _OnReviewInfoRecieved);
    }
})(MainMenu || (MainMenu = {}));
