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
        $.Schedule(0.0, DestroyMoviePlayer);
        $.DispatchEventAsync(0.0, "CSGOHideIntroMovie");
    }
    {
        $.RegisterForUnhandledEvent("CSGOShowIntroMovie", ShowIntroMovie);
        $.RegisterForUnhandledEvent("CSGOEndIntroMovie", HideIntroMovie);
        $.RegisterEventHandler("MoviePlayerPlaybackEnded", $("#IntroMoviePlayer"), HideIntroMovie);
    }
})(IntroMovie || (IntroMovie = {}));
