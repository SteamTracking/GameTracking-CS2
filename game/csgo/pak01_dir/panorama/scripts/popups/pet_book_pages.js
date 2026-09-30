"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/pet_photo_library.ts" />
/// <reference path="../popups/pet_photo_tag.ts" />
//
// Page authoring for the pet picture book. Kept out of popup_pet_book.ts, which owns the turn
// animation; the seam is ShownPages, FillPage and the refresh handed in at Init.
//
// Drag only - there is no selected hole and no click to place.
//
var PetBookPages;
(function (PetBookPages) {
    const _m_cp = $.GetContextPanel();
    //----------------------------------------------------------------------------------
    // The bird
    //----------------------------------------------------------------------------------
    // 'upgrade level' holds EChickenLifeStage.
    const STAGE_EGG = 0;
    const STAGE_CHICK = 1;
    const STAGE_ADOLESCENT = 2;
    const STAGE_ADULT = 3;
    // Localized here rather than where it is shown, because it goes into a dialog variable and those
    // substitute as they stand.
    const NAME_PLACEHOLDER = $.Localize('#pet_book_name_placeholder');
    // Read once at Init; the bird cannot grow up while the book is open. Filled in from a retired pet
    // when there is no live one, so this is what to display, not proof of ownership - see HasLivePet.
    let _m_pet = { strId: '', strName: NAME_PLACEHOLDER, nStage: STAGE_EGG, rtHatch: 0, bookdata: {} };
    // Which book is open, as the item id its folder is named with. '' when there is no book at all.
    // Everything that reads a photo goes through this, so a retired book reads like a current one.
    let _m_strBookKey = '';
    // Whether the open book's pet is still owned. Only a live pet can gain a photo.
    let _m_bHasLivePet = false;
    // The newest book left behind, for when there is no live pet to open one for. '' when there is
    // nothing on disk either.
    function _NewestBookOnDisk() {
        // Cloud keys, sorted oldest first by C++, so the newest book is the last entry. Scans the
        // clouded file system, so it is slow and Init asks once.
        const aBooks = GameInterfaceAPI.GetPetBookCloudFileKeys();
        if (aBooks.length <= 0) {
            return '';
        }
        const petKey = GameInterfaceAPI.UnpackPetBookCloudFile(aBooks[aBooks.length - 1]);
        if (!petKey) {
            return '';
        }
        // Nothing to display otherwise: the retired bird's name and hatch date are what the book prints.
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
            // 'deployment date' is the hatch date - see C_Chicken::GetGrowthPercent.
            rtHatch: _ItemAttr(strId, 'deployment date'),
            bookdata: {}, // bookdata can only be retrieved after the uncloud operation that mounts attached blob
        };
    }
    function _PetName(strId, nStage) {
        if (nStage <= STAGE_EGG)
            return NAME_PLACEHOLDER;
        // Each stage has a name "locked in" at the stage itself or carryover from previous stage
        // e.g. chick named "My Baby" grew up into pullet (even if you didn't explicitly name your pullet it has a carryover name "My Baby")
        // then later it grew up into an adult hen and you renamed it into "My Big Girl"
        // The expectation is that _PetName will return the following strings:
        // * nStage=1 => "My Baby"
        // * nStage=2 => "My Baby"
        // * nStage=3 => "My Big Girl"
        let nPreviousStage = nStage;
        while (nPreviousStage > 0) {
            const utf8name = InventoryAPI.GetItemAttributeValue(strId, '{bytestring}custom name attr'
                + ((nPreviousStage >= 2) ? ' ' + nPreviousStage : ''));
            if (utf8name)
                return utf8name; // explicit name for this stage
            --nPreviousStage; // try a previous stage
        }
        // But it's also possible that the player never bothered to name first or both first and second
        // life stages, so we want the first player-assigned name to retroactively name all the life stages
        let nNextStage = nStage + 1;
        while (nNextStage <= 3) {
            const utf8name = InventoryAPI.GetItemAttributeValue(strId, '{bytestring}custom name attr'
                + ((nNextStage >= 2) ? ' ' + nNextStage : ''));
            if (utf8name)
                return utf8name; // explicit name for this stage
            ++nNextStage; // try the next stage
        }
        // Looks this pet never had a name, so fallback to name for the species
        return InventoryAPI.GetItemNameUncustomized(strId);
    }
    // The book arrives with the egg, so the hatch is often still in the future.
    function _HatchDateText() {
        const rtHatch = _m_pet.rtHatch;
        if (!rtHatch) {
            return '';
        }
        // Misnamed, but it is the only date formatter exposed and it takes an RTime32.
        const strDate = InventoryAPI.LocalizeRentalDate(rtHatch);
        if (_m_pet.nStage !== STAGE_EGG) {
            return strDate;
        }
        // A variable rather than a built string: where the date sits in the sentence is the loc file's
        // to say. Localize takes the panel so it can read what was just set on it.
        _m_cp.SetDialogVariable('hatch_day', strDate);
        return $.Localize('#pet_book_hatch_due', _m_cp);
    }
    //----------------------------------------------------------------------------------
    // The bird, as the book's callers see it
    //----------------------------------------------------------------------------------
    // Both wanted by the booth when the book hands over to it - see PetBook.OpenPhotoBooth.
    function PetItemID() {
        return _m_pet.strId;
    }
    PetBookPages.PetItemID = PetItemID;
    function PetStage() {
        return _m_pet.nStage;
    }
    PetBookPages.PetStage = PetStage;
    // A retired book is still a book - everything in it can be moved, taken out and put back. The one
    // thing it cannot do is gain a photo, so the way to the booth is all that goes away.
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
    // Built from the shapes rather than listed again, so a shape cannot name a hole the page has not got.
    const FREE_HOLES = {};
    FREE_LAYOUTS.forEach(shape => shape.slots.forEach(nSlot => {
        FREE_HOLES[nSlot] = { hint: '#pet_book_hint_free' };
    }));
    // To add a layout: write the snippet, add a row here, put its name in a chapter below.
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
        // A term that lists values needs its words in a token of the hint's own, e.g.
        // pet_book_hint_adolescent_road_trip_1_stage; otherwise the values are just joined with 'or'.
        'teen-trip-1': { id: 6, snippet: 'page-teen-trip-set-1', holes: {
                0: { alsoRequires: 'stage:dust2|airport|inferno|train', hint: '#pet_book_hint_adolescent_road_trip_1' },
            } },
        'teen-trip-2': { id: 7, snippet: 'page-teen-trip-set-2', holes: {
                0: { alsoRequires: 'stage:mirage|nuke|cache|ancient', hint: '#pet_book_hint_adolescent_road_trip_2' },
            } },
        // The hats are listed out because a hole matches one value at a time; the hint gives the set
        // its own word.
        'birthday': { id: 8, snippet: 'page-birthday', holes: {
                0: { alsoRequires: 'activity:jump,headwear:party', hint: '#pet_book_hint_birthday' },
            } },
        // 7 was the free quad page, 9 the grown-up portrait and 12 the contact sheet; 7 has since been
        // taken again, 9 and 12 are free.
        'adult-perch': { id: 10, snippet: 'page-adult-perch', holes: {
                0: { alsoRequires: 'pose:1|3|6|7,filter:sepia', hint: '#pet_book_hint_adult_perch' },
            } },
        'adult-tricks': { id: 11, snippet: 'page-adult-tricks', holes: {
                0: { alsoRequires: 'activity:kick|fly', hint: '#pet_book_hint_adult_tricks' },
            } },
        'adult-close': { id: 13, snippet: 'page-adult-close', holes: {
                0: { alsoRequires: 'pose:4|5', hint: '#pet_book_hint_adult_close' },
            } },
        // Premade: nothing to place, shown once earned.
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
        // Earned as a pullet or a hen, so never behind the bird. The chip only appears once a page has.
        {
            name: 'brave', icon: 'pet_field_report.svg', stage: STAGE_ADULT,
            pages: ['brave-fire', 'brave-taser', 'brave-c4'],
        },
        // The free pages come before adult-close rather than after it, because that page is the one the
        // book closes on.
        {
            name: 'hen', icon: 'pet_hen.svg', stage: STAGE_ADULT,
            pages: ['adult-perch', 'adult-tricks', 'adult-close', 'free', 'free'],
        },
    ];
    // The whole book, in reading order. Page N is PAGES[ N - 1 ].
    const PAGES = [];
    SECTIONS.forEach(section => section.pages.forEach(strName => {
        // Annotated, not inferred: the wider type is what carries the slot index signature.
        const layout = LAYOUTS[strName];
        PAGES.push({ num: PAGES.length + 1, section: section, layout: layout });
    }));
    function _PageAt(nPageNum) {
        return PAGES[nPageNum - 1];
    }
    // What a hole takes: its chapter's growth, and whatever else it asks for.
    function _RequireOf(page, hole) {
        const strGrowth = PetPhotoTag.GrowthTerm(page.section.stage);
        return hole.alsoRequires === undefined ? strGrowth : strGrowth + ',' + hole.alsoRequires;
    }
    // undefined for a hole the layout has not got. Callers refuse that rather than fall back to '',
    // which every photo matches.
    function _RequireAt(nPageNum, nSlot) {
        const page = _PageAt(nPageNum);
        if (page === undefined) {
            return undefined;
        }
        const hole = page.layout.holes[nSlot];
        return hole === undefined ? undefined : _RequireOf(page, hole);
    }
    //----------------------------------------------------------------------------------
    // Which pages the book shows
    //----------------------------------------------------------------------------------
    // In reading order. Page numbers, not positions: the photos carry them, so leaving a page out
    // never renumbers another page's holes.
    let _m_aShown = [];
    function _IsBehindTheBird(page) {
        return _m_pet.nStage > page.section.stage;
    }
    // A page with a photo on it stays, whatever it asked for.
    function _IsUnlocked(page) {
        const strAchievement = page.layout.achievement;
        if (strAchievement === undefined || _HasPhotos(page)) {
            return true;
        }
        //DEVONLY{
        const bDebugUnlockAll = false;
        if (bDebugUnlockAll) {
            return true;
        }
        //}DEVONLY
        return _m_pet.strId !== '' && InventoryAPI.PetHasAchievement(_m_pet.strId, strAchievement);
    }
    function _CanFill(page, aPhotos) {
        return Object.values(page.layout.holes).some(hole => {
            const strRequire = _RequireOf(page, hole);
            return aPhotos.some(strFileName => PetPhotoTag.Matches(strFileName, strRequire));
        });
    }
    // The roll and the pages both: a photo already in the book can still be moved onto another page.
    function _AllPhotos() {
        if (_m_strBookKey === '') {
            return [];
        }
        return GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL')
            .concat(GameInterfaceAPI.FindFiles(PetPhotoTag.BookFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL'));
    }
    // Run once, at Init. A page that went has to stay gone for this sitting, or taking a photo off
    // one would slide the rest of the book sideways under the player.
    function _BuildShown() {
        const aPhotos = _AllPhotos();
        _m_aShown = PAGES
            .filter(page => _IsUnlocked(page) && (!_IsBehindTheBird(page) || _HasPhotos(page) || _CanFill(page, aPhotos)))
            .map(page => page.num);
        $.Msg('pet book: showing ' + _m_aShown.length + ' of ' + PAGES.length +
            ' pages at stage ' + _m_pet.nStage + '.\n');
    }
    // The turn code asks rather than keeping its own count, so there is one book, not two.
    function ShownPages() {
        return _m_aShown;
    }
    PetBookPages.ShownPages = ShownPages;
    // A chapter with no pages left is left out, so the nav bar cannot offer a chip that jumps nowhere.
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
    // 0 for a page that is not in the book, and no photo carries it - the ids in LAYOUTS start at one.
    function _LayoutIdForPage(nPageNum) {
        const page = _PageAt(nPageNum);
        return page === undefined ? 0 : page.layout.id;
    }
    //----------------------------------------------------------------------------------
    // Pages
    //----------------------------------------------------------------------------------
    // What is on the pages, by page number then by data-slot. Sparse: only filled holes appear.
    const _m_photos = {};
    function _PhotosOn(nPageNum) {
        if (!_m_photos[nPageNum]) {
            _m_photos[nPageNum] = {};
        }
        return _m_photos[nPageNum];
    }
    // '' for an empty hole and for a page that has never been built, which read the same to every caller.
    function _PhotoAt(nPage, nSlot) {
        const photos = _m_photos[nPage];
        return photos ? photos[nSlot] || '' : '';
    }
    function _HasPhotos(page) {
        const photos = _m_photos[page.num];
        return photos !== undefined && Object.keys(photos).length > 0;
    }
    // A hole's coordinates, off the panel FillPage wrote them onto. -1 for a panel that is not a hole.
    function _SlotPlace(elSlot) {
        return {
            page: elSlot.GetAttributeInt('data-page', -1),
            slot: elSlot.GetAttributeInt('data-slot', -1),
        };
    }
    //----------------------------------------------------------------------------------
    // The book folder
    //----------------------------------------------------------------------------------
    // There is no save step. The book folder is the state: the folder says which pet, and one file per
    // photo on a page says which page and hole. The spread is rebuilt from the folder, not from here.
    function _Load() {
        if (_m_strBookKey === '') {
            return;
        }
        GameInterfaceAPI.FindFiles(PetPhotoTag.BookFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL').forEach(strFileName => {
            const place = PetPhotoTag.PlaceOf(strFileName);
            if (!place || place.slot === PetPhotoTag.SLOT_UNPLACED) {
                $.Msg('pet book: ' + strFileName + ' is in the book but not on a page.\n');
                return;
            }
            // A different layout sits at that page now, so a page was inserted or re-authored. Left off.
            if (place.layout !== _LayoutIdForPage(place.page)) {
                $.Msg('pet book: ' + strFileName + ' was placed on another layout, leaving it off.\n');
                return;
            }
            const slots = _PhotosOn(place.page);
            const strSitting = slots[place.slot];
            if (!strSitting) {
                slots[place.slot] = strFileName;
                return;
            }
            // Two files can name one hole if a move only half finished. _Reconcile has already sent one of
            // them home, so this is only reached if that failed. Newest wins - capture times are fixed
            // width, so comparing them as strings orders them.
            const bNewer = PetPhotoTag.CaptureMS(strFileName) > PetPhotoTag.CaptureMS(strSitting);
            $.Msg('pet book: two photos on page ' + place.page + ' hole ' + place.slot + '\n');
            slots[place.slot] = bNewer ? strFileName : strSitting;
        });
    }
    // Read the folder again rather than keep a second copy in step. bRoll for anything that also put a
    // photo back in the camera roll; a move inside the book leaves the roll alone.
    function _Reload(bRoll) {
        Object.keys(_m_photos).forEach(strPageNum => { delete _m_photos[Number(strPageNum)]; });
        _Load();
        if (bRoll) {
            PetPhotoLibrary.LoadFromDisk(_m_strBookKey);
        }
        // Deferred - this runs from the handler of the very panel the refresh is about to delete.
        $.Schedule(0, _m_fnRefreshSpread);
    }
    // An empty camera roll means one of two things now that a photo is in one place or the other, and
    // only the book can tell them apart.
    function _EmptyLibraryText() {
        return PAGES.some(_HasPhotos) ? '#pet_photo_library_empty_in_book' : '#pet_photo_library_empty';
    }
    function _BookName(strFileName, nPage, nSlot) {
        return PetPhotoTag.BookName(strFileName, { page: nPage, layout: _LayoutIdForPage(nPage), slot: nSlot });
    }
    // All three hand back the photo's new name, or '' if it did not move. A photo is in the camera roll
    // or on a page and never both, so every one of these is one rename and a failure always means it
    // stayed exactly where it was.
    function _MoveIntoBook(strFileName, nPage, nSlot) {
        // GameInterfaceAPI.SetPetPhotoBookData writes bookdata back, and only for a live pet.
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
    // Makes the disk match the one rule the two folders have: a photo is in the camera roll or on a page,
    // never both and never neither. Run once as the book opens, which is where a book unpacked from
    // the cloud gets settled. Scoped to this pet's folders, like _Load.
    function _Reconcile() {
        if (_m_strBookKey === '') {
            return;
        }
        const aBook = GameInterfaceAPI.FindFiles(PetPhotoTag.BookFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL');
        // The book is the record - it is the half that is backed up - so where both folders hold one photo
        // the camera roll copy is the one that goes. First, because a photo cannot go home to a name that
        // is already taken.
        const inBook = {};
        aBook.forEach(strFileName => { inBook[PetPhotoTag.CaptureMS(strFileName)] = true; });
        GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(_m_strBookKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL').forEach(strFileName => {
            if (inBook[PetPhotoTag.CaptureMS(strFileName)]) {
                $.Msg('pet book: ' + strFileName + ' is on a page too, dropping the camera roll copy.\n');
                GameInterfaceAPI.DeletePetPhoto(_m_strBookKey, strFileName);
            }
        });
        // Then the book's own. Newest first, so which of two files keeps a hole is the same answer every
        // time rather than whatever order the folder came back in.
        const byHole = {};
        const byPhoto = {};
        const aHome = [];
        aBook.sort().reverse().forEach(strFileName => {
            const place = PetPhotoTag.PlaceOf(strFileName);
            const strMS = PetPhotoTag.CaptureMS(strFileName);
            // A swap that only half finished parks a photo in the book with no page of its own.
            if (!place || place.slot === PetPhotoTag.SLOT_UNPLACED) {
                aHome.push(strFileName);
                return;
            }
            // Not the layout that is at its page any more, so a page was inserted or re-authored. _Load
            // leaves it off the page; this is what keeps it from then sitting in the folder unreachable.
            if (place.layout !== _LayoutIdForPage(place.page)) {
                aHome.push(strFileName);
                return;
            }
            // A hole already taken, or this photo already sitting somewhere else in the book. A cloud unpack
            // makes both, because it only skips a file whose name it matches exactly.
            const strKey = place.page + '_' + place.slot;
            if (byHole[strKey] || byPhoto[strMS]) {
                aHome.push(strFileName);
                return;
            }
            byHole[strKey] = true;
            byPhoto[strMS] = true;
        });
        // Sent home rather than deleted, so a photo the book cannot show is one the player still has.
        aHome.forEach(strFileName => {
            $.Msg('pet book: ' + strFileName + ' cannot sit where its name says, sending it home.\n');
            _MoveToLibrary(strFileName);
        });
    }
    let _m_strDragFile = '';
    // Which hole the photo in the air came off, or null if it came out of the library. This is the
    // whole difference between placing a photo and moving one.
    let _m_dragFrom = null;
    // Set by any hole that is dropped on, INCLUDING one that refuses the photo. Read at DragEnd to tell
    // "let go over a hole" apart from "let go over nothing".
    let _m_bDropHandled = false;
    // Kept so the drag image can be told it is about to remove rather than place.
    let _m_elDragImage = null;
    let _m_justDropped = null;
    let _m_fnRefreshSpread = () => { };
    function Init(fnRefreshSpread) {
        _m_fnRefreshSpread = fnRefreshSpread;
        // A book asked for by name, as the cloud key its file carries. The player card sends one to reach
        // a book whose bird is gone - see ContextmenuPlayerCard. Unpacking it is what says which pet it
        // belonged to, and a book already unpacked this session costs nothing the second time.
        const strAskedFor = _m_cp.GetAttributeString('bookkey', '');
        const strAskedPet = strAskedFor === '' ? '' : GameInterfaceAPI.UnpackPetBookCloudFile(strAskedFor);
        _m_pet = _ReadPet();
        // Caught before the branch below can overwrite _m_pet with a retired pet. A book asked for that is
        // not the living pet's own reads as retired even while a bird is alive: the book open is not hers.
        _m_bHasLivePet = _m_pet.strId !== '' && (strAskedPet === '' || strAskedPet === _m_pet.strId);
        if (_m_bHasLivePet) {
            GameInterfaceAPI.UnpackPetBookCloudFile(_m_pet.strId);
            // After the uncloud, so a later uncloud cannot clobber a name just changed.
            GameInterfaceAPI.PreparePetPhoto(_m_pet.strId, '');
            _m_strBookKey = _m_pet.strId;
        }
        else if (strAskedPet !== '') {
            // The bird the asked-for book belonged to: its name and hatch date are what that book prints.
            _m_pet = _ReadPet(strAskedPet);
            _m_strBookKey = strAskedPet;
        }
        else {
            _m_strBookKey = _NewestBookOnDisk();
        }
        // Attached on top of the cloud book, so only readable once it is unpacked.
        if (_m_strBookKey)
            _m_pet.bookdata = GameInterfaceAPI.GetPetPhotoBookData(_m_strBookKey);
        $.Msg('pet book: opened ' + _m_strBookKey + ' for pet ' + _m_pet.strId + ' "' + _m_pet.strName +
            '", stage ' + _m_pet.nStage + ', hatch ' + _m_pet.rtHatch + ', cover ' + _m_pet.bookdata.cover_design + '.\n');
        // On the popup, not on each page: dialog variables resolve up the panel tree, so every page picks
        // these up - including the cover, which the turn code builds without going through FillPage.
        _m_cp.SetDialogVariable('pet_name', _m_pet.strName);
        // Bind names for all 3 stages of life - that way pages can refer to "My Little Baby" when it hatched and was called baby
        // and later pages can have "My Ugly Pullet" if that's the name you gave to your teen chicken after it evolved
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
        // The open book's roll, not the living pet's: a photo taken off a retired page has to land
        // somewhere it can still be seen and put back.
        PetPhotoLibrary.LoadFromDisk(_m_strBookKey);
        _m_cp.FindChildInLayoutFile('id-pb-booth-btn').visible = HasLivePet();
        _Load();
        // After _Load, because a page with a photo on it is kept whatever its chapter.
        _BuildShown();
    }
    PetBookPages.Init = Init;
    function _Image(elParent, strClass) {
        const aImages = elParent.FindChildrenWithClassTraverse(strClass);
        return aImages.length > 0 ? aImages[0] : null;
    }
    // A hint names its terms as dialog variables, and each one gets the words for that term wrapped in a
    // span. The words are the value's own unless the hint has a token for that term, e.g.
    // pet_book_hint_chick_feet_zoom. '' for strAgainst leaves every term reading as met.
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
        // The token, not the localized string: the label keeps the localization string itself and
        // re-resolves it whenever one of these variables is set.
        elLabel.text = hole.hint;
    }
    //----------------------------------------------------------------------------------
    // Free pages - the ones the player shapes
    //----------------------------------------------------------------------------------
    // What has been picked for a page with no photo on it to say so, and only for this sitting: the
    // book folder is the state, and an empty page has nowhere to write a choice into. Without this a
    // pick would appear to do nothing, because picking clears the page and an empty page falls back to
    // the first shape.
    const _m_freeChoice = {};
    function _FreeLayoutNamed(strName) {
        return FREE_LAYOUTS.find(layout => layout.name === strName);
    }
    // Which shape a free page is wearing. A hole with a photo in it settles it, because a photo's hole
    // belongs to exactly one shape.
    function _FreeLayoutOf(nPageNum) {
        const slots = _PhotosOn(nPageNum);
        const worn = FREE_LAYOUTS.find(layout => layout.slots.some(nSlot => slots[nSlot] !== undefined));
        return worn || _FreeLayoutNamed(_m_freeChoice[nPageNum]) || FREE_LAYOUTS[0];
    }
    // Picking a shape clears the page. A photo's hole belongs to the shape it was placed under, so
    // there is no hole on the new one for it to be in; they go back to the camera roll, not away.
    function _ChooseLayout(elPage, nPageNum, strName) {
        // It arrives from a button this file made, but the table is what says what a shape is.
        if (!_FreeLayoutNamed(strName)) {
            return;
        }
        _m_freeChoice[nPageNum] = strName;
        const slots = _PhotosOn(nPageNum);
        const aOn = Object.keys(slots).map(Number);
        // Nothing to move, so nothing to rebuild: every shape's holes are already in the page and only
        // which of them is up has changed. Taking the spread down for this would hand back a fresh set
        // of buttons a frame later, which is what made the ones the cursor was not on flash.
        if (aOn.length === 0) {
            _ShowFreeLayout(elPage, nPageNum);
            return;
        }
        // A move that fails leaves its photo in its hole, so the page still wears the shape it had and
        // shows what is still on it. Nothing ends up somewhere the book cannot reach.
        aOn.forEach(nSlot => { _MoveToLibrary(slots[nSlot]); });
        _Reload(true);
    }
    // Unique across the book, so it stays one page's button even if the ids are looked up from above.
    function _FreeBtnId(nPageNum, strName) {
        return 'id-pb-free-' + nPageNum + '-' + strName;
    }
    // Which shape is up. Everything a pick changes is in here, and none of it deletes a panel, so it
    // can run from the handler of a button that is inside the page it is rearranging.
    function _ShowFreeLayout(elPage, nPageNum) {
        const worn = _FreeLayoutOf(nPageNum);
        // Collapsed rather than faded: a hole at zero opacity would still take a photo.
        elPage.FindChildrenWithClassTraverse('pb-free-group').forEach(elGroup => {
            elGroup.visible = elGroup.GetAttributeString('data-free', '') === worn.name;
        });
        // Only ever set on, like every other radio in these screens - the group turns the rest off.
        // Setting one off by hand asks the group what is on while nothing is.
        const elBtn = _m_cp.FindChildTraverse(_FreeBtnId(nPageNum, worn.name));
        if (elBtn) {
            elBtn.checked = true;
        }
    }
    // Builds the strip. Called once per fill, because the page's panels are rebuilt rather than reused.
    function _DressFreePage(elPage, nPageNum) {
        // By class, not by id: the snippet is loaded into both pages of a spread, so the same id would
        // be in the tree twice. FindChildrenWithClass is scoped to the page it is asked of.
        const elStrip = elPage.FindChildrenWithClassTraverse('pb-free-strip')[0];
        if (!elStrip) {
            return;
        }
        FREE_LAYOUTS.forEach(layout => {
            const elBtn = $.CreatePanel('RadioButton', elStrip, _FreeBtnId(nPageNum, layout.name), {
                class: 'pb-free-btn',
                // Grouped per page, because both pages of a spread can be free ones.
                group: 'pb-free-' + nPageNum
            });
            // Found by the shape's own name, so a new shape needs an icon and nothing here.
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
    // The turn code rebuilds a page every time it comes on screen, so everything is read back out of
    // the model here rather than assumed to have survived the last turn.
    function FillPage(elPage, nPageNum) {
        const page = _PageAt(nPageNum);
        if (page === undefined) {
            $.Msg('pet book: there is no page ' + nPageNum + '.\n');
            return;
        }
        const photos = _PhotosOn(nPageNum);
        elPage.BLoadLayoutSnippet(page.layout.snippet);
        // The rest are on the popup, see Init.
        elPage.SetDialogVariableInt('num', nPageNum);
        // Before the holes are walked, so what it puts away is already away by the time they are read.
        if (page.layout === LAYOUTS.free) {
            _DressFreePage(elPage, nPageNum);
        }
        // Which holes this page actually has, to catch a photo whose hole has since gone.
        const aClaimed = [];
        // Do NOT identify a hole by its position here. FindChildrenWithClassTraverse walks a global
        // registry in creation order, not child order - see CUIPanel::GetDescendentPanelsForSymbol.
        elPage.FindChildrenWithClassTraverse('pb-slot').forEach(elSlot => {
            const nSlot = elSlot.GetAttributeInt('data-slot', -1);
            if (nSlot < 0) {
                return;
            }
            _BuildHole(elSlot);
            aClaimed.push(nSlot);
            // It will take nothing at all - see _RequireAt.
            if (page.layout.holes[nSlot] === undefined) {
                $.Msg('pet book: ' + page.layout.snippet + ' has a hole ' + nSlot + ' its layout does not list.\n');
            }
            // Both coordinates live on the panel, so a slot cannot end up acting for a page it left.
            elSlot.SetAttributeInt('data-page', nPageNum);
            const strPhoto = photos[nSlot];
            elSlot.SetHasClass('pb-slot--filled', !!strPhoto);
            // Its plain words. Written here so the same call can put them back after a drag picked a term out.
            _SetSlotHint(elSlot, '');
            if (strPhoto) {
                _SetSlotPhoto(elSlot, strPhoto);
            }
            // A hole with a photo can be picked up - one gesture for both moving a photo and removing it.
            elSlot.SetDraggable(!!strPhoto);
            // Safe per fill, unlike the library rows: these panels are destroyed and rebuilt, not recycled.
            if (strPhoto) {
                $.RegisterEventHandler('DragStart', elSlot, (el, drag) => {
                    _m_dragFrom = _SlotPlace(elSlot);
                    _BeginDrag(strPhoto, drag);
                });
                $.RegisterEventHandler('DragEnd', elSlot, _EndDrag);
            }
            $.RegisterEventHandler('DragEnter', elSlot, () => {
                // DragEnter is handed no payload, hence _m_strDragFile. Answered while the button is down.
                const bTakes = _CanDrop(elSlot);
                elSlot.SetHasClass('pb-slot--drag-over', bTakes);
                elSlot.SetHasClass('pb-slot--drag-reject', !bTakes);
                // This hole's own terms, not _CanDrop's answer: a swap is also refused when the photo here
                // would not fit the hole it goes back to, which is nothing to do with what this hole asks.
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
            // The page it was dropped on is gone by now, replaced by the refresh, so the drop is animated
            // on the panel that took its place.
            if (_m_justDropped && _m_justDropped.page === nPageNum && _m_justDropped.slot === nSlot) {
                _m_justDropped = null;
                elSlot.TriggerClass('pb-slot--dropped');
            }
        });
        // A photo whose hole this page no longer has: the layout was re-authored without a new id, see
        // Layout_t. Dropped, or the page would dress itself over empty holes and the file be unreachable.
        Object.keys(photos).forEach(strSlot => {
            const nSlot = Number(strSlot);
            if (aClaimed.indexOf(nSlot) >= 0) {
                return;
            }
            $.Msg('pet book: ' + photos[nSlot] + ' is in hole ' + nSlot + ', which page ' +
                nPageNum + ' does not have. Leaving it off.\n');
            delete photos[nSlot];
        });
        // Everything that is not a hole stays faint until the page has a photo on it. No holes, nothing to wait for.
        elPage.SetHasClass('pb-dressed', Object.keys(photos).length > 0 || Object.keys(page.layout.holes).length === 0);
        _FillParagraph(elPage, nPageNum);
        // Matters on the drop: the refresh is scheduled from inside the drag handler, so it can run
        // before DragEnd has cleared the photo in flight.
        _ApplyDragState();
    }
    PetBookPages.FillPage = FillPage;
    // The inside of a hole. The same for every hole, so the layout only says where one is and what
    // shape it wears - see popup_pet_book.xml. Built per fill: a page's panels are fresh each time it
    // comes on screen, so there is never one to add to.
    function _BuildHole(elSlot) {
        const elClip = $.CreatePanel('Panel', elSlot, '', { class: 'pb-slot__clip' });
        $.CreatePanel('Image', elClip, '', { class: 'pb-slot__image', scaling: 'cover' });
        $.CreatePanel('Label', elSlot, '', { class: 'pb-slot__hint', html: 'true' });
    }
    // Every label on the page that names variants shows the one its photo picks, so a page reads the
    // same every open with nothing written down. A label that names none keeps the string it has.
    // A page can carry several sets; they all pick off the same photo, so they agree.
    function _FillParagraph(elPage, nPageNum) {
        // The capture time is arbitrary down to the millisecond and is the one part of a name that
        // never changes, so it is what picks. Nothing placed yet reads as the first one.
        const strFileName = _PhotosOn(nPageNum)[0];
        const nCaptureMS = strFileName ? Number(PetPhotoTag.CaptureMS(strFileName)) : 0;
        elPage.FindChildrenWithClassTraverse('pb-page__paragraph').forEach(elLabel => {
            const strToken = elLabel.GetAttributeString('data-paragraph', '');
            const nCount = elLabel.GetAttributeInt('data-variants', 0);
            if (strToken === '' || nCount <= 0) {
                return;
            }
            // The label, so a line holding {s:pet_name} resolves against the tree it sits in.
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
    // Only filled holes get one, and a hole is rebuilt whenever its page comes round, so this is per fill.
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
    // A hole's shape is fixed by css per layout, so it only needs measuring once. A turn rebuilds panels
    // up to five times and a fresh one measures zero, so without this a framed photo snaps to its default.
    const _m_holeAspect = {};
    function _HoleAspect(elSlot) {
        const place = _SlotPlace(elSlot);
        const strKey = _LayoutIdForPage(place.page) + ':' + place.slot;
        if (_m_holeAspect[strKey] > 0) {
            return _m_holeAspect[strKey];
        }
        // Divided out because the reported size is scaled and the shape is not.
        const flW = elSlot.actuallayoutwidth / (elSlot.actualuiscale_x || 1);
        const flH = elSlot.actuallayoutheight / (elSlot.actualuiscale_y || 1);
        if (flW <= 0 || flH <= 0) {
            return 0;
        }
        _m_holeAspect[strKey] = flW / flH;
        return _m_holeAspect[strKey];
    }
    // How big the photo has to be, as percentages of its hole. Covering pins the short axis at 100 and the
    // other overhangs; zoom pushes both past that. Whatever is over 100 is what there is to pan.
    function _FrameSize(flHole, strFileName, frame) {
        const flPhoto = PetPhotoTag.Aspect(strFileName);
        const flZoom = frame.zoom / 100;
        return {
            w: (flPhoto >= flHole ? 100 * flPhoto / flHole : 100) * flZoom,
            h: (flPhoto >= flHole ? 100 : 100 * flHole / flPhoto) * flZoom,
        };
    }
    // Which part of a photo its hole shows. Sizes and offsets the image panel; pb-slot__clip hides the
    // rest. Not css because an empty hole has an image panel too, and sizing that draws a box in the hole.
    function _ApplyFrame(elSlot, elImage, strFileName, frame) {
        // Covering exactly is what scaling="cover" already does, so the untouched case measures nothing.
        if (PetPhotoTag.IsDefaultFrame(frame)) {
            elImage.style.width = '100%;';
            elImage.style.height = '100%;';
            elImage.style.transform = 'none;';
            elImage.style.opacity = '1;';
            return;
        }
        const flHole = _HoleAspect(elSlot);
        if (flHole <= 0) {
            // Held back rather than shown unframed for a frame and then snapping into place.
            elImage.style.opacity = '0;';
            _DeferFrame(elSlot);
            return;
        }
        const { w: flW, h: flH } = _FrameSize(flHole, strFileName, frame);
        elImage.style.width = flW.toFixed(2) + '%;';
        elImage.style.height = flH.toFixed(2) + '%;';
        // The image is centred, so half the overhang is hidden on each side and sliding it by half moves
        // an edge into view. A percentage translate is a share of the parent, so these are hole percents
        // like the sizes above - taking them as image percents falls short of the edge by the zoom.
        const flX = (flW - 100) * (0.5 - frame.x / 100);
        const flY = (flH - 100) * (0.5 - frame.y / 100);
        elImage.style.transform = 'translateX( ' + flX.toFixed(2) + '% ) translateY( ' + flY.toFixed(2) + '% );';
        elImage.style.opacity = '1;';
    }
    const FRAME_MEASURE_TRIES = 8;
    // Only the first sighting of a hole shape gets here - after that _HoleAspect knows it. Reads the photo
    // back off the page rather than capturing it, so a deferred pass cannot frame one that has moved.
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
    //----------------------------------------------------------------------------------
    // Framing
    //----------------------------------------------------------------------------------
    // Which hole is being framed, by its coordinates rather than its panel: a page rebuild replaces the
    // panels and the session should survive that. The frame is carried here because the write is delayed.
    let _m_framing = null;
    let _m_frameJob = undefined;
    // Long enough that dragging a slider does not rename per tick, short enough that clicking away keeps it.
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
        // A drag would take the photo out from under the sliders adjusting it.
        elSlot.SetDraggable(false);
        _SetSliders(_m_framing.frame);
        _FrameBar().SetHasClass('pb-frame-bar--open', true);
        _PlaceFrameBar(elSlot);
        _EnablePanSliders();
    }
    PetBookPages.OpenFrame = OpenFrame;
    // Kept in step with .pb-frame-bar, which has to be placed before it can be measured.
    const FRAME_BAR_W = 260;
    const FRAME_BAR_H = 156;
    const FRAME_BAR_GAP = 10;
    // Beside the photo and never over it: framing something you cannot see is the one thing this must not
    // do. Right of the hole if there is room, otherwise left, pulled back inside the popup either way.
    function _PlaceFrameBar(elSlot) {
        const elBar = _FrameBar();
        const flScaleX = _m_cp.actualuiscale_x || 1;
        const flScaleY = _m_cp.actualuiscale_y || 1;
        // Reported in screen units, where everything written back is in layout units.
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
            // Detached while the value is written: the handler from the last open is still on it, and
            // writing a value reports a change, which would rename for a frame nobody asked for.
            elSlider.ClearPanelEvent('onvaluechanged');
            elSlider.min = row.min;
            elSlider.max = row.max;
            elSlider.value = row.value;
            elSlider.SetPanelEvent('onvaluechanged', _OnFrameChanged);
        });
    }
    // An axis can only be panned where the photo overhangs its hole. At zoom 100 only the long axis does,
    // so the other slider would move and change nothing, which reads as broken.
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
        // A hair over 100, so a photo the same shape as its hole offers no travel at all.
        const size = _FrameSize(flHole, strPhoto, _m_framing.frame);
        _EnablePanRow('x', size.w > 100.5);
        _EnablePanRow('y', size.h > 100.5);
    }
    // The icon sits beside its slider and Panorama has no sibling selector, so the row dims the icon.
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
    // Redraws now and writes later: the name on disk is the frame, so committing is a rename.
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
    // The photo keeps its pixels and changes its name. Not a _Reload: that rebuilds the page being adjusted.
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
            $.Msg('pet book: could not reframe ' + strPhoto + '.\n');
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
    // Writes whatever is pending before letting go, so clicking Done never loses the last nudge.
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
        // One hole, one panel. More than one means a page built twice, and framing writes where nobody looks.
        if (aFound.length > 1) {
            $.Msg('pet book: page ' + nPage + ' hole ' + nSlot + ' has ' + aFound.length + ' panels.\n');
        }
        return aFound.length > 0 ? aFound[0] : null;
    }
    // Both ends of a swap have to be legal: the photo in the air has to fit the hole it is going to,
    // and whatever is already there has to fit the hole it would be sent back to.
    function _CanDrop(elSlot) {
        const place = _SlotPlace(elSlot);
        if (!_TakesAt(place.page, place.slot, _m_strDragFile)) {
            return false;
        }
        const from = _m_dragFrom;
        if (!from) {
            return true; // out of the library, so nothing is going the other way
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
    //----------------------------------------------------------------------------------
    // Dragging
    //----------------------------------------------------------------------------------
    // Picking a photo up is what shows where it can go, and with no click to place it is the only cue.
    function _ApplyDragState() {
        const bDragging = _m_strDragFile !== '';
        _m_cp.FindChildrenWithClassTraverse('pb-slot').forEach(elSlot => {
            elSlot.SetHasClass('pb-slot--eligible', bDragging && _CanDrop(elSlot));
            _ClearDragOver(elSlot);
        });
    }
    // Handed to the library as fnOnDragStart. Out of the library means there is no hole to vacate.
    function _OnLibraryDragStart(strFileName, drag) {
        _m_dragFrom = null;
        _BeginDrag(strFileName, drag);
    }
    function _BeginDrag(strFileName, drag) {
        // Parented to the context panel rather than the panel it came from - a drag image parented to
        // its own source ends up stuck in odd places, see OnDragStart in loadout_grid.ts.
        const elDragImage = $.CreatePanel('Image', $.GetContextPanel(), '', { class: 'pb-drag-image', scaling: 'stretch-to-fit-y-preserve-aspect' });
        elDragImage.SetImageFromFile(PetPhotoTag.PhotoUrl(_m_strBookKey, strFileName));
        // The payload is held here because DragEnter is handed neither it nor the drag image.
        _m_strDragFile = strFileName;
        _m_elDragImage = elDragImage;
        _m_bDropHandled = false;
        drag.displayPanel = elDragImage;
        drag.offsetX = 40;
        drag.offsetY = 30;
        drag.removePositionBeforeDrop = false;
        _ApplyDragState();
        // Starts life outside every hole, so a photo off a page reads as leaving from the off.
        _ShowDragWillRemove(true);
        // Every drag comes through here, off a page or out of the library.
        $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Photo.Pickup', 'MOUSE');
    }
    // Letting go off a hole takes the photo off the page, so say so before release. Never for a library drag.
    function _ShowDragWillRemove(bWillRemove) {
        if (_m_elDragImage && _m_elDragImage.IsValid()) {
            _m_elDragImage.SetHasClass('pb-drag-image--remove', bWillRemove && !!_m_dragFrom);
        }
    }
    // The drag system makes the drag image a top level panel, so closing the book does not take it with
    // it. Throws away the photo in flight rather than treating it as let go.
    function CancelDrag() {
        if (_m_elDragImage && _m_elDragImage.IsValid()) {
            _m_elDragImage.DeleteAsync(0.1);
        }
        _m_strDragFile = '';
        _m_dragFrom = null;
        _m_elDragImage = null;
    }
    PetBookPages.CancelDrag = CancelDrag;
    // Both ends of every drag: a page's own DragEnd, and the library's through fnOnDragEnd.
    function _EndDrag() {
        const from = _m_dragFrom;
        const bHandled = _m_bDropHandled;
        CancelDrag();
        _ApplyDragState();
        // The library turns its own input back on; this covers a drag that started on a page.
        PetPhotoLibrary.SetTakesInput(true);
        // DragDrop is dispatched before DragEnd and only when something was under the cursor, so nothing
        // having handled it means empty space - see CUIWindowInput::CancelDrag. The library counts as nothing.
        if (!bHandled) {
            _PlayRejected();
            // Off a page the photo goes home to the list; out of the library it never left it.
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
            $.Msg('pet book: could not take ' + strFileName + ' off the page.\n');
            // It stayed on its page, so the hole says no in the same language a refused drop does.
            const elSlot = _SlotPanel(nPage, nSlot);
            if (elSlot) {
                elSlot.TriggerClass('pb-slot--reject');
            }
            return;
        }
        _Reload(true);
    }
    // Immediate on release for every rejection; any delay belongs in the soundevent.
    function _PlayRejected() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Photo.Rejected', 'MOUSE');
    }
    function _DropPhoto(elSlot) {
        // A drop rebuilds the hole it lands in, so sliders open on it point at the photo that just left.
        CloseFrame();
        // Marked before anything can refuse: a drop turned down still counts as handled, or it would remove.
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
            return; // put back where it was picked up from, so nothing changed
        }
        const strDisplaced = _PhotoAt(nPage, nSlot);
        let strParked = '';
        // Parked, never emptied: the hole has to be free before anything can be renamed into it, and a
        // parked photo is one rename from being back where it was if the drop then fails.
        if (strDisplaced) {
            strParked = _MoveWithinBook(strDisplaced, nPage, PetPhotoTag.SLOT_UNPLACED);
            if (strParked === '') {
                $.Msg('pet book: could not empty page ' + nPage + ' hole ' + nSlot + ', nothing moved.\n');
                _PlayRejected();
                return;
            }
        }
        const strPlaced = from ? _MoveWithinBook(_m_strDragFile, nPage, nSlot) :
            _MoveIntoBook(_m_strDragFile, nPage, nSlot);
        if (strPlaced === '') {
            $.Msg('pet book: could not put ' + _m_strDragFile + ' on page ' + nPage + '.\n');
            _PlayRejected();
            // Put back whatever was moved out of the way, so a drop that fails changes nothing.
            if (strParked !== '') {
                _MoveWithinBook(strParked, nPage, nSlot);
            }
        }
        else {
            // Where the photo that was here goes: back to the hole the dragged one came off, or home to the
            // camera roll when the dragged one came out of it. A failure leaves it parked and _Reconcile
            // sends it home next open, so it is never lost either way.
            if (strParked !== '') {
                if (from) {
                    _MoveWithinBook(strParked, from.page, from.slot);
                }
                else {
                    _MoveToLibrary(strParked);
                }
            }
            // Picked up by the rebuild, which is where the drop animation actually plays.
            _m_justDropped = { page: nPage, slot: nSlot };
            $.DispatchEvent('CSGOPlaySoundEffect', 'Chicken.Photo.Accepted', 'MOUSE');
        }
        _Reload(!from);
    }
})(PetBookPages || (PetBookPages = {}));
