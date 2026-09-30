"use strict";
/// <reference path="csgo.d.ts" />
var Chat;
(function (Chat) {
    let m_isContentPanelOpen = false;
    let m_lastChatEntry = null;
    let m_isChatType = $.GetContextPanel().GetParent().id === "id-team-vote-middle" ? true : false;
    function _Init() {
        let elInput = $('#ChatInput');
        elInput.SetPanelEvent('oninputsubmit', _ChatTextSubmitted);
        if (m_isChatType) {
            _OpenChat();
            return;
        }
        let elOpenChat = $.GetContextPanel().FindChildInLayoutFile('ChatContainer');
        elOpenChat.SetPanelEvent("onactivate", _OpenChat);
        let elCloseChat = $.GetContextPanel().FindChildInLayoutFile('ChatCloseButton');
        elCloseChat.SetPanelEvent("onactivate", () => { _Close(); });
    }
    function _OpenChat() {
        let elChatContainer = $('#ChatContainer');
        if (!elChatContainer.BHasClass("chat-open")) {
            elChatContainer.RemoveClass('closed-minimized');
            elChatContainer.AddClass("chat-open");
            $("#ChatInput").SetFocus();
            $.Schedule(.1, _ScrollToBottom);
        }
    }
    function _Close() {
        if (m_isChatType)
            return true;
        let elChatContainer = $('#ChatContainer');
        if (elChatContainer.BHasClass("chat-open")) {
            elChatContainer.RemoveClass("chat-open");
            elChatContainer.SetFocus();
            $.Schedule(.1, _ScrollToBottom);
            _SetClosedHeight();
            return true;
        }
        return false;
    }
    function _SetClosedHeight() {
        let elChatContainer = $('#ChatContainer');
        if (!elChatContainer.BHasClass("chat-open")) {
            elChatContainer.SetHasClass('closed-minimized', m_isContentPanelOpen);
            $.Schedule(.1, _ScrollToBottom);
        }
    }
    function _ChatTextSubmitted() {
        if (m_lastChatEntry && (Date.now() - m_lastChatEntry < 200))
            return;
        else
            m_lastChatEntry = Date.now();
        if (m_isChatType) {
            MatchDraftAPI.ActionPregameChat($('#ChatInput').text, false);
        }
        else {
            $.GetContextPanel().SubmitChatText();
        }
        $('#ChatInput').text = "";
    }
    function _OnNewChatEntry() {
        $.Schedule(.1, _ScrollToBottom);
    }
    function _ScrollToBottom() {
        $('#ChatLinesContainer').ScrollToBottom();
    }
    function _SessionUpdate(status) {
        let elChat = $.GetContextPanel().FindChildInLayoutFile('ChatPanelContainer');
        if (status === 'closed')
            _ClearChatMessages();
        if (!LobbyAPI.IsSessionActive()) {
            elChat.AddClass('hidden');
        }
        else {
            let numPlayersActuallyInParty = PartyListAPI.GetCount();
            let networkSetting = PartyListAPI.GetPartySessionSetting("system/network");
            elChat.SetHasClass('hidden', (networkSetting !== 'LIVE' && !m_isChatType));
            if (networkSetting !== 'LIVE' && !m_isChatType) {
                _Close();
            }
            let elPlaceholder = $.GetContextPanel().FindChildInLayoutFile('PlaceholderText');
            if (m_isChatType) {
                elPlaceholder.text = $.Localize('#party_chat_placeholder_pickban');
            }
            else if (numPlayersActuallyInParty > 1) {
                elPlaceholder.text = $.Localize('#party_chat_placeholder');
            }
            else {
                elPlaceholder.text = $.Localize('#party_chat_placeholder_empty_lobby');
            }
        }
    }
    function _ClearChatMessages() {
        let elMessagesContainer = $('#ChatLinesContainer');
        elMessagesContainer.RemoveAndDeleteChildren();
    }
    function _ClipPanelToNotOverlapSideBar(noClip) {
        let panelToClip = $.GetContextPanel();
        if (!panelToClip || panelToClip.BHasClass('hidden'))
            return;
        if ($.GetContextPanel().GetParent().id !== 'MainMenuFriendsAndParty')
            return;
        let panelToClipWidth = panelToClip.actuallayoutwidth;
        let friendsListWidthWhenExpanded = panelToClip.GetParent().FindChildInLayoutFile('mainmenu-sidebar__blur-target').contentwidth;
        let sideBarWidth = noClip ? 0 : friendsListWidthWhenExpanded;
        let widthDiff = panelToClipWidth - sideBarWidth;
        let clipPercent = (panelToClipWidth <= 0 || widthDiff <= 0 ? 1 : (widthDiff / panelToClipWidth)) * 100;
        if (clipPercent)
            panelToClip.style.clip = 'rect( 0%, ' + clipPercent + '%, 100%, 0% );';
    }
    ;
    function _OnHideContentPanel() {
        m_isContentPanelOpen = false;
        _SetClosedHeight();
    }
    ;
    function _OnShowContentPanel() {
        m_isContentPanelOpen = true;
        _SetClosedHeight();
    }
    ;
    {
        _Init();
        $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _SessionUpdate);
        $.RegisterForUnhandledEvent("OnNewChatEntry", _OnNewChatEntry);
        $.RegisterEventHandler("Cancelled", $.GetContextPanel(), _Close);
        $.RegisterForUnhandledEvent('SidebarIsCollapsed', _ClipPanelToNotOverlapSideBar);
        $.RegisterForUnhandledEvent('HideContentPanel', _OnHideContentPanel);
        $.RegisterForUnhandledEvent('ShowContentPanel', _OnShowContentPanel);
    }
})(Chat || (Chat = {}));
