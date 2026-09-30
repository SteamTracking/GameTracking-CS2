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
            // Example URLs:
            // https://cdn.akamai.steamstatic.com/apps/csgo/videos/csgo_react/cs2/video_smokes.webm
            // https://cdn.akamai.steamstatic.com/apps/csgo/videos/highlightreels_beta/024/024_074v095_005_de_anubis_aus2025_ra1nsmokedefuse_ww_1080p.webm
            // reels support url_1080p, url_720p, url_480p -- this big player uses biggest resolution @ 1080p:
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
