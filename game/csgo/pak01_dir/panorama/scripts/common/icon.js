"use strict";
/// <reference path="../csgo.d.ts" />
var IconUtil;
(function (IconUtil) {
    function SetPNGImageFallback(mapIconDetails, icon_image_path) {
        if (mapIconDetails.m_type == 'svg') {
            mapIconDetails.m_type = 'png';
            mapIconDetails.m_icon.SetImage(icon_image_path + '.png');
        }
        else {
            mapIconDetails.m_icon.SetImage('file://{images}/map_icons/map_icon_NONE.png');
        }
    }
    function SetupFallbackMapIcon(elIconPanel, icon_image_path) {
        const mapIconDetails = { m_icon: elIconPanel, m_type: 'svg', m_handler: -1 };
        $.RegisterEventHandler('ImageFailedLoad', elIconPanel, () => SetPNGImageFallback(mapIconDetails, icon_image_path));
    }
    IconUtil.SetupFallbackMapIcon = SetupFallbackMapIcon;
    function SetItemSetPNGImageFallback(elIconPanel, icon_image_name) {
        elIconPanel.SetImage('file://{images}/econ/set_icons/' + icon_image_name + '_small.png');
    }
    IconUtil.SetItemSetPNGImageFallback = SetItemSetPNGImageFallback;
    function SetItemSetSVGImage(elIconPanel, icon_image_name) {
        elIconPanel.SetImage('file://{images}/econ/set_icons/' + icon_image_name + '.svg');
    }
    IconUtil.SetItemSetSVGImage = SetItemSetSVGImage;
    function SetupFallbackItemSetIcon(elIconPanel, icon_image_name) {
        if (elIconPanel.IsValid() && elIconPanel && elIconPanel.Data().fallbackHandler === undefined) {
            $.RegisterEventHandler('ImageFailedLoad', elIconPanel, () => SetItemSetPNGImageFallback(elIconPanel, icon_image_name));
            elIconPanel.Data().fallbackHandler = true;
        }
    }
    IconUtil.SetupFallbackItemSetIcon = SetupFallbackItemSetIcon;
})(IconUtil || (IconUtil = {}));
