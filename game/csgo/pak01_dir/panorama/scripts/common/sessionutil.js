"use strict";
/// <reference path="../csgo.d.ts" />
var SessionUtil;
(function (SessionUtil) {
    function DoesGameModeHavePrimeQueue(gameModeSettingName) {
        return gameModeSettingName === 'competitive' || gameModeSettingName === 'scrimcomp2v2';
    }
    SessionUtil.DoesGameModeHavePrimeQueue = DoesGameModeHavePrimeQueue;
    function GetMaxLobbySlotsForGameMode(gameMode) {
        switch (gameMode) {
            case "scrimcomp2v2":
                return 2;
            case "retakes":
                return 4;
            case "rush":
                return 3;
            default:
                return 5;
        }
    }
    SessionUtil.GetMaxLobbySlotsForGameMode = GetMaxLobbySlotsForGameMode;
    function AreLobbyPlayersPrime() {
        const playersCount = PartyListAPI.GetCount();
        for (let i = 0; i < playersCount; i++) {
            const xuid = PartyListAPI.GetXuidByIndex(i);
            const isFriendPrime = PartyListAPI.GetFriendPrimeEligible(xuid);
            if (isFriendPrime === false) {
                return false;
            }
        }
        return true;
    }
    SessionUtil.AreLobbyPlayersPrime = AreLobbyPlayersPrime;
    function GetNumWinsNeededForRank(skillgroupType) {
        if (skillgroupType === 'Competitive')
            return 2;
        return 10;
    }
    SessionUtil.GetNumWinsNeededForRank = GetNumWinsNeededForRank;
    function BCanUseMyPetInCurrentLobby() {
        if (PartyListAPI.GetCount() <= 1)
            return true;
        if (LobbyAPI.GetHostSteamID() === MyPersonaAPI.GetXuid())
            return true;
        return false;
    }
    SessionUtil.BCanUseMyPetInCurrentLobby = BCanUseMyPetInCurrentLobby;
})(SessionUtil || (SessionUtil = {}));
