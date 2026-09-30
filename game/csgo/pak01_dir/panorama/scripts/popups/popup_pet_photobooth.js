"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="../common/characteranims.ts" />
/// <reference path="../context_menus/context_menu_color_picker.ts" />
/// <reference path="../popups/pet_photo_tag.ts" />
/// <reference path="../popups/pet_photo_library.ts" />
var PopupPetPhotoBooth;
(function (PopupPetPhotoBooth) {
    const _m_cp = $.GetContextPanel();
    const _m_elPhotoFrame = $.GetContextPanel().FindChildInLayoutFile('id-photo-booth-frame');
    const _m_elItemModelImagePanel = _m_cp.FindChildInLayoutFile('id-pet-model');
    const _m_elCaptured = _m_cp.FindChildInLayoutFile('id-pet-model-container');
    let _m_petId = '';
    let _m_elCloseBtn = null;
    let _m_currentPose = PetPhotoTag.POSES[0];
    let _m_photoBoothUpgradeLevel = 0;
    let _m_petSpawnedForPhotoBooth = false;
    let _m_elSelectedControls;
    let _m_photoFilter;
    let _m_lastSavedPhoto = '';
    let m_aspectRatio = '';
    let _m_currentAttachment = '';
    const STUDIO_STAGE = 'ui/pet_photo_studio';
    let _m_currentStage = STUDIO_STAGE;
    const DEFAULT_WALLPAPER = '1';
    let _m_currentWallpaper = DEFAULT_WALLPAPER;
    let _m_setupValues = {};
    function Init() {
        const popupPetParams = _m_cp.GetAttributeString('pet_id', '').split(',');
        _m_petId = (popupPetParams && (popupPetParams.length > 0)) ? popupPetParams[0] : '';
        _m_setupValues = _ReadSetup(_m_cp.GetAttributeString('booth_setup', ''));
        GameInterfaceAPI.SetChickenAudioSuppressed('pet_photobooth', true);
        _m_cp.GetParent().GetParent().SetHasClass('pet-event-blur', true);
        _SetupCloseBtn('id-pet-photo-close-btn');
        _m_cp.FindChildTraverse('id-pet-photo-book-btn').visible = _m_cp.GetAttributeInt('from_book', 0) === 1;
        _SetUpPhotoBooth(_m_petId);
    }
    PopupPetPhotoBooth.Init = Init;
    function _SetupCloseBtn(btnId) {
        const callbackHandle = _m_cp.GetAttributeInt('callback', -1);
        const closeButton = _m_cp.FindChildTraverse(btnId);
        _m_elCloseBtn = closeButton;
        closeButton.SetPanelEvent('onactivate', () => {
            _CancelPhotoJobs();
            GameInterfaceAPI.SetChickenAudioSuppressed('pet_photobooth', false);
            if (callbackHandle >= 0) {
                UiToolkitAPI.InvokeJSCallback(callbackHandle);
            }
            $.DispatchEvent('UIPopupButtonClicked', '');
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.mainmenu_press_quit', 'MOUSE');
        });
    }
    function OpenBook() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_pet_book.xml', 'spread=' + _m_cp.GetAttributeString('book_spread', '0')
            + '&' + 'booth_setup=' + _SetupString()
            + '&' + 'from_booth=1');
        Close();
    }
    PopupPetPhotoBooth.OpenBook = OpenBook;
    function Close() {
        if (_m_elCloseBtn && _m_elCloseBtn.IsValid()) {
            $.DispatchEvent('Activated', _m_elCloseBtn, 'keyboard');
        }
    }
    PopupPetPhotoBooth.Close = Close;
    function _ResetMapEntities(mapName, elItemModelPreviewPanel) {
        if (mapName === 'de_nuke_vanity') {
            InspectModelImage.SetSpotlightBrightness(elItemModelPreviewPanel);
        }
        else {
            InspectModelImage.SetSunBrightness(elItemModelPreviewPanel);
        }
        InspectModelImage.DisableItemLighting(elItemModelPreviewPanel);
    }
    const aAdjust = [
        { type: 'exposure', kind: 'post-pair', min: -1, max: 1, default: 0, down: 'pet_post_exposure_down', up: 'pet_post_exposure_up' },
        { type: 'saturation', kind: 'post-pair', min: -1, max: 1, default: 0, down: 'pet_post_saturation_down', up: 'pet_post_saturation_up' },
        { type: 'vibrance', kind: 'post-pair', min: -1, max: 1, default: 0, down: 'pet_post_vibrance_down', up: 'pet_post_vibrance_up' },
        { type: 'brightness', kind: 'brightness', min: .8, max: 2, default: 1 },
        { type: 'bloom', kind: 'post-single', min: 0, max: 1, default: 0, entity: 'pet_post_bloom' },
        { type: 'contrast', kind: 'post-pair', min: -1, max: 1, default: 0, down: 'pet_post_contrast_down', up: 'pet_post_contrast_up' },
        { type: 'vignette', kind: 'overlay', min: 0, max: .8, default: .14, panel_id: 'id-pet-photo-overlay' },
        { type: 'grain', kind: 'overlay', min: 0, max: .7, default: 0, panel_id: 'id-pet-photo-grain' },
        { type: 'grime', kind: 'overlay', min: 0, max: .5, default: 0, panel_id: 'id-pet-photo-grime' },
        { type: 'filter-strength', kind: 'filter', min: 0, max: 1, default: 1 },
    ];
    const aWallpapers = [
        { skin: '0', swatch: '' },
        { skin: '1', swatch: 'blue' },
        { skin: '2', swatch: 'green' },
        { skin: '3', swatch: 'purple' },
        { skin: '4', swatch: 'yellow' },
        { skin: '5', swatch: 'brown' },
        { skin: '6', swatch: 'red' },
        { skin: '7', swatch: 'black' },
        { skin: '8', swatch: 'sky' },
        { skin: '10', swatch: 'abstract' },
    ];
    const NO_HEADWEAR = 'none';
    const SETUP_PAIR_SEPARATOR = ';';
    const SETUP_KEY_VALUE_SEPARATOR = ':';
    const aSetupFields = [
        { key: 'stage', Read: () => _StageNameForMap(_m_currentStage) },
        { key: 'paper', Read: () => _m_currentWallpaper, Apply: _SelectWallpaper },
        { key: 'pose', Read: () => _m_currentPose.name, Apply: _SelectPose },
        { key: 'aspect', Read: () => m_aspectRatio, Apply: _SelectAspect },
        { key: 'filter', Read: () => _m_photoFilter || 'normal', Apply: _SelectFilter },
        { key: 'headwear', Read: () => _HeadwearNameForModel(_m_currentAttachment), Apply: _SelectHeadwear },
        ...aAdjust.map(adjust => ({
            key: adjust.type,
            Read: () => String(_SliderValue(adjust)),
            Apply: (strValue) => _SetSliderValue(adjust, strValue),
        })),
    ];
    function _SetupString() {
        return aSetupFields
            .map(field => field.key + SETUP_KEY_VALUE_SEPARATOR + field.Read())
            .join(SETUP_PAIR_SEPARATOR);
    }
    function _ReadSetup(strSetup) {
        const values = {};
        strSetup.split(SETUP_PAIR_SEPARATOR).forEach(strPair => {
            const nSplit = strPair.indexOf(SETUP_KEY_VALUE_SEPARATOR);
            if (nSplit > 0) {
                values[strPair.substring(0, nSplit)] = strPair.substring(nSplit + 1);
            }
        });
        return values;
    }
    function _ApplySetup() {
        aSetupFields.forEach(field => {
            const strValue = _m_setupValues[field.key];
            if (field.Apply && strValue !== undefined) {
                field.Apply(strValue);
            }
        });
    }
    function _SetupStageMap() {
        const row = PetPhotoTag.STAGES.find(entry => entry.name === _m_setupValues['stage']);
        return row && _BStageUnlocked(row) ? row.map : STUDIO_STAGE;
    }
    function _WallpaperBtnId(strSkin) {
        return 'id-photo-backdrop-' + strSkin;
    }
    function _SelectWallpaper(strSkin) {
        if (!aWallpapers.some(paper => paper.skin === strSkin)) {
            return;
        }
        _m_cp.FindChildTraverse(_WallpaperBtnId(strSkin)).checked = true;
        UpdateWallpaper(strSkin);
    }
    function _StageNameForMap(strMap) {
        const row = PetPhotoTag.STAGES.find(entry => entry.map === strMap);
        return row ? row.name : PetPhotoTag.STAGES[0].name;
    }
    function _SelectPose(strName) {
        const pose = PetPhotoTag.POSES.find(row => row.name === strName);
        if (!pose) {
            return;
        }
        _m_cp.FindChildTraverse(_PoseBtnId(pose.name)).checked = true;
        UpdatePhotoPoseSettings(pose);
    }
    function _SelectAspect(strName) {
        if (!PetPhotoTag.ASPECTS.some(row => row.name === strName)) {
            return;
        }
        _m_cp.FindChildTraverse(_AspectBtnId(strName)).checked = true;
        UpdateAspectRatioSettings(strName);
    }
    function _SelectFilter(strName) {
        if (!PetPhotoTag.FILTERS.some(row => row.name === strName)) {
            return;
        }
        _m_cp.FindChildTraverse(_FilterBtnId(strName)).checked = true;
        OnFilterEffect(strName);
    }
    function _SelectHeadwear(strName) {
        const strModel = _HeadwearModelForName(strName);
        if (strModel === undefined) {
            return;
        }
        _m_cp.FindChildTraverse(_HeadwearBtnId(strName)).checked = true;
        AttachModel(strModel);
    }
    function _HeadwearModelForName(strName) {
        if (strName === NO_HEADWEAR) {
            return '';
        }
        return PetPhotoTag.HEADWEAR.find(entry => entry.name === strName)?.model;
    }
    function _HeadwearNameForModel(strModel) {
        const row = PetPhotoTag.HEADWEAR.find(entry => entry.model === strModel);
        return row ? row.name : NO_HEADWEAR;
    }
    function _SliderValue(adjust) {
        const elSlider = _GetSlider(adjust.type);
        return elSlider ? elSlider.value : adjust.default;
    }
    function _SetSliderValue(adjust, strValue) {
        const elSlider = _GetSlider(adjust.type);
        const value = Number(strValue);
        if (!elSlider || !isFinite(value)) {
            return;
        }
        elSlider.value = Math.max(adjust.min, Math.min(value, adjust.max));
        _ApplyAdjust(adjust, elSlider.value);
    }
    function _SetUpPhotoBooth(petItemId) {
        _m_photoBoothUpgradeLevel = Number(_m_cp.GetAttributeString('upgrade_level', ''));
        if (_m_photoBoothUpgradeLevel > 0) {
            _MakeSettingsButtons();
            _MakeActivityButtons();
            _MakeHeadwearButtons();
            _m_cp.FindChildInLayoutFile('id-pet-sticker-search')
                .SetPanelEvent('ontextentrychange', UpdateStickerList);
            $.RegisterEventHandler('CSGOInventoryItemLoaded', _m_cp.FindChildInLayoutFile('id-pet-sticker-item-list'), _RefreshStickerTile);
            _m_cp.FindChildTraverse('id-photo-team-ct').checked = true;
            _m_currentStage = _SetupStageMap();
            _MakePoseButtons();
            const defaultPose = PetPhotoTag.POSES[0];
            _m_cp.FindChildTraverse(_PoseBtnId(defaultPose.name)).checked = true;
            _ApplyAgeGates();
            UpdatePhotoPoseSettings(defaultPose);
            _MakeAspectButtons();
            _m_cp.FindChildTraverse(_AspectBtnId('1x1')).checked = true;
            UpdateAspectRatioSettings('1x1');
            _MakeAdjustSliders();
            SliderDefaults();
            PhotoGridSliderDefaults();
            _MakeFilterButtons();
            $.Schedule(.25, () => {
                if (_m_currentStage !== STUDIO_STAGE) {
                    _SettleStage(_m_currentStage);
                }
                TurnOffAllFilters();
                _m_cp.FindChildTraverse(_FilterBtnId('normal')).checked = true;
                OnFilterEffect('normal');
                _RefreshAdjustments();
                _ApplySetup();
            });
            _MakeMapButtons();
            _MakeWallpaperButtons();
            _m_cp.FindChildTraverse(_WallpaperBtnId(DEFAULT_WALLPAPER)).checked = true;
            _m_cp.FindChildTraverse(_StageBtnId(_StageNameForMap(_m_currentStage))).checked = true;
            SetWallpaperOnStageChange(_m_currentStage === STUDIO_STAGE);
            _m_cp.FindChildTraverse('id-photo-headwear-none').checked = true;
            AttachModel('');
            _SetUpPhotoLibrary();
            LoadPreviousPhotos();
            _StartZoomReadout();
            _RefreshCountdown();
        }
    }
    function _MakeSettingsButtons() {
        const bHasStickers = _StickerCount() > 0;
        let aSettings = [
            {
                setting_id: 'grid',
                class: 'IconButton',
                icon: 'photo_grid',
                make_separator: true,
            },
            {
                setting_id: 'adjust',
                class: 'IconButton',
                icon: 'tune',
            },
            {
                setting_id: 'filters',
                class: 'IconButton',
                icon: 'filters',
            },
            {
                setting_id: 'format',
                class: 'IconButton',
                icon: 'aspect_ratio',
                make_separator: true,
            },
            {
                setting_id: 'poses',
                class: 'IconButton',
                icon: 'cheer',
            },
            {
                setting_id: 'team',
                class: 'IconButton',
                icon: 'ct_logo_1c',
            },
            {
                setting_id: 'stage',
                class: 'IconButton',
                icon: 'picture',
            },
            {
                setting_id: 'headwear',
                class: 'IconButton',
                icon: 'helmet',
                make_separator: true,
            },
            {
                setting_id: 'stickers',
                class: 'IconButton',
                icon: 'sticker',
                locked_tip: bHasStickers ? '' : '#pet_photo_booth_no_stickers',
            },
            {
                setting_id: 'light',
                class: 'IconButton',
                icon: 'colorwheel',
                on_activate: () => { ShowLightColorPicker(); },
                studio_only: true,
            },
        ];
        const namePrefix = 'id-pet-setting-btn-';
        const elParent = _m_cp.FindChildInLayoutFile('id-pet-photo-controls');
        aSettings.forEach(btn => {
            let elBtn = btn.on_activate
                ? $.CreatePanel('Button', elParent, namePrefix + btn.setting_id, {
                    class: btn.class
                })
                : $.CreatePanel('RadioButton', elParent, namePrefix + btn.setting_id, {
                    class: btn.class,
                    group: 'control'
                });
            elBtn.BLoadLayoutSnippet('setting-btn');
            elBtn.FindChildInLayoutFile('id-pet-setting-btn-icon').SetImage("file://{images}/icons/ui/" + btn.icon + ".svg");
            const bLocked = !!btn.locked_tip;
            const settingName = $.Localize(bLocked ? btn.locked_tip
                : '#pet_photo_booth_setting_' + btn.setting_id);
            elBtn.enabled = !bLocked;
            elBtn.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip(elBtn.id, settingName); });
            elBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
            const fnActivate = btn.on_activate ? btn.on_activate : () => { ShowSettingsRow(btn.setting_id); };
            elBtn.SetPanelEvent('onactivate', fnActivate);
            if (btn.studio_only) {
                elBtn.SetAttributeString('data-studio-only', 'true');
            }
            if (btn.make_separator) {
                $.CreatePanel('Panel', elParent, namePrefix + btn.setting_id, { class: 'photo-booth-controls__separator' });
            }
        });
    }
    function _StageBtnId(strStage) {
        return 'id-photo-stage-' + strStage;
    }
    function _MakeWallpaperButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-wallpaper-swatches');
        aWallpapers.forEach(paper => {
            if (elParent.FindChildInLayoutFile(_WallpaperBtnId(paper.skin))) {
                return;
            }
            const elBtn = $.CreatePanel('RadioButton', elParent, _WallpaperBtnId(paper.skin), {
                class: 'photo-booth-settings__btn',
                group: 'wallpaper'
            });
            const elIcon = $.CreatePanel('Panel', elBtn, '', { class: 'photo-booth-background-icon' });
            if (paper.swatch !== '') {
                elIcon.AddClass(paper.swatch);
            }
            elBtn.SetPanelEvent('onactivate', () => { UpdateWallpaper(paper.skin); });
        });
    }
    function _MakeMapButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-settings-stage');
        PetPhotoTag.STAGES.forEach(stage => {
            let elBtn = elParent.FindChildInLayoutFile(_StageBtnId(stage.name));
            if (!elBtn) {
                elBtn = $.CreatePanel('RadioButton', elParent, _StageBtnId(stage.name), {
                    class: 'photo-booth-settings__btn',
                    group: 'stage'
                });
                $.CreatePanel('Label', elBtn, '', {
                    text: PetPhotoTag.WordFor('s', String(stage.id)),
                    class: "stratum-regular"
                });
                elBtn.SetPanelEvent('onactivate', () => { ChangeStage(stage.map); });
            }
            const hasRequirement = Boolean(stage.achievement) || Boolean(stage.age_requirement);
            const bComplete = _BStageUnlocked(stage);
            if (hasRequirement) {
                elBtn.enabled = bComplete;
                if (!bComplete) {
                    const strTip = stage.age_requirement ? '#pet_photo_booth_map_locked_age'
                        : _m_photoBoothUpgradeLevel === GROWTH_CHICK ? '#pet_photo_booth_map_locked_chick'
                            : '#pet_photo_booth_map_locked_teen';
                    elBtn.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip(elBtn.id, strTip); });
                    elBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
                }
            }
        });
    }
    function _BStageUnlocked(stage) {
        if (stage.age_requirement) {
            return _m_photoBoothUpgradeLevel >= stage.age_requirement;
        }
        if (stage.achievement) {
            return InventoryAPI.PetHasAchievement(_m_petId, stage.achievement);
        }
        return true;
    }
    function _SettleStage(strMap) {
        const elPanel = _GetPicturePanel();
        if (!elPanel) {
            return;
        }
        elPanel.FireEntityInput('post_vanity', 'Disable');
        _ResetMapEntities(strMap, elPanel);
        _RefreshAdjustments();
        _RefreshLightColors();
    }
    function _GetPhotoBoothMapPanel() {
        let elPanel = _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel');
        if (!elPanel) {
            elPanel = $.CreatePanel('MapPlayerPreviewPanel', _m_elItemModelImagePanel, 'id-pet-picture-panel', {
                "require-composition-layer": "true",
                "transparent-background": "false",
                "pin-fov": "vertical",
                class: 'inspect-model-image-panel',
                camera: 'cam_pet_photo',
                player: "true",
                map: _m_currentStage,
                initial_entity: 'item',
                mouse_rotate: false,
                playername: "vanity_character",
                workshop_preview: false,
                panzoom_enabled: true,
                drag_rotate: true,
            });
            if (elPanel.PanZoomEnabled()) {
                elPanel.hittest = true;
                elPanel.SetAcceptsInput(true);
                elPanel.SetAcceptsFocus(true);
            }
            elPanel.SetDragRotateYawLimit(30);
            _m_cp.FindChildInLayoutFile('id-pet-photo-overlay').SetParent(_m_elItemModelImagePanel);
            return elPanel;
        }
        return elPanel;
    }
    const GROWTH_CHICK = 1;
    const GROWTH_ADOLESCENT = 2;
    const GROWTH_ADULT = 3;
    const aGrowth = [
        { level: GROWTH_CHICK, entityName: 'chick', soloCamera: 'cam_pet_pose_solo_1', soloOrbit: 36, headwearScale: 1.0, soundStage: 'Chick' },
        { level: GROWTH_ADOLESCENT, entityName: 'teen', soloCamera: 'cam_pet_pose_solo_2', soloOrbit: 45, headwearScale: 0.43, soundStage: 'Pullet' },
        { level: GROWTH_ADULT, entityName: 'adult', soloCamera: 'cam_pet_pose_solo_3', soloOrbit: 55, headwearScale: 0.55, soundStage: 'Hen' },
    ];
    function _Growth() {
        const aFound = aGrowth.filter(growth => growth.level === _m_photoBoothUpgradeLevel);
        return aFound.length > 0 ? aFound[0] : aGrowth[aGrowth.length - 1];
    }
    let _m_aActivityBtns = [];
    function _ActivityBtnId(strActivity) { return 'id-photo-activity-' + strActivity; }
    function _MakeActivityButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-pet-photo-activity-bar');
        _m_aActivityBtns = [];
        PetPhotoTag.ACTIVITIES.forEach(activity => {
            const elBtn = $.CreatePanel('Button', elParent, _ActivityBtnId(activity.name), {
                class: 'IconButton'
            });
            const btn = { row: activity, el: elBtn };
            _m_aActivityBtns.push(btn);
            $.CreatePanel('Image', elBtn, '', {
                src: 'file://{images}/icons/ui/' + activity.icon + '.svg',
                textureheight: '32',
                texturewidth: '-1'
            });
            $.CreatePanel('Panel', elBtn, '', { class: 'Spinner photo-booth-activity__spinner' });
            elBtn.SetPanelEvent('onactivate', () => { PlayPetActivity(btn); });
        });
    }
    const ACTIVITY_START = .5;
    const ACTIVITY_MAX = 5.0;
    const ACTIVITY_POLL = .1;
    let _m_running = undefined;
    let _m_activityJob = undefined;
    function _ClearActivity() {
        _m_activityJob = _CancelJob(_m_activityJob);
        _m_running = undefined;
    }
    function _TickActivity() {
        _m_activityJob = undefined;
        const running = _m_running;
        if (!running) {
            return;
        }
        running.flElapsed += ACTIVITY_POLL;
        const bIsRow = _CurrentActivity() === running.row;
        const bFirstSeen = bIsRow && !running.bSeen;
        running.bSeen = running.bSeen || bIsRow;
        if (bFirstSeen) {
            const strSound = running.row.sound?.[_Growth().soundStage];
            if (strSound) {
                UiToolkitAPI.PlaySoundEvent(strSound);
            }
        }
        const bOver = running.bSeen ? !bIsRow : running.flElapsed >= ACTIVITY_START;
        if (bOver || running.flElapsed >= ACTIVITY_MAX) {
            _ClearActivity();
            _RefreshActivityButtons();
            return;
        }
        _m_activityJob = $.Schedule(ACTIVITY_POLL, _TickActivity);
    }
    function _RefreshActivityButtons() {
        const bSolo = _IsSoloPose(_m_currentPose);
        _m_aActivityBtns.forEach(btn => {
            const strAgeTip = _m_ageTips[btn.el.id] || '';
            const bRunning = _m_running !== undefined && _m_running.row === btn.row;
            btn.el.enabled = strAgeTip === '' && bSolo && (_m_running === undefined || bRunning);
            btn.el.SetHasClass('photo-booth-activity--busy', bRunning);
            btn.el.SetHasClass('no-hover', bRunning);
            const strTip = strAgeTip !== '' ? strAgeTip
                : (bSolo ? PetPhotoTag.WordFor('v', String(btn.row.id))
                    : '#pet_photo_booth_setting_restriction_tooltip');
            btn.el.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip(btn.el.id, strTip); });
            btn.el.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        });
    }
    function PlayPetActivity(btn) {
        if (_m_ageTips[btn.el.id] || !_IsSoloPose(_m_currentPose) || _m_running !== undefined) {
            return;
        }
        const elPanel = _GetPhotoBoothMapPanel();
        const activity = btn.row;
        if (activity.variation === undefined) {
            elPanel.SetPetActivityOnItem(_Growth().entityName, activity.activity);
        }
        else {
            elPanel.SetPetActivityAndVariationOnItem(_Growth().entityName, activity.activity, activity.variation);
        }
        _m_running = { row: activity, bSeen: false, flElapsed: 0 };
        _m_activityJob = $.Schedule(ACTIVITY_POLL, _TickActivity);
        _RefreshActivityButtons();
    }
    function _PoseBtnId(strPose) {
        return 'id-photo-pose-' + strPose;
    }
    function _MakePoseButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-settings-poses');
        PetPhotoTag.POSES.forEach(pose => {
            if (elParent.FindChildInLayoutFile(_PoseBtnId(pose.name))) {
                return;
            }
            const elBtn = $.CreatePanel('RadioButton', elParent, _PoseBtnId(pose.name), {
                class: 'photo-booth-settings__btn',
                group: 'poses'
            });
            $.CreatePanel('Label', elBtn, '', {
                text: PetPhotoTag.WordFor('p', pose.name),
                class: 'stratum-regular'
            });
            elBtn.SetPanelEvent('onactivate', () => { UpdatePhotoPoseSettings(pose); });
        });
    }
    const SOLO_SHOT = {
        introCamera: 'cam_pet_pose_solo_intro',
        effectPrefix: 'solo_',
    };
    const POSED_SHOT = {
        introCamera: 'cam_pet_pose_intro',
        effectPrefix: '',
    };
    function _IsSoloPose(pose) { return pose.name === '0'; }
    const aAgeGates = [
        { ids: ['id-photo-pose-8', 'id-photo-pose-9', 'id-photo-pose-10'],
            max: GROWTH_CHICK, tip: '#pet_photo_booth_age_outgrown' },
        { ids: ['id-photo-pose-2', 'id-photo-pose-4', 'id-photo-pose-5', 'id-photo-pose-6'],
            min: GROWTH_ADOLESCENT, tip: '#pet_photo_booth_age_dangerous' },
        { ids: ['id-photo-pose-1', 'id-photo-pose-3', 'id-photo-pose-7'],
            min: GROWTH_ADULT, tip: '#pet_photo_booth_age_maturity' },
        { ids: ['id-photo-effect-sparks', 'id-photo-effect-laser', 'id-photo-effect-beam'],
            min: GROWTH_ADOLESCENT, tip: '#pet_photo_booth_age_scary' },
        { ids: ['id-photo-effect-fire', 'id-photo-effect-lightning', 'id-photo-effect-explosion'],
            min: GROWTH_ADULT, tip: '#pet_photo_booth_age_scary' },
        { ids: [_ActivityBtnId('jump'), _ActivityBtnId('wag'), _ActivityBtnId('moonwalk')],
            min: GROWTH_ADOLESCENT, tip: '#pet_photo_booth_age_tricks' },
        { ids: [_ActivityBtnId('kick'), _ActivityBtnId('fly')],
            min: GROWTH_ADULT, tip: '#pet_photo_booth_age_tricks' },
    ];
    const ACHIEVEMENT_UNLOCKS = {
        'id-photo-effect-fire': 'killed-by-burn',
        'id-photo-effect-lightning': 'killed-by-taser',
        'id-photo-effect-explosion': 'killed-by-planted-c4',
    };
    const ACHIEVEMENT_LOCKED_TIP = '#pet_photo_booth_age_scary_brave';
    let _m_ageTips = {};
    function _ApplyAgeGates() {
        aAgeGates.forEach(gate => {
            const bAllowed = (gate.min === undefined || _m_photoBoothUpgradeLevel >= gate.min) &&
                (gate.max === undefined || _m_photoBoothUpgradeLevel <= gate.max);
            gate.ids.forEach(strId => {
                const elBtn = _m_cp.FindChildTraverse(strId);
                if (!elBtn || !elBtn.IsValid()) {
                    return;
                }
                const strAchievement = ACHIEVEMENT_UNLOCKS[strId];
                if (bAllowed || (strAchievement !== undefined &&
                    InventoryAPI.PetHasAchievement(_m_petId, strAchievement))) {
                    return;
                }
                const strTip = strAchievement !== undefined ? ACHIEVEMENT_LOCKED_TIP : gate.tip;
                _m_ageTips[strId] = strTip;
                elBtn.enabled = false;
                elBtn.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip(strId, strTip); });
                elBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
            });
        });
    }
    function _PoseShot(pose) { return _IsSoloPose(pose) ? SOLO_SHOT : POSED_SHOT; }
    function _PoseOrbitRadius(pose) {
        return pose.orbit === undefined ? _Growth().soloOrbit : pose.orbit;
    }
    function _PoseCamera(pose) {
        return _IsSoloPose(pose) ? _Growth().soloCamera : 'cam_pet_pose_' + pose.name;
    }
    function UpdatePhotoPoseSettings(pose) {
        let elPanel = _GetPhotoBoothMapPanel();
        const shot = _PoseShot(pose);
        elPanel.ResetPanZoom();
        elPanel.ResetDragRotate();
        elPanel.SetDragRotateRadius(_PoseOrbitRadius(pose));
        elPanel.SetZoomLimit(25);
        elPanel.TransitionToCamera(shot.introCamera, 0);
        elPanel.TransitionToCamera(_PoseCamera(pose), 2);
        _SetCharacterAndPetPose(elPanel, pose);
    }
    function _SetCharacterAndPetPose(elPanel, pose) {
        if (_IsSoloPose(pose)) {
            if (!_m_petSpawnedForPhotoBooth) {
                elPanel.SpawnItem(_Growth().entityName, _m_petId, '', 'pet1');
                _m_petSpawnedForPhotoBooth = true;
            }
            elPanel.FireEntityInput(_Growth().entityName, 'Alpha', '255');
            elPanel.FireEntityInput('dynamic_player6', 'Alpha', '0');
        }
        else {
            let selectedBtn = _m_cp.FindChildInLayoutFile('id-photo-settings-team').Children()[0].GetSelectedButton();
            let charId = LoadoutAPI.GetItemID(selectedBtn.GetAttributeString('data-type', 'ct'), 'customplayer');
            const settings = ItemInfo.GetOrUpdateVanityCharacterSettings(charId);
            settings.panel = elPanel;
            settings.petItemId = _m_petId;
            elPanel.SetActiveCharacter(6);
            let model = ItemInfo.GetModelPlayer(charId);
            elPanel.SetPlayerCharacterItemID(charId);
            elPanel.SetPlayerModel(model);
            elPanel.SetPetPlacement(!!_m_petId && Number(_m_petId) != 0 ? 'origin' : 'none');
            elPanel.EquipPlayerWithPet(_m_petId);
            elPanel.PlayChickSnapshotAnimation(Number(pose.name));
            elPanel.FireEntityInput(_Growth().entityName, 'Alpha', '0');
            elPanel.FireEntityInput('dynamic_player6', 'Alpha', '255');
        }
        _m_currentPose = pose;
        _EnableDisablePhotoSettings();
        _ApplyAttachment();
    }
    let _m_captureJob = undefined;
    let _m_verifyJob = undefined;
    let _m_bCapturing = false;
    function _CancelJob(nJob) {
        if (nJob !== undefined) {
            $.CancelScheduled(nJob);
        }
        return undefined;
    }
    const COMPOSITION_LAYER_WARMUP = .1;
    const CAPTURE_VERIFY_SEC = .2;
    const CAPTURE_TRIES = 4;
    const PHOTO_MAX_LONG_EDGE = 1200;
    const PHOTO_JPEG_QUALITY = 95;
    const COUNTDOWN_SEC = 3;
    function _BTimerMode() { return _m_cp.FindChildInLayoutFile('id-pet-take-picture').checked; }
    function _SetShutterEnabled(bEnabled) {
        _m_cp.FindChildInLayoutFile('id-pet-take-picture-instant').enabled = bEnabled;
    }
    function _RefreshCountdown() {
        const elCountdown = _m_cp.FindChildInLayoutFile('id-pet-countdown');
        elCountdown.SetDialogVariableInt('countdown', COUNTDOWN_SEC);
        elCountdown.SetHasClass('show', _BTimerMode());
        elCountdown.SetHasClass('running', false);
    }
    function ToggleTimerMode() {
        _CancelCapture();
        _RefreshCountdown();
    }
    PopupPetPhotoBooth.ToggleTimerMode = ToggleTimerMode;
    function _BeginCapture() {
        _m_bCapturing = true;
        _SetShutterEnabled(false);
        _m_elCaptured.SetCompositionLayerTextureName(m_aspectRatio);
        _SetCapturing(true);
    }
    function _SetCapturing(bCapturing) {
        _m_elCaptured.SetHasClass('pet-capturing', bCapturing);
    }
    function _CancelCapture() {
        _m_captureJob = _CancelJob(_m_captureJob);
        _m_verifyJob = _CancelJob(_m_verifyJob);
        if (_m_bCapturing) {
            _EndCapture();
        }
    }
    function _EndCapture() {
        _m_bCapturing = false;
        _SetShutterEnabled(true);
        _SetCapturing(false);
        _RefreshCountdown();
    }
    function _CancelPhotoJobs() {
        _CancelCapture();
        _m_zoomReadoutJob = _CancelJob(_m_zoomReadoutJob);
        _ClearActivity();
    }
    function _WritePhoto() {
        _m_captureJob = undefined;
        const strFileName = 'pet_' + Date.now() + _PhotoMetaTag() + PetPhotoTag.EXT;
        _m_lastSavedPhoto = strFileName;
        _WriteLayerJPEG(strFileName);
        _m_cp.FindChildInLayoutFile('id-pet-white').TriggerClass('photo-flash');
        UiToolkitAPI.PlaySoundEvent('Chicken.Camera.Shoot');
        _EndCapture();
        _m_verifyJob = $.Schedule(CAPTURE_VERIFY_SEC, () => { _VerifyPhoto(strFileName, 1); });
    }
    function _WriteLayerJPEG(strFileName) {
        const strPath = GameInterfaceAPI.PreparePetPhoto(_m_petId, strFileName);
        if (!strPath) {
            return;
        }
        _m_elCaptured.WriteCompositionLayerJPEG(strPath, 'USRLOCAL', PHOTO_MAX_LONG_EDGE, PHOTO_JPEG_QUALITY);
    }
    function _VerifyPhoto(strFileName, nTry) {
        _m_verifyJob = undefined;
        if (_PhotoOnDisk(strFileName)) {
            PetPhotoLibrary.Insert(strFileName);
            return;
        }
        if (nTry < CAPTURE_TRIES) {
            _WriteLayerJPEG(strFileName);
            _m_verifyJob = $.Schedule(CAPTURE_VERIFY_SEC, () => { _VerifyPhoto(strFileName, nTry + 1); });
            return;
        }
        const nStickers = _m_elCaptured
            .FindChildrenWithClassTraverse('placed-sticker-container').length;
        if (_m_lastSavedPhoto === strFileName) {
            _m_lastSavedPhoto = '';
        }
        _WarnPhotoFailed();
    }
    function _PhotoOnDisk(strFileName) {
        return GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(_m_petId) + '/' + strFileName, 'USRLOCAL').length > 0;
    }
    let _m_bSaveFailureShown = false;
    function _WarnPhotoFailed() {
        if (_m_bSaveFailureShown) {
            return;
        }
        _m_bSaveFailureShown = true;
        UiToolkitAPI.ShowGenericPopupOneOption('#pet_photo_save_failed_title', '#pet_photo_save_failed_desc', '', '#pet_photo_save_failed_leave', () => { Close(); });
    }
    function _Countdown(nRemaining) {
        const elCountdown = _m_cp.FindChildInLayoutFile('id-pet-countdown');
        if (nRemaining === 0) {
            _WritePhoto();
            return;
        }
        elCountdown.SetDialogVariableInt('countdown', nRemaining);
        UiToolkitAPI.PlaySoundEvent('UI.Premier.CounterTimer');
        _m_captureJob = $.Schedule(1, () => { _Countdown(nRemaining - 1); });
    }
    function TakePhoto() {
        if (_m_bCapturing) {
            return;
        }
        _CancelCapture();
        _BeginCapture();
        if (_BTimerMode()) {
            _m_cp.FindChildInLayoutFile('id-pet-countdown').SetHasClass('running', true);
            _Countdown(COUNTDOWN_SEC);
            return;
        }
        _m_captureJob = $.Schedule(COMPOSITION_LAYER_WARMUP, _WritePhoto);
    }
    PopupPetPhotoBooth.TakePhoto = TakePhoto;
    function _PhotoMetaTag() {
        const activity = _CurrentActivity();
        return PetPhotoTag.Compose({
            pose: _m_currentPose.name,
            filter: _m_photoFilter || 'normal',
            stageMap: _m_currentStage,
            growth: _m_photoBoothUpgradeLevel,
            aspect: m_aspectRatio || '1x1',
            zoom: _CurrentZoom(),
            activity: activity ? activity.name : '',
            headwear: _m_currentAttachment,
        });
    }
    function _PetAttr(strAttrName) {
        const value = Number(InventoryAPI.GetItemAttributeValue(_m_petId, '{uint32}' + strAttrName));
        return isNaN(value) ? 0 : value;
    }
    function _CurrentActivity() {
        if (!_IsSoloPose(_m_currentPose)) {
            return undefined;
        }
        const elPanel = _GetPhotoBoothMapPanel();
        if (!elPanel || typeof elPanel.GetPetActivityVariationOnItem !== 'function') {
            return undefined;
        }
        const strEntity = _Growth().entityName;
        const strActivity = elPanel.GetPetActivityOnItem(strEntity);
        const nVariation = elPanel.GetPetActivityVariationOnItem(strEntity);
        return PetPhotoTag.ACTIVITIES.find(activity => activity.activity === strActivity &&
            (activity.variation === undefined ? nVariation < 0 : activity.variation === nVariation));
    }
    const ZOOM_READOUT_SEC = .1;
    let _m_zoomReadoutJob = undefined;
    let _m_nZoomShown = -1;
    function _StartZoomReadout() {
        _m_nZoomShown = -1;
        _TickZoomReadout();
    }
    function _TickZoomReadout() {
        const nZoom = _CurrentZoom();
        if (nZoom !== _m_nZoomShown) {
            if (_m_nZoomShown >= 0) {
                UiToolkitAPI.PlaySoundEvent(nZoom > _m_nZoomShown ? 'Chicken.Photo.ZoomIn'
                    : 'Chicken.Photo.Zoomout');
            }
            _m_nZoomShown = nZoom;
            _m_cp.SetDialogVariableInt('zoom_value', nZoom);
            _m_cp.SetDialogVariable('zoom_band', PetPhotoTag.WordFor('z', String(nZoom)));
        }
        _m_zoomReadoutJob = $.Schedule(ZOOM_READOUT_SEC, _TickZoomReadout);
    }
    function _CurrentZoom() {
        const elPanel = _GetPhotoBoothMapPanel();
        if (!elPanel || typeof elPanel.GetZoom !== 'function') {
            return 0;
        }
        const nZoom = elPanel.GetZoom();
        return (typeof nZoom === 'number' && isFinite(nZoom) && nZoom > 0) ? Math.floor(nZoom) : 0;
    }
    function PhotoGridSliderDefaults() {
        const elSlider = _m_cp.FindChildInLayoutFile('id-photo-grid-slider');
        elSlider.min = 0;
        elSlider.max = .5;
        elSlider.value = .1;
    }
    function SliderDefaults() {
        aAdjust.forEach(adjust => { _ApplySliderDefault(adjust); });
    }
    PopupPetPhotoBooth.SliderDefaults = SliderDefaults;
    function ResetAdjustSliders() {
        aAdjust.forEach(adjust => {
            if (adjust.kind !== 'filter') {
                _ApplySliderDefault(adjust);
            }
        });
    }
    PopupPetPhotoBooth.ResetAdjustSliders = ResetAdjustSliders;
    function _SliderRowId(type) { return 'id-pet-slider-row-' + type; }
    function _MakeAdjustSliders() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-settings-adjust');
        aAdjust.forEach(adjust => {
            if (adjust.kind === 'filter' || elParent.FindChildInLayoutFile(_SliderRowId(adjust.type))) {
                return;
            }
            const elRow = $.CreatePanel('Panel', elParent, _SliderRowId(adjust.type), { class: 'full-width' });
            elRow.BLoadLayoutSnippet('adjust-slider');
            elRow.FindChildInLayoutFile('id-pet-slider-label').text =
                $.Localize('#pet_photo_booth_adjust_' + adjust.type);
            elRow.FindChildInLayoutFile('id-pet-slider')
                .SetPanelEvent('onvaluechanged', () => { OnSliderChanged(adjust.type); });
        });
        elParent.FindChildInLayoutFile('id-pet-slider-reset').SetParent(elParent);
    }
    function _GetSlider(type) {
        const elRow = _m_cp.FindChildTraverse(_SliderRowId(type));
        return (elRow ? elRow.FindChildInLayoutFile('id-pet-slider') : null);
    }
    function _ApplySliderDefault(adjust) {
        const elSlider = _GetSlider(adjust.type);
        if (!elSlider) {
            return;
        }
        elSlider.min = adjust.min;
        elSlider.max = adjust.max;
        elSlider.value = adjust.default;
        _ApplyAdjust(adjust, elSlider.value);
    }
    function OnGridSliderChanged() {
        const elSlider = _m_cp.FindChildInLayoutFile('id-photo-grid-slider');
        const elGrid = _m_cp.FindChildInLayoutFile('id-pet-photo-grid');
        elGrid.style.opacity = elSlider.value + ';';
    }
    PopupPetPhotoBooth.OnGridSliderChanged = OnGridSliderChanged;
    function OnSliderChanged(typeOfSlider) {
        const adjust = aAdjust.find(a => a.type === typeOfSlider);
        const elSlider = _GetSlider(typeOfSlider);
        if (adjust && elSlider) {
            _ApplyAdjust(adjust, elSlider.value);
        }
    }
    PopupPetPhotoBooth.OnSliderChanged = OnSliderChanged;
    function _ApplyAdjust(adjust, value) {
        const elPanel = _GetPicturePanel();
        switch (adjust.kind) {
            case 'post-pair':
                elPanel?.SetPostProcessingWeight(adjust.up, value > 0 ? value : 0);
                elPanel?.SetPostProcessingWeight(adjust.down, value < 0 ? -value : 0);
                break;
            case 'post-single':
                elPanel?.SetPostProcessingWeight(adjust.entity, value);
                break;
            case 'filter':
                if (_m_photoFilter) {
                    elPanel?.SetPostProcessingWeight('pet_post_' + _m_photoFilter, value);
                }
                break;
            case 'brightness':
                _m_cp.FindChildTraverse('id-pet-model').style.brightness = value.toFixed(2);
                break;
            case 'overlay':
                {
                    const elOverlay = _m_cp.FindChildTraverse(adjust.panel_id);
                    elOverlay.style.opacity = value.toFixed(2);
                    elOverlay.visible = value > 0;
                    break;
                }
        }
    }
    function _GetPicturePanel() {
        return _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel');
    }
    function _RefreshAdjustments() {
        const elPanel = _GetPicturePanel();
        if (!elPanel) {
            return;
        }
        aAdjust.forEach(adjust => {
            if (adjust.kind === 'post-pair') {
                elPanel.FireEntityInput(adjust.up, 'Enable');
                elPanel.FireEntityInput(adjust.down, 'Enable');
            }
            else if (adjust.kind === 'post-single') {
                elPanel.FireEntityInput(adjust.entity, 'Enable');
            }
            OnSliderChanged(adjust.type);
        });
    }
    function _EnableDisablePhotoSettings() {
        let aDisableButtons = _m_cp.FindChildrenWithAttributeTraverse('data-disable-solo');
        aDisableButtons.forEach(btn => {
            let bDisableSolo = (btn.GetAttributeString('data-disable-solo', '') === "true") && _IsSoloPose(_m_currentPose) ? true : false;
            btn.enabled = !bDisableSolo;
            btn.SetPanelEvent('onmouseover', () => {
                if (bDisableSolo) {
                    UiToolkitAPI.ShowTextTooltip(btn.id, "#pet_photo_booth_setting_restriction_tooltip");
                }
            });
            btn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        });
        const bStudio = _m_currentStage === STUDIO_STAGE;
        const settingBtnPrefix = 'id-pet-setting-btn-';
        _m_cp.FindChildrenWithAttributeTraverse('data-studio-only').forEach(btn => {
            const settingName = '#pet_photo_booth_setting_' + btn.id.substring(settingBtnPrefix.length);
            btn.enabled = bStudio;
            btn.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip(btn.id, bStudio ? settingName : '#pet_photo_booth_setting_restriction_tooltip');
            });
            btn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        });
        _ClearActivity();
        _RefreshActivityButtons();
    }
    function ShowSettingsRow(setting) {
        let elPanel = _m_cp.FindChildInLayoutFile('id-photo-settings-' + setting);
        if (_m_elSelectedControls !== elPanel) {
            if (_m_elSelectedControls) {
                _m_elSelectedControls.SetHasClass('show', false);
            }
            elPanel.SetHasClass('show', true);
            _m_elSelectedControls = elPanel;
            if (setting === 'stage') {
                SetWallpaperOnStageChange(_m_currentStage === STUDIO_STAGE);
            }
            if (setting === "stickers") {
                UpdateStickerList();
            }
        }
    }
    PopupPetPhotoBooth.ShowSettingsRow = ShowSettingsRow;
    function _AspectBtnId(strAspect) {
        return 'id-photo-ratio-' + strAspect;
    }
    function _OrientationBtnId(strType) {
        return 'id-photo-orientation-' + strType;
    }
    function _MakeAspectButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-settings-format');
        PetPhotoTag.ASPECTS.forEach(aspect => {
            if (elParent.FindChildInLayoutFile(_AspectBtnId(aspect.name))) {
                return;
            }
            const elBtn = $.CreatePanel('RadioButton', elParent, _AspectBtnId(aspect.name), {
                class: 'photo-booth-settings__btn',
                group: 'ratio'
            });
            $.CreatePanel('Label', elBtn, '', {
                text: PetPhotoTag.WordFor('a', String(aspect.id)),
                class: 'stratum-regular'
            });
            elBtn.visible = PetPhotoTag.Orientation(aspect.name) !== 'vertical';
            elBtn.SetPanelEvent('onactivate', () => { UpdateAspectRatioSettings(aspect.name); });
        });
    }
    function UpdateAspectRatioSettings(aspectRatio) {
        _CancelCapture();
        _m_elCaptured.SetCompositionLayerTextureName('');
        const strOrientation = PetPhotoTag.Orientation(aspectRatio);
        ['horizontal', 'vertical'].forEach(strType => {
            const elBtn = _m_cp.FindChildInLayoutFile(_OrientationBtnId(strType));
            elBtn.enabled = strOrientation !== '';
            elBtn.checked = strOrientation === strType;
        });
        _m_elPhotoFrame.SwitchClass('aspect-ratio', 'photo-booth-ratio-' + aspectRatio);
        m_aspectRatio = aspectRatio;
    }
    PopupPetPhotoBooth.UpdateAspectRatioSettings = UpdateAspectRatioSettings;
    function UpdateAgent(team) {
        _SetCharacterAndPetPose(_m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel'), _m_currentPose);
    }
    PopupPetPhotoBooth.UpdateAgent = UpdateAgent;
    function UpdateWallpaper(wallpaper) {
        _m_currentWallpaper = wallpaper;
        _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel').FireEntityInput('backdrop', 'Skin', wallpaper);
    }
    PopupPetPhotoBooth.UpdateWallpaper = UpdateWallpaper;
    function ChangeStage(mapName) {
        _m_currentStage = mapName;
        _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel').SwitchMap(mapName);
        $.Schedule(.2, () => { _SettleStage(mapName); });
        UpdatePhotoPoseSettings(_m_currentPose);
        SetWallpaperOnStageChange(mapName === STUDIO_STAGE);
        $.Schedule(1, () => { OnFilterEffect(_m_photoFilter || 'normal'); });
    }
    PopupPetPhotoBooth.ChangeStage = ChangeStage;
    function SetWallpaperOnStageChange(bisStage) {
        if (bisStage) {
            UpdateWallpaper(_m_currentWallpaper);
        }
        _m_cp.FindChildInLayoutFile('id-photo-wallpapers-section').SetHasClass('show', bisStage);
    }
    const EFFECT_SOUNDS = {
        explosion: 'Photobooth.FX.Explosion',
        lightning: 'Photobooth.FX.Lightning',
        fire: 'Photobooth.FX.FireCircle',
        beam: 'Photobooth.FX.Beam',
        lasers: 'Photobooth.FX.Laser',
        sparks: 'Photobooth.FX.FireWorks',
        confetti: 'Photobooth.FX.Confetti',
        bubbles: 'Photobooth.FX.Bubbles',
        feathers: 'Photobooth.FX.Feathers',
    };
    const EFFECT_REACTION_DELAY = 0.5;
    function PlayEffect(effect) {
        UiToolkitAPI.PlaySoundEvent('Chicken.Camera.FX');
        const strEffectSound = EFFECT_SOUNDS[effect];
        if (strEffectSound) {
            UiToolkitAPI.PlaySoundEvent(strEffectSound);
        }
        const strReaction = 'Chicken.Idle.' + _Growth().soundStage + '.PhotoBooth';
        $.Schedule(EFFECT_REACTION_DELAY, () => { UiToolkitAPI.PlaySoundEvent(strReaction); });
        effect = _PoseShot(_m_currentPose).effectPrefix + effect;
        _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel').FireEntityInput(effect, 'Start');
        $.Schedule(1, () => { _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel').FireEntityInput(effect, 'Stop'); });
    }
    PopupPetPhotoBooth.PlayEffect = PlayEffect;
    const STUDIO_LIGHTS = ['chick_light', 'agent_light'];
    let _m_lightColor = { r: 255, g: 242, b: 230 };
    function _ApplyLightColor(oRGB) {
        _m_lightColor = oRGB;
        const elPanel = _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel');
        const sColor = oRGB.r + ' ' + oRGB.g + ' ' + oRGB.b;
        STUDIO_LIGHTS.forEach(lightName => { elPanel.FireEntityInput(lightName, 'SetColor', sColor); });
    }
    function _RefreshLightColors() {
        _ApplyLightColor(_m_lightColor);
    }
    function ShowLightColorPicker() {
        const elMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('id-pet-setting-btn-light', '', 'file://{resources}/layout/context_menus/context_menu_color_picker.xml', '');
        elMenu.AddClass('ContextMenu_NoArrow');
        CloseSettings();
        elMenu.Data().initRGB = _m_lightColor;
        elMenu.Data().funcCallback = (oResult) => {
            if (oResult.rgb) {
                _ApplyLightColor(oResult.rgb);
            }
        };
    }
    PopupPetPhotoBooth.ShowLightColorPicker = ShowLightColorPicker;
    function AttachModel(modelPath) {
        _m_currentAttachment = modelPath;
        _ApplyAttachment();
    }
    PopupPetPhotoBooth.AttachModel = AttachModel;
    function _ApplyAttachment() {
        let elPanel = _m_elItemModelImagePanel.FindChildInLayoutFile('id-pet-picture-panel');
        if (!elPanel)
            return;
        elPanel.DetachModelsFromItem(_m_petId);
        if (_m_currentAttachment !== '') {
            const headwearAttachPoint = _m_currentAttachment.includes('glasses') ? 'eyewear_attach' : 'head_attach';
            elPanel.AttachModelToItemWithScale(_m_currentAttachment, _m_petId, headwearAttachPoint, _Growth().headwearScale);
        }
    }
    function CloseSettings() {
        if (_m_elSelectedControls && _m_elSelectedControls.IsValid()) {
            _m_elSelectedControls.SetHasClass('show', false);
            _m_cp.FindChildInLayoutFile('id-pet-photo-controls').Children().forEach(btn => { btn.checked = false; });
            _m_elSelectedControls = null;
        }
    }
    PopupPetPhotoBooth.CloseSettings = CloseSettings;
    function SetAspectRatio(type) {
        let strFlip = '';
        PetPhotoTag.ASPECTS.forEach(aspect => {
            const strOrientation = PetPhotoTag.Orientation(aspect.name);
            if (strOrientation === '') {
                return;
            }
            const elBtn = _m_cp.FindChildInLayoutFile(_AspectBtnId(aspect.name));
            if (elBtn.checked && strOrientation !== type) {
                strFlip = PetPhotoTag.FlipAspect(aspect.name);
            }
            elBtn.visible = strOrientation === type;
        });
        if (strFlip !== '') {
            _m_cp.FindChildInLayoutFile(_AspectBtnId(strFlip)).checked = true;
            UpdateAspectRatioSettings(strFlip);
        }
    }
    PopupPetPhotoBooth.SetAspectRatio = SetAspectRatio;
    function _FilterBtnId(strFilter) {
        return 'id-photo-filter-' + strFilter;
    }
    function _HeadwearBtnId(strName) { return 'id-photo-headwear-' + strName; }
    function _MakeHeadwearButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-settings-headwear');
        PetPhotoTag.HEADWEAR.forEach(row => {
            if (elParent.FindChildInLayoutFile(_HeadwearBtnId(row.name))) {
                return;
            }
            const elBtn = $.CreatePanel('RadioButton', elParent, _HeadwearBtnId(row.name), {
                class: 'photo-booth-settings__btn',
                group: 'headwear'
            });
            $.CreatePanel('Label', elBtn, '', {
                text: PetPhotoTag.WordFor('e', String(row.id)),
                class: 'stratum-regular'
            });
            elBtn.SetPanelEvent('onactivate', () => { AttachModel(row.model); });
        });
    }
    function _MakeFilterButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-photo-settings-filters');
        PetPhotoTag.FILTERS.forEach(filter => {
            if (elParent.FindChildInLayoutFile(_FilterBtnId(filter.name))) {
                return;
            }
            const elBtn = $.CreatePanel('RadioButton', elParent, _FilterBtnId(filter.name), {
                class: 'photo-booth-settings__btn',
                group: 'filter'
            });
            $.CreatePanel('Label', elBtn, '', {
                text: PetPhotoTag.WordFor('f', String(filter.id)),
                class: 'stratum-regular'
            });
            elBtn.SetPanelEvent('onactivate', () => { OnFilterEffect(filter.name); });
        });
        elParent.FindChildInLayoutFile('id-photo-filter-strength-row').SetParent(elParent);
    }
    function OnFilterEffect(filterName) {
        const elPanel = _GetPicturePanel();
        if (!elPanel) {
            return;
        }
        if (_m_photoFilter) {
            elPanel.FireEntityInput('pet_post_' + _m_photoFilter, 'Disable');
        }
        elPanel.FireEntityInput('pet_post_' + filterName, 'Enable');
        _m_photoFilter = filterName;
        _m_cp.FindChildInLayoutFile('id-photo-filter-strength-row').SetHasClass('hide', filterName === 'normal');
        const strength = aAdjust.find(adjust => adjust.kind === 'filter');
        if (strength) {
            _ApplySliderDefault(strength);
        }
    }
    PopupPetPhotoBooth.OnFilterEffect = OnFilterEffect;
    function TurnOffAllFilters() {
        const elPanel = _GetPicturePanel();
        if (!elPanel) {
            return;
        }
        PetPhotoTag.FILTERS.forEach(filter => {
            elPanel.FireEntityInput('pet_post_' + filter.name, 'Disable');
        });
        elPanel.FireEntityInput('post_vanity', 'Disable');
    }
    const STICKER_LIST_FILTER = 'item_definition:sticker';
    const MAX_PLACED_STICKERS = 10;
    const STICKER_DROP_JITTER = 120;
    const _m_placedStickerIds = new Set();
    function UpdateStickerList() {
        const elList = _m_cp.FindChildInLayoutFile('id-pet-sticker-item-list');
        const elSearch = _m_cp.FindChildInLayoutFile('id-pet-sticker-search');
        $.DispatchEvent('SetInventoryFilter', elList, 'inv_graphic_art', 'sticker', 'any', 'inv_sort_age', STICKER_LIST_FILTER, elSearch.text);
    }
    function _StickerCount() {
        const elList = _m_cp.FindChildInLayoutFile('id-pet-sticker-item-list');
        $.DispatchEvent('SetInventoryFilter', elList, 'inv_graphic_art', 'sticker', 'any', 'inv_sort_age', STICKER_LIST_FILTER, '');
        return elList.count;
    }
    function _RefreshStickerTile(elTile) {
        const itemId = elTile.GetAttributeString('itemid', '0');
        elTile.enabled = !_m_placedStickerIds.has(itemId) && _m_placedStickerIds.size < MAX_PLACED_STICKERS;
    }
    function _RefreshStickerTiles() {
        _m_cp.FindChildInLayoutFile('id-pet-sticker-item-list')
            .FindChildrenWithClassTraverse('item-tile').forEach(_RefreshStickerTile);
    }
    let zIndex = 0;
    function OnItemTileActivated(elPanel, itemId) {
        if (_m_placedStickerIds.has(itemId) || _m_placedStickerIds.size >= MAX_PLACED_STICKERS) {
            return;
        }
        _m_placedStickerIds.add(itemId);
        _RefreshStickerTiles();
        CloseSettings();
        const elParent = _m_cp.FindChildInLayoutFile('id-pet-sticker-layer');
        const elDragPanel = $.CreatePanel('DragPanel', elParent, 'id-drag-panel-' + itemId);
        elDragPanel.style.zIndex = ++zIndex + ';';
        elDragPanel.SetDragPosition(Math.random() * STICKER_DROP_JITTER, Math.random() * STICKER_DROP_JITTER);
        const elSticker = $.CreatePanel('Panel', elParent, 'id-sticker-panel-' + itemId, { class: 'placed-sticker-container' });
        elSticker.BLoadLayoutSnippet('sticker');
        const elImage = elSticker.FindChildInLayoutFile('sticker');
        elImage.itemid = itemId;
        const elRotateSlider = elSticker.FindChildInLayoutFile('id-sticker-rotate');
        elRotateSlider.min = -180;
        elRotateSlider.max = 180;
        elRotateSlider.default = 0;
        const elScaleSlider = elSticker.FindChildInLayoutFile('id-sticker-scale');
        elScaleSlider.min = 240;
        elScaleSlider.max = 360;
        elScaleSlider.value = 360;
        elRotateSlider.SetPanelEvent('onvaluechanged', () => {
            if (elScaleSlider.value < .5) {
                elScaleSlider.value = 1;
            }
            elImage.style.transform = "rotatez( " + elRotateSlider.value + "deg );";
        });
        elScaleSlider.SetPanelEvent('onvaluechanged', () => {
            elImage.style.width = elScaleSlider.value + 'px;';
        });
        elSticker.FindChildInLayoutFile('id-sticker-remove').SetPanelEvent('onactivate', () => {
            _m_placedStickerIds.delete(itemId);
            elDragPanel.DeleteAsync(0);
            _RefreshStickerTiles();
        });
        elSticker.SetParent(elDragPanel);
    }
    function _SetUpPhotoLibrary() {
        const elLibrary = _m_cp.FindChildInLayoutFile('id-photo-library');
        const elBody = _m_cp.FindChildInLayoutFile('id-photo-library-body');
        elBody.BLoadLayout('file://{resources}/layout/popups/pet_photo_library.xml', false, false);
        PetPhotoLibrary.Init(elBody, {
            bDeletable: true,
            fnEmpty: () => '#pet_photo_library_empty',
            fnOnDeleted: (strFileName) => {
                if (_m_lastSavedPhoto === strFileName) {
                    _m_lastSavedPhoto = '';
                }
            },
        });
        elLibrary.visible = true;
    }
    function LoadPreviousPhotos() {
        PetPhotoLibrary.LoadFromDisk(_m_petId);
    }
    {
        $.RegisterForUnhandledEvent("OnItemTileActivated", OnItemTileActivated);
    }
})(PopupPetPhotoBooth || (PopupPetPhotoBooth = {}));
