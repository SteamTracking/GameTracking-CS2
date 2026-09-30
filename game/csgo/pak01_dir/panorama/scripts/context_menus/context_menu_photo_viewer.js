"use strict";
/// <reference path="../csgo.d.ts" />
var PhotoViewerContextMenu;
(function (PhotoViewerContextMenu) {
    function Init() {
        const elPanel = $.GetContextPanel();
        const strSrc = elPanel.GetAttributeString('src', '');
        const elImage = elPanel.FindChildTraverse('id-photo-viewer-image');
        if (strSrc === '' || !elImage) {
            return;
        }
        elImage.SetImageFromFile(strSrc);
        const strPath = elPanel.GetAttributeString('path', '');
        const strPathID = elPanel.GetAttributeString('pathid', '');
        const bFile = strPath !== '' && strPathID !== '';
        // The folder the photo sits in, which is what the second button opens - so everything beside
        // the file's own name. A path with nothing to strip leaves the pathID's own root.
        const nSlash = strPath.lastIndexOf('/');
        const strFolder = (nSlash < 0) ? '' : strPath.substring(0, nSlash);
        const elCopyBtn = elPanel.FindChildInLayoutFile('photo-viewer-copy');
        elCopyBtn.visible = bFile;
        elCopyBtn.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip('photo-viewer-copy', '#pet_photo_viewer_copy'); });
        elCopyBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elCopyBtn.SetPanelEvent('onactivate', () => {
            $.Msg('photo-viewer TEMP copy pressed: path="' + strPath + '" pathid="' + strPathID + '"\n');
            SteamOverlayAPI.CopyImageFileToClipboard(strPath, strPathID);
        });
        const elOpenBtn = elPanel.FindChildInLayoutFile('photo-viewer-open');
        elOpenBtn.visible = bFile;
        elOpenBtn.SetPanelEvent('onmouseover', () => { UiToolkitAPI.ShowTextTooltip('photo-viewer-open', '#pet_photo_viewer_folder'); });
        elOpenBtn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        elOpenBtn.SetPanelEvent('onactivate', () => {
            $.Msg('photo-viewer TEMP open pressed: folder="' + strFolder + '" pathid="' + strPathID + '"\n');
            GameInterfaceAPI.OsOpenFileOrFolder(strFolder, strPathID);
        });
        $.Msg('photo-viewer TEMP Init: src="' + strSrc + '"\n');
        $.Msg('photo-viewer TEMP Init: path="' + strPath + '" pathid="' + strPathID + '" bFile=' + bFile + '\n');
        $.Msg('photo-viewer TEMP Init: folder="' + strFolder + '"\n');
        $.Msg('photo-viewer TEMP Init: matches=' + GameInterfaceAPI.FindFiles(strPath, strPathID).length + '\n');
    }
    PhotoViewerContextMenu.Init = Init;
})(PhotoViewerContextMenu || (PhotoViewerContextMenu = {}));
