"use strict";
/// <reference path="csgo.d.ts" />
var MuteSpinner;
(function (MuteSpinner) {
    let m_curVal;
    let m_isMuted;
    let m_hFadeOutMuteBar = undefined;
    function HasXuid(elPanel) {
        return 'xuid' in elPanel;
    }
    function ToggleMute() {
        let elSpinner = $.GetContextPanel().FindChildTraverse('id-mute-spinner');
        const elParent = $.GetContextPanel().GetParent();
        if (HasXuid(elParent)) {
            let xuid = elParent.xuid;
            GameStateAPI.ToggleMute(xuid);
            UpdateVolumeDisplay();
        }
    }
    MuteSpinner.ToggleMute = ToggleMute;
    function _GetCurrentValues() {
        const elParent = $.GetContextPanel().GetParent();
        if (HasXuid(elParent)) {
            let xuid = elParent.xuid;
            m_curVal = GameStateAPI.GetPlayerVoiceVolume(xuid).toFixed(2);
            m_isMuted = GameStateAPI.IsSelectedPlayerMuted(xuid);
            let locMsg = GameStateAPI.HasCommunicationBan(xuid) ? '#tooltip_cannot_unmute' : '#tooltip_mute';
            $.GetContextPanel().SetDialogVariableLocString('mute_tooltip_message', locMsg);
            if (m_isMuted === undefined)
                m_isMuted = false;
        }
    }
    function _OnValueChanged(panel, flNewVal) {
        const elParent = $.GetContextPanel().GetParent();
        if (HasXuid(elParent)) {
            let xuid = elParent.xuid;
            let sNewVal = flNewVal.toFixed(2);
            _GetCurrentValues();
            if (m_curVal != sNewVal) {
                GameStateAPI.SetPlayerVoiceVolume(xuid, Number(sNewVal));
                UpdateVolumeDisplay();
                let elMuteBar = $.GetContextPanel().FindChildTraverse('id-mute-bar');
                if (elMuteBar) {
                    elMuteBar.RemoveClass("fade");
                    elMuteBar.style.height = Number(m_curVal) * 100 + "%";
                    if (m_hFadeOutMuteBar != undefined)
                        $.CancelScheduled(m_hFadeOutMuteBar);
                    m_hFadeOutMuteBar = $.Schedule(0.5, () => {
                        elMuteBar.AddClass("fade");
                        m_hFadeOutMuteBar = undefined;
                    });
                }
            }
        }
    }
    function UpdateVolumeDisplay() {
        _GetCurrentValues();
        $.GetContextPanel().SetDialogVariable('value', (Number(m_curVal) * 100).toFixed(0));
        let elSpinner = $.GetContextPanel().FindChildTraverse('id-mute-spinner');
        let elSpinnerBar = $.GetContextPanel().FindChildTraverse('id-mute-bar');
        if (!elSpinnerBar || !elSpinnerBar.IsValid())
            return;
        let elSpinnerLabel = $.GetContextPanel().FindChildTraverse('id-mute-value');
        if (!elSpinnerLabel || !elSpinnerLabel.IsValid())
            return;
        let elMutedImage = $.GetContextPanel().FindChildTraverse('id-mute-muted-img');
        if (!elMutedImage || !elMutedImage.IsValid())
            return;
        if (m_isMuted) {
            elMutedImage.RemoveClass("hidden");
            elSpinnerLabel.AddClass("hidden");
            elSpinnerBar.AddClass("hidden");
            elSpinner.AddClass('muted');
        }
        else {
            elMutedImage.AddClass("hidden");
            elSpinnerLabel.RemoveClass("hidden");
            elSpinnerBar.RemoveClass("hidden");
            elSpinner.RemoveClass('muted');
        }
        elSpinner.spinlock = m_isMuted;
    }
    MuteSpinner.UpdateVolumeDisplay = UpdateVolumeDisplay;
    {
        $.RegisterEventHandler("SpinnerValueChanged", $.GetContextPanel(), _OnValueChanged);
    }
})(MuteSpinner || (MuteSpinner = {}));
