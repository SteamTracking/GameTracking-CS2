"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="mock_adapter.ts" />
/// <reference path="rank_skillgroup_particles.ts" />
/// <reference path="endofmatch.ts" />
var EOM_Skillgroup;
(function (EOM_Skillgroup) {
    let _m_pauseBeforeEnd = 1.5;
    let _m_cP = $.GetContextPanel();
    _m_cP.Data().m_retries = 0;
    function _DisplayMe() {
        if (!_m_cP || !_m_cP.IsValid())
            return false;
        _Reset();
        if (!MockAdapter.bSkillgroupDataReady(_m_cP))
            return false;
        if (MyPersonaAPI.GetElevatedState() !== 'elevated')
            return false;
        let oSkillgroupData = MockAdapter.SkillgroupDataJSO(_m_cP);
        let localPlayerUpdate = oSkillgroupData[MockAdapter.GetLocalPlayerXuid()];
        if (!localPlayerUpdate)
            return false;
        const rating_mismatch = localPlayerUpdate.new_rank - localPlayerUpdate.old_rank != localPlayerUpdate.rank_change &&
            localPlayerUpdate.old_rank != 0;
        let oData = {
            current_rating: localPlayerUpdate.new_rank,
            num_wins: localPlayerUpdate.num_wins,
            old_rating: rating_mismatch ? 0 : localPlayerUpdate.old_rank,
            old_rating_info: '',
            old_rating_desc: '',
            old_image: '',
            new_rating: localPlayerUpdate.new_rank,
            new_rating_info: '',
            new_rating_desc: '',
            new_image: '',
            rating_change: localPlayerUpdate.rank_change,
            rating_mismatch: rating_mismatch,
            mode: localPlayerUpdate.rank_type,
            model: ''
        };
        let current_rating = Math.max(Number(oData.new_rating), Number(oData.old_rating));
        let winsNeededForRank = SessionUtil.GetNumWinsNeededForRank(oData.mode);
        let matchesNeeded = winsNeededForRank - oData.num_wins;
        _m_cP.SetDialogVariable('rating_type', $.Localize('#SFUI_GameMode' + oData.mode));
        _m_cP.SetDialogVariable('map', GameStateAPI.GetMapName());
        if (current_rating < 1 && matchesNeeded <= 0) {
            switch (oData.mode) {
                case 'Wingman':
                case 'Competitive':
                    let modePrefix = (oData.mode === 'Wingman') ? 'wingman' : 'skillgroup';
                    oData.old_rating_info = $.Localize('#eom-skillgroup-expired', _m_cP);
                    oData.old_image = 'file://{images}/icons/skillgroups/' + modePrefix + '_expired.svg';
                    break;
                case 'Premier':
                    oData.old_rating_info = $.Localize('#eom-skillgroup-expired', _m_cP);
                    break;
            }
        }
        else if (current_rating < 1) {
            _m_cP.SetDialogVariableInt('winsneeded', matchesNeeded);
            switch (oData.mode) {
                case 'Wingman':
                case 'Competitive':
                    let modePrefix = (oData.mode === 'Wingman') ? 'wingman' : 'skillgroup';
                    oData.old_rating_info = $.Localize('#eom-skillgroup-needed-wins:f', _m_cP);
                    oData.old_image = 'file://{images}/icons/skillgroups/' + modePrefix + '0.svg';
                    break;
                case 'Premier':
                    break;
            }
        }
        else if (current_rating >= 1) {
            let skillgroupDescString = '';
            switch (oData.mode) {
                case 'Wingman':
                case 'Premier':
                    skillgroupDescString = '#eom-skillgroup-name';
                    break;
                case 'Competitive':
                    skillgroupDescString = '#eom-skillgroup-map-name';
                    break;
            }
            switch (oData.mode) {
                case 'Wingman':
                case 'Competitive':
                    let modePrefix = (oData.mode === 'Wingman') ? 'wingman' : 'skillgroup';
                    oData.old_image = 'file://{images}/icons/skillgroups/' + modePrefix + oData.old_rating + '.svg';
                    oData.old_rating_info = $.Localize('#RankName_' + oData.old_rating);
                    oData.old_rating_desc = $.Localize(skillgroupDescString, _m_cP);
                    if (oData.old_rating < oData.new_rating) {
                        oData.new_image = 'file://{images}/icons/skillgroups/' + modePrefix + oData.new_rating + '.svg';
                        oData.new_rating_info = $.Localize('#RankName_' + oData.new_rating);
                        oData.new_rating_desc = $.Localize(skillgroupDescString, _m_cP);
                        _m_pauseBeforeEnd = 3.0;
                        _LoadAndShowNewRankReveal(oData);
                    }
                    break;
                case 'Premier':
                    if (oData.old_rating !== oData.new_rating) {
                        _m_pauseBeforeEnd = 5.0;
                        _LoadAndShowNewRankReveal(oData);
                    }
                    break;
            }
            _m_cP.SetHasClass('rating-mismatch', oData.rating_mismatch);
        }
        if (oData.mode === 'Premier') {
            _FilloutPremierRankData(oData);
            _m_cP.FindChildInLayoutFile('id-eom-skillgroup-premier-bg').SwitchClass('tier', RatingEmblem.GetTierColorClass(_m_cP.FindChildInLayoutFile('jsRatingEmblem')));
        }
        else {
            _FilloutRankData(oData);
        }
        _m_cP.FindChildInLayoutFile('id-eom-skillgroup-bg').SetHasClass('hide', oData.mode === 'Premier');
        _m_cP.FindChildInLayoutFile('id-eom-skillgroup-premier-bg').SetHasClass('hide', oData.mode !== 'Premier');
        _m_cP.AddClass('eom-skillgroup-show');
        return true;
    }
    ;
    function _LoadAndShowNewRankReveal(oData) {
        $.Schedule(1, () => _RevealNewIcon(oData));
    }
    function _RevealNewIcon(oData) {
        if (!_m_cP || !_m_cP.IsValid())
            return;
        if (oData.mode === 'Competitive' || oData.mode === 'Wingman') {
            _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem--new__image').SetImage(oData.new_image);
            _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem').AddClass("uprank-anim");
            _m_cP.SetDialogVariable('rank-info', oData.new_rating_info);
            let elParticleFlare = _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem--new__pfx--above');
            let aParticleSettings = RankSkillgroupParticles.GetSkillGroupSettings(oData.new_rating, oData.mode);
            elParticleFlare.SetParticleNameAndRefresh(aParticleSettings.particleName);
            elParticleFlare.SetControlPoint(aParticleSettings.cpNumber, aParticleSettings.cpValue[0], aParticleSettings.cpValue[1], 1);
            elParticleFlare.StartParticles();
            let elParticleAmb = _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem--new__pfx--below');
            let aParticleAmbSettings = RankSkillgroupParticles.GetSkillGroupAmbientSettings(oData.new_rating, oData.mode);
            elParticleAmb.SetParticleNameAndRefresh(aParticleAmbSettings.particleName);
            elParticleAmb.SetControlPoint(aParticleAmbSettings.cpNumber, aParticleAmbSettings.cpValue[0], aParticleAmbSettings.cpValue[1], 1);
            elParticleAmb.StartParticles();
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.XP.NewSkillGroup', 'MOUSE');
        }
        else if (oData.mode === 'Premier') {
            let options = {
                root_panel: _m_cP.FindChildInLayoutFile('jsRatingEmblem'),
                leaderboard_details: { score: oData.new_rating, matchesWon: oData.num_wins },
                do_fx: false,
                presentation: 'digital',
                eom_digipanel_class_override: GetEmblemStyleOverride(oData.new_rating),
                full_details: true,
                rating_type: "Premier",
                local_player: true
            };
            let winLossStyle = GetWinLossStyle(oData);
            _m_cP.FindChildInLayoutFile('jsRatingEmblem').SwitchClass('winloss', winLossStyle + '-anim');
            PremierRankText(oData);
            SpeedLinesAnim(winLossStyle);
            RatingEmblemAnim(oData, options, winLossStyle);
        }
    }
    function _Reset() {
        let elDesc = _m_cP.FindChildInLayoutFile("id-eom-skillgroup__current_wins_desc");
        elDesc.text = '';
        _m_cP.SetDialogVariable('total-wins', '');
        _m_cP.SetDialogVariable('rank-info', '');
        let elRankDesc = _m_cP.FindChildInLayoutFile("id-eom-skillgroup__current__title");
        elRankDesc.AddClass('hidden');
        elRankDesc.text = '';
        let elImage = _m_cP.FindChildInLayoutFile("id-eom-skillgroup-emblem--current__image");
        elImage.AddClass('hidden');
        elImage.SetImage('');
        _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem--new__image').SetImage('');
        _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem').RemoveClass("uprank-anim");
        _m_cP.RemoveClass('eom-skillgroup-show');
        let elParticleFlare = _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem--new__pfx--above');
        elParticleFlare.StopParticlesImmediately(true);
        let elParticleAmb = _m_cP.FindChildInLayoutFile('id-eom-skillgroup-emblem--new__pfx--below');
        elParticleAmb.StopParticlesImmediately(true);
        _m_cP.RemoveClass('rating-mismatch');
    }
    function _FilloutRankData(oData) {
        SetWinDescString(oData, _m_cP.FindChildInLayoutFile("id-eom-skillgroup__current_wins_desc"));
        _m_cP.SetDialogVariable('total-wins', oData.num_wins.toString());
        _m_cP.SetDialogVariable('rank-info', oData.old_rating_info);
        let elRankDesc = _m_cP.FindChildInLayoutFile("id-eom-skillgroup__current__title");
        if (oData.old_rating_desc) {
            elRankDesc.RemoveClass('hidden');
            elRankDesc.text = oData.old_rating_desc;
        }
        if (oData.mode === 'Competitive' || oData.mode === 'Wingman') {
            let elImage = _m_cP.FindChildInLayoutFile("id-eom-skillgroup-emblem--current__image");
            elImage.RemoveClass('hidden');
            elImage.SetImage(oData.old_image);
            let elParticleFlare = _m_cP.FindChildInLayoutFile('id-eom-skillgroup--current__pfx--above');
            let aParticleSettings = RankSkillgroupParticles.GetSkillGroupSettings(oData.old_rating, oData.mode);
            elParticleFlare.SetParticleNameAndRefresh(aParticleSettings.particleName);
            elParticleFlare.SetControlPoint(aParticleSettings.cpNumber, aParticleSettings.cpValue[0], aParticleSettings.cpValue[1], 0);
            elParticleFlare.StartParticles();
            let elParticleAmb = _m_cP.FindChildInLayoutFile('id-eom-skillgroup--current__pfx--below');
            let aParticleAmbSettings = RankSkillgroupParticles.GetSkillGroupAmbientSettings(oData.old_rating, oData.mode);
            elParticleAmb.SetParticleNameAndRefresh(aParticleAmbSettings.particleName);
            elParticleAmb.SetControlPoint(aParticleAmbSettings.cpNumber, aParticleAmbSettings.cpValue[0], aParticleAmbSettings.cpValue[1], 0);
            elParticleAmb.StartParticles();
        }
    }
    function GetEmblemStyleOverride(new_rating) {
        return new_rating < 1000 ? 'digitpanel-container-3-digit-offset' : new_rating < 10000 ? 'digitpanel-container-4-digit-offset' : '';
    }
    function _FilloutPremierRankData(oData) {
        const options = {
            root_panel: _m_cP.FindChildInLayoutFile('jsRatingEmblem'),
            leaderboard_details: { score: oData.old_rating, matchesWon: oData.num_wins },
            do_fx: false,
            rating_type: oData.mode,
            presentation: 'digital',
            eom_digipanel_class_override: GetEmblemStyleOverride(oData.old_rating),
            full_details: true,
            local_player: true
        };
        if (oData.rating_change === 0) {
            RatingEmblem.SetXuid(options);
            let winLossStyle = GetWinLossStyle(oData);
            _m_cP.FindChildInLayoutFile('jsRatingEmblem').SwitchClass('winloss', winLossStyle + '-anim');
            PremierRankText(oData);
            SpeedLinesAnim(winLossStyle);
            RatingEmblemAnim(oData, options, winLossStyle);
            return;
        }
        RatingEmblem.SetXuid(options);
    }
    function PremierRankText(oData) {
        SetWinDescString(oData, _m_cP.FindChildInLayoutFile("id-eom-skillgroup-premier-wins-desc"));
        _m_cP.SetDialogVariable('total-wins', oData.num_wins.toString());
        let desc;
        let nPoints;
        if (oData.new_rating > 0 && oData.old_rating < 1) {
            desc = $.Localize('#cs_rating_rating_established');
            nPoints = 0;
        }
        else {
            desc = RatingEmblem.GetEomDescText(_m_cP.FindChildInLayoutFile('jsRatingEmblem'));
            nPoints = Math.abs(oData.rating_change);
        }
        if (oData.rating_mismatch) {
            _m_cP.SetDialogVariable('premier-desc', $.Localize('#cs_rating_mismatch'));
        }
        else if (desc && desc !== '') {
            _m_cP.SetDialogVariable('premier-desc', desc);
        }
        _m_cP.FindChildInLayoutFile('id-eom-skillgroup-premier-desc').SetHasClass('hide', desc === '' || !desc);
        let sPointsString = '';
        sPointsString = oData.new_rating >= oData.old_rating ? "#eom-premier-points-gained" : "#eom-premier-points-lost";
        _m_cP.SetDialogVariableInt('premier_points', nPoints);
        _m_cP.FindChildInLayoutFile('id-eom-skillgroup-premier-points').text = $.Localize(sPointsString, _m_cP);
    }
    function GetWinLossStyle(oData) {
        let winLossStyle = ((oData.new_rating === 0) || (oData.new_rating > 0 && oData.old_rating < 1) || !oData.rating_change) ?
            'no-points' : oData.rating_change < 0 ?
            'lost-points' : oData.rating_change > 0 ?
            'gain-points' : '';
        return winLossStyle;
    }
    function SpeedLinesAnim(winLossStyle) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'UI.Premier.EOM.SlideIn', 'MOUSE');
        $.Schedule(.25, () => {
            if (!_m_cP || !_m_cP.IsValid())
                return;
            let speedLines = _m_cP.FindChildInLayoutFile('id-eom-premier-speed-lines');
            if (speedLines && speedLines.IsValid()) {
                speedLines.SetMovie("file://{resources}/videos/speed_lines.webm");
                speedLines.SwitchClass('winloss', winLossStyle);
                speedLines.SetControls('none');
                speedLines.Play();
            }
        });
    }
    function RatingEmblemAnim(oData, options, winLossStyle) {
        PlayPremierRankSound(winLossStyle);
        $.Schedule(.75, () => {
            if (!elPanel || !elPanel.IsValid() || !options.root_panel || !options.root_panel.IsValid())
                return;
            RatingEmblem.SetXuid(options);
            PremierRankText(oData);
            elPanel.SwitchClass('tier', RatingEmblem.GetTierColorClass(_m_cP.FindChildInLayoutFile('jsRatingEmblem')));
        });
        let elPanel = _m_cP.FindChildInLayoutFile('id-eom-skillgroup-premier-bg');
        elPanel.SwitchClass('winloss', winLossStyle);
    }
    function PlayPremierRankSound(winLossStyle) {
        if (winLossStyle === 'no-points') {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.Premier.EOM.RankNeutral', 'MOUSE');
        }
        else if (winLossStyle === 'lost-points') {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.Premier.EOM.RankDown', 'MOUSE');
        }
        else {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.Premier.EOM.RankUp', 'MOUSE');
        }
    }
    function SetWinDescString(oData, elLabel) {
        elLabel.SetDialogVariableInt("matcheswon", oData.num_wins);
        switch (oData.mode) {
            case 'Competitive':
                elLabel.text = $.Localize('#eom-skillgroup-map-win:f', elLabel);
                break;
            case 'Wingman':
            case 'Premier':
                elLabel.text = $.Localize('#eom-skillgroup-win:f', elLabel);
                break;
        }
    }
    function Start() {
        if (_DisplayMe()) {
            EndOfMatch.SwitchToPanel('eom-skillgroup');
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
            name: 'eom-skillgroup',
            Start: Start,
            Shutdown: Shutdown
        });
    }
})(EOM_Skillgroup || (EOM_Skillgroup = {}));
