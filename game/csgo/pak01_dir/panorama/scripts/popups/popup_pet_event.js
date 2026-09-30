"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="../common/characteranims.ts" />
var PopupPetEvent;
(function (PopupPetEvent) {
    const _m_cp = $.GetContextPanel();
    const _m_elPetFrame = $.GetContextPanel().FindChildInLayoutFile('id-pet-event-frame');
    const _m_elItemModelImagePanel = _m_cp.FindChildInLayoutFile('id-pet-model');
    let _m_elCloseBtn = null;
    let _m_bWaitingOnContinue = false;
    let _m_event;
    let _m_elPreviewPanel;
    const SEQ_FLY_AWAY = 'chick_retirement01';
    const SEQ_GRUMPY_RETIRE = 'chick_retirement02';
    const NEGLECT_FADE_SEC = 5;
    const NEGLECT_LINE_COUNT = 3;
    const NEGLECT_EGG_LINE_COUNT = 3;
    const PLAY_EVENT_DELAY_SEC = .1;
    const DISMISS_DELAY_SEC = 4;
    function _ParsePetEvent() {
        const popupPetParams = _m_cp.GetAttributeString('pet_id', '').split(',');
        const petItemId = popupPetParams.length > 0 ? popupPetParams[0] : '';
        const strSecond = popupPetParams.length > 1 ? popupPetParams[1] : '';
        const bExpired = (strSecond === 'maxage' || strSecond === 'nofood');
        const upgradeLevel = Number(InventoryAPI.GetItemAttributeValue(petItemId, '{uint32}upgrade level'));
        return {
            petItemId: petItemId,
            previousPetItemId: (bExpired || !strSecond) ? petItemId : strSecond,
            upgradeLevel: upgradeLevel,
            expiryReason: bExpired ? strSecond : '',
            bMaxAge: strSecond === 'maxage',
            bEggNoFood: upgradeLevel === 0 && strSecond === 'nofood',
        };
    }
    function Init() {
        _m_event = _ParsePetEvent();
        GameInterfaceAPI.SetChickenAudioExempt('pet_event', true);
        _m_cp.GetParent().GetParent().SetHasClass('pet-event-blur', true);
        _SetupCloseBtn('id-pet-event-close-btn');
        UiToolkitAPI.PlaySoundEvent('Chicken.Popup.Message');
        _m_elPetFrame.AddClass('show');
        _m_elPreviewPanel = _CreatePetPreviewPanel();
        _m_bWaitingOnContinue = true;
        if (_m_event.expiryReason) {
            _SetExpiryText();
        }
        else {
            _SetUpgradeText();
        }
        _SetupBookBtn();
        _SetupContinueBtn();
    }
    PopupPetEvent.Init = Init;
    function _SetExpiryText() {
        const strNeglect = _m_event.bEggNoFood ? 'nofood_egg' : 'nofood';
        const nNeglectLines = _m_event.bEggNoFood ? NEGLECT_EGG_LINE_COUNT : NEGLECT_LINE_COUNT;
        const strTitle = _m_event.bMaxAge ? _m_cp.GetAttributeString('title', '') : '#pet_expired_notification_title_' + strNeglect;
        const strBody = _m_event.bMaxAge ? (_EventPetBookId() !== '' ? '#pet_expired_notification_msg_maxage_book' : '#pet_expired_notification_msg_maxage')
            : '#pet_expired_notification_msg_' + strNeglect + '_' + Math.floor(Math.random() * nNeglectLines);
        _m_cp.SetDialogVariable('title', $.Localize(strTitle, _m_cp));
        _m_cp.SetDialogVariable('body', $.Localize(strBody, _m_cp));
    }
    function _PetBookId(strPetId) {
        if (!strPetId) {
            return '';
        }
        return GameInterfaceAPI.FindFiles('pet/' + strPetId + '/book/pet.bin', 'USRLOCAL').length > 0 ? strPetId : '';
    }
    function _EventPetBookId() {
        return _PetBookId(_m_cp.GetAttributeString('ack_exp_pet_id', '')) || _PetBookId(InventoryAPI.GetPetItemID());
    }
    function _SetupBookBtn() {
        _m_cp.FindChildInLayoutFile('id-pet-event-book-btn').SetPanelEvent('onactivate', () => {
            UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_pet_book.xml');
            Close();
        });
    }
    function _SetupContinueBtn() {
        const elContinueBtn = _m_cp.FindChildInLayoutFile('id-pet-event-continue-btn');
        elContinueBtn.SetHasClass('hide-btn', false);
        _m_elCloseBtn.SetHasClass('hide-btn', true);
        _SpawnPetEventItems();
        elContinueBtn.SetPanelEvent('onactivate', () => {
            elContinueBtn.enabled = false;
            elContinueBtn.SetHasClass('hide-btn', true);
            _m_cp.FindChildInLayoutFile('id-pet-event-text').SetHasClass('hide-text', true);
            $.Schedule(PLAY_EVENT_DELAY_SEC, () => { _PlayPetEvent(); });
            _RevealPet();
            $.Schedule(PLAY_EVENT_DELAY_SEC + DISMISS_DELAY_SEC, () => {
                _m_bWaitingOnContinue = false;
                if (_m_event.bMaxAge && _EventPetBookId()) {
                    _m_cp.FindChildInLayoutFile('id-pet-event-book-btn').SetHasClass('hide-btn', false);
                }
                _m_elCloseBtn.SetHasClass('hide-btn', false);
            });
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.resetSettings', 'MOUSE');
        });
    }
    function _RevealPet() {
        _m_cp.FindChildInLayoutFile('id-pet-white').AddClass('hide-white');
    }
    function _SetUpgradeText() {
        _m_cp.SetDialogVariable('title', $.Localize(_m_cp.GetAttributeString('title', ''), _m_cp));
        _m_cp.SetDialogVariable('body', $.Localize(_m_cp.GetAttributeString('msg', '') + '_' + _m_event.upgradeLevel, _m_cp));
    }
    function _SetupCloseBtn(btnId) {
        const callbackHandle = _m_cp.GetAttributeInt('callback', -1);
        const closeButton = _m_cp.FindChildTraverse(btnId);
        _m_elCloseBtn = closeButton;
        closeButton.SetPanelEvent('onactivate', () => {
            if (callbackHandle >= 0) {
                UiToolkitAPI.InvokeJSCallback(callbackHandle);
            }
            GameInterfaceAPI.SetChickenAudioExempt('pet_event', false);
            _m_cp.GetParent().GetParent().SetHasClass('pet-event-blur', false);
            _m_elPetFrame.RemoveClass('show');
            _m_cp.FindChildInLayoutFile('id-pet-white').RemoveClass('hide-white');
            $.DispatchEvent('UIPopupButtonClicked', '');
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.mainmenu_press_quit', 'MOUSE');
        });
    }
    function Close() {
        if (_m_bWaitingOnContinue) {
            return;
        }
        if (_m_elCloseBtn && _m_elCloseBtn.IsValid()) {
            $.DispatchEvent('Activated', _m_elCloseBtn, 'keyboard');
        }
    }
    PopupPetEvent.Close = Close;
    function _CreatePetPreviewPanel() {
        let mapName = GameInterfaceAPI.GetSettingString('ui_mainmenu_bkgnd_movie') + '_vanity';
        let elItemModelPreviewPanel = $.CreatePanel('MapPreviewPanel', _m_elItemModelImagePanel, 'PetUpgradePanel', {
            'require-composition-layer': 'true',
            'transparent-background': 'false',
            class: 'inspect-model-image-panel',
            camera: 'cam_gloves',
            map: mapName,
            panzoom_enabled: true,
            load_map_char_entities_as_info_targets: 'true',
            load_map_item_entities_as_info_targets: 'true',
        });
        _ResetMapEntities(mapName, elItemModelPreviewPanel);
        return elItemModelPreviewPanel;
    }
    function _SpawnPetEventItems() {
        if (_m_event.expiryReason) {
            if (_m_event.bEggNoFood) {
                _m_elPreviewPanel.SpawnModel('nest', 'models/nest/nest.vmdl', '', 'item11');
                return;
            }
            _m_elPreviewPanel.SpawnItem('adult', _m_event.petItemId, '', 'item13');
            return;
        }
        if (_m_event.upgradeLevel === 1) {
            _m_elPreviewPanel.SpawnModel('nest', 'models/nest/nest.vmdl', '', 'item9');
            _m_elPreviewPanel.SpawnModelWithItemID('egg', 'models/chicken/chicknegg.vmdl', _m_event.previousPetItemId, '', 'item9');
            _m_elPreviewPanel.SpawnItem('chick', _m_event.petItemId, '', 'item9');
        }
        else if (_m_event.upgradeLevel === 2) {
            _m_elPreviewPanel.SpawnItem('chick', _m_event.previousPetItemId, '', 'item11');
            _m_elPreviewPanel.SpawnItem('teen', _m_event.petItemId, '', 'item12');
        }
        else if (_m_event.upgradeLevel === 3) {
            _m_elPreviewPanel.SpawnItem('teen', _m_event.previousPetItemId, '', 'item12');
            _m_elPreviewPanel.SpawnItem('adult', _m_event.petItemId, '', 'item13');
        }
    }
    function _PlayPetEvent() {
        let camera = '';
        if (_m_event.expiryReason) {
            camera = _m_event.bMaxAge ? 'expiration' : _m_event.bEggNoFood ? 'pet_growth_teen' : 'retire';
            _m_elPreviewPanel.TransitionToCamera('cam_' + camera + '_intro', 0);
            _m_elPreviewPanel.FireEntityInput('adult', 'Alpha', '255');
            if (_m_event.bMaxAge) {
                $.Schedule(3, () => {
                    _m_elPreviewPanel.TransitionToCamera('cam_' + camera, 2);
                });
                _m_elPreviewPanel.PlaySequenceOnItem('adult', SEQ_FLY_AWAY);
            }
            else {
                $.Schedule(.25, () => {
                    _m_elPreviewPanel.TransitionToCamera('cam_' + camera, _m_event.bEggNoFood ? 15 : 5);
                });
                $.Schedule(_m_event.bEggNoFood ? 2 : NEGLECT_FADE_SEC, () => { _m_cp.FindChildInLayoutFile('id-pet-model-container').AddClass('fade-black'); });
                if (_m_event.bEggNoFood) {
                    return;
                }
                _m_elPreviewPanel.PlaySequenceOnItem('adult', SEQ_GRUMPY_RETIRE);
            }
            return;
        }
        if (_m_event.upgradeLevel === 1) {
            camera = 'egg_hatch';
            _m_elPreviewPanel.TransitionToCamera('cam_' + camera + '_intro', 0);
            _m_elPreviewPanel.TransitionToCamera('cam_' + camera, 4);
            let hatchNum = 1 + Math.floor(Math.random() * 2);
            _m_elPreviewPanel.PlaySequenceOnItem('egg', 'chicknegg_hatch0' + hatchNum);
            _m_elPreviewPanel.PlaySequenceOnItem('chick', 'chicknegg_hatch0' + hatchNum);
        }
        else if (_m_event.upgradeLevel === 2) {
            camera = 'pet_growth_teen';
            _m_elPreviewPanel.TransitionToCamera('cam_' + camera + '_intro', 0);
            _m_elPreviewPanel.PlaySequenceOnItem('chick', 'chick_chicken_reveal');
            _m_elPreviewPanel.FireEntityInput('teen', 'Alpha', '0');
            _m_elPreviewPanel.PlaySequenceOnItem('teen', 'chick_chicken_reveal');
            $.Schedule(4, () => {
                _m_elPreviewPanel.TransitionToCamera('cam_' + camera, 5);
                _m_elPreviewPanel.FireEntityInput('particle_growth', 'Start');
                _m_elPreviewPanel.FireEntityInput('chick', 'Alpha', '0');
                _m_elPreviewPanel.FireEntityInput('teen', 'Alpha', '255');
            });
        }
        else if (_m_event.upgradeLevel === 3) {
            camera = 'pet_growth_adult';
            _m_elPreviewPanel.TransitionToCamera('cam_' + camera + '_intro', 0);
            _m_elPreviewPanel.TransitionToCamera('cam_' + camera, 3);
            _m_elPreviewPanel.PlaySequenceOnItem('teen', 'chick_chicken_reveal02');
            _m_elPreviewPanel.FireEntityInput('adult', 'Alpha', '0');
            _m_elPreviewPanel.PlaySequenceOnItem('adult', 'chick_chicken_reveal02');
            $.Schedule(3.4, () => {
                _m_elPreviewPanel.FireEntityInput('particle_growth', 'Start');
                _m_elPreviewPanel.FireEntityInput('teen', 'Alpha', '0');
                _m_elPreviewPanel.FireEntityInput('adult', 'Alpha', '255');
            });
        }
    }
    function _ResetMapEntities(mapName, elItemModelPreviewPanel) {
        if (mapName === 'de_nuke_vanity') {
            InspectModelImage.SetSpotlightBrightness(elItemModelPreviewPanel);
        }
        else {
            InspectModelImage.SetSunBrightness(elItemModelPreviewPanel);
        }
        InspectModelImage.DisableItemLighting(elItemModelPreviewPanel);
    }
})(PopupPetEvent || (PopupPetEvent = {}));
