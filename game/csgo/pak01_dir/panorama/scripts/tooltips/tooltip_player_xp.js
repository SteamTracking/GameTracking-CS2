"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/formattext.ts" />
var TooltipPlayerXp;
(function (TooltipPlayerXp) {
    function Init() {
        let xuid = $.GetContextPanel().GetAttributeString("xuid", "not-found");
        let rawBonuses = MyPersonaAPI.GetActiveXpBonuses();
        let bonusesArray = rawBonuses.split(",");
        let maxLevel = InventoryAPI.GetMaxLevel();
        let currentPoints = FriendsListAPI.GetFriendXp(xuid);
        let pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
        let currentLvl = FriendsListAPI.GetFriendLevel(xuid);
        let isDueServiceMedal = currentLvl >= maxLevel;
        $.GetContextPanel().SetDialogVariable("xpcurrent", String(currentPoints));
        $.GetContextPanel().SetDialogVariable("xptonext", String(pointsPerLevel - currentPoints));
        $("#JsTooltip_Xp_Current").text = isDueServiceMedal ? "#tooltip_xp_have_max_current" : "#tooltip_xp_current";
        $("#JsTooltip_Xp_Needed").text = isDueServiceMedal ? "#tooltip_xp_have_max_rank" : "#tooltip_xp_for_next_rank";
        if (bonusesArray.length > 0) {
            // Remove the bonus for drops if you are due a service medal.
            // We don't give you your next drop till you redeem the medal.
            if (isDueServiceMedal) {
                for (let i = 0; i < bonusesArray.length; i++) {
                    if (bonusesArray[i] === '2')
                        bonusesArray.splice(i, 1);
                }
            }
        }
        let numBonusesAdded = 0;
        if (bonusesArray.length > 0) {
            // Remove the bonus for drops if you are due a service medal.
            // We don't give you your next drop till you redeem the medal.
            $('#JsTooltipXpSection').RemoveClass('hidden');
            $("#JsTooltipXpBonuses").RemoveAndDeleteChildren();
            for (let i = 0; i < bonusesArray.length; i++) {
                if (!bonusesArray[i])
                    continue;
                ++numBonusesAdded;
                $.Msg('bonusesArray: ' + i + ': ' + bonusesArray[i]);
                let newTile = $.CreatePanel("Label", $("#JsTooltipXpBonuses"), 'JsTooltipBonus' + i, { html: true });
                let secRemaining = StoreAPI.GetSecondsUntilXpRollover();
                newTile.SetDialogVariable('time-to-week-rollover', (secRemaining > 0) ? FormatText.SecondsToSignificantTimeString(secRemaining) : '');
                newTile.AddClass('tooltip-player-xp__subtitle');
                newTile.text = $.Localize("#tooltip_xp_bonus_" + bonusesArray[i], newTile);
                if (bonusesArray[i] == '2') {
                    const petId = InventoryAPI.GetPetItemID();
                    const nStage = petId ? Number(InventoryAPI.GetItemAttributeValue(petId, '{uint32}upgrade level')) : 0;
                    if (nStage > 0 && !!petId) {
                        const rtFoodExp = Number(InventoryAPI.GetItemAttributeValue(petId, '{uint32}pet food expiration date'));
                        const rtPetUpgr = Number(InventoryAPI.GetItemAttributeValue(petId, '{uint32}pet next upgrade date'));
                        if (rtFoodExp && rtPetUpgr && (rtFoodExp < rtPetUpgr)) {
                            let newTile = $.CreatePanel("Label", $("#JsTooltipXpBonuses"), 'JsTooltipBonus' + i, { html: true });
                            newTile.AddClass('tooltip-player-xp__subtitle');
                            newTile.text = $.Localize("#tooltip_xp_bonus_pet_feed", newTile);
                        }
                    }
                }
            }
            // xp trail
            let xpTrailTimeRemaining = MyPersonaAPI.GetXpTrailTimeRemaining();
            if (xpTrailTimeRemaining > 0) {
                ++numBonusesAdded;
                let newTile = $.CreatePanel("Label", $("#JsTooltipXpBonuses"), 'JsTooltipBonus_xptrail', { html: true });
                newTile.SetDialogVariable('xptrail-time-remaining', FormatText.SecondsToSignificantTimeString(xpTrailTimeRemaining));
                newTile.AddClass('tooltip-player-xp__subtitle');
                newTile.text = $.Localize("#tooltip_xp_bonus_xptrail", newTile);
            }
        }
        if (!numBonusesAdded) {
            $('#JsTooltipXpSection').AddClass('hidden');
        }
    }
    TooltipPlayerXp.Init = Init;
})(TooltipPlayerXp || (TooltipPlayerXp = {}));
