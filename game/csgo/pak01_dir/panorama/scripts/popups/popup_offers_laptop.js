"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="popup_acknowledge_item.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="popup_inspect_async-bar.ts" />
/// <reference path="popup_inspect_header.ts" />
/// <reference path="popup_acknowledge_item.ts" />
/// <reference path="popup_offers_laptop_interface.ts" />
var OffersLaptop;
(function (OffersLaptop) {
    let m_aItemsInLootlist = [];
    let m_itemid = '';
    let m_isOpen = false;
    let m_InspectPanel = $.GetContextPanel();
    let m_unusualItemImagePath = '';
    let m_showInspectScheduleHandle = null;
    let m_specialItemId = 'id-special-item';
    let m_elCaseModelImagePanel = null;
    let m_bReadyForDisplay = false;
    let m_LoopingSounds = {};
    function LaptopSoundPlayOnce(s) {
        if (!m_bReadyForDisplay)
            return;
        $.DispatchEvent("CSGOPlaySoundEffect", s, "MOUSE");
    }
    OffersLaptop.LaptopSoundPlayOnce = LaptopSoundPlayOnce;
    function LaptopSoundStartLooping(s) {
        if (!m_bReadyForDisplay)
            return;
        if (!s)
            return;
        if (m_LoopingSounds[s] !== undefined)
            return;
        m_LoopingSounds[s] = UiToolkitAPI.PlaySoundEvent(s);
    }
    OffersLaptop.LaptopSoundStartLooping = LaptopSoundStartLooping;
    function LaptopSoundStopLooping(s) {
        if (!s)
            return;
        if (m_LoopingSounds[s] === undefined)
            return;
        UiToolkitAPI.StopSoundEvent(m_LoopingSounds[s], 0);
        m_LoopingSounds[s] = undefined;
    }
    OffersLaptop.LaptopSoundStopLooping = LaptopSoundStopLooping;
    function _OnHandleReadyForDisplay(b) {
        m_bReadyForDisplay = b;
        if (!m_bReadyForDisplay) {
            for (const s in m_LoopingSounds)
                LaptopSoundStopLooping(s);
        }
    }
    function Init() {
        m_itemid = InspectShared.GetPopupSetting('item_id');
        m_InspectPanel.RegisterForReadyEvents(true);
        m_bReadyForDisplay = m_InspectPanel.BReadyForDisplay();
        $.RegisterEventHandler('ReadyForDisplay', m_InspectPanel, _OnHandleReadyForDisplay.bind(undefined, true));
        $.RegisterEventHandler('UnreadyForDisplay', m_InspectPanel, _OnHandleReadyForDisplay.bind(undefined, false));
        m_InspectPanel.SetReadyForDisplay(true);
        if (!m_itemid || !InventoryAPI.IsValidItemID(m_itemid)) {
            ClosePopUp();
        }
        LaptopSoundPlayOnce('UI.Laptop.Inspect');
        if (m_itemid && ItemInfo.ItemHasCapability(m_itemid, 'decodable') &&
            !!InventoryAPI.GetItemAttributeValue(m_itemid, '{uint32}volatile container') &&
            InventoryAPI.IsRental(m_itemid) &&
            (InventoryAPI.GetItemQuality(m_itemid) === 14)) {
            _SetUpOpenLaptop(m_itemid);
        }
        else {
            _SetUpClosedLaptop();
        }
    }
    OffersLaptop.Init = Init;
    function _SetUpClosedLaptop() {
        InspectShared.SetPopupSetting('is_keyless', true);
        InspectShared.SetPopupSetting('show_work_type_warning', true);
        InspectShared.SetPopupSetting('override_async_bar_desc', true);
        InspectAsyncActionBar.Init();
        CapabilityHeader.Init();
        _SetCaseModelImage(m_itemid, 'PopUpInspectModelOrImage');
        _SetLootListItems(m_itemid);
    }
    function _SetCaseModelImage(caseId, PanelId) {
        let elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile(PanelId);
        elItemModelImagePanel.Data().isLapTopOpening = m_isOpen;
        InspectModelImage.Init(elItemModelImagePanel, caseId);
        m_elCaseModelImagePanel = InspectModelImage.GetModelPanel();
    }
    function _SetLootListItems(itemId) {
        let count = InventoryAPI.GetLootListItemsCount(itemId);
        let elLootList = $.GetContextPanel().FindChildInLayoutFile('DecodableLootlist');
        if (count === 0) {
            _ShowHideLootList(false);
            return;
        }
        if (m_elCaseModelImagePanel && m_elCaseModelImagePanel.IsValid() && m_elCaseModelImagePanel.id === 'ImagePreviewPanel') {
            m_elCaseModelImagePanel.AddClass('y-offset');
        }
        _ShowHideLootList(true);
        _SetLootlistHintText(itemId, count);
        for (let i = 0; i < count; i++) {
            let itemid = InventoryAPI.GetLootListItemIdByIndex(itemId, i) === '0' ? m_specialItemId : InventoryAPI.GetLootListItemIdByIndex(itemId, i);
            let elItem = elLootList.FindChildInLayoutFile(itemid);
            if (!elItem) {
                let elItem = $.CreatePanel('Panel', elLootList, itemid);
                elItem.SetAttributeString('itemid', itemid);
                elItem.BLoadLayoutSnippet('LootListItem');
                _UpdateLootListItemInfo(elItem, itemid, itemId);
                elItem.SetPanelEvent('onactivate', _OnActivateLootlistTile.bind(undefined, itemid, itemId, ''));
                elItem.SetPanelEvent('oncontextmenu', _OnActivateLootlistTile.bind(undefined, itemid, itemId, ''));
                if (i === 0) {
                    $.GetContextPanel().FindChildInLayoutFile('CanDecodableBrowseBtn').SetPanelEvent('onactivate', callBackFunc.bind(undefined, itemid, itemId, ''));
                }
                if (itemid !== m_specialItemId) {
                    m_aItemsInLootlist.push({
                        id: itemid,
                        weight: _GetDisplayWeightForScroll(itemid),
                    });
                }
            }
        }
    }
    function _OnActivateLootlistTile(itemid, caseId, keyId) {
        if (!InventoryAPI.IsValidItemID(itemid))
            return;
        let items = [];
        items.push({ label: '#UI_Inspect', jsCallback: callBackFunc.bind(undefined, itemid, caseId, keyId) });
        if (MyPersonaAPI.GetLauncherType() !== "perfectworld" && !InventoryAPI.CannotTrade(itemid)) {
            items.push({ label: '#SFUI_Store_Market_Link', jsCallback: _ViewOnMarket.bind(undefined, itemid) });
        }
        UiToolkitAPI.ShowSimpleContextMenu('', 'ControlLibSimpleContextMenu', items);
    }
    function callBackFunc(itemid, caseId, keyId) {
        $.DispatchEvent('ContextMenuEvent', '');
        _HidePanelForLootlistItemPreview();
        $.DispatchEvent("LootlistItemPreview", itemid, caseId + ',' + caseId);
    }
    function _HidePanelForLootlistItemPreview() {
        if (!m_InspectPanel.IsValid())
            return;
    }
    function _ViewOnMarket(id) {
        SteamOverlayAPI.OpenURL(ItemInfo.GetMarketLinkForLootlistItem(id));
    }
    function _GetDisplayWeightForScroll(itemid) {
        let rarityVal = InventoryAPI.GetItemRarity(itemid);
        let displayItemWeight = [150000, 30000, 6000, 1250, 250, 50, 10];
        return displayItemWeight[rarityVal];
    }
    function _UpdateLootListItemInfo(elItem, itemid, caseId) {
        if (itemid == m_specialItemId) {
            m_unusualItemImagePath = InventoryAPI.GetLootListUnusualItemImage(caseId) + ".png";
            _UpdateUnusualItemInfo(elItem, caseId, m_unusualItemImagePath, true);
        }
        else {
            elItem.FindChildInLayoutFile('ItemImage').itemid = itemid;
            elItem.FindChildInLayoutFile('JsRarity').style.backgroundColor = InventoryAPI.GetItemRarityColor(itemid);
            ItemInfo.GetFormattedName(itemid).SetOnLabel(elItem.FindChildInLayoutFile('JsItemName'));
        }
    }
    function _ShowHideLootList(bshow) {
        let elLootListContainer = $.GetContextPanel().FindChildInLayoutFile('DecodableLootlistContainer');
        elLootListContainer.SetHasClass('hidden', !bshow);
    }
    function _SetLootlistHintText(caseId, count) {
        let bAllItems = InventoryAPI.GetLootListAllEntriesAreAdditionalDrops(caseId);
        $.GetContextPanel().FindChildInLayoutFile('CanDecodableDesc').visible = !bAllItems;
    }
    function _UpdateUnusualItemInfo(elItem, caseId, unusualItemImagePath, bisDisplayedInLootlist = false) {
        if (!elItem || !elItem.IsValid()) {
            return;
        }
        elItem.FindChildInLayoutFile('ItemImage').SetImage("file://{images}/" + unusualItemImagePath);
        if (bisDisplayedInLootlist) {
            elItem.FindChildInLayoutFile('JsRarity').AddClass('popup-decodable-wash-color-unusual');
            let elBg = elItem.FindChildInLayoutFile('ItemTileBg');
            elBg.AddClass('popup-decodable-wash-color-unusual-bg');
            let elName = elItem.FindChildInLayoutFile('JsItemName');
            elName.text = InventoryAPI.GetLootListUnusualItemName(caseId);
        }
        else {
            elItem.FindChildInLayoutFile('JsRarity').style.washColor = '#ffd700';
            elItem.FindChildInLayoutFile('JItemTint').style.washColor = '#ffd700';
        }
    }
    function ClosePopUp(bDestroyLaptop = false, bCloseImmediate = false) {
        InventoryAPI.StopItemPreviewMusic();
        if (m_InspectPanel.IsValid()) {
            if (m_showInspectScheduleHandle) {
                $.CancelScheduled(m_showInspectScheduleHandle);
                m_showInspectScheduleHandle = null;
            }
            if (bDestroyLaptop) {
                LaptopSoundPlayOnce('UI.Laptop.Break');
                m_InspectPanel.FindChildInLayoutFile('id-laptop-screen').SetHasClass('broken-mask', true);
                $.Schedule(.25, () => {
                    m_InspectPanel.FindChildInLayoutFile('id-laptop-screen').SetHasClass('cracked', true);
                });
                $.Schedule(.5, () => {
                    m_InspectPanel.FindChildInLayoutFile('id-laptop-screen').SetHasClass('broken-screen', true);
                    m_InspectPanel.FindChildInLayoutFile('id-laptop-screen').SetHasClass('broken-mask', false);
                });
                $.Schedule(2, () => {
                    InspectAsyncActionBar.OnEventToClose();
                });
            }
            else if (bCloseImmediate) {
                LaptopSoundPlayOnce('inventory_inspect_close');
                InspectAsyncActionBar.OnEventToClose();
            }
            else {
                m_elCaseModelImagePanel?.SetAnimgraphBool('close', true);
                m_InspectPanel.FindChildInLayoutFile('id-laptop-screen').SetHasClass('show', false);
                LaptopSoundPlayOnce('UI.Laptop.Close');
                $.Schedule(.25, () => {
                    if (m_elCaseModelImagePanel && m_elCaseModelImagePanel.IsValid()) {
                        m_elCaseModelImagePanel.TransitionToCamera('cam_laptop_close', 1);
                    }
                });
                $.Schedule(1.25, () => {
                    InspectAsyncActionBar.OnEventToClose();
                });
            }
        }
        _OnHandleReadyForDisplay(false);
    }
    OffersLaptop.ClosePopUp = ClosePopUp;
    function _Refresh() {
        if (!m_itemid || !InventoryAPI.IsValidItemID(m_itemid)) {
            ClosePopUp();
            return;
        }
        Init();
    }
    function ItemUnlocked(numericType, type, itemId) {
        if (itemId && InventoryAPI.IsValidItemID(itemId) && type === 'crate_unlock') {
            InspectShared.SetPopupSetting('item_id', itemId);
            InventoryAPI.SetItemSessionPropertyValue(itemId, 'recent', '1');
            InventoryAPI.AcknowledgeNewItembyItemID(itemId);
            _SetUpOpenLaptop(itemId);
        }
        else if (type === 'casket_contents' || numericType === 1012 || type === 'xpgrant') {
            CollectionOffers.OnItemCustomizationNotification(numericType, type, itemId);
        }
        else {
            ClosePopUp();
        }
    }
    function _SetUpOpenLaptop(itemId) {
        m_isOpen = true;
        $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar').SetHasClass('hidden', true);
        $.GetContextPanel().FindChildInLayoutFile('PopUpCapabilityHeader').SetHasClass('hidden', true);
        _ShowHideLootList(false);
        _SetCaseModelImage(itemId, 'PopUpInspectModelOrImage');
        $.Schedule(.5, () => {
            CollectionOffers.Init(itemId, $.GetContextPanel().FindChildInLayoutFile('id-laptop-screen'));
            LaptopSoundStartLooping('UI.Laptop.FanLoop');
        });
        $.Schedule(.75, () => {
            m_elCaseModelImagePanel?.SetAnimgraphBool('open', true);
            LaptopSoundPlayOnce('UI.Laptop.Open');
            $.GetContextPanel().FindChildInLayoutFile('id-laptop-screen').SetHasClass('show', true);
        });
    }
    function _ItemAcquired(ItemId) {
        LaptopSoundPlayOnce("rename_purchaseSuccess");
        if (CollectionOffers.m_currentOfferId === ItemId) {
            InventoryAPI.SetItemSessionPropertyValue(ItemId, 'recent', '1');
            InventoryAPI.AcknowledgeNewItembyItemID(ItemId);
            $.Schedule(1, () => {
                $.DispatchEvent("InventoryItemPreview", ItemId, '');
                let rarityVal = InventoryAPI.GetItemRarity(ItemId);
                let soundEvent = "ItemRevealRarityCommon";
                if (rarityVal == 4) {
                    soundEvent = "ItemRevealRarityUncommon";
                }
                else if (rarityVal == 5) {
                    soundEvent = "ItemRevealRarityRare";
                }
                else if (rarityVal == 6) {
                    soundEvent = "ItemRevealRarityMythical";
                }
                else if (rarityVal == 7) {
                    soundEvent = "ItemRevealRarityLegendary";
                }
                else if (rarityVal == 8) {
                    soundEvent = "ItemRevealRarityAncient";
                }
                LaptopSoundPlayOnce(soundEvent);
                ClosePopUp(false, true);
            });
        }
    }
    function _CheckConnection() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            if (m_InspectPanel.IsValid() && m_InspectPanel) {
                ClosePopUp(false, true);
            }
        }
    }
    $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', ItemUnlocked);
    $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', _ItemAcquired);
    $.RegisterForUnhandledEvent('CSGOShowMainMenu', _Refresh);
    $.RegisterForUnhandledEvent('PopulateLoadingScreen', ClosePopUp);
    $.RegisterForUnhandledEvent('OpenInventory', ClosePopUp);
    $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _CheckConnection);
})(OffersLaptop || (OffersLaptop = {}));
