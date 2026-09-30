"use strict";
/// <reference path="../csgo.d.ts" />
var HudInstructor;
(function (HudInstructor) {
    function ShowBinding(elLesson, hLocator, i) {
        if (elLesson.BHasClass('hidden')) {
            HideBindings(elLesson);
            return;
        }
        let bindingTexture = 'icon_key_wide';
        let bindingText = '#GameUI_Icons_NONE';
        const binding = $.GetContextPanel().GetBinding(hLocator, i).toUpperCase();
        if (binding != '') {
            bindingText = '';
            if (binding === 'MOUSE1') {
                bindingTexture = 'icon_mouseLeft';
            }
            else if (binding === 'MOUSE2') {
                bindingTexture = 'icon_mouseRight';
            }
            else if (binding === 'MOUSE3') {
                bindingTexture = 'icon_mouseThree';
            }
            else if (binding === 'MWHEELUP') {
                bindingTexture = 'icon_mouseWheel_up';
            }
            else if (binding === 'MWHEELDOWN') {
                bindingTexture = 'icon_mouseWheel_down';
            }
            else if (binding === 'UPARROW') {
                bindingTexture = 'icon_key_up';
            }
            else if (binding === 'LEFTARROW') {
                bindingTexture = 'icon_key_left';
            }
            else if (binding === 'DOWNARROW') {
                bindingTexture = 'icon_key_down';
            }
            else if (binding === 'RIGHTARROW') {
                bindingTexture = 'icon_key_right';
            }
            else if (binding === 'SEMICOLON') {
                bindingTexture = 'icon_key_generic';
                bindingText = ';';
            }
            else if (binding.length <= 3) {
                bindingTexture = 'icon_key_generic';
                bindingText = binding;
            }
            else {
                bindingTexture = 'icon_key_wide';
                bindingText = binding;
            }
            const elBindingLabel = elLesson.FindChildTraverse('LocatorBindingText');
            const bShowBindingText = (bindingText != '');
            elLesson.SetHasClass('ShowBindingText', bShowBindingText);
            if (bShowBindingText) {
                elBindingLabel.text = $.Localize(bindingText);
            }
            elLesson.SwitchClass('BindingIcon', bindingTexture);
            if (elLesson.bindingCount && elLesson.bindingCount > 1) {
                let iNext = i + 1;
                if (iNext == elLesson.bindingCount) {
                    iNext = 0;
                }
                elLesson.animhandle = $.Schedule(.75, () => ShowBinding(elLesson, hLocator, iNext));
            }
        }
    }
    function HideBindings(elLesson) {
        if (elLesson.animhandle) {
            $.CancelScheduled(elLesson.animhandle);
            elLesson.animhandle = undefined;
        }
        elLesson.SetHasClass('ShowBindingText', false);
        elLesson.SwitchClass('BindingIcon', 'none');
    }
    function OnShowBindingsEvent(elLesson, hLocator, bindingCount) {
        HideBindings(elLesson);
        elLesson.bindingCount = bindingCount;
        ShowBinding(elLesson, hLocator, 0);
    }
    function OnHideBindingsEvent(elLesson) {
        HideBindings(elLesson);
    }
    {
        $.RegisterEventHandler('CSGOHudInstructorShowBindings', $.GetContextPanel(), OnShowBindingsEvent);
        $.RegisterEventHandler('CSGOHudInstructorHideBindings', $.GetContextPanel(), OnHideBindingsEvent);
    }
})(HudInstructor || (HudInstructor = {}));
