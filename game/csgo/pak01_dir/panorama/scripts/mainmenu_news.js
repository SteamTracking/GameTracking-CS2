"use strict";
/// <reference path="csgo.d.ts" />
var NewsPanel;
(function (NewsPanel) {
    function _GetRssFeed() {
        BlogAPI.RequestRSSFeed();
    }
    function _OnRssFeedReceived(feed) {
        $.Msg('Revieved blog RSSs Feed' + feed);
        if ($.GetContextPanel().BHasClass('news-panel--hide-news-panel')) {
            return;
        }
        ;
        let elLister = $.GetContextPanel().FindChildInLayoutFile('NewsPanelLister');
        if (elLister === undefined || elLister === null || !feed)
            return;
        elLister.RemoveAndDeleteChildren();
        // find the first candidate for popup
        let foundFirstNewsItem = false;
        feed['items'].forEach(function (item, i) {
            let elEntry = $.CreatePanel('Panel', elLister, 'NewEntry' + i, {
                acceptsinput: true
            });
            // pop up the first news item if we've never seen it before
            if (!foundFirstNewsItem && !item.categories.includes('Minor')) {
                foundFirstNewsItem = true;
                // always highlight the latest important news
                elEntry.AddClass('new');
            }
            elEntry.BLoadLayoutSnippet('featured-news-full-entry');
            let elImage = elEntry.FindChildInLayoutFile('NewsHeaderImage');
            if (item.imageUrl) {
                elImage.SetImage(item.imageUrl);
            }
            else {
                elImage.SetImage("file://{images}/store/default-news.png");
            }
            let elEntryInfo = $.CreatePanel('Panel', elEntry, 'NewsInfo' + i);
            elEntryInfo.BLoadLayoutSnippet('featured-news-info');
            elEntryInfo.SetDialogVariable('news_item_date', item.date);
            elEntryInfo.SetDialogVariable('news_item_title', item.title);
            elEntryInfo.SetDialogVariable('news_item_body', item.description);
            // history articles  //
            elEntry.BLoadLayoutSnippet('history-news-full-entry');
            elImage = elEntry.FindChildInLayoutFile('NewsHeaderImage');
            if (item.imageUrl) {
                elImage.SetImage(item.imageUrl);
            }
            else {
                elImage.SetImage("file://{images}/store/default-news.png");
            }
            elEntryInfo = $.CreatePanel('Panel', elEntry, 'NewsInfo' + i);
            elEntryInfo.BLoadLayoutSnippet('history-news-info');
            elEntryInfo.SetDialogVariable('news_item_date', item.date);
            elEntryInfo.SetDialogVariable('news_item_title', item.title);
            elEntryInfo.SetDialogVariable('news_item_body', item.description);
            // Adding
            elEntry.FindChildInLayoutFile('NewsEntryBlurTarget').AddBlurPanel(elEntryInfo);
            let link = item.link;
            let clearNew = i == 0;
            elEntry.SetPanelEvent("onactivate", () => {
                SteamOverlayAPI.OpenURL(link);
                if (clearNew) {
                    // GameInterfaceAPI.SetSettingString( 'ui_news_last_read_link', link );
                    elEntry.RemoveClass('new');
                }
            });
        });
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        _GetRssFeed();
        $.RegisterForUnhandledEvent("PanoramaComponent_Blog_RSSFeedReceived", _OnRssFeedReceived);
    }
})(NewsPanel || (NewsPanel = {}));
