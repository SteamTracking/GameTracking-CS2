"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/async.ts" />
/// <reference path="../common/xpshop_tile_weapon_camera_settings.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../common/icon.ts" />
/// <reference path="../common/store_items.ts" />
/// <reference path="../popups/popup_acknowledge_item.ts" />
/// <reference path="../popups/popup_offers_laptop.ts" />
/// <reference path="../itemtile_store.ts" />
var CollectionOffers;
(function (CollectionOffers) {
    class UniqueRandom {
        min;
        max;
        available = [];
        constructor(min, max) {
            this.min = min;
            this.max = max;
            this.reset();
        }
        reset() {
            this.available = [];
            for (let i = this.min; i <= this.max; i++) {
                this.available.push(i);
            }
        }
        getNext() {
            if (this.available.length === 0) {
                this.reset();
            }
            const index = Math.floor(Math.random() * this.available.length);
            const value = this.available[index];
            this.available.splice(index, 1);
            return value;
        }
    }
    function _GetRandomIntInRange(min, max) {
        if (min > max)
            [min, max] = [max, min];
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
    let m_idContainerItem = "";
    let m_defidxContainerItem = 0;
    let m_numOfferCounter = 0;
    let m_bWrappingUpThisTransaction = false;
    let m_tmsExpectingXpGrantNotification = 0;
    CollectionOffers.m_currentOfferId = '';
    let m_numVolatileNotifications = 0;
    let m_initialDotsUpdateFinished = false;
    function _IsFinalOffer() {
        return (m_numOfferCounter <= 0);
    }
    function _CurrentOfferNumber() {
        return (m_numOfferCounter < 0) ? -m_numOfferCounter : m_numOfferCounter;
    }
    let m_signalBars = _GetRandomIntInRange(0, 1);
    let m_elScreen;
    let m_elMessagesParent;
    let m_elYesBtn;
    let m_elNoBtn;
    let m_elEndBtn;
    ;
    let m_mapUniqueRandoms = {};
    class MapLineTracker_t {
        data = {};
        getCount(s) { return this.data[s] || 0; }
        incrementCount(s) { return this.data[s] ? ++this.data[s] : (this.data[s] = 1); }
        async awaitMessageOnce(m) {
            if (this.incrementCount(m.line) != 1)
                return false;
            await _MakeMessage(m);
            return true;
        }
    }
    ;
    let m_mapLineTracker = new MapLineTracker_t;
    const dealerIntroMessage = {
        line: '#dealer_message_start_',
        sender: 'dealer',
        action: () => {
            _MakeMessage(dealerFirstOffer);
        }
    };
    const dealerReturningToContractMessage = {
        line: '#dealer_message_resume_',
        sender: 'dealer',
        action: () => {
            _DealerEstablishExistingOffer();
        }
    };
    const dealerFirstOffer = {
        line: '#dealer_message_first_offer_',
        sender: 'dealer',
        action: () => {
            _DealerSendOffer();
        }
    };
    const dealerNextOffer = {
        line: '#dealer_message_next_offer_',
        sender: 'dealer',
        action: () => {
            _DealerSendOffer();
        }
    };
    const dealerLastOffer = {
        line: '#dealer_message_last_offer_',
        sender: 'dealer',
    };
    const dealerEndOffer = {
        line: '#dealer_message_end_',
        sender: 'dealer',
    };
    const dealerOpenCheckOutMessage = {
        line: '#dealer_message_open_check_out_',
        sender: 'dealer',
        action: async () => {
            await Async.Delay(.25);
            _DealerTransitionToPurchaseState();
        }
    };
    const dealerTxnXldBailout = {
        line: '#dealer_message_txn_xld_bailout_',
        sender: 'dealer',
        action: async () => {
            await Async.Delay(2);
            _MakeMessage(systemDealerLeave);
        }
    };
    const dealerStatTrak = {
        line: '#dealer_message_stattrack_',
        sender: 'dealer'
    };
    const dealerFactoryNew = {
        line: '#dealer_message_factory_new_',
        sender: 'dealer'
    };
    const dealerMinimalWear = {
        line: '#dealer_message_minimal_wear_',
        sender: 'dealer'
    };
    const dealerCovert = {
        line: '#dealer_message_covert_',
        sender: 'dealer'
    };
    const dealerClassified = {
        line: '#dealer_message_classified_',
        sender: 'dealer'
    };
    const dealerRestricted = {
        line: '#dealer_message_restricted_',
        sender: 'dealer'
    };
    const dealerBattleScarred = {
        line: '#dealer_message_battle_scarred_',
        sender: 'dealer'
    };
    const dealerUsps = {
        line: '#dealer_message_usp-s_',
        sender: 'dealer'
    };
    const dealerItemDesc = {
        line: '#dealer_message_item_desc_',
        dialogVar: { dialogName: 'flavor-text', dialogText: '' },
        sender: 'dealer'
    };
    const dealerAdditionStatTrak = {
        line: '#dealer_message_addition_stattrak_',
        sender: 'dealer'
    };
    const dealerAdditionFactoryNew = {
        line: '#dealer_message_addition_factory_new_',
        sender: 'dealer'
    };
    const dealerOfferLimitMessage = {
        line: '#dealer_message_set_offer_limit_',
        sender: 'dealer',
        action: async () => {
            await Async.Delay(.5);
            _ShowMessageOfferLimit();
        }
    };
    const dealerContainerExpired = {
        line: '#dealer_message_timerexpired_',
        sender: 'dealer',
        action: () => {
            _MakeMessage(systemDealerLeaveContainerDestroy);
        }
    };
    const systemDealerJoin = {
        line: '#system_dealer_join_chat_0',
        sender: 'system',
        action: () => {
            _OnSystemDealerJoinBootstrap();
        }
    };
    const systemUserRejectOffer = {
        line: '#system_user_reject_offer_0',
        sender: 'system',
        nomarkup: true
    };
    const systemDealerLeave = {
        line: '#system_dealer_left_chat_0',
        sender: 'system',
        action: async () => {
            m_elScreen.FindChildInLayoutFile('id-laptop-connected-icon').SetHasClass('connected', false);
            m_elScreen.FindChildInLayoutFile('id-laptop-signal-icon').SetHasClass('connected-' + m_signalBars, false);
            await Async.Delay(1);
            Close(false);
        }
    };
    const systemDealerLeaveContainerDestroy = {
        line: '#system_dealer_left_chat_0',
        sender: 'system',
        action: async () => {
            m_elScreen.FindChildInLayoutFile('id-laptop-connected-icon').SetHasClass('connected', true);
            m_elScreen.FindChildInLayoutFile('id-laptop-signal-icon').SetHasClass('connected-' + m_signalBars, true);
            await Async.Delay(1);
            Close(true);
        }
    };
    const systemOfferLimitSetWithBootstrapAction = {
        line: '#system_user_updated_offer_limit_0',
        sender: 'system',
        action: async () => {
            await ShowDealerOfferLimitAcknowledge(true);
            const elWaitMessage = _ShowDealerWaitMessageDotDotDot();
            await Async.Delay(2);
            (await elWaitMessage).visible = false;
            _OnSystemDealerJoinBootstrap();
        }
    };
    const systemOfferLimitSet = {
        line: '#system_user_updated_offer_limit_0',
        sender: 'system',
        action: () => {
            ShowDealerOfferLimitAcknowledge();
        }
    };
    async function ShowDealerOfferLimitAcknowledge(firstTime = false) {
        let oLimits = JSON.parse(InventoryAPI.GetVolatileLimits());
        if (oLimits.limit !== 0) {
            const strLine = !firstTime ? '#dealer_message_limit_' : '#dealer_message_limit_first_time_';
            await _MakeMessage({ line: strLine, sender: 'dealer' });
        }
        else {
            const strLine = !firstTime ? '#dealer_message_limit_unlimited_' : '#dealer_message_limit_first_time_unlimited_';
            await _MakeMessage({ line: strLine, sender: 'dealer' });
        }
    }
    function Init(itemId, elScreen) {
        m_idContainerItem = itemId;
        m_defidxContainerItem = InventoryAPI.GetItemDefinitionIndex(m_idContainerItem);
        m_elMessagesParent = elScreen.FindChildInLayoutFile('id-chat-messages');
        m_elYesBtn = elScreen.FindChildInLayoutFile('id-user-message-yes');
        m_elNoBtn = elScreen.FindChildInLayoutFile('id-user-message-no');
        m_elEndBtn = elScreen.FindChildInLayoutFile('id-user-message-end');
        m_elScreen = elScreen;
        elScreen.FindChildInLayoutFile('id-laptop-screen-close').SetPanelEvent('onactivate', () => {
            OffersLaptop.ClosePopUp();
        });
        let setName = ItemInfo.GetSet(m_idContainerItem);
        if (!setName)
            setName = ItemInfo.GetSet(InventoryAPI.GetLootListItemIdByIndex(m_idContainerItem, 0));
        m_elMessagesParent.SetDialogVariable('collection', $.Localize('#CSGO_' + setName));
        _UpdateOfferTimer();
        _CollectionInfo();
        _SetTooltips(elScreen);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseFinalizing', _OnPurchaseFinalizing);
        $.RegisterForUnhandledEvent('ShowStoreStatusPanel', _ShowStoreStatusPanel);
        _MakeMessage(systemDealerJoin);
        elScreen.SetPanelEvent('onactivate', () => { _MakeFingerPrints(elScreen); });
    }
    CollectionOffers.Init = Init;
    function _SetTooltips(elScreen) {
        elScreen.FindChildInLayoutFile('id-wear-fn').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-wear-fn', '#SFUI_InvTooltip_Wear_Amount_0', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-wear-fn').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elScreen.FindChildInLayoutFile('id-wear-mw').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-wear-mw', '#SFUI_InvTooltip_Wear_Amount_1', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-wear-mw').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elScreen.FindChildInLayoutFile('id-wear-ft').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-wear-ft', '#SFUI_InvTooltip_Wear_Amount_2', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-wear-ft').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elScreen.FindChildInLayoutFile('id-wear-ww').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-wear-ww', '#SFUI_InvTooltip_Wear_Amount_3', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-wear-ww').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elScreen.FindChildInLayoutFile('id-wear-bs').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-wear-bs', '#SFUI_InvTooltip_Wear_Amount_4', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-wear-bs').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elScreen.FindChildInLayoutFile('id-weapon-wear-name-container').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-weapon-wear-name-container', '#SFUI_InvTooltip_WearTag', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-weapon-wear-name-container').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elScreen.FindChildInLayoutFile('id-weapon-wear-rating-container').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-weapon-wear-rating-container', '#SFUI_ItemInfo_WearAmount', 'tooltip-offer-wear'); });
        elScreen.FindChildInLayoutFile('id-weapon-wear-rating-container').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        m_elScreen.FindChildInLayoutFile('id-laptop-connected-icon').SetPanelEvent('onmouseover', () => {
            let tooltipText = m_elScreen.FindChildInLayoutFile('id-laptop-connected-icon').BHasClass('connected') ? '#popup_vpn_status_connected' : '#popup_vpn_status_disconnected';
            UiToolkitAPI.ShowTextTooltipStyled('id-laptop-connected-icon', tooltipText, 'tooltip-laptop-topbar');
        });
        elScreen.FindChildInLayoutFile('id-laptop-connected-icon').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        m_elScreen.FindChildInLayoutFile('id-offer-lootlist-btn').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-offer-lootlist-btn', '#collection_xp_tooltip', 'tooltip-offer-wear'); });
        m_elScreen.FindChildInLayoutFile('id-offer-lootlist-btn').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        m_elScreen.FindChildInLayoutFile('id-orignal-owner-image').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-orignal-owner-image', '#laptop_original_seal_tooltip', 'tooltip-offer-wear'); });
        m_elScreen.FindChildInLayoutFile('id-orignal-owner-image').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        m_elScreen.FindChildInLayoutFile('id-offer-zoom_hint').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-offer-zoom_hint', '#laptop_zoom_tooltip', 'tooltip-offer-wear'); });
        m_elScreen.FindChildInLayoutFile('id-offer-zoom_hint').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        m_elScreen.FindChildInLayoutFile('id-offer-pan_hint').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-offer-pan_hint', '#laptop_pan_tooltip', 'tooltip-offer-actions'); });
        m_elScreen.FindChildInLayoutFile('id-offer-pan_hint').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        m_elScreen.FindChildInLayoutFile('id-price-tooltip').SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltipStyled('id-price-tooltip', '#laptop_pricing_tooltip', 'tooltip-offer-actions'); });
        m_elScreen.FindChildInLayoutFile('id-price-tooltip').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
    }
    function Close(destoryAnim = false) {
        _TimerUpdateCancel();
        m_elScreen.FindChildInLayoutFile('laptop-container').RemoveClass('open');
        OffersLaptop.ClosePopUp(destoryAnim);
    }
    CollectionOffers.Close = Close;
    function _RandomizeLocString(line) {
        if (line && line.length > 0 && line[0] === '#' && line[line.length - 1] === '_') {
            if (!m_mapUniqueRandoms.hasOwnProperty(line)) {
                const urMax = UiToolkitAPI.EnumerateLocalizationStringVariants(line);
                let ur = new UniqueRandom(0, urMax);
                m_mapUniqueRandoms[line] = ur;
            }
            const nrnd = m_mapUniqueRandoms[line].getNext();
            return line + nrnd;
        }
        return line;
    }
    async function _MakeMessage(oMessage) {
        m_elMessagesParent.SetDialogVariable('user-name', MyPersonaAPI.GetName());
        if (oMessage.dialogVar !== undefined) {
            m_elMessagesParent.SetDialogVariable(oMessage.dialogVar?.dialogName, oMessage.dialogVar.dialogText);
        }
        let locString = _RandomizeLocString(oMessage.line);
        let raw_string = $.Localize(locString, m_elMessagesParent);
        let allMessages = [];
        if (oMessage.nomarkup) {
            let message = {
                text: raw_string,
                sleepTime: Number(0),
                sender: oMessage.sender
            };
            allMessages.push(message);
        }
        else {
            let curTextIdx = 0;
            let sleepTime = Number(0);
            while (curTextIdx < raw_string.length) {
                let splitPos = raw_string.indexOf('<!--', curTextIdx);
                if (splitPos > curTextIdx) {
                    let message = {
                        text: raw_string.substring(curTextIdx, splitPos),
                        sleepTime: sleepTime,
                        sender: oMessage.sender
                    };
                    allMessages.push(message);
                }
                if (splitPos == -1) {
                    let message = {
                        text: raw_string.substring(curTextIdx),
                        sleepTime: sleepTime,
                        sender: oMessage.sender
                    };
                    allMessages.push(message);
                    break;
                }
                let indexEndOfSleepTime = raw_string.indexOf('-->', splitPos);
                if (indexEndOfSleepTime == -1)
                    break;
                sleepTime = Number(raw_string.substring(splitPos + 4, indexEndOfSleepTime));
                sleepTime = (sleepTime > 0) ? sleepTime : 0;
                curTextIdx = indexEndOfSleepTime + 3;
            }
        }
        for (const message of allMessages) {
            if (message.sleepTime > 0)
                await Async.Delay(message.sleepTime);
            OffersLaptop.LaptopSoundStartLooping('UI.Laptop.MessageLoop');
            await _DisplayMessage(message);
            OffersLaptop.LaptopSoundStopLooping('UI.Laptop.MessageLoop');
        }
        if (oMessage.hasOwnProperty('action') && oMessage.action !== undefined) {
            await oMessage.action();
        }
    }
    async function _DisplayMessage(message) {
        const elMessage = $.CreatePanel('Panel', m_elMessagesParent, '');
        elMessage.BLoadLayoutSnippet(message.sender + '-message');
        let aWords = message.text.split(' ');
        let elMessageLabel = elMessage.FindChildInLayoutFile('id-chat-message-label');
        elMessage.AddClass('show');
        _HighlightCurrentMessage();
        elMessageLabel.html = (message.sender !== 'system');
        if (message.sender === 'dealer') {
            elMessage.FindChildInLayoutFile('id-chat-message-label-placeholder');
            elMessage.FindChildInLayoutFile('id-chat-message-label-placeholder').text = message.text;
            elMessage.FindChildInLayoutFile('avatar-image').SetDefaultImage("file://{images}/avatars/arms_dealer.psd");
            await Async.Delay(.1);
            m_elMessagesParent.ScrollToBottom();
            let displayString = '';
            for (const word of aWords) {
                await Async.Delay(.05);
                displayString = displayString + word + ' ';
                elMessageLabel.text = displayString;
            }
        }
        else {
            elMessageLabel.text = message.text;
            await Async.Delay(.1);
            m_elMessagesParent.ScrollToBottom();
        }
    }
    async function _OnSystemDealerJoinBootstrap() {
        let numOffers = InventoryAPI.GetItemAttributeValue(m_idContainerItem, '{uint32}quest points remaining');
        let oLimits = JSON.parse(InventoryAPI.GetVolatileLimits());
        if (numOffers == undefined) {
            m_numOfferCounter = 0;
            await _MakeMessage(dealerIntroMessage);
        }
        else {
            m_numOfferCounter = numOffers;
            await _MakeMessage(dealerReturningToContractMessage);
        }
        const setting = oLimits.choices.find(item => item.limit === oLimits.limit);
        m_elScreen.SetDialogVariable('limit', GetLimitString(setting?.limit, setting?.label));
        m_elScreen.FindChildInLayoutFile('id-offer-limit-setting').SetPanelEvent('onactivate', () => {
            ShowOfferLimitPopup();
        });
        m_elScreen.FindChildInLayoutFile('id-laptop-connected-icon').SetHasClass('connected', true);
        m_elScreen.FindChildInLayoutFile('id-laptop-signal-icon').SetHasClass('connected-' + m_signalBars, true);
    }
    async function _ShowDealerWaitMessageDotDotDot(bPreserveOfferID) {
        const elWaitMessage = $.CreatePanel('Panel', m_elMessagesParent, '');
        elWaitMessage.BLoadLayoutSnippet('wait-message');
        elWaitMessage.FindChildInLayoutFile('avatar-image').SetDefaultImage("file://{images}/avatars/arms_dealer.psd");
        elWaitMessage.AddClass('show');
        await Async.Delay(.1);
        m_elMessagesParent.ScrollToBottom();
        if (bPreserveOfferID) {
            await Async.Delay(.1);
        }
        else {
            CollectionOffers.m_currentOfferId = '';
            m_numVolatileNotifications = 0;
        }
        return elWaitMessage;
    }
    async function _AwaitOfferItemID(bJustNotificationIsOk) {
        for (let i = 5; i-- > 0;) {
            await Async.Delay(1);
            if (bJustNotificationIsOk && (m_numVolatileNotifications > 0)) {
                return CollectionOffers.m_currentOfferId ? CollectionOffers.m_currentOfferId : m_idContainerItem;
            }
            if (CollectionOffers.m_currentOfferId) {
                return CollectionOffers.m_currentOfferId;
            }
        }
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#PlayMenu_unavailable_newuser_2_nogcconnection'), '', () => { });
        Close(false);
        return '';
    }
    async function _ReplaceMessageDotDotDotWithOffer(elWaitMessage) {
        UpdateCollectionDots();
        elWaitMessage.FindChildInLayoutFile('id-waiting').visible = false;
        const OfferItemData = _GetItemData(CollectionOffers.m_currentOfferId);
        _HighlightCurrentMessage();
        await _DisplayOfferDownloadMessage(elWaitMessage, OfferItemData);
        _UpdateWeaponModel(OfferItemData);
        await _MessageOfferComment(OfferItemData);
        await Async.Delay(.1);
        m_elMessagesParent.ScrollToBottom();
        m_elScreen.FindChildInLayoutFile('id-chat-messages-bg').SetHasClass('show', true);
        let elUserButtonContainer = m_elScreen.FindChildInLayoutFile('id-user-messages-container');
        if (!elUserButtonContainer.BHasClass('show')) {
            elUserButtonContainer.SetHasClass('show', true);
        }
        if (_IsFinalOffer()) {
            elUserButtonContainer.SetDialogVariable('user-response-title', $.Localize('#user_btn_purchase_final_title'));
        }
        else {
            elUserButtonContainer.SetDialogVariable('offer-count', $.Localize('#dealer_offer_' + _CurrentOfferNumber()));
            elUserButtonContainer.SetDialogVariable('user-response-title', $.Localize('#user_btn_purchase_title', elUserButtonContainer));
        }
        _SetUpUserOfferConfirmDeclineBtns(elWaitMessage.FindChildInLayoutFile('id-offer-' + OfferItemData.itemId), OfferItemData);
    }
    async function _DealerEstablishExistingOffer() {
        const elWaitMessage = await _ShowDealerWaitMessageDotDotDot();
        InventoryAPI.PerformItemCasketTransaction(0, m_idContainerItem, m_idContainerItem);
        if (!await _AwaitOfferItemID())
            return;
        await _ReplaceMessageDotDotDotWithOffer(elWaitMessage);
    }
    async function _DealerSendOffer() {
        let elWaitMessage = await _ShowDealerWaitMessageDotDotDot();
        InventoryAPI.UseToolWithIntArg(m_idContainerItem, m_idContainerItem, m_numOfferCounter);
        if (!await _AwaitOfferItemID())
            return;
        if (_IsFinalOffer()) {
            elWaitMessage.RemoveAndDeleteChildren();
            await _MakeMessage(dealerLastOffer);
            elWaitMessage = await _ShowDealerWaitMessageDotDotDot(true);
        }
        await _ReplaceMessageDotDotDotWithOffer(elWaitMessage);
    }
    async function _DealerEndTransaction() {
        const elWaitMessage = await _ShowDealerWaitMessageDotDotDot();
        InventoryAPI.UseToolWithIntArg(m_idContainerItem, m_idContainerItem, m_numOfferCounter);
        m_bWrappingUpThisTransaction = true;
        if (!await _AwaitOfferItemID(true))
            return;
        elWaitMessage.RemoveAndDeleteChildren();
        await _MakeMessage(dealerEndOffer);
        await Async.Delay(2.5);
        await _MakeMessage(systemDealerLeaveContainerDestroy);
    }
    async function _DealerTransitionToPurchaseState() {
        const strPurchaseString = '' + InventoryAPI.GetItemDefinitionIndex(m_idContainerItem) + '(' + m_idContainerItem + ')';
        StoreAPI.StoreItemPurchase(strPurchaseString);
    }
    function _OnPurchaseFinalizing(strTxnID) {
        m_bWrappingUpThisTransaction = true;
        const storeStatusMessage = {
            line: '#dealer_message_purchase_finalizing_0',
            sender: 'system'
        };
        _MakeMessage(storeStatusMessage);
    }
    function _ShowStoreStatusPanel(strText, bAllowClose, bCancel, strOkCmd) {
        if (strText === '#StoreCheckout_TransactionCanceled') {
            _MakeMessage(dealerTxnXldBailout);
            return;
        }
        if (bCancel)
            return;
        if (strText === '#StoreCheckout_TransactionCompleted') {
            const storeStatusMessage = {
                line: strText,
                sender: 'system-success',
                action: () => {
                    _EnableActionButtons(false);
                }
            };
            _MakeMessage(storeStatusMessage);
            return;
        }
        const storeStatusMessage = {
            line: strText,
            sender: 'system-steam',
            action: () => {
                const bCanRetryPurchase = !m_bWrappingUpThisTransaction &&
                    (strText !== '#StoreCheckout_PurchaseExpiredItemsUnavailable') &&
                    (strText !== '#StoreCheckout_CompleteButUnfinalized');
                _EnableActionButtons(bCanRetryPurchase);
            }
        };
        _MakeMessage(storeStatusMessage);
    }
    async function _MessageOfferComment(OfferItemData) {
        if (OfferItemData.rarity === 6 || OfferItemData.rarity === 5) {
            if (OfferItemData.rarity === 6) {
                await _MakeMessage(dealerCovert);
            }
            else if (OfferItemData.rarity === 5) {
                await _MakeMessage(dealerClassified);
            }
            if (OfferItemData.statTrack) {
                await _MakeMessage(dealerAdditionStatTrak);
            }
            else if (OfferItemData.numWear === 0) {
                await _MakeMessage(dealerAdditionFactoryNew);
            }
        }
        else if (OfferItemData.numWear === 0) {
            await _MakeMessage(dealerFactoryNew);
        }
        else if (OfferItemData.statTrack) {
            await _MakeMessage(dealerStatTrak);
        }
        else if (OfferItemData.numWear === 1 && _RollChance(50)
            && (await m_mapLineTracker.awaitMessageOnce(dealerMinimalWear))) {
            ;
        }
        else if (OfferItemData.rarity === 4 && _RollChance(50)
            && (await m_mapLineTracker.awaitMessageOnce(dealerRestricted))) {
            ;
        }
        else if (OfferItemData.numWear === 4 && _RollChance(50)
            && (await m_mapLineTracker.awaitMessageOnce(dealerBattleScarred))) {
            ;
        }
        else if (_RollChance(10) && (0 == m_mapLineTracker.getCount(dealerItemDesc.line))) {
            if (InventoryAPI.GetItemDescription(OfferItemData.itemId, '')) {
                if (dealerItemDesc.dialogVar !== undefined) {
                    const descString = InventoryAPI.GetItemDescription(OfferItemData.itemId, '');
                    const offFlavor = descString.indexOf("<i>");
                    const endFlavor = descString.indexOf("</i>", offFlavor);
                    if (offFlavor != -1 && endFlavor != -1 && endFlavor > offFlavor) {
                        dealerItemDesc.dialogVar.dialogText = descString.substring(offFlavor, endFlavor + 4);
                        if (dealerItemDesc.dialogVar.dialogText.indexOf('<!--') == -1) {
                            m_mapLineTracker.incrementCount(dealerItemDesc.line);
                            await _MakeMessage(dealerItemDesc);
                        }
                    }
                }
            }
        }
    }
    function _GetItemData(itemId) {
        const OfferItemData = {
            itemId: itemId,
            defName: InventoryAPI.GetItemDefinitionName(itemId),
            rarity: InventoryAPI.GetItemRarity(itemId),
            rarityName: InventoryAPI.GetItemType(itemId),
            rarityColor: InventoryAPI.GetItemRarityColor(itemId),
            itemName: InventoryAPI.GetItemName(itemId),
            statTrack: (InventoryAPI.GetItemAttributeValue(itemId, "kill eater")) !== undefined ? true : false,
            itemType: ItemInfo.IsWeapon(itemId) ? 'weapon' : ItemInfo.IsKeychain(itemId) ? 'keychain' : 'sticker',
            slot: InventoryAPI.GetLoadoutCategory(itemId),
            numWear: InventoryAPI.GetWear(itemId),
            price: StoreAPI.GetStoreItemEmbeddedAttributePrice(itemId, 1, '')
        };
        return OfferItemData;
    }
    function _HighlightCurrentMessage() {
        m_elMessagesParent.Children().forEach((element, index) => {
            element.SetHasClass('current-message', index == (m_elMessagesParent.Children().length - 1));
        });
    }
    function _DisplayOfferDownloadMessage(elWaitMessage, OfferItemData) {
        const elOffer = $.CreatePanel('Panel', elWaitMessage.FindChildInLayoutFile('id-message'), 'id-offer-' + OfferItemData.itemId);
        elOffer.BLoadLayoutSnippet('dealer-offer');
        elOffer.FindChildInLayoutFile('id-offer-message-image').itemid = OfferItemData.itemId;
        _SetRarityColor(elOffer.FindChildInLayoutFile('id-offer-message-rarity'), OfferItemData.rarityColor);
        _SetRarityColor(m_elScreen.FindChildInLayoutFile('id-chat-messages-bg'), OfferItemData.rarityColor);
        elOffer.AddClass('glow-color-rarity-' + OfferItemData.rarity);
        elOffer.SetDialogVariable('offer-count', $.Localize('#EOM_Position_' + _CurrentOfferNumber()));
        elOffer.FindChildInLayoutFile('id-offer-desc').text =
            _IsFinalOffer() ?
                $.Localize('#dealer_offer_attachment_final', elOffer) :
                $.Localize('#dealer_offer_received_count', elOffer);
        elOffer.SetDialogVariable('item-name', OfferItemData.itemName);
        elOffer.SetDialogVariable('item-rarity', $.Localize('#SFUI_InvTooltip_Wear_Amount_' + OfferItemData.numWear));
        elOffer.SetDialogVariable('offer-price', OfferItemData.price);
        elOffer.SetDialogVariable('offer-status', $.Localize('#dealer_offer_attachment_status-price', elOffer));
        elOffer.AddClass('show');
    }
    function _SetRarityColor(elPanel, rarityColor) {
        if (rarityColor) {
            elPanel.style.washColor = rarityColor;
        }
    }
    let m_timerHandler = null;
    function _UpdateOfferTimer() {
        _TimerUpdateCancel();
        const elTimer = m_elScreen.FindChildInLayoutFile('id-offer-expiration');
        if (!m_idContainerItem || m_bWrappingUpThisTransaction) {
            elTimer.SetDialogVariable('expiration-time', ' ');
            return;
        }
        const expirationDate = InventoryAPI.GetExpirationDate(m_idContainerItem);
        let oLocData = FormatText.FormatExpirationToDDHHMMSSWithSymbolSeperator(expirationDate);
        _SetBatteryState(oLocData, expirationDate);
        if (oLocData.isExpired || !InventoryAPI.IsValidItemID(m_idContainerItem)) {
            elTimer.SetDialogVariable('expiration-time', $.Localize('#op_pass_status_operation_over'));
            return;
        }
        elTimer.SetDialogVariable('expiration-time', oLocData.time);
        elTimer.FindChildInLayoutFile('id-offer-expiration-timer').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltipStyled('id-offer-expiration-timer', '#laptop_expiration_tooltip', 'tooltip-offer-actions');
        });
        elTimer.FindChildInLayoutFile('id-offer-expiration-timer').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        m_timerHandler = $.Schedule(1, _UpdateOfferTimer);
    }
    function _SetBatteryState(oLocData, expirationDate) {
        const elBattery = m_elScreen.FindChildInLayoutFile('id-laptop-battery');
        const barPercentage = oLocData.isExpired ? 18 : Math.floor(Math.max(18, Math.min(oLocData.seconds / 2592, 100)));
        elBattery.SwitchClass('state', oLocData.isExpired ? 'red' : (barPercentage < 40) ? 'yellow' : 'green');
        elBattery.style.width = barPercentage.toString() + '%;';
        elBattery.SetDialogVariableInt('percent', barPercentage);
        m_elScreen.FindChildInLayoutFile('id-laptop-battery-container').SetPanelEvent('onmouseover', () => {
            let tooltipText = $.Localize('#laptop_battery_tooltip', elBattery);
            UiToolkitAPI.ShowTextTooltipStyled('id-laptop-battery-container', tooltipText, 'tooltip-laptop-topbar');
        });
        m_elScreen.FindChildInLayoutFile('id-laptop-battery-container').SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
    }
    function _TimerUpdateCancel() {
        if (m_timerHandler !== null) {
            $.CancelScheduled(m_timerHandler);
            m_timerHandler = null;
        }
    }
    function _EnableActionButtons(bEnable = false) {
        if (m_bWrappingUpThisTransaction)
            bEnable = false;
        m_elYesBtn.enabled = bEnable;
        m_elNoBtn.enabled = bEnable;
        m_elEndBtn.enabled = bEnable;
        m_elScreen.FindChildInLayoutFile('id-offer-limit-setting').enabled = bEnable;
        m_elScreen.FindChildInLayoutFile('id-price-tooltip').SetHasClass('faded', !bEnable);
    }
    let _m_savedOffer = null;
    let _m_savedOfferItemData = null;
    function _SetUpUserOfferConfirmDeclineBtns(elOffer, OfferItemData) {
        _m_savedOffer = elOffer;
        _m_savedOfferItemData = OfferItemData;
        const numPaidAlready = 0;
        let payPrice = OfferItemData.price;
        m_elYesBtn.SetDialogVariable('price', payPrice);
        m_elYesBtn.visible = true;
        m_elNoBtn.visible = !_IsFinalOffer() && (numPaidAlready === 0);
        m_elEndBtn.visible = _IsFinalOffer() && (numPaidAlready === 0);
        m_elScreen.FindChildInLayoutFile('id-offer-limit-setting').visible = (numPaidAlready === 0);
        m_elScreen.FindChildInLayoutFile('id-price-tooltip').visible = (numPaidAlready === 0);
        if (m_elYesBtn.visible) {
            const btnYesSettings = {
                btn: m_elYesBtn,
                tooltip: '#user_btn_purchase_desc_purchase',
                locString: $.Localize(_RandomizeLocString('#user_btn_accept_'), m_elYesBtn),
                tooltipStyle: 'tooltip-offer-actions',
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _EnableActionButtons(false);
                    _MakeMessage(dealerOpenCheckOutMessage);
                    OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Drop.Purchased');
                }
            };
            HoldButton.SetupButton(btnYesSettings);
        }
        if (m_elEndBtn.visible) {
            const btnEndSettings = {
                btn: m_elEndBtn,
                tooltip: '#user_btn_purchase_desc_end',
                locString: $.Localize('#user_btn_end'),
                tooltipStyle: 'tooltip-offer-actions',
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _EnableActionButtons(false);
                    _DealerEndTransaction();
                }
            };
            HoldButton.SetupButton(btnEndSettings);
        }
        if (m_elNoBtn.visible) {
            const btnNoSettings = {
                btn: m_elNoBtn,
                tooltip: '#user_btn_purchase_desc_continue',
                locString: $.Localize(_IsFinalOffer() ? '#user_btn_decline' : _RandomizeLocString('#user_btn_next_'), m_elNoBtn),
                tooltipStyle: 'tooltip-offer-actions',
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _EnableActionButtons(false);
                    elOffer.SetHasClass('rejected', true);
                    elOffer.SetDialogVariable('offer-status', $.Localize('#dealer_offer_attachment_status-declined-price', elOffer));
                    elOffer.FindChildInLayoutFile('id-offer-desc').text = $.Localize('#dealer_offer_attachment_status-declined', elOffer);
                    m_elScreen.FindChildInLayoutFile('id-offer-preview-panel-container').SetHasClass('show', false);
                    m_elScreen.FindChildInLayoutFile('id-weapon-wear-rating-pointer').style.transform = 'translateX(100%) translateY(3px) scaleY(-1);';
                    m_elScreen.FindChildInLayoutFile('id-chat-messages-bg').SetHasClass('show', false);
                    OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Drop.Discarded');
                    const elModel = m_elScreen.FindChildInLayoutFile('id-offer-preview-panel');
                    if (elModel) {
                        elModel.DeleteAsync(.25);
                    }
                    _MakeMessage(systemUserRejectOffer);
                    _MakeMessage(dealerNextOffer);
                }
            };
            HoldButton.SetupButton(btnNoSettings);
        }
        _EnableActionButtons(numPaidAlready === 0);
    }
    function OnInventoryUpdated() {
        if (m_bWrappingUpThisTransaction)
            return;
        if (InventoryAPI.IsValidItemID(m_idContainerItem))
            return;
        _UpdateOfferTimer();
        m_bWrappingUpThisTransaction = true;
        m_idContainerItem = '';
        _EnableActionButtons(false);
        m_elEndBtn.enabled = false;
        _MakeMessage(dealerContainerExpired);
    }
    CollectionOffers.OnInventoryUpdated = OnInventoryUpdated;
    function OnItemCustomizationNotification(numericType, szType, itemid) {
        if (szType === 'xpgrant' && m_tmsExpectingXpGrantNotification) {
            m_tmsExpectingXpGrantNotification = 0;
            _XpCollectionPopup();
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_acknowledge_xpgrant.xml', 'none');
            return;
        }
        if (numericType !== 1012 || !szType || !szType.startsWith("casket_contents"))
            return;
        if (itemid !== m_idContainerItem)
            return;
        ++m_numVolatileNotifications;
        let numOffers = InventoryAPI.GetItemAttributeValue(m_idContainerItem, '{uint32}quest points remaining');
        if (numOffers === undefined)
            m_numOfferCounter = 0;
        else {
            m_numOfferCounter = numOffers;
        }
        InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, "casketcontents:" + m_idContainerItem, '', '');
        const count = InventoryAPI.GetInventoryCount();
        const offerItemID = (count && (count > 0)) ? InventoryAPI.GetInventoryItemIDByIndex(0) : "";
        if (!offerItemID)
            return;
        if (!InventoryAPI.IsValidItemID(offerItemID))
            return;
        CollectionOffers.m_currentOfferId = offerItemID;
    }
    CollectionOffers.OnItemCustomizationNotification = OnItemCustomizationNotification;
    function _UpdateWeaponModel(OfferItemData) {
        let cameraData = XpShopWeaponCameraSettings.CameraSettings.find(({ type }) => type === OfferItemData.defName);
        let cameraSuffix = cameraData !== undefined ? cameraData.camera : '0';
        let camera = 'camera_' + OfferItemData.itemType + '_' + cameraSuffix;
        let elModel = m_elScreen.FindChildInLayoutFile('id-offer-preview-panel');
        let slot = InventoryAPI.GetDefaultSlot(OfferItemData.itemId);
        let rotationDeg = slot === 'clothing_hands' ? 0 : 360;
        let rotationXAmount = slot === 'clothing_hands' ? 0 : 30;
        let rotationYAmount = slot === 'clothing_hands' ? 0 : 20;
        let rotationPeriod = slot === 'clothing_hands' ? 0 : 16;
        if (!elModel) {
            elModel = _MakeMapItemPreviewPanel("ui/xpshop_item", !(slot === 'clothing_hands'));
            m_elScreen.defaultfocus = 'id-offer-preview-panel';
        }
        m_elScreen.FindChildInLayoutFile('id-offer-camera-hints').visible = !(slot === 'clothing_hands');
        elModel.SetRotationLimits(rotationDeg, rotationDeg);
        elModel.SetAutoRotateAmount(rotationXAmount, rotationYAmount);
        elModel.SetAutoRotatePeriod(rotationPeriod, rotationPeriod);
        elModel.SetActiveItem(0);
        elModel.SetItemItemId(OfferItemData.itemId, '');
        elModel.SetCamera(camera);
        if (elModel.PanZoomEnabled()) {
            elModel.SetAcceptsFocus(true);
            elModel.ResetPanZoom();
            elModel.SetFocus();
        }
        m_elScreen.FindChildInLayoutFile('id-offer-preview-panel-container').SetHasClass('show', true);
        elModel.SetCSMSplitPlane0DistanceOverride(85.0);
        _UpdateModelData(OfferItemData);
    }
    function _UpdateModelData(OfferItemData) {
        let elParent = m_elScreen.FindChildInLayoutFile('id-offer-preview-panel-info');
        let setName = ItemInfo.GetSet(OfferItemData.itemId);
        DecodeText.Init(OfferItemData.itemName, elParent.FindChildInLayoutFile('id-offer-item-name-container'), 'window__weapon-info__name-letter');
        DecodeText.Init(OfferItemData.rarityName, elParent.FindChildInLayoutFile('id-offer-item-rarity-container'), 'window__weapon-info__name-letter');
        elParent.FindChildInLayoutFile('id-offer-item-rarity-container').style.backgroundColor = OfferItemData.rarityColor;
        _SetRarityColor(m_elScreen.FindChildInLayoutFile('id-offer-preview-glow'), OfferItemData.rarityColor);
        _SetRarityColor(m_elScreen.FindChildInLayoutFile('id-offer-preview-gradient'), OfferItemData.rarityColor);
        const certData = InventoryAPI.GetItemCertificateInfo(OfferItemData.itemId);
        const aCertData = certData.split("\n");
        let elCollectionImage = m_elScreen.FindChildInLayoutFile('id-offer-preview-collection-icon');
        elCollectionImage.itemid = OfferItemData.itemId;
        IconUtil.SetupFallbackItemSetIcon(elCollectionImage, setName);
        IconUtil.SetItemSetSVGImage(elCollectionImage, setName);
        for (let i = 0; i < aCertData.length - 1; i++) {
            if (i % 2 == 0) {
                if (i < 5) {
                    let elCertContainer = m_elScreen.FindChildInLayoutFile('id-offer-cert-info');
                    let elCertLine = elCertContainer.FindChildInLayoutFile('item-cert-' + i);
                    if (!elCertLine) {
                        elCertLine = $.CreatePanel('Panel', elCertContainer, 'item-cert-' + i);
                        elCertLine.BLoadLayoutSnippet('cert-row');
                    }
                    elCertLine.SetDialogVariable('cert_title', aCertData[i] + ' : ');
                    elCertLine.SetDialogVariable('cert_desc', aCertData[i + 1]);
                }
                if (i === 6) {
                    DecodeText.Init(aCertData[i + 1], (m_elScreen.FindChildInLayoutFile('id-weapon-wear-rating-container')), '');
                    const elPointer = m_elScreen.FindChildInLayoutFile('id-weapon-wear-rating-pointer');
                    const pointerOffset = (elPointer.actuallayoutwidth / 2) / elPointer.actualuiscale_x;
                    elPointer.style.transform = 'translateX(' + ((400 * (parseFloat(aCertData[i + 1]))) - pointerOffset) + 'px) translateY(2px) scaleY(-1)';
                }
                if (i === 8) {
                    DecodeText.Init(aCertData[i + 1], (m_elScreen.FindChildInLayoutFile('id-weapon-wear-name-container')), '');
                }
            }
        }
        m_elScreen.FindChildInLayoutFile('id-offer-preview-inspect-btn').SetPanelEvent('onactivate', () => {
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
            let oSettings = {
                item_id: OfferItemData.itemId,
                inspect_only: true,
                hide_all_action_items: true
            };
            elPanel.Data().oSettings = oSettings;
        });
        switch (OfferItemData.rarity) {
            case 3:
                OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Drop.Blue');
                break;
            case 4:
                OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Drop.Purple');
                break;
            case 5:
                OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Drop.Pink');
                break;
            case 6:
                OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Drop.Red');
                break;
        }
    }
    function _MakeMapItemPreviewPanel(mapName, isGloves) {
        return $.CreatePanel('MapItemPreviewPanel', m_elScreen.FindChildInLayoutFile('id-offer-preview-panel-container'), 'id-offer-preview-panel', {
            class: 'window__offer__preview-panel',
            "require-composition-layer": "true",
            'transparent-background': true,
            'disable-depth-of-field': true,
            camera: 'default',
            player: "false",
            map: mapName,
            initial_entity: 'item',
            active_item_idx: 0,
            mouse_rotate: "true",
            rotation_limit_x: "0",
            rotation_limit_y: "0",
            auto_rotate_x: "0",
            auto_rotate_y: "0",
            auto_rotate_period_x: "0",
            auto_rotate_period_y: "0",
            auto_recenter: true,
            panzoom_enabled: isGloves,
            tabindex: "auto",
            selectionpos: "auto",
            hittest: "true",
            hide_while_waiting_for_composite_materials: "false"
        });
    }
    let m_fingerPrintCount = 0;
    function _MakeFingerPrints(elPanel) {
        const mousePosition = $.MousePosition();
        const panelPosition = m_elScreen.FindChildInLayoutFile('id-laptop-finger-prints').GetPositionWithinWindow();
        panelPosition.x = panelPosition.x / m_elScreen.actualuiscale_x;
        panelPosition.y = panelPosition.y / m_elScreen.actualuiscale_y;
        mousePosition.x = mousePosition.x / m_elScreen.actualuiscale_x;
        mousePosition.y = mousePosition.y / m_elScreen.actualuiscale_y;
        const mouseInPanelPosition = { x: mousePosition.x - panelPosition.x, y: mousePosition.y - panelPosition.y };
        if (m_fingerPrintCount >= 40) {
            m_fingerPrintCount = 0;
        }
        let elImage = m_elScreen.FindChildInLayoutFile('id-laptop-finger-prints').FindChild('finger-' + m_fingerPrintCount);
        if (!elImage) {
            elImage = $.CreatePanel('Image', m_elScreen.FindChildInLayoutFile('id-laptop-finger-prints'), 'finger-' + m_fingerPrintCount, { hittest: 'false' });
            elImage.SetHasClass('finger-print', true);
            m_fingerPrintCount++;
            elImage.style.x = mouseInPanelPosition.x + 'px';
            elImage.style.y = mouseInPanelPosition.y + 'px';
            const rotate = _GetRandomIntInRange(-30, 25);
            const opacity = _GetRandomIntInRange(2, 5) / 100;
            elImage.style.transform = 'translateY(128px) translateX(-64px) rotateZ(' + rotate + 'deg);';
            elImage.style.opacity = opacity.toString();
        }
        else {
            elImage.style.x = mouseInPanelPosition.x + 'px';
            elImage.style.y = mouseInPanelPosition.y + 'px';
            const rotate = _GetRandomIntInRange(-30, 25);
            elImage.style.transform = 'translateY(128px) translateX(-64px) rotateZ(' + rotate + 'deg);';
        }
        m_fingerPrintCount++;
    }
    function _RollChance(chancePercent) {
        if (chancePercent <= 0)
            return false;
        if (chancePercent >= 100)
            return true;
        const roll = Math.random() * 100;
        return roll < chancePercent;
    }
    function _CollectionInfo() {
        const elCollectionImage = m_elScreen.FindChildInLayoutFile('id-offer-collection-icon');
        const collectionName = InventoryAPI.GetSet(InventoryAPI.GetLootListItemIdByIndex(m_idContainerItem, 0));
        m_elScreen.SetDialogVariable('collection-name', $.Localize('#CSGO_' + collectionName));
        IconUtil.SetupFallbackItemSetIcon(elCollectionImage, collectionName);
        IconUtil.SetItemSetSVGImage(elCollectionImage, collectionName);
    }
    function UpdateCollectionDots() {
        m_elScreen.FindChildInLayoutFile('id-offer-collection-progress').SetHasClass('show', true);
        const oHistoricData = InventoryAPI.GetCacheTypeElementJSOByIndex('VolatileItemOffer', InventoryAPI.GetCacheTypeElementIndexByKey('VolatileItemOffer', m_defidxContainerItem));
        let count = InventoryAPI.GetLootListItemsCount(m_idContainerItem);
        const elParent = m_elScreen.FindChildInLayoutFile('id-offer-lootlist-btn');
        elParent.SetPanelEvent('onactivate', () => {
            _MakeFingerPrints(m_elScreen);
            _XpCollectionPopup();
        });
        for (let i = 0; i < count; i++) {
            const itemId = InventoryAPI.GetLootListItemIdByIndex(m_idContainerItem, i);
            const rarityNum = InventoryAPI.GetItemRarity(itemId);
            let raritySection = elParent.FindChildInLayoutFile('rarity-btn-' + rarityNum);
            if (!raritySection) {
                raritySection = $.CreatePanel('Panel', elParent, 'rarity-btn-' + rarityNum, { class: 'offer-collection__lootlist' });
            }
            let elItem = raritySection.FindChildInLayoutFile(itemId);
            if (!elItem) {
                elItem = $.CreatePanel("Panel", raritySection, itemId);
                elItem.BLoadLayoutSnippet('offer-collection-item');
                _SetRarityColor(elItem, (rarityNum === 0) ? '#ffd700' : InventoryAPI.GetItemRarityColor(itemId));
            }
            const iidCheckHistoricData = (rarityNum === 0) ? InventoryAPI.GetFauxItemIDFromDefAndPaintIndexUB1(m_defidxContainerItem, 1, 3) : itemId;
            const bSeenInHistoricData = (oHistoricData && oHistoricData.faux_itemid.includes(iidCheckHistoricData)) ? true : false;
            if (m_initialDotsUpdateFinished && !elItem.BHasClass('seen') && bSeenInHistoricData) {
                elItem.SetHasClass('seen-anim', bSeenInHistoricData);
            }
            elItem.SetHasClass('seen', bSeenInHistoricData);
        }
        if (!m_initialDotsUpdateFinished) {
            m_initialDotsUpdateFinished = true;
        }
    }
    function _XpCollectionPopup() {
        m_elScreen.FindChildInLayoutFile('id-popup-in-screen').SetHasClass('show-lootlist', true);
        m_elScreen.FindChildInLayoutFile('id-close-popup-in-screen').SetPanelEvent('onactivate', () => CloseInScreenPopup('show-lootlist'));
        const oHistoricData = InventoryAPI.GetCacheTypeElementJSOByIndex('VolatileItemOffer', InventoryAPI.GetCacheTypeElementIndexByKey('VolatileItemOffer', m_defidxContainerItem));
        const oClaimedData = InventoryAPI.GetCacheTypeElementJSOByIndex('VolatileItemClaimedRewards', InventoryAPI.GetCacheTypeElementIndexByKey('VolatileItemClaimedRewards', m_defidxContainerItem));
        const elParent = m_elScreen.FindChildInLayoutFile('id-offer-xp-lootlist');
        let count = InventoryAPI.GetLootListItemsCount(m_idContainerItem);
        let iCurrentRarity = -1;
        let itemsInRarityTier = 0;
        let itemsSeenInRarityTier = 0;
        for (let i = 0; i < count; i++) {
            const itemId = InventoryAPI.GetLootListItemIdByIndex(m_idContainerItem, i);
            const rarityNum = InventoryAPI.GetItemRarity(itemId);
            let raritySection = elParent.FindChildInLayoutFile('rarity-' + rarityNum);
            if (!raritySection) {
                raritySection = $.CreatePanel('Panel', elParent, 'rarity-' + rarityNum);
                raritySection.BLoadLayoutSnippet('lootlist-section');
            }
            if (iCurrentRarity != rarityNum) {
                iCurrentRarity = rarityNum;
                itemsInRarityTier = 0;
                itemsSeenInRarityTier = 0;
                raritySection.SetDialogVariableInt('seen', 0);
            }
            let raritySectionList = raritySection.FindChild('id-lootlist-items');
            let elItem = elParent.FindChildInLayoutFile('item-xp-list-' + itemId);
            if (!elItem) {
                elItem = $.CreatePanel('Panel', raritySectionList, 'item-xp-list-' + itemId);
                elItem.BLoadLayoutSnippet('lootlist-xp-item');
                elItem.SetPanelEvent('onactivate', () => {
                    $.DispatchEvent("LootlistItemPreview", itemId, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(m_defidxContainerItem, 0) +
                        ',' + '');
                });
                elItem.enabled = rarityNum !== 0;
            }
            const iidCheckHistoricData = (rarityNum === 0) ? InventoryAPI.GetFauxItemIDFromDefAndPaintIndexUB1(m_defidxContainerItem, 1, 3) : itemId;
            const bSeenInHistoricData = (oHistoricData && oHistoricData.faux_itemid.includes(iidCheckHistoricData)) ? true : false;
            elItem.SetHasClass('seen', bSeenInHistoricData);
            if (bSeenInHistoricData) {
                raritySection.SetDialogVariableInt('seen', ++itemsSeenInRarityTier);
            }
            raritySection.SetDialogVariableInt('total', ++itemsInRarityTier);
            _SetRarityColor(elItem.FindChildInLayoutFile('id-lootlist-xp-rarity'), (rarityNum === 0) ? '#ffd700' : InventoryAPI.GetItemRarityColor(itemId));
            elItem.SetDialogVariable('loot-name', (rarityNum === 0) ? $.Localize(InventoryAPI.GetLootListUnusualItemName(m_idContainerItem)) : InventoryAPI.GetItemName(itemId));
            let btn = raritySection.FindChildInLayoutFile('id-lootlist-xp-claim');
            if (btn) {
                const iClaimRewardID = (rarityNum === 0) ? 99 : rarityNum;
                const bClaimed = (oClaimedData && oClaimedData.reward.includes(iClaimRewardID)) ? true : false;
                const bAllowClaimingXP = !bClaimed && (itemsSeenInRarityTier == itemsInRarityTier);
                btn.enabled = bAllowClaimingXP && (itemsSeenInRarityTier == itemsInRarityTier);
                btn.text = $.Localize(bClaimed ? '#popup_lootlist_claim_ok' : '#popup_lootlist_claim_xp', btn);
                btn.SetPanelEvent('onactivate', () => {
                    if (!bAllowClaimingXP)
                        return;
                    if (!FriendsListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid())) {
                        UiToolkitAPI.ShowCustomLayoutPopup('prime_status', 'file://{resources}/layout/popups/popup_prime_status.xml');
                        return;
                    }
                    if (FriendsListAPI.GetFriendLevel(MyPersonaAPI.GetXuid()) >= InventoryAPI.GetMaxLevel()) {
                        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                        let oSettings = {
                            item_id: '0',
                            show_work_type_warning: false,
                            work_type: 'prestigecheck'
                        };
                        elPanel.Data().oSettings = oSettings;
                        return;
                    }
                    if (m_tmsExpectingXpGrantNotification && (Date.now() - m_tmsExpectingXpGrantNotification < 1500))
                        return;
                    m_tmsExpectingXpGrantNotification = Date.now();
                    InventoryAPI.ClaimVolatileReward(m_defidxContainerItem, iClaimRewardID);
                    btn.enabled = false;
                    btn.text = $.Localize('#popup_lootlist_claim_ww', btn);
                });
            }
        }
    }
    async function _ShowMessageOfferLimit() {
        const elMessage = $.CreatePanel('Panel', m_elMessagesParent, '');
        elMessage.BLoadLayoutSnippet('interaction-offer-limit-message');
        elMessage.AddClass('show');
        const oSettings = {
            parentPanel: elMessage.FindChildInLayoutFile('id-interaction-list'),
            buttonClass: 'message-interaction__text-button',
            group: 'offer-limit-message',
            namePrefix: 'id-limit-message',
            isContextMenu: false
        };
        MakeOfferLimitRadioButton(oSettings);
        await Async.Delay(.1);
        m_elMessagesParent.ScrollToBottom();
        return elMessage;
    }
    function ShowOfferLimitPopup() {
        m_elScreen.FindChildInLayoutFile('id-popup-in-screen').SetHasClass('show-settings', true);
        m_elScreen.FindChildInLayoutFile('id-close-popup-in-screen').SetPanelEvent('onactivate', () => CloseInScreenPopup('show-settings'));
        const oSettings = {
            parentPanel: m_elScreen.FindChildInLayoutFile('id-offer-settings'),
            buttonClass: 'popup-offers-setting__text-button',
            group: 'offer-limit',
            namePrefix: 'id-limit-popup',
            isContextMenu: true
        };
        MakeOfferLimitRadioButton(oSettings);
    }
    function MakeOfferLimitRadioButton(oSetting) {
        let oLimits = JSON.parse(InventoryAPI.GetVolatileLimits());
        for (let i = 0; i < oLimits.choices.length; i++) {
            let elButton = oSetting.parentPanel.FindChild(oSetting.namePrefix + oLimits.choices[i].limit);
            if (!elButton) {
                elButton = $.CreatePanel('RadioButton', oSetting.parentPanel, oSetting.namePrefix + oLimits.choices[i].limit, {
                    class: oSetting.buttonClass,
                    group: 'offer-limit',
                    html: 'true',
                    text: '{s:setting-label}'
                });
                elButton.SetDialogVariable('limit-setting', oLimits.choices[i]?.label);
                const locString = (oLimits.choices[i].limit !== 0) ?
                    $.Localize(_RandomizeLocString('#user_message_limit_'), elButton) :
                    $.Localize(_RandomizeLocString('#user_message_limit_unlimited_'), elButton);
                elButton.SetDialogVariable('setting-label', locString);
                elButton.SetPanelEvent('onactivate', () => {
                    InventoryAPI.SetVolatileLimits(oLimits.choices[i].limit);
                    m_elScreen.SetDialogVariable('limit', GetLimitString(oLimits.choices[i]?.limit, oLimits.choices[i]?.label));
                    if (oSetting.isContextMenu) {
                        $.Schedule(.25, () => CloseInScreenPopup('show-settings'));
                        oSetting.parentPanel.Children().forEach(element => element.enabled = false);
                        ShowDealerOfferLimitAcknowledge();
                        return;
                    }
                    else {
                        oSetting.parentPanel.SetHasClass('hide', true);
                        _MakeMessage(systemOfferLimitSetWithBootstrapAction);
                    }
                });
            }
            if (oSetting.isContextMenu) {
                elButton.checked = ((oLimits.limit === oLimits.choices[i].limit) && oLimits.selected === true);
                elButton.enabled = !elButton.checked;
            }
        }
    }
    function CloseInScreenPopup(className) {
        OffersLaptop.LaptopSoundPlayOnce('UI.Laptop.Click');
        m_elScreen.FindChildInLayoutFile('id-popup-in-screen').SetHasClass(className, false);
    }
    function GetLimitString(nLimit, sLimitLabel) {
        return nLimit === 0 ? $.Localize(sLimitLabel) : sLimitLabel;
    }
})(CollectionOffers || (CollectionOffers = {}));
var DecodeText;
(function (DecodeText) {
    const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{};:,.<>/?';
    function Init(textString, elContainer, className, bHtml = false) {
        let aTextString = textString.split('');
        let aExistingLetter = elContainer.Children();
        let numExistingLetters = aExistingLetter.length;
        if (aTextString.length < numExistingLetters) {
            for (let i = aTextString.length; i < numExistingLetters; i++) {
                aExistingLetter[i].DeleteAsync(0);
            }
        }
        aTextString.forEach((letter, index) => {
            let elLetter = elContainer.FindChild('letter-' + index);
            if (!elLetter) {
                elLetter = $.CreatePanel('Label', elContainer, 'letter-' + index, {
                    class: className + ' stratum-regular-mono',
                    html: bHtml
                });
            }
        });
        let time = 0;
        let nDelay = .1;
        let textStringLength = aTextString.length;
        aTextString.forEach((letter, index) => {
            $.Schedule(time, () => {
                for (let i = index + 1; i < elContainer.Children().length; i++) {
                    let letterIndex = Math.floor(Math.random() * (0 - textStringLength) + textStringLength);
                    let randomLetter = charset[letterIndex];
                    elContainer.Children()[i].text = randomLetter;
                    elContainer.Children()[i].ToggleClass('show');
                }
                elContainer.Children()[index].text = letter;
                elContainer.Children()[index].SetHasClass('show', true);
            });
            time = time + nDelay;
        });
    }
    DecodeText.Init = Init;
})(DecodeText || (DecodeText = {}));
