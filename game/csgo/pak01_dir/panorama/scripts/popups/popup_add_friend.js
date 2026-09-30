"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../friendtile.ts" />
var PopupAddFriend;
(function (PopupAddFriend) {
    let m_xuidToInvite = '';
    function Init() {
        let yourCode = MyPersonaAPI.GetFriendCode();
        let elYourCodeBtn = $('#JsPopupYourFriendCode');
        elYourCodeBtn.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip('JsPopupYourFriendCode', yourCode));
        elYourCodeBtn.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
        elYourCodeBtn.SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.CopyTextToClipboard(yourCode);
            UiToolkitAPI.ShowTextTooltip('JsPopupYourFriendCode', '#AddFriend_copy_code_Hint');
        });
        $('#JsPopupYourSendRequest').enabled = false;
        $('#JsFriendCodeNotFound').visible = false;
        $('#JsFriendCodeFound').visible = false;
        $('#JsAddFriendTextEntryLabel').SetFocus();
        $('#JsAddFriendTextEntryLabel').SetPanelEvent('ontextentrychange', OnEntrySubmit);
    }
    PopupAddFriend.Init = Init;
    function OnEntrySubmit() {
        let elNotFoundLabel = $('#JsFriendCodeNotFound');
        let elTextEntry = $('#JsAddFriendTextEntryLabel');
        let xuid = FriendsListAPI.GetXuidFromFriendCode(elTextEntry.text.toUpperCase());
        if (xuid) {
            let elTile = $.GetContextPanel().FindChildTraverse('JsPopupFriendTile');
            if (!elTile) {
                elTile = $.CreatePanel("Panel", $('#JsFriendCodeFound'), 'JsPopupFriendTile');
                elTile.SetAttributeString('xuid', xuid);
                elTile.BLoadLayout('file://{resources}/layout/friendtile.xml', false, false);
            }
            $.Schedule(.1, () => {
                FriendTile.Init(elTile);
                elTile.RemoveClass('hidden');
            });
            $('#JsAddFriendInviteImg').AddClass('hidden');
            $('#JsFriendCodeFound').visible = true;
            $('#JsPopupYourSendRequest').enabled = true;
            elNotFoundLabel.visible = false;
            $.GetContextPanel().FindChildInLayoutFile('JSFriendValidIcon').SetHasClass('valid', true);
            m_xuidToInvite = xuid;
        }
        else {
            if (elTextEntry.text === '') {
                elNotFoundLabel.visible = false;
                return;
            }
            elNotFoundLabel.SetDialogVariable('code', elTextEntry.text.toUpperCase());
            elNotFoundLabel.text = $.Localize('#AddFriend_not_found', elNotFoundLabel);
            $.GetContextPanel().FindChildInLayoutFile('JSFriendValidIcon').SetHasClass('valid', false);
            elNotFoundLabel.visible = true;
            $('#JsPopupYourSendRequest').enabled = false;
            $('#JsFriendCodeFound').visible = false;
        }
    }
    PopupAddFriend.OnEntrySubmit = OnEntrySubmit;
    function OnSendInvite() {
        $('#JsAddFriendInviteImg').RemoveClass('hidden');
        $('#JsPopupYourSendRequest').enabled = false;
        SteamOverlayAPI.InteractWithUser(m_xuidToInvite, 'friendadd');
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupAddFriend.OnSendInvite = OnSendInvite;
    function _FriendsListUpdateName(xuid) {
        let elTile = $.GetContextPanel().FindChildTraverse('JsPopupFriendTile');
        if (elTile && elTile.IsValid() && (xuid === elTile.GetAttributeString('xuid', ''))) {
            FriendTile.Init(elTile);
        }
    }
    {
        $.RegisterForUnhandledEvent('PanoramaComponent_FriendsList_NameChanged', _FriendsListUpdateName);
    }
})(PopupAddFriend || (PopupAddFriend = {}));
