"use strict";
/// <reference path="../csgo.d.ts" />
var AddMajorTokensAnim;
(function (AddMajorTokensAnim) {
    function SetTransitionEndEvent(elPanel) {
        if (!elPanel.Data().PropertyTransitionEndHandler) {
            function fnOnPropertyTransitionEndEventNotifications(panel, propertyName) {
                if (elPanel === panel && propertyName === 'opacity') {
                    if (elPanel.visible === true && elPanel.BIsTransparent()) {
                        elPanel.visible = false;
                        return true;
                    }
                }
                return false;
            }
            elPanel.Data().PropertyTransitionEndHandler = $.RegisterEventHandler('PropertyTransitionEnd', elPanel, fnOnPropertyTransitionEndEventNotifications);
        }
    }
    AddMajorTokensAnim.SetTransitionEndEvent = SetTransitionEndEvent;
    function StartAnim(elPanel, elBalance, nCredits, CallAtEndAnimation) {
        elPanel.TriggerClass('add_major_tokens__amount-anim');
        elPanel.SetHasClass('hide-particles', false);
        elPanel.SetDialogVariableInt('credits', nCredits);
        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.XP.NewSkillGroup', 'MOUSE');
        let elCredits = elPanel.FindChildInLayoutFile('id-major-store-add-tokens-credits');
        if (!elCredits) {
            elCredits = $.CreatePanel('Panel', elPanel, 'id-major-store-add-tokens-credits');
            elCredits.BLoadLayoutSnippet('credits-text');
        }
        $.Schedule(1.5, () => {
            const balancePos = elBalance.GetPositionWithinWindow();
            const notificationPos = elPanel.GetPositionWithinWindow();
            const newXPos = Math.floor(balancePos.x / elPanel.actualuiscale_x - notificationPos.x / elPanel.actualuiscale_x) - Math.floor((elPanel.actuallayoutwidth / elPanel.actualuiscale_x) / 2.0);
            const newYPos = Math.floor(balancePos.y / elPanel.actualuiscale_y - notificationPos.y / elPanel.actualuiscale_y) - Math.floor((elPanel.actuallayoutheight / elPanel.actualuiscale_y) / 2.05);
            elCredits.SetPositionInPixels(newXPos, newYPos, 0);
            elCredits.style.preTransformScale2d = '.4;';
            elPanel.SetHasClass('hide-particles', true);
            $.Schedule(1, () => {
                CallAtEndAnimation();
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_claim', 'MOUSE');
                elCredits.DeleteAsync(0);
            });
        });
    }
    AddMajorTokensAnim.StartAnim = StartAnim;
})(AddMajorTokensAnim || (AddMajorTokensAnim = {}));
