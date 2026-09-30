"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupNews;
(function (PopupNews) {
    function Init() {
        let date = $.GetContextPanel().GetAttributeString("date", '');
        date = date.split(' ')[0];
        $.GetContextPanel().SetDialogVariable('news_date', date);
        let title = $.GetContextPanel().GetAttributeString("title", '');
        $.GetContextPanel().SetDialogVariable('news_title', title);
        let link = $.GetContextPanel().GetAttributeString("link", '');
        let elUrlBtn = $.GetContextPanel().FindChildTraverse('id-news-url-button');
        if (elUrlBtn) {
            let strUrl = link;
            elUrlBtn.SetPanelEvent('onactivate', () => {
                SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser(strUrl);
                $.DispatchEvent('UIPopupButtonClicked', '');
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.mainmenu_press_home', 'MOUSE');
            });
        }
        //
        // Adjust the link as needed for display in client and navigate to it
        //
        let elBlogHTML = $.GetContextPanel().FindChildTraverse('BlogHTML');
        if (elBlogHTML) {
            // Debug links:
            // link = 'https://csgostaging.wpcomstaging.com/index.php/2019/04/23968/';
            // link = 'https://stackoverflow.com/';
            // Make a special URL that allows for distinguishing in-client views -vs- web views
            // also fixes proxy caching settings when generating in-client PHP to not pollute
            // the in-browser stylesheets (wordpress woes)
            if (link.indexOf('?') < 0)
                link += '?';
            else
                link += '&';
            link += 'is_embedded_in_client=1';
            // Navigate to the URL
            elBlogHTML.SetURL(link);
        }
    }
    PopupNews.Init = Init;
    function Close() {
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupNews.Close = Close;
    function _HTMLOpenPopupLink(elPanel, sLinkUrl) {
        SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser(sLinkUrl);
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.mainmenu_press_home', 'MOUSE');
    }
    function _HTMLFinishRequest() {
        $.Schedule(0.3, () => {
            let elHTML = $.GetContextPanel().FindChildTraverse('BlogHTML');
            if (elHTML) {
                elHTML.AddClass('visible');
            }
        });
    }
    $.RegisterEventHandler("HTMLFinishRequest", $.GetContextPanel(), _HTMLFinishRequest);
    $.RegisterEventHandler("HTMLOpenPopupLink", $.GetContextPanel(), _HTMLOpenPopupLink);
})(PopupNews || (PopupNews = {}));
