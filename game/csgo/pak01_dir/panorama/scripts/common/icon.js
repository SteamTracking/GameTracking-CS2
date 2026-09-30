"use strict";
/// <reference path="../csgo.d.ts" />
//This file contains functions that helps setting up map icon
var IconUtil;
(function (IconUtil) {
    // Used in the for loop below
    function SetPNGImageFallback(mapIconDetails, icon_image_path) {
        if (mapIconDetails.m_type == 'svg') {
            mapIconDetails.m_type = 'png';
            mapIconDetails.m_icon.SetImage(icon_image_path + '.png');
        }
        else {
            mapIconDetails.m_icon.SetImage('file://{images}/map_icons/map_icon_NONE.png'); // this should a known valid path
        }
    }
    function SetupFallbackMapIcon(elIconPanel, icon_image_path) {
        const mapIconDetails = { m_icon: elIconPanel, m_type: 'svg', m_handler: -1 };
        $.RegisterEventHandler('ImageFailedLoad', elIconPanel, () => SetPNGImageFallback(mapIconDetails, icon_image_path));
    }
    IconUtil.SetupFallbackMapIcon = SetupFallbackMapIcon;
    // For Item Set Icons
    function SetItemSetPNGImageFallback(elIconPanel, icon_image_name) {
        $.Msg('IconUtil did not find a SVG for ' + icon_image_name + ' using a _small.PNG');
        elIconPanel.SetImage('file://{images}/econ/set_icons/' + icon_image_name + '_small.png'); // this should a known valid path
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
