"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/licenseutil.ts" />
/// <reference path="../common/eventutil.ts" />
/// <reference path="../common/store_items.ts" />
/// <reference path="../common/shopping_cart.ts" />
/// <reference path="../common/add_major_tokens_anim.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
/// <reference path="../popups/popup_acknowledge_item.ts" />
/// <reference path="../itemtile_store.ts" />
/// <reference path="../common/unique_random_number.ts"/>
/// <reference path="../common/major_store_prices.ts" />
var PopupMajorStore;
(function (PopupMajorStore) {
    const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
    const defidxKeyChainItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('keychain');
    function State(cp) {
        return cp.Data();
    }
    function _EffectivePrice(item) {
        return MajorStorePrices.GetEffectivePrice(item);
    }
    function _CompareById(a, b) {
        const aId = a.rawId ?? a.kc_highlight ?? a.itemId;
        const bId = b.rawId ?? b.kc_highlight ?? b.itemId;
        return aId < bId ? -1 : (aId > bId ? 1 : 0);
    }
    const NAV_TAB_NONE = '';
    const VIEW_TEAMS = 'id-major-store-teams';
    const VIEW_LIST = 'id-major-store-list';
    const VIEW_TEAM = 'id-major-store-team';
    const VIEW_CHARMS = 'id-major-store-keychains';
    const SNIPPET_STICKER_TILE = 'sticker-tile';
    const SNIPPET_KEYCHAIN_TILE = 'keychain-tile';
    const TEAM_GRID_RARITIES = [6, 5, 4, 3];
    const FEATURED_TEAM_COUNT = 10;
    const FEATURED_PAGE_COUNT = 15;
    const SORT_OPTIONS = {
        'price-high-low': (a, b) => _EffectivePrice(b) - _EffectivePrice(a),
        'price-low-high': (a, b) => _EffectivePrice(a) - _EffectivePrice(b),
        'name': (a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
    };
    const SORT_DEFAULT = 'price-high-low';
    const SEARCH_DEBOUNCE_HANDLE = 'textDebounceTimeoutHandle';
    let m_activeMain = null;
    let m_activeTabKey = '';
    const m_overlayStack = [];
    let m_aTeamGridCells = [];
    let m_aTeamGridLines = [];
    let m_bSyncingNavTabs = false;
    const STORE_NAV_TABS = [
        {
            key: 'team',
            btnId: 'id-major-store-nav-team',
            isAvailable: () => true,
            show: (cp) => _ShowMainPanel(cp, VIEW_TEAMS),
        },
        {
            key: 'event',
            btnId: 'id-major-store-nav-event',
            isAvailable: (cp) => State(cp).aFlatStickersData.some(s => s.isOrg),
            show: (cp) => _ShowList(cp, _EventListSource(cp)),
        },
        {
            key: 'charms',
            btnId: 'id-major-store-nav-charms',
            isAvailable: (cp) => State(cp).aFlatKeyChainData.length > 1,
            show: (cp) => _ShowMainPanel(cp, VIEW_CHARMS),
        },
    ];
    const STORE_VIEWS = [
        {
            id: VIEW_TEAMS,
            onShow: (cp) => _SetUpTeamsHome(cp),
            onRefresh: (cp) => _SetUpTeamsHome(cp),
        },
        {
            id: VIEW_LIST,
            rebuildIfActive: true,
            onShow: (cp) => _UpdateItemsList(cp, false),
            onRefresh: (cp, bDisableScroll) => _UpdateItemsList(cp, bDisableScroll),
        },
        {
            id: VIEW_TEAM,
            onShow: (cp) => _BuildTeamGrid(cp),
            onRefresh: (cp) => _RefreshTeamGrid(cp),
        },
        {
            id: VIEW_CHARMS,
            onShow: (cp) => _SetUpKeyChainsPage(cp),
            onRefresh: (cp) => _SetUpKeyChainsPage(cp),
        },
    ];
    function ClosePopup() {
        const cp = $.GetContextPanel();
        cp.SetReadyForDisplay(false);
        CancelRefreshSubscription(cp);
        const state = State(cp);
        const loadHandle = state.loadDataTimeoutHandler;
        if (loadHandle) {
            $.CancelScheduled(loadHandle);
            state.loadDataTimeoutHandler = null;
        }
        if (jsTooltipDelayHandle) {
            $.CancelScheduled(jsTooltipDelayHandle);
            jsTooltipDelayHandle = null;
        }
        const searchHandle = cp.Data()[SEARCH_DEBOUNCE_HANDLE];
        if (searchHandle) {
            $.CancelScheduled(searchHandle);
            cp.Data()[SEARCH_DEBOUNCE_HANDLE] = null;
        }
        if (state.jsCallbackHandles) {
            state.jsCallbackHandles.forEach((h) => UiToolkitAPI.UnregisterJSCallback(h));
            state.jsCallbackHandles = [];
        }
        UiToolkitAPI.HideTextTooltip();
        UiToolkitAPI.HideTitleTextTooltip();
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('ContextMenuEvent', '');
    }
    PopupMajorStore.ClosePopup = ClosePopup;
    function _TrackJSCallback(cp, handle) {
        if (!State(cp).jsCallbackHandles)
            State(cp).jsCallbackHandles = [];
        State(cp).jsCallbackHandles.push(handle);
        return handle;
    }
    function ReadyForDisplay() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        let eventId = g_ActiveTournamentInfo.eventid ? g_ActiveTournamentInfo.eventid : -1;
        if (eventId < 0) {
            ClosePopup();
            return;
        }
        const cp = $.GetContextPanel();
        State(cp).aFlatStickersData = [];
        State(cp).aFlatKeyChainData = [];
        State(cp).searchCache = null;
        _SubscribeForAllTournamentItems();
    }
    function Init() {
        let cp = $.GetContextPanel();
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        let eventId = g_ActiveTournamentInfo.eventid ? g_ActiveTournamentInfo.eventid : -1;
        if (eventId < 0) {
            ClosePopup();
            return;
        }
        cp.FindChildInLayoutFile('id-major-store-container').style.backgroundImage =
            'url( "file://{images}/tournaments/backgrounds/pickem_bg_' + eventId + '.psd" )';
        State(cp).arrAwaitingPricesheets = [];
        if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, g_ActiveTournamentInfo.stickerids[0])))
            State(cp).arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_dynamic_stickers);
        if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, g_ActiveTournamentDynamicSouvenirFaux))
            State(cp).arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_dynamic_souvenirs);
        let nStickerIdChampion = 0;
        g_ActiveTournamentTeams.forEach((tt) => {
            tt.champions.forEach((tcp) => {
                if (tcp.stickerids.length > 0)
                    nStickerIdChampion = tcp.stickerids[0];
            });
        });
        if (nStickerIdChampion && !MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, nStickerIdChampion)))
            State(cp).arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_champion_stickers);
        g_ActiveTournamentHighlights.forEach((thg) => {
            if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxKeyChainItem, thg.highlights[0].kc_highlight)))
                State(cp).arrAwaitingPricesheets.push(thg.itemid_dynamic_shop);
        });
        if (!State(cp).loadDataTimeoutHandler && (State(cp).arrAwaitingPricesheets.length > 0)) {
            $.GetContextPanel().SetHasClass('data-loading', true);
            _PushOverlay(cp, 'id-major-store-loading');
            State(cp).loadDataTimeoutHandler = $.Schedule(5, () => {
                UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => $.DispatchEvent('HideContentPanel'));
                ClosePopup();
            });
            return;
        }
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-loading'));
        cp.FindChildInLayoutFile('id-major-store-container-inner').AddClass('show');
        _UpdateStickerData(cp);
        _UpdateKeyChainsData(cp);
        _SetUpTitleBar(cp, eventId);
        _SetUpTeamsBanner(cp);
        _VariousButtonActionsAndEvents(cp);
        _SetUpStoreNavTabs(cp);
        if (!State(cp).aFeaturedPicks || State(cp).aFeaturedPicks.length < 1)
            State(cp).aFeaturedPicks = _PickFeatured();
        _ShowTab(cp, 'team');
        _UpdateBalance(cp);
        ShoppingCart.cart.subscribeToUpdates(cp, 'cart-counter', () => {
            const numItems = ShoppingCart.cart.getTotalItems();
            cp.SetDialogVariableInt('cart-count', numItems);
            cp.SetDialogVariableInt('cart-value', ShoppingCart.cart.getTotalPrice());
            cp.FindChildInLayoutFile('id-major-store-cart-info').SetHasClass('show', numItems > 0);
            cp.FindChildInLayoutFile('id-major-store-cart-info').TriggerClass('update-count');
        });
    }
    PopupMajorStore.Init = Init;
    function OnVolatileShopSubscribe(nContainerDef, bNewPricesParsed, cp) {
        const loadHandle = State(cp).loadDataTimeoutHandler;
        if (loadHandle) {
            const state = State(cp);
            state.arrAwaitingPricesheets = state.arrAwaitingPricesheets.filter((xx) => xx != nContainerDef);
            if (state.arrAwaitingPricesheets.length > 0) {
                return;
            }
            $.CancelScheduled(loadHandle);
            state.loadDataTimeoutHandler = null;
            _PopOverlay();
            Init();
            return;
        }
        RefreshSubscription(cp);
        if (bNewPricesParsed) {
            if (nContainerDef == g_ActiveTournamentInfo.itemid_dynamic_stickers ||
                nContainerDef == g_ActiveTournamentInfo.itemid_dynamic_souvenirs ||
                nContainerDef == g_ActiveTournamentInfo.itemid_champion_stickers) {
                _UpdateStickerData(cp);
            }
            else if (g_ActiveTournamentDynamicContainers.includes(nContainerDef)) {
                _UpdateKeyChainsData(cp);
            }
            _UpdateVisiblePanel(cp, true);
            ShoppingCart.cart.syncPrices((itemId) => {
                const item = _FindItemById(cp, itemId);
                return item ? _EffectivePrice(item) : undefined;
            });
        }
    }
    function _FindItemById(cp, itemId) {
        const state = State(cp);
        return state.aFlatStickersData.find(i => i.itemId === itemId)
            ?? state.aFlatKeyChainData.find(i => i.itemId === itemId);
    }
    function _UpdateVisiblePanel(cp, bDisableScroll = false) {
        _ActiveView()?.onRefresh?.(cp, bDisableScroll);
    }
    function _SubscribeForAllTournamentItems() {
        g_ActiveTournamentDynamicContainers.forEach((id) => StoreAPI.VolatileShopSubscribe(id, true));
    }
    function RefreshSubscription(cp) {
        if (!cp || !cp.IsValid())
            return;
        CancelRefreshSubscription(cp);
        _SubscribeForAllTournamentItems();
        State(cp).refreshSubscriptionHandle = $.Schedule(150, () => RefreshSubscription(cp));
    }
    PopupMajorStore.RefreshSubscription = RefreshSubscription;
    function CancelRefreshSubscription(cp) {
        const handle = State(cp).refreshSubscriptionHandle;
        if (handle) {
            $.CancelScheduled(handle);
            State(cp).refreshSubscriptionHandle = null;
        }
    }
    PopupMajorStore.CancelRefreshSubscription = CancelRefreshSubscription;
    function _UpdateStickerData(cp) {
        _BuildStickerData(State(cp).aFlatStickersData);
        State(cp).searchCache = null;
    }
    function _BuildStickerData(target) {
        const map = MapDataById(target);
        const add = (oData) => _UpdateWithCurrentData(target, map.get(oData.rawId), oData, _GetStickerData);
        g_ActiveTournamentTeams.forEach(team => {
            team.stickerids.forEach(id => add({ rawId: id, isPlayer: false, isOrg: false, teamId: team.teamid, team: team.team, isChampion: false }));
            team.players.forEach(player => player.stickerids.forEach(id => add({ rawId: id, isPlayer: true, isOrg: false, teamId: team.teamid, team: team.team, playerCode: player.code, playerNick: player.nick, isChampion: false })));
            team.champions.forEach(player => player.stickerids.forEach(id => add({ rawId: id, isPlayer: true, isOrg: false, teamId: team.teamid, team: team.team, playerCode: player.code, playerNick: player.nick, isChampion: true })));
        });
        g_ActiveTournamentInfo.stickerids.forEach(id => add({ rawId: id, isPlayer: false, isOrg: true, playerCode: g_ActiveTournamentInfo.location + ' ' + g_ActiveTournamentInfo.organization }));
    }
    function _UpdateKeyChainsData(cp) {
        const highlights = g_ActiveTournamentHighlights;
        const mapKeyChains = MapDataById(State(cp).aFlatKeyChainData);
        State(cp).searchCache = null;
        highlights.forEach(group => {
            group.highlights.forEach(kc => {
                const oData = {
                    group_id: group.group_id,
                    itemid_dynamic_shop: group.itemid_dynamic_shop,
                    stage: group.stage,
                    kc_highlight: kc.kc_highlight,
                    teamid1: kc.teamid1,
                    teamid2: kc.teamid2,
                    map_name: kc.map_name,
                    name: kc.title,
                    desc: kc.desc,
                };
                _UpdateWithCurrentData(State(cp).aFlatKeyChainData, mapKeyChains.get(kc.kc_highlight), oData, _GetKeyChainData);
            });
        });
    }
    function MapDataById(savedFlatData) {
        const oldStickersData = new Map();
        if (savedFlatData && savedFlatData.length > 0) {
            for (let i = 0; i < savedFlatData.length; i++) {
                oldStickersData.set(('rawId' in savedFlatData[i]) ? savedFlatData[i].rawId : savedFlatData[i].kc_highlight, savedFlatData[i]);
            }
        }
        return oldStickersData;
    }
    function _UpdateWithCurrentData(aFlatStoredData, savedItemData, oData, _funcGetData) {
        if (!savedItemData) {
            savedItemData = _funcGetData(oData);
            aFlatStoredData.push(savedItemData);
        }
        _ApplyPriceData(savedItemData);
    }
    function _ApplyPriceData(item) {
        Object.assign(item, MajorStorePrices.GetItemPrice(item.itemId));
    }
    function _GetStickerData(oData) {
        const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, oData.rawId);
        const numRarity = InventoryAPI.GetItemRarity(itemId);
        return {
            isPlayer: oData.isPlayer,
            isOrg: ('isOrg' in oData) ? oData.isOrg : false,
            rawId: oData.rawId,
            teamName: $.Localize('#CSGO_TeamID_' + oData.teamId),
            teamId: oData.teamId,
            teamTag: oData.team,
            playerCode: ('playerCode' in oData) ? oData.playerCode : '',
            playerNick: ('playerNick' in oData) ? oData.playerNick : '',
            realName: oData.isPlayer ? $.Localize('#SFUI_ProPlayer_' + oData.playerCode) : '',
            itemId: itemId,
            rarity: numRarity,
            rarityLookup: $.Localize('#major_store_filter_type_' + numRarity),
            name: InventoryAPI.GetItemName(itemId),
            displayName: ItemInfo.GetFormattedName(itemId),
            champion: oData.isChampion,
        };
    }
    function _GetKeyChainData(oData) {
        const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxKeyChainItem, oData.kc_highlight);
        return {
            group_id: oData.group_id,
            itemid_dynamic_shop: oData.itemid_dynamic_shop,
            kc_highlight: oData.kc_highlight,
            displayName: ItemInfo.GetFormattedName(itemId),
            stage: oData.stage,
            teamid1: oData.teamid1,
            teamid2: oData.teamid2,
            map_name: oData.map_name,
            desc: $.Localize(oData.desc),
            itemId: itemId,
            name: $.Localize(oData.name),
        };
    }
    function UnreadyForDisplay() {
    }
    function _VariousButtonActionsAndEvents(cp) {
        const elSortDropDown = _SortDropDown(cp);
        elSortDropDown.SetSelected(SORT_DEFAULT);
        elSortDropDown.SetPanelEvent('oninputsubmit', () => _UpdateItemsList(cp, false));
        cp.FindChildInLayoutFile('id-search-filter-all').checked = true;
        cp.FindChildInLayoutFile('id-major-store-filter-pills').Children().forEach(btn => btn.SetPanelEvent('onactivate', () => _UpdateItemsList(cp, false)));
        cp.FindChildInLayoutFile('id-popup-major-store-back-btn').SetPanelEvent('onactivate', () => _GoBack(cp));
        cp.FindChildInLayoutFile('id-major-store-balance').SetPanelEvent('onmouseover', () => {
            cp.FindChildInLayoutFile('id-major-store-balance').SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, 100, ''));
            const tooltip = $.Localize('#major_store_balance_tooltip' + (g_ActiveTournamentInfo.pp_fixed_prices ? '_fx' : ''), cp.FindChildInLayoutFile('id-major-store-balance'));
            UiToolkitAPI.ShowTitleTextTooltip('id-major-store-balance', '#CSGO_TournamentPass_' + g_ActiveTournamentInfo.location + '_credits', tooltip);
        });
        cp.FindChildInLayoutFile('id-major-store-balance').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTitleTextTooltip();
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-receipt', '#major_store_balance_receipt' + (g_ActiveTournamentInfo.pp_fixed_prices ? '_fx' : ''));
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser("https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/my/gcpd/" + SteamOverlayAPI.GetAppID() + "/?tab=creditsaudit");
        });
        function _Callback() {
            _UpdateBalance(cp);
        }
        ;
        const callback = _TrackJSCallback(cp, UiToolkitAPI.RegisterJSCallback(_Callback));
        cp.FindChildInLayoutFile('id-major-store-cart-btn').SetPanelEvent('onactivate', () => {
            $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.loadout_sector_select", "MOUSE");
            const popupPanel = UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-shopping-cart-checkout', 'file://{resources}/layout/popups/popup_shopping_cart_checkout.xml', '&callback=' + callback);
            popupPanel.Data().eventId = g_ActiveTournamentInfo.eventid;
        });
        cp.FindChildInLayoutFile('id-major-store-cart-btn').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-cart-btn', '#major_store_checkout_empty_desc');
        });
        cp.FindChildInLayoutFile('id-major-store-cart-btn').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        elSearchBox.SetPanelEvent('ontextentrychange', () => {
            _Debounce(cp, SEARCH_DEBOUNCE_HANDLE, .3, () => _OnSearchTextChanged(cp));
        });
        elSearchBox.SetPanelEvent('ontextentrysubmit', () => _OnSearchTextChanged(cp));
        cp.FindChildInLayoutFile('id-major-store-list-page').SetAcceptsFocus(true);
        cp.FindChildInLayoutFile('id-major-store-container').SetPanelEvent('onactivate', () => _CloseSortDropDown(cp));
        AddMajorTokensAnim.SetTransitionEndEvent(cp.FindChildInLayoutFile('id-major-store-add-tokens'));
    }
    function _CloseSortDropDown(cp) {
        const elMenu = _SortDropDown(cp).AccessDropDownMenu();
        if (!elMenu || !elMenu.visible) {
            return;
        }
        cp.FindChildInLayoutFile('id-major-store-list-page').SetFocus();
    }
    function _SortDropDown(cp) {
        return cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
    }
    function _SetUpTitleBar(cp, eventId) {
        cp.SetDialogVariable('tournament_name', $.Localize('#CSGO_Tournament_Event_NameShort_' + eventId));
        cp.FindChildInLayoutFile('id-major-store-major-logo').SetImage('file://{images}/tournaments/backgrounds/pickem_mainmenu_promo_' + eventId + '.psd');
    }
    function _SetUpTeamsHome(cp) {
        _UpdateSaleBanner(cp);
        _SetUpFeaturedCarousel(cp);
    }
    function _UpdateSaleBanner(cp) {
        const maxDiscount = Math.max(0, ...State(cp).aFlatStickersData.map(s => s.discountPct ?? 0));
        const elBanner = cp.FindChildInLayoutFile('id-major-store-sale-banner');
        elBanner.SetDialogVariableInt('discount', maxDiscount);
        elBanner.visible = maxDiscount > 0;
    }
    function _SetUpTeamsBanner(cp) {
        const teams = g_ActiveTournamentTeams;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-teams');
        const R2_X = 0.7548777;
        const R2_Y = 0.5698403;
        const startX = Math.random();
        const startY = Math.random();
        teams.forEach((team, i) => {
            const elPanel = $.CreatePanel('Button', elParent, '');
            elPanel.BLoadLayoutSnippet('banner-team-box');
            const szLogo = 'file://{images}/tournaments/teams/' + team.team + '.svg';
            elPanel.FindChildInLayoutFile('id-team-icon').SetImage(szLogo);
            elPanel.FindChildInLayoutFile('id-team-icon-blur').style.backgroundImage = 'url( "' + szLogo + '" )';
            elPanel.SetDialogVariable('name', $.Localize('#CSGO_TeamID_' + team.teamid));
            const x = Math.floor(((startX + i * R2_X) % 1) * 100);
            const y = Math.floor(((startY + i * R2_Y) % 1) * 100);
            elPanel.style.backgroundImage = _TileBgImage();
            elPanel.style.backgroundPosition = x + '% ' + y + '%';
            elPanel.SetPanelEvent('onactivate', () => {
                _ShowTeam(cp, team);
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_select', 'MOUSE');
            });
        });
    }
    function _PickFeatured() {
        const aPool = g_ActiveTournamentTeams.slice(0, FEATURED_TEAM_COUNT).flatMap(team => [
            { teamId: team.teamid, playerCode: '' },
            ...team.players.map(player => ({ teamId: team.teamid, playerCode: player.code })),
        ]);
        const randomGen = new UniqueRandomUtils.UniqueRandomGenerator(0, aPool.length - 1);
        const aPicks = [];
        for (let i = 0; i < FEATURED_PAGE_COUNT; i++) {
            const nRandom = randomGen.next();
            if (nRandom === null)
                break;
            aPicks.push(aPool[nRandom]);
        }
        return aPicks;
    }
    function _GetFeaturedStickers(cp, pick) {
        return State(cp).aFlatStickersData
            .filter(s => s.teamId === pick.teamId && !s.champion &&
            (pick.playerCode ? s.playerCode === pick.playerCode : !s.isPlayer))
            .sort((a, b) => b.rarity - a.rarity);
    }
    function _SetUpFeaturedCarousel(cp) {
        const elCarousel = cp.FindChildInLayoutFile('id-major-store-featured-carousel');
        State(cp).aFeaturedPicks.forEach((pick, nPage) => {
            const elPage = _GetOrCreatePanel(elCarousel, 'id-featured-page-' + nPage, 'popup-major-store__featured__page');
            elPage.hittest = false;
            const aStickers = _GetFeaturedStickers(cp, pick);
            for (let i = 0; i < aStickers.length; i++) {
                const elTile = _GetOrCreateTile(elPage, 'id-featured-tile-' + nPage + '-' + i, SNIPPET_STICKER_TILE, tile => tile.AddClass('featured'));
                _UpdateTile(cp, elTile, aStickers, i);
            }
        });
        _UpdateFeaturedHitTest(cp);
    }
    function _UpdateFeaturedHitTest(cp) {
        const elCarousel = cp.FindChildInLayoutFile('id-major-store-featured-carousel');
        const elFocus = elCarousel.GetFocusChild() ?? elCarousel.GetChild(0);
        for (const elPage of elCarousel.Children()) {
            elPage.hittestchildren = elPage === elFocus;
        }
    }
    function _GetOrCreatePanel(elParent, id, cls) {
        return elParent.FindChildInLayoutFile(id)
            ?? $.CreatePanel('Panel', elParent, id, { class: cls });
    }
    function _GetOrCreateTile(elParent, id, snippet, onCreate) {
        let elTile = elParent.FindChildInLayoutFile(id);
        if (!elTile) {
            elTile = $.CreatePanel('Panel', elParent, id);
            _LoadItemTileSnippet(elTile, snippet);
            onCreate?.(elTile);
        }
        return elTile;
    }
    function _TileBgImage() {
        return 'url( "file://{images}/tournaments/backgrounds/store_team_tile_bg_' + g_ActiveTournamentInfo.eventid + '.psd" )';
    }
    function _LoadItemTileSnippet(elTile, szSnippet) {
        elTile.BLoadLayoutSnippet(szSnippet);
        const elImage = elTile.FindChildInLayoutFile('id-store-item-image_container');
        elImage.style.backgroundImage = _TileBgImage();
        elImage.style.backgroundSize = 'auto';
    }
    function _StickersTitle(cp, szName) {
        cp.SetDialogVariable('team-name', szName);
        return $.Localize('#major_store_team_stickers', cp);
    }
    function _ShowTeam(cp, team) {
        State(cp).activeTeam = team;
        cp.FindChildInLayoutFile(VIEW_TEAM).SetDialogVariable('team-title', _StickersTitle(cp, $.Localize('#CSGO_TeamID_' + team.teamid)));
        _SetActiveNavTab(cp, NAV_TAB_NONE);
        _ShowMainPanel(cp, VIEW_TEAM);
    }
    function _InTeamGridColumn(sticker, szPlayerCode) {
        return szPlayerCode ? sticker.playerCode === szPlayerCode : !sticker.isPlayer;
    }
    function _TeamGridLayout(team, aStickers) {
        const aColumns = [
            { code: '', label: $.Localize('#CSGO_TeamID_' + team.teamid) },
            ...team.players.map(player => ({ code: player.code, label: player.nick })),
        ];
        const aRows = TEAM_GRID_RARITIES.map(nRarity => ({
            icon: 'file://{images}/icons/ui/sticker_rarity_' + nRarity + '.svg',
            label: $.Localize('#major_store_filter_type_' + nRarity),
            aStickers: aColumns.map(col => aStickers.find(s => !s.champion && s.rarity === nRarity && _InTeamGridColumn(s, col.code))),
        }));
        if (aStickers.some(s => s.champion)) {
            aRows.unshift({
                icon: 'file://{images}/icons/ui/trophy.svg',
                label: $.Localize('#major_store_nav_tab_champions'),
                aStickers: aColumns.map(col => aStickers
                    .filter(s => s.champion && _InTeamGridColumn(s, col.code))
                    .sort((a, b) => b.rarity - a.rarity)[0]),
            });
        }
        return { aColumns, aRows };
    }
    function _BuildTeamGrid(cp) {
        const elGrid = cp.FindChildInLayoutFile('id-major-store-team-grid');
        elGrid.RemoveAndDeleteChildren();
        m_aTeamGridCells = [];
        m_aTeamGridLines = [];
        const team = State(cp).activeTeam;
        if (!team) {
            return;
        }
        const { aColumns, aRows } = _TeamGridLayout(team, State(cp).aFlatStickersData.filter(s => !s.isOrg && s.teamId === team.teamid));
        const elTitleRow = _AddGridRow(elGrid);
        _AddGridSpacer(elTitleRow, 'icon');
        aColumns.forEach(col => _AddGridTitle(elTitleRow, col.label));
        _AddGridSpacer(elTitleRow, 'tab');
        const aColumnCells = aColumns.map(() => []);
        for (const row of aRows) {
            const elRow = _AddGridRow(elGrid);
            _AddGridRowIcon(elRow, row.icon, row.label);
            const aRowCells = [];
            row.aStickers.forEach((sticker, nCol) => {
                if (!sticker) {
                    $.CreatePanel('Panel', elRow, '', { class: 'popup-major-store__team-grid__empty' });
                    return;
                }
                const cell = { elTile: _AddGridTile(cp, elRow, sticker), sticker };
                m_aTeamGridCells.push(cell);
                aRowCells.push(cell);
                aColumnCells[nCol].push(cell);
            });
            _AddGridTab(elRow, 'row', aRowCells);
        }
        const elFooter = _AddGridRow(elGrid);
        _AddGridSpacer(elFooter, 'icon');
        aColumnCells.forEach(aCells => _AddGridTab(elFooter, 'column', aCells));
        _AddGridSpacer(elFooter, 'tab');
    }
    function _AddGridRow(elGrid) {
        return $.CreatePanel('Panel', elGrid, '', { class: 'popup-major-store__team-grid__row' });
    }
    function _AddGridSpacer(elRow, szType) {
        $.CreatePanel('Panel', elRow, '', { class: 'popup-major-store__grid-spacer ' + szType });
    }
    function _AddGridTitle(elRow, szText) {
        const elLabel = $.CreatePanel('Label', elRow, '', { class: 'stratum-medium popup-major-store__grid-title' });
        elLabel.text = szText;
    }
    function _AddGridRowIcon(elRow, szIcon, szLabel) {
        const elCell = $.CreatePanel('Panel', elRow, '', { class: 'popup-major-store__grid-row-icon' });
        const elIcon = $.CreatePanel('Image', elCell, '', { src: szIcon, textureheight: '32', texturewidth: '-1' });
        elIcon.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltipOnPanel(elIcon, szLabel));
        elIcon.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
    }
    function _AddGridTile(cp, elRow, sticker) {
        const elTile = $.CreatePanel('Panel', elRow, '');
        _LoadItemTileSnippet(elTile, SNIPPET_STICKER_TILE);
        elTile.AddClass('grid');
        _UpdateTile(cp, elTile, [sticker], 0);
        return elTile;
    }
    function _AddGridTab(elRow, szType, aCells) {
        const elCell = $.CreatePanel('Panel', elRow, '', { class: 'popup-major-store__grid-tab-cell ' + szType });
        const elBtn = $.CreatePanel('Button', elCell, 'id-major-store-grid-tab-' + m_aTeamGridLines.length, { class: 'popup-major-store__grid-tab' });
        $.CreatePanel('Image', elBtn, '', { src: 'file://{images}/icons/ui/add_to_cart.svg', textureheight: '28', texturewidth: '-1', hittest: 'false' });
        const line = { elBtn, aCells };
        m_aTeamGridLines.push(line);
        elBtn.SetPanelEvent('onactivate', () => _AddGridLineToCart(line));
        elBtn.SetPanelEvent('onmouseover', () => {
            aCells.forEach(cell => cell.elTile.AddClass('line-hover'));
            _ShowGridTabTooltip(line);
        });
        elBtn.SetPanelEvent('onmouseout', () => {
            aCells.forEach(cell => cell.elTile.RemoveClass('line-hover'));
            UiToolkitAPI.HideTitleTextTooltip();
        });
        _UpdateGridLine(line);
    }
    function _GridLineTotal(line) {
        return line.aCells.reduce((nSum, cell) => nSum + _EffectivePrice(cell.sticker), 0);
    }
    function _ShowGridTabTooltip(line) {
        const nTotal = _GridLineTotal(line);
        const szRealPrice = nTotal > 0 ? StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, nTotal, '') : '';
        let szText = $.Localize('#major_store_grid_tab_tooltip', line.elBtn);
        const nInCart = line.aCells.filter(cell => ShoppingCart.cart.getItemQuantity(cell.sticker.itemId) > 0).length;
        if (nInCart > 0) {
            line.elBtn.SetDialogVariableInt('in-cart', nInCart);
            szText += '<br>' + $.Localize('#major_store_grid_tab_in_cart', line.elBtn);
        }
        UiToolkitAPI.ShowTitleTextTooltipStyled(line.elBtn.id, szRealPrice, szText, 'major-store-grid-tab-tooltip');
    }
    function _UpdateGridLine(line) {
        line.elBtn.SetDialogVariableInt('count', line.aCells.length);
        line.elBtn.SetDialogVariableInt('price', _GridLineTotal(line));
        line.elBtn.SetHasClass('empty', line.aCells.length === 0);
        line.elBtn.enabled = line.aCells.length > 0;
    }
    function _AddGridLineToCart(line) {
        if (line.aCells.length === 0) {
            return;
        }
        const nAdded = ShoppingCart.cart.addItems(line.aCells.map(cell => _CartProduct(cell.sticker)));
        $.DispatchEvent('CSGOPlaySoundEffect', nAdded === line.aCells.length ? 'UIPanorama.generic_button_press' : 'UIPanorama.buymenu_failure', 'MOUSE');
        if (nAdded > 0) {
            _ShowGridTabTooltip(line);
            line.aCells.forEach(cell => cell.elTile.AddClass('line-added'));
            $.Schedule(0.6, () => line.aCells.forEach(cell => {
                if (cell.elTile.IsValid()) {
                    cell.elTile.RemoveClass('line-added');
                }
            }));
        }
    }
    function _RefreshTeamGrid(cp) {
        m_aTeamGridCells.forEach(cell => _UpdateTile(cp, cell.elTile, [cell.sticker], 0));
        m_aTeamGridLines.forEach(_UpdateGridLine);
    }
    function _OrgName() {
        return $.Localize('#CSGO_' + g_ActiveTournamentInfo.organization);
    }
    function _EventListSource(cp) {
        return {
            title: _StickersTitle(cp, _OrgName()),
            navTabKey: 'event',
            isSearch: false,
            getItems: (cp) => State(cp).aFlatStickersData.filter(s => s.isOrg),
        };
    }
    function _SearchListSource(szReturnTab) {
        return {
            title: $.Localize('#major_store_search_results'),
            navTabKey: NAV_TAB_NONE,
            isSearch: true,
            getItems: (cp) => _GetSearchListItems(cp),
            back: (cp) => _ShowTab(cp, szReturnTab),
        };
    }
    function _ShowList(cp, source) {
        State(cp).listSource = source;
        cp.FindChildInLayoutFile(VIEW_LIST).SetDialogVariable('list-title', source.title);
        cp.FindChildInLayoutFile('id-major-store-filter-row').visible = source.isSearch;
        _SetActiveNavTab(cp, source.navTabKey);
        _ShowMainPanel(cp, VIEW_LIST);
    }
    function _UpdateItemsList(cp, bDisableScroll) {
        const source = State(cp).listSource;
        if (!source)
            return;
        const elLister = cp.FindChildInLayoutFile('id-major-store-items-lister');
        const aItems = source.getItems(cp);
        if (source.isSearch) {
            const elList = cp.FindChildInLayoutFile(VIEW_LIST);
            elList.SetDialogVariableInt('result-count', aItems.length);
            elList.SetDialogVariable('list-title', $.Localize('#major_store_search_results_count', elList));
        }
        elLister.SetLoadListItemFunction((elLister, nPanelIdx, reusePanel) => {
            const bIsSticker = 'rawId' in aItems[nPanelIdx];
            if (!reusePanel || !reusePanel.IsValid()) {
                reusePanel = $.CreatePanel('Panel', elLister, '');
            }
            _LoadTileSnippet(reusePanel, bIsSticker ? SNIPPET_STICKER_TILE : SNIPPET_KEYCHAIN_TILE);
            if (bIsSticker) {
                _UpdateTile(cp, reusePanel, aItems, nPanelIdx);
            }
            else {
                _UpdateKeyChainsTile(cp, reusePanel, aItems, nPanelIdx);
            }
            return reusePanel;
        });
        elLister.UpdateListItems(aItems.length);
        if (!bDisableScroll)
            elLister.ScrollToTop();
    }
    function _LoadTileSnippet(elTile, szSnippet) {
        if (elTile.GetAttributeString('data-snippet', '') === szSnippet) {
            return;
        }
        elTile.RemoveAndDeleteChildren();
        elTile.RemoveClass('major-store__sticker-tile');
        elTile.RemoveClass('major-store__keychain-tile');
        _LoadItemTileSnippet(elTile, szSnippet);
        elTile.SetAttributeString('data-snippet', szSnippet);
    }
    function _SortItems(aItems, szSortId) {
        const compare = SORT_OPTIONS[szSortId] ?? SORT_OPTIONS[SORT_DEFAULT];
        return [...aItems].sort((a, b) => compare(a, b) || (_EffectivePrice(b) - _EffectivePrice(a)) || _CompareById(a, b));
    }
    function _UpdateBalance(cp) {
        const idxLookup = InventoryAPI.GetCacheTypeElementIndexByKey('SeasonalOperations', g_ActiveTournamentInfo.credits_id);
        let nRedeemableBalance = 0;
        if (g_ActiveTournamentInfo.credits_id == InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'season_value')) {
            nRedeemableBalance = InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'redeemable_balance');
            nRedeemableBalance = (nRedeemableBalance === null || nRedeemableBalance === undefined) ? 0 : nRedeemableBalance;
        }
        if (State(cp).activatedCredits > 0) {
            const elNotification = cp.FindChildInLayoutFile('id-major-store-add-tokens');
            _PushOverlay(cp, 'id-major-store-add-tokens');
            const tempBalance = nRedeemableBalance - State(cp).activatedCredits;
            cp.SetDialogVariableInt('balance', tempBalance);
            function CallAtEndAnimation() {
                _PopOverlay();
                cp.FindChildInLayoutFile('id-major-store-balance').TriggerClass('popup-major-store__top-bar__balance-anim');
                cp.SetDialogVariableInt('balance', nRedeemableBalance);
            }
            AddMajorTokensAnim.StartAnim(elNotification, cp.FindChildInLayoutFile('id-major-store-balance'), State(cp).activatedCredits, CallAtEndAnimation);
            State(cp).activatedCredits = 0;
        }
        else {
            cp.SetDialogVariableInt('balance', nRedeemableBalance);
        }
    }
    function _ClearTextSearch(cp) {
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        elSearchBox.ClearSelection();
        elSearchBox.text = '';
    }
    function _SetUpKeyChainsPage(cp) {
        const elParent = cp.FindChildInLayoutFile(VIEW_CHARMS);
        const numStages = g_ActiveTournamentHighlights.length;
        for (let i = numStages - 1; i >= 0; --i) {
            const stage = g_ActiveTournamentHighlights[i];
            let elPanel = elParent.FindChildInLayoutFile('id-keychains-stage-' + stage.group_id);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elParent, 'id-keychains-stage-' + stage.group_id);
                elPanel.BLoadLayoutSnippet('keychain-section');
                elPanel.SetDialogVariable('stage-title', $.Localize('#CSGO_Tournament_Event_Stage_' + stage.stage));
            }
            const keyChains = State(cp).aFlatKeyChainData.filter((keychain) => keychain.stage === stage.stage);
            const elContainer = elPanel.FindChildInLayoutFile('id-keychains-container');
            keyChains.forEach((keychain, idx) => {
                let elTile = elParent.FindChildInLayoutFile('id-keychain-' + keychain.kc_highlight);
                if (!elTile) {
                    elTile = $.CreatePanel('Panel', elContainer, 'id-keychain-' + keychain.kc_highlight);
                    _LoadItemTileSnippet(elTile, SNIPPET_KEYCHAIN_TILE);
                }
                _UpdateKeyChainsTile(cp, elTile, keyChains, idx);
            });
        }
    }
    function _UpdateTile(cp, reusePanel, filteredList, nPanelIdx) {
        const stickerData = filteredList[nPanelIdx];
        reusePanel.SetDialogVariable('title', stickerData.isPlayer ?
            stickerData.playerNick :
            stickerData.isOrg ?
                _OrgName() :
                stickerData.teamName);
        MajorStorePrices.SetPriceOnPanel(reusePanel, stickerData);
        _ShoppingCartControlsOnTile(stickerData, reusePanel);
        reusePanel.SwitchClass('rarity', 'rarity-' + stickerData.rarity);
        reusePanel.SwitchClass('sticker-type', stickerData.champion ? 'champion' : '');
        reusePanel.FindChildInLayoutFile('id-store-item-rarity-bar').style.washColor = InventoryAPI.GetItemRarityColor(stickerData.itemId);
        reusePanel.SetHasClass('is-player', stickerData.isPlayer);
        reusePanel.FindChildInLayoutFile('id-store-item-image').itemid = stickerData.itemId;
        reusePanel.FindChildInLayoutFile('id-store-item-team-logo').SetImage(stickerData.isOrg ?
            'file://{images}/tournaments/events/tournament_logo_' + g_ActiveTournamentInfo.eventid + '.svg' :
            'file://{images}/tournaments/teams/' + stickerData.teamTag + '.svg');
        reusePanel.SetPanelEvent('onmouseover', () => {
            _MakeModelPanel(reusePanel, stickerData.itemId);
            MajorStorePrices.ShowRealPrice(reusePanel, stickerData);
        });
        reusePanel.SetPanelEvent('onmouseout', () => {
            MajorStorePrices.HideRealPrice(reusePanel);
            _DeleteModelPanel(reusePanel);
        });
        _RebindOpenModelPanel(reusePanel, stickerData.itemId);
        reusePanel.FindChildInLayoutFile('id-inspect-sticker').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(stickerData);
        });
    }
    function _RebindOpenModelPanel(reusePanel, itemId) {
        const MapPanel = reusePanel.FindChildInLayoutFile('id-store-item-model');
        if (MapPanel && MapPanel.IsValid())
            MapPanel.SetItemItemId(itemId, '');
    }
    function _MakeModelPanel(reusePanel, itemId) {
        let elParent = reusePanel.FindChildInLayoutFile('id-store-item-image_container');
        let MapPanel = elParent.FindChildInLayoutFile('id-store-item-model');
        if (!MapPanel) {
            MapPanel = $.CreatePanel('MapItemPreviewPanel', elParent, 'id-store-item-model', {
                class: 'major-store__item-tile__model',
                "require-composition-layer": "true",
                'transparent-background': true,
                'disable-depth-of-field': true,
                player: "false",
                map: "ui/xpshop_item",
                initial_entity: 'item',
                active_item_idx: 0,
                camera: 'camera_weapon_7',
                mouse_rotate: "false",
                auto_recenter: true,
                tabindex: "auto",
                selectionpos: "auto",
                hittest: "true",
                hide_while_waiting_for_composite_materials: "false"
            });
            MapPanel.SetRotationLimits(60, 45);
            MapPanel.SetAutoRotateAmount(20, -2);
            MapPanel.SetAutoRotatePeriod(6, 6);
            let nRenderInterval = 1;
            MapPanel.SetRenderInterval(nRenderInterval);
        }
        MapPanel.SetItemItemId(itemId, '');
    }
    function _DeleteModelPanel(reusePanel) {
        let MapPanel = reusePanel.FindChildInLayoutFile('id-store-item-model');
        if (MapPanel !== null && MapPanel.IsValid()) {
            MapPanel.DeleteAsync(0);
        }
    }
    function _UpdateKeyChainsTile(cp, reusePanel, filteredList, nPanelIdx) {
        const keychainData = filteredList[nPanelIdx];
        reusePanel.SetDialogVariable('title', keychainData.name);
        MajorStorePrices.SetPriceOnPanel(reusePanel, keychainData);
        _ShoppingCartControlsOnTile(keychainData, reusePanel);
        reusePanel.SetHasClass('is-final', keychainData.stage === 97);
        reusePanel.SetDialogVariable('stage', $.Localize('#CSGO_Tournament_Event_Stage_' + keychainData.stage));
        reusePanel.FindChildInLayoutFile('id-store-item-image').itemid = keychainData.itemId;
        reusePanel.FindChildInLayoutFile('id-store-item-team-1').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid1) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-2').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid2) + '.svg');
        reusePanel.SetPanelEvent('onmouseover', () => {
            if (jsTooltipDelayHandle) {
                $.CancelScheduled(jsTooltipDelayHandle);
                jsTooltipDelayHandle = null;
            }
            jsTooltipDelayHandle = $.Schedule(.4, () => {
                {
                    _ShowVideoClip(reusePanel, keychainData.itemId);
                }
            });
            MajorStorePrices.ShowRealPrice(reusePanel, keychainData);
        });
        reusePanel.SetPanelEvent('onmouseout', () => {
            if (jsTooltipDelayHandle) {
                $.CancelScheduled(jsTooltipDelayHandle);
                jsTooltipDelayHandle = null;
            }
            MajorStorePrices.HideRealPrice(reusePanel);
            _HideVideoClip(reusePanel, keychainData.itemId);
        });
        if (reusePanel.FindChildTraverse('id-store-item-movie-container')?.BHasClass('play'))
            _ShowVideoClip(reusePanel, keychainData.itemId);
        reusePanel.FindChildInLayoutFile('id-inspect-sticker').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(keychainData);
        });
    }
    let jsTooltipDelayHandle = null;
    function _ShowVideoClip(elPanel, itemId) {
        const reelId = InventoryAPI.GetItemAttributeValue(itemId, '{uint32}keychain slot 0 highlight');
        if (reelId) {
            const reelJson = InventoryAPI.BuildHighlightReelSchemaJSON(reelId);
            const reelSchemaDef = JSON.parse(reelJson);
            const videoPlayerContainer = elPanel.FindChildTraverse('id-store-item-movie-container');
            const videoPlayer = elPanel.FindChildTraverse('id-store-item-movie');
            if (videoPlayerContainer && videoPlayer) {
                videoPlayerContainer.AddClass('play');
                videoPlayer.AddClass('play');
                videoPlayer.SetMovie(reelSchemaDef["url_480p"]);
                videoPlayer.Play();
            }
        }
    }
    function _HideVideoClip(elPanel, itemId) {
        if (InventoryAPI.GetItemAttributeValue(itemId, '{uint32}keychain slot 0 highlight')) {
            const videoPlayerContainer = elPanel.FindChildTraverse('id-store-item-movie-container');
            const videoPlayer = elPanel.FindChildTraverse('id-store-item-movie');
            if (videoPlayerContainer && videoPlayer) {
                videoPlayerContainer.RemoveClass('play');
                videoPlayer.RemoveClass('play');
                videoPlayer.Stop();
            }
        }
    }
    function _CartProduct(item) {
        return { id: item.itemId, name: item.displayName, price: _EffectivePrice(item) };
    }
    function _ShoppingCartControlsOnTile(stickerData, reusePanel) {
        const shopItem = _CartProduct(stickerData);
        ShoppingCart.cart.subscribeToUpdates(reusePanel, 'tile-counter', () => {
            const quantityInCart = ShoppingCart.cart.getItemQuantity(stickerData.itemId);
            reusePanel.SetHasClass('show-quantity', quantityInCart > 0);
            reusePanel.SetDialogVariableInt('quantity', quantityInCart);
        });
        reusePanel.FindChildInLayoutFile('id-store-item-add-to-cart-btn').SetPanelEvent('onactivate', () => {
            ShoppingCart.cart.addItem(shopItem);
            if (ShoppingCart.cart.getItemQuantity(stickerData.itemId) >= 10 || ShoppingCart.cart.getTotalItems() >= 100) {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
                return;
            }
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
        });
        reusePanel.FindChildInLayoutFile('id-store-item-remove-from-cart-btn').SetPanelEvent('onactivate', () => {
            ShoppingCart.cart.decrementItem(shopItem.id);
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
        });
    }
    function _OpenFullscreenInspect(itemData) {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: itemData.itemId,
            inspect_only: true,
            hide_all_action_items: true,
            price_in_tokens: _EffectivePrice(itemData),
        };
        elPanel.Data().oSettings = oSettings;
    }
    function _Debounce(cp, handleName, delay, fnAction) {
        const data = cp.Data();
        if (data[handleName]) {
            $.CancelScheduled(data[handleName]);
            data[handleName] = null;
        }
        data[handleName] = $.Schedule(delay, fnAction);
    }
    function _ScoreStickerSearch(stickers, lowerTokens) {
        const szMajor = $.Localize('#major_store_nav_tab_major').toLowerCase();
        const szChampions = $.Localize('#major_store_nav_tab_champions').toLowerCase();
        return stickers.map(sticker => {
            let totalScore = 0;
            const nick = sticker.playerCode.toLowerCase();
            const tag = (sticker.teamTag) ? sticker.teamTag.toLowerCase() : '';
            const rarity = sticker.rarityLookup.toLowerCase();
            const team = (sticker.teamName) ? sticker.teamName.toLowerCase() : '';
            const real = (sticker.realName) ? sticker.realName.toLowerCase() : '';
            const name = (sticker.name) ? sticker.name.toLowerCase() : '';
            const category = sticker.champion ? szChampions : szMajor;
            const hasMatch = lowerTokens.every(token => {
                let tokenScore = 0;
                if (nick === token || nick.startsWith(token))
                    tokenScore = 100;
                else if (nick.includes(token))
                    tokenScore = 80;
                else if (tag.includes(token))
                    tokenScore = 60;
                else if (rarity.includes(token))
                    tokenScore = 40;
                else if (category.includes(token))
                    tokenScore = 35;
                else if (name.includes(token))
                    tokenScore = 30;
                else if (team.includes(token) || real.includes(token))
                    tokenScore = 20;
                totalScore += tokenScore;
                return tokenScore > 0;
            });
            return { sticker, score: totalScore, isValid: hasMatch };
        })
            .filter(result => result.isValid)
            .sort((a, b) => b.score - a.score)
            .map(result => result.sticker);
    }
    function _ScoreKeyChainSearch(keychains, lowerTokens) {
        return keychains.map(item => {
            let totalScore = 0;
            const name = item.name ? item.name.toLowerCase() : '';
            const mapName = item.map_name ? item.map_name.toLowerCase() : '';
            const stage = item.stage ? $.Localize('#CSGO_Tournament_Event_Stage_' + item.stage).toLowerCase() : '';
            const team1 = item.teamid1 ? $.Localize('#CSGO_TeamID_' + item.teamid1).toLowerCase() : '';
            const team2 = item.teamid2 ? $.Localize('#CSGO_TeamID_' + item.teamid2).toLowerCase() : '';
            const hasMatch = lowerTokens.every(token => {
                let tokenScore = 0;
                if (name === token || name.startsWith(token))
                    tokenScore = 100;
                else if (name.includes(token))
                    tokenScore = 80;
                else if (mapName.includes(token))
                    tokenScore = 60;
                else if (stage.includes(token))
                    tokenScore = 40;
                else if (team1.includes(token) || team2.includes(token))
                    tokenScore = 20;
                totalScore += tokenScore;
                return tokenScore > 0;
            });
            return { item, score: totalScore, isValid: hasMatch };
        })
            .filter(result => result.isValid)
            .sort((a, b) => b.score - a.score)
            .map(result => result.item);
    }
    function _GetItemsForSearch(cp, searchTxt) {
        const tokens = searchTxt.toLowerCase().trim().split(/\s+/).filter(t => t.length > 0);
        if (tokens.length === 0)
            return { stickerResults: [], keychainResults: [] };
        const szKey = tokens.join(' ');
        const cached = State(cp).searchCache;
        if (cached && cached.key === szKey)
            return cached.results;
        const results = {
            stickerResults: _ScoreStickerSearch(State(cp).aFlatStickersData, tokens),
            keychainResults: _ScoreKeyChainSearch(State(cp).aFlatKeyChainData, tokens),
        };
        State(cp).searchCache = { key: szKey, results };
        return results;
    }
    function _SearchText(cp) {
        return cp.FindChildInLayoutFile('id-major-store-search-box').text;
    }
    function _IsSearchActive(cp) {
        return _ActiveView()?.id === VIEW_LIST && !!State(cp).listSource?.isSearch;
    }
    function _OnSearchTextChanged(cp) {
        const bHasText = _SearchText(cp).trim().length > 0;
        if (_IsSearchActive(cp)) {
            if (bHasText)
                _UpdateItemsList(cp, false);
            else
                _GoBack(cp);
            return;
        }
        if (!bHasText)
            return;
        cp.FindChildInLayoutFile('id-search-filter-all').checked = true;
        _ShowList(cp, _SearchListSource(m_activeTabKey));
    }
    function _FilterSearchResults(results, szFilter) {
        if (szFilter === 'all') {
            return [...results.stickerResults, ...results.keychainResults];
        }
        else if (szFilter === 'charms') {
            return results.keychainResults;
        }
        else {
            return results.stickerResults.filter(s => s.rarity === Number(szFilter));
        }
    }
    function _GetSearchListItems(cp) {
        const results = _GetItemsForSearch(cp, _SearchText(cp));
        const elAll = cp.FindChildInLayoutFile('id-search-filter-all');
        for (const elPill of cp.FindChildInLayoutFile('id-major-store-filter-pills').Children()) {
            const szPillFilter = elPill.GetAttributeString('data-filter', 'all');
            elPill.visible = szPillFilter === 'all' || _FilterSearchResults(results, szPillFilter).length > 0;
        }
        let elSelected = elAll.GetSelectedButton();
        if (!elSelected || !elSelected.visible) {
            elAll.checked = true;
            elSelected = elAll;
        }
        const aItems = _FilterSearchResults(results, elSelected.GetAttributeString('data-filter', 'all'));
        const selected = _SortDropDown(cp).GetSelected();
        return _SortItems(aItems, selected ? selected.id : SORT_DEFAULT);
    }
    function _SetUpStoreNavTabs(cp) {
        STORE_NAV_TABS.forEach(tab => {
            const elTab = cp.FindChildInLayoutFile(tab.btnId);
            elTab.visible = tab.isAvailable(cp);
            elTab.SetPanelEvent('onactivate', () => {
                if (m_bSyncingNavTabs)
                    return;
                _ShowTab(cp, tab.key);
            });
        });
    }
    function _ShowTab(cp, key) {
        const tab = STORE_NAV_TABS.find(t => t.key === key) ?? STORE_NAV_TABS[0];
        _ClearTextSearch(cp);
        _SetActiveNavTab(cp, tab.key);
        tab.show(cp);
    }
    function _SetActiveNavTab(cp, key) {
        m_bSyncingNavTabs = true;
        STORE_NAV_TABS.forEach(tab => {
            cp.FindChildInLayoutFile(tab.btnId).checked = (tab.key === key);
        });
        m_bSyncingNavTabs = false;
        if (key !== NAV_TAB_NONE) {
            m_activeTabKey = key;
        }
    }
    function _FindView(viewId) {
        return STORE_VIEWS.find(view => view.id === viewId);
    }
    function _ActiveView() {
        return (m_activeMain && m_activeMain.IsValid()) ? _FindView(m_activeMain.id) : undefined;
    }
    function _ShowMainPanel(cp, viewId) {
        _CloseSortDropDown(cp);
        const view = _FindView(viewId);
        const elNext = cp.FindChildInLayoutFile(viewId);
        if (!view || !elNext) {
            return;
        }
        if (elNext === m_activeMain) {
            if (view.rebuildIfActive) {
                view.onShow(cp);
                elNext.TriggerClass('panel-reveal');
            }
            _UpdateFooterButtons(cp);
            return;
        }
        view.onShow(cp);
        if (m_activeMain && m_activeMain.IsValid()) {
            m_activeMain.AddClass('hidden');
        }
        elNext.RemoveClass('hidden');
        elNext.TriggerClass('panel-reveal');
        m_activeMain = elNext;
        _UpdateFooterButtons(cp);
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
    }
    function _BackAction(cp) {
        const viewId = _ActiveView()?.id;
        if (viewId === VIEW_TEAM) {
            return (cp) => _ShowTab(cp, 'team');
        }
        if (viewId === VIEW_LIST) {
            return State(cp).listSource?.back;
        }
        return undefined;
    }
    function _GoBack(cp) {
        _BackAction(cp)?.(cp);
    }
    function _UpdateFooterButtons(cp) {
        const bCanGoBack = !!_BackAction(cp);
        cp.FindChildInLayoutFile('id-popup-major-store-close-btn').visible = !bCanGoBack;
        cp.FindChildInLayoutFile('id-popup-major-store-back-btn').visible = bCanGoBack;
    }
    function _PushOverlay(cp, panelId) {
        const overlay = $.GetContextPanel().FindChildTraverse(panelId);
        if (!overlay || m_overlayStack.includes(overlay))
            return;
        m_overlayStack.push(overlay);
        overlay.RemoveClass('hidden');
    }
    function _PopOverlay() {
        const topOverlay = m_overlayStack.pop();
        if (topOverlay && topOverlay.IsValid()) {
            topOverlay.AddClass('hidden');
            return true;
        }
        return false;
    }
    function OnCancelPressed() {
        if (m_overlayStack.includes($.GetContextPanel().FindChildInLayoutFile('id-major-store-loading'))) {
            return true;
        }
        if (m_overlayStack.length > 0) {
            const topOverlay = m_overlayStack.pop();
            $.GetContextPanel().FindChildTraverse(topOverlay.id).AddClass('hidden');
            return true;
        }
        const cp = $.GetContextPanel();
        if (_BackAction(cp)) {
            _GoBack(cp);
            return true;
        }
        ClosePopup();
        return true;
    }
    PopupMajorStore.OnCancelPressed = OnCancelPressed;
    {
        const cp = $.GetContextPanel();
        $.RegisterEventHandler('ReadyForDisplay', cp, ReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', cp, UnreadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_VolatileShopSubscribe', (...args) => { OnVolatileShopSubscribe(...args, cp); });
        $.RegisterEventHandler('SetCarouselSelectedChild', cp, () => _UpdateFeaturedHitTest(cp));
        cp.RegisterForReadyEvents(true);
        if (cp.BReadyForDisplay()) {
            ReadyForDisplay();
        }
    }
})(PopupMajorStore || (PopupMajorStore = {}));
