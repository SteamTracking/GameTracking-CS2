"use strict";
/// <reference path="../csgo.d.ts" />
//This file contains functions that helps polling session or game settings for answers
var SessionUtil;
(function (SessionUtil) {
    function DoesGameModeHavePrimeQueue(gameModeSettingName) {
        //
        // Make sure C++ also honors the prime request for the same game modes in cstrike15v2_matchmaking.cpp
        // CGCJob_EMsgGCCStrike15_v2_MatchmakingStart::BYieldingRunJobFromMsg {
        // 		bool bPrimeOnlyRequested = msg.Body().prime_only();
        // 		if ( bPrimeOnlyRequested ) { ...
        //
        return gameModeSettingName === 'competitive' || gameModeSettingName === 'scrimcomp2v2';
    }
    SessionUtil.DoesGameModeHavePrimeQueue = DoesGameModeHavePrimeQueue;
    function GetMaxLobbySlotsForGameMode(gameMode) {
        //
        // Returns max number of slots to display for the lobby in a given game mode
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
        // Allow pet toolbar for solo players
        if (PartyListAPI.GetCount() <= 1)
            return true;
        // But also allow the toolbar for players who are the lobby leader
        // since we always feature the lobby leader front-and-center in the lineup
        // on the lobby leader's screen
        if (LobbyAPI.GetHostSteamID() === MyPersonaAPI.GetXuid())
            return true;
        // Otherwise you are a client in the lobby and your pet might not be onscreen
        return false;
    }
    SessionUtil.BCanUseMyPetInCurrentLobby = BCanUseMyPetInCurrentLobby;
})(SessionUtil || (SessionUtil = {}));
