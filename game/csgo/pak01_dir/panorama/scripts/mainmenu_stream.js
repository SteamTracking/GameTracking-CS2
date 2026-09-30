"use strict";
/// <reference path="csgo.d.ts" />m_cp
var StreamPanel;
(function (StreamPanel) {
    let m_cp;
    let m_elEmbeddedStream;
    let m_bAllowStream = true;
    let m_bMainMenuActive = true;
    let m_valLastKnownVolume = 0;
    let m_nVolumeSliderChangedFromScript = 0;
    let m_userClosedStream = false;
    const m_pinnedParent = $.GetContextPanel().GetParent();
    const m_dragParent = $.GetContextPanel().GetParent().GetParent().GetParent();
    function _Init() {
        m_cp = $.GetContextPanel();
        _UpdateEmbeddedStream();
        m_cp.SetHasClass('stream-drag-enabled', false);
    }
    function _CloseStream() {
        m_bAllowStream = false;
        m_userClosedStream = true;
        _UpdateEmbeddedStream();
    }
    ;
    function _MinimizeStream() {
        m_cp.SetHasClass('minimize_stream', true);
        let elDragPanel = m_dragParent.FindChildInLayoutFile('main-menu-drag-panel');
        if (m_cp.GetParent().id === elDragPanel.id) {
            $.Schedule(.25, () => { elDragPanel.style.width = 'fit-children'; });
        }
    }
    ;
    function _FullSizeStream() {
        m_cp.SetHasClass('minimize_stream', false);
    }
    ;
    function _StreamDragEnable() {
        let elDragPanel = m_dragParent.FindChildInLayoutFile('main-menu-drag-panel');
        m_cp.SetParent(elDragPanel);
        m_cp.style.y = "0px";
        m_cp.style.x = "0px";
        $.Schedule(.25, () => { elDragPanel.style.width = 'fit-children'; });
        let rightOffset = 140;
        let xpos = (elDragPanel.GetParent().actuallayoutwidth / elDragPanel.GetParent().actualuiscale_x);
        xpos = xpos - ((m_cp.actuallayoutwidth / m_cp.actualuiscale_x) + rightOffset);
        let ypos = (elDragPanel.GetParent().actuallayoutheight / elDragPanel.GetParent().actualuiscale_y);
        ypos = ypos - ((m_cp.actuallayoutheight / m_cp.actualuiscale_y) + rightOffset);
        elDragPanel.SetDragPosition(xpos, ypos);
        m_cp.SetHasClass('stream-drag-enabled', true);
    }
    function _StreamDragDisable() {
        m_cp.style.y = m_cp.actualyoffset + 150 + 'px';
        m_cp.style.x = m_cp.actualxoffset - 55 + 'px';
        m_cp.FindChild('StreamPanelFeed').style.opacity = '0';
        $.Schedule(.3, () => {
            m_cp.SetParent(m_pinnedParent);
            m_cp.SetHasClass('stream-drag-enabled', false);
            m_cp.FindChild('StreamPanelFeed').style.opacity = '1';
            m_pinnedParent.MoveChildBefore(m_cp, m_pinnedParent.FindChild('VanityControls'));
        });
    }
    function _CSGOHideMainMenu() {
        m_bMainMenuActive = false;
        _UpdateEmbeddedStream();
    }
    ;
    function _CSGOShowMainMenu() {
        m_bMainMenuActive = true;
        m_bAllowStream = true;
        _UpdateEmbeddedStream();
    }
    ;
    function _UpdateEmbeddedStream() {
        let urlStreamFeed = EmbeddedStreamAPI.GetStreamFeedSourceURL();
        let elStreamPanelFeed = m_cp.FindChildInLayoutFile('StreamPanelFeed');
        if (!m_bAllowStream || !m_bMainMenuActive) {
            urlStreamFeed = '';
        }
        if (urlStreamFeed) {
            if (!elStreamPanelFeed) {
                elStreamPanelFeed = $.CreatePanel('Panel', m_cp, 'StreamPanelFeed');
                elStreamPanelFeed.BLoadLayoutSnippet('stream-panel');
                let elSlider = elStreamPanelFeed.FindChildInLayoutFile('VolumeSlider');
                if (elSlider) {
                    elSlider.min = 0;
                    elSlider.max = 100;
                    elSlider.increment = 1;
                    ++m_nVolumeSliderChangedFromScript;
                    elSlider.value = EmbeddedStreamAPI.GetAudioVolume();
                    elSlider.SetPanelEvent('onvaluechanged', OnVolumeSliderValueChanged);
                }
                _UpdateVolumeImageFromSlider();
                let elVolumeImage = elStreamPanelFeed.FindChildInLayoutFile('VolumeImage');
                if (elVolumeImage) {
                    elVolumeImage.SetPanelEvent('onactivate', ToggleVolumeMute);
                }
                elStreamPanelFeed.FindChildInLayoutFile("id-close-btn").SetPanelEvent('onactivate', _CloseStream);
                elStreamPanelFeed.FindChildInLayoutFile("id-minimize-btn").SetPanelEvent('onactivate', _MinimizeStream);
                elStreamPanelFeed.FindChildInLayoutFile("id-full-size-btn").SetPanelEvent('onactivate', _FullSizeStream);
                elStreamPanelFeed.FindChildInLayoutFile("id-popout-btn").SetPanelEvent('onactivate', _StreamDragEnable);
                elStreamPanelFeed.FindChildInLayoutFile("id-popout-reset-btn").SetPanelEvent('onactivate', _StreamDragDisable);
            }
            m_elEmbeddedStream = elStreamPanelFeed.FindChildInLayoutFile('StreamHTML');
            m_elEmbeddedStream.SetURL(urlStreamFeed);
            _SetClassesForVideoPlaying(EmbeddedStreamAPI.IsVideoPlaying());
        }
        else if (elStreamPanelFeed) {
            elStreamPanelFeed.DeleteAsync(0);
            _SetClassesForVideoPlaying(false);
        }
    }
    ;
    function ToggleVolumeMute() {
        let valCurrentVolume = EmbeddedStreamAPI.GetAudioVolume();
        if (valCurrentVolume > 0) {
            m_valLastKnownVolume = valCurrentVolume;
            EmbeddedStreamAPI.SetAudioVolume(0);
        }
        else {
            if (m_valLastKnownVolume < 15)
                m_valLastKnownVolume = 20;
            EmbeddedStreamAPI.SetAudioVolume(m_valLastKnownVolume);
        }
        _OnVolumeCodeValueChanged();
    }
    StreamPanel.ToggleVolumeMute = ToggleVolumeMute;
    ;
    function OnVolumeSliderValueChanged() {
        if (m_nVolumeSliderChangedFromScript > 0) {
            --m_nVolumeSliderChangedFromScript;
            return;
        }
        let elSlider = m_cp.FindChildInLayoutFile('VolumeSlider');
        if (elSlider) {
            let vol = elSlider.value;
            EmbeddedStreamAPI.SetAudioVolume(vol);
            _UpdateVolumeImageFromSlider();
        }
    }
    StreamPanel.OnVolumeSliderValueChanged = OnVolumeSliderValueChanged;
    ;
    function _MuteStream() {
        let elSlider = m_cp.FindChildInLayoutFile('VolumeSlider');
        if (elSlider && elSlider.IsValid()) {
            let valCurrentVolume = EmbeddedStreamAPI.GetAudioVolume();
            if (valCurrentVolume > 0) {
                m_valLastKnownVolume = valCurrentVolume;
                EmbeddedStreamAPI.SetAudioVolume(0);
                _OnVolumeCodeValueChanged();
            }
        }
    }
    function _OnVolumeCodeValueChanged() {
        let elSlider = m_cp.FindChildInLayoutFile('VolumeSlider');
        if (elSlider) {
            ++m_nVolumeSliderChangedFromScript;
            elSlider.value = EmbeddedStreamAPI.GetAudioVolume();
            _UpdateVolumeImageFromSlider();
        }
    }
    StreamPanel._OnVolumeCodeValueChanged = _OnVolumeCodeValueChanged;
    ;
    function _UpdateVolumeImageFromSlider() {
        let elSlider = m_cp.FindChildInLayoutFile('VolumeSlider');
        let elVolumeImage = m_cp.FindChildInLayoutFile('VolumeImage');
        if (elSlider && elVolumeImage) {
            elVolumeImage.SetImage((elSlider.value > 0) ? 'file://{images}/icons/ui/unmuted.svg' : 'file://{images}/icons/ui/sound_off.svg');
        }
    }
    function _UpdateEmbeddedStreamVisibility() {
        _SetClassesForVideoPlaying(EmbeddedStreamAPI.IsVideoPlaying());
    }
    StreamPanel._UpdateEmbeddedStreamVisibility = _UpdateEmbeddedStreamVisibility;
    ;
    function _HTMLJSAlertV8(elPanel, sAlertText) {
        EmbeddedStreamAPI.PanoramaJSAlert(m_elEmbeddedStream, sAlertText);
    }
    StreamPanel._HTMLJSAlertV8 = _HTMLJSAlertV8;
    ;
    function _HTMLFinishRequest(elPanel, sUrl, sPageTitle) {
        EmbeddedStreamAPI.PanoramaFinishRequest(m_elEmbeddedStream, sUrl, sPageTitle);
    }
    StreamPanel._HTMLFinishRequest = _HTMLFinishRequest;
    ;
    function _SetClassesForVideoPlaying(bIsVideoPlaying) {
        if (m_cp) {
            if (bIsVideoPlaying) {
                m_cp.SetDialogVariable('title', $.Localize('#SFUI_MajorEventVenue_StreamTitle_' + NewsAPI.GetActiveTournamentEventID() + '_' + EmbeddedStreamAPI.GetStreamEventVenueID()));
                let elNavBarWatchExternalExtraButtons = m_cp.FindChildInLayoutFile("NavBarWatchExternalExtraButtons");
                let sSupportedStreamTypes = EmbeddedStreamAPI.GetStreamExternalLinkTypes();
                let sChildrenWithTypeName = "NavBarWatchExternal";
                elNavBarWatchExternalExtraButtons.Children().forEach(function (elchild) {
                    if (elchild.id.startsWith(sChildrenWithTypeName)) {
                        let chrLookupTypeCharacter = elchild.id.substring(sChildrenWithTypeName.length, sChildrenWithTypeName.length + 1);
                        elchild.SetHasClass('hidden', sSupportedStreamTypes.indexOf(chrLookupTypeCharacter) < 0);
                    }
                });
                if (m_userClosedStream) {
                    m_userClosedStream = false;
                    _MinimizeStream();
                    _StreamDragDisable();
                    _MuteStream();
                }
            }
            else {
                $.DispatchEvent('StreamPanelClosed');
            }
            m_cp.SetHasClass('hidden', !bIsVideoPlaying);
        }
    }
    ;
    {
        _Init();
        $.RegisterForUnhandledEvent("PanoramaComponent_EmbeddedStream_VideoReload", _UpdateEmbeddedStream);
        $.RegisterForUnhandledEvent("PanoramaComponent_EmbeddedStream_VideoPlaying", _UpdateEmbeddedStreamVisibility);
        $.RegisterForUnhandledEvent("PanoramaComponent_EmbeddedStream_VolumeChanged", _OnVolumeCodeValueChanged);
        $.RegisterForUnhandledEvent("CSGOHideMainMenu", _CSGOHideMainMenu);
        $.RegisterForUnhandledEvent("CSGOShowMainMenu", _CSGOShowMainMenu);
        $.RegisterForUnhandledEvent("MuteStreamPanel", _MuteStream);
        $.RegisterEventHandler("HTMLJSAlertV8", $.GetContextPanel(), _HTMLJSAlertV8);
        $.RegisterEventHandler("HTMLFinishRequest", $.GetContextPanel(), _HTMLFinishRequest);
    }
})(StreamPanel || (StreamPanel = {}));
;
