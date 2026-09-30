"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/popup_inspect_shared.ts" />
/// <reference path="../watchtile.ts" />
var PopupRedeemSouvenir;
(function (PopupRedeemSouvenir) {
    let m_scheduleHandle = null;
    let m_tournamentIndex = null;
    let m_matchId = '';
    let m_redeemsAvailable = 0;
    function Init() {
        $.GetContextPanel().FindChildInLayoutFile('popup-redeem-spinner').visible = false;
        m_tournamentIndex = $.GetContextPanel().GetAttributeString("tournamentindex", "");
        m_matchId = $.GetContextPanel().GetAttributeString("matchid", "");
        if (!m_tournamentIndex || !m_matchId) {
            OnClose();
            return;
        }
        _SetMatchTile();
        _SetDescText();
    }
    PopupRedeemSouvenir.Init = Init;
    ;
    function _SetMatchTile() {
        const elMatchtile = $.CreatePanel('Panel', $.GetContextPanel().FindChildInLayoutFile('id-popup-matchtile-redeem'), 'id-match-tile', {
            class: 'MatchTile--Redeem'
        });
        elMatchtile.Data().matchId = m_matchId;
        elMatchtile.BLoadLayout('file://{resources}/layout/matchtiles/tournament.xml', false, false);
        elMatchtile.RemoveClass('MatchTile--Collapse');
        watchTile.Init(elMatchtile);
    }
    ;
    function _SetDescText() {
        const coinId = InventoryAPI.GetActiveTournamentCoinItemId(parseInt(m_tournamentIndex));
        const elLabel = $.GetContextPanel().FindChildInLayoutFile('MessageLabel');
        if (!coinId || coinId === '0') {
            elLabel.visible = false;
            return;
        }
        let coinLevel = InventoryAPI.GetItemAttributeValue(coinId, "upgrade level");
        let coinRedeemsPurchased = InventoryAPI.GetItemAttributeValue(coinId, "operation drops awarded 1");
        if (coinRedeemsPurchased)
            coinLevel += coinRedeemsPurchased;
        const redeemed = InventoryAPI.GetItemAttributeValue(coinId, "operation drops awarded 0");
        var redeemsAvailable = coinLevel - redeemed;
        m_redeemsAvailable = redeemsAvailable;
        elLabel.SetDialogVariableInt('redeems', redeemsAvailable);
        elLabel.text = (redeemsAvailable > 1) ?
            $.Localize('#popup_redeem_souvenir_desc:f', elLabel) :
            $.Localize('#popup_redeem_souvenir_desc_single', elLabel);
        elLabel.visible = true;
    }
    ;
    function OnRedeem() {
        _ResetTimeouthandle();
        const coinId = InventoryAPI.GetActiveTournamentCoinItemId(parseInt(m_tournamentIndex));
        if (!coinId || coinId === '0') {
            return;
        }
        if (m_redeemsAvailable <= 0) {
            OnClose();
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_tournament_journal.xml', 'journalid=' + coinId);
            return;
        }
        const contextPanel = $.GetContextPanel();
        m_scheduleHandle = $.Schedule(5, () => _CancelWaitforCallBack(contextPanel));
        $.GetContextPanel().FindChildInLayoutFile('popup-redeem-spinner').visible = true;
        $.GetContextPanel().FindChildInLayoutFile('id-popup-redeem-btn').visible = false;
        MatchInfoAPI.RequestMatchTournamentSouvenir(m_matchId, coinId);
    }
    PopupRedeemSouvenir.OnRedeem = OnRedeem;
    ;
    function ItemCustomizationNotification(numericType, type, itemid) {
        _ResetTimeouthandle();
        if (type === 'souvenir_generated') {
            InventoryAPI.AcknowledgeNewItembyItemID(itemid);
            const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
            let oSettings = {
                item_id: itemid,
                inspect_only: true,
                hide_char_select: true,
                hide_all_action_items: true,
                show_market_link: false,
                hide_item_cert: true,
            };
            elPanel.Data().oSettings = oSettings;
            OnClose();
        }
    }
    PopupRedeemSouvenir.ItemCustomizationNotification = ItemCustomizationNotification;
    ;
    function _ResetTimeouthandle() {
        if (m_scheduleHandle) {
            $.CancelScheduled(m_scheduleHandle);
            m_scheduleHandle = null;
        }
    }
    ;
    function _CancelWaitforCallBack(elPanel) {
        m_scheduleHandle = null;
        if (!elPanel || !elPanel.IsValid()) {
            return;
        }
        elPanel.FindChildInLayoutFile('popup-redeem-spinner').visible = false;
        $.DispatchEvent('UIPopupButtonClicked', '');
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', function () {
        });
    }
    ;
    function OnClose() {
        _ResetTimeouthandle();
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupRedeemSouvenir.OnClose = OnClose;
    $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', ItemCustomizationNotification);
})(PopupRedeemSouvenir || (PopupRedeemSouvenir = {}));
