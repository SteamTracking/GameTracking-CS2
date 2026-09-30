"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/pet_photo_tag.ts" />
var PetPhotoLibrary;
(function (PetPhotoLibrary) {
    let _m_aFiles = [];
    let _m_elList = null;
    let _m_elEmpty = null;
    let _m_opts = {};
    function Init(elRoot, opts) {
        _m_opts = opts;
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
        const elItem = $.CreatePanel(_m_opts.bDraggable ? 'Button' : 'Panel', _m_elList, '', { class: 'photo-library__item' });
        $.CreatePanel('Image', elItem, '', { scaling: 'stretch-to-fit-y-preserve-aspect', class: 'photo-library__image' });
        if (_m_opts.bDeletable) {
            const elDelete = $.CreatePanel('Button', elItem, '', { class: 'photo-library__delete-btn' });
            $.CreatePanel('Image', elDelete, '', { src: 'file://{images}/icons/ui/trash.svg', textureheight: '16', scaling: 'stretch-to-fit-preserve-aspect' });
        }
        if (_m_opts.bDraggable) {
            $.RegisterEventHandler('DragStart', elItem, _OnDragStart);
            $.RegisterEventHandler('DragEnd', elItem, _OnDragEnd);
        }
        return elItem;
    }
    function _PointRowAt(elItem, strFileName) {
        elItem.SetAttributeString('data-file', strFileName);
        const aImages = elItem.FindChildrenWithClassTraverse('photo-library__image');
        if (aImages.length > 0) {
            aImages[0].SetImageFromFile(PetPhotoTag.PhotoUrl(_m_strPetKey, strFileName));
        }
        elItem.SetPanelEvent('onactivate', () => { ShowViewer(strFileName); });
        elItem.SetPanelEvent('onmouseover', () => { _ShowSettings(elItem, strFileName); });
        elItem.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        if (_m_opts.bDeletable) {
            const aDelete = elItem.FindChildrenWithClassTraverse('photo-library__delete-btn');
            if (aDelete.length > 0) {
                aDelete[0].SetPanelEvent('onactivate', () => { _ConfirmDelete(strFileName); });
            }
        }
        elItem.SetDraggable(!!_m_opts.bDraggable);
        elItem.SetHasClass('photo-library__item--draggable', !!_m_opts.bDraggable);
    }
    let _m_strPetKey = '';
    function LoadFromDisk(strPetKey) {
        _m_strPetKey = strPetKey;
        const aFiles = (strPetKey === '') ? [] :
            GameInterfaceAPI.FindFiles(PetPhotoTag.LibraryFolder(strPetKey) + '/*' + PetPhotoTag.EXT, 'USRLOCAL');
        aFiles.sort();
        aFiles.reverse();
        _m_aFiles = aFiles;
        Refresh();
    }
    PetPhotoLibrary.LoadFromDisk = LoadFromDisk;
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
        if (_m_elEmpty) {
            const strEmpty = (!bAny && _m_opts.fnEmpty) ? _m_opts.fnEmpty() : '';
            _m_elEmpty.visible = strEmpty !== '';
            _m_elEmpty.text = strEmpty === '' ? '' : $.Localize(strEmpty);
        }
    }
    PetPhotoLibrary.Refresh = Refresh;
    function _ShowSettings(elItem, strFileName) {
        const strSettings = PetPhotoTag.Describe(strFileName);
        if (strSettings !== '') {
            UiToolkitAPI.ShowTextTooltipOnPanelStyled(elItem, strSettings, 'tooltip-pet-photo-settings');
        }
    }
    function ShowViewer(strFileName) {
        const elMenu = UiToolkitAPI.ShowCustomLayoutContextMenuParameters('id-photo-library-list', '', 'file://{resources}/layout/context_menus/context_menu_photo_viewer.xml', 'src=' + PetPhotoTag.PhotoUrl(_m_strPetKey, strFileName) +
            '&' + 'path=' + PetPhotoTag.LibraryFolder(_m_strPetKey) + '/' + strFileName +
            '&' + 'pathid=USRLOCAL');
        elMenu.AddClass('ContextMenu_NoArrow');
    }
    PetPhotoLibrary.ShowViewer = ShowViewer;
    function _ConfirmDelete(strFileName) {
        UiToolkitAPI.ShowGenericPopupYesNo('#pet_photo_library_delete_title', '#pet_photo_library_delete_desc', '', () => { _Delete(strFileName); }, () => { });
    }
    function _Delete(strFileName) {
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
    function _OnDragStart(elRow, drag) {
        const strFileName = elRow.GetAttributeString('data-file', '');
        if (strFileName === '' || !_m_opts.fnOnDragStart) {
            return;
        }
        _m_opts.fnOnDragStart(strFileName, drag);
        UiToolkitAPI.HideTextTooltip();
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
