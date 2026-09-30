"use strict";
/// <reference path="csgo.d.ts" />
var NewNewsEntryCheck;
(function (NewNewsEntryCheck) {
    let _m_RSSFeedReceivedEventHandler = null;
    function GetRssFeed() {
        BlogAPI.RequestRSSFeed();
    }
    NewNewsEntryCheck.GetRssFeed = GetRssFeed;
    function _OnRssFeedReceived(feed) {
        let feeds = [
            {
                linkmatch: '/newsentry/',
                cvarname: 'ui_news_last_read_link',
                processed: false
            },
            {
                linkmatch: '/newsentry2/',
                cvarname: 'ui_news_last_read_link2',
                processed: false
            }
        ];
        feed['items'].forEach(function (item, i) {
            if (item.categories.includes('Minor'))
                return;
            feeds.forEach(function (feed) {
                if (feed.processed)
                    return;
                const urlpos = item.link.indexOf(feed.linkmatch);
                if (urlpos === -1)
                    return;
                feed.processed = true;
                const postid = item.link.substring(urlpos + feed.linkmatch.length);
                const lastseen = GameInterfaceAPI.GetSettingString(feed.cvarname);
                if (postid === lastseen)
                    return;
                UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_news.xml', 'date=' + item.date + "&" +
                    'title=' + item.title + "&" +
                    'link=' + item.link);
                GameInterfaceAPI.SetSettingString(feed.cvarname, postid);
            });
        });
    }
    function RegisterForRssReceivedEvent() {
        if (!_m_RSSFeedReceivedEventHandler)
            _m_RSSFeedReceivedEventHandler = $.RegisterForUnhandledEvent("PanoramaComponent_Blog_RSSFeedReceived", _OnRssFeedReceived);
    }
    NewNewsEntryCheck.RegisterForRssReceivedEvent = RegisterForRssReceivedEvent;
    function UnRegisterForRssReceivedEvent() {
        if (_m_RSSFeedReceivedEventHandler) {
            $.UnregisterForUnhandledEvent("PanoramaComponent_Blog_RSSFeedReceived", _m_RSSFeedReceivedEventHandler);
            _m_RSSFeedReceivedEventHandler = null;
        }
    }
    NewNewsEntryCheck.UnRegisterForRssReceivedEvent = UnRegisterForRssReceivedEvent;
    {
        GetRssFeed();
    }
})(NewNewsEntryCheck || (NewNewsEntryCheck = {}));
