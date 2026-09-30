"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="xpshop_track.ts" />
/// <reference path="rank_skillgroup_particles.ts" />
/// <reference path="endofmatch.ts" />
var EOM_Rank;
(function (EOM_Rank) {
    let _m_pauseBeforeEnd = 1.0;
    const _m_cP = $.GetContextPanel();
    _m_cP.Data().m_retries = 0;
    function _DisplayMe() {
        if (!_m_cP || !_m_cP.IsValid())
            return;
        if (!MockAdapter.bXpDataReady(_m_cP))
            return false;
        if (MyPersonaAPI.GetElevatedState() !== 'elevated')
            return false;
        let xPPerLevel = MyPersonaAPI.GetXpPerLevel();
        let oXpData = MockAdapter.XPDataJSO(_m_cP);
        if (!oXpData)
            return false;
        const xpBonuses = MyPersonaAPI.GetActiveXpBonuses();
        const bEligibleForCarePackage = xpBonuses.split(',').includes('2');
        const earnedFreeRewards = oXpData.hasOwnProperty('free_rewards') ? Number(oXpData.free_rewards) : 0;
        const xp_trail_level = oXpData.hasOwnProperty('xp_trail_level') ? Number(oXpData.xp_trail_level) : 0;
        $.GetContextPanel().SetHasClass('care-package-eligible', bEligibleForCarePackage || (earnedFreeRewards != 0));
        let elCarePackage = _m_cP.FindChildTraverse('jsEomCarePackage');
        elCarePackage.RemoveClass('earned-rewards');
        let elProgress = _m_cP.FindChildInLayoutFile("id-eom-rank__bar-container");
        let elNew = _m_cP.FindChildInLayoutFile("id-eom-new-reveal");
        let elCurrent = _m_cP.FindChildInLayoutFile("id-eom-rank__current");
        let elBar = _m_cP.FindChildInLayoutFile("id-eom-rank__bar");
        let elRankLister = _m_cP.FindChildInLayoutFile("id-eom-rank__lister");
        let elRankListerItems = _m_cP.FindChildInLayoutFile("id-eom-rank__lister__items");
        let arrPreRankXP = [];
        let arrPostRankXP = [];
        let totalXP = 0;
        let maxLevel = InventoryAPI.GetMaxLevel();
        let elPanel = _m_cP.FindChildTraverse('id-eom-rank__current');
        elPanel.TriggerClass('show');
        _m_cP.AddClass('eom-rank-show');
        let currentRank = oXpData.current_level;
        currentRank = currentRank < maxLevel ? currentRank : maxLevel;
        elCurrent.SetDialogVariableInt("level", currentRank);
        elCurrent.SetDialogVariable('name', $.Localize('#XP_RankName_' + currentRank, elCurrent));
        _m_cP.FindChildInLayoutFile("id-eom-rank__current__emblem").SetImage("file://{images}/icons/xp/level" + currentRank + ".png");
        const newRank = currentRank < maxLevel ? (currentRank + 1) : maxLevel;
        let elCurrentListerItem;
        let _xpSoundNum = 1;
        let currentXpPointer = 0;
        function _AddXPBar(reason, xp, xpToXpTrailEvent = -1) {
            const sPerXp = 0.0005;
            const duration = sPerXp * xp;
            const sPerSoundTick = 0.082;
            for (let t = sPerSoundTick; t < duration; t += sPerSoundTick) {
                $.Schedule(animTime + t, () => $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.XP.Ticker', 'eom-rank'));
            }
            $.Schedule(animTime, () => {
                if (!elBar.IsValid())
                    return 0;
                let elRankSegment = $.CreatePanel('Panel', elBar, 'id-eom-rank__bar__segment');
                elRankSegment.AddClass("eom-rank__bar__segment");
                elBar.MoveChildAfter(elRankLister, elRankSegment);
                let colorClass;
                if (reason == "old") {
                    colorClass = "eom-rank__blue";
                }
                else if (reason == "levelup") {
                    colorClass = "eom-rank__purple";
                }
                else if (reason == "6" || reason == "7") {
                    colorClass = "eom-rank__yellow";
                }
                else if (reason == "9" || reason == "10" || reason == "59") {
                    colorClass = "eom-rank__yellow";
                }
                else {
                    colorClass = "eom-rank__green";
                }
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.XP.Milestone_0' + _xpSoundNum.toString(), 'eom-rank');
                if (_xpSoundNum < 4) {
                    _xpSoundNum++;
                }
                elRankSegment.AddClass(colorClass);
                elRankSegment.style.width = '0%';
                $.Schedule(0.0, () => {
                    if (elRankSegment && elRankSegment.IsValid()) {
                        elRankSegment.style.width = (xp / xPPerLevel * 100) + '%;';
                    }
                });
                elRankSegment.style.transitionDuration = duration + "s";
                if (elCurrentListerItem) {
                    elCurrentListerItem.AddClass("eom-rank__lister__item--old");
                }
                if (elRankListerItems && elRankListerItems.IsValid()) {
                    elCurrentListerItem = $.CreatePanel('Panel', elRankListerItems, 'id-eom-rank__lister__items__' + reason);
                    elCurrentListerItem.BLoadLayoutSnippet("snippet_rank__lister__item");
                    elCurrentListerItem.RemoveClass("eom-rank__lister__item--appear");
                    let elAmtLabel = elCurrentListerItem.FindChildTraverse('id-eom-rank__lister__item__amt');
                    elAmtLabel.SetDialogVariable("xp", String(xp));
                    elAmtLabel.text = $.Localize("#EOM_XP_Bar", elAmtLabel);
                    elAmtLabel.AddClass(colorClass);
                    let elDescLabel = elCurrentListerItem.FindChildTraverse('id-eom-rank__lister__item__desc');
                    elDescLabel.SetDialogVariable("gamemode", $.Localize("#SFUI_GameMode_" + MatchStatsAPI.GetGameMode()));
                    elDescLabel.text = $.Localize("#XP_Bonus_RankUp_" + reason, elDescLabel);
                }
            });
            currentXpPointer += xp;
            if (xpToXpTrailEvent > -1) {
                const xpTrailAnimStartTime = xpToXpTrailEvent * sPerXp;
                $.Schedule(animTime + xpTrailAnimStartTime, () => {
                    if (_m_cP && _m_cP.IsValid()) {
                        _m_cP.SetHasClass('xptrail-acquired', true);
                        _DisplayXpTrailRemainingTime(oXpData.xp_trail_remaining);
                        const elHonorIcon = _m_cP.FindChildTraverse('jsHonorIcon');
                        elHonorIcon.Set(xp_trail_level, false);
                    }
                });
            }
            return duration;
        }
        ;
        totalXP += oXpData.current_xp;
        for (let elem of oXpData.xp_progress_data) {
            let xp = elem.xp_points;
            let key = elem.xp_category;
            if (totalXP + xp < xPPerLevel) {
                arrPreRankXP.push({ reason: key, xp: xp });
            }
            else {
                let xp_upto = xPPerLevel - totalXP;
                let xp_remainder = totalXP + xp - xPPerLevel;
                if (xp_upto > 0) {
                    arrPreRankXP.push({ reason: key, xp: xp_upto });
                    arrPostRankXP.push({ reason: key, xp: xp_remainder });
                }
                else
                    arrPostRankXP.push({ reason: key, xp: xp });
            }
            totalXP += xp;
        }
        const xpTrailXpPosition = totalXP + (oXpData.hasOwnProperty('xp_trail_xp_needed') ? Number(oXpData.xp_trail_xp_needed) : 0);
        function _AnimSequenceNext(func, duration = 0) {
            $.Schedule(animTime, func);
            animTime += duration;
        }
        let _AnimPause = function (sec) {
            animTime += sec;
        };
        let animTime = 0;
        _AnimPause(1.0);
        function _PlaceXpTrail(xp) {
            const elHonorIcon = _m_cP.FindChildTraverse('jsHonorIcon');
            elHonorIcon.Set(xp_trail_level, false);
            _m_cP.SetHasClass('xptrail-enabled', xp >= 0);
            if (xp < 0)
                return;
            const XpTrail_pct = (xp / xPPerLevel * 100) - 2;
            elHonorIcon.style.x = (XpTrail_pct) + '%;';
        }
        function _DisplayXpTrailRemainingTime(xp_trail_remaining) {
            _m_cP.SetHasClass('xptrail-remaining-time-enabled', (xp_trail_remaining != undefined) && (xp_trail_remaining > 0));
            _m_cP.SetDialogVariable('xp-trail-remaining', FormatText.SecondsToSignificantTimeString(xp_trail_remaining).toLowerCase());
        }
        if (oXpData.current_xp > 0) {
            const xpToXpTrailEvent = ((xpTrailXpPosition > 0) && (xpTrailXpPosition <= oXpData.current_xp)) ? xpTrailXpPosition : -1;
            _AnimPause(_AddXPBar("old", oXpData.current_xp, xpToXpTrailEvent));
        }
        const xpToXpTrailEvent = xpTrailXpPosition <= 5000 ? xpTrailXpPosition : -1;
        _PlaceXpTrail(xpToXpTrailEvent);
        const DelayXpTrailAnnounce = xpTrailXpPosition > 0 && xpTrailXpPosition <= totalXP;
        if (!DelayXpTrailAnnounce)
            _DisplayXpTrailRemainingTime(oXpData.xp_trail_remaining);
        for (let i = 0; i < arrPreRankXP.length; i++) {
            _AnimPause(1.0);
            if (arrPreRankXP[i].xp > 0) {
                const xpToXpTrailEvent = ((xpTrailXpPosition > currentXpPointer) && (xpTrailXpPosition <= currentXpPointer + arrPreRankXP[i].xp)) ? xpTrailXpPosition - currentXpPointer : -1;
                _AnimPause(_AddXPBar(arrPreRankXP[i].reason, arrPreRankXP[i].xp, xpToXpTrailEvent));
            }
        }
        if (totalXP >= xPPerLevel) {
            let elRankEarnedCarePackagefx = _m_cP.FindChildInLayoutFile("id-eom-rank_carepackage_earned_effects");
            let elRankCarePackageBgfx = _m_cP.FindChildInLayoutFile("id-eom-rank_carepackage_bg_effects");
            _AnimSequenceNext(() => {
                if (!elProgress || !elProgress.IsValid())
                    return;
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.XP.BarFull', 'eom-rank');
                elProgress.FindChildInLayoutFile('id-eom-rank-bar-white').AddClass('eom-rank__bar--white--show');
                if (earnedFreeRewards > 0) {
                    elRankCarePackageBgfx.SetParticleNameAndRefresh("particles/ui/rank_carepackage_bg_base.vpcf");
                    elRankCarePackageBgfx.SetControlPoint(3, 0, 0, 1);
                    elRankCarePackageBgfx.StartParticles();
                }
            }, 1);
            if (earnedFreeRewards > 0) {
                _AnimSequenceNext(() => {
                    if (!_m_cP || !_m_cP.IsValid())
                        return;
                    let elCarePackage = _m_cP.FindChildTraverse('jsEomCarePackage');
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.tab_mainmenu_shop', 'eom-rank');
                    elCarePackage.AddClass('earned-rewards');
                    elRankEarnedCarePackagefx.SetParticleNameAndRefresh("particles/ui/rank_carepackage_recieve.vpcf");
                    elRankEarnedCarePackagefx.SetControlPoint(3, 0, 0, 1);
                }, 2);
            }
            _AnimSequenceNext(() => {
                if (!elProgress || !elProgress.IsValid() ||
                    !elCurrent || !elCurrent.IsValid() ||
                    !elBar || !elBar.IsValid() ||
                    !elNew || !elNew.IsValid() ||
                    !elCurrent || !elCurrent.IsValid())
                    return;
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.XP.NewRank', 'eom-rank');
                elBar.FindChildrenWithClassTraverse("eom-rank__bar__segment").forEach(entry => entry.DeleteAsync(.0));
                elRankCarePackageBgfx.StopParticlesWithEndcaps();
                elCurrent.SetDialogVariableInt("level", newRank);
                elCurrent.SetDialogVariable('name', $.Localize('#XP_RankName_' + newRank, elCurrent));
                _m_cP.SetDialogVariable('rank_new', $.Localize('#XP_RankName_Display', elCurrent));
                _m_cP.FindChildInLayoutFile("id-eom-rank__current__label").text = $.Localize("{s:rank_new}", elCurrent);
                _m_cP.FindChildInLayoutFile("id-eom-rank__current__emblem").SetImage("file://{images}/icons/xp/level" + newRank + ".png");
                elNew.RemoveClass("hidden");
                elNew.FindChildInLayoutFile('id-eom-new-reveal-image').SetImage("file://{images}/icons/xp/level" + newRank + ".png");
                elNew.TriggerClass("eom-rank-new-reveal--anim");
                let elParticleEffect = elNew.FindChildInLayoutFile('id-eom-new-reveal-flare');
                let aParticleSettings = RankSkillgroupParticles.GetRankParticleSettings(newRank);
                elParticleEffect.SetParticleNameAndRefresh(aParticleSettings.particleName);
                elParticleEffect.SetControlPoint(aParticleSettings.cpNumber, aParticleSettings.cpValue[0], aParticleSettings.cpValue[1], aParticleSettings.cpValue[2]);
                elParticleEffect.StartParticles();
            }, 3);
            _AnimSequenceNext(() => {
                if (!_m_cP || !_m_cP.IsValid())
                    return;
                const xpToXpTrailEvent = xpTrailXpPosition > 5000 && xpTrailXpPosition <= 10000 ? xpTrailXpPosition - 5000 : -1;
                _PlaceXpTrail(xpToXpTrailEvent);
            });
            _AnimSequenceNext(() => {
                if (!elProgress || !elProgress.IsValid() ||
                    !elCurrent || !elCurrent.IsValid() ||
                    !elBar || !elBar.IsValid() ||
                    !elNew || !elNew.IsValid() ||
                    !elCurrent || !elCurrent.IsValid())
                    return;
                elProgress.FindChildInLayoutFile('id-eom-rank-bar-white').RemoveClass('eom-rank__bar--white--show');
            });
            for (let i = 0; i < arrPostRankXP.length; i++) {
                const xpToXpTrailEvent = ((xpTrailXpPosition > currentXpPointer) && (xpTrailXpPosition <= currentXpPointer + arrPostRankXP[i].xp)) ? xpTrailXpPosition - currentXpPointer : -1;
                _AnimPause(_AddXPBar(arrPostRankXP[i].reason, arrPostRankXP[i].xp, xpToXpTrailEvent));
            }
            _AnimPause(2.0);
        }
        _AnimSequenceNext(() => {
        }, 1);
        let oXpShopData = MockAdapter.XPShopDataJSO(_m_cP);
        if (oXpShopData && oXpShopData.hasOwnProperty('prematch')) {
            const elRoot = _m_cP.FindChildTraverse('jsXpShopTrackRoot');
            const elXpShopContainer = _m_cP.FindChildTraverse('jsXpShopTrackContainer');
            oXpShopData.prematch.xp_tracks.forEach(function (track, idx) {
                const elTrack = $.CreatePanel('Panel', elXpShopContainer, 'id-xpshop_track_' + idx);
                elTrack.BLoadLayout('file://{resources}/layout/xpshop_track.xml', false, false);
                XpShopTrack.XpShopInit({
                    xpshop_track_frame_panel: elTrack,
                    xpshop_track_value: track,
                });
            });
            _AnimSequenceNext(() => {
                if (elRoot && elRoot.IsValid())
                    elRoot.AddClass('reveal');
            }, 0.3);
            if (oXpShopData.hasOwnProperty('postmatch')) {
                _AnimPause(1.0);
                _AnimSequenceNext(() => {
                    oXpShopData.postmatch.xp_tracks.forEach(function (track, idx) {
                        const elTrack = (elXpShopContainer && elXpShopContainer.IsValid()) ? elXpShopContainer.FindChildTraverse('id-xpshop_track_' + idx) : undefined;
                        if (elTrack) {
                            XpShopTrack.XpShopUpdate({
                                xpshop_track_frame_panel: elTrack,
                                xpshop_track_value: track,
                            });
                        }
                    });
                }, 2);
            }
        }
        _m_pauseBeforeEnd += animTime;
        return true;
    }
    ;
    function Start() {
        if (MockAdapter.GetMockData() && !MockAdapter.GetMockData().includes('RANK')) {
            _End();
            return;
        }
        if (_DisplayMe()) {
            EndOfMatch.SwitchToPanel('eom-rank');
            EndOfMatch.StartDisplayTimer(_m_pauseBeforeEnd);
            $.Schedule(_m_pauseBeforeEnd, _End);
        }
        else {
            _End();
            return;
        }
    }
    function _End() {
        EndOfMatch.ShowNextPanel();
    }
    function Shutdown() {
    }
    {
        EndOfMatch.RegisterPanelObject({
            name: 'eom-rank',
            Start: Start,
            Shutdown: Shutdown
        });
    }
})(EOM_Rank || (EOM_Rank = {}));
