"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/sessionutil.ts" />
/// <reference path="rating_emblem.ts" />
/// <reference path="avatar.ts" />
var PlayerCard;
(function (PlayerCard) {
    let _m_xuid = '';
    let _m_currentLvl = null;
    let _m_isSelf = false;
    let _m_bShownInFriendsList = false;
    let _m_tooltipDelayHandle = null;
    let _m_arrAdditionalSkillGroups = ['Wingman'];
    let _m_InventoryUpdatedHandler = null;
    let _m_ShowLockedRankSkillGroupState = false;
    let _m_cp = $.GetContextPanel();
    function Init() {
        _m_xuid = $.GetContextPanel().GetAttributeString('xuid', 'no XUID found');
        _m_isSelf = _m_xuid === MyPersonaAPI.GetXuid() ? true : false;
        _m_bShownInFriendsList = $.GetContextPanel().GetAttributeString('data-slot', '') !== '';
        $("#AnimBackground").PopulateFromSteamID(_m_xuid);
        _RegisterForInventoryUpdate();
        if (!_m_isSelf)
            FriendsListAPI.RequestFriendProfileUpdateFromScript(_m_xuid);
        FillOutFriendCard();
    }
    function _RegisterForInventoryUpdate() {
        _m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', UpdateAvatar);
        _m_cp.RegisterForReadyEvents(true);
        $.RegisterEventHandler('ReadyForDisplay', _m_cp, () => {
            if (!_m_InventoryUpdatedHandler) {
                _m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', UpdateAvatar);
            }
        });
        $.RegisterEventHandler('UnreadyForDisplay', _m_cp, () => {
            if (_m_InventoryUpdatedHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _m_InventoryUpdatedHandler);
                _m_InventoryUpdatedHandler = null;
            }
        });
    }
    function FillOutFriendCard() {
        if (_m_xuid) {
            _m_currentLvl = FriendsListAPI.GetFriendLevel(_m_xuid);
            _m_ShowLockedRankSkillGroupState = !_IsPlayerPrime() && _HasXpProgressToFreeze();
            UpdateName();
            _SetHonorIcon();
            _SetAvatar();
            _SetFlairItems();
            _SetPlayerBackground();
            _SetRank();
            _SetPrimeUpsell();
            if (_m_isSelf) {
                if (MyPersonaAPI.GetPipRankWins("Premier") >= 0) {
                    if (_m_bShownInFriendsList)
                        _SetSkillGroup('Premier');
                    else
                        SetAllSkillGroups();
                }
                else {
                    let elToggleBtn = $.GetContextPanel().FindChildInLayoutFile('SkillGroupExpand');
                    elToggleBtn.visible = false;
                }
            }
            else {
                SetAllSkillGroups();
            }
            if (_m_bShownInFriendsList) {
                $.GetContextPanel().FindChildInLayoutFile('JsPlayerCommendations').AddClass('hidden');
                $.GetContextPanel().FindChildInLayoutFile('JsPlayerPrime').AddClass('hidden');
                _SetTeam();
            }
            else {
                let bHasNoCommendsToShow = _SetCommendations();
                _SetPrime(bHasNoCommendsToShow);
            }
        }
    }
    function ProfileUpdated(xuid) {
        if (_m_xuid === xuid)
            FillOutFriendCard();
    }
    function UpdateName() {
        $.GetContextPanel().SetDialogVariable('xuid', _m_xuid);
    }
    function _SetHonorIcon() {
        const elHonorIcon = $.GetContextPanel().FindChildInLayoutFile('jsHonorIcon');
        if (elHonorIcon)
            elHonorIcon.Set(FriendsListAPI.GetFriendXpTrailLevel(_m_xuid), false);
    }
    function _SetAvatar() {
        let elAvatarExisting = $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardAvatar');
        if (!elAvatarExisting) {
            let elParent = $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardTop');
            let elAvatar = $.CreatePanel("Panel", elParent, 'JsPlayerCardAvatar');
            elAvatar.SetAttributeString('xuid', _m_xuid);
            elAvatar.BLoadLayout('file://{resources}/layout/avatar.xml', false, false);
            elAvatar.BLoadLayoutSnippet("AvatarPlayerCard");
            Avatar.Init(elAvatar, _m_xuid, 'playercard');
            elParent.MoveChildBefore(elAvatar, $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardName'));
        }
        else {
            Avatar.Init(elAvatarExisting, _m_xuid, 'playercard');
        }
    }
    function _SetPlayerBackground() {
        let flairDefIdx = FriendsListAPI.GetFriendDisplayItemDefFeatured(_m_xuid);
        let flairItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(flairDefIdx, 0);
        let imagePath = InventoryAPI.GetItemInventoryImage(flairItemId);
        let elBgImage = $.GetContextPanel().FindChildInLayoutFile('AnimBackground');
        elBgImage.style.backgroundImage = (imagePath) ? 'url("file://{images}' + imagePath + '.png")' : 'none';
        elBgImage.style.backgroundPosition = '50% 50%';
        elBgImage.style.backgroundSize = 'auto 165%';
        elBgImage.style.backgroundRepeat = 'no-repeat';
        elBgImage.style.blur = 'gaussian(2,2,1)';
        elBgImage.AddClass('player-card-bg-anim');
    }
    function _SetRank() {
        let elRank = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXp');
        if (!MyPersonaAPI.IsInventoryValid() || !_m_currentLvl || (!_HasXpProgressToFreeze() && !_IsPlayerPrime())) {
            elRank.AddClass('hidden');
            return;
        }
        if (!_IsPlayerPrime() && !_m_isSelf) {
            elRank.AddClass('hidden');
            return;
        }
        let bHasRankToFreezeButNoPrestige = (_m_ShowLockedRankSkillGroupState) ? true : false;
        let currentPoints = FriendsListAPI.GetFriendXp(_m_xuid), pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
        let elXpBarInner = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpBarInner');
        if (bHasRankToFreezeButNoPrestige) {
            elXpBarInner.GetParent().visible = false;
        }
        else {
            let percentComplete = (currentPoints / pointsPerLevel) * 100;
            elXpBarInner.style.width = percentComplete + '%';
            elXpBarInner.GetParent().visible = true;
        }
        if (_m_isSelf) {
            const xpBonuses = MyPersonaAPI.GetActiveXpBonuses();
            const bEligibleForCarePackage = xpBonuses.split(',').includes('2');
            $.GetContextPanel().SetHasClass('care-package-eligible', bEligibleForCarePackage);
            const petId = InventoryAPI.GetPetItemID();
            const nStage = petId ? Number(InventoryAPI.GetItemAttributeValue(petId, '{uint32}upgrade level')) : 0;
            $.GetContextPanel().SetHasClass('pet-feed-eligible', bEligibleForCarePackage && !!petId && nStage > 0);
        }
        let elRankText = $.GetContextPanel().FindChildInLayoutFile('JsPlayerRankName');
        elRankText.SetHasClass('player-card-prime-text', bHasRankToFreezeButNoPrestige);
        elRank.SetHasClass('player-card-nonprime-locked-xp-row', bHasRankToFreezeButNoPrestige);
        if (bHasRankToFreezeButNoPrestige) {
            elRankText.text = $.Localize('#Xp_RankName_Locked');
        }
        else {
            elRankText.SetDialogVariable('name', $.Localize('#SFUI_XP_RankName_' + _m_currentLvl));
            elRankText.SetDialogVariableInt('level', _m_currentLvl);
        }
        let elRankIcon = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpIcon');
        elRankIcon.SetImage('file://{images}/icons/xp/level' + _m_currentLvl + '.png');
        elRank.RemoveClass('hidden');
        let bPrestigeAvailable = _m_isSelf && (_m_currentLvl >= InventoryAPI.GetMaxLevel());
        $.GetContextPanel().FindChildInLayoutFile('GetPrestigeButton').SetHasClass('hidden', !bPrestigeAvailable);
        if (bPrestigeAvailable) {
            $.GetContextPanel().FindChildInLayoutFile('GetPrestigeButtonClickable').SetPanelEvent('onactivate', _OnActivateGetPrestigeButtonClickable);
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
    function SetAllSkillGroups() {
        let elSkillGroupContainer = $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardSkillGroupContainer');
        if (!_HasXpProgressToFreeze() && !_IsPlayerPrime()) {
            elSkillGroupContainer.AddClass('hidden');
            return;
        }
        _SetSkillGroup('Premier');
        _m_arrAdditionalSkillGroups.forEach(type => _SetSkillGroup(type));
        elSkillGroupContainer.RemoveClass('hidden');
    }
    function _SetSkillGroup(type) {
        _UpdateSkillGroup(_LoadSkillGroupSnippet(type), type);
    }
    function _LoadSkillGroupSnippet(type) {
        let id = 'JsPlayerCardSkillGroup-' + type;
        let elParent = $.GetContextPanel().FindChildInLayoutFile('SkillGroupContainer');
        let elSkillGroup = elParent.FindChildInLayoutFile(id);
        if (!elSkillGroup) {
            elSkillGroup = $.CreatePanel("Panel", elParent, id);
            elSkillGroup.BLoadLayoutSnippet('PlayerCardRatingEmblem');
            _ShowOtherRanksByDefault(elSkillGroup, type);
        }
        return elSkillGroup;
    }
    function _ShowOtherRanksByDefault(elSkillGroup, type) {
        let elToggleBtn = $.GetContextPanel().FindChildInLayoutFile('SkillGroupExpand');
        if (type !== 'Competitive' && _m_bShownInFriendsList) {
            elSkillGroup.AddClass('collapsed');
            return;
        }
        elToggleBtn.visible = _m_bShownInFriendsList ? true : false;
        if (!_m_bShownInFriendsList && _m_isSelf) {
            _AskForLocalPlayersAdditionalSkillGroups();
        }
    }
    function _AskForLocalPlayersAdditionalSkillGroups() {
        let hintLoadSkillGroups = '';
        for (let type of _m_arrAdditionalSkillGroups) {
            if (FriendsListAPI.GetFriendCompetitiveRank(_m_xuid, type) === -1) {
                hintLoadSkillGroups += (hintLoadSkillGroups ? ',' : '') + type;
            }
        }
        if (hintLoadSkillGroups) {
            MyPersonaAPI.HintLoadPipRanks(hintLoadSkillGroups);
        }
        _m_arrAdditionalSkillGroups.forEach(type => _SetSkillGroup(type));
    }
    function _UpdateSkillGroup(elSkillGroup, type) {
        const score = FriendsListAPI.GetFriendCompetitiveRank(_m_xuid, type);
        const wins = FriendsListAPI.GetFriendCompetitiveWins(_m_xuid, type);
        let options = {
            root_panel: elSkillGroup,
            rating_type: type,
            do_fx: true,
            full_details: true,
            leaderboard_details: { score: score, matchesWon: wins },
            local_player: _m_xuid === MyPersonaAPI.GetXuid()
        };
        let haveRating = RatingEmblem.SetXuid(options);
        let showRating = haveRating || MyPersonaAPI.GetXuid() === _m_xuid;
        elSkillGroup.SetHasClass('hidden', !showRating);
        elSkillGroup.SetDialogVariable('rating-text', RatingEmblem.GetRatingDesc(elSkillGroup));
        let skillGroupId = elSkillGroup.id;
        let tooltipText = RatingEmblem.GetTooltipText(elSkillGroup);
        elSkillGroup.SetPanelEvent('onmouseover', () => ShowSkillGroupTooltip(skillGroupId, tooltipText));
        elSkillGroup.SetPanelEvent('onmouseout', HideSkillGroupTooltip);
    }
    function _SetPrimeUpsell() {
        let elUpsellPanel = $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardPrimeUpsell');
        elUpsellPanel.SetHasClass('hidden', !MyPersonaAPI.IsInventoryValid() || _IsPlayerPrime() || !_m_isSelf);
        elUpsellPanel.FindChildInLayoutFile("id-player-card-prime-upsell-xp").visible = !_HasXpProgressToFreeze() && !_IsPlayerPrime();
        elUpsellPanel.FindChildInLayoutFile("id-player-card-prime-upsell-skillgroup").visible = !_HasXpProgressToFreeze() && !_IsPlayerPrime();
    }
    function _SetCommendations() {
        let catagories = [
            { key: 'friendly', value: 0 },
            { key: 'teaching', value: 0 },
            { key: 'leader', value: 0 }
        ];
        let catagoriesCount = catagories.length;
        let countHiddenCommends = 0;
        let elCommendsBlock = $.GetContextPanel().FindChildInLayoutFile('JsPlayerCommendations');
        for (let i = 0; i < catagoriesCount; i++) {
            catagories[i].value = FriendsListAPI.GetFriendCommendations(_m_xuid, catagories[i].key);
            let elCommend = $.GetContextPanel().FindChildInLayoutFile('JsPlayer' + catagories[i].key);
            if (!catagories[i].value || catagories[i].value === 0) {
                elCommend.AddClass('hidden');
                countHiddenCommends++;
            }
            else {
                if (elCommendsBlock.BHasClass('hidden'))
                    elCommendsBlock.RemoveClass('hidden');
                elCommend.RemoveClass('hidden');
                elCommend.FindChild('JsCommendLabel').text = String(catagories[i].value);
            }
        }
        elCommendsBlock.SetHasClass('hidden', countHiddenCommends === catagoriesCount && !_IsPlayerPrime());
        return countHiddenCommends === catagoriesCount;
    }
    function _SetPrime(bHasNoCommendsToShow) {
        let elPrime = $.GetContextPanel().FindChildInLayoutFile('JsPlayerPrime');
        if (!MyPersonaAPI.IsInventoryValid())
            elPrime.AddClass('hidden');
        if (_IsPlayerPrime()) {
            elPrime.RemoveClass('hidden');
            elPrime.FindChildInLayoutFile('JsCommendLabel').visible = bHasNoCommendsToShow;
            return;
        }
        else
            elPrime.AddClass('hidden');
    }
    function _IsPlayerPrime() {
        return FriendsListAPI.GetFriendPrimeEligible(_m_xuid);
    }
    function _HasXpProgressToFreeze() {
        return MyPersonaAPI.HasPrestige() || MyPersonaAPI.GetCurrentLevel() > 2;
    }
    function _SetTeam() {
        if (!_m_isSelf)
            return;
        let teamName = MyPersonaAPI.GetMyOfficialTeamName(), tournamentName = MyPersonaAPI.GetMyOfficialTournamentName();
        if (!teamName || !tournamentName) {
            $.GetContextPanel().FindChildInLayoutFile('JsPlayerTeam').AddClass('hidden');
            return;
        }
        $.GetContextPanel().FindChildInLayoutFile('JsPlayerXp').AddClass('hidden');
        $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardSkillGroupContainer').AddClass('hidden');
        $.GetContextPanel().FindChildInLayoutFile('JsPlayerTeam').RemoveClass('hidden');
        let teamTag = MyPersonaAPI.GetMyOfficialTeamTag();
        $.GetContextPanel().FindChildInLayoutFile('JsTeamIcon').SetImage('file://{images}/tournaments/teams/' + teamTag + '.svg');
        $.GetContextPanel().FindChildInLayoutFile('JsTeamLabel').text = teamName;
        $.GetContextPanel().FindChildInLayoutFile('JsTournamentLabel').text = tournamentName;
    }
    function _SetFlairItems() {
        let flairItems = FriendsListAPI.GetFriendDisplayItemDefCount(_m_xuid);
        let flairItemIdList = [];
        let elFlairPanal = $.GetContextPanel().FindChildInLayoutFile('FlairCarouselAndControls');
        if (!flairItems) {
            elFlairPanal.AddClass('hidden');
            return;
        }
        for (let i = 0; i < flairItems; i++) {
            let flairDefIdx = FriendsListAPI.GetFriendDisplayItemDefByIndex(_m_xuid, i);
            let flairItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(flairDefIdx, 0);
            flairItemIdList.push(flairItemId);
        }
        $.GetContextPanel().FindChildInLayoutFile('FlairCarousel').RemoveAndDeleteChildren();
        _MakeFlairCarouselPages(flairItemIdList);
        elFlairPanal.RemoveClass('hidden');
    }
    function _MakeFlairCarouselPages(flairItemIdList) {
        let countFlairItems = flairItemIdList.length;
        let elFlairCarousel = $.GetContextPanel().FindChildInLayoutFile('FlairCarousel');
        let elCarouselPage = null;
        for (let i = 0; i < countFlairItems; i++) {
            if (i % 5 === 0) {
                elCarouselPage = $.CreatePanel('Panel', elFlairCarousel, '', { class: 'playercard-flair-carousel__page' });
            }
            function onMouseOver(flairItemId, idForTooltipLocaation) {
                let tooltipText = InventoryAPI.GetItemName(flairItemId);
                UiToolkitAPI.ShowTextTooltip(idForTooltipLocaation, tooltipText);
            }
            ;
            let imagePath = InventoryAPI.GetItemInventoryImage(flairItemIdList[i]);
            let panelName = _m_xuid + flairItemIdList[i];
            if (elCarouselPage) {
                if (imagePath !== '') {
                    let elFlair = $.CreatePanel('Image', elCarouselPage, panelName, {
                        class: 'playercard-flair__icon',
                        src: 'file://{images}' + imagePath + '_small.png',
                        scaling: 'stretch-to-fit-preserve-aspect'
                    });
                    let flairItemId = flairItemIdList[i];
                    elFlair.SetPanelEvent('onmouseover', () => onMouseOver(flairItemId, panelName));
                    elFlair.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
                }
            }
        }
    }
    function ShowXpTooltip() {
        if (_m_ShowLockedRankSkillGroupState) {
            ShowSkillGroupTooltip('JsPlayerXpIcon', '#tooltip_xp_locked');
            return;
        }
        function ShowTooltip() {
            _m_tooltipDelayHandle = null;
            if (!_m_isSelf)
                return;
            if (_m_currentLvl && _m_currentLvl > 0)
                UiToolkitAPI.ShowCustomLayoutParametersTooltip('JsPlayerXpIcon', 'XpToolTip', 'file://{resources}/layout/tooltips/tooltip_player_xp.xml', 'xuid=' + _m_xuid);
        }
        ;
        _m_tooltipDelayHandle = $.Schedule(0.3, ShowTooltip);
    }
    PlayerCard.ShowXpTooltip = ShowXpTooltip;
    function HideXpTooltip() {
        if (_m_ShowLockedRankSkillGroupState) {
            HideSkillGroupTooltip();
            return;
        }
        if (_m_tooltipDelayHandle) {
            $.CancelScheduled(_m_tooltipDelayHandle);
            _m_tooltipDelayHandle = null;
        }
        UiToolkitAPI.HideCustomLayoutTooltip('XpToolTip');
    }
    PlayerCard.HideXpTooltip = HideXpTooltip;
    function ShowSkillGroupTooltip(id, tooltipText) {
        function ShowTooltipSkill() {
            _m_tooltipDelayHandle = null;
            UiToolkitAPI.ShowTextTooltip(id, tooltipText);
        }
        ;
        _m_tooltipDelayHandle = $.Schedule(0.3, ShowTooltipSkill);
    }
    function HideSkillGroupTooltip() {
        if (_m_tooltipDelayHandle) {
            $.CancelScheduled(_m_tooltipDelayHandle);
            _m_tooltipDelayHandle = null;
        }
        UiToolkitAPI.HideTextTooltip();
    }
    function UpdateAvatar() {
        _SetAvatar();
        _SetPlayerBackground();
        _SetFlairItems();
        _SetPrimeUpsell();
        _SetRank();
    }
    function ShowHideAdditionalRanks() {
        let elToggleBtn = $.GetContextPanel().FindChildInLayoutFile('SkillGroupExpand');
        if (elToggleBtn.checked) {
            _AskForLocalPlayersAdditionalSkillGroups();
        }
        for (let type of _m_arrAdditionalSkillGroups) {
            $.GetContextPanel().FindChildInLayoutFile('JsPlayerCardSkillGroup-' + type).SetHasClass('collapsed', !elToggleBtn.checked);
        }
    }
    PlayerCard.ShowHideAdditionalRanks = ShowHideAdditionalRanks;
    {
        if ($.DbgIsReloadingScript()) {
        }
        Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_GC_Hello', FillOutFriendCard);
        $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_ProfileUpdated', ProfileUpdated);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_PipRankUpdate', SetAllSkillGroups);
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_PlayerUpdated", UpdateAvatar);
    }
})(PlayerCard || (PlayerCard = {}));
