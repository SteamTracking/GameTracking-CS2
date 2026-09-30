"use strict";
/// <reference path="..\csgo.d.ts" />
var PopupVideoClip;
(function (PopupVideoClip) {
    function Init() {
        const reelId = $.GetContextPanel().GetAttributeString("reelid", '');
        const reelJson = InventoryAPI.BuildHighlightReelSchemaJSON(parseInt(reelId));
        const reelSchemaDef = JSON.parse(reelJson);
        $.GetContextPanel().SetDialogVariable('clip_title', $.Localize("#CSGO_Watch_Cat_Tournament_" + reelSchemaDef["tournament event id"])
            + " | " +
            $.Localize("#HighlightReel_" + reelSchemaDef["id"]));
        const videoPlayer = $('#VideoClipMovie');
        if (videoPlayer) {
            UiToolkitAPI.PlaySoundEvent('UIPanorama.OnStartPopupVideo');
            videoPlayer.SetMovie(reelSchemaDef["url_1080p"]);
            videoPlayer.UseAttachedAudioStream(true);
            videoPlayer.Play();
        }
    }
    PopupVideoClip.Init = Init;
    function Close() {
        UiToolkitAPI.PlaySoundEvent('UIPanorama.OnStopPopupVideo');
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    PopupVideoClip.Close = Close;
    $.RegisterForUnhandledEvent("ServerReserved", Close);
})(PopupVideoClip || (PopupVideoClip = {}));
