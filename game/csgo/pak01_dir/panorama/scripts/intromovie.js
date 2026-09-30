"use strict";
/// <reference path="csgo.d.ts" />
var IntroMovie;
(function (IntroMovie) {
    var g_movieSoundEventInstanceHandle = null;
    function ShowIntroMovie() {
        var movieName = "file://{resources}/videos/intro.webm";
        const launcherType = MyPersonaAPI.GetLauncherType();
        if (launcherType == "perfectworld") {
            movieName = "file://{resources}/videos/intro-perfectworld.webm";
        }
        $("#IntroMoviePlayer").SetMovie(movieName);
        // This function is called from CGameUI::OnGameUIActivated()
        // For now, we schedule the movie to play on the next frame because the first frame is so long that it causes the videoplayer to
        // stutter. The same bug can be seen if you hit a breakpoint, then resume during a video playback with audio.
        $.Schedule(0.0, PlayIntroMovie);
        $("#IntroMoviePlayer").SetFocus();
        $.RegisterKeyBind($("#IntroMoviePlayer"), "key_enter,key_space,key_escape", SkipIntroMovie);
    }
    function StopIntroMovieSoundEvent() {
        if (g_movieSoundEventInstanceHandle != null) {
            UiToolkitAPI.StopSoundEvent(g_movieSoundEventInstanceHandle, 0.1);
            g_movieSoundEventInstanceHandle = null;
        }
    }
    function PlayIntroMovie() {
        StopIntroMovieSoundEvent();
        g_movieSoundEventInstanceHandle = UiToolkitAPI.PlaySoundEvent("UIPanorama.IntroLogo");
        $("#IntroMoviePlayer").Play();
    }
    function SkipIntroMovie() {
        StopIntroMovieSoundEvent();
        $("#IntroMoviePlayer").Stop();
    }
    function DestroyMoviePlayer() {
        StopIntroMovieSoundEvent();
        $("#IntroMoviePlayer").SetMovie("");
    }
    function HideIntroMovie() {
        // Can't destroy the movie player straight away as this event has been dispatched by the video player itself
        // and therefore delay the destruction to the next iteration of the scheduler.
        $.Schedule(0.0, DestroyMoviePlayer);
        $.DispatchEventAsync(0.0, "CSGOHideIntroMovie");
    }
    //--------------------------------------------------------------------------------------------------
    // Entry point called when panel is created
    //--------------------------------------------------------------------------------------------------
    {
        $.RegisterForUnhandledEvent("CSGOShowIntroMovie", ShowIntroMovie);
        $.RegisterForUnhandledEvent("CSGOEndIntroMovie", HideIntroMovie);
        $.RegisterEventHandler("MoviePlayerPlaybackEnded", $("#IntroMoviePlayer"), HideIntroMovie);
    }
})(IntroMovie || (IntroMovie = {}));
