"use strict";
/// <reference path="../csgo.d.ts" />
var HoldButton;
(function (HoldButton) {
    let m_LoopingSounds = {};
    let _m_btnSettings = {
        holdTimer: 0,
        holdTimeMax: 10,
        holdTimerHandle: null,
        isButtonPressed: false
    };
    function StartLoopingSound(s) {
        if (!s)
            return;
        if (m_LoopingSounds[s] !== undefined)
            return;
        m_LoopingSounds[s] = UiToolkitAPI.PlaySoundEvent(s);
    }
    HoldButton.StartLoopingSound = StartLoopingSound;
    function StopLoopingSound(s) {
        if (!s)
            return;
        if (m_LoopingSounds[s] === undefined)
            return;
        UiToolkitAPI.StopSoundEvent(m_LoopingSounds[s], 0);
        m_LoopingSounds[s] = undefined;
    }
    HoldButton.StopLoopingSound = StopLoopingSound;
    function SetupButton(settings) {
        if (!settings.btn)
            return;
        if ('tooltip' in settings && settings.tooltip !== '') {
            settings.btn.SetPanelEvent('onmouseover', () => {
                if (settings.btn.enabled) {
                    UiToolkitAPI.ShowTextTooltipStyled(settings.btn.id, settings.tooltip, ('tooltipStyle' in settings) ? settings.tooltipStyle : '');
                }
            });
            settings.btn.SetPanelEvent('onmouseout', () => { UiToolkitAPI.HideTextTooltip(); });
        }
        settings.btn.SetDialogVariable('action-label', $.Localize(settings.locString));
        settings.btn.SetPanelEvent('onmouseup', () => _OnMouseUp(settings));
        settings.btn.SetPanelEvent('onmousedown', () => _OnMouseDown(settings));
    }
    HoldButton.SetupButton = SetupButton;
    function _OnMouseUp(settings) {
        CancelButtonTimer(settings);
        _m_btnSettings.isButtonPressed = false;
        _m_btnSettings.holdTimer = 0;
        settings.btn.FindChild('id-response-btn-timer').visible = false;
        settings.btn.FindChild('id-response-btn-timer').style.width = '0%;';
        if ('mouseUpAction' in settings)
            settings.mouseUpAction();
    }
    function _OnMouseDown(settings) {
        CancelButtonTimer(settings);
        _m_btnSettings.isButtonPressed = true;
        _m_btnSettings.holdTimer = 0;
        IncrementButtonTimer(settings);
    }
    function CancelButtonTimer(settings) {
        if (_m_btnSettings.holdTimerHandle !== null) {
            $.CancelScheduled(_m_btnSettings.holdTimerHandle);
            if ('cancelTimerAction' in settings) {
                settings.cancelTimerAction();
            }
            StopLoopingSound(settings.loopingSound);
            _m_btnSettings.holdTimerHandle = null;
        }
    }
    function IncrementButtonTimer(settings) {
        ++_m_btnSettings.holdTimer;
        if (_m_btnSettings.holdTimer <= _m_btnSettings.holdTimeMax && _m_btnSettings.isButtonPressed) {
            settings.btn.FindChild('id-response-btn-timer').visible = true;
            settings.btn.FindChild('id-response-btn-timer').style.width = (_m_btnSettings.holdTimer * 10) + '%;';
            if (_m_btnSettings.holdTimerHandle == null) {
                _m_btnSettings.holdTimerHandle = $.Schedule(.1, () => IncrementButtonTimer(settings));
                StartLoopingSound(settings.loopingSound);
            }
            else {
                $.Schedule(.1, () => IncrementButtonTimer(settings));
            }
            return;
        }
        if (_m_btnSettings.isButtonPressed) {
            if ('timerCompleteAction' in settings)
                settings.timerCompleteAction();
        }
        _OnMouseUp(settings);
    }
})(HoldButton || (HoldButton = {}));
