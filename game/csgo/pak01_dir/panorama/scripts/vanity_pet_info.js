"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="avatar.ts" />
/// <reference path="common/sessionutil.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="rating_emblem.ts" />
var VanityPetInfo;
(function (VanityPetInfo) {
    // Null when the camera is pulled back.
    let _m_zoomedPetId = null;
    VanityPetInfo._m_idPrefix = "id-mainmenu-pet-info";
    let _m_infoPanel;
    let _m_textEntry;
    // let _m_elTimer:Panel_t;
    let _m_petId;
    let _m_scheduleEggTimerHandle;
    let _m_focusEventHandler;
    let _m_oldName = '';
    _m_scheduleEggTimerHandle = null;
    function CreateOrUpdatePetInfoPanel(elParent, petItemId) {
        let newPanel = elParent.FindChildInLayoutFile(VanityPetInfo._m_idPrefix);
        if (!petItemId || Number(petItemId) === 0) {
            // Hide info panel
            RemovePanel(elParent);
            return null;
        }
        if (!newPanel) {
            newPanel = $.CreatePanel('Panel', elParent, VanityPetInfo._m_idPrefix);
            newPanel.BLoadLayout('file://{resources}/layout/vanity_pet_info.xml', false, false);
        }
        _m_petId = petItemId;
        let nPetUpgradeLevel = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}upgrade level'));
        newPanel.SetHasClass('is-grown', nPetUpgradeLevel > 1);
        newPanel.SetHasClass('show', true);
        _m_infoPanel = newPanel;
        // _m_elTimer = newPanel.FindChildInLayoutFile( 'id-pet-milestone-egg' );
        _m_textEntry = newPanel.FindChildInLayoutFile('id-name-input-text');
        _m_textEntry.SetMaxChars(20);
        if (!_m_focusEventHandler) {
            _m_focusEventHandler = true;
            $.RegisterEventHandler('InputFocusLost', _m_textEntry, () => {
                if (newPanel.BHasClass('text-entry-active')) {
                    _CloseTextEntry();
                    newPanel.SetHasClass('hover-show', false);
                }
            });
        }
        // Pet can only be renamed once per life stage
        const bCanRenameThisLifeStage = (nPetUpgradeLevel >= 1) && !InventoryAPI.GetItemAttributeValue(petItemId, '{bytestring}custom name attr'
            + ((nPetUpgradeLevel >= 2) ? ' ' + nPetUpgradeLevel : ''));
        _SetButtonEvents(newPanel, petItemId, nPetUpgradeLevel, bCanRenameThisLifeStage);
        _HoverEvents(newPanel, nPetUpgradeLevel);
        _ShowFoodHint(newPanel, petItemId);
        let petName = InventoryAPI.GetItemName(petItemId);
        let elPetName = newPanel.FindChildInLayoutFile('id-pet-name');
        if (petItemId !== '' && petItemId !== undefined) {
            newPanel.SetDialogVariable('pet_name', InventoryAPI.HasCustomName(petItemId) ? petName : "");
            elPetName.SetHasClass('has-name', InventoryAPI.HasCustomName(petItemId));
            if (_m_oldName !== petName) {
                _m_oldName = petName;
                elPetName.TriggerClass('name-update');
                _CloseTextEntry();
            }
        }
        return newPanel;
    }
    VanityPetInfo.CreateOrUpdatePetInfoPanel = CreateOrUpdatePetInfoPanel;
    function RemovePanel(elParent) {
        let elPanel = elParent.FindChildInLayoutFile(VanityPetInfo._m_idPrefix);
        if (elPanel && elPanel.IsValid()) {
            CancelEggTimer();
            elPanel.RemoveClass('show');
        }
    }
    VanityPetInfo.RemovePanel = RemovePanel;
    function _RoundToPixel(context, value, axis) {
        const scale = axis === "x" ? context.actualuiscale_x : context.actualuiscale_y;
        return Math.round(value * scale) / scale;
    }
    function SetVanityPetInfoPos(elParent, oPos) {
        let elPanel = elParent.FindChildInLayoutFile("id-mainmenu-pet-info");
        if (!elPanel || !elPanel.IsValid()) {
            return;
        }
        elPanel.style.transform = 'translate3d( ' + _RoundToPixel(elParent, oPos.x, "x") + 'px, ' + _RoundToPixel(elParent, oPos.y, "y") + 'px, 0px );';
    }
    VanityPetInfo.SetVanityPetInfoPos = SetVanityPetInfoPos;
    function _HoverEvents(elPanel, nPetUpgradeLevel) {
        let elHoverTarget = elPanel.FindChild('id-vanity-pet-hitbox');
        elHoverTarget.SetPanelEvent('onmouseover', () => {
            if (!SessionUtil.BCanUseMyPetInCurrentLobby()) {
                return;
            }
            if (!InventoryAPI.GetPetItemID()) {
                return; // my pet was alive, but expired in the middle of this game session, prevent toolbar from coming up
            }
            _UpdateProgressBars(nPetUpgradeLevel);
            _ShowFoodHint(elPanel, InventoryAPI.GetPetItemID());
            elPanel.SetHasClass('hover-show', true);
        });
        elPanel.SetPanelEvent('onmouseout', () => {
            // CancelEggTimer();
            // Stays up while a name is being typed, so moving the mouse off does not take the text entry
            // with it. Closing that is InputFocusLost's job.
            elPanel.SetHasClass('hover-show', elPanel.BHasClass('text-entry-active'));
        });
    }
    function _SetButtonEvents(elPanel, petId, nPetUpgradeLevel, bCanRenameThisLifeStage) {
        // inspect		
        elPanel.FindChildInLayoutFile('id-inspect-pet').SetPanelEvent('onactivate', () => {
            $.DispatchEvent("InventoryItemPreview", petId, '');
        });
        // nametag	
        let elNameTag = elPanel.FindChildInLayoutFile('id-name-pet');
        if (bCanRenameThisLifeStage) {
            elNameTag.SetPanelEvent('onactivate', () => {
                _m_textEntry.text = _nameWithQuotes(petId);
                _m_textEntry.SetFocus();
                elPanel.SetHasClass('text-entry-active', true);
                $.DispatchEvent('CSGOPlaySoundEffect', 'sidemenu_slidein', 'MOUSE');
            });
        }
        elNameTag.SetHasClass('hide', !bCanRenameThisLifeStage);
        // A pet carrying a name from an earlier life stage is being renamed, not named.
        elNameTag.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-name-pet', InventoryAPI.HasCustomName(petId) ? '#pet_tooltip_rename' : '#pet_tooltip_name');
        });
        let elPhotoBooth = elPanel.FindChildInLayoutFile('id-photo-booth');
        elPhotoBooth.SetPanelEvent('onactivate', () => { _OpenPhotoBooth(nPetUpgradeLevel); });
        elPhotoBooth.SetHasClass('hide', nPetUpgradeLevel < 1);
        // picture book - hidden until the bird hatches, same gate the photo booth uses. Nothing can go
        // in the book before there is a chick to photograph.
        let elPetBook = elPanel.FindChildInLayoutFile('id-pet-book');
        elPetBook.SetPanelEvent('onactivate', _OpenPetBook);
        elPetBook.SetHasClass('hide', nPetUpgradeLevel < 1);
        elPanel.FindChildInLayoutFile('id-name-input-text-cancel').SetPanelEvent('onactivate', CancelTextEntry);
        elPanel.FindChildInLayoutFile('id-name-input-text-submit').SetPanelEvent('onactivate', () => { _SubmitText(petId); });
        elPanel.FindChildInLayoutFile('id-name-input-text-back').SetPanelEvent('onactivate', _CloseTextEntry);
        _EnableDisableSubmitButton(false);
    }
    function CancelTextEntry() {
        if (_m_infoPanel !== null && _m_infoPanel.IsValid())
            _m_textEntry.text = '';
    }
    VanityPetInfo.CancelTextEntry = CancelTextEntry;
    function _SubmitText(petId) {
        const fauxNameTag = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1200, 0); // "Name Tag"
        InventoryAPI.UseTool(fauxNameTag, petId);
    }
    function _EnableDisableSubmitButton(bEnable) {
        if (_m_infoPanel !== null && _m_infoPanel.IsValid()) {
            _m_infoPanel.FindChildInLayoutFile('id-name-input-text-submit').enabled = (bEnable && _m_textEntry.text != _nameWithQuotes(_m_petId));
        }
    }
    function _CloseTextEntry() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'sidemenu_slideout', 'MOUSE');
        _m_infoPanel.SetHasClass('text-entry-active', false);
    }
    function OnEntryChanged() {
        let isValid = InventoryAPI.SetNameToolString(_m_textEntry.text, '');
        _EnableDisableSubmitButton(isValid);
        $.DispatchEvent("CSGOPlaySoundEffect", "rename_teletype", "MOUSE");
    }
    VanityPetInfo.OnEntryChanged = OnEntryChanged;
    ;
    function _nameWithQuotes(petId) {
        let nameWithQuotes = InventoryAPI.GetItemName(petId);
        if (nameWithQuotes && nameWithQuotes.length > 4
            && nameWithQuotes[0] == "'" && nameWithQuotes[1] == "'"
            && nameWithQuotes[nameWithQuotes.length - 1] == "'" && nameWithQuotes[nameWithQuotes.length - 2] == "'") {
            return nameWithQuotes.substring(2, nameWithQuotes.length - 2);
        }
        else {
            return nameWithQuotes;
        }
    }
    function _BPetNeedsFood(petItemId) {
        const nPetUpgradeLevel = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}upgrade level'));
        if (nPetUpgradeLevel < 1)
            return false;
        const rtFoodExp = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}pet food expiration date'));
        const rtPetUpgr = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}pet next upgrade date'));
        return !!(rtFoodExp && rtPetUpgr && (rtFoodExp < rtPetUpgr));
    }
    function _ShowFoodHint(elPanel, petItemId) {
        const bLowFood = InventoryAPI.IsPetLowOnFood(petItemId);
        const bNeedsFood = _BPetNeedsFood(petItemId);
        elPanel.SetHasClass('low-food', bLowFood);
        elPanel.SetHasClass('needs-food', bNeedsFood);
        if (!bLowFood && !bNeedsFood)
            return;
        const elWarning = elPanel.FindChildInLayoutFile('id-pet-food-warning');
        const elIcon = elPanel.FindChildInLayoutFile('id-pet-food-warning-icon');
        const elLabel = elPanel.FindChildInLayoutFile('id-pet-food-warning-label');
        elIcon.SetImage(bLowFood ? 'file://{images}/icons/ui/warning.svg' : 'file://{images}/icons/ui/pet_feed.svg');
        const szHint = bLowFood ? '#pet_low_food_hint' : '#pet_needs_food_hint';
        if (InventoryAPI.HasCustomName(petItemId)) {
            elWarning.SetDialogVariable('name', _nameWithQuotes(petItemId));
            elLabel.text = $.Localize(szHint + '_name', elWarning);
            return;
        }
        elLabel.text = $.Localize(szHint);
    }
    // _BCanUsePet is the gate _HoverEvents uses to reveal the action row, so failing it leaves the
    // zoom-out button collapsed.
    function BShouldKeepZoom(petItemIdOnScreen) {
        return SessionUtil.BCanUseMyPetInCurrentLobby() && _m_zoomedPetId === petItemIdOnScreen;
    }
    VanityPetInfo.BShouldKeepZoom = BShouldKeepZoom;
    function SetZoomBtns(elMapPanel, elPanel, petItemId) {
        let elZoomInBtn = elPanel.FindChildInLayoutFile('id-zoom-in-pet');
        elZoomInBtn.SetPanelEvent('onactivate', () => {
            elMapPanel.TransitionToCamera('cam_pet', 1);
            $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Vanity.ZoomIn', 'MOUSE');
            elMapPanel.SetParallaxOffset(elMapPanel.Data().parallax_zoomed);
            _m_zoomedPetId = petItemId;
            elPanel.TriggerClass('hide-during-zoom');
            elPanel.SetHasClass('is-zoomed', true);
        });
        let elZoomOutBtn = elPanel.FindChildInLayoutFile('id-zoom-out-pet');
        elZoomOutBtn.SetPanelEvent('onactivate', () => {
            elMapPanel.TransitionToCamera('cam_default', 1);
            $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Vanity.ZoomOut', 'MOUSE');
            elMapPanel.SetParallaxOffset(elMapPanel.Data().parallax_unzoomed);
            _m_zoomedPetId = null;
            elPanel.SetHasClass('is-zoomed', false);
            elPanel.TriggerClass('hide-during-zoom');
        });
        // Restores the class when the panel is rebuilt for a pet that is already zoomed.
        elPanel.SetHasClass('is-zoomed', _m_zoomedPetId === petItemId);
    }
    VanityPetInfo.SetZoomBtns = SetZoomBtns;
    function ResetPetZoom(elMapPanel) {
        if (_m_zoomedPetId === null) {
            return;
        }
        // Silent on purpose: a 0s snap with no visible move, and it fires while navigating away.
        elMapPanel.TransitionToCamera('cam_default', 0);
        elMapPanel.SetParallaxOffset(elMapPanel.Data().parallax_unzoomed);
        _m_zoomedPetId = null;
        // Hidden along with its pet by now, so the camera reset above cannot depend on it.
        if (_m_infoPanel && _m_infoPanel.IsValid()) {
            _m_infoPanel.SetHasClass('is-zoomed', false);
        }
    }
    VanityPetInfo.ResetPetZoom = ResetPetZoom;
    // function _SetUpEggTimer( nPetUpgradeLevel: number, newPanel:Panel_t )
    // {
    // 	_m_elTimer = newPanel.FindChildInLayoutFile( 'id-pet-milestone-egg' );
    // 	_m_elTimer.SetPanelEvent( 'onmouseover', ()=>{
    // 		_m_elTimer.visible = true;
    // 		UiToolkitAPI.ShowTextTooltip( 'id-pet-clock', '#tooltip_pet_egg' );
    // 	});
    // 	_m_elTimer.SetPanelEvent( 'onmouseout', ()=>{
    // 		_m_elTimer.visible = false;
    // 		UiToolkitAPI.HideTextTooltip();
    // 	});
    // }
    // export function StartEggTimer()
    // {
    // 	if( !_m_elTimer || !_m_elTimer.IsValid() )
    // 	{
    // 		CancelEggTimer();
    // 		return;
    // 	}
    // 	CancelEggTimer();
    // 	let nGrowth =  InventoryAPI.GetPetGrowthPercent( _m_petId );
    // 	// $.Msg( 'eggtimer: ' + nGrowth );
    // 	const nDegrees = Math.floor( nGrowth * 360 );
    // 	(_m_elTimer.FindChild('id-pet-progress-bar-eg') as Panel_t).style.clip = 'radial(50% 50%, 0deg, ' + nDegrees + 'deg)';
    // 	if( !_m_scheduleEggTimerHandle )
    // 	{
    // 		_m_scheduleEggTimerHandle = $.Schedule( 10, StartEggTimer );
    // 	}
    // }
    function CancelEggTimer() {
        if (_m_scheduleEggTimerHandle) {
            // $.Msg( 'eggtimerCANCEL' );
            $.CancelScheduled(_m_scheduleEggTimerHandle);
            _m_scheduleEggTimerHandle = null;
        }
    }
    VanityPetInfo.CancelEggTimer = CancelEggTimer;
    function _UpdateProgressBars(nPetUpgradeLevel) {
        function _UpdateProgressMeter(idMeter, nLevelValue, flFillRatio) {
            const elProgress = _m_infoPanel.FindChildInLayoutFile(idMeter);
            const nGrowth = (nPetUpgradeLevel < nLevelValue) ? 0
                : (nPetUpgradeLevel < nLevelValue + 1) ? flFillRatio
                    : 1;
            UpdateRadialProgressBar(elProgress, nGrowth, nPetUpgradeLevel === nLevelValue, nPetUpgradeLevel > nLevelValue);
        }
        // egg
        _UpdateProgressMeter('id-pet-milestone-egg', 0, InventoryAPI.GetPetGrowthPercent(_m_petId));
        // life stages. Whether the row is shown at all while the pet waits on feed is decided by
        // _ShowFoodHint through the needs-food class, so the meters always reflect real growth here.
        const flLifeStageMeter = 1 - InventoryAPI.GetPetLifetimeRemaining(_m_petId);
        _UpdateProgressMeter('id-pet-milestone-chick', 1, flLifeStageMeter);
        _UpdateProgressMeter('id-pet-milestone-pullet', 2, flLifeStageMeter);
        _UpdateProgressMeter('id-pet-milestone-hen', 3, flLifeStageMeter);
    }
    function UpdateRadialProgressBar(elProgress, nGrowth, IsActive, isComplete) {
        const elRadial = elProgress.FindChild('id-pet-progress-timer');
        if (!nGrowth && nGrowth !== 0) {
            elRadial.style.clip = 'radial(50% 50%, 0deg, 0deg, deg)';
            return;
        }
        const nDegrees = isComplete ? 360 : Math.floor(nGrowth * 360);
        elRadial.style.clip = 'radial(50% 50%, 0deg, ' + nDegrees + 'deg)';
        elProgress.SetHasClass('active', IsActive);
        elProgress.SetHasClass('complete', isComplete);
    }
    function UpdateProgressBar(elProgress, nFeedEarned, IsActive, isComplete) {
        if ((!nFeedEarned && nFeedEarned !== 0))
            return;
        const aPips = elProgress.FindChild('id-pet-progress-bar')?.Children();
        aPips?.forEach((pip, idx) => {
            pip.SetHasClass('filled', ((nFeedEarned >= idx + 1 && IsActive) || isComplete));
        });
        elProgress.SetHasClass('active', IsActive);
        elProgress.SetHasClass('complete', isComplete);
    }
    function _OpenPetBook() {
        UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_pet_book.xml');
    }
    function _OpenPhotoBooth(nPetUpgradeLevel) {
        const OnClosePetEventNotification = UiToolkitAPI.RegisterJSCallback(() => { $.Msg('Close Photo Booth Callback'); });
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_pet_photobooth.xml', 'action-type=expire'
            + '&' + 'title=' + ''
            + '&' + 'msg=' + ''
            + '&' + 'pet_id=' + _m_petId
            + '&' + 'photo_booth=' + 'true'
            + '&' + 'upgrade_level=' + nPetUpgradeLevel
            + '&' + 'callback=' + OnClosePetEventNotification);
    }
    // export function DeleteVanityInfoPanel ( elParent: Panel_t, index: number ): void
    // {
    // 	const idPrefix = "id-player-vanity-info-" + index;
    // 	const elPanel = elParent.FindChildInLayoutFile( idPrefix );
    // 	if ( elPanel && elPanel.IsValid() )
    // 	{
    // 		elPanel.DeleteAsync( 0 );
    // 	}
    // }
    // function _RoundToPixel ( context: Panel_t, value: number, axis: "x" | "y" ): number
    // {
    // 	const scale = axis === "x" ? context.actualuiscale_x : context.actualuiscale_y;
    // 	return Math.round( value * scale ) / scale;
    // }
    // export function SetVanityInfoPanelPos ( elParent: Panel_t, index: number, oPos: Vector2D, idPrefix:string, OnlyXOrY?: "x" | "y" ): void
    // {
    // 	const elPanel = elParent.FindChildInLayoutFile( idPrefix );
    // 	if ( elPanel && elPanel.IsValid() )
    // 	{
    // 		switch ( OnlyXOrY )
    // 		{
    // 			case 'x':
    // 				elPanel.style.transform = 'translateX( ' + oPos.x + 'px );';
    // 				break;
    // 			case 'y':
    // 				elPanel.style.transform = 'translateY( ' + oPos.x + 'px );';
    // 				break;
    // 			default:
    // 				elPanel.style.transform = 'translate3d( ' + _RoundToPixel( elParent, oPos.x, "x" ) + 'px, ' + _RoundToPixel( elParent, oPos.y, "y" ) + 'px, 0px );';
    // 				break;
    // 		}
    // 	}
    // }
    // // individual elements
    // function _SetName ( newPanel: Panel_t, xuid: string ): void
    // {
    // 	const name = MockAdapter.IsFakePlayer( xuid )
    // 		? MockAdapter.GetPlayerName( xuid )
    // 		: FriendsListAPI.GetFriendName( xuid );
    // 	newPanel.SetDialogVariable( 'player_name', name );
    // }
    // function _SetAvatar ( newPanel: Panel_t, xuid: string ): void
    // {
    // 	const elParent = newPanel.FindChildInLayoutFile( 'vanity-avatar-container' );
    // 	let elAvatar = elParent.FindChildInLayoutFile( 'JsPlayerVanityAvatar-' + xuid );
    // 	if ( !elAvatar )
    // 	{
    // 		elAvatar = $.CreatePanel( "Panel", elParent, 'JsPlayerVanityAvatar-' + xuid );
    // 		elAvatar.SetAttributeString( 'xuid', xuid );
    // 		elAvatar.BLoadLayout( 'file://{resources}/layout/avatar.xml', false, false );
    // 		elAvatar.BLoadLayoutSnippet( "AvatarPlayerCard" );
    // 		elAvatar.AddClass( 'avatar--vanity' );
    // 	}
    // 	Avatar.Init( elAvatar, xuid, 'partymember' );
    // 	if ( MockAdapter.IsFakePlayer( xuid ) )
    // 	{
    // 		const elAvatarImage = elAvatar.FindChildInLayoutFile( "JsAvatarImage" ) as CSGOAvatarImage_t;
    // 		elAvatarImage.PopulateFromPlayerSlot( MockAdapter.GetPlayerSlot( xuid ) );
    // 	}
    // }
    // function _SetRank ( newPanel: Panel_t, xuid: string, isLocalPlayer: boolean ): void
    // {
    // 	const elRankIcon = newPanel.FindChildInLayoutFile( 'vanity-xp-icon' ) as Image_t;
    // 	const elXpBarInner = newPanel.FindChildInLayoutFile( 'vanity-xp-bar-inner' );
    // 	if ( !isLocalPlayer || !MyPersonaAPI.IsInventoryValid() )
    // 	{
    // 		newPanel.FindChildInLayoutFile( 'vanity-xp-container' ).visible = false;
    // 		return;
    // 	}
    // 	newPanel.FindChildInLayoutFile( 'vanity-xp-container' ).visible = true;
    // 	const currentLvl = FriendsListAPI.GetFriendLevel( xuid );
    // 	if ( !MyPersonaAPI.IsInventoryValid() ||
    // 		!currentLvl ||
    // 		( !_HasXpProgressToFreeze() && !_IsPlayerPrime( xuid ) )
    // 	)
    // 	{
    // 		newPanel.AddClass( 'no-valid-xp' );
    // 		return;
    // 	}
    // 	const bHasRankToFreezeButNoPrestige = ( !_IsPlayerPrime( xuid ) && _HasXpProgressToFreeze() ) ? true : false;
    // 	const currentPoints = FriendsListAPI.GetFriendXp( xuid );
    // 	const pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
    // 	// Set Xp bar and show.
    // 	if ( bHasRankToFreezeButNoPrestige )
    // 	{
    // 		elXpBarInner.GetParent().visible = false;
    // 	}
    // 	else
    // 	{
    // 		const percentComplete = ( currentPoints / pointsPerLevel ) * 100;
    // 		elXpBarInner.style.width = percentComplete + '%';
    // 		elXpBarInner.GetParent().visible = true;
    // 		_ShowPrestigeUpgrade( newPanel, xuid, isLocalPlayer );
    // 	}
    // 	// Set Xp rank image and show.
    // 	elRankIcon.SetImage( 'file://{images}/icons/xp/level' + currentLvl + '.png' );
    // 	newPanel.RemoveClass( 'no-valid-xp' );
    // }
    // function _SetSkillGroup ( newPanel: Panel_t, xuid: string, isLocalPlayer: boolean ): void
    // {
    // 	let rating_type;
    // 	let score;
    // 	let wins;
    // 	if ( isLocalPlayer && !PartyListAPI.IsPartySessionActive() )
    // 	{
    // 		rating_type = 'Premier' as SkillRatingType_t;
    // 		score = MyPersonaAPI.GetPipRankCount( rating_type );
    // 		wins = MyPersonaAPI.GetPipRankWins( rating_type );
    // 	}
    // 	else
    // 	{
    // 		rating_type = PartyListAPI.GetFriendCompetitiveRankType( xuid ) as SkillRatingType_t;
    // 		score = PartyListAPI.GetFriendCompetitiveRank( xuid );
    // 		wins = PartyListAPI.GetFriendCompetitiveWins( xuid );			
    // 	}
    // 	let options =
    // 	{
    // 		root_panel: newPanel,
    // 	//	xuid: xuid,
    // 	//	api: 'partylist' as SkillRatingSourceAPI_t,
    // 		do_fx: true,
    // 		full_details: false,
    // 		rating_type: rating_type,
    // 		leaderboard_details: { score: score, matchesWon: wins },
    // 		local_player: xuid === MyPersonaAPI.GetXuid()
    // 	};
    // 	RatingEmblem.SetXuid( options );
    // 	newPanel.SetDialogVariable( 'rating-text', RatingEmblem.GetRatingDesc( newPanel ) );
    // }
    // function _SetHonorIcon ( elPanel: Panel_t, xuid: string ): void
    // {
    // 	// honor icon
    // 	const honorIconOptions =
    // 	{
    // 		honor_icon_frame_panel: elPanel.FindChildTraverse( 'jsHonorIcon' ),
    // 		debug_xuid: xuid,
    // 		do_fx: true,
    // 		xptrail_value: PartyListAPI.GetFriendXpTrailLevel( xuid ),
    // 		prime_value: PartyListAPI.GetFriendPrimeEligible( xuid )
    // 	} as HonorIconOptions_t;
    // 	HonorIcon.SetOptions( honorIconOptions );
    // }
    // function _ShowPrestigeUpgrade(elPanel:Panel_t, xuid:string, isLocalPlayer:boolean )
    // {
    // 	let bPrestigeAvailable = isLocalPlayer && ( FriendsListAPI.GetFriendLevel( xuid ) >= InventoryAPI.GetMaxLevel() );
    // 	elPanel.FindChildInLayoutFile( 'vanity-xp-prestige' ).SetHasClass( 'hidden', !bPrestigeAvailable );
    // 	if ( bPrestigeAvailable )
    // 	{
    // 		elPanel.FindChildInLayoutFile( 'vanity-xp-prestige' ).SetPanelEvent(
    // 			'onactivate',
    // 			_OnActivateGetPrestigeButtonClickable
    // 		);
    // 	}
    // }
    // function _OnActivateGetPrestigeButtonClickable()
    // {
    // 	UiToolkitAPI.ShowCustomLayoutPopupParameters(
    // 		'',
    // 		'file://{resources}/layout/popups/popup_inventory_inspect.xml',
    // 		'itemid=' + '0' + 
    // 		'&' + 'asyncworkitemwarning=no' +
    // 		'&' + 'asyncworktype=prestigecheck'
    // 	);
    // }
    // export function UpdateVoiceIcon ( elAvatar: Panel_t, xuid: string ): void
    // {
    // 	Avatar.UpdateTalkingState( elAvatar, xuid );
    // }
    // function _HasXpProgressToFreeze (): boolean
    // {
    // 	return MyPersonaAPI.HasPrestige() || ( MyPersonaAPI.GetCurrentLevel() > 2 );
    // }
    // function _IsPlayerPrime ( xuid: string ): boolean
    // {
    // 	return FriendsListAPI.GetFriendPrimeEligible( xuid );
    // }
    // function _SetLobbyLeader ( elPanel: Panel_t, xuid: string )
    // {
    // 	elPanel.SetHasClass( 'is-not-leader', LobbyAPI.GetHostSteamID() !== xuid );
    // }
    // function _ShowSettingsBtn( elPanel: Panel_t, xuid :string )
    // {
    // 	elPanel.SetHasClass( "show-controls", MyPersonaAPI.GetXuid() === xuid );
    // }
    // function _AddOpenPlayerCardAction ( elPanel: Panel_t, xuid: string ): void
    // {
    // 	elPanel.SetPanelEvent( "onactivate", () =>
    // 	{
    // 		if ( xuid !== "0" )
    // 		{
    // 			const contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(
    // 				'',
    // 				'',
    // 				'file://{resources}/layout/context_menus/context_menu_playercard.xml',
    // 				'xuid=' + xuid,
    // 				() => {}
    // 			);
    // 			contextMenuPanel.AddClass( "ContextMenu_NoArrow" );
    // 		}
    // 	} );
    // }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        if ($.DbgIsReloadingScript()) {
            $.Msg("Vanity Pet reloaded\n ");
        }
    }
})(VanityPetInfo || (VanityPetInfo = {}));
