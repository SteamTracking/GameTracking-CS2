"use strict";
/// <reference path="csgo.d.ts" />
var RankSkillgroupParticles;
(function (RankSkillgroupParticles) {
    function GetRankParticleSettings(nRank) {
        let sParticlelevel1 = 'particles/ui/status_levels/ui_status_level_1.vpcf';
        let sParticlelevel2 = 'particles/ui/status_levels/ui_status_level_2.vpcf';
        let sParticlelevel3 = 'particles/ui/status_levels/ui_status_level_3.vpcf';
        let sParticlelevel4 = 'particles/ui/status_levels/ui_status_level_4.vpcf';
        let sParticlelevel5 = 'particles/ui/status_levels/ui_status_level_5.vpcf';
        let sParticlelevel6 = 'particles/ui/status_levels/ui_status_level_6.vpcf';
        let sParticlelevel7 = 'particles/ui/status_levels/ui_status_level_7.vpcf';
        let sParticlelevel8 = 'particles/ui/status_levels/ui_status_level_8.vpcf';
        let aRank = [
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [0, 1, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [1, 1, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [2, 2, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [3, 3, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [4, 4, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [5, 5, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [1, 6, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [2, 7, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [3, 8, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [4, 9, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [5, 10, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [1, 11, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [2, 12, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [3, 13, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [4, 14, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [5, 15, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [1, 16, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [2, 17, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [3, 18, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [4, 19, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [5, 20, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [1, 21, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [2, 22, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [3, 23, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [4, 24, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [5, 25, 1], playEndcap: false },
            { particleName: sParticlelevel6, cpNumber: 3, cpValue: [1, 26, 1], playEndcap: false },
            { particleName: sParticlelevel6, cpNumber: 3, cpValue: [2, 27, 1], playEndcap: false },
            { particleName: sParticlelevel6, cpNumber: 3, cpValue: [3, 28, 1], playEndcap: false },
            { particleName: sParticlelevel6, cpNumber: 3, cpValue: [4, 29, 1], playEndcap: false },
            { particleName: sParticlelevel6, cpNumber: 3, cpValue: [5, 30, 1], playEndcap: false },
            { particleName: sParticlelevel7, cpNumber: 3, cpValue: [1, 31, 1], playEndcap: false },
            { particleName: sParticlelevel7, cpNumber: 3, cpValue: [2, 32, 1], playEndcap: false },
            { particleName: sParticlelevel7, cpNumber: 3, cpValue: [3, 33, 1], playEndcap: false },
            { particleName: sParticlelevel7, cpNumber: 3, cpValue: [4, 34, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [0, 35, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [1, 36, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [2, 37, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [3, 38, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [4, 39, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [5, 40, 1], playEndcap: false },
        ];
        return aRank[nRank];
    }
    RankSkillgroupParticles.GetRankParticleSettings = GetRankParticleSettings;
    function GetSkillGroupSettings(nSkillGroup, SkillGroupType) {
        let sParticlelevel0 = 'particles/ui/skillgroups/ui_skillgroup_1.vpcf';
        let sParticlelevel1 = 'particles/ui/skillgroups/ui_skillgroup_1.vpcf';
        let sParticlelevel2 = 'particles/ui/skillgroups/ui_skillgroup_2.vpcf';
        let sParticlelevel3 = 'particles/ui/skillgroups/ui_skillgroup_3.vpcf';
        let sParticlelevel4 = 'particles/ui/skillgroups/ui_skillgroup_4.vpcf';
        let sParticlelevel5 = 'particles/ui/skillgroups/ui_skillgroup_5.vpcf';
        let sParticlelevel6 = 'particles/ui/skillgroups/ui_skillgroup_6.vpcf';
        let sParticlelevel7 = 'particles/ui/skillgroups/ui_skillgroup_7.vpcf';
        let sParticlelevel8 = 'particles/ui/skillgroups/ui_skillgroup_8.vpcf';
        let sParticlelevel9 = 'particles/ui/skillgroups/ui_skillgroup_9.vpcf';
        let sParticlelevel10 = 'particles/ui/skillgroups/ui_skillgroup_10.vpcf';
        let sParticlelevel11 = 'particles/ui/skillgroups/ui_skillgroup_11.vpcf';
        let sParticlelevel12 = 'particles/ui/skillgroups/ui_skillgroup_12.vpcf';
        let sParticlelevel13 = 'particles/ui/skillgroups/ui_skillgroup_13.vpcf';
        let sParticlelevel14 = 'particles/ui/skillgroups/ui_skillgroup_14.vpcf';
        let sParticlelevel15 = 'particles/ui/skillgroups/ui_skillgroup_15.vpcf';
        let sParticlelevel16 = 'particles/ui/skillgroups/ui_skillgroup_16.vpcf';
        let sParticlelevel17 = 'particles/ui/skillgroups/ui_skillgroup_17.vpcf';
        let sParticlelevel18 = 'particles/ui/skillgroups/ui_skillgroup_18.vpcf';
        if (SkillGroupType === 'Wingman') {
            sParticlelevel0 = 'particles/ui/skillgroups/ui_skillgroup_wingman_0.vpcf';
            sParticlelevel1 = 'particles/ui/skillgroups/ui_skillgroup_wingman_1.vpcf';
            sParticlelevel2 = 'particles/ui/skillgroups/ui_skillgroup_wingman_2.vpcf';
            sParticlelevel3 = 'particles/ui/skillgroups/ui_skillgroup_wingman_3.vpcf';
            sParticlelevel4 = 'particles/ui/skillgroups/ui_skillgroup_wingman_4.vpcf';
            sParticlelevel5 = 'particles/ui/skillgroups/ui_skillgroup_wingman_5.vpcf';
            sParticlelevel6 = 'particles/ui/skillgroups/ui_skillgroup_wingman_6.vpcf';
            sParticlelevel7 = 'particles/ui/skillgroups/ui_skillgroup_wingman_7.vpcf';
            sParticlelevel8 = 'particles/ui/skillgroups/ui_skillgroup_wingman_8.vpcf';
            sParticlelevel9 = 'particles/ui/skillgroups/ui_skillgroup_wingman_9.vpcf';
            sParticlelevel10 = 'particles/ui/skillgroups/ui_skillgroup_wingman_10.vpcf';
            sParticlelevel11 = 'particles/ui/skillgroups/ui_skillgroup_wingman_11.vpcf';
            sParticlelevel12 = 'particles/ui/skillgroups/ui_skillgroup_wingman_12.vpcf';
            sParticlelevel13 = 'particles/ui/skillgroups/ui_skillgroup_wingman_13.vpcf';
            sParticlelevel14 = 'particles/ui/skillgroups/ui_skillgroup_wingman_14.vpcf';
            sParticlelevel15 = 'particles/ui/skillgroups/ui_skillgroup_wingman_15.vpcf';
            sParticlelevel16 = 'particles/ui/skillgroups/ui_skillgroup_wingman_16.vpcf';
            sParticlelevel17 = 'particles/ui/skillgroups/ui_skillgroup_wingman_17.vpcf';
            sParticlelevel18 = 'particles/ui/skillgroups/ui_skillgroup_wingman_18.vpcf';
        }
        else if (SkillGroupType === 'Premier') {
            sParticlelevel0 = 'particles/dev/empty.vpcf';
            sParticlelevel1 = 'particles/dev/empty.vpcf';
            sParticlelevel2 = 'particles/dev/empty.vpcf';
            sParticlelevel3 = 'particles/dev/empty.vpcf';
            sParticlelevel4 = 'particles/dev/empty.vpcf';
            sParticlelevel5 = 'particles/dev/empty.vpcf';
            sParticlelevel6 = 'particles/dev/empty.vpcf';
            sParticlelevel7 = 'particles/dev/empty.vpcf';
            sParticlelevel8 = 'particles/dev/empty.vpcf';
            sParticlelevel9 = 'particles/dev/empty.vpcf';
            sParticlelevel10 = 'particles/dev/empty.vpcf';
            sParticlelevel11 = 'particles/dev/empty.vpcf';
            sParticlelevel12 = 'particles/dev/empty.vpcf';
            sParticlelevel13 = 'particles/dev/empty.vpcf';
            sParticlelevel14 = 'particles/dev/empty.vpcf';
            sParticlelevel15 = 'particles/dev/empty.vpcf';
            sParticlelevel16 = 'particles/dev/empty.vpcf';
            sParticlelevel17 = 'particles/dev/empty.vpcf';
            sParticlelevel18 = 'particles/dev/empty.vpcf';
        }
        let aSkillGroup = [
            { particleName: sParticlelevel0, cpNumber: 3, cpValue: [1, 0, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [1, 1, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [2, 2, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [3, 3, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [4, 4, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [5, 5, 1], playEndcap: false },
            { particleName: sParticlelevel6, cpNumber: 3, cpValue: [6, 6, 1], playEndcap: false },
            { particleName: sParticlelevel7, cpNumber: 3, cpValue: [7, 7, 1], playEndcap: false },
            { particleName: sParticlelevel8, cpNumber: 3, cpValue: [1, 8, 1], playEndcap: false },
            { particleName: sParticlelevel9, cpNumber: 3, cpValue: [2, 9, 1], playEndcap: false },
            { particleName: sParticlelevel10, cpNumber: 3, cpValue: [3, 10, 1], playEndcap: false },
            { particleName: sParticlelevel11, cpNumber: 3, cpValue: [4, 11, 1], playEndcap: false },
            { particleName: sParticlelevel12, cpNumber: 3, cpValue: [6, 12, 1], playEndcap: false },
            { particleName: sParticlelevel13, cpNumber: 3, cpValue: [6, 13, 1], playEndcap: false },
            { particleName: sParticlelevel14, cpNumber: 3, cpValue: [6, 14, 1], playEndcap: false },
            { particleName: sParticlelevel15, cpNumber: 3, cpValue: [6, 15, 1], playEndcap: false },
            { particleName: sParticlelevel16, cpNumber: 3, cpValue: [6, 16, 1], playEndcap: false },
            { particleName: sParticlelevel17, cpNumber: 3, cpValue: [6, 17, 1], playEndcap: false },
            { particleName: sParticlelevel18, cpNumber: 3, cpValue: [6, 18, 1], playEndcap: false },
            { particleName: sParticlelevel18, cpNumber: 3, cpValue: [6, 19, 1], playEndcap: false },
        ];
        return aSkillGroup[Math.min(nSkillGroup, aSkillGroup.length - 1)];
    }
    RankSkillgroupParticles.GetSkillGroupSettings = GetSkillGroupSettings;
    function GetSkillGroupAmbientSettings(nSkillGroup, SkillGroupType) {
        let sParticlelevel0 = 'particles/ui/skillgroups/ui_skillgroup_rear_1.vpcf';
        let sParticlelevel1 = 'particles/ui/skillgroups/ui_skillgroup_rear_1.vpcf';
        let sParticlelevel2 = 'particles/ui/skillgroups/ui_skillgroup_rear_2.vpcf';
        let sParticlelevel3 = 'particles/ui/skillgroups/ui_skillgroup_rear_3.vpcf';
        let sParticlelevel4 = 'particles/ui/skillgroups/ui_skillgroup_rear_4.vpcf';
        let sParticlelevel5 = 'particles/ui/skillgroups/ui_skillgroup_rear_5.vpcf';
        if (SkillGroupType === 'Wingman') {
            sParticlelevel0 = 'particles/ui/skillgroups/ui_skillgroup_wingman_rear_1.vpcf';
            sParticlelevel1 = 'particles/ui/skillgroups/ui_skillgroup_wingman_rear_1.vpcf';
            sParticlelevel2 = 'particles/ui/skillgroups/ui_skillgroup_wingman_rear_2.vpcf';
            sParticlelevel3 = 'particles/ui/skillgroups/ui_skillgroup_wingman_rear_3.vpcf';
            sParticlelevel4 = 'particles/ui/skillgroups/ui_skillgroup_wingman_rear_4.vpcf';
            sParticlelevel5 = 'particles/ui/skillgroups/ui_skillgroup_wingman_rear_5.vpcf';
        }
        else if (SkillGroupType === 'Premier') {
            sParticlelevel0 = 'particles/dev/empty.vpcf';
            sParticlelevel1 = 'particles/dev/empty.vpcf';
            sParticlelevel2 = 'particles/dev/empty.vpcf';
            sParticlelevel3 = 'particles/dev/empty.vpcf';
            sParticlelevel4 = 'particles/dev/empty.vpcf';
            sParticlelevel5 = 'particles/dev/empty.vpcf';
        }
        let aSkillGroup = [
            { particleName: sParticlelevel0, cpNumber: 3, cpValue: [1, 0, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [1, 1, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [2, 2, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [3, 3, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [4, 4, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [5, 5, 1], playEndcap: false },
            { particleName: sParticlelevel1, cpNumber: 3, cpValue: [6, 6, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [1, 7, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [2, 8, 1], playEndcap: false },
            { particleName: sParticlelevel2, cpNumber: 3, cpValue: [3, 9, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [4, 10, 1], playEndcap: false },
            { particleName: sParticlelevel3, cpNumber: 3, cpValue: [5, 11, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [1, 12, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [2, 13, 1], playEndcap: false },
            { particleName: sParticlelevel4, cpNumber: 3, cpValue: [3, 14, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [1, 15, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [2, 16, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [6, 17, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [1, 18, 1], playEndcap: false },
            { particleName: sParticlelevel5, cpNumber: 3, cpValue: [2, 19, 1], playEndcap: false },
        ];
        return aSkillGroup[Math.min(nSkillGroup, aSkillGroup.length - 1)];
    }
    RankSkillgroupParticles.GetSkillGroupAmbientSettings = GetSkillGroupAmbientSettings;
})(RankSkillgroupParticles || (RankSkillgroupParticles = {}));
