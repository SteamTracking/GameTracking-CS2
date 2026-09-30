"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/hold_button.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="popup_inspect_shared.ts" />
/// <reference path="popup_can_apply_pick_slot.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
/// <reference path="../common/shopping_cart.ts" />
var InspectAsyncActionBar;
(function (InspectAsyncActionBar) {
    let m_scheduleHandle = null;
    function Init() {
        const worktype = InspectShared.GetPopupSetting('work_type');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        const allowRental = InspectShared.GetPopupSetting('allow_rent');
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        $.GetContextPanel().AddClass('PopupPanelCapability_' + worktype);
        const purchaseItemId = InspectShared.GetPopupSetting('purchase_item_id');
        if (InspectShared.GetPopupSetting('force_hide_async_bar') ||
            !worktype ||
            (allowRental && !showXrayMachineUi) ||
            (worktype === 'nameable' && !toolId) ||
            purchaseItemId && showXrayMachineUi ||
            _DoesNotMeetDecodalbeRequirements()) {
            elAsyncActionBarPanel.AddClass('hidden');
            return;
        }
        elAsyncActionBarPanel.RemoveClass('hidden');
        _SetUpDescription(elAsyncActionBarPanel);
        _SetUpButtonStates(elAsyncActionBarPanel);
        elAsyncActionBarPanel.FindChildInLayoutFile('InspectWeaponBtn').checked = true;
        _ShowHideInspectViewButtons(elAsyncActionBarPanel);
        _ChangeSceneryBtn(elAsyncActionBarPanel);
        _ShowZoomBtn(elAsyncActionBarPanel);
        elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkCancelBtn').SetPanelEvent('onactivate', () => {
            if (_DefaultZoomView(worktype, elAsyncActionBarPanel) === false)
                _ClosePopup();
        });
        if (worktype === 'prestigecheck') {
            _OnAccept($.GetContextPanel().Data().oSettings, elAsyncActionBarPanel);
        }
        const cp = $.GetContextPanel();
        if (!elAsyncActionBarPanel.Data().PanelRegisteredForEvents) {
            elAsyncActionBarPanel.Data().PanelRegisteredForEvents = $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', (...args) => {
                return _OnItemCustomization(...args, cp);
            });
            if (worktype !== 'decodeable' && worktype !== 'nameable' && worktype !== 'remove_sticker') {
                $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _OnMyPersonaInventoryUpdated);
                $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_PrestigeCoinResponse', _OnInventoryPrestigeCoinResponse);
            }
            if (worktype === 'craft_souvenir') {
                $.RegisterForUnhandledEvent('PanoramaComponent_Store_VolatileShopSubscribe', (...args) => { _OnVolatileShopSubscribe(...args, cp); });
                _EnsureVolatileShopSubscribed(cp);
            }
        }
    }
    InspectAsyncActionBar.Init = Init;
    function _EnsureVolatileShopSubscribed(cp) {
        if (!cp || !cp.IsValid())
            return;
        if (cp.Data().refreshSubscriptionHandle) {
            $.CancelScheduled(cp.Data().refreshSubscriptionHandle);
            cp.Data().refreshSubscriptionHandle = null;
        }
        StoreAPI.VolatileShopSubscribe(g_ActiveTournamentInfo.itemid_dynamic_stickers, true);
        cp.Data().refreshSubscriptionHandle = $.Schedule(150, () => _EnsureVolatileShopSubscribed(cp));
    }
    function _DoesNotMeetDecodalbeRequirements() {
        if (InspectShared.GetPopupSetting('work_type') === 'decodeable') {
            const sRestriction = InventoryAPI.GetDecodeableRestriction(InspectShared.GetPopupSetting('item_id'));
            const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
            if (sRestriction === 'restricted' || (sRestriction === 'xray' && !showXrayMachineUi) || InspectShared.GetPopupSetting('inspect_only'))
                return false;
            return (!InspectShared.GetPopupSetting('tool_id') && !InspectShared.GetPopupSetting('is_keyless'));
        }
        return false;
    }
    function _PerformAsyncAction(oSettings, bForceRemoveSticker = false) {
        const worktype = oSettings.work_type;
        const itemId = oSettings.item_id;
        const toolId = oSettings.tool_id;
        const bAllowXray = oSettings.allow_xray_claim;
        const selectedSlot = parseInt($.GetContextPanel().GetAttributeString('selectedItemToApplySlot', ''));
        if (worktype === 'useitem' || worktype === 'usegift') {
            InventoryAPI.UseTool(itemId, '');
        }
        else if (worktype === 'delete') {
            InventoryAPI.DeleteItem(itemId);
        }
        else if (worktype === 'prestigecheck') {
            InventoryAPI.RequestPrestigeCoinCheck();
        }
        else if (worktype === 'prestigeget' || worktype === 'prestigeupgrade') {
            InventoryAPI.RequestPrestigeCoin(InventoryAPI.GetItemDefinitionIndex(itemId));
        }
        else if (worktype === 'nameable') {
            $.DispatchEvent("CSGOPlaySoundEffect", "rename_applyConfirm", "MOUSE");
            InventoryAPI.UseTool(toolId, itemId);
            if ($.GetContextPanel().FindChildInLayoutFile('NameableRemoveConfirm')) {
                $.GetContextPanel().FindChildInLayoutFile('NameableRemoveConfirm').enabled = false;
                $.GetContextPanel().FindChildInLayoutFile('NameableValidBtn').enabled = false;
            }
        }
        else if (worktype === 'remove_patch') {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.StickerScratch', 'MOUSE');
            InventoryAPI.WearItemSticker(itemId, selectedSlot, 0);
        }
        else if (worktype === 'remove_keychain') {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.StickerScratch', 'MOUSE');
            InventoryAPI.RemoveKeychain(itemId, 0);
        }
        else if (worktype === 'remove_sticker') {
            if (oSettings.remove_sticker_all_at_once) {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UI.StickerScratch', 'MOUSE');
                _ClosePopup();
                const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + itemId, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
                let oSouvenirSettings = {
                    item_id: itemId,
                    tool_id: '',
                    umid_souvenir: oSettings.umid_souvenir,
                    work_type: 'craft_souvenir'
                };
                elPanel.Data().oSettings = oSouvenirSettings;
                return;
            }
            CapabilityCanSticker.OnScratchSticker(itemId, selectedSlot, bForceRemoveSticker, oSettings.popup_panel);
        }
        else if (worktype === 'can_wrap_sticker' && !oSettings.tool_id) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applyConfirm', 'MOUSE');
            InventoryAPI.RemoveKeychain(itemId, 0);
        }
        else if (worktype === 'can_sticker' || worktype === 'can_patch' || worktype === 'can_keychain' || worktype === 'can_wrap_sticker') {
            $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applyConfirm', 'MOUSE');
            InventoryAPI.SetStickerToolSlot(itemId, selectedSlot);
            InventoryAPI.UseTool(toolId, itemId);
        }
        else if (worktype === 'craft_souvenir') {
            const fauxCartItemID = oSettings.temp_display_item_id;
            const nPurchaseCost = _ComputeTotalSouvenirCost(oSettings.popup_panel, fauxCartItemID).discountPrice;
            const strPurchaseCommand = 'craft_souvenir:' + itemId + ':' + oSettings.umid_souvenir;
            m_SouvenirCheckoutCart = ShoppingCart.findOrCreateTempCart(itemId, true);
            const shopItem = {
                id: fauxCartItemID,
                name: ItemInfo.GetFormattedName(fauxCartItemID),
                price: nPurchaseCost,
                checkout_id: strPurchaseCommand
            };
            m_SouvenirCheckoutCart.clearCart();
            m_SouvenirCheckoutCart.addItem(shopItem);
            $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applyConfirm', 'MOUSE');
            const popupPanel = UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-shopping-cart-checkout', 'file://{resources}/layout/popups/popup_shopping_cart_checkout.xml', 'cartid=' + itemId +
                '&checkoutsuffix=_souvenir');
            popupPanel.Data().eventId = g_ActiveTournamentInfo.eventid;
        }
        else if (worktype === 'decodeable') {
            if (ItemInfo.IsSpraySealed(itemId) || ItemInfo.ItemDefinitionNameSubstrMatch(itemId, 'tournament_pass_')) {
                InventoryAPI.UseTool(itemId, '');
            }
            else if (InventoryAPI.GetDecodeableRestriction(itemId) === "xray" && !bAllowXray) {
                InventoryAPI.UseTool(itemId, itemId);
            }
            else if (InventoryAPI.GetItemAttributeValue(itemId, '{uint32}volatile container')) {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UI.Laptop.Unlock', 'MOUSE');
                InventoryAPI.UseTool(toolId, itemId);
            }
            else {
                InventoryAPI.UseTool(toolId, itemId);
            }
            if (InventoryAPI.GetDecodeableRestriction(itemId) !== "xray") {
                $.DispatchEvent('StartDecodeableAnim');
            }
        }
    }
    function _SetUpButtonStates(elPanel) {
        const elOK = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptConfirm');
        const elNegative = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegative');
        const worktype = InspectShared.GetPopupSetting('work_type');
        const itemId = InspectShared.GetPopupSetting('item_id');
        let sOkButtonText = '#popup_' + worktype + '_button';
        if (InspectShared.GetPopupSetting('is_workshop_preview')) {
            elOK.AddClass('hidden');
            if (elNegative)
                elNegative.AddClass('hidden');
        }
        const oSettings = $.GetContextPanel().Data().oSettings;
        function _SetPanelEventOnAccept() {
            elOK.SetPanelEvent('onactivate', () => _OnAccept(oSettings, elPanel));
        }
        if (worktype === '') {
            return;
        }
        if (worktype === 'can_wrap_sticker') {
            elOK.visible = false;
            elNegative.visible = false;
            const toolId = InspectShared.GetPopupSetting('tool_id');
            ;
            const btnId = toolId ? 'AsyncItemWorkAcceptConfirmHold' : 'AsyncItemWorkAcceptNegativeHold';
            const btnHoldAction = elPanel.FindChildInLayoutFile(btnId);
            const locString = !toolId ? '#popup_' + worktype + '_button_negative' : '#popup_' + worktype + '_button';
            btnHoldAction.RemoveClass('AsyncItemWorkAcceptNegativeHidden');
            const btnSettings = {
                btn: btnHoldAction,
                tooltip: !toolId ? '#popup_' + worktype + '_button_negative_tooltip' : '#popup_' + worktype + '_button_tooltip',
                locString: locString,
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _OnAccept(oSettings, elPanel);
                    btnHoldAction.enabled = false;
                }
            };
            HoldButton.SetupButton(btnSettings);
            return;
        }
        if (worktype === 'craft_souvenir') {
            elOK.visible = false;
            elNegative.visible = false;
            const btnId = 'AsyncItemWorkAcceptConfirmHold';
            const btnHoldAction = elPanel.FindChildInLayoutFile(btnId);
            let locString = '#popup_' + worktype + '_button';
            btnHoldAction.RemoveClass('AsyncItemWorkAcceptNegativeHidden');
            const btnSettings = {
                btn: btnHoldAction,
                locString: locString,
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _OnAccept(oSettings, elPanel);
                }
            };
            const tempCreatedItem = InspectShared.GetPopupSetting('temp_display_item_id');
            btnHoldAction.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowCustomLayoutParametersTooltip(btnHoldAction.id, 'tooltip-souvenir-receipt', 'file://{resources}/layout/tooltips/tooltip_souvenir_receipt.xml', 'itemid=' + tempCreatedItem);
            });
            btnHoldAction.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideCustomLayoutTooltip('tooltip-souvenir-receipt');
            });
            HoldButton.SetupButton(btnSettings);
            btnHoldAction.enabled = true;
            _DiscountPanel(oSettings.popup_panel, elPanel);
            const umidSouvenir = InspectShared.GetPopupSetting('umid_souvenir');
            const elButtonChangeSouvenirItem = elPanel.FindChildInLayoutFile('ChangeSouvenirItem');
            elButtonChangeSouvenirItem.RemoveClass('hidden');
            elButtonChangeSouvenirItem.SetPanelEvent('onactivate', () => {
                $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
                _ClosePopup();
                $.DispatchEvent('ShowSelectItemForCapabilityPopup', umidSouvenir, '', 'craft_souvenir');
            });
            const elMakeSouvenirPlayerSelect = elPanel.FindChildInLayoutFile('MakeSouvenirPlayerSelect');
            elMakeSouvenirPlayerSelect.RemoveClass('hidden');
            const goldenItemId = InspectShared.GetPopupSetting('temp_display_item_id');
            const unTeamIDs = [InventoryAPI.GetItemAttributeValue(goldenItemId, '{uint32}tournament event team0 id'),
                InventoryAPI.GetItemAttributeValue(goldenItemId, '{uint32}tournament event team1 id')];
            const unPlayerID = InventoryAPI.GetItemAttributeValue(goldenItemId, '{uint32}tournament mvp account id');
            let arrSelections = [];
            const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
            g_ActiveTournamentTeams.filter((tt) => unTeamIDs.includes(tt.teamid)).forEach((tt) => {
                tt.players.forEach((tp) => {
                    let sPlayerName = $.Localize('#SFUI_ProPlayer_' + tp.code, elPanel).split(" ");
                    sPlayerName.splice(1, 0, ...["'" + tp.nick + "'"]);
                    const idFauxSticker = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, tp.stickerids[tp.stickerids.length - 1]);
                    let unCostInCredits = MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, idFauxSticker);
                    arrSelections.push({
                        unPlayerID: tp.playerid,
                        sPlayerName: sPlayerName.join(" "),
                        sTeamTag: tt.team,
                        unCostInCredits: unCostInCredits,
                        unStickerID: tp.stickerids[tp.stickerids.length - 1]
                    });
                });
            });
            arrSelections.sort((a, b) => (a.unCostInCredits - b.unCostInCredits) * 100000 + (a.unStickerID - b.unStickerID));
            arrSelections.forEach((sel) => {
                let elOption = $.CreatePanel('Panel', elMakeSouvenirPlayerSelect, 'id-MakeSouvenirPlayerSelect-p' + sel.unPlayerID);
                elOption.BLoadLayoutSnippet('craft-souvenir-dropdown-select-player-entry');
                let elNamePanel = elOption.FindChildInLayoutFile('id-craft-souvenir-dropdown-select-player-entry-name');
                elNamePanel.text = sel.sPlayerName;
                elOption.FindChildInLayoutFile('id-craft-souvenir-dropdown-select-player-entry-cost')
                    .SetDialogVariableInt('cost', sel.unCostInCredits);
                elOption.FindChildInLayoutFile('id-team-player-logo')
                    .SetImage("file://{images}/tournaments/teams/" + sel.sTeamTag + ".svg");
                elOption.SetAttributeUInt32('playerid', sel.unPlayerID);
                if (sel.unPlayerID != unPlayerID) {
                    elNamePanel.SetPanelEvent('onactivate', () => {
                        $.DispatchEvent("Activated", elNamePanel.GetParent(), "mouse");
                    });
                }
                else {
                    elOption.AddClass('craft_souvenir_dropdown_selected');
                }
                elMakeSouvenirPlayerSelect.AddOption(elOption);
            });
            elMakeSouvenirPlayerSelect.SetPanelEvent('oninputsubmit', () => {
                const elSelected = elMakeSouvenirPlayerSelect.GetSelected();
                const nNewPlayerID = elSelected.GetAttributeUInt32('playerid', 0);
                if (nNewPlayerID && unPlayerID != nNewPlayerID) {
                    let oNewSettings = {
                        item_id: itemId,
                        tool_id: '',
                        umid_souvenir: 'pid_' + nNewPlayerID + ':' + (umidSouvenir.split(':').pop()),
                        work_type: 'craft_souvenir'
                    };
                    _ClosePopup();
                    const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('popup-inspect-' + itemId, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml');
                    elPanel.AddClass('PopupPanelCapability_' + oNewSettings.work_type);
                    elPanel.Data().oSettings = oNewSettings;
                }
            });
            elMakeSouvenirPlayerSelect.SetSelected('id-MakeSouvenirPlayerSelect-p' + unPlayerID);
            return;
        }
        if (worktype === 'remove_keychain') {
            elOK.visible = false;
            elNegative.visible = false;
            const btnHoldAction = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
            btnHoldAction.RemoveClass('AsyncItemWorkAcceptNegativeHidden');
            const btnSettings = {
                btn: btnHoldAction,
                tooltip: '#SFUI_Keychain_Remove_Tooltip',
                locString: '#popup_' + worktype + '_button',
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _OnAccept(oSettings, elPanel);
                    btnHoldAction.enabled = false;
                }
            };
            HoldButton.SetupButton(btnSettings);
            return;
        }
        if (worktype === 'remove_patch') {
            elOK.visible = false;
            elNegative.visible = false;
            const btnHoldAction = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
            btnHoldAction.RemoveClass('AsyncItemWorkAcceptNegativeHidden');
            const btnSettings = {
                btn: btnHoldAction,
                tooltip: '#SFUI_Patch_Remove_Desc_Tooltip',
                locString: '#popup_' + worktype + '_button',
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _OnAccept(oSettings, elPanel);
                    btnHoldAction.enabled = false;
                }
            };
            HoldButton.SetupButton(btnSettings);
            return;
        }
        if (worktype === 'remove_sticker') {
            const bRemovingAllStickersForSouvenir = !!InspectShared.GetPopupSetting('remove_sticker_all_at_once');
            if (bRemovingAllStickersForSouvenir)
                elOK.visible = false;
            elNegative.visible = false;
            const btnHoldAction = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
            btnHoldAction.RemoveClass('AsyncItemWorkAcceptNegativeHidden');
            const btnSettings = {
                btn: btnHoldAction,
                tooltip: bRemovingAllStickersForSouvenir ? '#SFUI_Sticker_WipeStickersImmediate_Tooltip' : '#SFUI_Sticker_RemoveImmediate_Tooltip',
                locString: '#popup_' + worktype + '_button_negative' + (bRemovingAllStickersForSouvenir ? '_wipestickers' : ''),
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _OnAccept(oSettings, elPanel, true);
                    btnHoldAction.enabled = false;
                }
            };
            HoldButton.SetupButton(btnSettings);
        }
        if (worktype === 'delete') {
            elNegative.visible = false;
            elOK.visible = false;
            const btnHoldAction = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
            btnHoldAction.RemoveClass('AsyncItemWorkAcceptNegativeHidden');
            const btnSettings = {
                btn: btnHoldAction,
                tooltip: '#popup_delete_tooltip',
                locString: '#popup_' + worktype + '_button',
                loopingSound: 'UI.Laptop.ButtonFillLoop',
                timerCompleteAction: () => {
                    _OnAccept(oSettings, elPanel, true);
                    btnHoldAction.enabled = false;
                }
            };
            HoldButton.SetupButton(btnSettings);
            return;
        }
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const itemDefName = InventoryAPI.GetItemDefinitionName(itemId);
        const btnStyle = InspectShared.GetPopupSetting('override_async_btn_style') === false ?
            'Positive' :
            InspectShared.GetPopupSetting('override_async_btn_style');
        if (worktype === 'decodeable') {
            const sRestriction = InventoryAPI.GetDecodeableRestriction(itemId);
            const elDescLabel = elPanel.FindChildInLayoutFile('AsyncItemWorkDesc');
            const elDescImage = elPanel.FindChildInLayoutFile('AsyncItemWorkDescImage');
            const inspectOnly = InspectShared.GetPopupSetting('inspect_only');
            if (inspectOnly || sRestriction === 'restricted' && !$.GetContextPanel().Data().existingRewardFromXrayId) {
                elOK.visible = false;
                elDescLabel.visible = false;
                elDescImage.visible = false;
                return;
            }
            if (InspectShared.GetPopupSetting('is_xray_machine')) {
                const enabled = InspectShared.GetPopupSetting('allow_xray_claim') ? true : false;
                EnableDisableOkBtn(elPanel, enabled);
                elOK.AddClass(btnStyle);
                elOK.text = '#popup_xray_claim_item';
                _SetPanelEventOnAccept();
                return;
            }
            if (sRestriction === 'xray' && !inspectOnly) {
                elOK.visible = true;
                elOK.text = '#popup_xray_button_goto';
                elOK.AddClass(btnStyle);
                elOK.SetPanelEvent('onactivate', () => {
                    $.DispatchEvent("ShowXrayCasePopup", !toolId ? '' : toolId, itemId, true);
                    _ClosePopup();
                });
                elDescLabel.visible = true;
                elDescLabel.text = '#popup_decodeable_async_xray_desc';
                elDescImage.visible = false;
                return;
            }
            const terminalValue = InventoryAPI.GetItemAttributeValue(itemId, '{uint32}volatile container');
            const isTerminal = (terminalValue == '' || terminalValue == undefined || terminalValue == 0) ? false : true;
            if (itemDefName && itemDefName.indexOf("spray") != -1)
                sOkButtonText = sOkButtonText + "_graffiti";
            else if (itemDefName && itemDefName.indexOf("tournament_pass_") != -1)
                sOkButtonText = sOkButtonText + "_fantoken";
            else if (terminalValue)
                sOkButtonText = sOkButtonText + "_terminal";
            const elDropdown = elPanel.FindChildInLayoutFile('AsyncOfferLimitDropdown');
            elDropdown.SetHasClass('hidden', !isTerminal);
            if (isTerminal)
                _SetUpOfferLimitDropdown(elDropdown);
        }
        if (worktype === 'can_sticker') {
            const listStickers = ItemInfo.GetitemStickerList(itemId);
            elOK.SetDialogVariableInt('sticker_count', listStickers.length + 1);
            elOK.SetDialogVariableInt('max_stickers', 5);
        }
        if (worktype === 'nameable' && itemDefName === 'casket') {
            sOkButtonText = '#popup_newcasket_button';
        }
        if (worktype === 'useitem') {
            if (itemDefName && itemDefName.startsWith('Remove Keychain Tool')) {
                elOK.SetDialogVariableInt('item_count', Number(InventoryAPI.GetItemAttributeValue(itemId, '{uint32}items count')));
                sOkButtonText = '#popup_useitem_button_getkeychaincharges:f';
            }
            if (itemDefName && itemDefName.startsWith('XpShopTicket')) {
                const bHasPrime = FriendsListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid());
                sOkButtonText = bHasPrime ? '#xpshop_pass_activate_open_armory' : '#SFUI_Elevated_Status_upgrade_status';
            }
            if (itemDefName?.includes('tournament_pass_') && itemDefName?.includes('_credits')) {
                $.GetContextPanel().Data().majorCreditsToClaim = Number(InventoryAPI.GetItemAttributeValue(itemId, '{uint32}upgrade level'));
            }
        }
        elOK.text = sOkButtonText;
        elOK.AddClass(btnStyle);
        _SetPanelEventOnAccept();
    }
    function _DiscountPanel(popup_panel, elAsyncBar) {
        const oPriceData = _ComputeTotalSouvenirCost(popup_panel);
        const elDiscount = elAsyncBar.FindChildInLayoutFile('id-souvenir-discount');
        if (oPriceData.discountAmount > 0) {
            elDiscount.SetHasClass('hidden', false);
            elDiscount.SetDialogVariableInt('discount', oPriceData.discountAmount);
            elDiscount.SetDialogVariableInt('price', oPriceData.discountPrice);
            elDiscount.SetDialogVariableInt('original-price', oPriceData.originalPrice);
        }
        else
            elDiscount.SetHasClass('hidden', true);
    }
    function _SetUpOfferLimitDropdown(elDropdown) {
        const oLimits = JSON.parse(InventoryAPI.GetVolatileLimits());
        for (let i = 0; i < oLimits.choices.length; i++) {
            if (!elDropdown.HasOption('id-dropdown-limit-' + oLimits.choices[i].limit)) {
                let elOption = $.CreatePanel('Label', elDropdown, 'id-dropdown-limit-' + oLimits.choices[i].limit, {
                    class: 'DropDownMenu'
                });
                elOption.SetDialogVariable('limit', $.Localize(oLimits.choices[i].label));
                elOption.text = $.Localize('#offer_limit_setting', elOption);
                elOption.SetAttributeUInt32('limit', oLimits.choices[i].limit);
                elDropdown.AddOption(elOption);
            }
        }
        elDropdown.SetPanelEvent('oninputsubmit', () => _OnOfferLimitDropdownSubmit(elDropdown));
        elDropdown.SetSelected('id-dropdown-limit-' + oLimits.limit);
    }
    function _OnOfferLimitDropdownSubmit(elDropdown) {
        const elSelected = elDropdown.GetSelected();
        const nLimit = elSelected.GetAttributeUInt32('limit', 0);
        InventoryAPI.SetVolatileLimits(nLimit);
    }
    function _SetUpDescription(elPanel) {
        const elDescLabel = elPanel.FindChildInLayoutFile('AsyncItemWorkDesc');
        const elDescImage = elPanel.FindChildInLayoutFile('AsyncItemWorkDescImage');
        const worktype = InspectShared.GetPopupSetting('work_type');
        const toolId = InspectShared.GetPopupSetting('tool_id');
        const showAsyncActionDesc = InspectShared.GetPopupSetting('override_async_bar_desc');
        const showXrayMachineUi = InspectShared.GetPopupSetting('is_xray_machine');
        elDescLabel.SetHasClass('popup-capability-faded', showXrayMachineUi && !InspectShared.GetPopupSetting('allow_xray_claim'));
        elDescImage.SetHasClass('popup-capability-faded', showXrayMachineUi && !InspectShared.GetPopupSetting('allow_xray_claim'));
        if (showAsyncActionDesc) {
            elDescImage.itemid = toolId;
            const itemName = InventoryAPI.GetItemName(toolId);
            if (itemName) {
                elDescLabel.SetDialogVariable('itemname', itemName);
                elDescLabel.text = $.Localize('#popup_' + worktype + '_async_desc', elDescLabel);
            }
        }
        elDescLabel.visible = showAsyncActionDesc;
    }
    function EnableDisableOkBtn(elPanel, bEnable) {
        const elOK = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptConfirm');
        if (elOK.visible) {
            if (elOK.enabled !== bEnable)
                elOK.TriggerClass('popup-capability-update-anim');
            elOK.enabled = bEnable;
        }
        let elNegative = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegative');
        if (elNegative && elNegative.visible) {
            if (elNegative.enabled !== bEnable)
                elNegative.TriggerClass('popup-capability-update-anim');
            elNegative.enabled = bEnable;
        }
        elNegative = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
        if (elNegative && elNegative.visible) {
            if (elNegative.enabled !== bEnable)
                elNegative.TriggerClass('popup-capability-update-anim');
            elNegative.enabled = bEnable;
        }
    }
    InspectAsyncActionBar.EnableDisableOkBtn = EnableDisableOkBtn;
    function ShowHideOkBtn(elPanel, bShow) {
        const elOK = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptConfirm');
        elOK.SetHasClass('move-down', !bShow);
        let elNegative = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegative');
        if (elNegative)
            elNegative.SetHasClass('move-down', !bShow);
        elNegative = elPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
        if (elNegative)
            elNegative.SetHasClass('move-down', !bShow);
    }
    InspectAsyncActionBar.ShowHideOkBtn = ShowHideOkBtn;
    function _OnAccept(oSettings, elAsyncActionBarPanel, bForceRemoveSticker = false) {
        ResetTimeouthandle();
        const worktype = oSettings.work_type;
        const itemId = oSettings.item_id;
        if (worktype === 'useitem') {
            if (ItemInfo.ItemDefinitionNameSubstrMatch(itemId, 'XpShopTicket')) {
                const bHasPrime = FriendsListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid());
                if (!bHasPrime) {
                    UiToolkitAPI.ShowCustomLayoutPopup('prime_status', 'file://{resources}/layout/popups/popup_prime_status.xml');
                    return;
                }
                const oXpShopTrackProgress = InventoryAPI.GetCacheTypeElementJSOByIndex('XpShop', 0);
                const bTooManyTracks = (oXpShopTrackProgress && (oXpShopTrackProgress.xp_tracks.length >= StoreAPI.GetXpShopMaxTracks()));
                if (bTooManyTracks) {
                    UiToolkitAPI.ShowGenericPopupOk('#CSGO_Purchasable_XpShop_Ticket', '#CSGO_Purchasable_XpShop_Ticket_TooManyTracks', '', () => { });
                    return;
                }
                ResetTimeouthandle();
                _ClosePopup();
                $.DispatchEvent('MainMenuGoToStore', 'id-store-nav-xpshop');
                return;
            }
        }
        if (worktype === 'useitem' || worktype === 'decodeable') {
            const strToolType = InventoryAPI.GetToolType(itemId);
            if (strToolType === 'fantoken') {
                const nTournamentEventID = InventoryAPI.GetItemAttributeValue(itemId, '{uint32}tournament event id');
                if (nTournamentEventID && (nTournamentEventID > 0)) {
                    const coinItemId = InventoryAPI.GetActiveTournamentCoinItemId(nTournamentEventID);
                    if (coinItemId && (coinItemId !== '0')) {
                        $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applyConfirm', 'MOUSE');
                        UiToolkitAPI.ShowGenericPopupOk(InventoryAPI.GetItemName(coinItemId), '#Store_DuplicateItemInBackpack', '', () => {
                            ResetTimeouthandle();
                            _ClosePopup();
                            $.DispatchEvent("ShowCustomLayoutPopupParametersAsEvent", '', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'item_id=' + coinItemId +
                                ',inspect_only=true,force_inspect_view_type=primary');
                        });
                        return;
                    }
                }
            }
        }
        _PerformAsyncAction(oSettings, bForceRemoveSticker);
        if (worktype === 'craft_souvenir')
            return;
        let elNegative = elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegative');
        if (elNegative)
            elNegative.AddClass('hidden');
        elNegative = elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
        if (elNegative)
            elNegative.AddClass('hidden');
        elAsyncActionBarPanel.FindChildInLayoutFile('NameableSpinner').RemoveClass('hidden');
        elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkAcceptConfirm').AddClass('hidden');
    }
    function _ShowHideInspectViewButtons(elAsyncActionBarPanel) {
        const worktype = InspectShared.GetPopupSetting('work_type');
        if (worktype === 'can_sticker' || worktype === 'can_keychain') {
            const elApplyPickSlot = $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyPickSlot');
            elAsyncActionBarPanel.FindChildInLayoutFile('InspectWeaponBtn').SetPanelEvent('onactivate', () => {
                InspectModelImage.EndWeaponLookat();
                CanApplyPickSlot.ShowHideInfoPanel(false, elApplyPickSlot);
                CanApplyPickSlot.IsContinueEnabled(elApplyPickSlot);
                ShowHideOkBtn(elAsyncActionBarPanel, true);
                EnableDisableOkBtn(elAsyncActionBarPanel, !CanApplyPickSlot.IsContinueEnabled(elApplyPickSlot));
                elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkCancelBtn').text = "#GameUI_Close";
                if (elAsyncActionBarPanel.FindChildInLayoutFile('InspectItemModelZoom').visible) {
                    elAsyncActionBarPanel.FindChildInLayoutFile('InspectItemModelZoom').enabled = true;
                }
            });
            elAsyncActionBarPanel.FindChildInLayoutFile('LookatWeaponBtn').SetPanelEvent('onactivate', () => {
                InspectModelImage.StartWeaponLookat();
                CanApplyPickSlot.ShowHideInfoPanel(true, elApplyPickSlot);
                ShowHideOkBtn(elAsyncActionBarPanel, false);
                EnableDisableOkBtn(elAsyncActionBarPanel, false);
                elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkCancelBtn').text = "#SFUI_Back";
                elAsyncActionBarPanel.FindChildInLayoutFile('InspectItemModelZoom').enabled = false;
            });
            elAsyncActionBarPanel.FindChildInLayoutFile('InspectWeaponBtn').GetParent().SetHasClass('hidden', false);
        }
        else {
            elAsyncActionBarPanel.FindChildInLayoutFile('InspectWeaponBtn').GetParent().SetHasClass('hidden', true);
        }
        elAsyncActionBarPanel.FindChildInLayoutFile('ChangeScenery').SetHasClass('hidden', worktype === 'decodeable' || worktype === 'remove_patch'
            || worktype === 'can_wrap_sticker' || worktype === 'craft_souvenir'
            || worktype === 'remove_sticker' || worktype === 'remove_keychain');
    }
    function _ChangeSceneryBtn(elAsyncActionBarPanel) {
        elAsyncActionBarPanel.FindChildInLayoutFile('ChangeScenery').SetPanelEvent('onactivate', UpdateScenery);
    }
    function UpdateScenery() {
        UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-inspect-contextmenu-maps', '', 'file://{resources}/layout/context_menus/context_menu_mainmenu_vanity.xml', 'type=maps' +
            '&' + 'inspect-map=true', () => { $.DispatchEvent('ContextMenuEvent', ''); });
    }
    InspectAsyncActionBar.UpdateScenery = UpdateScenery;
    function EnableDisableChangeSceneryBtn(bEnable, elAsyncActionBarPanel) {
        elAsyncActionBarPanel.FindChildInLayoutFile('ChangeScenery').enabled = bEnable;
    }
    InspectAsyncActionBar.EnableDisableChangeSceneryBtn = EnableDisableChangeSceneryBtn;
    function _ShowZoomBtn(elAsyncActionBarPanel) {
        if (InspectModelImage.PanZoomEnabled() || InspectShared.GetPopupSetting('work_type') === 'nameable')
            return;
        const defName = InventoryAPI.GetItemDefinitionName(InspectShared.GetPopupSetting('item_id'));
        const result = InspectModelImage.m_CameraSettingsPerWeapon.find(({ type }) => type === defName);
        if (!result || !result.hasOwnProperty('zoom_camera'))
            return;
        const elZoomBtn = elAsyncActionBarPanel.FindChildInLayoutFile('InspectItemModelZoom');
        elZoomBtn.SetPanelEvent('onactivate', () => ZoomCamera(false, elAsyncActionBarPanel));
        elZoomBtn.SetHasClass('hidden', false);
    }
    function ZoomCamera(bForceZoomOut = false, elAsyncActionBarPanel) {
        const elZoomButton = elAsyncActionBarPanel.FindChildInLayoutFile('InspectItemModelZoom');
        if (bForceZoomOut) {
            InspectModelImage.ZoomCamera(false);
            elZoomButton.checked = false;
            return;
        }
        if (elZoomButton.checked) {
            InspectModelImage.ZoomCamera(true);
        }
        else {
            InspectModelImage.ZoomCamera(false);
        }
    }
    InspectAsyncActionBar.ZoomCamera = ZoomCamera;
    function OnCloseRemove(elAsyncActionBarPanel) {
        if (elAsyncActionBarPanel.IsValid()) {
            elAsyncActionBarPanel.FindChildInLayoutFile('NameableSpinner').AddClass('hidden');
            elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkAcceptConfirm').RemoveClass('hidden');
            let elNegative = elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegative');
            if (elNegative)
                elNegative.RemoveClass('hidden');
            elNegative = elAsyncActionBarPanel.FindChildInLayoutFile('AsyncItemWorkAcceptNegativeHold');
            if (elNegative)
                elNegative.RemoveClass('hidden');
        }
    }
    InspectAsyncActionBar.OnCloseRemove = OnCloseRemove;
    function _ClosePopup() {
        ResetTimeouthandle();
        HoldButton.StopLoopingSound('UI.Laptop.ButtonFillLoop');
        $.DispatchEvent('HideSelectItemForCapabilityPopup');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
    }
    function SetCallbackTimeout() {
        const elPanel = $.GetContextPanel();
        m_scheduleHandle = $.Schedule(5, () => _CancelWaitforCallBack(elPanel));
    }
    InspectAsyncActionBar.SetCallbackTimeout = SetCallbackTimeout;
    function _CancelWaitforCallBack(elPanel) {
        m_scheduleHandle = null;
        const elSpinner = elPanel.FindChildInLayoutFile('NameableSpinner');
        elSpinner.AddClass('hidden');
        _ClosePopup();
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', () => { });
    }
    function OnEventToClose() {
        const worktype = InspectShared.GetPopupSetting('work_type');
        const elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        if (_DefaultZoomView(worktype, elAsyncActionBarPanel) === false)
            _ClosePopup();
    }
    InspectAsyncActionBar.OnEventToClose = OnEventToClose;
    function _DefaultZoomView(worktype, elAsyncActionBarPanel) {
        if (elAsyncActionBarPanel && (worktype === 'can_sticker' || worktype === 'can_keychain')) {
            const elLookatBtn = elAsyncActionBarPanel.FindChildInLayoutFile('LookatWeaponBtn');
            if (elLookatBtn && elLookatBtn.IsValid()
                && elLookatBtn.checked
                && m_scheduleHandle === null) {
                $.DispatchEvent("Activated", elAsyncActionBarPanel.FindChildInLayoutFile('InspectWeaponBtn'), "mouse");
                return true;
            }
        }
        return false;
    }
    function ResetTimeouthandle() {
        if (m_scheduleHandle) {
            $.CancelScheduled(m_scheduleHandle);
            m_scheduleHandle = null;
        }
    }
    InspectAsyncActionBar.ResetTimeouthandle = ResetTimeouthandle;
    function _OnItemCustomization(numericType, type, itemid, cp = $.GetContextPanel()) {
        const worktype = InspectShared.GetPopupSetting('work_type');
        if (_IgnoreClose()) {
            ResetTimeouthandle();
            return;
        }
        if (worktype === 'craft_souvenir' && type === 'reward_redeemed') {
            _ClosePopup();
            return;
        }
        if (type === 'xp_shop_use_ticket' || type === 'xp_shop_ack_tracks') {
        }
        else if (type === 'keychain_tool_charges' && worktype === 'useitem') {
            const defidxContract = InventoryAPI.GetItemDefinitionIndexFromDefinitionName("Remove Keychain Tool");
            const fauxItemID = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxContract, 0);
            $.DispatchEvent("ShowCustomLayoutPopupParametersAsEvent", '', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'item_id=' + fauxItemID +
                ',' + 'inspect_only=true');
        }
        else if (type === 'seasontiers') {
            if (worktype === 'useitem') {
                const popupPanel = UiToolkitAPI.ShowCustomLayoutPopup('id-popup-major-store', 'file://{resources}/layout/popups/popup_major_store.xml');
                popupPanel.Data().activatedCredits = cp.Data().majorCreditsToClaim;
            }
            else {
                return;
            }
        }
        else {
            $.DispatchEvent('ShowAcknowledgePopup', type, itemid);
        }
        OnEventToClose();
    }
    function _IgnoreClose() {
        return InspectShared.GetPopupSetting('work_type') === 'decodeable';
    }
    function _ComputeTotalSouvenirCost(cp, itemIdSouvenir) {
        const tempCreatedItem = itemIdSouvenir ?? InspectShared.GetPopupSetting('temp_display_item_id');
        let nTotalCostInCredits = 0;
        {
            const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
            for (let i = 0; i < 6; ++i) {
                const idStickerKit = InventoryAPI.GetItemAttributeValue(tempCreatedItem, '{uint32}sticker slot ' + i + ' id');
                if (!idStickerKit)
                    continue;
                const idFauxSticker = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, idStickerKit);
                const unCostInCredits = MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, idFauxSticker);
                if (unCostInCredits)
                    nTotalCostInCredits += unCostInCredits;
                else
                    nTotalCostInCredits += g_ActiveTournamentInfo.souvenir_cost;
            }
        }
        const discountAmount = InventoryAPI.GetItemSouvenirDiscountPercent(tempCreatedItem);
        const discountCredits = Math.trunc(nTotalCostInCredits * discountAmount / 100);
        let discountPrice = nTotalCostInCredits;
        if (discountCredits < nTotalCostInCredits)
            discountPrice -= discountCredits;
        return { discountPrice: discountPrice, originalPrice: nTotalCostInCredits, discountAmount: discountAmount };
    }
    let m_SouvenirCheckoutCart = ShoppingCart.cart;
    function _OnVolatileShopSubscribe(nContainerDef, bNewPricesParsed, cp) {
        if (nContainerDef != g_ActiveTournamentInfo.itemid_dynamic_stickers)
            return;
        const nTotalCostInCredits = _ComputeTotalSouvenirCost(cp).discountPrice;
        if (m_SouvenirCheckoutCart !== ShoppingCart.cart) {
            m_SouvenirCheckoutCart.syncPrices((itemId) => {
                return nTotalCostInCredits;
            });
        }
        let oApplySettings = {
            headerPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyHeader'),
            infoPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpCanApplyPickSlot'),
            asyncBarPanel: $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar'),
            contextPanel: $.GetContextPanel(),
            itemId: InspectShared.GetPopupSetting('temp_display_item_id') ? InspectShared.GetPopupSetting('temp_display_item_id') : InspectShared.GetPopupSetting('item_id'),
            toolId: InspectShared.GetPopupSetting('tool_id'),
            isRemove: false,
            type: '',
            funcOnConfirm: () => { },
            funcOnNext: () => { },
            funcOnCancel: () => { },
            funcOnSelectForRemove: () => { }
        };
        CanApplyPickSlot.Init(oApplySettings);
        _DiscountPanel(oApplySettings.contextPanel, oApplySettings.asyncBarPanel);
    }
    function _OnMyPersonaInventoryUpdated() {
        if (InspectShared.GetPopupSetting('is_season_pass') && InventoryAPI.IsValidItemID(InspectShared.GetPopupSetting('item_id'))) {
            return;
        }
        const worktype = InspectShared.GetPopupSetting('work_type');
        if (worktype === "remove_sticker" ||
            worktype === "remove_patch" ||
            worktype === "remove_keychain" ||
            worktype === "can_sticker" ||
            worktype === "can_wrap_sticker" ||
            worktype === "craft_souvenir" ||
            worktype === "can_patch" ||
            worktype === "can_keychain" ||
            worktype === "useitem" ||
            worktype === "nameable") {
            return;
        }
        OnEventToClose();
    }
    function _OnInventoryPrestigeCoinResponse(defidx, upgradeid, hours, prestigetime) {
        OnEventToClose();
        if (InspectShared.GetPopupSetting('work_type') === 'prestigecheck') {
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
            let oSettings = {
                item_id: InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidx, 0),
                show_work_type_warning: false,
                work_type: (upgradeid === '0') ? 'prestigeget' : 'prestigeupgrade'
            };
            elPanel.Data().oSettings = oSettings;
        }
        else if (upgradeid !== '0') {
            InventoryAPI.AcknowledgeNewItembyItemID(upgradeid);
            InventoryAPI.SetItemSessionPropertyValue(upgradeid, 'recent', '1');
            $.DispatchEvent('InventoryItemPreview', upgradeid, '');
        }
    }
})(InspectAsyncActionBar || (InspectAsyncActionBar = {}));
