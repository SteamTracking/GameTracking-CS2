"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../common/icon.ts" />
/// <reference path="popup_capability_can_sticker.ts" />
var AcknowledgeItems;
(function (AcknowledgeItems_1) {
    let m_elEquipBtn = $('#EquipItemBtn');
    let m_focusedItemId = '';
    function OnLoad() {
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', Init);
        $.RegisterEventHandler("SetCarouselSelectedChild", $.GetContextPanel(), CarouselUpdated);
        $.RegisterForUnhandledEvent('CSGOShowMainMenu', Init);
        $.RegisterForUnhandledEvent('PopulateLoadingScreen', AcknowledgeItems.AcknowledgeAllItems.OnCloseEvents);
        Init();
    }
    AcknowledgeItems_1.OnLoad = OnLoad;
    function Init() {
        const items = GetItems();
        if (items.length < 1) {
            AcknowledgeAllItems.InvokeJSCallback();
            $.DispatchEvent('UIPopupButtonClicked', '');
            return;
        }
        const numItems = items.length;
        AcknowledgeAllItems.SetItemsToSaveAsNew(items);
        const elParent = $.GetContextPanel().FindChildInLayoutFile('AcknowledgeItemsCarousel');
        elParent.RemoveAndDeleteChildren();
        for (let i = 0; i < items.length; i++) {
            const elDelayLoadPanel = $.CreatePanel('CSGODelayLoadPanel', elParent, 'carousel_delay_load_' + i, { class: 'Offscreen' });
            elDelayLoadPanel.SetLoadFunction(MakeItemPanel.bind(null, items[i], i, numItems));
            elDelayLoadPanel.ListenForClassRemoved('Offscreen');
        }
        $.Schedule(.25, () => {
            let aPanels = $.GetContextPanel().FindChildInLayoutFile('AcknowledgeItemsCarousel').Children();
            if (aPanels.length > 0) {
                for (let i = 0; i < aPanels.length; i++) {
                    if (aPanels[i].BHasClass('Focused')) {
                        ShowHideOpenItemInLayoutBtn(aPanels[i].Data().itemId);
                        if (m_elEquipBtn)
                            m_elEquipBtn.SetPanelEvent('onactivate', () => {
                                AcknowledgeAllItems.OnActivate();
                                $.DispatchEvent("ShowLoadoutForItem", m_focusedItemId);
                            });
                        break;
                    }
                }
            }
        });
        $.Schedule(1, SetFocusForNavButton);
    }
    function SetFocusForNavButton() {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('AcknowledgeItemsCarouselNav');
        elParent.FindChildInLayoutFile('NextItemButton').SetPanelEvent('onmouseover', () => {
            elParent.FindChildInLayoutFile('NextItemButton').SetFocus();
        });
        elParent.FindChildInLayoutFile('PreviousItemButton').SetPanelEvent('onmouseover', () => {
            elParent.FindChildInLayoutFile('PreviousItemButton').SetFocus();
        });
    }
    function MakeItemPanel(item, index, numItems, elParent) {
        const elItemTile = $.CreatePanel('Panel', elParent, item.id);
        elItemTile.BLoadLayoutSnippet('Item');
        const modelPath = ShowModelOrItem(elItemTile, item.id, item.type);
        ResizeForVerticalItem(elItemTile, item.id);
        const rarityColor = InventoryAPI.GetItemRarityColor(item.id);
        SetTitle(elItemTile, item, rarityColor);
        SetParticlesBg(elItemTile, rarityColor, modelPath, item.id);
        ColorRarityBar(elItemTile, rarityColor);
        SetItemName(elItemTile, item.id);
        ShowGiftPanel(elItemTile, item.id);
        ShowSetPanel(elItemTile, item);
        ItemCount(elItemTile, index, numItems);
        elParent.Data().itemId = item.id;
    }
    function ShowModelOrItem(elItemTile, id, type = "") {
        let elItemModelImagePanel = elItemTile.FindChildInLayoutFile('PopUpInspectModelOrImage');
        elItemModelImagePanel.Data().useAcknowledge = !(ItemInfo.IsSprayPaint(id) || ItemInfo.IsSpraySealed(id));
        return InspectModelImage.Init(elItemModelImagePanel, id);
    }
    function ResizeForVerticalItem(elItemTile, id) {
        if (ItemInfo.IsCharacter(id)) {
            let elPanel = elItemTile.FindChildInLayoutFile('AcknowledgeItemContainer');
            elPanel.AddClass('popup-acknowledge__item__model--vertical');
        }
    }
    function SetItemName(elItemTile, id) {
        const elLabel = elItemTile.FindChildInLayoutFile('AcknowledgeItemLabel');
        elLabel.text = InventoryAPI.GetItemName(id);
    }
    function SetTitle(elItemTile, item, rarityColor) {
        const defName = InventoryAPI.GetItemDefinitionName(item.id);
        const elTitle = elItemTile.FindChildInLayoutFile('AcknowledgeItemTitle');
        const titleSuffex = (item.pickuptype
            && ['xpshopredeem', 'quest_reward'].includes(item.pickuptype)) ? item.pickuptype : item.type;
        if (defName === 'casket' && item.type === 'nametag_add') {
            elTitle.text = $.Localize('#CSGO_Tool_Casket_Tag');
        }
        else {
            const idxOfExtraParams = titleSuffex.indexOf("[");
            const typeWithoutParams = (idxOfExtraParams > 0) ? titleSuffex.substring(0, idxOfExtraParams) : titleSuffex;
            elTitle.text = $.Localize('#popup_title_' + typeWithoutParams);
        }
        elTitle.style.washColor = rarityColor;
    }
    function SetParticlesBg(elItemTile, rarityColor, modelPath, itemId) {
        const oColor = HexColorToRgb(rarityColor);
        let elParticlePanel = elItemTile.FindChildInLayoutFile('popup-acknowledge__item__particle');
        elParticlePanel.visible = !modelPath;
        if (!modelPath) {
            elParticlePanel.SetParticleNameAndRefresh('particles/ui/ui_item_present_bokeh.vpcf');
            elParticlePanel.SetControlPoint(16, oColor.r, oColor.g, oColor.b);
            elParticlePanel.StartParticles();
            return;
        }
        elParticlePanel.StopParticlesImmediately(false);
    }
    function HexColorToRgb(hex) {
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        return { r, g, b };
    }
    function ColorRarityBar(elItemTile, rarityColor) {
        const elBar = elItemTile.FindChildInLayoutFile('AcknowledgeBar');
        elBar.style.washColor = rarityColor;
    }
    function ShowGiftPanel(elItemTile, id) {
        const elPanel = elItemTile.FindChildInLayoutFile('AcknowledgeItemGift');
        const gifterId = ItemInfo.GetGifter(id);
        elPanel.SetHasClass('hidden', gifterId === '');
        const elLabel = elItemTile.FindChildInLayoutFile('AcknowledgeItemGiftLabel');
        elLabel.SetDialogVariable('name', FriendsListAPI.GetFriendName(gifterId));
        elLabel.text = $.Localize('#acknowledge_gifter', elLabel);
    }
    function ShowSetPanel(elItemTile, item) {
        const id = item.id;
        const elPanel = elItemTile.FindChildInLayoutFile('AcknowledgeItemSet');
        const elLabel = elItemTile.FindChildInLayoutFile('AcknowledgeItemSetLabel');
        const elImage = elItemTile.FindChildInLayoutFile('AcknowledgeItemSetImage');
        const strSetName = InventoryAPI.GetTag(id, 'ItemSet');
        if (!strSetName || strSetName === '0') {
            if (ItemInfo.IsKeychain(id) && item.pickuptype === 'xpshopredeem') {
                let m_szRemoveKeychainToolChargesForPurchase = 'Remove Keychain Tool Pack';
                let defidxForPurchase = InventoryAPI.GetItemDefinitionIndexFromDefinitionName(m_szRemoveKeychainToolChargesForPurchase);
                let fauxPurchaseItemID = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxForPurchase, 0);
                elLabel.SetDialogVariableInt('item_count', Number(InventoryAPI.GetItemAttributeValue(fauxPurchaseItemID, '{uint32}items count')));
                elLabel.text = $.Localize('#CSGO_RemoveKeychainToolCharges_Reward:f', elLabel);
                elImage.SetImage('file://{images}/icons/ui/keychain_removal.svg');
                elImage.SetHasClass('popup-acknowledge__subtitle_seticon_tiny', true);
                elPanel.SetHasClass('hide', false);
                return;
            }
            elPanel.SetHasClass('hide', true);
            return;
        }
        const setName = InventoryAPI.GetTagString(strSetName);
        if (!setName) {
            elPanel.SetHasClass('hide', true);
            return;
        }
        elLabel.text = setName;
        IconUtil.SetupFallbackItemSetIcon(elImage, strSetName);
        IconUtil.SetItemSetSVGImage(elImage, strSetName);
        elImage.SetHasClass('popup-acknowledge__subtitle_seticon_tiny', false);
        elPanel.SetHasClass('hide', false);
    }
    function ItemCount(elItemTile, index, numItems) {
        const elCountLabel = elItemTile.FindChildInLayoutFile('AcknowledgeItemCount');
        if (numItems < 2) {
            elCountLabel.visible = false;
            return;
        }
        elCountLabel.visible = true;
        elCountLabel.text = (index + 1) + ' / ' + numItems;
    }
    function GetItems() {
        const newItems = [];
        const itemCount = InventoryAPI.GetUnacknowledgeItemsCount();
        for (let i = 0; i < itemCount; i++) {
            const itemId = InventoryAPI.GetUnacknowledgeItemByIndex(i);
            const pickUpType = InventoryAPI.GetItemPickupMethod(itemId);
            let strCustomization = InventoryAPI.GetItemSessionPropertyValue(itemId, 'item_customization');
            if (!strCustomization || !(strCustomization.startsWith('crate_')
                || strCustomization.startsWith('nametag_')
                || strCustomization.startsWith('sticker_')
                || strCustomization.startsWith('keychain_')
                || strCustomization.startsWith('patch_')
                || strCustomization.startsWith('stattrack_')
                || strCustomization.startsWith('quest_')
                || strCustomization.startsWith('xpshop'))) {
                strCustomization = 'acknowledge';
            }
            if (ItemstoAcknowlegeRightAway(itemId))
                InventoryAPI.AcknowledgeNewItembyItemID(itemId);
            else
                newItems.unshift({ type: strCustomization, id: itemId, pickuptype: pickUpType });
        }
        const getUpdateItem = GetUpdatedItem();
        if (getUpdateItem && newItems.filter(item => item.id === getUpdateItem.id).length < 1) {
            newItems.push(getUpdateItem);
        }
        const priorityItemAckTypes = ["xpshopredeem", "quest_reward"];
        const rewardItems = newItems.filter(item => item.pickuptype && priorityItemAckTypes.includes(item.pickuptype));
        const otherItems = newItems.filter(item => !(item.pickuptype && priorityItemAckTypes.includes(item.pickuptype)));
        return rewardItems.concat(otherItems);
    }
    AcknowledgeItems_1.GetItems = GetItems;
    function GetItemsByType(afilters, bShouldAcknowledgeItems) {
        const aItems = GetItems();
        const alist = aItems.filter(oItem => afilters.includes(InventoryAPI.GetItemDefinitionName(oItem.id)));
        if (bShouldAcknowledgeItems) {
            AcknowledgeAllItems.AcknowledgeItems(alist);
        }
        return alist.map(item => item.id);
    }
    AcknowledgeItems_1.GetItemsByType = GetItemsByType;
    function GetUpdatedItem() {
        const itemidExplicitAcknowledge = $.GetContextPanel().GetAttributeString("ackitemid", '');
        if (itemidExplicitAcknowledge === '')
            return null;
        return {
            id: itemidExplicitAcknowledge,
            type: $.GetContextPanel().GetAttributeString("acktype", '')
        };
    }
    function ItemstoAcknowlegeRightAway(id) {
        const itemType = InventoryAPI.GetItemTypeFromEnum(id);
        return itemType === 'quest' ||
            itemType === 'coupon_crate' ||
            itemType === 'campaign';
    }
    function CarouselUpdated(elPanel) {
        $.Schedule(.15, () => {
            if (elPanel && elPanel.IsValid())
                ShowHideOpenItemInLayoutBtn(elPanel.Data().itemId);
        });
    }
    function ShowHideOpenItemInLayoutBtn(itemId) {
        m_focusedItemId = itemId;
        let category = InventoryAPI.GetLoadoutCategory(itemId);
        let isHidden = !category || ItemInfo.ItemHasCapability(itemId, 'decodable');
        if (m_elEquipBtn) {
            m_elEquipBtn.SetHasClass('hide', isHidden);
        }
    }
    let AcknowledgeAllItems;
    (function (AcknowledgeAllItems) {
        let itemsToSave = [];
        function SetItemsToSaveAsNew(items) {
            itemsToSave = items;
        }
        AcknowledgeAllItems.SetItemsToSaveAsNew = SetItemsToSaveAsNew;
        function AcknowledgeItems(alist) {
            const acklist = alist ? alist : itemsToSave;
            for (let item of acklist) {
                InventoryAPI.SetItemSessionPropertyValue(item.id, 'item_pickup_method', InventoryAPI.GetItemPickupMethod(item.id));
                if (item.type === 'acknowledge') {
                    InventoryAPI.SetItemSessionPropertyValue(item.id, 'recent', '1');
                    InventoryAPI.AcknowledgeNewItembyItemID(item.id);
                }
                else {
                    const bWasNew = InventoryAPI.AcknowledgeNewItembyItemID(item.id);
                    InventoryAPI.SetItemSessionPropertyValue(item.id, bWasNew ? 'recent' : 'updated', '1');
                    $.DispatchEvent('RefreshActiveInventoryList');
                }
            }
        }
        AcknowledgeAllItems.AcknowledgeItems = AcknowledgeItems;
        function OnActivate() {
            AcknowledgeItems();
            InventoryAPI.AcknowledgeNewBaseItems();
            InvokeJSCallback();
            OnCloseEvents();
        }
        AcknowledgeAllItems.OnActivate = OnActivate;
        function InvokeJSCallback() {
            const callbackResetAcknowlegePopupHandle = $.GetContextPanel().GetAttributeInt("callback", -1);
            if (callbackResetAcknowlegePopupHandle != -1) {
                UiToolkitAPI.InvokeJSCallback(callbackResetAcknowlegePopupHandle);
            }
        }
        AcknowledgeAllItems.InvokeJSCallback = InvokeJSCallback;
        function OnCloseEvents() {
            $.DispatchEvent('UIPopupButtonClicked', '');
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_new_item_accept', 'MOUSE');
        }
        AcknowledgeAllItems.OnCloseEvents = OnCloseEvents;
    })(AcknowledgeAllItems = AcknowledgeItems_1.AcknowledgeAllItems || (AcknowledgeItems_1.AcknowledgeAllItems = {}));
})(AcknowledgeItems || (AcknowledgeItems = {}));
