"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/licenseutil.ts" />
/// <reference path="../common/eventutil.ts" />
/// <reference path="../common/store_items.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
/// <reference path="../common/xpshop_tile_weapon_camera_settings.ts" />
/// <reference path="../popups/popup_acknowledge_item.ts" />
/// <reference path="../itemtile_store.ts" />
/// <reference path="../tournaments/predictions_timer.ts" />
/// <reference path="../tournaments/predictions_group_stage.ts" />
/// <reference path="../tournaments/predictions_bracket_stage.ts" />
var PopupMajorHub;
(function (PopupMajorHub) {
    const _m_cp = $.GetContextPanel();
    const _m_elPickemPages = _m_cp.FindChildInLayoutFile('id-pickem-pages');
    let _m_timeoutHandle;
    let _m_eventId;
    let _m_tournamentId;
    let _m_inventoryUpdatedHandler;
    let m_selectedPage;
    let m_setDefaultTab;
    let m_redeemAvailable = 0;
    let m_oPageData = {};
    m_oPageData.hasAlreadyInit = [];
    function ClosePopup() {
        if (_m_elPickemPages.IsValid() && _m_elPickemPages) {
            m_oPageData.hasAlreadyInit.forEach(id => {
                let elPage = _m_elPickemPages.FindChild(id);
                if (elPage && elPage.IsValid()) {
                    let elBtn = elPage.FindChildInLayoutFile('id-predictions-apply-btn').FindChild('id-apply-btn');
                    if (elBtn.enabled) {
                        elBtn.AddClass('activated-by-program');
                        $.DispatchEvent("Activated", elBtn, "program");
                    }
                }
            });
        }
        PopupMajorHub.DeleteDragItem();
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        _m_cp.SetReadyForDisplay(false);
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('ContextMenuEvent', '');
        UiToolkitAPI.HideTextTooltip();
    }
    PopupMajorHub.ClosePopup = ClosePopup;
    function LeaderboardPopup() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_leaderboards.xml', 'type=official_leaderboard_pickem_' + g_ActiveTournamentInfo.location + '_team.friends' +
            '&' + 'titleoverride=#CSGO_PickEm_Leaderboard_Title' +
            '&' + 'points-title=#tournament_coin_completed_challenges' +
            '&' + 'popup-style=major-hub-popup-leaderboard' +
            '&' + 'eventid=' + _m_eventId);
    }
    PopupMajorHub.LeaderboardPopup = LeaderboardPopup;
    function Init() {
        let eventId = $.GetContextPanel().GetAttributeString('eventid', '') ? parseInt($.GetContextPanel().GetAttributeString('eventid', '')) : -1;
        if (eventId < 0) {
            ClosePopup();
            return;
        }
        ReadyForDisplay();
    }
    PopupMajorHub.Init = Init;
    function ReadyForDisplay() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        let restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
        if (restrictions) {
            ClosePopup();
            return;
        }
        if (!_m_inventoryUpdatedHandler) {
            _m_inventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated);
        }
        let eventId = $.GetContextPanel().GetAttributeString('eventid', '') ? parseInt($.GetContextPanel().GetAttributeString('eventid', '')) : -1;
        if (eventId < 0) {
            return;
        }
        _m_eventId = eventId;
        SavePicksButton._m_eventId = eventId;
        _m_tournamentId = 'tournament:' + _m_eventId;
        if (_m_eventId > 22) {
            _m_cp.SetHasClass('major-' + _m_eventId, true);
        }
        SetUpHubBasedOnEventId();
    }
    function UnreadyForDisplay() {
        if (_m_inventoryUpdatedHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _m_inventoryUpdatedHandler);
            _m_inventoryUpdatedHandler = null;
        }
    }
    function SetUpHubBasedOnEventId() {
        _UpdateTournamentTitle();
        _UpdateChallenges();
        _SetUpSpray();
        _SetBackgroundImages();
        let bItemsForSale = _ItemsForSale();
        _m_cp.SetHasClass('no-items-on-sale', !bItemsForSale);
        if (bItemsForSale) {
            _UpdateStoreBannar();
        }
        LoadPickEmData();
        SetUpTournamentControlRoom();
        InitializeEmbeddedLeaderboard();
    }
    function SetUpTournamentControlRoom() {
        var elBtn = _m_cp.FindChildInLayoutFile('JsTournamentOperatorBtn');
        var bCanControl = false;
        if (MyPersonaAPI.GetMyOfficialTournamentName() &&
            g_ActiveTournamentInfo.eventid === _m_eventId) {
            bCanControl = true;
            elBtn.SetPanelEvent('onactivate', function () {
                UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_tournament_controlroom.xml', 'type=matches' +
                    '&' + 'eventid=tournament:' + _m_eventId +
                    '&' + 'titleoverride=#Control');
            });
        }
        elBtn.SetHasClass('hidden', !bCanControl);
    }
    function InitializeEmbeddedLeaderboard() {
        let elLeaderboard = _m_cp.FindChildInLayoutFile('id-leaderboard');
        if (elLeaderboard && elLeaderboard.BHasClass('hidden')) {
            elLeaderboard.SetAttributeString("type", 'official_leaderboard_pickem_' + g_ActiveTournamentInfo.location + '_team.friends');
            elLeaderboard.SetAttributeString("titleoverride", '#CSGO_TournamentHub_FriendsCoinLeaderboards');
            elLeaderboard.SetAttributeString("points-title", '#tournament_coin_completed_challenges');
            elLeaderboard.SetAttributeInt("limitrows", 4);
            elLeaderboard.BLoadLayout('file://{resources}/layout/popups/popup_leaderboards.xml', true, false);
            elLeaderboard.RemoveClass('hidden');
            elLeaderboard.AddClass('leaderboard_embedded');
            elLeaderboard.RemoveClass('Hidden');
        }
    }
    function SetDefaultTab() {
        let passItemId = InventoryAPI.GetActiveTournamentCoinItemId(_m_eventId * -1);
        let coinItemId = InventoryAPI.GetActiveTournamentCoinItemId(_m_eventId);
        if ((!coinItemId || coinItemId === '0') && (passItemId && passItemId !== '0') && !m_setDefaultTab)
            OpenPassActivate(passItemId);
        let elLastActiveSection;
        for (let i = g_ActiveTournamentInfo.num_stages_with_swiss; i >= 0; --i) {
            let sectionId = PredictionsAPI.GetEventSectionIDByIndex(_m_tournamentId, i);
            if (PredictionsAPI.GetSectionIsActive(_m_tournamentId, sectionId) === true) {
                let elNavBtn = _m_cp.FindChildInLayoutFile('id-pickem-nav-stage' + i);
                if (elNavBtn && elNavBtn.IsValid()) {
                    elNavBtn.SetHasClass('active', true);
                    elLastActiveSection = elNavBtn;
                }
                else {
                    elNavBtn.SetHasClass('active', false);
                }
            }
        }
        if (elLastActiveSection && elLastActiveSection.IsValid()) {
            $.DispatchEvent("Activated", elLastActiveSection, "mouse");
        }
        else {
            let elNavBtn = _m_cp.FindChildInLayoutFile('id-pickem-nav-stage' + g_ActiveTournamentInfo.num_stages_with_swiss);
            $.DispatchEvent("Activated", elNavBtn, "mouse");
        }
        m_setDefaultTab = true;
        return;
    }
    function _UpdateTournamentTitle() {
        _m_cp.SetDialogVariable('tournament_name', $.Localize('#CSGO_Tournament_Event_NameShort_' + _m_eventId));
        _m_cp.FindChildInLayoutFile('id-major-logo').SetImage('file://{images}/tournaments/events/tournament_logo_' + _m_eventId + '.svg');
        _m_cp.SetDialogVariable('store-title', $.Localize('#major_hub_store_title_event', _m_cp));
    }
    function _SetBackgroundImages() {
        if (!_m_eventId)
            return;
        let bgImage = "url( 'file://{images}/tournaments/backgrounds/pickem_bg_" + _m_eventId + ".png')";
        if (_m_eventId !== 24) {
            _m_cp.FindChildInLayoutFile('id-graffiti-block').style.backgroundImage = bgImage;
            _m_cp.FindChildInLayoutFile('id-graffiti-block').SetHasClass('major-background-size', true);
            _m_cp.FindChildInLayoutFile('id-major-store-block').style.backgroundImage = bgImage;
            _m_cp.FindChildInLayoutFile('id-major-store-block').SetHasClass('major-background-size', true);
        }
        else {
            _m_cp.FindChildInLayoutFile('id-major-store').style.backgroundImage = bgImage;
            _m_cp.FindChildInLayoutFile('id-major-store').SetHasClass('major-background-size', true);
        }
        _m_cp.FindChildInLayoutFile('id-challenges-block').style.backgroundImage = bgImage;
        _m_cp.FindChildInLayoutFile('id-challenges-block').SetHasClass('major-background-size', true);
    }
    function _UpdateSouvenirSection(bItemsForSale) {
        let elDesc = _m_cp.FindChildInLayoutFile('id-major-hub-souvenir-desc');
        elDesc.visible = true;
        if (bItemsForSale) {
            let idForCharges = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_charge, 0);
            if (StoreAPI.GetStoreItemSalePrice(idForCharges, 1, '')) {
                _m_cp.SetDialogVariable('souvenir_price', StoreAPI.GetStoreItemSalePrice(idForCharges, 1, ''));
            }
            elDesc.SetDialogVariable('souvenir_package_desc', $.Localize('#major_hub_souvenir_package_desc', _m_cp));
        }
        else if (m_redeemAvailable && m_redeemAvailable > 0) {
            elDesc.SetDialogVariable('souvenir_package_desc', $.Localize('#major_hub_souvenir_package_desc_no_price', _m_cp));
        }
        else {
            elDesc.visible = false;
        }
        _m_cp.SetDialogVariable('souvenir_package', $.Localize('#CSGO_TournamentPass_' + g_ActiveTournamentInfo.location + '_store_desc'));
    }
    const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
    function _UpdateStoreBannar() {
        _m_cp.FindChildInLayoutFile('id-major-open-store').SetPanelEvent('onactivate', () => {
            UiToolkitAPI.ShowCustomLayoutPopup('id-popup-major-store', 'file://{resources}/layout/popups/popup_major_store.xml');
            $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.tab_mainmenu_shop", "MOUSE");
        });
        const elStore = _m_cp.FindChildInLayoutFile('id-major-store-banner');
        const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
        const numStickers = 10;
        for (let i = 0; i < numStickers; i++) {
            const stickerIndex = g_ActiveTournamentTeams[getRandomInt(0, g_ActiveTournamentTeams.length - 1)].players[getRandomInt(0, 4)].rankingids[getRandomInt(0, 2)];
            const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, stickerIndex);
            let elDisplay;
            if (i == 2 || i == 8) {
                elDisplay = elStore.FindChildInLayoutFile('id-major-store-banner-item-' + i);
                elDisplay.SetCamera('camera_weapon_7');
                elDisplay.SetActiveItem(0);
                elDisplay.SetItemItemId(itemId, '');
                let nRenderInterval = 1;
                elDisplay.SetRenderInterval(nRenderInterval);
            }
            else {
                elDisplay = elStore.FindChildInLayoutFile('id-major-store-banner-item-' + i);
                elDisplay.itemid = itemId;
            }
            elDisplay.AddClass('show');
        }
        _SetUpBannerSouvenir(elStore);
    }
    function _SetUpBannerSouvenir(elStore) {
        InventoryAPI.SetInventorySortAndFilters('inv_sort_rarity', false, 'rifle,craft_souvenir,is_rental:false,is_sealed:false', '', '');
        let itemId = '';
        const count = InventoryAPI.GetInventoryCount();
        if (count > 0) {
            const rarityCutoff = Math.floor(InventoryAPI.GetItemRarity(InventoryAPI.GetInventoryItemIDByIndex(0)) / 3);
            let maxInclusiveIndex = count - 1;
            while (maxInclusiveIndex > 0) {
                const rarityMid = InventoryAPI.GetItemRarity(InventoryAPI.GetInventoryItemIDByIndex(maxInclusiveIndex));
                if (rarityMid >= rarityCutoff)
                    break;
                else
                    maxInclusiveIndex = Math.floor(maxInclusiveIndex / 2);
            }
            itemId = InventoryAPI.GetInventoryItemIDByIndex(getRandomInt(0, maxInclusiveIndex));
        }
        if (!itemId) {
            const randomRifles = [7, 8, 9, 10, 11, 13, 16, 40, 60];
            itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(randomRifles[getRandomInt(0, randomRifles.length - 1)], 0);
        }
        if (itemId) {
            const halfTeams = Math.floor(g_ActiveTournamentTeams.length / 2);
            const fauxSouvenirItemId = InventoryAPI.CreateTempCombinedItemWithTool(itemId, 'craft_souvenir:faux_' + g_ActiveTournamentInfo.eventid + '_'
                + g_ActiveTournamentTeams[getRandomInt(0, halfTeams - 1)].teamid + '_'
                + g_ActiveTournamentTeams[getRandomInt(halfTeams, g_ActiveTournamentTeams.length - 1)].teamid);
            if (fauxSouvenirItemId)
                itemId = fauxSouvenirItemId;
        }
        const defName = InventoryAPI.GetItemDefinitionName(itemId);
        let cameraData = XpShopWeaponCameraSettings.CameraSettings.find(({ type }) => type === defName);
        let cameraSuffix = cameraData !== undefined ? cameraData.camera : '0';
        const elModelPanel = elStore.FindChildInLayoutFile('id-major-store-banner-souvenir');
        elModelPanel.SetCamera('camera_weapon_' + cameraSuffix);
        elModelPanel.SetActiveItem(0);
        elModelPanel.SetItemItemId(itemId, '');
        let nRenderInterval = 1;
        elModelPanel.SetRenderInterval(nRenderInterval);
    }
    function _ItemsForSale() {
        var tournamentEventId = NewsAPI.GetActiveTournamentEventID();
        if (tournamentEventId === 0)
            return false;
        if (g_ActiveTournamentInfo.eventid !== tournamentEventId)
            return false;
        return g_ActiveTournamentInfo.active;
    }
    ;
    function _UpdateChallenges() {
        let tournamentCoinItemId = InventoryAPI.GetActiveTournamentCoinItemId(_m_eventId);
        let bHasActiveCoin = true;
        if (!tournamentCoinItemId || tournamentCoinItemId === '0') {
            bHasActiveCoin = false;
            tournamentCoinItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_coins[0], 0);
        }
        let nCampaignID = InventoryAPI.GetItemAttributeValue(tournamentCoinItemId, "campaign id");
        let numTotalChallenges = InventoryAPI.GetCampaignNodeCount(nCampaignID);
        let nPointsEarned = 0;
        let arrMissions = [];
        for (let i = 0; i < numTotalChallenges; ++i) {
            let nMissionNodeID = InventoryAPI.GetCampaignNodeIDbyIndex(nCampaignID, i);
            let strNodeState = InventoryAPI.GetCampaignNodeState(nCampaignID, nMissionNodeID, tournamentCoinItemId, true);
            nPointsEarned = strNodeState === "complete" ? ++nPointsEarned : nPointsEarned;
            let nQuestID = InventoryAPI.GetCampaignNodeQuestID(nCampaignID, nMissionNodeID);
            ;
            let strFauxQuestItem = InventoryAPI.GetQuestItemIDFromQuestID(nQuestID);
            let strQuestIcon = InventoryAPI.GetQuestIcon(strFauxQuestItem);
            let strQuestName = InventoryAPI.GetItemName(strFauxQuestItem);
            let oChallenge = {
                idx: i,
                text: strQuestName,
                isComplete: strNodeState === "complete",
                isDisqualified: strNodeState === 'disqualified',
                icon: (!bHasActiveCoin || (strNodeState === 'disqualified')) ? 'locked' :
                    (strQuestIcon === 'watchem') ? 'watch' :
                        (strQuestIcon === 'pickem') ? 'trophy' :
                            strQuestIcon,
            };
            arrMissions.push(oChallenge);
        }
        let counter = 0;
        arrMissions.forEach(oChallenge => { if (oChallenge.isDisqualified) {
            oChallenge.idx = counter++;
            _CreateUpdateChallenge(oChallenge);
        } });
        arrMissions.forEach(oChallenge => { if (!oChallenge.isDisqualified) {
            oChallenge.idx = counter++;
            _CreateUpdateChallenge(oChallenge);
        } });
        _m_cp.SetHasClass('no-active-coin', !bHasActiveCoin);
        if (bHasActiveCoin) {
            _SetPoints(nPointsEarned, tournamentCoinItemId);
            _SetThresholdText(nPointsEarned, numTotalChallenges, tournamentCoinItemId);
            _RedemptionChargesRemaining(tournamentCoinItemId);
            _m_cp.FindChildInLayoutFile('id-major-hub-coin-model').SetActiveItem(0);
            _m_cp.FindChildInLayoutFile('id-major-hub-coin-model').SetItemItemId(tournamentCoinItemId, '');
            _m_cp.FindChildInLayoutFile('id-major-hub-coin-model').SetPanelEvent('onactivate', () => {
                $.DispatchEvent("InventoryItemPreview", tournamentCoinItemId, '');
            });
        }
        else {
            let passIndex = g_ActiveTournamentInfo.itemid_pass;
            let passId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(passIndex, 0);
            _m_cp.FindChildInLayoutFile('id-pass-upsell-image').itemid = passId;
            let coinIndex = g_ActiveTournamentInfo.itemid_coins[0];
            let coinId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(coinIndex, 0);
            _m_cp.FindChildInLayoutFile('id-pass-upsell-image-coin').itemid = coinId;
            _SetPassBtnAction();
        }
    }
    function _CreateUpdateChallenge(oChallenge) {
        var elList = _m_cp.FindChildInLayoutFile('id-major-challenges');
        var elChallenge = _m_cp.FindChildInLayoutFile('id-major-challenge-' + oChallenge.idx);
        if (!elChallenge) {
            elChallenge = $.CreatePanel("Panel", elList, 'id-major-challenge-' + oChallenge.idx);
            elChallenge.BLoadLayoutSnippet("major-challenge");
        }
        _UpdateChallenge(elChallenge, oChallenge);
    }
    function _UpdateChallenge(elChallenge, oChallenge) {
        let elIcon = elChallenge.FindChildInLayoutFile('id-major-challenge-icon');
        elChallenge.SetDialogVariable('challenge_desc', oChallenge.text);
        let iconPath = oChallenge.isComplete ? 'file://{images}/icons/ui/check.svg' :
            oChallenge.isDisqualified ? 'file://{images}/icons/ui/cancel.svg' :
                'file://{images}/icons/ui/' + oChallenge.icon + '.svg';
        elIcon.SetImage(iconPath);
        elChallenge.SetHasClass('complete', oChallenge.isComplete);
        elChallenge.SetHasClass('disqualified', !oChallenge.isComplete && oChallenge.isDisqualified);
    }
    function _SetPoints(nPointsEarned, tournamentCoinItemId) {
        _m_cp.SetDialogVariableInt('challenges_complete', nPointsEarned);
        let coinLevel = InventoryAPI.GetItemAttributeValue(tournamentCoinItemId, "upgrade level");
        let style = coinLevel < 1 ? 'bronze' : coinLevel === 1 ? 'silver' : coinLevel > 1 ? 'gold' : 'bronze';
        $.GetContextPanel().FindChildInLayoutFile('id-coin-status-image').AddClass(style);
    }
    var _SetThresholdText = function (nPointsEarned, nTotalChallenges, tournamentCoinItemId) {
        let threshold = InventoryAPI.GetItemAttributeValue(tournamentCoinItemId, "upgrade threshold");
        let sText = (nTotalChallenges - nPointsEarned) === 0 ? '#tournament_coin_completed_challenges' :
            (threshold > nPointsEarned) ? '#tournament_coin_remaining_challenges_curr' : '';
        let challengesRemain = threshold - nPointsEarned;
        _m_cp.SetDialogVariableInt('challenges', challengesRemain);
        _m_cp.SetDialogVariable('challenges_status', $.Localize(sText, $.GetContextPanel()));
    };
    var _RedemptionChargesRemaining = function (tournamentCoinItemId) {
        let coinLevel = parseInt(InventoryAPI.GetItemAttributeValue(tournamentCoinItemId, "upgrade level"));
        let coinRedeemsPurchased = parseInt(InventoryAPI.GetItemAttributeValue(tournamentCoinItemId, "operation drops awarded 1"));
        if (coinRedeemsPurchased)
            coinLevel += coinRedeemsPurchased;
        let redeemed = parseInt(InventoryAPI.GetItemAttributeValue(tournamentCoinItemId, "operation drops awarded 0"));
        m_redeemAvailable = coinLevel - redeemed;
        if (_m_eventId >= 26)
            m_redeemAvailable = 0;
        _m_cp.SetDialogVariableInt('redeems', m_redeemAvailable);
        let elPanel = _m_cp.FindChildInLayoutFile('id-coin-status-charges');
        elPanel.visible = m_redeemAvailable > 0;
        let sTooltip = $.Localize('#popup_redeem_souvenir_desc:f', _m_cp);
        elPanel.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip('id-coin-status-charges', sTooltip); });
        elPanel.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
    };
    var _SetPassBtnAction = function () {
        let btn = _m_cp.FindChildInLayoutFile('id-pass-upsell-btn');
        let passItemId = InventoryAPI.GetActiveTournamentCoinItemId(_m_eventId * -1);
        if ((!passItemId || passItemId === '0')) {
            let bCanPurchasePass = (g_ActiveTournamentInfo.eventid === _m_eventId) &&
                ('' !== StoreAPI.GetStoreItemSalePrice(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentStoreLayout[0][0], 0), 1, ''));
            if (bCanPurchasePass) {
                btn.text = '#SFUI_ConfirmBtn_GetPassNow';
                btn.SetPanelEvent('onactivate', () => {
                    var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_store_linked_items.xml', 'itemids=' + InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pass, 0) +
                        ',' + InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pack, 0) +
                        '&' + 'linkedWarning=#tournament_items_notice');
                    contextMenuPanel.AddClass("ContextMenu_NoArrow");
                });
            }
            else {
                btn.text = '';
                btn.visible = false;
                btn.SetPanelEvent('onactivate', () => {
                });
            }
        }
        else {
            btn.text = '#SFUI_ConfirmBtn_ActivatePassNow';
            btn.SetPanelEvent('onactivate', () => {
                InventoryAPI.UseTool(passItemId, '');
            });
        }
    };
    function _SetUpSpray() {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-major-store');
        if (!_m_eventId) {
            elParent.SetHasClass('graffiti-panel-visible', false);
            return;
        }
        let tournamentCoinItemId = InventoryAPI.GetActiveTournamentCoinItemId(_m_eventId);
        if (!tournamentCoinItemId || tournamentCoinItemId === '0' || g_ActiveTournamentInfo.eventid !== _m_eventId || !g_ActiveTournamentInfo.active) {
            elParent.SetHasClass('graffiti-panel-visible', false);
            return;
        }
        var elImage = $.GetContextPanel().FindChildInLayoutFile('id-tournament-journal-spray');
        elImage.itemid = ItemInfo.GetFauxReplacementItemID(tournamentCoinItemId, 'graffiti');
        var elIBtn = $.GetContextPanel().FindChildInLayoutFile('id-tournament-journal-selectspray-btn');
        elIBtn.SetPanelEvent('onactivate', function () {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_tournament_select_spray.xml', 'journalid=' + tournamentCoinItemId +
                '&' + 'eventid=' + _m_eventId);
        });
        elParent.SetHasClass('graffiti-panel-visible', true);
    }
    ;
    function NavigateToTab(sectionIndex) {
        let elPage = _m_elPickemPages.FindChild('id-pickem-page-stage' + sectionIndex);
        elPage?.SetHasClass('hidden', m_selectedPage === elPage);
        m_selectedPage?.SetHasClass('hidden', m_selectedPage !== elPage);
        let sectionId = PredictionsAPI.GetEventSectionIDByIndex(_m_tournamentId, sectionIndex);
        let groupId = PredictionsAPI.GetSectionGroupIDByIndex(_m_tournamentId, sectionId, 0);
        m_selectedPage = elPage;
        m_oPageData.panel = elPage;
        m_oPageData.eventId = _m_eventId;
        m_oPageData.tournamentId = _m_tournamentId;
        m_oPageData.sectionId = sectionId;
        m_oPageData.groupId = groupId;
        m_oPageData.sectionIndex = sectionIndex;
        PredictionsTimer.UpdateTimer();
        if ((sectionIndex < g_ActiveTournamentInfo.num_stages_with_swiss) && elPage) {
            PredictionsGroup.Init();
        }
        else {
            PredictionsBracket.Init();
        }
        if (!m_oPageData.hasAlreadyInit.includes(elPage.id)) {
            m_oPageData.hasAlreadyInit.push(elPage.id);
        }
    }
    PopupMajorHub.NavigateToTab = NavigateToTab;
    function GetActivePageData() {
        return m_oPageData;
    }
    PopupMajorHub.GetActivePageData = GetActivePageData;
    function RefreshData() {
        MatchListAPI.Refresh(_m_tournamentId);
    }
    PopupMajorHub.RefreshData = RefreshData;
    function LoadPickEmData() {
        let listState = MatchListAPI.GetState(_m_tournamentId);
        let elLoadingPanel = _m_cp.FindChildInLayoutFile('id-pickem-loading-status');
        if (listState === 'none') {
            MatchListAPI.Refresh(_m_tournamentId);
            _CancelMatchStatsLoadedTimeout();
            _m_cp.SetHasClass('loading', true);
            _m_cp.SetHasClass('timeout', false);
            elLoadingPanel.SetDialogVariable('pickem_loaded_status', $.Localize('#CSGO_Watch_Loading_PickEm'));
        }
        if (listState === 'ready') {
            let isLoaded = PredictionsAPI.GetMyPredictionsLoaded(_m_tournamentId);
            let sectionsCount = PredictionsAPI.GetEventSectionsCount(_m_tournamentId);
            if (!isLoaded || !sectionsCount) {
                _CancelMatchStatsLoadedTimeout();
                _m_timeoutHandle = $.Schedule(5, () => {
                    _m_timeoutHandle = null;
                    elLoadingPanel.SetDialogVariable('pickem_loaded_status', $.Localize('#pickem_apply_timeout'));
                    _m_cp.SetHasClass('timeout', true);
                });
                return;
            }
            _CancelMatchStatsLoadedTimeout();
            _m_cp.SetHasClass('loading', false);
            if (!m_setDefaultTab) {
                $.Schedule(.15, SetDefaultTab);
            }
            else {
                NavigateToTab(m_oPageData.sectionIndex);
            }
            return;
        }
        return;
    }
    function _CancelMatchStatsLoadedTimeout() {
        if (_m_timeoutHandle) {
            $.CancelScheduled(_m_timeoutHandle);
            _m_timeoutHandle = null;
        }
    }
    ;
    function CheckIfPickIsCorrect(sCorrectPicks, userPickTeamID) {
        let aCorrectPicks = sCorrectPicks.split(',');
        return aCorrectPicks.includes(userPickTeamID.toString());
    }
    PopupMajorHub.CheckIfPickIsCorrect = CheckIfPickIsCorrect;
    function IsSectionActive() {
        if (PredictionsAPI.GetSectionIsActive(m_oPageData.tournamentId, m_oPageData.sectionId)) {
            return true;
        }
        return false;
    }
    PopupMajorHub.IsSectionActive = IsSectionActive;
    function IsPreviousSectionActive() {
        if (PredictionsAPI.GetSectionIsActive(m_oPageData.tournamentId, m_oPageData.sectionId - 1)) {
            return true;
        }
        return false;
    }
    PopupMajorHub.IsPreviousSectionActive = IsPreviousSectionActive;
    function GetTeamIcon(teamId) {
        let teamTag = PredictionsAPI.GetTeamTag(teamId);
        return 'file://{images}/tournaments/teams/' + teamTag + '.svg';
    }
    PopupMajorHub.GetTeamIcon = GetTeamIcon;
    function OnInventoryUpdated() {
        _SetUpSpray();
        _UpdateChallenges();
        SavePicksButton.ShowHideNoActivePassWarning(m_oPageData, false);
    }
    function RefreshActivePage() {
        PredictionsTimer.UpdateTimer();
        if (m_oPageData.sectionIndex < g_ActiveTournamentInfo.num_stages_with_swiss) {
            PredictionsGroup.UpdateFromPredictionUploadedEvent();
        }
        else if (m_oPageData.sectionIndex == g_ActiveTournamentInfo.num_stages_with_swiss) {
            PredictionsBracket.UpdateFromPredictionUploadedEvent();
        }
    }
    function ItemAcquired(itemId) {
        let nSouvenir = g_ActiveTournamentInfo;
        let newItemDefName = InventoryAPI.GetItemDefinitionName(itemId);
        let passDef = InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pass, 0));
        let passPackDef = InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pack, 0));
        if (InventoryAPI.GetItemDefinitionName(itemId) === passDef || InventoryAPI.GetItemDefinitionName(itemId) === passPackDef) {
            AcknowledgeItems.GetItemsByType([passDef, passPackDef], true);
            OpenPassActivate(itemId);
            return;
        }
    }
    function OpenPassActivate(itemId) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_capability_decodable.xml');
        let oSettings = {
            item_id: itemId,
            work_type: 'decodeable'
        };
        elPanel.Data().oSettings = oSettings;
    }
    function DeleteDragItem() {
        if (PopupMajorHub.m_elDragImage && PopupMajorHub.m_elDragImage.IsValid()) {
            PopupMajorHub.m_elDragImage.DeleteAsync(0.25);
        }
    }
    PopupMajorHub.DeleteDragItem = DeleteDragItem;
    {
        ReadyForDisplay();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MatchList_StateChange', LoadPickEmData);
        $.RegisterForUnhandledEvent('PanoramaComponent_MatchList_PredictionUploaded', RefreshActivePage);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', ItemAcquired);
        $.RegisterForUnhandledEvent('OpenInventory', ClosePopup);
        $.RegisterEventHandler('ReadyForDisplay', _m_cp, ReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', _m_cp, UnreadyForDisplay);
    }
})(PopupMajorHub || (PopupMajorHub = {}));
var SavePicksButton;
(function (SavePicksButton) {
    let _m_timeoutApplyHandle;
    function UpdateBtn(aLocalPicks = []) {
        ResetTimeoutHandle();
        let oPageData = PopupMajorHub.GetActivePageData();
        let elBtn = oPageData.panel.FindChildInLayoutFile('id-predictions-apply-btn').FindChild('id-apply-btn');
        let elWarning = oPageData.panel.FindChildInLayoutFile('id-predictions-apply-btn').FindChild('id-apply-warning');
        elWarning.SetDialogVariable('pass-name', InventoryAPI.GetItemName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pass, 0)));
        let bThisSectionIsNoLongerActive = !PredictionsAPI.GetSectionIsActive(oPageData.tournamentId, oPageData.sectionId);
        if (!PredictionsAPI.GetGroupCanPick(oPageData.tournamentId, oPageData.groupId)) {
            elBtn.enabled = false;
            elBtn.visible = false;
            ShowHideNoActivePassWarning(oPageData, true);
            let elToggleBtn = oPageData.panel.FindChildInLayoutFile('id-predictions-apply-btn').FindChild('id-toggle-correct-btn');
            elToggleBtn.visible = true;
            elToggleBtn.SetPanelEvent('onactivate', () => {
                oPageData.panel.SetHasClass('show-all-correct-picks', !oPageData.panel.BHasClass('show-all-correct-picks'));
            });
            elToggleBtn.checked = bThisSectionIsNoLongerActive;
            oPageData.panel.SetHasClass('show-all-correct-picks', bThisSectionIsNoLongerActive);
            return;
        }
        if (bThisSectionIsNoLongerActive) {
            elBtn.enabled = false;
            elBtn.visible = false;
            ShowHideNoActivePassWarning(oPageData, true);
            return;
        }
        elBtn.visible = true;
        ShowHideNoActivePassWarning(oPageData, false);
        let nCount = (oPageData.sectionIndex >= g_ActiveTournamentInfo.num_stages_with_swiss) ? 7 : PredictionsAPI.GetGroupPicksCount(oPageData.tournamentId, oPageData.groupId);
        if (aLocalPicks.length === nCount) {
            let bPicksDifferent = false;
            for (let i = 0; i < nCount; ++i) {
                if (aLocalPicks[i].teamId !== PredictionsAPI.GetMyPredictionTeamID(oPageData.tournamentId, aLocalPicks[i].group, aLocalPicks[i].groupIndex)) {
                    bPicksDifferent = true;
                    break;
                }
                ;
            }
            elBtn.enabled = bPicksDifferent;
            elBtn.SetDialogVariable('save-btn-text', bPicksDifferent ?
                $.Localize('#pickem_save_all') :
                $.Localize('#pickem_saved'));
            elBtn.SwitchClass('btn_state', !bPicksDifferent ? 'saved' : '');
            if (bPicksDifferent) {
                _SetPicks(elBtn, oPageData, nCount, aLocalPicks);
            }
        }
        else {
            elBtn.enabled = false;
            elBtn.SwitchClass('btn_state', '');
            elBtn.SetDialogVariableInt('user-picks', aLocalPicks.length);
            elBtn.SetDialogVariableInt('total-picks', nCount);
            elBtn.SetDialogVariable('save-btn-text', $.Localize('#pickem_make_picks', elBtn));
        }
    }
    SavePicksButton.UpdateBtn = UpdateBtn;
    function ShowHideNoActivePassWarning(oPageData, bHide = false) {
        if (!oPageData.panel || oPageData.panel.IsValid() === false) {
            return;
        }
        let elWarning = oPageData.panel.FindChildInLayoutFile('id-predictions-apply-btn').FindChild('id-apply-warning');
        let tournamentCoinItemId = InventoryAPI.GetActiveTournamentCoinItemId(SavePicksButton._m_eventId);
        elWarning.visible = (!tournamentCoinItemId || tournamentCoinItemId === '0') && !bHide;
    }
    SavePicksButton.ShowHideNoActivePassWarning = ShowHideNoActivePassWarning;
    function _SetPicks(elBtn, oPageData, nCount, aLocalPicks) {
        if (elBtn.enabled) {
            var args = [oPageData.tournamentId];
            for (var i = 0; i < nCount; ++i) {
                args.push(aLocalPicks[i].group.toString(), aLocalPicks[i].groupIndex.toString(), PredictionsAPI.GetFakeItemIDToRepresentTeamID(oPageData.tournamentId, aLocalPicks[i].teamId));
            }
            elBtn.SetPanelEvent('onactivate', () => {
                let tournamentCoinItemId = InventoryAPI.GetActiveTournamentCoinItemId(oPageData.eventId);
                let passItemId = InventoryAPI.GetActiveTournamentCoinItemId(SavePicksButton._m_eventId * -1);
                let bHasActiveCoin = tournamentCoinItemId && tournamentCoinItemId !== '0';
                let bIsPrime = (MyPersonaAPI.GetElevatedState() === 'elevated');
                if (!elBtn.BHasClass('activated-by-program')) {
                    if (!bIsPrime && !bHasActiveCoin) {
                        if (!elBtn.BHasClass('activated-by-program')) {
                            UiToolkitAPI.ShowGenericPopupTwoOptions('#CSGO_official_leaderboard_pickem_' + g_ActiveTournamentInfo.location + '_team', '#CSGO_PickEm_Leaderboards_PassOrPrime_Message', '', '#SFUI_ConfirmBtn_GetPassNow', () => { }, '#SFUI_Elevated_Status_Sale_action', () => { UiToolkitAPI.ShowCustomLayoutPopup('prime_status', 'file://{resources}/layout/popups/popup_prime_status.xml'); });
                        }
                        return;
                    }
                    if (!bHasActiveCoin && (passItemId && passItemId !== '0')) {
                        let elPopup = UiToolkitAPI.ShowGenericPopupTwoOptions('#pickem_submit_warning_popup_title', '#pickem_submit_warning_popup_desc', '', '#pickem_submit_warning_popup_action2', () => {
                            InventoryAPI.UseTool(passItemId, '');
                            _SubmitPicks(elBtn, args);
                        }, '#pickem_submit_warning_popup_action', () => { _SubmitPicks(elBtn, args); });
                        elPopup.SetDialogVariable('pass-name', InventoryAPI.GetItemName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pass, 0)));
                        return;
                    }
                    if (!bHasActiveCoin) {
                        let elPopup = UiToolkitAPI.ShowGenericPopupTwoOptions('#pickem_submit_warning_popup_title', '#pickem_submit_warning_popup_desc', '', '#SFUI_ConfirmBtn_GetPassNow', () => {
                            $.DispatchEvent('UIPopupButtonClicked', elPopup, '');
                            $.DispatchEvent('ContextMenuEvent', '');
                            UiToolkitAPI.HideTextTooltip();
                            var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_store_linked_items.xml', 'itemids=' + InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pass, 0) +
                                ',' + InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pack, 0) +
                                '&' + 'linkedWarning=#tournament_items_notice');
                            contextMenuPanel.AddClass("ContextMenu_NoArrow");
                            contextMenuPanel.SetFocus();
                        }, '#pickem_submit_warning_popup_action', () => { _SubmitPicks(elBtn, args); });
                        elPopup.SetDialogVariable('pass-name', InventoryAPI.GetItemName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_pass, 0)));
                        return;
                    }
                }
                _SubmitPicks(elBtn, args);
            });
        }
    }
    function _SubmitPicks(elBtn, args) {
        elBtn.enabled = false;
        elBtn.SwitchClass('btn_state', 'waiting-for-update');
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.tab_mainmenu_shop', 'MOUSE');
        PredictionsAPI.SetMyPredictionUsingItemID.apply(PredictionsAPI, args);
        ResetTimeoutHandle();
        _m_timeoutApplyHandle = $.Schedule(7, () => {
            _CancelWaitForCallBack(elBtn);
        });
    }
    SavePicksButton._SubmitPicks = _SubmitPicks;
    function ResetTimeoutHandle() {
        if (_m_timeoutApplyHandle) {
            $.CancelScheduled(_m_timeoutApplyHandle);
            _m_timeoutApplyHandle = null;
        }
    }
    SavePicksButton.ResetTimeoutHandle = ResetTimeoutHandle;
    function _CancelWaitForCallBack(elBtn) {
        _m_timeoutApplyHandle = null;
        PopupMajorHub.ClosePopup();
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#CSGO_PickEm_Pick_TimeOut'), '', () => { });
    }
})(SavePicksButton || (SavePicksButton = {}));
