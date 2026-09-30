"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="avatar.ts" />
/// <reference path="common/sessionutil.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="rating_emblem.ts" />
var VanityPlayerInfo;
(function (VanityPlayerInfo) {
    function CreateOrUpdateVanityInfoPanel(elParent = null, oSettings = null) {
        if (!elParent) {
            elParent = $.GetContextPanel();
        }
        const idPrefix = "id-player-vanity-info-" + oSettings.playeridx;
        let newPanel = elParent.FindChildInLayoutFile(idPrefix);
        if (!newPanel) {
            newPanel = $.CreatePanel('Button', elParent, idPrefix);
            newPanel.BLoadLayout('file://{resources}/layout/vanity_player_info.xml', false, false);
            newPanel.AddClass('vanity-info-loc-' + oSettings.playeridx);
            newPanel.AddClass('show');
        }
        _SetName(newPanel, oSettings.xuid);
        _SetAvatar(newPanel, oSettings.xuid);
        _SetRank(newPanel, oSettings.xuid, oSettings.isLocalPlayer);
        _SetSkillGroup(newPanel, oSettings.xuid, oSettings.isLocalPlayer);
        _SetHonorIcon(newPanel, oSettings.xuid);
        _AddOpenPlayerCardAction(newPanel.FindChildInLayoutFile('vanity-info-container'), oSettings.xuid);
        _SetLobbyLeader(newPanel, oSettings.xuid);
        _ShowSettingsBtn(newPanel, oSettings.xuid);
        return newPanel;
    }
    VanityPlayerInfo.CreateOrUpdateVanityInfoPanel = CreateOrUpdateVanityInfoPanel;
    function DeleteVanityInfoPanel(elParent, index) {
        const idPrefix = "id-player-vanity-info-" + index;
        const elPanel = elParent.FindChildInLayoutFile(idPrefix);
        if (elPanel && elPanel.IsValid()) {
            elPanel.DeleteAsync(0);
        }
    }
    VanityPlayerInfo.DeleteVanityInfoPanel = DeleteVanityInfoPanel;
    function _RoundToPixel(context, value, axis) {
        const scale = axis === "x" ? context.actualuiscale_x : context.actualuiscale_y;
        return Math.round(value * scale) / scale;
    }
    function SetVanityInfoPanelPos(elParent, index, oPos, idPrefix, OnlyXOrY) {
        const elPanel = elParent.FindChildInLayoutFile(idPrefix);
        if (elPanel && elPanel.IsValid()) {
            switch (OnlyXOrY) {
                case 'x':
                    elPanel.style.transform = 'translateX( ' + oPos.x + 'px );';
                    break;
                case 'y':
                    elPanel.style.transform = 'translateY( ' + oPos.x + 'px );';
                    break;
                default:
                    elPanel.style.transform = 'translate3d( ' + _RoundToPixel(elParent, oPos.x, "x") + 'px, ' + _RoundToPixel(elParent, oPos.y, "y") + 'px, 0px );';
                    break;
            }
        }
    }
    VanityPlayerInfo.SetVanityInfoPanelPos = SetVanityInfoPanelPos;
    function _SetName(newPanel, xuid) {
        newPanel.SetDialogVariable('partyxuid', xuid);
    }
    function _SetAvatar(newPanel, xuid) {
        const elParent = newPanel.FindChildInLayoutFile('vanity-avatar-container');
        let elAvatar = elParent.FindChildInLayoutFile('JsPlayerVanityAvatar-' + xuid);
        if (!elAvatar) {
            elAvatar = $.CreatePanel("Panel", elParent, 'JsPlayerVanityAvatar-' + xuid);
            elAvatar.SetAttributeString('xuid', xuid);
            elAvatar.BLoadLayout('file://{resources}/layout/avatar.xml', false, false);
            elAvatar.BLoadLayoutSnippet("AvatarPlayerCard");
            elAvatar.AddClass('avatar--vanity');
        }
        Avatar.Init(elAvatar, xuid, 'partymember');
        if (MockAdapter.IsFakePlayer(xuid)) {
            const elAvatarImage = elAvatar.FindChildInLayoutFile("JsAvatarImage");
            elAvatarImage.PopulateFromPlayerSlot(MockAdapter.GetPlayerSlot(xuid));
        }
    }
    function _SetRank(newPanel, xuid, isLocalPlayer) {
        const elRankIcon = newPanel.FindChildInLayoutFile('vanity-xp-icon');
        const elXpBarInner = newPanel.FindChildInLayoutFile('vanity-xp-bar-inner');
        if (!isLocalPlayer || !MyPersonaAPI.IsInventoryValid()) {
            newPanel.FindChildInLayoutFile('vanity-xp-container').visible = false;
            return;
        }
        newPanel.FindChildInLayoutFile('vanity-xp-container').visible = true;
        const currentLvl = FriendsListAPI.GetFriendLevel(xuid);
        if (!MyPersonaAPI.IsInventoryValid() ||
            !currentLvl ||
            (!_HasXpProgressToFreeze() && !_IsPlayerPrime(xuid))) {
            newPanel.AddClass('no-valid-xp');
            return;
        }
        const bHasRankToFreezeButNoPrestige = (!_IsPlayerPrime(xuid) && _HasXpProgressToFreeze()) ? true : false;
        const currentPoints = FriendsListAPI.GetFriendXp(xuid);
        const pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
        if (bHasRankToFreezeButNoPrestige) {
            elXpBarInner.GetParent().visible = false;
        }
        else {
            const percentComplete = (currentPoints / pointsPerLevel) * 100;
            elXpBarInner.style.width = percentComplete + '%';
            elXpBarInner.GetParent().visible = true;
            _ShowPrestigeUpgrade(newPanel, xuid, isLocalPlayer);
        }
        elRankIcon.SetImage('file://{images}/icons/xp/level' + currentLvl + '.png');
        newPanel.RemoveClass('no-valid-xp');
    }
    function _SetSkillGroup(newPanel, xuid, isLocalPlayer) {
        let rating_type;
        let score;
        let wins;
        if (isLocalPlayer && !PartyListAPI.IsPartySessionActive()) {
            rating_type = 'Premier';
            score = MyPersonaAPI.GetPipRankCount(rating_type);
            wins = MyPersonaAPI.GetPipRankWins(rating_type);
        }
        else {
            rating_type = PartyListAPI.GetFriendCompetitiveRankType(xuid);
            score = PartyListAPI.GetFriendCompetitiveRank(xuid);
            wins = PartyListAPI.GetFriendCompetitiveWins(xuid);
        }
        let options = {
            root_panel: newPanel,
            do_fx: true,
            full_details: false,
            rating_type: rating_type,
            leaderboard_details: { score: score, matchesWon: wins },
            local_player: xuid === MyPersonaAPI.GetXuid()
        };
        RatingEmblem.SetXuid(options);
        newPanel.SetDialogVariable('rating-text', RatingEmblem.GetRatingDesc(newPanel));
    }
    function _SetHonorIcon(elPanel, xuid) {
        const elHonorIcon = elPanel.FindChildTraverse('jsHonorIcon');
        if (elHonorIcon) {
            elHonorIcon.Set(PartyListAPI.GetFriendXpTrailLevel(xuid), PartyListAPI.GetFriendPrimeEligible(xuid));
        }
    }
    function _ShowPrestigeUpgrade(elPanel, xuid, isLocalPlayer) {
        let bPrestigeAvailable = isLocalPlayer && (FriendsListAPI.GetFriendLevel(xuid) >= InventoryAPI.GetMaxLevel());
        elPanel.FindChildInLayoutFile('vanity-xp-prestige').SetHasClass('hidden', !bPrestigeAvailable);
        if (bPrestigeAvailable) {
            elPanel.FindChildInLayoutFile('vanity-xp-prestige').SetPanelEvent('onactivate', _OnActivateGetPrestigeButtonClickable);
        }
    }
    function _OnActivateGetPrestigeButtonClickable() {
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: '0',
            show_work_type_warning: false,
            work_type: 'prestigecheck'
        };
        elPanel.Data().oSettings = oSettings;
    }
    function UpdateVoiceIcon(elAvatar, xuid) {
        Avatar.UpdateTalkingState(elAvatar, xuid);
    }
    VanityPlayerInfo.UpdateVoiceIcon = UpdateVoiceIcon;
    function _HasXpProgressToFreeze() {
        return MyPersonaAPI.HasPrestige() || (MyPersonaAPI.GetCurrentLevel() > 2);
    }
    function _IsPlayerPrime(xuid) {
        return FriendsListAPI.GetFriendPrimeEligible(xuid);
    }
    function _SetLobbyLeader(elPanel, xuid) {
        elPanel.SetHasClass('is-not-leader', LobbyAPI.GetHostSteamID() !== xuid);
    }
    function _ShowSettingsBtn(elPanel, xuid) {
        elPanel.SetHasClass("show-controls", MyPersonaAPI.GetXuid() === xuid);
    }
    function _AddOpenPlayerCardAction(elPanel, xuid) {
        elPanel.SetPanelEvent("onactivate", () => {
            if (xuid !== "0") {
                const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('', '', 'file://{resources}/layout/context_menus/context_menu_playercard.xml', 'xuid=' + xuid, () => { });
                contextMenuPanel.AddClass("ContextMenu_NoArrow");
            }
        });
    }
    {
        if ($.DbgIsReloadingScript()) {
        }
    }
})(VanityPlayerInfo || (VanityPlayerInfo = {}));
