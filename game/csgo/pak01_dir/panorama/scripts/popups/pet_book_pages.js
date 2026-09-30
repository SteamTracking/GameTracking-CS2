"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/pet_photo_library.ts" />
/// <reference path="../popups/pet_photo_tag.ts" />
var PetBookPages;
(function (PetBookPages) {
    const _m_cp = $.GetContextPanel();
    const STAGE_EGG = 0;
    const STAGE_CHICK = 1;
    const STAGE_ADOLESCENT = 2;
    const STAGE_ADULT = 3;
    const NAME_PLACEHOLDER = $.Localize('#pet_book_name_placeholder');
    let _m_pet = { strId: '', strName: NAME_PLACEHOLDER, nStage: STAGE_EGG, rtHatch: 0, bookdata: {} };
    let _m_strBookKey = '';
    let _m_bHasLivePet = false;
    function _NewestBookOnDisk() {
        const aBooks = GameInterfaceAPI.GetPetBookCloudFileKeys();
        if (aBooks.length <= 0) {
            return '';
        }
        const petKey = GameInterfaceAPI.UnpackPetBookCloudFile(aBooks[aBooks.length - 1]);
        if (!petKey) {
            return '';
        }
        _m_pet = _ReadPet(petKey);
        return petKey;
    }
    function _ItemAttr(strId, strAttrName) {
        const value = Number(InventoryAPI.GetItemAttributeValue(strId, '{uint32}' + strAttrName));
        return isNaN(value) ? 0 : value;
    }
    function _ReadPet(strId) {
        if (!strId)
            strId = InventoryAPI.GetPetItemID();
        if (!strId) {
            return { strId: '', strName: NAME_PLACEHOLDER, nStage: STAGE_EGG, rtHatch: 0, bookdata: {} };
        }
        const nStage = _ItemAttr(strId, 'upgrade level');
        return {
            strId: strId,
            strName: _PetName(strId, nStage),
            nStage: nStage,
            rtHatch: _ItemAttr(strId, 'deployment date'),
            bookdata: {},
        };
    }
    function _PetName(strId, nStage) {
        if (nStage <= STAGE_EGG)
            return NAME_PLACEHOLDER;
        let nPreviousStage = nStage;
        while (nPreviousStage > 0) {
            const utf8name = InventoryAPI.GetItemAttributeValue(strId, '{bytestring}custom name attr'
                + ((nPreviousStage >= 2) ? ' ' + nPreviousStage : ''));
            if (utf8name)
                return utf8name;
            --nPreviousStage;
        }
        let nNextStage = nStage + 1;
        while (nNextStage <= 3) {
            const utf8name = InventoryAPI.GetItemAttributeValue(strId, '{bytestring}custom name attr'
                + ((nNextStage >= 2) ? ' ' + nNextStage : ''));
            if (utf8name)
                return utf8name;
            ++nNextStage;
        }
        return InventoryAPI.GetItemNameUncustomized(strId);
    }
    function _HatchDateText() {
        const rtHatch = _m_pet.rtHatch;
        if (!rtHatch) {
            return '';
        }
        const strDate = InventoryAPI.LocalizeRentalDate(rtHatch);
        if (_m_pet.nStage !== STAGE_EGG) {
            return strDate;
        }
        _m_cp.SetDialogVariable('hatch_day', strDate);
        return $.Localize('#pet_book_hatch_due', _m_cp);
    }
    function PetItemID() {
        return _m_pet.strId;
    }
    PetBookPages.PetItemID = PetItemID;
    function PetStage() {
        return _m_pet.nStage;
    }
    PetBookPages.PetStage = PetStage;
    function HasLivePet() {
        return _m_bHasLivePet;
    }
    PetBookPages.HasLivePet = HasLivePet;
    const FREE_LAYOUTS = [
        { name: 'single', slots: [0] },
        { name: 'pair', slots: [1, 2] },
        { name: 'trio', slots: [3, 4, 5] },
        { name: 'quad', slots: [6, 7, 8, 9] },
    ];
    const FREE_HOLES = {};
    FREE_LAYOUTS.forEach(shape => shape.slots.forEach(nSlot => {
        FREE_HOLES[nSlot] = { hint: '#pet_book_hint_free' };
    }));
    const LAYOUTS = {
        'intro': { id: 1, snippet: 'page-intro', holes: {
                0: { alsoRequires: 'zoom:closeup', hint: '#pet_book_hint_chick_intro' },
            } },
        'feet': { id: 2, snippet: 'page-feet', holes: {
                0: { alsoRequires: 'zoom:wide', hint: '#pet_book_hint_chick_feet' },
            } },
        'early-days': { id: 3, snippet: 'page-early-days', holes: {
                0: { alsoRequires: 'pose:8|9|10', hint: '#pet_book_hint_chick_and_you' },
            } },
        'chick-park': { id: 4, snippet: 'page-chick-park', holes: {
                0: { alsoRequires: 'stage:picnic', hint: '#pet_book_hint_chick_park' },
            } },
        'teen-warehouse': { id: 5, snippet: 'page-teen-warehouse', holes: {
                0: { alsoRequires: 'stage:warehouse', hint: '#pet_book_hint_adolescent_intro' },
            } },
        'teen-trip-1': { id: 6, snippet: 'page-teen-trip-set-1', holes: {
                0: { alsoRequires: 'stage:dust2|airport|inferno|train', hint: '#pet_book_hint_adolescent_road_trip' },
            } },
        'teen-trip-2': { id: 7, snippet: 'page-teen-trip-set-2', holes: {
                0: { alsoRequires: 'stage:mirage|nuke|cache|ancient', hint: '#pet_book_hint_adolescent_road_trip' },
            } },
        'birthday': { id: 8, snippet: 'page-birthday', holes: {
                0: { alsoRequires: 'activity:jump,headwear:party', hint: '#pet_book_hint_birthday' },
            } },
        'adult-perch': { id: 10, snippet: 'page-adult-perch', holes: {
                0: { alsoRequires: 'pose:1|3|6|7,filter:sepia', hint: '#pet_book_hint_adult_perch' },
            } },
        'adult-tricks': { id: 11, snippet: 'page-adult-tricks', holes: {
                0: { alsoRequires: 'activity:kick|fly', hint: '#pet_book_hint_adult_tricks' },
            } },
        'adult-close': { id: 13, snippet: 'page-adult-close', holes: {
                0: { alsoRequires: 'pose:4|5', hint: '#pet_book_hint_adult_close' },
            } },
        'brave-fire': { id: 15, snippet: 'page-brave-fire', achievement: 'killed-by-burn', holes: {} },
        'brave-taser': { id: 16, snippet: 'page-brave-taser', achievement: 'killed-by-taser', holes: {} },
        'brave-c4': { id: 17, snippet: 'page-brave-c4', achievement: 'killed-by-planted-c4', holes: {} },
        'free': { id: 14, snippet: 'page-free', holes: FREE_HOLES },
    };
    const SECTIONS = [
        {
            name: 'chick', icon: 'pet_chick.svg', stage: STAGE_CHICK,
            pages: ['intro', 'feet', 'early-days', 'chick-park', 'free', 'free'],
        },
        {
            name: 'pullet', icon: 'pet_pullet.svg', stage: STAGE_ADOLESCENT,
            pages: ['teen-warehouse', 'teen-trip-1', 'teen-trip-2', 'birthday', 'free', 'free'],
        },
        {
            name: 'brave', icon: 'pet_field_report.svg', stage: STAGE_ADULT,
            pages: ['brave-fire', 'brave-taser', 'brave-c4'],
        },
        {
            name: 'hen', icon: 'pet_hen.svg', stage: STAGE_ADULT,
            pages: ['adult-perch', 'adult-tricks', 'adult-close', 'free', 'free'],
        },
    ];
    const PAGES = [];
    SECTIONS.forEach(section => section.pages.forEach(strName => {
        const layout = LAYOUTS[strName];
        PAGES.push({ num: PAGES.length + 1, section: section, layout: layout });
    }));
    function _PageAt(nPageNum) {
        return PAGES[nPageNum - 1];
    }
    function _RequireOf(page, hole) {
        const strGrowth = PetPhotoTag.GrowthTerm(page.section.stage);
        return hole.alsoRequires === undefined ? strGrowth : strGrowth + ',' + hole.alsoRequires;
    }
    function _RequireAt(nPageNum, nSlot) {
        const page = _PageAt(nPageNum);
        if (page === undefined) {
            return undefined;
        }
        const hole = page.layout.holes[nSlot];
        return hole === undefined ? undefined : _RequireOf(page, hole);
    }
    let _m_aShown = [];
    function _IsBehindTheBird(page) {
        return _m_pet.nStage > page.section.stage;
    }
    function _IsUnlocked(page) {
        const strAchievement = page.layout.achievement;
        if (strAchievement === undefined || _HasPhotos(page)) {
            return true;
        }
        return _m_pet.strId !== '' && InventoryAPI.PetHasAchievement(_m_pet.strId, strAchievement);
    }
    function _CanFill(page, aPhotos) {
        return Object.values(page.layout.holes).some(hole => {
            const strRequire = _RequireOf(page, hole);
            return aPhotos.some(strFileName => PetPhotoTag.Matches(strFileName, strRequire));
        });
    }
    function _AllPhotos() {
        if (_m_strBookKey === '') {
            return [];
        }
        return GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL')
            .concat(GameInterfaceAPI.FindFiles(PetPhotoTag.BookFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL'));
    }
    function _BuildShown() {
        const aPhotos = _AllPhotos();
        _m_aShown = PAGES
            .filter(page => _IsUnlocked(page) && (!_IsBehindTheBird(page) || _HasPhotos(page) || _CanFill(page, aPhotos)))
            .map(page => page.num);
    }
    function ShownPages() {
        return _m_aShown;
    }
    PetBookPages.ShownPages = ShownPages;
    function Chapters() {
        const aChapters = [];
        SECTIONS.forEach(section => {
            const nFirst = _m_aShown.find(nPage => PAGES[nPage - 1].section === section);
            if (nFirst !== undefined) {
                aChapters.push({ name: section.name, icon: section.icon, page: nFirst });
            }
        });
        return aChapters;
    }
    PetBookPages.Chapters = Chapters;
    function _LayoutIdForPage(nPageNum) {
        const page = _PageAt(nPageNum);
        return page === undefined ? 0 : page.layout.id;
    }
    const _m_photos = {};
    function _PhotosOn(nPageNum) {
        if (!_m_photos[nPageNum]) {
            _m_photos[nPageNum] = {};
        }
        return _m_photos[nPageNum];
    }
    function _PhotoAt(nPage, nSlot) {
        const photos = _m_photos[nPage];
        return photos ? photos[nSlot] || '' : '';
    }
    function _HasPhotos(page) {
        const photos = _m_photos[page.num];
        return photos !== undefined && Object.keys(photos).length > 0;
    }
    function _SlotPlace(elSlot) {
        return {
            page: elSlot.GetAttributeInt('data-page', -1),
            slot: elSlot.GetAttributeInt('data-slot', -1),
        };
    }
    function _Load() {
        if (_m_strBookKey === '') {
            return;
        }
        GameInterfaceAPI.FindFiles(PetPhotoTag.BookFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL').forEach(strFileName => {
            const place = PetPhotoTag.PlaceOf(strFileName);
            if (!place || place.slot === PetPhotoTag.SLOT_UNPLACED) {
                return;
            }
            if (place.layout !== _LayoutIdForPage(place.page)) {
                return;
            }
            const slots = _PhotosOn(place.page);
            const strSitting = slots[place.slot];
            if (!strSitting) {
                slots[place.slot] = strFileName;
                return;
            }
            const bNewer = PetPhotoTag.CaptureMS(strFileName) > PetPhotoTag.CaptureMS(strSitting);
            slots[place.slot] = bNewer ? strFileName : strSitting;
        });
    }
    function _Reload(bRoll) {
        Object.keys(_m_photos).forEach(strPageNum => { delete _m_photos[Number(strPageNum)]; });
        _Load();
        if (bRoll) {
            PetPhotoLibrary.LoadFromDisk(_m_strBookKey);
        }
        $.Schedule(0, _m_fnRefreshSpread);
    }
    function _EmptyLibraryText() {
        return PAGES.some(_HasPhotos) ? '#pet_photo_library_empty_in_book' : '#pet_photo_library_empty';
    }
    function _BookName(strFileName, nPage, nSlot) {
        return PetPhotoTag.BookName(strFileName, { page: nPage, layout: _LayoutIdForPage(nPage), slot: nSlot });
    }
    function _MoveIntoBook(strFileName, nPage, nSlot) {
        const strNew = _BookName(strFileName, nPage, nSlot);
        return GameInterfaceAPI.MovePetPhotoToBook(_m_strBookKey, strFileName, strNew) ? strNew : '';
    }
    function _MoveWithinBook(strFileName, nPage, nSlot) {
        const strNew = _BookName(strFileName, nPage, nSlot);
        return GameInterfaceAPI.RenameBookPhoto(_m_strBookKey, strFileName, strNew) ? strNew : '';
    }
    function _MoveToLibrary(strFileName) {
        const strNew = PetPhotoTag.RollName(strFileName);
        return GameInterfaceAPI.MoveBookPhotoToPet(_m_strBookKey, strFileName, strNew) ? strNew : '';
    }
    function _Reconcile() {
        if (_m_strBookKey === '') {
            return;
        }
        const aBook = GameInterfaceAPI.FindFiles(PetPhotoTag.BookFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL');
        const inBook = {};
        aBook.forEach(strFileName => { inBook[PetPhotoTag.CaptureMS(strFileName)] = true; });
        GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL').forEach(strFileName => {
            if (inBook[PetPhotoTag.CaptureMS(strFileName)]) {
                GameInterfaceAPI.DeletePetPhoto(_m_strBookKey, strFileName);
            }
        });
        const byHole = {};
        const byPhoto = {};
        const aHome = [];
        aBook.sort().reverse().forEach(strFileName => {
            const place = PetPhotoTag.PlaceOf(strFileName);
            const strMS = PetPhotoTag.CaptureMS(strFileName);
            if (!place || place.slot === PetPhotoTag.SLOT_UNPLACED) {
                aHome.push(strFileName);
                return;
            }
            if (place.layout !== _LayoutIdForPage(place.page)) {
                aHome.push(strFileName);
                return;
            }
            const strKey = place.page + '_' + place.slot;
            if (byHole[strKey] || byPhoto[strMS]) {
                aHome.push(strFileName);
                return;
            }
            byHole[strKey] = true;
            byPhoto[strMS] = true;
        });
        aHome.forEach(strFileName => {
            _MoveToLibrary(strFileName);
        });
    }
    let _m_strDragFile = '';
    let _m_dragFrom = null;
    let _m_bDropHandled = false;
    let _m_elDragImage = null;
    let _m_justDropped = null;
    let _m_fnRefreshSpread = () => { };
    function Init(fnRefreshSpread) {
        _m_fnRefreshSpread = fnRefreshSpread;
        const strAskedFor = _m_cp.GetAttributeString('bookkey', '');
        const strAskedPet = strAskedFor === '' ? '' : GameInterfaceAPI.UnpackPetBookCloudFile(strAskedFor);
        _m_pet = _ReadPet();
        _m_bHasLivePet = _m_pet.strId !== '' && (strAskedPet === '' || strAskedPet === _m_pet.strId);
        if (_m_bHasLivePet) {
            GameInterfaceAPI.UnpackPetBookCloudFile(_m_pet.strId);
            GameInterfaceAPI.PreparePetPhoto(_m_pet.strId, '');
            _m_strBookKey = _m_pet.strId;
        }
        else if (strAskedPet !== '') {
            _m_pet = _ReadPet(strAskedPet);
            _m_strBookKey = strAskedPet;
        }
        else {
            _m_strBookKey = _NewestBookOnDisk();
        }
        if (_m_strBookKey)
            _m_pet.bookdata = GameInterfaceAPI.GetPetPhotoBookData(_m_strBookKey);
        _m_cp.SetDialogVariable('pet_name', _m_pet.strName);
        for (let iLifeStage = 1; iLifeStage <= 3; ++iLifeStage) {
            _m_cp.SetDialogVariable('pet_name_' + iLifeStage, _PetName(_m_pet.strId, iLifeStage));
        }
        _m_cp.SetDialogVariable('hatch_date', _HatchDateText());
        const elBody = _m_cp.FindChildInLayoutFile('id-photo-library-body');
        elBody.BLoadLayout('file://{resources}/layout/popups/pet_photo_library.xml', false, false);
        _Reconcile();
        PetPhotoLibrary.Init(elBody, {
            bDraggable: true,
            bDeletable: true,
            fnEmpty: _EmptyLibraryText,
            fnOnDragStart: _OnLibraryDragStart,
            fnOnDragEnd: _EndDrag,
        });
        PetPhotoLibrary.LoadFromDisk(_m_strBookKey);
        _m_cp.FindChildInLayoutFile('id-pb-booth-btn').visible = HasLivePet();
        _Load();
        _BuildShown();
    }
    PetBookPages.Init = Init;
    function _Image(elParent, strClass) {
        const aImages = elParent.FindChildrenWithClassTraverse(strClass);
        return aImages.length > 0 ? aImages[0] : null;
    }
    function _SetSlotHint(elSlot, strAgainst) {
        const place = _SlotPlace(elSlot);
        const page = _PageAt(place.page);
        const aLabels = elSlot.FindChildrenWithClassTraverse('pb-slot__hint');
        if (page === undefined || aLabels.length === 0) {
            return;
        }
        const hole = page.layout.holes[place.slot];
        if (hole === undefined) {
            return;
        }
        const strRequire = _RequireOf(page, hole);
        const aUnmet = strAgainst === '' ? [] : PetPhotoTag.Unmet(strAgainst, strRequire);
        const elLabel = aLabels[0];
        PetPhotoTag.TermWords(strRequire).forEach(term => {
            const strOwn = hole.hint + '_' + term.name;
            const strWord = $.CanLocalize(strOwn) ? $.Localize(strOwn) : term.word;
            const strClass = 'pb-hint-' + term.name +
                (aUnmet.indexOf(term.name) >= 0 ? ' pb-hint-unmet' : '');
            elLabel.SetDialogVariable(term.name, '<span class="' + strClass + '">' + strWord + '</span>');
        });
        elLabel.text = hole.hint;
    }
    const _m_freeChoice = {};
    function _FreeLayoutNamed(strName) {
        return FREE_LAYOUTS.find(layout => layout.name === strName);
    }
    function _FreeLayoutOf(nPageNum) {
        const slots = _PhotosOn(nPageNum);
        const worn = FREE_LAYOUTS.find(layout => layout.slots.some(nSlot => slots[nSlot] !== undefined));
        return worn || _FreeLayoutNamed(_m_freeChoice[nPageNum]) || FREE_LAYOUTS[0];
    }
    function _ChooseLayout(elPage, nPageNum, strName) {
        if (!_FreeLayoutNamed(strName)) {
            return;
        }
        _m_freeChoice[nPageNum] = strName;
        const slots = _PhotosOn(nPageNum);
        const aOn = Object.keys(slots).map(Number);
        if (aOn.length === 0) {
            _ShowFreeLayout(elPage, nPageNum);
            return;
        }
        aOn.forEach(nSlot => { _MoveToLibrary(slots[nSlot]); });
        _Reload(true);
    }
    function _FreeBtnId(nPageNum, strName) {
        return 'id-pb-free-' + nPageNum + '-' + strName;
    }
    function _ShowFreeLayout(elPage, nPageNum) {
        const worn = _FreeLayoutOf(nPageNum);
        elPage.FindChildrenWithClassTraverse('pb-free-group').forEach(elGroup => {
            elGroup.visible = elGroup.GetAttributeString('data-free', '') === worn.name;
        });
        const elBtn = _m_cp.FindChildTraverse(_FreeBtnId(nPageNum, worn.name));
        if (elBtn) {
            elBtn.checked = true;
        }
    }
    function _DressFreePage(elPage, nPageNum) {
        const elStrip = elPage.FindChildrenWithClassTraverse('pb-free-strip')[0];
        if (!elStrip) {
            return;
        }
        FREE_LAYOUTS.forEach(layout => {
            const elBtn = $.CreatePanel('RadioButton', elStrip, _FreeBtnId(nPageNum, layout.name), {
                class: 'pb-free-btn',
                group: 'pb-free-' + nPageNum
            });
            $.CreatePanel('Image', elBtn, '', {
                src: 'file://{images}/icons/ui/page_layout_' + layout.name + '.svg',
                textureheight: '20',
                texturewidth: '-1',
                scaling: 'stretch-to-fit-preserve-aspect'
            });
            elBtn.SetPanelEvent('onactivate', () => { _ChooseLayout(elPage, nPageNum, layout.name); });
        });
        _ShowFreeLayout(elPage, nPageNum);
    }
    function FillPage(elPage, nPageNum) {
        const page = _PageAt(nPageNum);
        if (page === undefined) {
            return;
        }
        const photos = _PhotosOn(nPageNum);
        elPage.BLoadLayoutSnippet(page.layout.snippet);
        elPage.SetDialogVariableInt('num', nPageNum);
        if (page.layout === LAYOUTS.free) {
            _DressFreePage(elPage, nPageNum);
        }
        const aClaimed = [];
        elPage.FindChildrenWithClassTraverse('pb-slot').forEach(elSlot => {
            const nSlot = elSlot.GetAttributeInt('data-slot', -1);
            if (nSlot < 0) {
                return;
            }
            _BuildHole(elSlot);
            aClaimed.push(nSlot);
            if (page.layout.holes[nSlot] === undefined) {
            }
            elSlot.SetAttributeInt('data-page', nPageNum);
            const strPhoto = photos[nSlot];
            elSlot.SetHasClass('pb-slot--filled', !!strPhoto);
            _SetSlotHint(elSlot, '');
            if (strPhoto) {
                _SetSlotPhoto(elSlot, strPhoto);
            }
            elSlot.SetDraggable(!!strPhoto);
            if (strPhoto) {
                $.RegisterEventHandler('DragStart', elSlot, (el, drag) => {
                    _m_dragFrom = _SlotPlace(elSlot);
                    _BeginDrag(strPhoto, drag);
                });
                $.RegisterEventHandler('DragEnd', elSlot, _EndDrag);
            }
            $.RegisterEventHandler('DragEnter', elSlot, () => {
                const bTakes = _CanDrop(elSlot);
                elSlot.SetHasClass('pb-slot--drag-over', bTakes);
                elSlot.SetHasClass('pb-slot--drag-reject', !bTakes);
                _SetSlotHint(elSlot, bTakes ? '' : _m_strDragFile);
                _ShowDragWillRemove(false);
            });
            $.RegisterEventHandler('DragLeave', elSlot, () => {
                _ClearDragOver(elSlot);
                _ShowDragWillRemove(true);
            });
            $.RegisterEventHandler('DragDrop', elSlot, () => {
                _ClearDragOver(elSlot);
                _DropPhoto(elSlot);
            });
            if (_m_justDropped && _m_justDropped.page === nPageNum && _m_justDropped.slot === nSlot) {
                _m_justDropped = null;
                elSlot.TriggerClass('pb-slot--dropped');
            }
        });
        Object.keys(photos).forEach(strSlot => {
            const nSlot = Number(strSlot);
            if (aClaimed.indexOf(nSlot) >= 0) {
                return;
            }
            delete photos[nSlot];
        });
        elPage.SetHasClass('pb-dressed', Object.keys(photos).length > 0 || Object.keys(page.layout.holes).length === 0);
        _FillParagraph(elPage, nPageNum);
        _ApplyDragState();
    }
    PetBookPages.FillPage = FillPage;
    function _BuildHole(elSlot) {
        const elClip = $.CreatePanel('Panel', elSlot, '', { class: 'pb-slot__clip' });
        $.CreatePanel('Image', elClip, '', { class: 'pb-slot__image', scaling: 'cover' });
        $.CreatePanel('Label', elSlot, '', { class: 'pb-slot__hint', html: 'true' });
    }
    function _FillParagraph(elPage, nPageNum) {
        const strFileName = _PhotosOn(nPageNum)[0];
        const nCaptureMS = strFileName ? Number(PetPhotoTag.CaptureMS(strFileName)) : 0;
        elPage.FindChildrenWithClassTraverse('pb-page__paragraph').forEach(elLabel => {
            const strToken = elLabel.GetAttributeString('data-paragraph', '');
            const nCount = elLabel.GetAttributeInt('data-variants', 0);
            if (strToken === '' || nCount <= 0) {
                return;
            }
            elLabel.text = $.Localize(strToken + '_' + (nCaptureMS % nCount), elLabel);
        });
    }
    function _SetSlotPhoto(elSlot, strFileName) {
        const elImage = _Image(elSlot, 'pb-slot__image');
        if (!elImage) {
            return;
        }
        elImage.SetImageFromFile(PetPhotoTag.PhotoUrl(_m_strBookKey, strFileName));
        _ApplyFrame(elSlot, elImage, strFileName, PetPhotoTag.FrameOf(strFileName));
        _MakeFrameButton(elSlot);
    }
    function _MakeFrameButton(elSlot) {
        if (elSlot.FindChildrenWithClassTraverse('pb-slot__frame-btn').length > 0) {
            return;
        }
        const elBtn = $.CreatePanel('Button', elSlot, '', { class: 'pb-slot__frame-btn' });
        $.CreatePanel('Image', elBtn, '', {
            src: 'file://{images}/icons/ui/tune.svg',
            textureheight: '24',
            texturewidth: '-1',
            scaling: 'stretch-to-fit-preserve-aspect'
        });
        elBtn.SetPanelEvent('onactivate', () => { OpenFrame(elSlot); });
    }
    const _m_holeAspect = {};
    function _HoleAspect(elSlot) {
        const place = _SlotPlace(elSlot);
        const strKey = _LayoutIdForPage(place.page) + ':' + place.slot;
        if (_m_holeAspect[strKey] > 0) {
            return _m_holeAspect[strKey];
        }
        const flW = elSlot.actuallayoutwidth / (elSlot.actualuiscale_x || 1);
        const flH = elSlot.actuallayoutheight / (elSlot.actualuiscale_y || 1);
        if (flW <= 0 || flH <= 0) {
            return 0;
        }
        _m_holeAspect[strKey] = flW / flH;
        return _m_holeAspect[strKey];
    }
    function _FrameSize(flHole, strFileName, frame) {
        const flPhoto = PetPhotoTag.Aspect(strFileName);
        const flZoom = frame.zoom / 100;
        return {
            w: (flPhoto >= flHole ? 100 * flPhoto / flHole : 100) * flZoom,
            h: (flPhoto >= flHole ? 100 : 100 * flHole / flPhoto) * flZoom,
        };
    }
    function _ApplyFrame(elSlot, elImage, strFileName, frame) {
        if (PetPhotoTag.IsDefaultFrame(frame)) {
            elImage.style.width = '100%;';
            elImage.style.height = '100%;';
            elImage.style.transform = 'none;';
            elImage.style.opacity = '1;';
            return;
        }
        const flHole = _HoleAspect(elSlot);
        if (flHole <= 0) {
            elImage.style.opacity = '0;';
            _DeferFrame(elSlot);
            return;
        }
        const { w: flW, h: flH } = _FrameSize(flHole, strFileName, frame);
        elImage.style.width = flW.toFixed(2) + '%;';
        elImage.style.height = flH.toFixed(2) + '%;';
        const flX = (flW - 100) * (0.5 - frame.x / 100);
        const flY = (flH - 100) * (0.5 - frame.y / 100);
        elImage.style.transform = 'translateX( ' + flX.toFixed(2) + '% ) translateY( ' + flY.toFixed(2) + '% );';
        elImage.style.opacity = '1;';
    }
    const FRAME_MEASURE_TRIES = 8;
    function _DeferFrame(elSlot) {
        const nTried = elSlot.GetAttributeInt('data-frame-tries', 0);
        if (nTried >= FRAME_MEASURE_TRIES) {
            return;
        }
        elSlot.SetAttributeInt('data-frame-tries', nTried + 1);
        $.Schedule(0, () => {
            if (!elSlot.IsValid()) {
                return;
            }
            const place = _SlotPlace(elSlot);
            const strPhoto = _PhotoAt(place.page, place.slot);
            if (strPhoto) {
                _SetSlotPhoto(elSlot, strPhoto);
            }
        });
    }
    let _m_framing = null;
    let _m_frameJob = undefined;
    const FRAME_COMMIT_SEC = 0.4;
    function _FrameBar() { return _m_cp.FindChildInLayoutFile('id-pb-frame-bar'); }
    function _FrameSlider(strWhich) { return _m_cp.FindChildInLayoutFile('id-pb-frame-' + strWhich); }
    function OpenFrame(elSlot) {
        const place = _SlotPlace(elSlot);
        const strPhoto = _PhotoAt(place.page, place.slot);
        if (!strPhoto) {
            return;
        }
        CloseFrame();
        _m_framing = { page: place.page, slot: place.slot, frame: PetPhotoTag.FrameOf(strPhoto) };
        elSlot.SetHasClass('pb-slot--framing', true);
        elSlot.SetDraggable(false);
        _SetSliders(_m_framing.frame);
        _FrameBar().SetHasClass('pb-frame-bar--open', true);
        _PlaceFrameBar(elSlot);
        _EnablePanSliders();
    }
    PetBookPages.OpenFrame = OpenFrame;
    const FRAME_BAR_W = 260;
    const FRAME_BAR_H = 156;
    const FRAME_BAR_GAP = 10;
    function _PlaceFrameBar(elSlot) {
        const elBar = _FrameBar();
        const flScaleX = _m_cp.actualuiscale_x || 1;
        const flScaleY = _m_cp.actualuiscale_y || 1;
        const pos = elSlot.GetPositionWithinAncestor(_m_cp);
        const flSlotX = pos.x / flScaleX;
        const flSlotY = pos.y / flScaleY;
        const flSlotW = elSlot.actuallayoutwidth / flScaleX;
        const flSlotH = elSlot.actuallayoutheight / flScaleY;
        const flRoomW = _m_cp.actuallayoutwidth / flScaleX;
        const flRoomH = _m_cp.actuallayoutheight / flScaleY;
        const flRight = flSlotX + flSlotW + FRAME_BAR_GAP;
        const flX = (flRight + FRAME_BAR_W <= flRoomW) ? flRight : flSlotX - FRAME_BAR_W - FRAME_BAR_GAP;
        const flWanted = flSlotY + flSlotH / 2 - FRAME_BAR_H / 2;
        const flY = Math.max(FRAME_BAR_GAP, Math.min(flRoomH - FRAME_BAR_H - FRAME_BAR_GAP, flWanted));
        elBar.style.position = Math.max(FRAME_BAR_GAP, flX).toFixed(0) + 'px ' + flY.toFixed(0) + 'px 0px;';
    }
    function _SetSliders(frame) {
        const aRows = [
            { which: 'zoom', min: 100, max: PetPhotoTag.FRAME_ZOOM_MAX, value: frame.zoom },
            { which: 'x', min: 0, max: 100, value: frame.x },
            { which: 'y', min: 0, max: 100, value: frame.y },
        ];
        aRows.forEach(row => {
            const elSlider = _FrameSlider(row.which);
            if (!elSlider) {
                return;
            }
            elSlider.ClearPanelEvent('onvaluechanged');
            elSlider.min = row.min;
            elSlider.max = row.max;
            elSlider.value = row.value;
            elSlider.SetPanelEvent('onvaluechanged', _OnFrameChanged);
        });
    }
    function _EnablePanSliders() {
        if (!_m_framing) {
            return;
        }
        const strPhoto = _PhotoAt(_m_framing.page, _m_framing.slot);
        const elSlot = _SlotPanel(_m_framing.page, _m_framing.slot);
        if (!strPhoto || !elSlot) {
            return;
        }
        const flHole = _HoleAspect(elSlot);
        if (flHole <= 0) {
            return;
        }
        const size = _FrameSize(flHole, strPhoto, _m_framing.frame);
        _EnablePanRow('x', size.w > 100.5);
        _EnablePanRow('y', size.h > 100.5);
    }
    function _EnablePanRow(strWhich, bEnable) {
        const elSlider = _FrameSlider(strWhich);
        elSlider.enabled = bEnable;
        elSlider.GetParent().SetHasClass('pb-frame-bar__row--off', !bEnable);
    }
    function _ReadSliders() {
        return {
            x: _FrameSlider('x').value,
            y: _FrameSlider('y').value,
            zoom: _FrameSlider('zoom').value,
        };
    }
    function _OnFrameChanged() {
        if (!_m_framing) {
            return;
        }
        _m_framing.frame = _ReadSliders();
        _PreviewFrame();
        _EnablePanSliders();
        if (_m_frameJob !== undefined) {
            $.CancelScheduled(_m_frameJob);
        }
        _m_frameJob = $.Schedule(FRAME_COMMIT_SEC, _CommitFrame);
    }
    function _PreviewFrame() {
        if (!_m_framing) {
            return;
        }
        const strPhoto = _PhotoAt(_m_framing.page, _m_framing.slot);
        const elSlot = _SlotPanel(_m_framing.page, _m_framing.slot);
        if (!elSlot || !strPhoto) {
            return;
        }
        const elImage = _Image(elSlot, 'pb-slot__image');
        if (elImage) {
            _ApplyFrame(elSlot, elImage, strPhoto, _m_framing.frame);
        }
    }
    function _CommitFrame() {
        _m_frameJob = undefined;
        if (!_m_framing) {
            return;
        }
        const strPhoto = _PhotoAt(_m_framing.page, _m_framing.slot);
        if (!strPhoto) {
            return;
        }
        const strNew = PetPhotoTag.WithFrame(strPhoto, _m_framing.frame);
        if (strNew === strPhoto) {
            return;
        }
        if (!GameInterfaceAPI.RenameBookPhoto(_m_strBookKey, strPhoto, strNew)) {
            return;
        }
        _PhotosOn(_m_framing.page)[_m_framing.slot] = strNew;
        const elSlot = _SlotPanel(_m_framing.page, _m_framing.slot);
        const elImage = elSlot ? _Image(elSlot, 'pb-slot__image') : null;
        if (elImage) {
            elImage.SetImageFromFile(PetPhotoTag.PhotoUrl(_m_strBookKey, strNew));
        }
    }
    function ResetFrame() {
        if (!_m_framing) {
            return;
        }
        _SetSliders(PetPhotoTag.FRAME_DEFAULT);
        _OnFrameChanged();
    }
    PetBookPages.ResetFrame = ResetFrame;
    function CloseFrame() {
        if (_m_frameJob !== undefined) {
            $.CancelScheduled(_m_frameJob);
            _m_frameJob = undefined;
            _CommitFrame();
        }
        if (_m_framing) {
            const elSlot = _SlotPanel(_m_framing.page, _m_framing.slot);
            if (elSlot) {
                elSlot.SetHasClass('pb-slot--framing', false);
                elSlot.SetDraggable(true);
            }
        }
        _m_framing = null;
        _FrameBar().SetHasClass('pb-frame-bar--open', false);
    }
    PetBookPages.CloseFrame = CloseFrame;
    function _TakesAt(nPage, nSlot, strFileName) {
        const strRequire = _RequireAt(nPage, nSlot);
        return strRequire !== undefined && PetPhotoTag.Matches(strFileName, strRequire);
    }
    function _SlotPanel(nPage, nSlot) {
        const aFound = _m_cp.FindChildrenWithClassTraverse('pb-slot').filter(elSlot => {
            const place = _SlotPlace(elSlot);
            return place.page === nPage && place.slot === nSlot;
        });
        if (aFound.length > 1) {
        }
        return aFound.length > 0 ? aFound[0] : null;
    }
    function _CanDrop(elSlot) {
        const place = _SlotPlace(elSlot);
        if (!_TakesAt(place.page, place.slot, _m_strDragFile)) {
            return false;
        }
        const from = _m_dragFrom;
        if (!from) {
            return true;
        }
        const strDisplaced = _PhotoAt(place.page, place.slot);
        if (!strDisplaced || (from.page === place.page && from.slot === place.slot)) {
            return true;
        }
        return _TakesAt(from.page, from.slot, strDisplaced);
    }
    function _ClearDragOver(elSlot) {
        elSlot.SetHasClass('pb-slot--drag-over', false);
        elSlot.SetHasClass('pb-slot--drag-reject', false);
        _SetSlotHint(elSlot, '');
    }
    function _ApplyDragState() {
        const bDragging = _m_strDragFile !== '';
        _m_cp.FindChildrenWithClassTraverse('pb-slot').forEach(elSlot => {
            elSlot.SetHasClass('pb-slot--eligible', bDragging && _CanDrop(elSlot));
            _ClearDragOver(elSlot);
        });
    }
    function _OnLibraryDragStart(strFileName, drag) {
        _m_dragFrom = null;
        _BeginDrag(strFileName, drag);
    }
    function _BeginDrag(strFileName, drag) {
        const elDragImage = $.CreatePanel('Image', $.GetContextPanel(), '', { class: 'pb-drag-image', scaling: 'stretch-to-fit-y-preserve-aspect' });
        elDragImage.SetImageFromFile(PetPhotoTag.PhotoUrl(_m_strBookKey, strFileName));
        _m_strDragFile = strFileName;
        _m_elDragImage = elDragImage;
        _m_bDropHandled = false;
        drag.displayPanel = elDragImage;
        drag.offsetX = 40;
        drag.offsetY = 30;
        drag.removePositionBeforeDrop = false;
        _ApplyDragState();
        _ShowDragWillRemove(true);
        $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Photo.Pickup', 'MOUSE');
    }
    function _ShowDragWillRemove(bWillRemove) {
        if (_m_elDragImage && _m_elDragImage.IsValid()) {
            _m_elDragImage.SetHasClass('pb-drag-image--remove', bWillRemove && !!_m_dragFrom);
        }
    }
    function CancelDrag() {
        if (_m_elDragImage && _m_elDragImage.IsValid()) {
            _m_elDragImage.DeleteAsync(0.1);
        }
        _m_strDragFile = '';
        _m_dragFrom = null;
        _m_elDragImage = null;
    }
    PetBookPages.CancelDrag = CancelDrag;
    function _EndDrag() {
        const from = _m_dragFrom;
        const bHandled = _m_bDropHandled;
        CancelDrag();
        _ApplyDragState();
        PetPhotoLibrary.SetTakesInput(true);
        if (!bHandled) {
            _PlayRejected();
            if (from) {
                _RemovePhoto(from.page, from.slot);
            }
        }
    }
    function _RemovePhoto(nPage, nSlot) {
        const strFileName = _PhotoAt(nPage, nSlot);
        if (!strFileName) {
            return;
        }
        if (_MoveToLibrary(strFileName) === '') {
            const elSlot = _SlotPanel(nPage, nSlot);
            if (elSlot) {
                elSlot.TriggerClass('pb-slot--reject');
            }
            return;
        }
        _Reload(true);
    }
    function _PlayRejected() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Photo.Rejected', 'MOUSE');
    }
    function _DropPhoto(elSlot) {
        CloseFrame();
        _m_bDropHandled = true;
        const { page: nPage, slot: nSlot } = _SlotPlace(elSlot);
        if (nPage < 0 || nSlot < 0 || _m_strDragFile === '') {
            return;
        }
        if (!_CanDrop(elSlot)) {
            elSlot.TriggerClass('pb-slot--reject');
            _PlayRejected();
            return;
        }
        const from = _m_dragFrom;
        if (from && from.page === nPage && from.slot === nSlot) {
            return;
        }
        const strDisplaced = _PhotoAt(nPage, nSlot);
        let strParked = '';
        if (strDisplaced) {
            strParked = _MoveWithinBook(strDisplaced, nPage, PetPhotoTag.SLOT_UNPLACED);
            if (strParked === '') {
                _PlayRejected();
                return;
            }
        }
        const strPlaced = from ? _MoveWithinBook(_m_strDragFile, nPage, nSlot) :
            _MoveIntoBook(_m_strDragFile, nPage, nSlot);
        if (strPlaced === '') {
            _PlayRejected();
            if (strParked !== '') {
                _MoveWithinBook(strParked, nPage, nSlot);
            }
        }
        else {
            if (strParked !== '') {
                if (from) {
                    _MoveWithinBook(strParked, from.page, from.slot);
                }
                else {
                    _MoveToLibrary(strParked);
                }
            }
            _m_justDropped = { page: nPage, slot: nSlot };
            $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Photo.Accepted', 'MOUSE');
        }
        _Reload(!from);
    }
})(PetBookPages || (PetBookPages = {}));
