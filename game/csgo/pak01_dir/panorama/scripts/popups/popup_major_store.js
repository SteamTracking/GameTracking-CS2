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
var PopupMajorStore;
(function (PopupMajorStore) {
    const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
    const defidxKeyChainItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('keychain');
    function State(cp) {
        return cp.Data();
    }
    function _CompareByPopularity(a, b) {
        if (a.popularity != b.popularity)
            return b.popularity - a.popularity;
        if (a.price != b.price)
            return b.price - a.price;
        const aId = a.rawId ?? a.kc_highlight ?? a.itemId;
        const bId = b.rawId ?? b.kc_highlight ?? b.itemId;
        return aId < bId ? -1 : (aId > bId ? 1 : 0);
    }
    let Bookmarks;
    (function (Bookmarks) {
        const SETTING = 'cl_major_store_watch_list';
        let _cache = null;
        function ids() {
            if (_cache === null) {
                const raw = GameInterfaceAPI.GetSettingString(SETTING);
                _cache = raw ? raw.split(',') : [];
            }
            return _cache;
        }
        Bookmarks.ids = ids;
        function invalidate() {
            _cache = null;
        }
        Bookmarks.invalidate = invalidate;
        function has(defidx) {
            return ids().includes(defidx.toString());
        }
        Bookmarks.has = has;
        function toggle(defidx) {
            const id = defidx.toString();
            const list = [...ids()];
            const idx = list.indexOf(id);
            if (idx === -1)
                list.push(id);
            else
                list.splice(idx, 1);
            GameInterfaceAPI.SetSettingString(SETTING, list.length > 0 ? list.join(',') : '');
            _cache = list;
        }
        Bookmarks.toggle = toggle;
    })(Bookmarks || (Bookmarks = {}));
    const NAV_TAB_NONE = '';
    const VIEW_HOME = 'id-major-store-banners';
    const VIEW_CONTENT = 'id-major-store-content';
    const VIEW_CHARMS = 'id-major-store-keychains';
    const VIEW_TEAM = 'id-major-store-team-view';
    const VIEW_SINGLE = 'id-major-store-single-view';
    const NO_SERIES_FILTER = '';
    const SORT_OPTIONS = {
        'price-high-low': { field: 'price', direction: 'desc' },
        'price-low-high': { field: 'price', direction: 'asc' },
        'weekly-high-low': { field: 'weeklyPctReductionFromHigh', direction: 'desc' },
        'popularity-high-low': { field: 'popularity', direction: 'desc' },
        'popularity-low-high': { field: 'popularity', direction: 'asc' },
        'name': { field: 'name', direction: 'asc' },
    };
    const SORT_OPTION_IDS = Object.keys(SORT_OPTIONS);
    const VIEW_SORTS = {
        Event: { key: 'event', default: 'popularity-high-low', hidden: [] },
        Ranked: { key: 'ranked', default: 'price-high-low', hidden: ['weekly-high-low', 'popularity-high-low', 'popularity-low-high'] },
        Champions: { key: 'champions', default: 'popularity-high-low', hidden: ['weekly-high-low'] },
        Favorites: { key: 'favorites', default: 'weekly-high-low', hidden: ['popularity-high-low', 'popularity-low-high'] },
        AllItems: { key: 'all', default: 'name', hidden: [] },
        Search: { key: 'search', default: 'weekly-high-low', hidden: [] },
    };
    function _CloseSortDropDown(cp) {
        const elDropDown = _SortDropDown(cp);
        const elMenu = elDropDown ? elDropDown.AccessDropDownMenu() : null;
        if (!elMenu || !elMenu.visible) {
            return;
        }
        const elPage = cp.FindChildInLayoutFile('id-major-store-content-page');
        if (elPage) {
            elPage.SetFocus();
        }
    }
    function _SortDropDown(cp) {
        return cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
    }
    function _SelectSort(cp, szSortId) {
        m_bApplyingSort = true;
        _SortDropDown(cp).SetSelected(szSortId);
        m_bApplyingSort = false;
    }
    function _ApplyViewSort(cp, sort) {
        State(cp).activeSort = sort;
        const elDropDown = _SortDropDown(cp);
        SORT_OPTION_IDS.forEach(id => {
            const elOption = elDropDown.FindDropDownMenuChild(id);
            if (elOption) {
                elOption.visible = !sort.hidden.includes(id);
            }
        });
        const szRemembered = State(cp).mSortByView[sort.key];
        const szWanted = (szRemembered && !sort.hidden.includes(szRemembered)) ? szRemembered : sort.default;
        _SelectSort(cp, szWanted);
    }
    function _RememberViewSort(cp, szSortId) {
        State(cp).mSortByView[State(cp).activeSort.key] = szSortId;
    }
    const SERIES_FILTERS = [
        { toggleId: 'id-major-store-filter-major', loc: '#major_store_filter_type_major_only', chipId: 'id-filter-active-major-only' },
        { toggleId: 'id-major-store-filter-champions', loc: '#major_store_filter_type_champions_only', chipId: 'id-filter-active-champions-only' },
        { toggleId: 'id-major-store-filter-ranked', loc: '#major_store_filter_type_ranked_only', chipId: 'id-filter-active-ranked-only' },
    ];
    const REFINEMENT_FILTERS = [
        { toggleId: 'id-major-store-filter-team', loc: '#major_store_filter_type_team_only', chipId: 'id-filter-active-t-only' },
        { toggleId: 'id-major-store-filter-player', loc: '#major_store_filter_type_player_only', chipId: 'id-filter-active-p-only' },
    ];
    function _IsMixedContentView(cp) {
        if (State(cp).useBookMarkList) {
            return true;
        }
        const elParent = cp.FindChildInLayoutFile('id-major-store-nav-tabs-container');
        if (cp.FindChildInLayoutFile('id-major-store-nav-home').checked) {
            return false;
        }
        return !STORE_NAV_TABS.some(tab => {
            const elTab = elParent.FindChild(tab.key);
            return elTab && elTab.checked;
        });
    }
    function _MatchesSeriesFilter(item, settings) {
        if (!settings.rankedOnly && !settings.championsOnly && !settings.majorOnly) {
            return true;
        }
        return (settings.rankedOnly && item.isRanked)
            || (settings.championsOnly && item.champion)
            || (settings.majorOnly && ('rawId' in item) && !item.isRanked && !item.champion);
    }
    function _UpdateFilterSections(cp) {
        const bMixed = _IsMixedContentView(cp);
        cp.FindChildInLayoutFile('id-filter-section-series').visible = bMixed;
        cp.FindChildInLayoutFile('id-filter-section-keychains').visible = bMixed;
        cp.FindChildInLayoutFile('id-filter-section-teams').visible =
            !cp.FindChildInLayoutFile('id-major-store-filter-champions').checked;
    }
    function _SetActiveSeriesFilter(cp, toggleId) {
        if (toggleId !== NO_SERIES_FILTER && !SERIES_FILTERS.some(s => s.toggleId === toggleId)) {
        }
        SERIES_FILTERS.forEach(series => {
            const elToggle = cp.FindChildInLayoutFile(series.toggleId);
            if (elToggle) {
                elToggle.checked = (series.toggleId === toggleId);
            }
        });
    }
    const SEARCH_DEBOUNCE_HANDLE = 'textDebounceTimeoutHandle';
    const MAX_SEARCH_RESULTS_SHOWN = 20;
    let m_activeMain = null;
    const m_overlayStack = [];
    let m_bSyncingNavTabs = false;
    let m_bApplyingSort = false;
    const StoreNavActions = {
        Home: (cp) => {
            _OnActivateClearAll(cp);
            _SetActiveSeriesFilter(cp, NO_SERIES_FILTER);
            _ShowMainPanel(cp, VIEW_HOME);
        },
        Major: (cp) => _ShowCategoryList(cp, 'id-major-store-filter-major', VIEW_SORTS.Event),
        Ranked: (cp) => _ShowCategoryList(cp, 'id-major-store-filter-ranked', VIEW_SORTS.Ranked),
        Champions: (cp) => _ShowCategoryList(cp, 'id-major-store-filter-champions', VIEW_SORTS.Champions),
        Bookmarks: (cp) => {
            _OnActivateClearAll(cp);
            _SetActiveSeriesFilter(cp, NO_SERIES_FILTER);
            _ApplyViewSort(cp, VIEW_SORTS.Favorites);
            State(cp).useBookMarkList = true;
            _ShowMainPanel(cp, VIEW_CONTENT);
        },
        Charms: (cp) => {
            _OnActivateClearAll(cp);
            _SetActiveSeriesFilter(cp, NO_SERIES_FILTER);
            _ApplyViewSort(cp, VIEW_SORTS.AllItems);
            _ShowMainPanel(cp, VIEW_CHARMS);
        },
    };
    const STORE_CAROUSELS = [
        {
            key: 'ranked',
            bannerId: 'id-banner-ranked',
            seeAllBtnId: 'id-major-store-see-all-ranked-btn',
            hasItems: (cp) => State(cp).aFlatStickersData.some(s => s.isRanked),
            refresh: (cp) => _SetUpRankedBanner(cp),
            onSeeAll: StoreNavActions.Ranked,
            navTabKey: 'ranked',
        },
    ];
    const STORE_NAV_TABS = [
        {
            key: 'major',
            loc: '#major_store_nav_tab_major',
            isAvailable: (cp) => State(cp).aFlatStickersData.length > 0,
            activate: StoreNavActions.Major,
        },
        {
            key: 'champions',
            loc: '#major_store_nav_tab_champions',
            isAvailable: (cp) => State(cp).aFlatStickersData.some(s => s.champion),
            activate: StoreNavActions.Champions,
        },
        {
            key: 'ranked',
            loc: '#major_store_nav_tab_ranked',
            isAvailable: (cp) => State(cp).aFlatStickersData.some(s => s.isRanked),
            activate: StoreNavActions.Ranked,
        },
        {
            key: 'charms',
            loc: '#major_store_nav_tab_charms',
            isAvailable: (cp) => State(cp).aFlatKeyChainData.length > 1,
            activate: StoreNavActions.Charms,
        },
        {
            key: 'bookmarked',
            loc: '#major_store_nav_tab_bookmarked',
            isAvailable: () => true,
            activate: StoreNavActions.Bookmarks,
            label: (cp, elLabel) => {
                const nCount = _GetBookmarkedItemsList(cp).length;
                elLabel.SetDialogVariableInt('count', nCount);
                return $.Localize(nCount > 0 ? '#major_store_nav_tab_bookmarked_count' : '#major_store_nav_tab_bookmarked', elLabel);
            },
        },
    ];
    const STORE_VIEWS = [
        {
            id: VIEW_HOME,
            navTabKey: 'home',
            onShow: (cp) => _RefreshHome(cp),
            onRefresh: (cp) => _RefreshHome(cp),
        },
        {
            id: VIEW_CONTENT,
            rebuildIfActive: true,
            onShow: (cp) => { if (!_UpdateFavoritesEmptyState(cp))
                _MakeDelayedLoadList(cp); },
            onRefresh: (cp, bDisableScroll) => _UpdateItemsList({ cp, bDisableScroll }),
        },
        {
            id: VIEW_CHARMS,
            navTabKey: 'charms',
            onShow: (cp) => _SetUpKeyChainsPage(cp),
            onRefresh: (cp) => _SetUpKeyChainsPage(cp),
        },
        {
            id: VIEW_TEAM,
            onRefresh: (cp) => _RefreshTeamView(cp),
        },
        {
            id: VIEW_SINGLE,
            onRefresh: (cp) => _RefreshSingleView(cp),
            backTarget: VIEW_TEAM,
        },
    ];
    PopupMajorStore.UpdateAnimationTimer = 5;
    function ClosePopup() {
        const cp = $.GetContextPanel();
        cp.SetReadyForDisplay(false);
        CancelRefreshSubscription(cp);
        CancelRefreshTimerUpdate(cp);
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
        const menuHandle = state.contextMenuCallbackHandle;
        if (menuHandle) {
            UiToolkitAPI.UnregisterJSCallback(menuHandle);
            state.contextMenuCallbackHandle = null;
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
        State(cp).aKeyChainBannerItems = [];
        State(cp).searchCache = null;
        State(cp).activeSort = VIEW_SORTS.AllItems;
        State(cp).mSortByView = {};
        State(cp).stopTileUpdate = true;
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
        State(cp).arrAwaitingPricesheets = [];
        if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, g_ActiveTournamentInfo.stickerids[0])))
            State(cp).arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_dynamic_stickers);
        if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, g_ActiveTournamentInfo.rankingids[0])))
            State(cp).arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_rankings_stickers);
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
        cp.SetHasClass('major-' + eventId, true);
        if (!State(cp).contextMenuCallbackHandle)
            State(cp).contextMenuCallbackHandle = UiToolkitAPI.RegisterJSCallback(OnSearchContextMenuCallBack);
        cp.FindChildInLayoutFile('id-major-store-container-inner').AddClass('show');
        PriceRefreshTimerUpdate(cp);
        _UpdateStickerData(cp);
        _UpdateKeyChainsData(cp);
        _SetUpTitleBar(cp, eventId);
        _SetUpTeamsBanner(cp);
        _SetUpOrgBanners(cp);
        _VariousButtonActionsAndEvents(cp);
        _SetUpCarouselSeeAllButtons(cp);
        _SetUpStoreNavTabs(cp);
        _SetUpFilterPanel(cp);
        _ShowMainPanel(cp, VIEW_HOME);
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
        PriceRefreshTimerUpdate(cp);
        if (bNewPricesParsed) {
            if (nContainerDef == g_ActiveTournamentInfo.itemid_dynamic_stickers ||
                nContainerDef == g_ActiveTournamentInfo.itemid_champion_stickers ||
                nContainerDef == g_ActiveTournamentInfo.itemid_rankings_stickers) {
                _UpdateStickerData(cp);
            }
            else if (g_ActiveTournamentDynamicContainers.includes(nContainerDef)) {
                _UpdateKeyChainsData(cp);
            }
            State(cp).stopTileUpdate = false;
            _UpdateVisiblePanel(cp, true);
            $.Schedule(1, () => { State(cp).stopTileUpdate = true; });
            ShoppingCart.cart.syncPrices((itemId) => {
                const item = State(cp).aFlatStickersData.find(i => i.itemId === itemId);
                return item ? item.price : undefined;
            });
        }
    }
    function _UpdateVisiblePanel(cp, bDisableScroll = false) {
        _ActiveView()?.onRefresh?.(cp, bDisableScroll);
    }
    function GetNewMarketPrice(itemId) {
        const item = State($.GetContextPanel()).aFlatStickersData.find(i => i.itemId === itemId);
        return item ? item.price : undefined;
    }
    PopupMajorStore.GetNewMarketPrice = GetNewMarketPrice;
    function _SubscribeForAllTournamentItems() {
        g_ActiveTournamentDynamicContainers.forEach((id) => StoreAPI.VolatileShopSubscribe(id, true));
    }
    function GetSecondsUntilPendingPriceUpdateForAllTournamentItems() {
        let nSeconds = 0;
        g_ActiveTournamentDynamicContainers.forEach((id) => {
            const nThisPricesheet = StoreAPI.GetSecondsUntilPendingPriceUpdate(id);
            if (nThisPricesheet > 0) {
                if ((nSeconds <= 0) || (nThisPricesheet < nSeconds))
                    nSeconds = nThisPricesheet;
            }
        });
        return nSeconds;
    }
    PopupMajorStore.GetSecondsUntilPendingPriceUpdateForAllTournamentItems = GetSecondsUntilPendingPriceUpdateForAllTournamentItems;
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
    function PriceRefreshTimerUpdate(cp) {
        if (!cp || !cp.IsValid())
            return;
        CancelRefreshTimerUpdate(cp);
        const nSeconds = GetSecondsUntilPendingPriceUpdateForAllTournamentItems();
        const elRefresh = cp.FindChildInLayoutFile('id-major-store-refresh');
        const timer = cp.FindChildInLayoutFile('id-major-store-refresh-time');
        timer.text = $.Localize("#major_store_prices_updated");
        if (nSeconds <= 0) {
            CancelRefreshTimerUpdate(cp);
            elRefresh.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip('id-major-store-refresh', '#major_store_prices_updated_tooltip');
            });
            elRefresh.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideTextTooltip();
            });
            elRefresh.SetHasClass('alert', false);
            return;
        }
        elRefresh.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-refresh', '#major_store_refesh_tooltip');
        });
        elRefresh.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        elRefresh.SetHasClass('alert', true);
        timer.SetDialogVariable('timer', FormatText.SecondsToDDHHMMSSWithSymbolSeperator(nSeconds));
        timer.text = nSeconds > 1 ?
            $.Localize('#major_store_refresh_timer', timer) :
            $.Localize('#major_store_refresh_soon');
        State(cp).priceRefreshHandler = $.Schedule(1, () => PriceRefreshTimerUpdate(cp));
    }
    PopupMajorStore.PriceRefreshTimerUpdate = PriceRefreshTimerUpdate;
    function CancelRefreshTimerUpdate(cp) {
        const handle = State(cp).priceRefreshHandler;
        if (handle) {
            $.CancelScheduled(handle);
            State(cp).priceRefreshHandler = null;
        }
    }
    PopupMajorStore.CancelRefreshTimerUpdate = CancelRefreshTimerUpdate;
    function _UpdateStickerData(cp) {
        _BuildStickerData(State(cp).aFlatStickersData, false);
        _BuildStickerData(State(cp).aFlatStickersData, true);
        State(cp).searchCache = null;
        [...State(cp).aFlatStickersData]
            .sort(_CompareByPopularity)
            .forEach((sticker, i) => { sticker.popularityRank = i; });
    }
    function _BuildStickerData(target, isRanked) {
        const map = MapDataById(target);
        const add = (oData) => _UpdateWithCurrentData(target, map.get(oData.rawId), oData, _GetStickerData);
        g_ActiveTournamentTeams.forEach(team => {
            (isRanked ? team.rankingids : team.stickerids).forEach(id => add({ rawId: id, isPlayer: false, isOrg: false, teamId: team.teamid, team: team.team, isChampion: false, isRanked }));
            team.players.forEach(player => (isRanked ? player.rankingids : player.stickerids).forEach(id => add({ rawId: id, isPlayer: true, isOrg: false, teamId: team.teamid, team: team.team, playerCode: player.code, isChampion: false, isRanked })));
            team.champions.forEach(player => (isRanked ? player.rankingids : player.stickerids).forEach(id => add({ rawId: id, isPlayer: true, isOrg: false, teamId: team.teamid, team: team.team, playerCode: player.code, isChampion: true, isRanked })));
        });
        (isRanked ? g_ActiveTournamentInfo.rankingids : g_ActiveTournamentInfo.stickerids).forEach(id => add({ rawId: id, isPlayer: false, isOrg: true, playerCode: g_ActiveTournamentInfo.location + ' ' + g_ActiveTournamentInfo.organization, isRanked }));
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
        if (savedItemData) {
            const livePrice = _GetCurrentPriceForItem(savedItemData.itemId);
            if (livePrice !== undefined && savedItemData.price !== undefined) {
                if (savedItemData.price !== livePrice) {
                    savedItemData.oldPrice = savedItemData.price;
                    savedItemData.priceChangeRevealed = false;
                }
                savedItemData.price = livePrice;
                savedItemData.popularity = _GetCurrentTrendData(savedItemData.itemId, 'trend');
                const weeklyLow = _GetCurrentTrendData(savedItemData.itemId, 'low');
                const weeklyHigh = _GetCurrentTrendData(savedItemData.itemId, 'high');
                savedItemData.weeklyLow = weeklyLow;
                savedItemData.weeklyHigh = weeklyHigh;
                savedItemData.weeklyPctReductionFromHigh = (weeklyHigh > livePrice)
                    ? ((weeklyHigh - livePrice) * 100.0 / weeklyHigh) : 0.0;
            }
        }
        else {
            aFlatStoredData.push(_funcGetData(oData));
        }
    }
    function _GetStickerData(oData) {
        const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, oData.rawId);
        const numRarity = InventoryAPI.GetItemRarity(itemId);
        const livePrice = _GetCurrentPriceForItem(itemId);
        const weeklyLow = _GetCurrentTrendData(itemId, 'low');
        const weeklyHigh = _GetCurrentTrendData(itemId, 'high');
        const weeklyPctReductionFromHigh = (weeklyHigh > livePrice)
            ? ((weeklyHigh - livePrice) * 100.0 / weeklyHigh) : 0.0;
        return {
            isPlayer: oData.isPlayer,
            isOrg: ('isOrg' in oData) ? oData.isOrg : false,
            rawId: oData.rawId,
            teamName: $.Localize('#CSGO_TeamID_' + oData.teamId),
            teamId: oData.teamId,
            teamTag: oData.team,
            playerCode: ('playerCode' in oData) ? oData.playerCode : '',
            realName: oData.isPlayer ? $.Localize('#SFUI_ProPlayer_' + oData.playerCode) : '',
            itemId: itemId,
            price: livePrice,
            rarity: numRarity,
            rarityLookup: $.Localize('#major_store_filter_type_' + numRarity),
            name: InventoryAPI.GetItemName(itemId),
            displayName: ItemInfo.GetFormattedName(itemId),
            popularity: _GetCurrentTrendData(itemId, 'trend'),
            weeklyLow: weeklyLow,
            weeklyHigh: weeklyHigh,
            weeklyPctReductionFromHigh: weeklyPctReductionFromHigh,
            champion: oData.isChampion,
            isRanked: ('isRanked' in oData) ? oData.isRanked : false
        };
    }
    function _GetKeyChainData(oData) {
        const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxKeyChainItem, oData.kc_highlight);
        const livePrice = _GetCurrentPriceForItem(itemId);
        const weeklyLow = _GetCurrentTrendData(itemId, 'low');
        const weeklyHigh = _GetCurrentTrendData(itemId, 'high');
        const weeklyPctReductionFromHigh = (weeklyHigh > livePrice)
            ? ((weeklyHigh - livePrice) * 100.0 / weeklyHigh) : 0.0;
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
            price: livePrice,
            name: $.Localize(oData.name),
            popularity: _GetCurrentTrendData(itemId, 'trend'),
            weeklyLow: weeklyLow,
            weeklyHigh: weeklyHigh,
            weeklyPctReductionFromHigh: weeklyPctReductionFromHigh
        };
    }
    function _GetCurrentPriceForItem(itemId) {
        return MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, itemId);
    }
    function _GetCurrentTrendData(itemId, szField) {
        return MissionsAPI.GetSeasonalOperationFauxItemTrend(g_ActiveTournamentInfo.credits_id, itemId, szField);
    }
    function UnreadyForDisplay() {
    }
    function _VariousButtonActionsAndEvents(cp) {
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-filters-panel'));
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-loading'));
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-search-results'));
        cp.FindChildInLayoutFile('id-list-large-icons').SetPanelEvent('onactivate', () => {
            _MakeDelayedLoadList(cp);
        });
        cp.FindChildInLayoutFile('id-list-small-icons').SetPanelEvent('onactivate', () => {
            _MakeDelayedLoadList(cp);
        });
        cp.FindChildInLayoutFile('id-list-small-icons').checked = true;
        _SortDropDown(cp).SetPanelEvent('oninputsubmit', () => {
            if (!m_bApplyingSort) {
                const selected = _SortDropDown(cp).GetSelected();
                _RememberViewSort(cp, selected ? selected.id : '');
            }
            _UpdateItemsList({ cp });
        });
        cp.FindChildInLayoutFile('id-popup-major-store-back-btn').SetPanelEvent('onactivate', () => _GoBack(cp));
        cp.FindChildInLayoutFile('id-major-store-balance').SetPanelEvent('onmouseover', () => {
            cp.FindChildInLayoutFile('id-major-store-balance').SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, 100, ''));
            const tooltip = $.Localize('#major_store_balance_tooltip', cp.FindChildInLayoutFile('id-major-store-balance'));
            UiToolkitAPI.ShowTitleTextTooltip('id-major-store-balance', '#CSGO_TournamentPass_' + g_ActiveTournamentInfo.location + '_credits', tooltip);
        });
        cp.FindChildInLayoutFile('id-major-store-balance').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTitleTextTooltip();
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-receipt', '#major_store_balance_receipt');
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
            _Debounce(cp, SEARCH_DEBOUNCE_HANDLE, .3, () => { _ShowSearchResults(cp, _GetItemsForSearch(cp, elSearchBox.text)); });
        });
        elSearchBox.SetPanelEvent('ontextentrysubmit', () => {
            _ShowSearchResults(cp, _GetItemsForSearch(cp, elSearchBox.text));
        });
        cp.FindChildInLayoutFile('id-major-store-see-all-teams-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _SetActiveSeriesFilter(cp, NO_SERIES_FILTER);
            _ApplyViewSort(cp, VIEW_SORTS.AllItems);
            _ShowMainPanel(cp, VIEW_CONTENT);
            _SetActiveNavTab(cp, NAV_TAB_NONE);
        });
        cp.FindChildInLayoutFile('id-major-store-filters-panel').SetPanelEvent('onactivate', () => {
        });
        cp.FindChildInLayoutFile('id-major-store-search-results').SetPanelEvent('onactivate', () => {
        });
        const elFloatingFilterPanel = cp.FindChildInLayoutFile('id-major-fullscreen-filter');
        cp.FindChildInLayoutFile('id-major-store-content-page').SetAcceptsFocus(true);
        cp.FindChildInLayoutFile('id-major-store-container').SetPanelEvent('onactivate', () => _CloseSortDropDown(cp));
        cp.FindChildInLayoutFile('id-major-store-sort-filter-btn').SetPanelEvent('onactivate', () => {
            _UpdateFilterSections(cp);
            elFloatingFilterPanel.visible = true;
            _PushOverlay(cp, 'id-major-fullscreen-filter');
        });
        cp.FindChildInLayoutFile('id-major-fullscreen-filter-btn').SetPanelEvent('onactivate', () => {
            _PopOverlay();
        });
        cp.FindChildInLayoutFile('id-major-fullscreen-text-search-btn').SetPanelEvent('onactivate', () => {
            _PopOverlay();
        });
        cp.FindChildInLayoutFile('id-major-store-filters-close').SetPanelEvent('onactivate', () => {
            _PopOverlay();
        });
        function fnOnPropertyTransitionEndEvent(panel, propertyName) {
            if (elFloatingFilterPanel === panel && propertyName === 'opacity') {
                if (elFloatingFilterPanel.visible === true && !panel.BIsTransparent()) {
                    return true;
                }
                if (propertyName === 'opacity') {
                    if (elFloatingFilterPanel.visible === true && elFloatingFilterPanel.BIsTransparent()) {
                        elFloatingFilterPanel.visible = false;
                        return true;
                    }
                }
                return false;
            }
        }
        $.RegisterEventHandler('PropertyTransitionEnd', elFloatingFilterPanel, fnOnPropertyTransitionEndEvent);
        AddMajorTokensAnim.SetTransitionEndEvent(cp.FindChildInLayoutFile('id-major-store-add-tokens'));
        const elBookmark = cp.FindChildInLayoutFile('id-major-store-banners-bookmarks');
        $.RegisterEventHandler('PropertyTransitionEnd', elBookmark, (panel, propertyName) => {
            if (elBookmark.id === panel.id && propertyName === 'opacity') {
                if (!elBookmark.BHasClass('hidden') && elBookmark.BIsTransparent()) {
                    elBookmark.SetHasClass('hidden', true);
                    return true;
                }
            }
            return false;
        });
    }
    function _MakeDelayedLoadList(cp) {
        let lister = cp.FindChildInLayoutFile('id-major-store-items-lister');
        const btn = cp.FindChildInLayoutFile('id-list-large-icons');
        const selectedBtn = btn.GetSelectedButton();
        const snippetType = selectedBtn.GetAttributeString('data-type', '');
        if (lister && lister.IsValid() && snippetType == lister.GetAttributeString('data-type', '')) {
            _UpdateItemsList({ cp });
            return;
        }
        if (lister)
            lister.DeleteAsync(0);
        lister = $.CreatePanel('JSDelayLoadList', cp.FindChildInLayoutFile('id-major-store-content-page'), 'id-major-store-items-lister');
        lister.BLoadLayoutSnippet(snippetType);
        $.Schedule(.15, () => _UpdateItemsList({ cp }));
    }
    function _SetUpTitleBar(cp, eventId) {
        cp.SetDialogVariable('tournament_name', $.Localize('#CSGO_Tournament_Event_NameShort_' + eventId));
        cp.FindChildInLayoutFile('id-major-store-major-logo').SetImage('file://{images}/tournaments/events/tournament_logo_' + eventId + '.svg');
    }
    function _SetUpTeamsBanner(cp) {
        const teams = g_ActiveTournamentTeams;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-teams');
        teams.forEach(team => {
            const elPanel = $.CreatePanel('Button', elParent, '');
            elPanel.BLoadLayoutSnippet('banner-team-box');
            elPanel.FindChildInLayoutFile('id-team-icon').SetImage('file://{images}/tournaments/teams/' + team.team + '.svg');
            elPanel.FindChildInLayoutFile('id-team-icon-blur').SetImage('file://{images}/tournaments/teams/' + team.team + '.svg');
            elPanel.SetDialogVariable('name', $.Localize('#CSGO_TeamID_' + team.teamid));
            elPanel.style.backgroundPosition = Math.floor(Math.random() * 100) + '% 50%';
            elPanel.SetPanelEvent('onactivate', () => {
                _SetUpTeamView(cp, team);
                _ShowMainPanel(cp, VIEW_TEAM);
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_select', 'MOUSE');
            });
        });
    }
    function _GetOrCreatePanel(elParent, id, cls) {
        return elParent.FindChildInLayoutFile(id)
            ?? $.CreatePanel('Panel', elParent, id, { class: cls });
    }
    function _GetOrCreateTile(elParent, id, snippet, onCreate) {
        let elTile = elParent.FindChildInLayoutFile(id);
        if (!elTile) {
            elTile = $.CreatePanel('Panel', elParent, id);
            elTile.BLoadLayoutSnippet(snippet);
            onCreate?.(elTile);
        }
        return elTile;
    }
    function _PopulateCarousel(elParent, cfg) {
        for (let i = 0; i < cfg.numToShow; i++) {
            const nPage = Math.floor(i / cfg.numTilesPerPage);
            const elPage = _GetOrCreatePanel(elParent, 'id-major-store-carousel-page-' + nPage, cfg.pageClass);
            cfg.onUpdateTile(_GetOrCreateTile(elPage, cfg.tileIdPrefix + i, cfg.tileSnippet, cfg.onCreateTile), i);
        }
    }
    function _SetUpPopularityBanner(cp) {
        const aSorted = [...State(cp).aFlatStickersData].sort(_CompareByPopularity);
        _PopulateCarousel(cp.FindChildInLayoutFile('id-major-store-banner-popular'), {
            numToShow: 40,
            numTilesPerPage: 5,
            pageClass: 'popup-major-store__banner__popular_page elCarouselPage',
            tileIdPrefix: 'id-carousel-sticker',
            tileSnippet: 'banner-popular-entry',
            onUpdateTile: (elPanel, i) => {
                elPanel.SetDialogVariableInt('position', i + 1);
                _UpdateTile(cp, elPanel.FindChildInLayoutFile('id-popular-tile'), aSorted, i);
            },
        });
    }
    function _GetBookmarkedItemsList(cp) {
        const itemsMap = new Map();
        for (const sticker of State(cp).aFlatStickersData) {
            itemsMap.set(sticker.rawId.toString(), sticker);
        }
        for (const keyChain of State(cp).aFlatKeyChainData) {
            itemsMap.set(keyChain.kc_highlight.toString(), keyChain);
        }
        return Bookmarks.ids().map(defIndex => itemsMap.get(defIndex)).filter((item) => item !== undefined).reverse();
    }
    function _SetUpBookmarkItemsBanner(cp) {
        const aSorted = _GetBookmarkedItemsList(cp);
        if (aSorted.length < 1) {
            cp.FindChildInLayoutFile('id-major-store-banners-bookmarks').SetHasClass('show', false);
            return;
        }
        cp.FindChildInLayoutFile('id-major-store-banners-bookmarks').SetHasClass('show', true);
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-bookmarked');
        const numTilesPerPage = 8;
        const totalPages = Math.ceil(aSorted.length / numTilesPerPage);
        for (let i = 0; i < totalPages; i++) {
            let elCarouselPage = elParent.FindChildInLayoutFile('id-major-store-carousel-page-' + i);
            if (!elCarouselPage) {
                elCarouselPage = $.CreatePanel('Panel', elParent, 'id-major-store-carousel-page-' + i, { class: 'popup-major-store__banner__popular_page' });
                elCarouselPage.SetHasClass('small', true);
                elCarouselPage.SetHasClass('banner-bookmark', true);
            }
            const startIndex = i * numTilesPerPage;
            for (let j = 0; j < numTilesPerPage; j++) {
                let stickerIndex = startIndex + j;
                let elPanel = elCarouselPage.FindChildInLayoutFile('id-carousel-sticker' + stickerIndex);
                if (!elPanel) {
                    elPanel = $.CreatePanel('Panel', elCarouselPage, 'id-carousel-sticker' + stickerIndex);
                    elPanel.BLoadLayoutSnippet('store-tile');
                }
                if (aSorted[stickerIndex]) {
                    const bIsSticker = 'rawId' in aSorted[stickerIndex];
                    elPanel.SetHasClass('keychain', !bIsSticker);
                    if (bIsSticker)
                        _UpdateTile(cp, elPanel, aSorted, stickerIndex);
                    else
                        _UpdateKeyChainsTile(cp, elPanel, aSorted, stickerIndex);
                    elPanel.SetHasClass('hidden', false);
                    elPanel.enabled = true;
                    elPanel.hittest = true;
                }
                else {
                    elPanel.SetHasClass('keychain', false);
                    elPanel.SetHasClass('is-final', false);
                    elPanel.SetHasClass('hidden', true);
                    elPanel.enabled = false;
                    elPanel.hittest = false;
                }
            }
        }
        if (elParent.Children().length > totalPages) {
            const numPanelsToDelete = elParent.Children().length - totalPages;
            const numPagesMade = elParent.Children().length - 1;
            for (let i = numPagesMade; i > (numPagesMade - numPanelsToDelete); i--) {
                elParent.Children()[i].DeleteAsync(0);
            }
        }
    }
    function _UpdateBookmarkSetting(cp, reusePanel, defidx) {
        Bookmarks.toggle(defidx);
        _UpdateStoreNavTabs(cp);
        if (_IsHomeActive() || State(cp).useBookMarkList) {
            _UpdateVisiblePanel(cp, true);
        }
    }
    function _SetUpOrgBanners(cp) {
        cp.SetDialogVariable('org-name', g_ActiveTournamentInfo.organization);
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-org-stickers');
        const aFilteredStickers = State(cp).aFlatStickersData
            .filter(sticker => sticker.isOrg)
            .sort((a, b) => Number(b.isRanked) - Number(a.isRanked));
        aFilteredStickers.forEach((sticker, idx) => {
            let elPanel = elParent.FindChildInLayoutFile('id-org-sticker-' + idx);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elParent, 'id-org-sticker-' + idx);
                elPanel.BLoadLayoutSnippet('store-tile');
            }
            _UpdateTile(cp, elPanel, aFilteredStickers, idx);
        });
    }
    function _SetUpKeyChainsBanner(cp) {
        const aKeyChains = State(cp).aFlatKeyChainData;
        if (aKeyChains.length <= 1)
            return;
        let aKeyChainsForBanner = State(cp).aKeyChainBannerItems;
        if (!aKeyChainsForBanner || aKeyChainsForBanner.length < 1) {
            const itemsMap = new Map();
            for (const item of aKeyChains) {
                itemsMap.set(item.kc_highlight.toString(), item);
            }
            aKeyChainsForBanner = [];
            const numItemsFromEachStage = 9;
            g_ActiveTournamentHighlights.forEach(group => {
                if (group.highlights.length === 0)
                    return;
                const randomGen = new UniqueRandomUtils.UniqueRandomGenerator(0, group.highlights.length - 1);
                const count = Math.min(numItemsFromEachStage, group.highlights.length);
                for (let i = 0; i < count; i++) {
                    const nRandom = randomGen.next();
                    if (nRandom === null)
                        break;
                    const mapped = itemsMap.get(group.highlights[nRandom].kc_highlight.toString());
                    if (mapped)
                        aKeyChainsForBanner.push(mapped);
                }
            });
            for (let i = aKeyChainsForBanner.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [aKeyChainsForBanner[i], aKeyChainsForBanner[j]] = [aKeyChainsForBanner[j], aKeyChainsForBanner[i]];
            }
            State(cp).aKeyChainBannerItems = aKeyChainsForBanner;
        }
        _PopulateCarousel(cp.FindChildInLayoutFile('id-major-store-banner-keychains'), {
            numToShow: aKeyChainsForBanner.length,
            numTilesPerPage: 5,
            pageClass: 'popup-major-store__banner__popular_page',
            tileIdPrefix: 'id-carousel-keychain',
            tileSnippet: 'store-tile',
            onCreateTile: (elPanel) => {
                elPanel.SetHasClass('keychain', true);
                elPanel.SetHasClass('keychain-banner', true);
            },
            onUpdateTile: (elPanel, i) => _UpdateKeyChainsTile(cp, elPanel, aKeyChainsForBanner, i),
        });
    }
    function _SetUpChampionsBanner(cp) {
        const aChamps = [...State(cp).aFlatStickersData].sort(_CompareByPopularity).filter(sticker => sticker.champion);
        if (aChamps.length < 1)
            return;
        _PopulateCarousel(cp.FindChildInLayoutFile('id-major-store-banner-champions'), {
            numToShow: aChamps.length,
            numTilesPerPage: 8,
            pageClass: 'popup-major-store__banner__popular_page banner-bookmark small',
            tileIdPrefix: 'id-carousel-champs',
            tileSnippet: 'store-tile',
            onUpdateTile: (elPanel, i) => _UpdateTile(cp, elPanel, aChamps, i),
        });
    }
    const RANKED_ROW_RARITIES = [6, 5, 4];
    const RANKED_TILES_PER_ROW = 8;
    const RANKED_MAX_PAGES = 4;
    function _GetRankedRarityRows(cp) {
        const aRanked = State(cp).aFlatStickersData.filter(sticker => sticker.isRanked);
        return RANKED_ROW_RARITIES.map(nRarity => aRanked
            .filter(sticker => sticker.rarity === nRarity)
            .sort((a, b) => (b.price - a.price) || _CompareByPopularity(a, b)));
    }
    function _GetRankedPageCount(aRows) {
        const nLongestRow = Math.max(0, ...aRows.map(aRow => aRow.length));
        return Math.min(RANKED_MAX_PAGES, Math.ceil(nLongestRow / RANKED_TILES_PER_ROW));
    }
    function _FillRankedRarityRow(cp, elRow, aRow, nRarity, nPage) {
        const nStart = nPage * RANKED_TILES_PER_ROW;
        const aPageStickers = aRow.slice(nStart, nStart + RANKED_TILES_PER_ROW);
        for (let nSlot = 0; nSlot < RANKED_TILES_PER_ROW; nSlot++) {
            const elTile = _GetOrCreateTile(elRow, 'id-ranked-tile-' + nRarity + '-' + (nStart + nSlot), 'store-tile');
            const bHasSticker = nSlot < aPageStickers.length;
            elTile.visible = bHasSticker;
            if (bHasSticker)
                _UpdateTile(cp, elTile, aPageStickers, nSlot);
        }
    }
    function _SetUpRankedBanner(cp) {
        const aRows = _GetRankedRarityRows(cp);
        const nPages = _GetRankedPageCount(aRows);
        if (nPages < 1)
            return;
        const elCarousel = cp.FindChildInLayoutFile('id-major-store-banner-ranked');
        for (let nPage = 0; nPage < nPages; nPage++) {
            const elPage = _GetOrCreatePanel(elCarousel, 'id-major-store-carousel-page-' + nPage, 'popup-major-store__banner__popular_page banner-bookmark small rarity-rows');
            aRows.forEach((aRow, nRow) => {
                const nRarity = RANKED_ROW_RARITIES[nRow];
                const elRow = _GetOrCreatePanel(elPage, 'id-ranked-row-' + nRarity, 'popup-major-store__banner__rarity-row');
                elRow.visible = aRow.length > 0;
                _FillRankedRarityRow(cp, elRow, aRow, nRarity, nPage);
            });
        }
    }
    function _SetUpTeamView(cp, team) {
        const elPanel = cp.FindChildInLayoutFile(VIEW_TEAM);
        elPanel.Data().DisplayedTeam = team;
        const teamName = $.Localize('#CSGO_TeamID_' + team.teamid);
        elPanel.SetDialogVariable('team-name', teamName);
        const elTilesContainer = cp.FindChildInLayoutFile('id-major-store-team-tiles');
        const numTiles = 6;
        const randomGen = new UniqueRandomUtils.UniqueRandomGenerator(0, 7);
        for (let i = 0; i < numTiles; i++) {
            const elPackTile = elTilesContainer.FindChildInLayoutFile('sticker-pack-' + i);
            const elPackLabel = elPackTile.FindChildInLayoutFile('team-pack-major');
            elPackLabel.SetDialogVariableLocString('event-name', '#CSGO_Tournament_Event_Location_' + g_ActiveTournamentInfo.eventid);
            elPackLabel.text = $.Localize('#major_store_team_stickers-made', elPackLabel);
            const elBg = elPackTile.FindChildInLayoutFile('team-pack-bg-logo');
            elBg.SetImage('file://{images}/tournaments/teams/' + team.team + '.svg');
            elPackTile.SetDialogVariable('title', i === 0 ? teamName : team.players[i - 1].nick);
            elPackTile.SetHasClass('player', i > 0);
            const elStickerContainer = elPackTile.FindChildInLayoutFile('team-pack-icons');
            const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
            randomGen.reset();
            let xpos = 0;
            let prices = [];
            const stickers = i === 0 ?
                State(cp).aFlatStickersData.filter(sticker => (!sticker.isPlayer && sticker.teamId === team.teamid)) :
                State(cp).aFlatStickersData.filter(sticker => (sticker.isPlayer && sticker.playerCode === team.players[i - 1].code));
            stickers.forEach((id, idx) => {
                prices.push(stickers[idx].price);
                let sticker = elStickerContainer.FindChild('pack-sticker' + idx);
                if (!sticker)
                    sticker = $.CreatePanel('ItemImage', elStickerContainer, 'pack-sticker' + idx, { scaling: 'stretch-to-fit-preserve-aspect' });
                sticker.itemid = stickers[idx].itemId;
                const zIndex = randomGen.next() ?? (idx % 8);
                const rotationSetting = zIndex == 3 ? getRandomInt(-15, 15) : getRandomInt(-95, 85);
                if (idx % 4 === 0) {
                    xpos = 0;
                }
                sticker.style.transform = 'rotateZ(' + rotationSetting + 'deg) translateY(-' + getRandomInt(8, 30) + 'px) translateX(' + getRandomInt(xpos, xpos + 35) + 'px)';
                xpos = xpos + 50;
                sticker.style.zIndex = ((idx === stickers.length - 1) && (stickers[idx].champion)) ? '9;' : zIndex + ';';
                sticker.style.brightness = zIndex === 0 ? '.5' : zIndex === 1 ? '.7' : zIndex === 2 ? '.8' : zIndex === 3 ? '1.1' : '1';
            });
            elStickerContainer.Children().forEach((sticker, index) => { if (index >= stickers.length) {
                sticker.DeleteAsync(0);
            } });
            elPackTile.SetDialogVariableInt('low-price', Math.min(...prices));
            elPackTile.SetDialogVariableInt('high-price', Math.max(...prices));
            elPackTile.SetPanelEvent('onactivate', () => {
                _ShowMainPanel(cp, VIEW_SINGLE);
                _SetUpSingleView(cp, stickers);
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_select', 'MOUSE');
            });
        }
    }
    function _SetUpSingleView(cp, aStickers) {
        const elPanel = cp.FindChildInLayoutFile(VIEW_SINGLE);
        elPanel.SetDialogVariable('team-name', aStickers[0].isPlayer ? aStickers[0].playerCode : $.Localize('#CSGO_TeamID_' + aStickers[0].teamId));
        const numTiles = aStickers.length;
        const elParent = elPanel.FindChildInLayoutFile('id-major-store-single-tiles');
        for (let i = 0; i < numTiles; i++) {
            let elPackTile = elParent.FindChildInLayoutFile('sticker-single-' + i);
            if (!elPackTile) {
                elPackTile = $.CreatePanel('Panel', elParent, 'sticker-single-' + i);
                elPackTile.BLoadLayoutSnippet('store-tile');
            }
            _UpdateTile(cp, elPackTile, aStickers, i);
        }
        elParent.Children().forEach((sticker, index) => { if (index >= aStickers.length) {
            sticker.DeleteAsync(0);
        } });
        elPanel.Data().SingleViewDisplayedStickers = aStickers;
    }
    function _RefreshTeamView(cp) {
        const team = cp.FindChildInLayoutFile(VIEW_TEAM).Data().DisplayedTeam;
        if (team) {
            _SetUpTeamView(cp, team);
        }
    }
    function _RefreshSingleView(cp) {
        const aStickers = cp.FindChildInLayoutFile(VIEW_SINGLE).Data().SingleViewDisplayedStickers;
        if (aStickers) {
            _SetUpSingleView(cp, aStickers);
        }
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
    function _UpdateItemsList(oSettings) {
        if (_UpdateFavoritesEmptyState(oSettings.cp))
            return;
        const elParent = oSettings.cp.FindChildInLayoutFile('id-major-store-content-page');
        let elLister = elParent.FindChildInLayoutFile('id-major-store-items-lister');
        if (!elLister)
            return;
        const filteredList = _GetFilteredSortedIds(oSettings);
        elLister.SetLoadListItemFunction((elLister, nPanelIdx, reusePanel) => {
            const bIsSticker = 'rawId' in filteredList[nPanelIdx];
            if (!reusePanel || !reusePanel.IsValid()) {
                reusePanel = $.CreatePanel('Panel', elLister, '');
                reusePanel.BLoadLayoutSnippet('store-tile');
            }
            if (bIsSticker) {
                _UpdateTile(oSettings.cp, reusePanel, filteredList, nPanelIdx);
            }
            else {
                _UpdateKeyChainsTile(oSettings.cp, reusePanel, filteredList, nPanelIdx);
            }
            reusePanel.SetHasClass('keychain', !bIsSticker);
            return reusePanel;
        });
        elLister.UpdateListItems(filteredList.length);
        oSettings.cp.SetDialogVariableInt('item-count', filteredList.length);
        if (!oSettings.bDisableScroll)
            elLister.ScrollToTop();
    }
    function _ReadFilterSettings(cp) {
        const elDropDown = _SortDropDown(cp);
        const aTeams = _GetFilteredTeams(cp);
        const aRarities = _GetFilteredRarities(cp);
        const btnTeamOnly = cp.FindChildInLayoutFile('id-major-store-filter-team');
        const btnPlayerOnly = cp.FindChildInLayoutFile('id-major-store-filter-player');
        const btnRankedOnly = cp.FindChildInLayoutFile('id-major-store-filter-ranked');
        const btnChampionsOnly = cp.FindChildInLayoutFile('id-major-store-filter-champions');
        const btnMajorOnly = cp.FindChildInLayoutFile('id-major-store-filter-major');
        const btnKeyChainsOnly = cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn');
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        const selectedSort = elDropDown.GetSelected();
        const sortOption = SORT_OPTIONS[selectedSort ? selectedSort.id : ''] ?? SORT_OPTIONS['weekly-high-low'];
        const sortType = sortOption.field;
        const sortDirection = sortOption.direction;
        return btnKeyChainsOnly.checked
            ? {
                selectedTeamIds: [],
                sort: sortType,
                rarity: [],
                teamsOnly: false,
                playersOnly: false,
                keyChainsOnly: true,
                rankedOnly: false,
                championsOnly: false,
                majorOnly: false,
                sortDirection: sortDirection,
                searchText: elSearchBox.text
            }
            : {
                selectedTeamIds: aTeams.flatMap(team => team.Data().teamid),
                sort: sortType,
                rarity: aRarities.flatMap(panel => panel.Data().rarity),
                teamsOnly: btnTeamOnly.checked,
                playersOnly: btnPlayerOnly.checked,
                keyChainsOnly: false,
                rankedOnly: btnRankedOnly.checked,
                championsOnly: btnChampionsOnly.checked,
                majorOnly: btnMajorOnly.checked,
                sortDirection: sortDirection,
                searchText: elSearchBox.text
            };
    }
    function _RenderActiveFilterChips(cp) {
        let numFiltersSelected = 0;
        const elNavBarFiltersParent = cp.FindChildInLayoutFile('id-major-store-filters-active');
        elNavBarFiltersParent.Children().forEach(btn => btn.DeleteAsync(0));
        const fnAddChip = (elToggle, loc, chipId) => {
            if (!elToggle || !elToggle.checked || !elToggle.enabled) {
                return;
            }
            numFiltersSelected++;
            _MakeNavBarFilterButton(cp, elNavBarFiltersParent, elToggle, loc, chipId);
        };
        _GetFilteredTeams(cp).forEach(btn => fnAddChip(btn, '#CSGO_TeamID_' + btn.Data().teamid, 'id-filter-active-r-' + btn.Data().teamid));
        _GetFilteredRarities(cp).forEach(btn => fnAddChip(btn, '#major_store_filter_type_' + btn.Data().rarity, 'id-filter-active-r-' + btn.Data().rarity));
        REFINEMENT_FILTERS.forEach(f => fnAddChip(cp.FindChildInLayoutFile(f.toggleId), f.loc, f.chipId));
        if (_IsMixedContentView(cp)) {
            SERIES_FILTERS.forEach(f => fnAddChip(cp.FindChildInLayoutFile(f.toggleId), f.loc, f.chipId));
        }
        fnAddChip(cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn'), '#major_store_filter_type_keychains_only', 'id-filter-active-k-only');
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        if (elSearchBox.text) {
            numFiltersSelected++;
            const elActiveFilterBtn = $.CreatePanel('Button', elNavBarFiltersParent, 'id-filter-active-search-txt');
            elActiveFilterBtn.BLoadLayoutSnippet('active-filter-button');
            elActiveFilterBtn.SetDialogVariable('search-text', elSearchBox.text);
            elActiveFilterBtn.SetDialogVariable('name', $.Localize('#major_store_filter_type_search_text', elActiveFilterBtn));
            elNavBarFiltersParent.MoveChildBefore(elActiveFilterBtn, elNavBarFiltersParent.Children()[0]);
            elActiveFilterBtn.SetPanelEvent('onactivate', () => {
                _ClearTextSearch(cp);
                _UpdateItemsList({ cp });
                elActiveFilterBtn.DeleteAsync(0);
            });
        }
        cp.FindChildInLayoutFile('id-filter-active-clear_all').visible = numFiltersSelected > 1;
        cp.FindChildInLayoutFile('id-major-store-filters-clear').visible = numFiltersSelected > 1;
    }
    function _MakeNavBarFilterButton(cp, elParent, selectedFilterBtn, locString, idForBtn) {
        const elActiveFilterBtn = $.CreatePanel('Button', elParent, idForBtn);
        elActiveFilterBtn.BLoadLayoutSnippet('active-filter-button');
        elActiveFilterBtn.SetDialogVariable('name', $.Localize(locString, selectedFilterBtn));
        elActiveFilterBtn.SetPanelEvent('onactivate', () => {
            selectedFilterBtn.checked = false;
            if (elActiveFilterBtn.id === 'id-filter-active-k-only') {
                _EnableDisableFilterPanelBtns(cp, false);
            }
            _UpdateItemsList({ cp });
            elActiveFilterBtn.DeleteAsync(0);
        });
    }
    function _OnActivateClearAll(cp, doNotClearSearch = false) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        elFilterPanel.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn').checked = false;
        elFilterPanel.FindChildrenWithAttributeTraverse('filter-button').forEach(btn => { btn.checked = false, btn.enabled = true; });
        State(cp).useBookMarkList = false;
        if (!doNotClearSearch) {
            _ClearTextSearch(cp);
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
                    elTile.BLoadLayoutSnippet('store-tile');
                    elTile.SetHasClass('keychain', true);
                    elTile.SetHasClass('keychain-banner', true);
                }
                _UpdateKeyChainsTile(cp, elTile, keyChains, idx);
            });
        }
    }
    function _UpdateTile(cp, reusePanel, filteredList, nPanelIdx) {
        const stickerData = filteredList[nPanelIdx];
        reusePanel.SetDialogVariable('title', stickerData.isPlayer ?
            stickerData.playerCode :
            stickerData.isOrg ?
                g_ActiveTournamentInfo.organization :
                stickerData.teamName);
        _UpdatePriceAnimOnTile(stickerData, reusePanel, cp);
        _SetPriceDataOnTile(stickerData, reusePanel);
        _ShoppingCartControlsOnTile(stickerData, reusePanel);
        _UpdateBookmarkOnTile(stickerData.rawId, reusePanel, cp);
        reusePanel.FindChildInLayoutFile('id-store-item-rarity').SetImage('file://{images}/icons/ui/sticker_rarity_' + stickerData.rarity + '.svg');
        reusePanel.SwitchClass('rarity', 'rarity-' + stickerData.rarity);
        reusePanel.SwitchClass('sticker-type', stickerData.champion ? 'champion' : stickerData.isRanked ? 'ranked' : '');
        reusePanel.FindChildInLayoutFile('id-store-item-rarity-bar').style.washColor = InventoryAPI.GetItemRarityColor(stickerData.itemId);
        reusePanel.SetHasClass('is-final', false);
        reusePanel.FindChildInLayoutFile('id-store-item-hot-trend').SetHasClass('show', stickerData.popularityRank < 40);
        reusePanel.SetHasClass('is-player', stickerData.isPlayer);
        reusePanel.FindChildInLayoutFile('id-store-item-image').itemid = stickerData.itemId;
        reusePanel.FindChildInLayoutFile('id-store-item-team-logo').SetImage(stickerData.isOrg ?
            'file://{images}/tournaments/events/tournament_logo_' + g_ActiveTournamentInfo.eventid + '.svg' :
            'file://{images}/tournaments/teams/' + stickerData.teamTag + '.svg');
        reusePanel.SetPanelEvent('onmouseover', () => {
            _MakeModelPanel(reusePanel, stickerData.itemId);
            reusePanel.FindChildInLayoutFile('id-store-item-real-price').SetHasClass('show', stickerData.price >= 100);
            reusePanel.SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, stickerData.price, ''));
        });
        reusePanel.SetPanelEvent('onmouseout', () => {
            reusePanel.FindChildInLayoutFile('id-store-item-real-price').SetHasClass('show', false);
            _DeleteModelPanel(reusePanel);
        });
        _RebindOpenModelPanel(reusePanel, stickerData.itemId);
        reusePanel.FindChildInLayoutFile('id-inspect-sticker').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(cp, stickerData);
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
        _UpdatePriceAnimOnTile(keychainData, reusePanel, cp);
        _SetPriceDataOnTile(keychainData, reusePanel);
        _ShoppingCartControlsOnTile(keychainData, reusePanel);
        _UpdateBookmarkOnTile(keychainData.kc_highlight, reusePanel, cp);
        reusePanel.FindChildInLayoutFile('id-store-item-hot-trend').SetHasClass('show', false);
        reusePanel.SetHasClass('is-player', false);
        reusePanel.SetHasClass('is-final', keychainData.stage === 97);
        reusePanel.SetDialogVariable('stage', $.Localize('#CSGO_Tournament_Event_Stage_' + keychainData.stage));
        reusePanel.FindChildInLayoutFile('id-store-item-image').itemid = keychainData.itemId;
        reusePanel.FindChildInLayoutFile('id-store-item-team-1').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid1) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-2').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid2) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-bg-1').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid1) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-bg-2').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid2) + '.svg');
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
            reusePanel.FindChildInLayoutFile('id-store-item-real-price').SetHasClass('show', keychainData.price >= 100);
            reusePanel.SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, keychainData.price, ''));
        });
        reusePanel.SetPanelEvent('onmouseout', () => {
            if (jsTooltipDelayHandle) {
                $.CancelScheduled(jsTooltipDelayHandle);
                jsTooltipDelayHandle = null;
            }
            reusePanel.FindChildInLayoutFile('id-store-item-real-price').SetHasClass('show', false);
            _HideVideoClip(reusePanel, keychainData.itemId);
        });
        _DeleteModelPanel(reusePanel);
        if (reusePanel.FindChildTraverse('id-store-item-movie-container')?.BHasClass('play'))
            _ShowVideoClip(reusePanel, keychainData.itemId);
        reusePanel.FindChildInLayoutFile('id-inspect-sticker').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(cp, keychainData);
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
    function _UpdatePriceAnimOnTile(stickerData, reusePanel, cp) {
        const elChange = reusePanel.FindChildInLayoutFile('id-store-item-price-change');
        const bIsRanked = ('isRanked' in stickerData) && stickerData.isRanked;
        const bPriceChanged = !bIsRanked
            && stickerData.oldPrice !== undefined
            && stickerData.oldPrice !== stickerData.price;
        if (!bPriceChanged) {
            reusePanel.SetHasClass('price-reveal', false);
            elChange.SetHasClass('show-change', false);
            return;
        }
        reusePanel.SetDialogVariableInt('price-change', Math.abs(stickerData.price - stickerData.oldPrice));
        elChange.SwitchClass('direction', stickerData.price > stickerData.oldPrice ? 'higher' : 'lower');
        const bFirstReveal = !State(cp).stopTileUpdate && !stickerData.priceChangeRevealed;
        if (bFirstReveal) {
            stickerData.priceChangeRevealed = true;
        }
        reusePanel.SetHasClass('price-reveal', bFirstReveal);
        elChange.SetHasClass('show-change', true);
    }
    function _SetPriceDataOnTile(stickerData, reusePanel) {
        reusePanel.SetDialogVariableInt('price', stickerData.price);
        reusePanel.FindChildInLayoutFile('id-store-item-price').text = ('isRanked' in stickerData && stickerData.isRanked) ? $.Localize('#major_store_price_locked', reusePanel) : $.Localize('#major_store_price', reusePanel);
        reusePanel.SetDialogVariableInt('weeklyLow', stickerData.weeklyLow);
        reusePanel.SetDialogVariableInt('weeklyHigh', stickerData.weeklyHigh);
        let posDot = (stickerData.weeklyHigh > stickerData.weeklyLow)
            ? ((stickerData.price - stickerData.weeklyLow) / (stickerData.weeklyHigh - stickerData.weeklyLow)) * 100
            : 100;
        posDot = Math.floor(Math.max(0, Math.min(96, posDot)));
        reusePanel.FindChildInLayoutFile('id-store-item-price-pos').style.transform = 'translateX(' + posDot + '%)';
    }
    function _ShoppingCartControlsOnTile(stickerData, reusePanel) {
        const shopItem = { id: stickerData.itemId, name: stickerData.displayName, price: stickerData.price, oldPrice: stickerData.oldPrice };
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
    function _UpdateBookmarkOnTile(defidx, reusePanel, cp) {
        const elBookmark = reusePanel.FindChildInLayoutFile('id-store-item-bookmark');
        elBookmark.checked = Bookmarks.has(defidx);
        elBookmark.SetPanelEvent('onactivate', () => {
            _UpdateBookmarkSetting(cp, reusePanel, defidx);
        });
    }
    function _OpenFullscreenInspect(cp, itemData) {
        function _Callback() {
            Bookmarks.invalidate();
            _UpdateVisiblePanel(cp, true);
        }
        ;
        const callback = _TrackJSCallback(cp, UiToolkitAPI.RegisterJSCallback(_Callback));
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: itemData.itemId,
            inspect_only: true,
            hide_all_action_items: true,
            price_in_tokens: itemData.price,
            sticker_def_index: 'rawId' in itemData ? itemData.rawId : itemData.kc_highlight,
            callback_handle: callback
        };
        elPanel.Data().oSettings = oSettings;
    }
    function _GetFilteredSortedIds(oSettings) {
        let aFilteredStickers;
        const cp = oSettings.cp;
        _RenderActiveFilterChips(cp);
        const FilterSortSettings = _ReadFilterSettings(cp);
        const btnKeyChainsToggle = cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn');
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        if (elSearchBox.text) {
            const searchResults = _GetItemsForSearch(cp, elSearchBox.text);
            aFilteredStickers = btnKeyChainsToggle.checked ? searchResults.keychainResults : searchResults.stickerResults;
        }
        else if (State(cp).useBookMarkList) {
            aFilteredStickers = _GetBookmarkedItemsList(cp);
        }
        else {
            aFilteredStickers = btnKeyChainsToggle.checked ? State(cp).aFlatKeyChainData : State(cp).aFlatStickersData;
        }
        aFilteredStickers = aFilteredStickers.filter(s => _MatchesSeriesFilter(s, FilterSortSettings));
        if (FilterSortSettings.selectedTeamIds.length > 0) {
            aFilteredStickers = aFilteredStickers.filter(sticker => FilterSortSettings.selectedTeamIds.includes(sticker.teamId));
        }
        if (FilterSortSettings.playersOnly || FilterSortSettings.teamsOnly || FilterSortSettings.keyChainsOnly) {
            aFilteredStickers = aFilteredStickers.filter(sticker => (('kc_highlight' in sticker) && FilterSortSettings.keyChainsOnly) ||
                (!('kc_highlight' in sticker) && sticker.isPlayer && FilterSortSettings.playersOnly) ||
                (!('kc_highlight' in sticker) && !sticker.isPlayer && FilterSortSettings.teamsOnly));
        }
        if (FilterSortSettings.rarity.length > 0) {
            aFilteredStickers = aFilteredStickers.filter(sticker => FilterSortSettings.rarity.includes(sticker.rarity));
        }
        const nSortDirection = ((FilterSortSettings.sortDirection === 'asc') ? 1 : -1);
        const filterSetting = FilterSortSettings.sort;
        return [...aFilteredStickers].sort((a, b) => {
            let aField = a[filterSetting];
            let bField = b[filterSetting];
            if (filterSetting === 'name') {
                aField = aField.toLowerCase();
                bField = bField.toLowerCase();
            }
            if (aField != bField) {
                return ((aField < bField) ? -1 : 1) * nSortDirection;
            }
            return _CompareByPopularity(a, b);
        });
    }
    function _GetFilteredTeams(cp) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        let elTeams = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-section-teams');
        return [...elTeams.Children().filter(panel => panel.checked && panel.enabled)];
    }
    function _GetFilteredRarities(cp) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        let elRarities = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-rarities');
        return elRarities.Children().filter(panel => panel.checked && panel.enabled);
    }
    function _SetUpFilterPanel(cp) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        g_ActiveTournamentTeams.forEach((team, i) => {
            const elParent = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-section-teams');
            let elTeam = elParent.FindChildInLayoutFile(g_ActiveTournamentTeams[i].team);
            if (!elTeam) {
                elTeam = $.CreatePanel('ToggleButton', elParent, g_ActiveTournamentTeams[i].team);
                elTeam.BLoadLayoutSnippet('filter-team-btn');
                elTeam.Data().team = g_ActiveTournamentTeams[i].team;
                elTeam.Data().teamid = g_ActiveTournamentTeams[i].teamid;
                elTeam.SetAttributeString('filter-button', 'true');
                elTeam.FindChildInLayoutFile('id-filter-icon').SetImage('file://{images}/tournaments/teams/' + g_ActiveTournamentTeams[i].team + '.svg');
                elTeam.FindChildInLayoutFile('id-filter-icon-blur').SetImage('file://{images}/tournaments/teams/' + g_ActiveTournamentTeams[i].team + '.svg');
            }
        });
        const aRarities = [3, 4, 5, 6];
        aRarities.forEach((r, index) => {
            const rarityBtn = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-rarity-' + r);
            if (rarityBtn) {
                rarityBtn.SetDialogVariable('rarity', $.Localize('#major_store_filter_type_' + r));
                rarityBtn.FindChildInLayoutFile('id-filter-icon').SetImage('file://{images}/icons/ui/sticker_rarity_' + r + '.svg');
                rarityBtn.FindChildInLayoutFile('id-filter-icon-blur').SetImage('file://{images}/icons/ui/sticker_rarity_' + r + '.svg');
                rarityBtn.Data().rarity = r;
            }
        });
        const fnRefilter = () => _UpdateItemsList({ cp });
        elFilterPanel.FindChildrenWithAttributeTraverse('filter-button').forEach(btn => btn.SetPanelEvent('onactivate', fnRefilter));
        SERIES_FILTERS.forEach(series => elFilterPanel.FindChildInLayoutFile(series.toggleId).SetPanelEvent('onactivate', fnRefilter));
        const btnKeyChainsOnly = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn');
        btnKeyChainsOnly.SetDialogVariable('slide_toggle_text', $.Localize('#major_store_filter_info_keychains'));
        btnKeyChainsOnly.SetPanelEvent('onactivate', () => {
            _EnableDisableFilterPanelBtns(cp, btnKeyChainsOnly.checked);
            _UpdateItemsList({ cp });
        });
        const elClearBtn = elFilterPanel.FindChildInLayoutFile('id-major-store-filters-clear');
        elClearBtn.SetDialogVariable('name', $.Localize('#major_store_filter_type_clear_all'));
        elClearBtn.SetPanelEvent('onactivate', () => _ClearAllFilters(cp));
        const elClearAllNavBtn = cp.FindChildInLayoutFile('id-filter-active-clear_all');
        elClearAllNavBtn.SetDialogVariable('name', $.Localize('#major_store_filter_type_clear_all'));
        elClearAllNavBtn.AddClass('clear-all');
        elClearAllNavBtn.visible = false;
        elClearAllNavBtn.SetPanelEvent('onactivate', () => {
            _ClearAllFilters(cp);
            elClearAllNavBtn.visible = false;
        });
    }
    function _ClearAllFilters(cp) {
        if (_IsMixedContentView(cp)) {
            _SetActiveSeriesFilter(cp, NO_SERIES_FILTER);
        }
        _OnActivateClearAll(cp);
        _UpdateItemsList({ cp });
    }
    function _EnableDisableFilterPanelBtns(cp, btnKeyChainsOnly) {
        cp.FindChildrenWithClassTraverse('major-filter-panel__toggle').forEach(btn => {
            btn.enabled = !btnKeyChainsOnly;
        });
        _ApplyViewSort(cp, State(cp).activeSort);
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
        const szResults = $.Localize('#major_store_nav_tab_ranked').toLowerCase();
        return stickers.map(sticker => {
            let totalScore = 0;
            const nick = sticker.playerCode.toLowerCase();
            const tag = (sticker.teamTag) ? sticker.teamTag.toLowerCase() : '';
            const rarity = sticker.rarityLookup.toLowerCase();
            const team = (sticker.teamName) ? sticker.teamName.toLowerCase() : '';
            const real = (sticker.realName) ? sticker.realName.toLowerCase() : '';
            const name = (sticker.name) ? sticker.name.toLowerCase() : '';
            const category = (sticker.champion ? szChampions + ' ' : '')
                + (sticker.isRanked ? szResults : '')
                + (!sticker.champion && !sticker.isRanked ? szMajor : '');
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
    function _ShowSearchResults(cp, oItems) {
        const elTextSearchFlyout = cp.FindChildInLayoutFile('id-major-fullscreen-text-search');
        const elResultsPanel = elTextSearchFlyout.FindChildInLayoutFile('id-search-list');
        elResultsPanel.Children().forEach(result => result.DeleteAsync(0));
        const sections = [
            { id: 'id-results-stickers', items: oItems.stickerResults },
            { id: 'id-results-keychains', items: oItems.keychainResults },
        ];
        if (sections.every(s => s.items.length < 1)) {
            _PopOverlay();
            return;
        }
        State(cp).useBookMarkList = false;
        _PushOverlay(cp, 'id-major-fullscreen-text-search');
        let bNeedSeparator = false;
        sections.forEach(section => {
            if (section.items.length < 1)
                return;
            if (bNeedSeparator)
                $.CreatePanel('Panel', elResultsPanel, '', { class: 'major-search-results__section__separator' });
            bNeedSeparator = true;
            const elSection = $.CreatePanel('Panel', elResultsPanel, section.id, { class: 'major-search-results__section' });
            _MakeShowSearchResultsBtn(cp, elSection, section.items.length);
            const elListParent = $.CreatePanel('Panel', elSection, '', { class: 'major-search-results__list' });
            section.items.slice(0, MAX_SEARCH_RESULTS_SHOWN).forEach(item => _MakeSearchTile(cp, elListParent, item));
        });
    }
    function _MakeShowSearchResultsBtn(cp, elSection, count) {
        const elPanel = $.CreatePanel('Button', elSection, '');
        elPanel.SetDialogVariableInt('results-count', count);
        elPanel.BLoadLayoutSnippet('search-result-show-all');
        elPanel.SetDialogVariable('search-text', cp.FindChildInLayoutFile('id-major-store-search-box').text);
        const bIsKeychains = elSection.id === 'id-results-keychains';
        elPanel.FindChildInLayoutFile('id-results-btn-label').text = $.Localize(bIsKeychains ? '#major_store_search_see_all_keychains' : '#major_store_search_see_all_stickers', elPanel);
        elPanel.SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp, true);
            _PopOverlay();
            cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn').checked = bIsKeychains;
            _EnableDisableFilterPanelBtns(cp, bIsKeychains);
            _SetActiveSeriesFilter(cp, NO_SERIES_FILTER);
            _ApplyViewSort(cp, VIEW_SORTS.Search);
            _ShowMainPanel(cp, VIEW_CONTENT);
            _SetActiveNavTab(cp, NAV_TAB_NONE);
        });
    }
    function _MakeSearchTile(cp, elSection, item) {
        const bIsSticker = ('rawId' in item);
        const elTile = $.CreatePanel('Button', elSection, '');
        elTile.BLoadLayoutSnippet('search-result');
        elTile.FindChildInLayoutFile('id-result-icon').itemid = item.itemId;
        item.displayName.SetOnLabel(elTile.FindChildInLayoutFile('id-result-name'));
        elTile.SetDialogVariableInt('price', item.price);
        elTile.FindChildInLayoutFile('id-result-inspect').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(cp, item);
            _PopOverlay();
        });
        const elBookmark = elTile.FindChildInLayoutFile('id-store-item-bookmark');
        elBookmark.checked = Bookmarks.has(bIsSticker ? item.rawId : item.kc_highlight);
        elBookmark.SetPanelEvent('onactivate', () => {
            _UpdateBookmarkSetting(cp, elTile, bIsSticker ? item.rawId : item.kc_highlight);
        });
    }
    function OnSearchContextMenuCallBack(msg) {
    }
    function _ShowCategoryList(cp, filterToggleId, sort) {
        _OnActivateClearAll(cp);
        _SetActiveSeriesFilter(cp, filterToggleId);
        _ApplyViewSort(cp, sort);
        _ShowMainPanel(cp, VIEW_CONTENT);
    }
    function _IsFavoritesEmpty(cp) {
        return State(cp).useBookMarkList && _GetBookmarkedItemsList(cp).length < 1;
    }
    function _UpdateFavoritesEmptyState(cp) {
        const bEmpty = _IsFavoritesEmpty(cp);
        cp.FindChildInLayoutFile('id-major-store-bookmark-hint').SetHasClass('hidden', !bEmpty);
        cp.FindChildInLayoutFile('id-major-store-content-controls').visible = !bEmpty;
        const elLister = cp.FindChildInLayoutFile('id-major-store-items-lister');
        if (elLister)
            elLister.visible = !bEmpty;
        return bEmpty;
    }
    function _RefreshCarousels(cp) {
        STORE_CAROUSELS.forEach(carousel => {
            const elBanner = cp.FindChildInLayoutFile(carousel.bannerId);
            if (elBanner)
                elBanner.SetHasClass('hidden', !carousel.hasItems(cp));
            carousel.refresh(cp);
        });
    }
    function _RefreshHome(cp) {
        _RefreshCarousels(cp);
        _UpdateStoreNavTabs(cp);
    }
    function _SetUpCarouselSeeAllButtons(cp) {
        STORE_CAROUSELS.forEach(carousel => {
            if (carousel.navTabKey && !STORE_NAV_TABS.some(tab => tab.key === carousel.navTabKey)) {
            }
            const elSeeAll = cp.FindChildInLayoutFile(carousel.seeAllBtnId);
            if (!elSeeAll)
                return;
            elSeeAll.SetPanelEvent('onactivate', () => {
                carousel.onSeeAll(cp);
                if (carousel.navTabKey)
                    _SetActiveNavTab(cp, carousel.navTabKey);
            });
        });
    }
    function _SetUpStoreNavTabs(cp) {
        const elParent = cp.FindChildInLayoutFile('id-major-store-nav-tabs-container');
        STORE_NAV_TABS.forEach((tab, i) => {
            if (STORE_NAV_TABS.findIndex(t => t.key === tab.key) !== i) {
            }
            let elTab = elParent.FindChild(tab.key);
            if (!elTab) {
                elTab = $.CreatePanel('RadioButton', elParent, tab.key, {
                    group: 'store_nav',
                    class: 'content-navbar__tabs__btn left-right-flow',
                });
                $.CreatePanel('Label', elTab, tab.key + '-label', { text: $.Localize(tab.loc) });
            }
            elTab.SetPanelEvent('onactivate', () => {
                if (m_bSyncingNavTabs)
                    return;
                tab.activate(cp);
                _SetActiveNavTab(cp, tab.key);
            });
        });
        cp.FindChildInLayoutFile('id-major-store-nav-home').SetPanelEvent('onactivate', () => {
            if (m_bSyncingNavTabs)
                return;
            StoreNavActions.Home(cp);
        });
        _UpdateStoreNavTabs(cp);
    }
    function _UpdateStoreNavTabs(cp) {
        const elParent = cp.FindChildInLayoutFile('id-major-store-nav-tabs-container');
        STORE_NAV_TABS.forEach(tab => {
            const elTab = elParent.FindChild(tab.key);
            if (!elTab) {
                return;
            }
            elTab.visible = tab.isAvailable(cp);
            const elLabel = elTab.FindChild(tab.key + '-label');
            if (elLabel && tab.label) {
                elLabel.text = tab.label(cp, elLabel);
            }
        });
    }
    function _SetActiveNavTab(cp, key) {
        const elParent = cp.FindChildInLayoutFile('id-major-store-nav-tabs-container');
        const elHome = cp.FindChildInLayoutFile('id-major-store-nav-home');
        m_bSyncingNavTabs = true;
        let bMatched = (key === 'home');
        elHome.checked = bMatched;
        STORE_NAV_TABS.forEach(tab => {
            const elTab = elParent.FindChild(tab.key);
            if (!elTab)
                return;
            elTab.checked = (tab.key === key);
            bMatched = bMatched || elTab.checked;
        });
        m_bSyncingNavTabs = false;
        if (!bMatched && key !== NAV_TAB_NONE) {
        }
    }
    function _FindView(viewId) {
        return STORE_VIEWS.find(view => view.id === viewId);
    }
    function _ActiveView() {
        return (m_activeMain && m_activeMain.IsValid()) ? _FindView(m_activeMain.id) : undefined;
    }
    function _IsHomeActive() {
        return _ActiveView()?.id === VIEW_HOME;
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
                view.onShow?.(cp);
                elNext.TriggerClass('panel-reveal');
            }
            return;
        }
        if (view.navTabKey) {
            _SetActiveNavTab(cp, view.navTabKey);
        }
        view.onShow?.(cp);
        if (m_activeMain && m_activeMain.IsValid()) {
            m_activeMain.AddClass('hidden');
        }
        elNext.RemoveClass('hidden');
        elNext.TriggerClass('panel-reveal');
        m_activeMain = elNext;
        _UpdateFooterButtons(cp);
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
    }
    function _GoBack(cp) {
        const szBackTarget = _ActiveView()?.backTarget;
        if (szBackTarget) {
            _ShowMainPanel(cp, szBackTarget);
        }
        else {
            StoreNavActions.Home(cp);
        }
    }
    function _UpdateFooterButtons(cp) {
        const bHome = _IsHomeActive();
        cp.FindChildInLayoutFile('id-popup-major-store-close-btn').visible = bHome;
        cp.FindChildInLayoutFile('id-popup-major-store-back-btn').visible = !bHome;
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
        if (_ActiveView() && !_IsHomeActive()) {
            _GoBack($.GetContextPanel());
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
        cp.RegisterForReadyEvents(true);
        if (cp.BReadyForDisplay()) {
            ReadyForDisplay();
        }
    }
})(PopupMajorStore || (PopupMajorStore = {}));
