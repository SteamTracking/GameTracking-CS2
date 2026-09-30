"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="common/sessionutil.ts" />
/// <reference path="itemtile_store.ts" />
$.LogChannel('p.rankup', "LV_OFF");
var RankUpRedemptionStore;
(function (RankUpRedemptionStore) {
    let m_redeemableBalance = 0;
    let m_timeStamp = -1;
    let m_timeoutScheduleHandle;
    let m_profileCustomizationHandler;
    let m_profileUpdateHandler;
    let m_registered = false;
    let m_schTimer;
    function RegisterForInventoryUpdate() {
        if (m_registered)
            return;
        m_registered = true;
        _UpdateStoreState();
        CheckForPopulateItems();
        m_profileUpdateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated);
        m_profileCustomizationHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', OnItemCustomization);
        $.GetContextPanel().RegisterForReadyEvents(true);
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), () => {
            $.Msg("[p.rankup] READY FOR DISPLAY");
            _UpdateStoreState();
            CheckForPopulateItems(true);
            if (!m_profileUpdateHandler) {
                m_profileUpdateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated);
            }
            if (!m_profileCustomizationHandler) {
                m_profileCustomizationHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', OnItemCustomization);
            }
        });
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), () => {
            $.Msg("[p.rankup] UN-READY FOR DISPLAY");
            if (m_schTimer) {
                $.CancelScheduled(m_schTimer);
                m_schTimer = null;
            }
            if (m_profileUpdateHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', m_profileUpdateHandler);
                m_profileUpdateHandler = null;
            }
            if (m_profileCustomizationHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', m_profileCustomizationHandler);
                m_profileCustomizationHandler = null;
            }
        });
    }
    ;
    function CheckForPopulateItems(bFirstTime = false, claimedItemId = '') {
        const objStore = GetPersonalStore();
        const genTime = objStore ? objStore.generation_time : 0;
        // PopulateItems item if we have a new store
        if (genTime != m_timeStamp || claimedItemId) {
            if (genTime != m_timeStamp) {
                m_timeStamp = genTime;
                GameInterfaceAPI.SetSettingString('cl_redemption_reset_timestamp', genTime);
            }
            PopulateItems(bFirstTime, claimedItemId);
        }
    }
    // The GC carries no per-item claim cost yet and its weekly rolls never include an egg, so this
    // names a store slot to charge two claims for whatever landed in it; -1 for none.
    const TEST_DOUBLE_CLAIM_COST_SLOT = -1;
    function _GetClaimCost(itemId, index) {
        // A placeholder tile has no item behind it to ask about.
        if (itemId !== '-' && InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'chicken_egg'))
            return 2;
        if (itemId !== '-' && InventoryAPI.DoesItemMatchDefinitionByName(itemId, 'chicken_feed'))
            return 2;
        return (index === TEST_DOUBLE_CLAIM_COST_SLOT) ? 2 : 1;
    }
    function _CreateItemPanel(itemId, index, bFirstTime, claimedItemId = '') {
        //- Means you don't have a store yet. so we need to make tiles with a ?
        // Users new to the system will get this state
        const bNoDropsEarned = itemId === '-';
        if (itemId !== '-' && (!InventoryAPI.IsItemInfoValid(itemId) || !InventoryAPI.IsValidItemID(itemId))) {
            $.Msg('[p.rankup] item ' + itemId + ' is invalid');
            return;
        }
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        let elGhostItem = elItemContainer.FindChildInLayoutFile('itemdrop-' + itemId);
        elGhostItem = $.CreatePanel('Panel', elItemContainer, 'itemdrop-' + index + '-' + itemId);
        elGhostItem.BLoadLayout('file://{resources}/layout/itemtile_store.xml', false, false);
        _AddTileToBlurPanel(elGhostItem);
        const oItemData = {
            id: itemId,
            isDropItem: true,
            noDropsEarned: bNoDropsEarned,
        };
        ItemTileStore.Init(elGhostItem, oItemData);
        elGhostItem.Data().itemid = itemId;
        elGhostItem.Data().cost = _GetClaimCost(itemId, index);
        elGhostItem.Data().index = index;
        // itemtile_store.css hangs the second claim circle and the cost warning off the class, and
        // the warning reads its count from the dialog variable.
        elGhostItem.SetHasClass('claim-cost-2', elGhostItem.Data().cost === 2);
        elGhostItem.SetDialogVariableInt('claim-cost', elGhostItem.Data().cost);
        if (bNoDropsEarned)
            return;
        _OnGhostItemActivate(elGhostItem, itemId);
    }
    function _AddTileToBlurPanel(elGhostItem) {
        let parent = elGhostItem.GetParent();
        let count = 0;
        while (parent) {
            if (parent.id === 'id-rewards-background') {
                let blurTarget = parent.FindChildInLayoutFile('id-rewards-background-blur');
                blurTarget.AddBlurPanel(elGhostItem);
                break;
            }
            if (count > 5)
                break;
            parent = parent.GetParent();
            count++;
        }
    }
    function _OnGhostItemActivate(elGhostItem, itemId) {
        if (!InventoryAPI.IsFauxItemID(itemId)) {
            // set the click action
            elGhostItem.SetPanelEvent('onactivate', () => _OnItemSelected(elGhostItem));
            // set the inspect button action
            const elInspect = elGhostItem.FindChildTraverse('id-itemtile-store-inspect-btn');
            const isVolatile = !!InventoryAPI.GetItemAttributeValue(itemId, '{uint32}volatile container');
            elInspect.SetPanelEvent('onactivate', () => {
                if (isVolatile) {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + itemId, 'file://{resources}/layout/popups/popup_offers_laptop.xml');
                    let oSettings = {
                        item_id: itemId,
                        inspect_only: true,
                        work_type: 'decodeable',
                        only_close_btn: true
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else if (ItemInfo.ItemHasCapability(itemId, 'decodable') && !InventoryAPI.IsTool(itemId)) {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + itemId, 'file://{resources}/layout/popups/popup_capability_decodable.xml');
                    let oSettings = {
                        item_id: itemId,
                        show_work_type_warning: false,
                        inspect_only: true,
                        work_type: 'decodeable',
                        only_close_btn: true
                    };
                    elPanel.Data().oSettings = oSettings;
                }
                else {
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
                    let oSettings = {
                        item_id: itemId,
                        inspect_only: true,
                        hide_all_action_items: true
                    };
                    elPanel.Data().oSettings = oSettings;
                }
            });
        }
    }
    function GetPersonalStore() {
        let oStore = InventoryAPI.GetCacheTypeElementJSOByIndex("PersonalStore", 0);
        return oStore;
    }
    function PopulateItems(bFirstTime = false, claimedItemId = '') {
        $.Msg('[p.rankup] PopulateItems');
        $.Msg('[p.rankup] claimedItemId:' + claimedItemId);
        const objStore = GetPersonalStore();
        $.GetContextPanel().RemoveClass('waiting');
        if (bFirstTime) {
            $.GetContextPanel().TriggerClass('reveal-store');
        }
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        // Save any selected items index so we can update them after we PopulateItems the items
        let aSelectedItems = [];
        elItemContainer.Children().forEach(element => {
            if (element.BHasClass('selected')) {
                aSelectedItems.push(element.Data().index);
            }
        });
        // Clear container
        elItemContainer.RemoveAndDeleteChildren();
        // Get ghost items and create panels
        const arrItemIds = objStore ? Object.values(objStore.items) : ['-', '-', '-', '-'];
        for (let i = 0; i < arrItemIds.length; i++) {
            _CreateItemPanel(arrItemIds[i], i, bFirstTime, claimedItemId);
        }
        _UpdateAllItemStyles();
        // If we claimed items the play an animation of the selected tiles
        elItemContainer.Children().forEach((element, idx) => {
            if (claimedItemId) {
                aSelectedItems.forEach(selectedIndex => {
                    if (idx === selectedIndex) {
                        element.TriggerClass('reveal-anim');
                        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_claim', '');
                    }
                });
            }
        });
    }
    function _UpdateTime() {
        let secRemaining = StoreAPI.GetSecondsUntilXpRollover();
        $.GetContextPanel().SetDialogVariable('time-to-week-rollover', (secRemaining > 0) ? FormatText.SecondsToSignificantTimeString(secRemaining) : '');
        const xpBonuses = MyPersonaAPI.GetActiveXpBonuses();
        const bEligibleForCarePackage = xpBonuses.split(',').includes('2');
        if (bEligibleForCarePackage) {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_refresh', $.GetContextPanel()));
        }
        else {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_rollover_wait', $.GetContextPanel()));
        }
        m_schTimer = $.Schedule(30, _UpdateTime);
    }
    function _UpdateStoreState() {
        const objStore = GetPersonalStore();
        m_redeemableBalance = objStore ? objStore.redeemable_balance : 0;
        $.Msg('[p.rankup] _UpdateStoreState: m_redeemableBalance = ' + m_redeemableBalance);
        const elClaimButton = $.GetContextPanel().FindChildTraverse('jsRrsClaimButton');
        elClaimButton.enabled = m_redeemableBalance !== 0;
        elClaimButton.SetHasClass('hide', m_redeemableBalance === 0);
        if (m_redeemableBalance <= 0) {
            _CloseStore(objStore ? true : false);
        }
        else {
            _EnableStore();
        }
        _SetXpProgress();
        _UpdateTime();
    }
    function OnItemCustomization(numericType, type, itemid) {
        $.Msg('[p.rankup] OnItemCustomization ' + numericType + ' ' + type + ' ' + itemid + ' m_redeemableBalance=' + m_redeemableBalance);
        if (type !== 'free_reward_redeemed')
            return;
        if (m_timeoutScheduleHandle) {
            $.CancelScheduled(m_timeoutScheduleHandle);
            m_timeoutScheduleHandle = null;
        }
        // Because the reward was redeemed, we need to update the redeemable balance (it went down, OnInventoryUpdated is a delayed notification)
        const objStore = GetPersonalStore();
        m_redeemableBalance = objStore ? objStore.redeemable_balance : 0;
        $.Msg('[p.rankup] OnItemCustomization: m_redeemableBalance = ' + m_redeemableBalance);
        CheckForPopulateItems(false, itemid);
        // If we claimed an egg, then go to the home screen and zoom into the egg to complete the entire experience
        if (ItemInfo.IsPet(itemid)) {
            let myContextPanel = $.GetContextPanel(); // make sure it's "captured" because we'll bind this script callback to outside panels
            function DiscoverPanels() {
                if (!myContextPanel || !myContextPanel.IsValid())
                    return [];
                let elMainMenu = myContextPanel.Data().elMainMenu;
                let elPopupRoot = myContextPanel;
                if (!elMainMenu) {
                    elMainMenu = myContextPanel;
                    for (;;) {
                        let elParent = elMainMenu.GetParent();
                        if (elParent && elParent.IsValid()) {
                            if (elParent.Data().elMainMenu) {
                                elMainMenu = elParent.Data().elMainMenu;
                                elPopupRoot = elParent;
                                break;
                            }
                            elMainMenu = elParent;
                            if (elMainMenu.id === 'MainMenu')
                                break;
                        }
                        else
                            break;
                    }
                }
                if (!elMainMenu) {
                    $.Msg('[p.rankup] /PET CLAIMED/ Failed to find main menu panel');
                    return [];
                }
                // To fake a click on the Main Menu Home button --
                let btnHome = elMainMenu.FindChildInLayoutFile('MainMenuNavBarHome');
                if (!btnHome) {
                    $.Msg('[p.rankup] /PET CLAIMED/ Failed to find main menu MainMenuNavBarHome');
                    return [];
                }
                let elPetInfoPanel = elMainMenu.FindChildInLayoutFile('id-mainmenu-pet-info');
                let elZoomInBtn = elPetInfoPanel ? elPetInfoPanel.FindChildInLayoutFile('id-zoom-in-pet') : undefined;
                // allow elZoomBtn to be undefined for now (maybe main menu will re-discover the pet/egg shortly)
                let elCloseBtn = (elPopupRoot && (elPopupRoot != myContextPanel))
                    ? elPopupRoot.FindChildInLayoutFile('PopupRankUpRedemptionStoreClose')
                    : undefined;
                return [btnHome, elZoomInBtn, elPopupRoot, elCloseBtn];
            }
            function ClickToMainMenuAndZoomIn(arrParamPanels) {
                if (!SessionUtil.BCanUseMyPetInCurrentLobby())
                    return; // safety-check, if the user is still a client or rejoined quickly then just skip the animations
                let arrPanels = arrParamPanels ?? DiscoverPanels();
                if (arrPanels.length == 4 && arrPanels[0] && arrPanels[1]) {
                    // Click all the buttons
                    $.Msg('[p.rankup] /PET CLAIMED/ Activating main menu MainMenuNavBarHome');
                    $.DispatchEvent("Activated", arrPanels[0], "mouse");
                    // Action to fake clicking the "zoom in" button on the pet action panel
                    $.Msg('[p.rankup] /PET CLAIMED/ Activating vanity id-zoom-in-pet');
                    $.DispatchEvent("Activated", arrPanels[1], "mouse");
                    if (myContextPanel.Data().schPendingZoom) {
                        $.CancelScheduled(myContextPanel.Data().schPendingZoom);
                        delete myContextPanel.Data().schPendingZoom;
                    }
                }
            }
            //
            // If the user very quickly goes and clicks the "CLOSE" button in the popup,
            // then we want to run all the egg-zooming code too
            //
            {
                let arrPanels = DiscoverPanels();
                if (arrPanels.length == 4 && arrPanels[2] && arrPanels[3]) {
                    arrPanels[2].Data().fnPopupRankUpRedemptionStoreOnClose = ClickToMainMenuAndZoomIn.bind(null);
                }
                // If the user is a client and cannot access pet actions/zoom in the current lobby then
                // just exit the lobby so that we could complete UI/UX animations correctly
                if (!SessionUtil.BCanUseMyPetInCurrentLobby()) {
                    LobbyAPI.CloseSession();
                }
            }
            //
            // Automatically schedule to go to main menu and zoom in on your newly acquired egg
            //
            myContextPanel.Data().schPendingZoom = $.Schedule(2.0, () => {
                let arrPanels = DiscoverPanels();
                if (arrPanels.length == 4 && arrPanels[2] && arrPanels[3]) {
                    $.DispatchEvent("Activated", arrPanels[3], "mouse"); // clicking the "CLOSE" in the popup will execute our callback
                }
                else {
                    ClickToMainMenuAndZoomIn(arrPanels); // otherwise this is not a popup, so we are responsible for all the clicking
                }
            });
        }
    }
    function OnInventoryUpdated() {
        // We always update the other information when ever your inventory state changes
        _UpdateStoreState();
        $.Msg('[p.rankup] OnInventoryUpdated ');
        // We only need to PopulateItems the store when we have new store items to show or you claimed items
        CheckForPopulateItems();
    }
    function _GetSelectedItems() {
        let arrItems = [];
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let panel of elItemContainer.Children()) {
            if (panel.BHasClass('selected')) {
                arrItems.push({ item_id: panel.Data().itemid, cost: panel.Data().cost });
            }
        }
        return arrItems;
    }
    function _CalcPendingBalance() {
        return _GetSelectedItems().reduce((sum, item) => sum + item.cost, 0);
    }
    function _OnItemSelected(elPanel) {
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        let aItemIds = _GetSelectedItems();
        $.Msg("[p.rankup] nPendingBalance: " + _CalcPendingBalance());
        $.Msg("[p.rankup] elPanel.Data().cost: " + elPanel.Data().cost);
        $.Msg("[p.rankup] elPanel.Data().itemid: " + elPanel.Data().itemid);
        // can afford
        if ((_CalcPendingBalance() + elPanel.Data().cost) <= m_redeemableBalance) {
            // toggle the selection
            elPanel.SetHasClass('selected', !elPanel.BHasClass('selected'));
            if (!elPanel.BHasClass('selected')) {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_select', 'MOUSE');
            }
            else {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_deselect', 'MOUSE');
            }
        }
        else {
            if (aItemIds.find(element => element.item_id === elPanel.Data().itemid)) {
                elPanel.SetHasClass('selected', !elPanel.BHasClass('selected'));
                if (!elPanel.BHasClass('selected')) {
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_select', 'MOUSE');
                }
                else {
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_deselect', 'MOUSE');
                }
            }
        }
        // pulse the selected
        for (let element of elItemContainer.Children()) {
            const bCantAffordClicked = !elPanel.BHasClass('selected') && _CalcPendingBalance() + elPanel.Data().cost > m_redeemableBalance;
            if (bCantAffordClicked) {
                if (element.BHasClass('selected')) {
                    element.TriggerClass('pulse-me');
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
                }
            }
        }
        _UpdateAllItemStyles();
    }
    function _UpdateAllItemStyles() {
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        // mark cant-afford
        for (let element of elItemContainer.Children()) {
            const bCantAfford = !element.BHasClass('selected') && !element.BHasClass('item-claimed') && _CalcPendingBalance() + element.Data().cost > m_redeemableBalance;
            element.SetHasClass('cant-afford', bCantAfford);
            element.SetHasClass('disabled', bCantAfford || element.BHasClass('item-claimed'));
        }
    }
    function _CloseStore(bHasStore) {
        // show 'Come Back Next Level to claim future rewards'
        _EnableDisableStorePanels(false);
        $.GetContextPanel().AddClass('store-closed');
        if (bHasStore) {
            $.GetContextPanel().SetDialogVariable('frame-badge-text', $.Localize('#rankup_redemption_store_closed', $.GetContextPanel()));
        }
        else {
            $.GetContextPanel().SetDialogVariable('frame-badge-text', $.Localize('#rankup_redemption_store_earn_xp', $.GetContextPanel()));
        }
    }
    function _EnableStore() {
        $.Msg('[p.rankup] _EnableStore ');
        $.GetContextPanel().RemoveClass('waiting');
        $.GetContextPanel().RemoveClass('store-closed');
        $.GetContextPanel().SetDialogVariableInt('redeemable_balance', m_redeemableBalance);
        $.GetContextPanel().SetDialogVariable('frame-badge-text', $.Localize('#rankup_redemption_store_directive', $.GetContextPanel()));
        _EnableDisableStorePanels(true);
    }
    // we disable the store if it's closed, and also if we're between redemption action and response from server
    function _EnableDisableStorePanels(enableStore) {
        $.Msg('[p.rankup] _enableStore ' + enableStore);
        //disable input on all items
        $.GetContextPanel().Children().forEach(elPanel => {
            elPanel.enabled = enableStore;
        });
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let panel of elItemContainer.Children()) {
            panel.hittest = enableStore;
            panel.hittestchildren = enableStore;
        }
    }
    function _PulseItems() {
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let panel of elItemContainer.Children()) {
            if (!panel.BHasClass('item-claimed')) {
                panel.TriggerClass('pulse-me');
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
            }
        }
    }
    function OnRedeem() {
        const numSelected = _GetSelectedItems().length;
        if (numSelected === 0) {
            _PulseItems();
            return;
        }
        InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'only_econ_items', '', '');
        if (InventoryAPI.GetInventoryCount() + numSelected > ItemInfo.NUM_BACKPACK_SLOTS) {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#popup_casket_title_error_casket_inv_full'), $.Localize('#SFUI_InventoryFull_Error'), '', () => { });
            return;
        }
        let szItemList = _GetSelectedItems().map(item => item.item_id).join(',');
        StoreAPI.StoreRedeemFreeRewards(szItemList);
        $.GetContextPanel().AddClass('waiting');
        _EnableDisableStorePanels(true);
        m_timeoutScheduleHandle = $.Schedule(10, _RedemptionTimedOut);
    }
    RankUpRedemptionStore.OnRedeem = OnRedeem;
    function _RedemptionTimedOut() {
        m_timeoutScheduleHandle = null;
        UiToolkitAPI.ShowGenericPopup($.Localize('#rankup_redemption_store_timeout_title'), $.Localize('#rankup_redemption_store_timeout_desc'), '');
        _EnableStore();
    }
    function _SetXpProgress() {
        const currentPoints = FriendsListAPI.GetFriendXp(MyPersonaAPI.GetXuid());
        const pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
        let elXpBarInner = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpBarInner');
        let percentComplete = (currentPoints / pointsPerLevel) * 100;
        elXpBarInner.style.width = percentComplete + '%';
        elXpBarInner.GetParent().visible = true;
        const xpBonuses = MyPersonaAPI.GetActiveXpBonuses();
        const bEligibleForCarePackage = xpBonuses.split(',').includes('2');
        $.GetContextPanel().SetHasClass('care-package-eligible', bEligibleForCarePackage);
        const currentLvl = FriendsListAPI.GetFriendLevel(MyPersonaAPI.GetXuid());
        let elRankIcon = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpIcon');
        elRankIcon.SetImage('file://{images}/icons/xp/level' + currentLvl + '.png');
        if (bEligibleForCarePackage) {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_refresh', $.GetContextPanel()));
        }
        else {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_rollover_wait', $.GetContextPanel()));
        }
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        $.GetContextPanel().RegisterForReadyEvents(true);
        RegisterForInventoryUpdate();
    }
})(RankUpRedemptionStore || (RankUpRedemptionStore = {}));
