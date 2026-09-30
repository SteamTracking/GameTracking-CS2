"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
var PopupTournamentTeamsList;
(function (PopupTournamentTeamsList) {
    function Init() {
        let journalId = $.GetContextPanel().GetAttributeString("journalid", '');
        let graffitis = [];
        g_ActiveTournamentTeams.forEach(team => { graffitis.push(team.stickerid_graffiti); });
        graffitis.push(g_ActiveTournamentInfo.stickerid_graffiti);
        let elBackground = $.GetContextPanel().FindChild('id-popup-tournament-teams-bg');
        elBackground.style.backgroundImage = 'url( "file://{images}/tournaments/backgrounds/pickem_bg_' + $.GetContextPanel().GetAttributeString('eventid', '') + '.png");';
        elBackground.style.backgroundSize = 'cover';
        elBackground.style.backgroundPosition = ' 50% 50%;';
        $.GetContextPanel().SetHasClass('major-' + $.GetContextPanel().GetAttributeString('eventid', ''), true);
        graffitis.forEach(stickerid => {
            let itemid = ItemInfo.GetFauxItemIdForGraffiti(stickerid);
            let elTeam = $.CreatePanel("ItemImage", $.GetContextPanel().FindChildInLayoutFile('id-popup-tournament-teams'), 'graffiti_' + stickerid, {
                itemid: itemid,
                class: 'popup-tournament-select-spray-team'
            });
            elTeam.SetPanelEvent('onactivate', () => {
                InventoryAPI.SetItemAttributeValueAsync(journalId, "sticker slot 0 id", stickerid);
                LoadoutAPI.EquipItemInSlot('noteam', journalId, 'spray0');
                $.DispatchEvent('UIPopupButtonClicked', '');
            });
        });
    }
    PopupTournamentTeamsList.Init = Init;
    ;
})(PopupTournamentTeamsList || (PopupTournamentTeamsList = {}));
