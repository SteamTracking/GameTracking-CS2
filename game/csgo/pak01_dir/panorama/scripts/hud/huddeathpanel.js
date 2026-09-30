"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/anim_background.ts" />
var HudDeathPanel;
(function (HudDeathPanel) {
    $.RegisterEventHandler('CSGOHudDeathPanelSetFlair', $.GetContextPanel(), OnSetFlairEvent);
    function OnSetFlairEvent(xuid, skillgroup) {
        let elAvatarFlair = $('#AvatarFlair');
        let elMedalText = $('#MedalText');
        let elAvatarFlairSS = $('#AvatarFlairSS');
        let elMedalTextSS = $('#MedalTextSS');
        let elPlayerAvatarSkillGroup = $('#PlayerAvatarSkillGroup');
        SetAnimBackground(xuid);
        let flairItemImage = GetFlairItemImage(xuid);
        if (flairItemImage !== '') {
            elAvatarFlair.RemoveClass('DeathPanel__AvatarFlair--Hidden');
            elAvatarFlair.SetImage('file://{images}' + flairItemImage + '_small.png');
            elAvatarFlairSS.RemoveClass('DeathPanel__AvatarFlair--Hidden');
            elAvatarFlairSS.SetImage('file://{images}' + flairItemImage + '_small.png');
            let flairItemName = InventoryAPI.GetFlairItemName(xuid);
            if (flairItemName === '') {
                elMedalText.AddClass('DeathPanel__MedalText--Hidden');
                elMedalTextSS.AddClass('DeathPanel__MedalText--Hidden');
            }
            else {
                elMedalText.RemoveClass('DeathPanel__MedalText--Hidden');
                elMedalText.text = flairItemName;
                elMedalTextSS.RemoveClass('DeathPanel__MedalText--Hidden');
                elMedalTextSS.text = flairItemName;
            }
        }
        else {
            elAvatarFlair.AddClass('DeathPanel__AvatarFlair--Hidden');
            elMedalText.AddClass('DeathPanel__MedalText--Hidden');
            elAvatarFlairSS.AddClass('DeathPanel__AvatarFlair--Hidden');
            elMedalTextSS.AddClass('DeathPanel__MedalText--Hidden');
        }
        if (skillgroup) {
            elPlayerAvatarSkillGroup.SetImage('file://{images}/icons/skillgroups/dangerzone' + skillgroup + '.svg');
            elPlayerAvatarSkillGroup.RemoveClass('DeathPanel__AvatarSkillGroup--Hidden');
        }
        else {
            elPlayerAvatarSkillGroup.AddClass('DeathPanel__AvatarSkillGroup--Hidden');
        }
    }
    function SetAnimBackground(xuid) {
        HudSpecatorBg.PickBg(xuid);
    }
    // Returns the image name for the given xuid
    // Returns empty string in case of failure
    function GetFlairItemImage(xuid) {
        if (xuid === '' || xuid === '0')
            return '';
        // We can't access the xuid inventory so we ask for the display item a different way
        let flairItemId = InventoryAPI.GetFlairItemId(xuid);
        if (flairItemId === "0" || !flairItemId) {
            let flairDefIdx = FriendsListAPI.GetFriendDisplayItemDefFeatured(xuid);
            flairItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(flairDefIdx, 0);
            if (flairItemId === "0" || !flairItemId)
                return '';
        }
        return InventoryAPI.GetItemInventoryImage(flairItemId);
    }
})(HudDeathPanel || (HudDeathPanel = {}));
