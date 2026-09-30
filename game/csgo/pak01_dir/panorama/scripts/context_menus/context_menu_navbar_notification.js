"use strict";
/// <reference path="../csgo.d.ts" />
var ContextMenuNavBarNotification;
(function (ContextMenuNavBarNotification) {
    function SetupContextMenu() {
        const icon = $.GetContextPanel().GetAttributeString('icon', '');
        const title = $.GetContextPanel().GetAttributeString('title', '');
        const color = $.GetContextPanel().GetAttributeString('color', '');
        const tooltip = $.GetContextPanel().GetAttributeString('tooltip', '');
        const link = $.GetContextPanel().GetAttributeString('link', '');
        const gcConnecting = $.GetContextPanel().GetAttributeString('gcconnecting', '');
        const elPanel = $.CreatePanel('Panel', $.GetContextPanel(), '');
        elPanel.BLoadLayoutSnippet('notification');
        $.Msg('ContextMenuNavBarNotification: ' + gcConnecting);
        // Show hide icons
        $.GetContextPanel().FindChildInLayoutFile('id-notification-gc-icon').SetHasClass('show', gcConnecting === 'true');
        let elIcon = $.GetContextPanel().FindChildInLayoutFile('id-notification-icon');
        elIcon.SetHasClass('show', gcConnecting !== 'true');
        if (gcConnecting !== 'true') {
            elIcon.SetImage('file://{images}/icons/ui/' + icon + '.svg');
            elIcon.SetHasClass(color, color !== '');
        }
        if (link !== '') {
            $.GetContextPanel().FindChildInLayoutFile('id-notification-link').SetPanelEvent('onactivate', () => SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser(link));
        }
        // Show hide text based on if we have text to show
        $.GetContextPanel().SetHasClass('show-title', title !== '');
        $.GetContextPanel().SetHasClass('show-tooltip', tooltip !== '');
        $.GetContextPanel().SetHasClass('show-link', link !== '');
        // Set text
        $.GetContextPanel().SetDialogVariable('title', title);
        $.GetContextPanel().SetDialogVariable('tooltip', $.Localize(tooltip));
        $.GetContextPanel().SetDialogVariable('link', link);
        $.GetContextPanel().FindChildInLayoutFile('id-notification-text-block').SetHasClass(color, true);
    }
    ContextMenuNavBarNotification.SetupContextMenu = SetupContextMenu;
    // $( '#DynamicLabel' ).text = "Parameter 'test' had value '" + strTest + "'";
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        // const oNotification = $.GetContextPanel().Data().oNotification as MainMenu.NotificationBarDef_t;
        $.Msg('ContextMenuNavBarNotification ');
    }
})(ContextMenuNavBarNotification || (ContextMenuNavBarNotification = {}));
