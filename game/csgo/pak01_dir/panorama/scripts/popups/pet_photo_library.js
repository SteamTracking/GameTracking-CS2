"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/pet_photo_tag.ts" />
//
// The photo library, shared by the photo booth and the picture book. BLoadLayout
// pet_photo_library.xml into an empty panel, then call Init with what that host wants switched on.
//
// The two are never open at the same time - the booth closes itself to open the book and back - so the
// state below can be module level.
//
var PetPhotoLibrary;
(function (PetPhotoLibrary) {
    // The list only builds panels for the rows on screen, so this array is the model and the panels are
    // a view onto it.
    let _m_aFiles = [];
    let _m_elList = null;
    let _m_elEmpty = null;
    let _m_opts = {};
    function Init(elRoot, opts) {
        _m_opts = opts;
        // FindChildInLayoutFile is scoped to the layout that declared the panel, so the host cannot
        // reach this and the reference has to be kept here.
        _m_elList = elRoot.FindChildTraverse('id-photo-library-list');
        _m_elEmpty = elRoot.FindChildTraverse('id-photo-library-empty');
        _m_elList.SetLoadListItemFunction((parent, nPanelIdx, reusePanel) => {
            let elItem = reusePanel;
            if (!elItem || !elItem.IsValid()) {
                elItem = _BuildRow();
            }
            _PointRowAt(elItem, _m_aFiles[nPanelIdx]);
            return elItem;
        });
    }
    PetPhotoLibrary.Init = Init;
    function _BuildRow() {
        // A Button when it has to take a click for the drag to start from; the booth's rows were Panels
        // and stay that way, so its hover and hit testing are unchanged.
        const elItem = $.CreatePanel(_m_opts.bDraggable ? 'Button' : 'Panel', _m_elList, '', { class: 'photo-library__item' });
        $.CreatePanel('Image', elItem, '', { scaling: 'stretch-to-fit-y-preserve-aspect', class: 'photo-library__image' });
        if (_m_opts.bDeletable) {
            const elDelete = $.CreatePanel('Button', elItem, '', { class: 'photo-library__delete-btn' });
            $.CreatePanel('Image', elDelete, '', { src: 'file://{images}/icons/ui/trash.svg', textureheight: '16', scaling: 'stretch-to-fit-preserve-aspect' });
        }
        if (_m_opts.bDraggable) {
            // Registered once per panel, NOT per load - RegisterEventHandler adds rather than replaces,
            // and rows are recycled as the list scrolls. The name is read off data-file at drag time.
            $.RegisterEventHandler('DragStart', elItem, _OnDragStart);
            $.RegisterEventHandler('DragEnd', elItem, _OnDragEnd);
        }
        return elItem;
    }
    // Rows are recycled, so everything a row knows about its photo is re-pointed on every load.
    function _PointRowAt(elItem, strFileName) {
        elItem.SetAttributeString('data-file', strFileName);
        const aImages = elItem.FindChildrenWithClassTraverse('photo-library__image');
        if (aImages.length > 0) {
            aImages[0].SetImageFromFile(PetPhotoTag.PhotoUrl(_m_strPetKey, strFileName));
        }
        // SetPanelEvent replaces rather than accumulates, so these are safe per load.
        elItem.SetPanelEvent('onactivate', () => { ShowViewer(strFileName); });
        elItem.SetPanelEvent('onmouseover', () => { _ShowSettings(elItem, strFileName); });
        elItem.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        if (_m_opts.bDeletable) {
            const aDelete = elItem.FindChildrenWithClassTraverse('photo-library__delete-btn');
            if (aDelete.length > 0) {
                aDelete[0].SetPanelEvent('onactivate', () => { _ConfirmDelete(strFileName); });
            }
        }
        // Rows are recycled, so this is re-set per load rather than once in _BuildRow. The flag and the
        // class go together - the class is what makes a row nudge on hover, and that nudge is all that
        // says a row can be picked up.
        elItem.SetDraggable(!!_m_opts.bDraggable);
        elItem.SetHasClass('photo-library__item--draggable', !!_m_opts.bDraggable);
    }
    //----------------------------------------------------------------------------------
    // The model
    //----------------------------------------------------------------------------------
    // Which pet's roll is on screen. Its own folder, so this reads one bird and never another.
    let _m_strPetKey = '';
    function LoadFromDisk(strPetKey) {
        _m_strPetKey = strPetKey;
        // No pet means no folder to read - a pet is only on disk once it has been photographed.
        const aFiles = (strPetKey === '') ? [] :
            GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(strPetKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL');
        aFiles.sort();
        aFiles.reverse();
        _m_aFiles = aFiles;
        Refresh();
    }
    PetPhotoLibrary.LoadFromDisk = LoadFromDisk;
    // Puts a just-taken photo at the top. Ignores one that is already listed.
    function Insert(strFileName) {
        if (strFileName === '' || _m_aFiles.indexOf(strFileName) >= 0) {
            return;
        }
        _m_aFiles.unshift(strFileName);
        Refresh();
    }
    PetPhotoLibrary.Insert = Insert;
    function Refresh() {
        if (!_m_elList) {
            return;
        }
        const bAny = _m_aFiles.length !== 0;
        _m_elList.visible = bAny;
        _m_elList.UpdateListItems(_m_aFiles.length);
        // An empty list is not the same thing as no photos, so the host's line goes in its place.
        if (_m_elEmpty) {
            const strEmpty = (!bAny && _m_opts.fnEmpty) ? _m_opts.fnEmpty() : '';
            _m_elEmpty.visible = strEmpty !== '';
            _m_elEmpty.text = strEmpty === '' ? '' : $.Localize(strEmpty);
        }
    }
    PetPhotoLibrary.Refresh = Refresh;
    //----------------------------------------------------------------------------------
    // Settings tooltip
    //----------------------------------------------------------------------------------
    // The settings are read off the name, so there is nothing to keep in step - hovering is what asks.
    // A name that describes to nothing gets no tooltip rather than an empty one.
    function _ShowSettings(elItem, strFileName) {
        const strSettings = PetPhotoTag.Describe(strFileName);
        if (strSettings !== '') {
            UiToolkitAPI.ShowTextTooltipOnPanelStyled(elItem, strSettings, 'tooltip-pet-photo-settings');
        }
    }
    //----------------------------------------------------------------------------------
    // The viewer
    //----------------------------------------------------------------------------------
    // The url draws the image, but the copy and folder buttons reach the photo through the filesystem
    // rather than through panorama, so they need it named the way g_pFullFileSystem takes it: a path
    // relative to a pathID. Both go over, so the viewer never has to turn one form into the other.
    function ShowViewer(strFileName) {
        const elMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('id-photo-library-list', '', 'file://{resources}/layout/context_menus/context_menu_photo_viewer.xml', 'src=' + PetPhotoTag.PhotoUrl(_m_strPetKey, strFileName) +
            '&' + 'path=' + PetPhotoTag.LibraryFolder(_m_strPetKey) + '/' + strFileName +
            '&' + 'pathid=USRLOCAL');
        elMenu.AddClass('ContextMenu_NoArrow');
    }
    PetPhotoLibrary.ShowViewer = ShowViewer;
    //----------------------------------------------------------------------------------
    // Deleting
    //----------------------------------------------------------------------------------
    // The one permanent delete in the whole feature. Only a photo in the camera roll has a row here to
    // press, so one on a page has to be taken off it first.
    function _ConfirmDelete(strFileName) {
        UiToolkitAPI.ShowGenericPopupYesNo('#pet_photo_library_delete_title', '#pet_photo_library_delete_desc', '', () => { _Delete(strFileName); }, () => { });
    }
    function _Delete(strFileName) {
        // the key and the name are all this side gets to say: DeletePetPhoto composes the path itself
        // and refuses anything that is not one of the booth's own screenshots
        if (!GameInterfaceAPI.DeletePetPhoto(_m_strPetKey, strFileName)) {
            return;
        }
        const nIndex = _m_aFiles.indexOf(strFileName);
        if (nIndex >= 0) {
            _m_aFiles.splice(nIndex, 1);
        }
        if (_m_opts.fnOnDeleted) {
            _m_opts.fnOnDeleted(strFileName);
        }
        Refresh();
    }
    //----------------------------------------------------------------------------------
    // Dragging out
    //----------------------------------------------------------------------------------
    function _OnDragStart(elRow, drag) {
        const strFileName = elRow.GetAttributeString('data-file', '');
        if (strFileName === '' || !_m_opts.fnOnDragStart) {
            return;
        }
        _m_opts.fnOnDragStart(strFileName, drag);
        // A drag does not reliably end the hover, and the drag image is what there is to look at.
        UiToolkitAPI.HideTextTooltip();
        // Scrolling the list and dragging out of it want the same movement, so the list stops taking
        // input for the duration - as loadout_grid does.
        SetTakesInput(false);
    }
    function _OnDragEnd() {
        if (_m_opts.fnOnDragEnd) {
            _m_opts.fnOnDragEnd();
        }
        SetTakesInput(true);
    }
    function SetTakesInput(bEnabled) {
        if (_m_elList) {
            _m_elList.hittest = bEnabled;
            _m_elList.hittestchildren = bEnabled;
        }
    }
    PetPhotoLibrary.SetTakesInput = SetTakesInput;
})(PetPhotoLibrary || (PetPhotoLibrary = {}));
