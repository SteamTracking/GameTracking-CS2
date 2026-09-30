"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="popup_inspect_async-bar.ts" />
/// <reference path="popup_inspect_purchase-bar.ts" />
/// <reference path="popup_inspect_rental-bar.ts" />
/// <reference path="popup_inspect_header.ts" />
/// <reference path="popup_acknowledge_item.ts" />
/// <reference path="popup_inspect_shared.ts" />
var CapabilityDecodable;
(function (CapabilityDecodable) {
    function Init() {
        $.GetContextPanel().Data().itemFromContainer = '';
        $.GetContextPanel().Data().existingRewardFromXrayId = '';
        $.GetContextPanel().Data().unusualItemImagePath = '';
        $.GetContextPanel().Data().showInspectScheduleHandle = null;
        let aItemsInLootlist = [];
        $.GetContextPanel().Data().aItemsInLootlist = aItemsInLootlist;
        let elCaseModelImagePanel = null;
        $.GetContextPanel().Data().elCaseModelImagePanel = elCaseModelImagePanel;
        $.GetContextPanel().Data().scrollListsPanelIds = ['ScrollList', 'ScrollListMagnified'];
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        if (showXrayMachineUi) {
            $.GetContextPanel().SetHasClass('popup-in-xray', showXrayMachineUi);
            let oData = ItemInfo.GetItemsInXray();
            $.GetContextPanel().Data().existingRewardFromXrayId = oData.reward;
            if (oData.reward) {
                if (oData.reward) {
                    if (InventoryAPI.IsFauxItemID(oData.reward)) {
                        const elPopup = UiToolkitAPI.ShowGenericPopupOk('#popup_xray_first_use_title', '#popup_xray_first_use_desc', '', () => { });
                        const elMessageLabel = elPopup.FindChildInLayoutFile('MessageLabel');
                        elMessageLabel.html = true;
                        elPopup.SetDialogVariable('itemname', InventoryAPI.GetItemName(oData.reward));
                        elMessageLabel.text = $.Localize('#popup_xray_first_use_desc', elPopup);
                    }
                    else if (InspectShared.GetPopupSetting('show_xray_warning')) {
                        UiToolkitAPI.ShowGenericPopupOk('#popup_xray_in_use_title', '#popup_xray_in_use_desc', '', () => { });
                    }
                }
                InspectShared.SetPopupSetting('item_id', oData.case);
            }
            if (!InspectShared.GetPopupSetting('tool_id')) {
                let keyId = ItemInfo.GetKeyForCaseInXray(InspectShared.GetPopupSetting('item_id'));
                if (keyId) {
                    InspectShared.SetPopupSetting('tool_id', keyId);
                }
            }
        }
        const caseId = InspectShared.GetPopupSetting('item_id');
        const keyId = InspectShared.GetPopupSetting('tool_id');
        if ((keyId && InventoryAPI.IsRental(keyId)) ||
            InventoryAPI.IsRental(InspectShared.GetPopupSetting('item_id'))) {
            InspectShared.SetPopupSetting('show_work_type_warning', false);
            InspectShared.SetPopupSetting('inspect_only', true);
            InspectShared.SetPopupSetting('only_close_btn', true);
            InspectShared.SetPopupSetting('force_hide_async_bar', true);
        }
        if (!keyId) {
            const associatedItemCount = InventoryAPI.GetAssociatedItemsCount(caseId);
            if (!InventoryAPI.IsItemInfoValid(caseId)) {
                return;
            }
            const storeItemId = InspectShared.GetPopupSetting('store_item_id');
            InspectShared.SetPopupSetting('is_keyless', ((associatedItemCount === 0 || !associatedItemCount) && !storeItemId));
            if (!storeItemId && associatedItemCount > 0) {
                const keyToSellId = InventoryAPI.GetAssociatedItemIdByIndex(caseId, 0);
                InspectShared.SetPopupSetting('purchase_item_id', keyToSellId);
            }
        }
        else {
            if (!InventoryAPI.IsItemInfoValid(keyId)) {
                return;
            }
        }
        _SetUpPanelElements();
        $.DispatchEvent('CapabilityPopupIsOpen', true);
    }
    CapabilityDecodable.Init = Init;
    function _SetUpPanelElements() {
        const caseId = InspectShared.GetPopupSetting('item_id');
        const keyId = InspectShared.GetPopupSetting('tool_id');
        const existingRewardFromXrayId = $.GetContextPanel().Data().existingRewardFromXrayId;
        if (!keyId) {
            InspectShared.SetPopupSetting('show_work_type_warning', false);
            InspectShared.SetPopupSetting('override_async_bar_desc', false);
            if (existingRewardFromXrayId) {
                InspectShared.SetPopupSetting('allow_xray_purchase', true);
            }
        }
        else {
            InspectShared.SetPopupSetting('show_work_type_warning', true);
            InspectShared.SetPopupSetting('override_async_bar_desc', true);
            if (existingRewardFromXrayId) {
                InspectShared.SetPopupSetting('allow_xray_claim', true);
            }
        }
        if (InspectShared.GetPopupSetting('is_keyless')) {
            if (existingRewardFromXrayId) {
                InspectShared.SetPopupSetting('allow_xray_claim', true);
            }
            InspectShared.SetPopupSetting('show_work_type_warning', true);
            InspectShared.SetPopupSetting('override_async_bar_desc', true);
        }
        const category = InventoryAPI.GetLoadoutCategory(caseId);
        if (category == "musickit") {
            InventoryAPI.PlayItemPreviewMusic(caseId, '');
        }
        InspectShared.SetPopupSetting('allow_rent', InventoryAPI.CanOpenForRental(caseId));
        InspectPurchaseBar.Init();
        InspectAsyncActionBar.Init();
        InspectRentalBar.Init();
        CapabilityHeader.Init();
        _SetupDescription(caseId);
        if (InspectShared.GetPopupSetting('is_xray_machine')) {
            _SetUpXrayPanel();
        }
        else {
            _SetCaseModelImage(caseId, 'PopUpInspectModelOrImage');
            if (!ItemInfo.IsSpraySealed(caseId) && !ItemInfo.ItemDefinitionNameSubstrMatch(caseId, 'tournament_pass_')) {
                _PlayContainerSound(caseId, 'fall');
            }
            _SetLootListItems(caseId, keyId);
        }
    }
    function _SetupDescription(caseId) {
        const elPanel = $.GetContextPanel().FindChildInLayoutFile('InspectItemDesc');
        const count = InventoryAPI.GetLootListItemsCount(caseId);
        if (count === 0 && InspectShared.GetPopupSetting('store_item_id')) {
            elPanel.visible = true;
            elPanel.text = InventoryAPI.GetItemDescription(caseId, '');
        }
        else {
            elPanel.visible = false;
        }
    }
    function _SetCaseModelImage(caseId, PanelId) {
        const elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile(PanelId);
        const item_attributes = 'item_attributes' in $.GetContextPanel().Data().oSettings ? $.GetContextPanel().Data().oSettings.item_attributes : '';
        InspectModelImage.Init(elItemModelImagePanel, caseId);
        $.GetContextPanel().Data().elCaseModelImagePanel = InspectModelImage.GetModelPanel();
    }
    function _SetLootListItems(caseId, keyId) {
        const count = InventoryAPI.GetLootListItemsCount(caseId);
        const elLootList = $.GetContextPanel().FindChildInLayoutFile('DecodableLootlist');
        const specialItemId = 'id-special-item';
        if (count === 0) {
            _ShowHideLootList(false);
            return;
        }
        const elCaseModelImagePanel = $.GetContextPanel().Data().elCaseModelImagePanel;
        if (elCaseModelImagePanel && elCaseModelImagePanel.IsValid() && elCaseModelImagePanel.id === 'ImagePreviewPanel') {
            elCaseModelImagePanel.AddClass('y-offset');
        }
        _ShowHideLootList(true);
        _SetLootlistHintText(caseId, count);
        for (let i = 0; i < count; i++) {
            const itemid = InventoryAPI.GetLootListItemIdByIndex(caseId, i) === '0' ? specialItemId : InventoryAPI.GetLootListItemIdByIndex(caseId, i);
            let elItem = elLootList.FindChildInLayoutFile(itemid);
            if (!elItem) {
                let elItem = $.CreatePanel('Panel', elLootList, itemid);
                elItem.SetAttributeString('itemid', itemid);
                elItem.BLoadLayoutSnippet('LootListItem');
                const isAllowedToInteractWithLootlistItems = true;
                _UpdateLootListItemInfo(elItem, itemid, caseId);
                const funcActivation = isAllowedToInteractWithLootlistItems ? _OnActivateLootlistTile : () => { };
                elItem.SetPanelEvent('onactivate', funcActivation.bind(undefined, itemid, caseId, keyId));
                elItem.SetPanelEvent('oncontextmenu', funcActivation.bind(undefined, itemid, caseId, keyId));
                if (i === 0 && isAllowedToInteractWithLootlistItems) {
                    $.GetContextPanel().FindChildInLayoutFile('CanDecodableBrowseBtn').SetPanelEvent('onactivate', callBackFunc.bind(undefined, itemid, caseId, keyId));
                }
                if (itemid !== specialItemId) {
                    $.GetContextPanel().Data().aItemsInLootlist.push({
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
        const storeid = InspectShared.GetPopupSetting('store_item_id') ? InspectShared.GetPopupSetting('store_item_id') : '';
        $.DispatchEvent("LootlistItemPreview", itemid, caseId +
            ',' + storeid);
    }
    function _ViewOnMarket(id) {
        SteamOverlayAPI.OpenURL(ItemInfo.GetMarketLinkForLootlistItem(id));
    }
    function _GetDisplayWeightForScroll(itemid) {
        const rarityVal = InventoryAPI.GetItemRarity(itemid);
        const displayItemWeight = [150000, 30000, 6000, 1250, 250, 50, 10];
        return displayItemWeight[rarityVal];
    }
    function _UpdateLootListItemInfo(elItem, itemid, caseId) {
        const specialItemId = 'id-special-item';
        if (itemid == specialItemId) {
            $.GetContextPanel().Data().unusualItemImagePath = InventoryAPI.GetLootListUnusualItemImage(caseId) + ".png";
            _UpdateUnusualItemInfo(elItem, caseId, $.GetContextPanel().Data().unusualItemImagePath, true);
        }
        else {
            elItem.FindChildInLayoutFile('ItemImage').itemid = itemid;
            elItem.FindChildInLayoutFile('JsRarity').style.backgroundColor = InventoryAPI.GetItemRarityColor(itemid);
            ItemInfo.GetFormattedName(itemid).SetOnLabel(elItem.FindChildInLayoutFile('JsItemName'));
        }
    }
    function _ShowHideLootList(bshow) {
        const elLootListContainer = $.GetContextPanel().FindChildInLayoutFile('DecodableLootlistContainer');
        elLootListContainer.SetHasClass('hidden', !bshow);
    }
    function _SetLootlistHintText(caseId, count) {
        const bAllItems = InventoryAPI.GetLootListAllEntriesAreAdditionalDrops(caseId);
        $.GetContextPanel().FindChildInLayoutFile('CanDecodableDesc').visible = !bAllItems;
        if (count > 1 || bAllItems) {
            $.GetContextPanel().FindChildInLayoutFile('CanDecodableDescMulti').SetDialogVariableInt('num_items', count);
            $.GetContextPanel().FindChildInLayoutFile('CanDecodableDescMulti').visible = (count > 1 && bAllItems);
        }
    }
    function _UpdateUnusualItemInfo(elItem, caseId, unusualItemImagePath, bisDisplayedInLootlist = false) {
        if (!elItem || !elItem.IsValid()) {
            return;
        }
        elItem.FindChildInLayoutFile('ItemImage').SetImage("file://{images}/" + unusualItemImagePath);
        if (bisDisplayedInLootlist) {
            elItem.FindChildInLayoutFile('JsRarity').AddClass('popup-decodable-wash-color-unusual');
            const elBg = elItem.FindChildInLayoutFile('ItemTileBg');
            elBg.AddClass('popup-decodable-wash-color-unusual-bg');
            const elName = elItem.FindChildInLayoutFile('JsItemName');
            elName.text = InventoryAPI.GetLootListUnusualItemName(caseId);
        }
        else {
            elItem.FindChildInLayoutFile('JsRarity').style.washColor = '#ffd700';
            elItem.FindChildInLayoutFile('JItemTint').style.washColor = '#ffd700';
        }
    }
    function _SetUpCaseOpeningScroll() {
        _ShowHideLootList(false);
        let delay = 0;
        const elCaseModelImagePanel = $.GetContextPanel().Data().elCaseModelImagePanel;
        if (elCaseModelImagePanel &&
            elCaseModelImagePanel.IsValid() &&
            elCaseModelImagePanel.id == 'ImagePreviewPanel' &&
            !elCaseModelImagePanel.BHasClass('hidden')) {
            elCaseModelImagePanel.RemoveClass('y-offset');
            delay = 0.1;
        }
        else {
            elCaseModelImagePanel.TransitionToCamera('cam_case_open', 1.5);
            $.Schedule(0.75, () => { elCaseModelImagePanel?.SetAnimgraphBool('open', true); });
            delay = 2.0;
        }
        $.Schedule(delay, () => _ShowScroll(elCaseModelImagePanel));
    }
    function _ShowScroll(elCase) {
        const elScroll = $.GetContextPanel().FindChildInLayoutFile('DecodableItemsScroll');
        if (!elScroll || !elScroll.IsValid() || !elCase || !elCase.IsValid()) {
            return;
        }
        elScroll.RemoveClass('hidden');
        elCase.AddClass('popup-inspect-modelpanel_darken_blur');
        const scrollListsPanelIds = $.GetContextPanel().Data().scrollListsPanelIds;
        _FillScrollsWithItems(scrollListsPanelIds);
        $.Schedule(0.1, _PlayScrollAnim.bind(undefined, scrollListsPanelIds));
    }
    function _PlayScrollAnim(scrolllists) {
        const targetId = 'ItemFromContainer';
        const xOffsetSlackPercent = (Math.floor(Math.random() * ((90) - 10 + 1) + 10) / 100);
        for (let element of scrolllists) {
            let xPos = _GetStopPosition($.GetContextPanel().FindChildInLayoutFile(element), targetId, xOffsetSlackPercent);
            const elScroll = $.GetContextPanel().FindChildInLayoutFile(element);
            elScroll.ScrollToFitRegion(xPos, xPos, 0, 0, 3, true, false);
        }
        const revealDelay = 6;
        const contextPanel = $.GetContextPanel();
        contextPanel.Data().showInspectScheduleHandle = $.Schedule(revealDelay, () => _ShowInspect(contextPanel));
        const itemDefName = InventoryAPI.GetItemDefinitionName(InspectShared.GetPopupSetting('item_id'));
        let soundEventName = "container_weapon_ticker";
        if (itemDefName && itemDefName.indexOf("sticker") != -1) {
            soundEventName = "container_sticker_ticker";
        }
        for (let i = 0; i < _TickSoundIntervals.length; ++i) {
            $.Schedule(_TickSoundIntervals[i], _ScrollTick.bind(undefined, soundEventName));
        }
    }
    const _TickSoundIntervals = [0.000, 0.063, 0.125, 0.188, 0.250, 0.313, 0.375, 0.438, 0.500, 0.563, 0.625, 0.688, 0.750, 0.813, 0.875, 0.938, 1.000, 1.063, 1.125, 1.188, 1.250, 1.313, 1.375, 1.483, 1.351, 1.620, 1.701, 1.786, 1.872, 2.003, 2.154, 2.313, 2.466, 2.615, 2.773, 2.941, 3.104, 3.339, 3.630, 3.953, 4.385, 5.004,];
    function _ScrollTick(soundEventName) {
        $.DispatchEvent("CSGOPlaySoundEffect", soundEventName, "MOUSE");
    }
    function _GetStopPosition(elParent, targetId, xOffsetSlackPercent) {
        const elTile = elParent.FindChildInLayoutFile(targetId);
        if (!elTile || !elTile.IsValid())
            return 0;
        const tileWidth = elTile.contentwidth;
        return (elTile.actualxoffset + (tileWidth * xOffsetSlackPercent));
    }
    function _ShowInspect(contextPanel) {
        contextPanel.Data().showInspectScheduleHandle = null;
        if (contextPanel.Data().itemFromContainer) {
            InventoryAPI.SetItemSessionPropertyValue(contextPanel.Data().itemFromContainer, 'recent', '1');
            InventoryAPI.AcknowledgeNewItembyItemID(contextPanel.Data().itemFromContainer);
            if (ItemInfo.ItemDefinitionNameSubstrMatch(contextPanel.Data().itemFromContainer, 'tournament_journal_')) {
                $.Schedule(0.2, () => {
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_major_hub.xml', 'journalid=' + contextPanel.Data().itemFromContainer);
                });
            }
            else {
                $.DispatchEvent("InventoryItemPreview", contextPanel.Data().itemFromContainer, '');
            }
            CapabilityDecodable.ClosePopUp();
            const rarityVal = InventoryAPI.GetItemRarity(contextPanel.Data().itemFromContainer);
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
            $.DispatchEvent("CSGOPlaySoundEffect", soundEvent, "MOUSE");
        }
        else {
            _TimeoutPopup();
        }
    }
    function _TimeoutPopup() {
        CapabilityDecodable.ClosePopUp();
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', () => { });
    }
    function _FillScrollsWithItems(lists) {
        const numTilesInScroll = 38;
        const indexItemsFromContainer = 3;
        const indexStart = (numTilesInScroll - 3);
        let totalWeight = 0;
        for (let element of $.GetContextPanel().Data().aItemsInLootlist) {
            totalWeight += element.weight;
        }
        let displayItemsList = [];
        for (let i = 0; i < numTilesInScroll; i++) {
            const itemToAdd = GetItemBasedOnDisplayWeight(totalWeight, $.GetContextPanel().Data().aItemsInLootlist);
            if (itemToAdd)
                displayItemsList.push(itemToAdd);
        }
        for (let element of lists) {
            const elParent = $.GetContextPanel().FindChildInLayoutFile(element);
            for (let i = 0; i < displayItemsList.length; i++) {
                const itemId = displayItemsList[i];
                const tileId = (i === indexItemsFromContainer) ? 'ItemFromContainer' : (i === indexStart) ? 'ItemStart' : itemId;
                const elTile = $.CreatePanel('Panel', elParent, tileId);
                elTile.BLoadLayoutSnippet('ScrollItem');
                _UpdateScrollTile(element, elTile, itemId);
            }
        }
    }
    function _UpdateScrollTile(listId, elTile, itemId) {
        if (listId === 'ScrollListMagnified') {
            elTile.AddClass('magnified');
        }
        itemId = (elTile.id === 'ItemFromContainer' && $.GetContextPanel().Data().itemFromContainer) ? $.GetContextPanel().Data().itemFromContainer : itemId;
        if ((InventoryAPI.GetItemQuality(itemId) === 3) && $.GetContextPanel().Data().unusualItemImagePath) {
            _UpdateUnusualItemInfo(elTile, InspectShared.GetPopupSetting('item_id'), $.GetContextPanel().Data().unusualItemImagePath);
        }
        else {
            elTile.FindChildInLayoutFile('ItemImage').itemid = itemId;
            elTile.FindChildInLayoutFile('JsRarity').style.washColor = InventoryAPI.GetItemRarityColor(itemId);
            elTile.FindChildInLayoutFile('JItemTint').style.washColor = InventoryAPI.GetItemRarityColor(itemId);
        }
    }
    function GetItemBasedOnDisplayWeight(totalWeight, aItemsInLootlist) {
        let weightOfItem = 0;
        const Random = Math.floor(Math.random() * totalWeight);
        for (let i = 0; i < aItemsInLootlist.length; i++) {
            weightOfItem += aItemsInLootlist[i].weight;
            if (Random <= weightOfItem)
                return aItemsInLootlist[i].id;
        }
    }
    function _SetUpCaseOpeningCountdown() {
        _UpdateOpeningCounter.SetIsGraffiti(_GetContainerType(InspectShared.GetPopupSetting('item_id')) === 'graffiti');
        _UpdateOpeningCounter.ShowCounter();
        _UpdateOpeningCounter.UpdateCounter();
        _ShowHideLootList(false);
    }
    let _UpdateOpeningCounter;
    (function (_UpdateOpeningCounter) {
        let counterVal = 6;
        const elCountdown = $.GetContextPanel().FindChildInLayoutFile('DecodableCountdown');
        const elCountdownLabel = elCountdown.FindChildInLayoutFile('DecodableCountdownLabel');
        const elCountdownRadial = elCountdown.FindChildInLayoutFile('DecodableCountdownRadial');
        let timerHandle = null;
        let isGraffitiUnseal = false;
        function UpdateCounter() {
            timerHandle = null;
            counterVal = counterVal - 1;
            if (counterVal === 0) {
                elCountdown.AddClass('hidden');
                _ShowInspect($.GetContextPanel());
            }
            else {
                $.DispatchEvent("CSGOPlaySoundEffect", "container_countdown", "MOUSE");
                elCountdownLabel.text = String(counterVal);
                if (!isGraffitiUnseal) {
                    elCountdownLabel.visible = true;
                    elCountdownLabel.RemoveClass('popup-countdown-anim');
                    elCountdownLabel.AddClass('popup-countdown-anim');
                }
                else {
                    elCountdownLabel.visible = false;
                }
                elCountdownRadial.RemoveClass('popup-countdown-timer-circle-anim');
                elCountdownRadial.AddClass('popup-countdown-timer-circle-anim');
                timerHandle = $.Schedule(1, UpdateCounter);
            }
        }
        _UpdateOpeningCounter.UpdateCounter = UpdateCounter;
        function ShowCounter() {
            elCountdown.RemoveClass('hidden');
        }
        _UpdateOpeningCounter.ShowCounter = ShowCounter;
        function CancelTimer() {
            if (timerHandle) {
                $.CancelScheduled(timerHandle);
                timerHandle = null;
            }
        }
        _UpdateOpeningCounter.CancelTimer = CancelTimer;
        function SetIsGraffiti(isGraffiti) {
            isGraffitiUnseal = isGraffiti;
        }
        _UpdateOpeningCounter.SetIsGraffiti = SetIsGraffiti;
    })(_UpdateOpeningCounter || (_UpdateOpeningCounter = {}));
    function _SetUpXrayPanel() {
        const caseId = InspectShared.GetPopupSetting('item_id');
        if (!caseId) {
            return;
        }
        const elActionsPanel = $.GetContextPanel().FindChildInLayoutFile('XrayItemsActionPanel');
        const existingRewardFromXrayId = $.GetContextPanel().Data().existingRewardFromXrayId;
        elActionsPanel.AddClass('hidden');
        if (!existingRewardFromXrayId) {
            elActionsPanel.RemoveClass('hidden');
            _SetCaseModelImage(caseId, 'PopUpXrayModelOrImage');
            const elBtn = $.GetContextPanel().FindChildInLayoutFile('ConfirmXray');
            elBtn.SetPanelEvent('onactivate', _OnActivateXray.bind(undefined, elBtn));
            $.GetContextPanel().FindChildInLayoutFile('PopUpXrayStatusLabel').text = $.Localize("#popup_xray_ready_for_use");
        }
        else if (existingRewardFromXrayId) {
            InspectHeader.Init();
            $.GetContextPanel().FindChildInLayoutFile('XrayItemsActionPanelItemName').RemoveClass('hidden');
            const elImagePanel = $.GetContextPanel().FindChildInLayoutFile('PopUpXrayModelOrImageReveal');
            if (!elImagePanel.BHasClass('popup-xray-reverse-effect')) {
                elImagePanel.AddClass('no-anim');
                elImagePanel.AddClass('popup-xray-reverse-effect');
                $.GetContextPanel().FindChildInLayoutFile('PopUpXrayModelOrImage').AddClass('hide');
                _SetCaseModelImage(existingRewardFromXrayId, 'PopUpXrayModelOrImageReveal');
            }
            $.GetContextPanel().FindChildInLayoutFile('PopUpXrayStatusLabel').text = $.Localize("#popup_xray_already_in_use");
            $.GetContextPanel().FindChildInLayoutFile('PopUpXrayStatusDot').AddClass('in-use');
        }
        const elXrayPanel = $.GetContextPanel().FindChildInLayoutFile('XrayItemsPanel');
        elXrayPanel.RemoveClass('hidden');
        const aPanels = $.GetContextPanel().FindChildInLayoutFile('PopUpXrayBgSquares').Children();
        _AnimSquares(aPanels);
    }
    function _OnActivateXray(elBtn) {
        const caseId = InspectShared.GetPopupSetting('item_id');
        InventoryAPI.UseTool(caseId, caseId);
        elBtn.enabled = false;
        _XrayReveal();
        $.DispatchEvent('CSGOPlaySoundEffect', 'XrayStart', 'MOUSE');
    }
    function _XrayReveal() {
        const revealDelay = 3.5;
        $.GetContextPanel().Data().showInspectScheduleHandle = $.Schedule(revealDelay, _ShowXrayReward);
        let oData = {
            clipValue: 0,
            lineValue: 100,
            clipPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpXrayModelOrImage'),
            linePanel: $.GetContextPanel().FindChildInLayoutFile('PopUpXrayModelOrImageRevealLine')
        };
        oData.clipPanel.AddClass('popup-xray-inverse-effect');
        $.GetContextPanel().FindChildInLayoutFile('PopUpXrayModelOrImageReveal').AddClass('popup-xray-reverse-effect');
        $.Schedule(1, () => {
            oData.linePanel.visible = true;
            _AnimClip(oData);
        });
    }
    function _AnimClip(oData) {
        if (oData.clipValue <= 100) {
            oData.clipPanel.style.clip = 'rect( 0%, 100%, 100%, ' + oData.clipValue + '% );';
            oData.clipValue = oData.clipValue + 1;
            oData.linePanel.style.transform = 'translatex( -' + oData.lineValue + '%);';
            oData.lineValue = oData.lineValue - 1;
            $.Schedule(0.02, _AnimClip.bind(undefined, oData));
        }
        else {
            oData.linePanel.AddClass('hide');
            oData.clipPanel.AddClass('hide');
            _SetUpPanelElements();
        }
    }
    function _AnimSquares(aPanels) {
        if ($.GetContextPanel().FindChildInLayoutFile('XrayItemsPanel').visible) {
            for (let panel of aPanels) {
                panel.style.backgroundColor = 'rgba(255, 255, 255, 0.0' + Math.ceil(Math.random() * 10) + ');';
            }
            $.Schedule(1, _AnimSquares.bind(undefined, aPanels));
        }
    }
    function _ShowXrayReward() {
        $.GetContextPanel().Data().showInspectScheduleHandle = null;
        if ($.GetContextPanel().Data().existingRewardFromXrayId) {
            _SetUpPanelElements();
        }
        else {
            _TimeoutPopup();
        }
    }
    function _UpdateXrayRewardTile(itemId) {
        const oData = ItemInfo.GetItemsInXray();
        $.GetContextPanel().Data().existingRewardFromXrayId = itemId === oData.reward ? oData.reward : '';
        _SetCaseModelImage(itemId, 'PopUpXrayModelOrImageReveal');
    }
    function _UpdateScrollResultTile(numericType, type, itemId) {
        if (type === "crate_unlock" ||
            type === 'graffity_unseal' ||
            type === 'xray_item_reveal' ||
            type === "xray_item_claim") {
            if (InspectShared.GetPopupSetting('is_xray_machine')) {
                let oData = ItemInfo.GetItemsInXray();
                if (oData.reward && type === 'xray_item_reveal') {
                    _UpdateXrayRewardTile(itemId);
                    return;
                }
                else if (type === 'xray_item_claim') {
                    $.GetContextPanel().Data().itemFromContainer = itemId;
                    _ShowInspect($.GetContextPanel());
                    return;
                }
            }
            else {
                $.GetContextPanel().Data().itemFromContainer = itemId;
            }
            if ($.GetContextPanel().FindChildInLayoutFile('DecodableItemsScroll').BHasClass('hidden')) {
                if (type === 'graffity_unseal') {
                    _ShowInspect($.GetContextPanel());
                }
                return;
            }
            else {
                for (let element of $.GetContextPanel().Data().scrollListsPanelIds) {
                    const elScroll = $.GetContextPanel().FindChildInLayoutFile(element);
                    const elTile = elScroll.FindChildInLayoutFile('ItemFromContainer');
                    _UpdateScrollTile(element, elTile, itemId);
                }
            }
        }
        else if (type === "ticket_activated") {
            $.GetContextPanel().Data().itemFromContainer = itemId;
            _ShowInspect($.GetContextPanel());
        }
    }
    function _ItemAcquired(ItemId) {
        $.DispatchEvent("CSGOPlaySoundEffect", "rename_purchaseSuccess", "MOUSE");
        const keyId = InspectShared.GetPopupSetting('tool_id');
        const keyToSellId = InventoryAPI.GetAssociatedItemIdByIndex(InspectShared.GetPopupSetting('item_id'), 0);
        if (!keyId && keyToSellId) {
            let matchingKeyDefName = InventoryAPI.GetItemDefinitionName(keyToSellId);
            if (InventoryAPI.DoesItemMatchDefinitionByName(ItemId, matchingKeyDefName)) {
                InspectShared.SetPopupSetting('tool_id', ItemId);
                $.DispatchEvent('HideStoreStatusPanel');
                _AcknowledgeMatchingKeys(matchingKeyDefName);
                InspectShared.SetPopupSetting('purchase_item_id', '');
                _SetUpPanelElements();
            }
        }
        else if (InspectShared.GetPopupSetting('store_item_id')) {
            ClosePopUp();
            $.DispatchEvent('ShowAcknowledgePopup', '', ItemId);
            $.DispatchEvent('HideStoreStatusPanel');
        }
    }
    function _AcknowledgeMatchingKeys(matchingKeyDefName) {
        const bShouldAcknowledge = true;
        AcknowledgeItems.GetItemsByType([matchingKeyDefName], bShouldAcknowledge);
    }
    function _ShowUnlockAnimation() {
        const caseId = InspectShared.GetPopupSetting('item_id');
        const lootListCount = InventoryAPI.GetLootListItemsCount(caseId);
        if (lootListCount === undefined) {
            if (InventoryAPI.IsValidItemID($.GetContextPanel().Data().itemFromContainer)) {
                _ShowInspect($.GetContextPanel());
            }
            else {
                _SetUpCaseOpeningCountdown();
            }
            return;
        }
        if (lootListCount <= 1) {
            _SetUpCaseOpeningCountdown();
        }
        else {
            _SetUpCaseOpeningScroll();
        }
        _PlayContainerSound(caseId, 'open');
        _PlayContainerSound(caseId, 'ticker');
    }
    function _PlayContainerSound(caseId, soundName) {
        $.DispatchEvent("CSGOPlaySoundEffect", "container_" + _GetContainerType(caseId) + "_" + soundName, "MOUSE");
    }
    function _GetContainerType(caseId) {
        const itemDefName = InventoryAPI.GetItemDefinitionName(InspectShared.GetPopupSetting('item_id'));
        if (itemDefName && (itemDefName.indexOf("spray") != -1 || itemDefName.indexOf("tournament_pass_") != -1))
            return 'graffiti';
        else if (itemDefName && itemDefName.indexOf("sticker") != -1)
            return 'sticker';
        else if (itemDefName && itemDefName.indexOf("pins") != -1)
            return 'pins';
        else if (itemDefName && itemDefName.indexOf("patch") != -1)
            return 'patch';
        else if (itemDefName && (itemDefName.indexOf("coupon") == 0 || itemDefName.indexOf("musickit") != -1))
            return 'music';
        else
            return 'weapon';
    }
    function ClosePopUp() {
        InventoryAPI.StopItemPreviewMusic();
        if ($.GetContextPanel().IsValid()) {
            if ($.GetContextPanel().Data().showInspectScheduleHandle) {
                $.CancelScheduled($.GetContextPanel().Data().showInspectScheduleHandle);
                $.GetContextPanel().Data().showInspectScheduleHandle = null;
            }
            const elRentalBar = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectRentalBar');
            const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
            const elPurchase = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
            if (!elRentalBar.BHasClass('hidden')) {
                InspectRentalBar.ClosePopup($.GetContextPanel());
            }
            if (!elAsyncActionBarPanel.BHasClass('hidden')) {
                InspectAsyncActionBar.OnEventToClose();
            }
            else if (!elPurchase.BHasClass('hidden')) {
                InspectPurchaseBar.ClosePopup();
            }
        }
        _UpdateOpeningCounter.CancelTimer();
    }
    CapabilityDecodable.ClosePopUp = ClosePopUp;
    function _Refresh() {
        const caseId = InspectShared.GetPopupSetting('item_id');
        if (!caseId || !InventoryAPI.IsValidItemID(caseId)) {
            ClosePopUp();
            return;
        }
        _SetUpPanelElements();
    }
    function UpdateInspectMap() {
        InspectModelImage.SwitchMap($.GetContextPanel());
    }
    CapabilityDecodable.UpdateInspectMap = UpdateInspectMap;
    function _PlayOpenCaseAnimForRental() {
        _ShowHideLootList(false);
        _PlayContainerSound(InspectShared.GetPopupSetting('item_id'), 'open');
        $.GetContextPanel().Data().elCaseModelImagePanel.TransitionToCamera('cam_case_open', 1.5);
        $.Schedule(0.75, () => { $.GetContextPanel().Data().elCaseModelImagePanel?.SetAnimgraphBool('open', true); });
    }
    CapabilityDecodable._PlayOpenCaseAnimForRental = _PlayOpenCaseAnimForRental;
    $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', _UpdateScrollResultTile);
    $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', _ItemAcquired);
    $.RegisterForUnhandledEvent('StartDecodeableAnim', _ShowUnlockAnimation);
    $.RegisterForUnhandledEvent('StartRentalAnim', _PlayOpenCaseAnimForRental);
    $.RegisterForUnhandledEvent("CSGOInspectBackgroundMapChanged", UpdateInspectMap);
    $.RegisterForUnhandledEvent('CSGOShowMainMenu', _Refresh);
    $.RegisterForUnhandledEvent('PopulateLoadingScreen', ClosePopUp);
    $.RegisterForUnhandledEvent('OpenInventory', ClosePopUp);
})(CapabilityDecodable || (CapabilityDecodable = {}));
