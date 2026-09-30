"use strict";
/// <reference path="csgo.d.ts" />
var GameModeFlags;
(function (GameModeFlags) {
    const k_gamemodeflags = {
        competitive: {
            name: 'competitive',
            flags: [
                16
            ],
            icons: [
                'file://{images}/icons/ui/timer_long.svg'
            ],
            user_visible_flags: false
        },
        deathmatch: {
            name: 'deathmatch',
            flags: [
                32
            ],
            icons: [
                'file://{images}/icons/ui/free_for_all.svg'
            ],
            user_visible_flags: true
        }
    };
    function GetIcon(mode, flags) {
        const iconIndex = k_gamemodeflags[mode].flags.indexOf(flags);
        return k_gamemodeflags[mode].icons[iconIndex];
    }
    GameModeFlags.GetIcon = GetIcon;
    function GetOptionsString(mode) {
        let s = '';
        const arr = k_gamemodeflags[mode].flags;
        for (let i = 0; i < arr.length; ++i) {
            s += '&option' + i + '=' + arr[i];
        }
        return s;
    }
    GameModeFlags.GetOptionsString = GetOptionsString;
    function AreFlagsValid(mode, flags) {
        const arrPossibleFlags = k_gamemodeflags[mode].flags;
        return (arrPossibleFlags.indexOf(flags) != -1);
    }
    GameModeFlags.AreFlagsValid = AreFlagsValid;
    function DoesModeUseFlags(mode) {
        return k_gamemodeflags.hasOwnProperty(mode);
    }
    GameModeFlags.DoesModeUseFlags = DoesModeUseFlags;
    function DoesModeShowUserVisibleFlags(mode) {
        return (k_gamemodeflags.hasOwnProperty(mode)) ? k_gamemodeflags[mode].user_visible_flags : false;
    }
    GameModeFlags.DoesModeShowUserVisibleFlags = DoesModeShowUserVisibleFlags;
    function GetFlags() {
        return k_gamemodeflags;
    }
    GameModeFlags.GetFlags = GetFlags;
})(GameModeFlags || (GameModeFlags = {}));
