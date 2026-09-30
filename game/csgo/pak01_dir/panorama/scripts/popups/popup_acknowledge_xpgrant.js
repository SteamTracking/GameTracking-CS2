"use strict";
/// <reference path="../csgo.d.ts" />
var AcknowledgeXpGrant;
(function (AcknowledgeXpGrant) {
    let _m_xuid = MyPersonaAPI.GetXuid();
    let _m_currentLvl = FriendsListAPI.GetFriendLevel(_m_xuid);
    function OnLoad() {
        let elRankIcon = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpIcon');
        let elRankText = $.GetContextPanel().FindChildInLayoutFile('JsPlayerRankName');
        elRankText.SetDialogVariable('name', $.Localize('#SFUI_XP_RankName_' + _m_currentLvl));
        elRankText.SetDialogVariableInt('level', _m_currentLvl);
        elRankIcon.SetImage('file://{images}/icons/xp/level' + _m_currentLvl + '.png');
        let fauxItemID = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(4607, 0);
        let rarityColor = InventoryAPI.GetItemRarityColor(fauxItemID);
        rarityColor = "#8847ff";
        let elMovie = $.GetContextPanel().FindChildInLayoutFile('AcknowledgeMovie');
        elMovie.style.washColor = rarityColor;
        let elBar = $.GetContextPanel().FindChildInLayoutFile('AcknowledgeBar');
        elBar.style.washColor = rarityColor;
    }
    AcknowledgeXpGrant.OnLoad = OnLoad;
    ;
    function OnActivate() {
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.inventory_new_item_accept', 'MOUSE');
    }
    AcknowledgeXpGrant.OnActivate = OnActivate;
})(AcknowledgeXpGrant || (AcknowledgeXpGrant = {}));
