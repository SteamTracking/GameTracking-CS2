"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/popup_acknowledge_item.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var ContextMenuGetSouvenir;
(function (ContextMenuGetSouvenir) {
    let _m_redeemsAvailable = 0;
    let _m_coinId = '';
    let m_scheduleHandle;
    function Init() {
        let sUmids = $.GetContextPanel().GetAttributeString('umids', '');
        if (!sUmids) {
            $.GetContextPanel().SetHasClass('no-score', true);
            return;
        }
        $.GetContextPanel().SetHasClass('no-score', false);
        let tournamentIndex = $.GetContextPanel().GetAttributeString('tournamentId', '');
        _m_coinId = InventoryAPI.GetActiveTournamentCoinItemId(parseInt(tournamentIndex));
        if (_m_coinId && _m_coinId !== '0') {
            let coinLevel = parseInt(InventoryAPI.GetItemAttributeValue(_m_coinId, "upgrade level"));
            let coinRedeemsPurchased = parseInt(InventoryAPI.GetItemAttributeValue(_m_coinId, "operation drops awarded 1"));
            if (coinRedeemsPurchased)
                coinLevel += coinRedeemsPurchased;
            let redeemed = parseInt(InventoryAPI.GetItemAttributeValue(_m_coinId, "operation drops awarded 0"));
            _m_redeemsAvailable = coinLevel - redeemed;
        }
        let aUmids = sUmids.split(',');
        aUmids.forEach(umid => {
            let elParent = $.GetContextPanel().FindChildInLayoutFile('id-get-souvenir-matches-list');
            MakeMatch(elParent, umid);
        });
        _SetRedeemHeader();
    }
    ContextMenuGetSouvenir.Init = Init;
    function _SetRedeemHeader() {
        let elRedeemHeader = $.GetContextPanel().FindChildInLayoutFile('id-get-souvenir-matches-redeem');
        elRedeemHeader.visible = false;
        if (_m_redeemsAvailable > 0) {
            elRedeemHeader.visible = true;
            elRedeemHeader.SetDialogVariableInt('redeems', _m_redeemsAvailable);
            elRedeemHeader.SetDialogVariable('redeems-text', $.Localize('#popup_redeem_souvenir_desc:f', elRedeemHeader));
        }
        else {
            elRedeemHeader.GetParent().visible = false;
        }
    }
    function MakeMatch(elParent, umid) {
        let elMatch = elParent.FindChild(umid);
        if (!elMatch) {
            elMatch = $.CreatePanel("Panel", elParent, umid);
            elMatch.BLoadLayoutSnippet("get-souvenir-tile");
        }
        let team0 = MatchInfoAPI.GetMatchTournamentTeamTag(umid, 0);
        let team1 = MatchInfoAPI.GetMatchTournamentTeamTag(umid, 1);
        let res = MatchInfoAPI.GetMatchOutcome(umid);
        let team0Score = MatchInfoAPI.GetMatchRoundScoreForTeam(umid, 0);
        let team1Score = MatchInfoAPI.GetMatchRoundScoreForTeam(umid, 1);
        let bTteamSwap = (res == 2);
        elMatch.SetDialogVariableInt('match-score-0', bTteamSwap ? team1Score : team0Score);
        elMatch.SetDialogVariableInt('match-score-1', bTteamSwap ? team0Score : team1Score);
        elMatch.SetDialogVariable('teamname-0', bTteamSwap ?
            MatchInfoAPI.GetMatchTournamentTeamName(umid, 1) :
            MatchInfoAPI.GetMatchTournamentTeamName(umid, 0));
        elMatch.SetDialogVariable('teamname-1', bTteamSwap ?
            MatchInfoAPI.GetMatchTournamentTeamName(umid, 0) :
            MatchInfoAPI.GetMatchTournamentTeamName(umid, 1));
        elMatch.FindChildInLayoutFile('id-team-logo-0').SetImage("file://{images}/tournaments/teams/" +
            (bTteamSwap ? team1 : team0) + ".svg");
        elMatch.FindChildInLayoutFile('id-team-logo-1').SetImage("file://{images}/tournaments/teams/" +
            (bTteamSwap ? team0 : team1) + ".svg");
        var rawMapName = MatchInfoAPI.GetMatchMap(umid);
        let mapBg = elMatch.FindChild('id-map-bg');
        mapBg.style.backgroundImage = 'url("file://{images}/map_icons/screenshots/720p/' + rawMapName + '.png")';
        mapBg.style.backgroundPosition = '50% 50%';
        mapBg.style.backgroundSize = 'clip_then_cover';
        mapBg.style.backgroundImgOpacity = '.25';
        elMatch.FindChildInLayoutFile('id-map-logo').SetImage("file://{images}/map_icons/map_icon_" + rawMapName + ".svg");
        let tournamentId = $.GetContextPanel().GetAttributeString('tournamentId', '');
        _SetButtonHintText(elMatch, parseInt(tournamentId), umid);
        _SetPreviewBtn(elMatch, rawMapName, umid);
        elMatch.SetHasClass('show', true);
    }
    function _SetButtonHintText(elMatch, tournamentIndex, umid) {
        let elGetSouvenir = elMatch.FindChildInLayoutFile('id-get-souvenir');
        let elGetSouvenirBtn = elMatch.FindChildInLayoutFile('id-get-souvenir-btn');
        let elDropdown = elMatch.FindChildInLayoutFile('PurchaseCountDropdown');
        let tailUmid = umid.split('_').at(-1);
        const nEventID = MatchInfoAPI.GetMatchTournamentEventID(umid);
        const nStageID = MatchInfoAPI.GetMatchTournamentStageID(umid);
        const team0 = MatchInfoAPI.GetMatchTournamentTeamID(umid, 0);
        const team1 = MatchInfoAPI.GetMatchTournamentTeamID(umid, 1);
        const bPlayoffMatch = MatchInfoAPI.IsMatchTournamentStageIDPlayoff(nStageID);
        const bThisMatchHasRedeemsEnabled = !bPlayoffMatch || InventoryAPI.HasHighlightReelSchema(nEventID, nStageID, team0, team1);
        elGetSouvenir.SetHasClass('awaiting-highlights', !bThisMatchHasRedeemsEnabled && (nEventID < 26));
        if (nEventID >= 26) {
            let previewBtn = elMatch.FindChildInLayoutFile('id-preview-souvenir-btn');
            previewBtn.text = $.Localize('#popup_redeem_souvenir_action_craft');
            return;
        }
        if (_m_redeemsAvailable > 0) {
            elGetSouvenir.SetDialogVariable('price', $.Localize('#popup_redeem_souvenir_action_redeem'));
            elDropdown.visible = false;
            elGetSouvenir.SetHasClass('only-purchase', false);
            elGetSouvenirBtn.SetPanelEvent('onactivate', () => {
                _ResetTimeouthandle();
                MatchInfoAPI.RequestMatchTournamentSouvenir(umid, _m_coinId);
                $.GetContextPanel().FindChildInLayoutFile('id-get-souvenir-matches-spinner').visible = true;
                $.GetContextPanel().FindChildInLayoutFile('id-get-souvenir-matches-spinner').SetPanelEvent('onactivate', () => { });
                m_scheduleHandle = $.Schedule(5, () => _CancelWaitforCallBack());
            });
            return;
        }
        let defIndexForCharges = g_ActiveTournamentInfo.itemid_charge;
        let idFaux = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defIndexForCharges, 0);
        if (StoreAPI.GetStoreItemSalePrice(idFaux, 1, '')) {
            elGetSouvenir.SetDialogVariable('redeems-text', $.Localize('#popup_redeem_souvenir_action'));
            UpdateQuantity(elMatch);
            elGetSouvenirBtn.SetPanelEvent('onactivate', () => {
                _ResetTimeouthandle();
                let elDropdown = elMatch.FindChildInLayoutFile('PurchaseCountDropdown');
                let qty = Number(elDropdown.GetSelected().id);
                let purchaseList = [];
                for (let i = 0; i < qty; i++) {
                    purchaseList.push(defIndexForCharges + '(' + tailUmid + ')');
                }
                let purchaseString = purchaseList.join(',');
                StoreAPI.StoreItemPurchase(purchaseString);
            });
            elDropdown.visible = true;
            elGetSouvenir.SetHasClass('only-purchase', true);
            elDropdown.SetPanelEvent('oninputsubmit', () => UpdateQuantity(elMatch));
            return;
        }
        elGetSouvenir.visible = false;
    }
    ;
    function UpdateQuantity(elMatch) {
        if (!elMatch || !elMatch.IsValid())
            return;
        let elDropdown = elMatch.FindChildInLayoutFile('PurchaseCountDropdown');
        let qty = Number(elDropdown.GetSelected().id);
        let elGetSouvenir = elMatch.FindChildInLayoutFile('id-get-souvenir');
        let idForCharges = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(g_ActiveTournamentInfo.itemid_charge, 0);
        elGetSouvenir.SetDialogVariable('price', StoreAPI.GetStoreItemSalePrice(idForCharges, qty, ''));
    }
    ContextMenuGetSouvenir.UpdateQuantity = UpdateQuantity;
    function _ResetTimeouthandle() {
        if (m_scheduleHandle) {
            $.CancelScheduled(m_scheduleHandle);
            m_scheduleHandle = null;
        }
    }
    ;
    function _CancelWaitforCallBack() {
        m_scheduleHandle = null;
        const elPanel = $.GetContextPanel();
        if (!elPanel || !elPanel.IsValid()) {
            return;
        }
        elPanel.FindChildInLayoutFile('id-get-souvenir-matches-spinner').visible = false;
        $.DispatchEvent('ContextMenuEvent', '');
        UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', function () {
        });
    }
    ;
    function _SetPreviewBtn(elMatch, rawMapName, umid) {
        let previewBtn = elMatch.FindChildInLayoutFile('id-preview-souvenir-btn');
        StoreAPI.VolatileShopSubscribe(g_ActiveTournamentInfo.itemid_dynamic_stickers, true);
        previewBtn.SetPanelEvent('onactivate', () => {
            const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
            const idFauxSticker = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, g_ActiveTournamentInfo.stickerids[g_ActiveTournamentInfo.stickerids.length - 1]);
            if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, idFauxSticker)) {
                StoreAPI.VolatileShopSubscribe(g_ActiveTournamentInfo.itemid_dynamic_stickers, true);
                return;
            }
            $.DispatchEvent('CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE');
            $.DispatchEvent('ContextMenuEvent', '');
            $.DispatchEvent('ShowSelectItemForCapabilityPopup', umid, '', 'craft_souvenir');
        });
    }
    var _ItemCustomizationNotification = function (numericType, type, itemid) {
        _ResetTimeouthandle();
        if (type === 'souvenir_generated') {
            let itemsToAcknowledge = AcknowledgeItems.GetItems();
            if (itemsToAcknowledge.length > 0) {
                $.DispatchEvent('ShowAcknowledgePopup', '', '');
            }
            return;
        }
    };
    {
        $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', _ItemCustomizationNotification);
    }
})(ContextMenuGetSouvenir || (ContextMenuGetSouvenir = {}));
