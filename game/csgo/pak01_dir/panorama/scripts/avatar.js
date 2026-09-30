"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/teamcolor.ts" />
var CAvatar = class {
    Init(elAvatar, xuid, type) {
        const sXuid = xuid.toString();
        switch (type) {
            case 'playercard':
            case 'partymember':
                this.SetImage(elAvatar, sXuid);
                this.SetFlair(elAvatar, sXuid, type);
                this.SetTeamColor(elAvatar, sXuid);
                this.SetLobbyLeader(elAvatar);
                break;
            case 'flair':
                this.SetImage(elAvatar, sXuid);
                this.SetFlair(elAvatar, sXuid, type);
                break;
            default:
                this.SetImage(elAvatar, sXuid);
                this.SetTeamColor(elAvatar, sXuid);
        }
    }
    UpdateTalkingState(elAvatar, xuid, bCalledFromScheduledFunction) {
        if (!elAvatar || !elAvatar.IsValid())
            return;
        const elSpeaking = elAvatar.FindChildTraverse('JsAvatarSpeaking');
        if (!elSpeaking)
            return;
        const bFriendIsTalking = PartyListAPI.GetFriendIsTalking(xuid);
        elSpeaking.SetHasClass('hidden', !bFriendIsTalking);
        if (bFriendIsTalking && (bCalledFromScheduledFunction || !elAvatar.GetAttributeString('updatetalkingstate', ''))) {
            const schfn = $.Schedule(.1, () => this.UpdateTalkingState(elAvatar, xuid, true));
            elAvatar.SetAttributeString('updatetalkingstate', '' + schfn);
        }
        if (!bFriendIsTalking) {
            elAvatar.SetAttributeString('updatetalkingstate', '');
        }
    }
    ;
    SetImage(elAvatar, xuid) {
        const elImage = elAvatar.FindChildTraverse('JsAvatarImage');
        if (xuid === '' || xuid === '0') {
            elImage.AddClass('hidden');
            return;
        }
        elImage.PopulateFromSteamID(xuid);
        elImage.RemoveClass('hidden');
    }
    ;
    SetFlair(elAvatar, xuid, type) {
        const elFlair = elAvatar.FindChildTraverse('JsAvatarFlair');
        if (xuid === '' || xuid === '0') {
            elFlair.AddClass('hidden');
            return;
        }
        let flairItemId = InventoryAPI.GetFlairItemId(xuid);
        if (flairItemId === "0" || !flairItemId) {
            const flairDefIdx = (type === 'partymember')
                ? PartyListAPI.GetFriendDisplayItemDefFeatured(xuid)
                : FriendsListAPI.GetFriendDisplayItemDefFeatured(xuid);
            flairItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(flairDefIdx, 0);
            if (flairItemId === "0" || !flairItemId) {
                elFlair.AddClass('hidden');
                return;
            }
        }
        const imagePath = InventoryAPI.GetItemInventoryImage(flairItemId);
        if (imagePath !== '') {
            elFlair.SetImage('file://{images}' + imagePath + '_small.png');
            elFlair.RemoveClass('hidden');
        }
    }
    ;
    SetTeamColor(elAvatar, xuid) {
        const teamColor = PartyListAPI.GetPartyMemberSetting(xuid, 'game/teamcolor');
        const elTeamColor = elAvatar.FindChildTraverse('JsAvatarTeamColor');
        if (!teamColor) {
            if (elTeamColor)
                elTeamColor.AddClass('hidden');
            return;
        }
        if (typeof TeamColor !== 'undefined') {
            const rgbColor = TeamColor.GetTeamColor(Number(teamColor));
            elTeamColor.RemoveClass('hidden');
            elTeamColor.style.washColor = 'rgb(' + rgbColor + ')';
        }
    }
    ;
    SetLobbyLeader(elAvatar) {
        if (!elAvatar.hasOwnProperty("GetAttributeString"))
            return;
        const show = elAvatar.GetAttributeString('showleader', '');
        const elLeader = elAvatar.FindChildTraverse('JsAvatarLeader');
        if (elLeader) {
            if (show === 'show')
                elLeader.RemoveClass('hidden');
            else
                elLeader.AddClass('hidden');
        }
    }
    ;
};
var Avatar = Avatar ?? new CAvatar();
