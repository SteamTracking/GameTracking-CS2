"use strict";
/// <reference path="../csgo.d.ts" />
var TooltipProgress;
(function (TooltipProgress) {
    function Init() {
        let titleText = $.GetContextPanel().GetAttributeString("titletext", "not-found");
        let bodyText = $.GetContextPanel().GetAttributeString("bodytext", "not-found");
        let useXp = $.GetContextPanel().GetAttributeString("usexp", "false") === 'true';
        let targetLevel = $.GetContextPanel().GetAttributeString("targetlevel", "2");
        let showBar = $.GetContextPanel().GetAttributeString("showbar", "true") === 'true';
        let value = 0;
        if (useXp) {
            const currentPoints = FriendsListAPI.GetFriendXp(MyPersonaAPI.GetXuid());
            const pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
            const levelsAttained = FriendsListAPI.GetFriendLevel(MyPersonaAPI.GetXuid());
            const totalPointsAttained = (levelsAttained ? (levelsAttained - 1) : 0) * pointsPerLevel + currentPoints;
            const totalPointsRequired = (Number(targetLevel) - 1) * pointsPerLevel;
            value = totalPointsAttained / totalPointsRequired * 100.0;
        }
        else {
            value = Number($.GetContextPanel().GetAttributeString("barvalue", "0"));
        }
        $('#TitleLabel').text = $.Localize(titleText);
        $('#TextLabel').text = $.Localize(bodyText);
        $('#TextPercentage').text = Math.floor(value) + '%';
        $('#js-tooltip-progress-bar-inner').style.width = value + '%';
        $('#ProgressBarContainer').visible = showBar;
    }
    TooltipProgress.Init = Init;
})(TooltipProgress || (TooltipProgress = {}));
