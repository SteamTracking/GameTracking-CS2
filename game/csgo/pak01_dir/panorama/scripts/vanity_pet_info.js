"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="avatar.ts" />
/// <reference path="common/sessionutil.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="rating_emblem.ts" />
var VanityPetInfo;
(function (VanityPetInfo) {
    let _m_zoomedPetId = null;
    VanityPetInfo._m_idPrefix = "id-mainmenu-pet-info";
    let _m_infoPanel;
    let _m_textEntry;
    let _m_petId;
    let _m_scheduleEggTimerHandle;
    let _m_focusEventHandler;
    let _m_oldName = '';
    _m_scheduleEggTimerHandle = null;
    function CreateOrUpdatePetInfoPanel(elParent, petItemId) {
        let newPanel = elParent.FindChildInLayoutFile(VanityPetInfo._m_idPrefix);
        if (!petItemId || Number(petItemId) === 0) {
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
                return;
            }
            _UpdateProgressBars(nPetUpgradeLevel);
            _ShowFoodHint(elPanel, InventoryAPI.GetPetItemID());
            elPanel.SetHasClass('hover-show', true);
        });
        elPanel.SetPanelEvent('onmouseout', () => {
            elPanel.SetHasClass('hover-show', elPanel.BHasClass('text-entry-active'));
        });
    }
    function _SetButtonEvents(elPanel, petId, nPetUpgradeLevel, bCanRenameThisLifeStage) {
        elPanel.FindChildInLayoutFile('id-inspect-pet').SetPanelEvent('onactivate', () => {
            $.DispatchEvent("InventoryItemPreview", petId, '');
        });
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
        elNameTag.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-name-pet', InventoryAPI.HasCustomName(petId) ? '#pet_tooltip_rename' : '#pet_tooltip_name');
        });
        let elPhotoBooth = elPanel.FindChildInLayoutFile('id-photo-booth');
        elPhotoBooth.SetPanelEvent('onactivate', () => { _OpenPhotoBooth(nPetUpgradeLevel); });
        elPhotoBooth.SetHasClass('hide', nPetUpgradeLevel < 1);
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
        const fauxNameTag = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1200, 0);
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
        elPanel.SetHasClass('is-zoomed', _m_zoomedPetId === petItemId);
    }
    VanityPetInfo.SetZoomBtns = SetZoomBtns;
    function ResetPetZoom(elMapPanel) {
        if (_m_zoomedPetId === null) {
            return;
        }
        elMapPanel.TransitionToCamera('cam_default', 0);
        elMapPanel.SetParallaxOffset(elMapPanel.Data().parallax_unzoomed);
        _m_zoomedPetId = null;
        if (_m_infoPanel && _m_infoPanel.IsValid()) {
            _m_infoPanel.SetHasClass('is-zoomed', false);
        }
    }
    VanityPetInfo.ResetPetZoom = ResetPetZoom;
    function CancelEggTimer() {
        if (_m_scheduleEggTimerHandle) {
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
        _UpdateProgressMeter('id-pet-milestone-egg', 0, InventoryAPI.GetPetGrowthPercent(_m_petId));
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
        const OnClosePetEventNotification = UiToolkitAPI.RegisterJSCallback(() => { });
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_pet_photobooth.xml', 'action-type=expire'
            + '&' + 'title=' + ''
            + '&' + 'msg=' + ''
            + '&' + 'pet_id=' + _m_petId
            + '&' + 'photo_booth=' + 'true'
            + '&' + 'upgrade_level=' + nPetUpgradeLevel
            + '&' + 'callback=' + OnClosePetEventNotification);
    }
    {
        if ($.DbgIsReloadingScript()) {
        }
    }
})(VanityPetInfo || (VanityPetInfo = {}));
