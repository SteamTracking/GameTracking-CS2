"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="hud/hudwinpanel_background_map.ts" />
/// <reference path="generated/items_event_current_generated_store.d.ts" />
/// <reference path="generated/items_event_current_generated_store.ts" />
var controlsLibActiveTab = null;
function ControlsLibNavigateToTab(tab, msg) {
    if (controlsLibActiveTab) {
        controlsLibActiveTab.RemoveClass('Active');
    }
    controlsLibActiveTab = $('#' + tab);
    if (controlsLibActiveTab) {
        controlsLibActiveTab.AddClass('Active');
    }
}
function CloseControlsLib() {
    $.GetContextPanel().DeleteAsync(.3);
    var controlsLibPanel = $.GetContextPanel();
    controlsLibPanel.RemoveClass("Active");
}
function OpenControlsLib() {
    var controlsLibPanel = $.GetContextPanel();
    controlsLibPanel.AddClass("Active");
}
var jsPopupCallbackHandle = null;
var jsPopupLoadingBarCallbackHandle = null;
var popupLoadingBarLevel = 0;
function ClearPopupsText() {
    $('#ControlsLibPopupsText').text = '--';
}
function OnControlsLibPopupEvent(msg) {
    $('#ControlsLibPopupsText').text = msg;
}
function OnPopupCustomLayoutParamsPressed() {
    ClearPopupsText();
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_custom_layout_test.xml', 'popupvalue=123456&callback=' + jsPopupCallbackHandle);
}
function OnPopupCustomLayoutImagePressed() {
    ClearPopupsText();
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_custom_layout_test_image.xml', 'message=Example of popup with an image&image=file://{images}/control_icons/home_icon.vtf&callback=' + jsPopupCallbackHandle);
}
function OnPopupCustomLayoutImageSpinnerPressed() {
    ClearPopupsText();
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_custom_layout_test_image.xml', 'message=Example of popup with an image and a spinner&image=file://{images}/control_icons/home_icon.vtf&spinner=1&callback=' + jsPopupCallbackHandle);
}
function OnPopupCustomLayoutImageLoadingPressed() {
    ClearPopupsText();
    popupLoadingBarLevel = 0;
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_custom_layout_test_image.xml', 'message=Example of popup with an image and a loading bar&image=file://{images}/control_icons/home_icon.vtf&callback=' + jsPopupCallbackHandle + '&loadingBarCallback=' + jsPopupLoadingBarCallbackHandle);
}
function OnPopupCustomLayoutMatchAccept() {
    ClearPopupsText();
    popupLoadingBarLevel = 0;
    var popup = UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_accept_match.xml', 'map_and_isreconnect=de_dust2,false&ping=155&location=China, Tianjin');
    $.DispatchEvent("ShowAcceptPopup", popup);
}
function OnPopupCustomLayoutPremierPickBan() {
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_premier_pick_ban.xml', "none");
}
function OnPopupCustomLayoutXpGrant() {
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_acknowledge_xpgrant.xml', 'none');
}
function OnPopupCustomLayoutMajorStore() {
    const popupPanel = UiToolkitAPI.ShowCustomLayoutPopup('id-popup-major-store', 'file://{resources}/layout/popups/popup_major_store.xml');
    popupPanel.Data().eventId = g_ActiveTournamentInfo.eventid;
}
function OnPopupCustomLayoutCaseConfirm() {
    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_container_open_confirm.xml', 'none');
}
function OnPopupCustomLayoutLoadingScreen() {
    ClearPopupsText();
    UiToolkitAPI.ShowCustomLayoutPopup('teams', 'file://{resources}/layout/teamselectmenu.xml');
}
function OnControlsLibPopupLoadingBarEvent() {
    popupLoadingBarLevel += 0.05;
    if (popupLoadingBarLevel > 1.0) {
        popupLoadingBarLevel = 1.0;
    }
}
var jsContextMenuCallbackHandle = null;
function ClearContextMenuText() {
    $('#ControlsLibContextMenuText').text = '--';
}
function OnControlsLibContextMenuEvent(msg) {
    $('#ControlsLibContextMenuText').text = msg;
}
function OnSimpleContextMenu() {
    ClearContextMenuText();
    var items = [];
    items.push({ label: 'Item 1', jsCallback: function () { OnControlsLibContextMenuEvent('Item1'); } });
    items.push({ label: 'Item 2', jsCallback: function () { OnControlsLibContextMenuEvent('Item2'); } });
    items.push({ label: 'Item 3', jsCallback: function () { OnControlsLibContextMenuEvent('Item3'); } });
    UiToolkitAPI.ShowSimpleContextMenu('', 'ControlLibSimpleContextMenu', items);
}
function OnContextMenuCustomLayoutParamsPressed() {
    ClearContextMenuText();
    UiToolkitAPI.ShowCustomLayoutContextMenuParameters('', '', 'file://{resources}/layout/context_menus/context_menu_custom_layout_test.xml', 'test=123456&callback=' + jsContextMenuCallbackHandle);
}
var g_VideoNumTrailers = 2;
var g_VideoCurrentTrailer = 0;
function VideoPlayNextTrailer() {
    g_VideoCurrentTrailer = (g_VideoCurrentTrailer + 1) % g_VideoNumTrailers;
    var videoPlayer = $('#VideoTrailerPlayer');
    videoPlayer.SetMovie("file://{resources}/videos/trailer_" + g_VideoCurrentTrailer + ".webm");
    videoPlayer.SetTitle("Trailer " + g_VideoCurrentTrailer);
    videoPlayer.Play();
}
function InitScenePanel() {
    var playbackSpeedSlider = $('#PlaybackSpeedSlider');
    playbackSpeedSlider.min = -2;
    playbackSpeedSlider.max = 2;
    playbackSpeedSlider.value = 1;
}
function SceneCameraPlaybackSpeedSliderChanged() {
    var playbackSpeedSlider = $('#PlaybackSpeedSlider');
    var playbackSpeedText = $('#PlaybackSpeedText');
    var vanityPanel = $('#MapForVanity');
    playbackSpeedText.text = playbackSpeedSlider.value.toFixed(3);
    vanityPanel.SetCameraPlaybackSpeed(playbackSpeedSlider.value);
}
function SceneCameraPlaybackSpeedTextChanged() {
    var playbackSpeedText = $('#PlaybackSpeedText');
    var value = parseFloat(playbackSpeedText.text);
    if (!isNaN(value)) {
        var playbackSpeedSlider = $('#PlaybackSpeedSlider');
        playbackSpeedSlider.value = value;
    }
    else {
    }
}
var g_DialogVarCount = 0;
function UpdateParentDialogVariablesFromTextEntry() {
    var varStr = $("#ParentDialogVarTextEntry").text;
    $("#DialogVarParentPanel").SetDialogVariable('testvar', varStr);
}
function UpdateChildDialogVariablesFromTextEntry() {
    var varStr = $("#ChildDialogVarTextEntry").text;
    $("#DialogVarChildPanel").SetDialogVariable('testvar', varStr);
}
function InitDialogVariables() {
    $("#ControlsLibDiagVars").SetDialogVariableInt("count", g_DialogVarCount);
    $("#ControlsLibDiagVars").SetDialogVariable("s1", "Test1");
    $("#ControlsLibDiagVars").SetDialogVariable("s2", "Test2");
    $("#ControlsLibDiagVars").SetDialogVariable("cam_key", "%jump%");
    $("#ControlsLibDiagVars").SetDialogVariable("np_key", "%attack%");
    $("#ControlsLibDiagVars").SetDialogVariable("sp_key", "%radio%");
    $("#DiagVarLabel").text = $.Localize("\tDynamic Label Count: {d:r:count}", $("#ControlsLibDiagVars"));
    $.Schedule(1.0, UpdateDialogVariables);
    $("#ParentDialogVarTextEntry").RaiseChangeEvents(true);
    $("#ChildDialogVarTextEntry").RaiseChangeEvents(true);
    $.RegisterEventHandler('TextEntryChanged', $("#ParentDialogVarTextEntry"), UpdateParentDialogVariablesFromTextEntry);
    $.RegisterEventHandler('TextEntryChanged', $("#ChildDialogVarTextEntry"), UpdateChildDialogVariablesFromTextEntry);
}
function UpdateDialogVariables() {
    g_DialogVarCount++;
    $("#ControlsLibDiagVars").SetDialogVariableInt("count", g_DialogVarCount);
    $.Schedule(1.0, UpdateDialogVariables);
}
function InitCaseTest() {
    $("#CaseTest").SetDialogVariable("casetest", "iİıI");
}
function OnImageFailLoad() {
    $("#ControlsLibPanelImageFallback").SetImage("file://{images}/icons/knife.psd");
}
function InitPanels() {
    var parent = $.FindChildInContext("#ControlsLibPanelsDynParent");
    $.CreatePanel('Label', parent, '', { text: 'Label, with text property, created dynamically from js.' });
    $.CreatePanel('Label', parent, '', { class: 'fontSize-l fontWeight-Bold', style: 'color:#558927;', text: 'Label, with text and class properties, created dynamically from js.' });
    $.CreatePanel('TextButton', parent, '', { class: 'PopupButton', text: "Output to console", onactivate: "$.Msg('Panel tab - Button pressed !!!')" });
    $.CreatePanel('ControlLibTestPanel', $.FindChildInContext('#ControlsLibPanelsJS'), '', { MyCustomProp: 'Created dynamically from javascript', CreatedFromJS: 1 });
    $.RegisterEventHandler('ImageFailedLoad', $("#ControlsLibPanelImageFallback"), OnImageFailLoad);
    $("#ControlsLibPanelImageFallback").SetImage("file://{images}/unknown2.vtf");
    $("#ImageApngtest").SetImage("file://{resources}/videos/test/apngtestnoext");
}
function TransitionBlurPanel() {
    $("#MyBlendBlurFitParent").RemoveClass("TheBlurAnimOut");
    $("#MyBlendBlurFitParent").RemoveClass("TheBlurAnimIn");
    $("#MyBlendBlurFitParent").AddClass("TheBlurAnimIn");
}
function TransitionBlurPanel2() {
    $("#MyBlendBlurFitParent").RemoveClass("TheBlurAnimIn");
    $("#MyBlendBlurFitParent").RemoveClass("TheBlurAnimOut");
    $("#MyBlendBlurFitParent").AddClass("TheBlurAnimOut");
}
function CreateSvgFromJs() {
    $.CreatePanel('Image', $('#svgButton'), '', {
        src: "file://{images}/icons/ui/smile.svg",
        texturewidth: 100,
        textureheight: 100
    });
}
function GetRssFeed() {
    BlogAPI.RequestRSSFeed();
}
function OnRssFeedReceived(feed) {
    var RSSFeedPanel = $("#RSSFeed");
    if (RSSFeedPanel == null) {
        return;
    }
    RSSFeedPanel.RemoveAndDeleteChildren();
    for (const item of feed.items) {
        var itemPanel = $.CreatePanel('Panel', RSSFeedPanel, '', { acceptsinput: true });
        itemPanel.AddClass('RSSFeed__Item');
        $.CreatePanel('Label', itemPanel, '', { text: item.title, html: true, class: 'RSSFeed__ItemTitle' });
        if (item.imageUrl.length !== 0) {
            $.CreatePanel('Image', itemPanel, '', { src: item.imageUrl, class: 'RSSFeed__ItemImage', scaling: 'stretch-to-fit-preserve-aspect' });
        }
        $.CreatePanel('Label', itemPanel, '', { text: item.description, html: true, class: 'RSSFeed__ItemDesc' });
        $.CreatePanel('Label', itemPanel, '', { text: item.date, html: true, class: 'RSSFeed__ItemDate' });
        itemPanel.SetPanelEvent("onactivate", SteamOverlayAPI.OpenURL.bind(SteamOverlayAPI, item.link));
    }
}
function JSReadyReset() {
    var elParent = $('#ControlsLibBugsReadyParent');
    var elBtnAddChild = $('#ControlsLibBugsReadyButtonAddChild');
    var elBtnAddBgImg = $('#ControlsLibBugsReadyButtonAddBgImg');
    elParent.RemoveAndDeleteChildren();
    elParent.SetReadyForDisplay(false);
    elBtnAddChild.enabled = true;
    elBtnAddBgImg.enabled = false;
}
function JSReadyAddChild() {
    var elParent = $('#ControlsLibBugsReadyParent');
    var elBtnAddChild = $('#ControlsLibBugsReadyButtonAddChild');
    var elBtnAddBgImg = $('#ControlsLibBugsReadyButtonAddBgImg');
    $.CreatePanel('Panel', elParent, 'ControlsLibBugsReadyChild', { class: 'ControlLibBugs__ReadyChild' });
    elBtnAddChild.enabled = false;
    elBtnAddBgImg.enabled = true;
}
function JSReadyAddBgImg() {
    var elBtnAddChild = $('#ControlsLibBugsReadyButtonAddChild');
    var elBtnAddBgImg = $('#ControlsLibBugsReadyButtonAddBgImg');
    var elParent = $('#ControlsLibBugsReadyParent');
    var elChild = $('#ControlsLibBugsReadyChild');
    elBtnAddChild.enabled = false;
    elBtnAddBgImg.enabled = false;
    elChild.AddClass('ControlLibBugs__ReadyChild--Ready');
    elParent.SetReadyForDisplay(true);
}
function JSTestTransition() {
    var Delay = 0.2;
    function _reveal(panelId) {
        $(panelId).AddClass('TestTransition');
    }
    $.Schedule(Delay, () => _reveal("#RepaintBugGrandchild"));
    $.Schedule(Delay * 2.0, () => _reveal("#RepaintBugChild"));
}
function JSResetTransition() {
    $('#RepaintBugChild').RemoveClass('TestTransition');
    $('#RepaintBugGrandchild').RemoveClass('TestTransition');
}
function JSControlsPageStartParticles() {
    for (const curPanel of $('#ControlsLibParticles').FindChildrenWithClassTraverse('TestParticlePanel')) {
        curPanel.StartParticles();
    }
}
function JSControlsPageStopPlayEndCapParticles() {
    for (const curPanel of $('#ControlsLibParticles').FindChildrenWithClassTraverse('TestParticlePanel')) {
        curPanel.StopParticlesWithEndcaps();
    }
}
function JSControlsPageSetControlPointParticles(cp, xpos, ypos, zpos) {
    for (const curPanel of $('#ControlsLibParticles').FindChildrenWithClassTraverse('TestParticlePanel')) {
        curPanel.SetControlPoint(cp, 0, 1 + ypos, zpos);
        curPanel.SetControlPoint(cp, xpos, ypos, zpos);
    }
}
function JSPanelStartParticles(name) {
    for (const curPanel of $.GetContextPanel().FindChildrenWithClassTraverse(name)) {
        curPanel.StartParticles();
    }
}
function JSPanelStopPlayEndCapParticles(name) {
    for (const curPanel of $.GetContextPanel().FindChildrenWithClassTraverse(name)) {
        curPanel.StopParticlesWithEndcaps();
    }
}
function JSPanelSetControlPointParticles(name, cp, xpos, ypos, zpos) {
    for (const curPanel of $.GetContextPanel().FindChildrenWithClassTraverse(name)) {
        curPanel.SetControlPoint(cp, 0, 1 + ypos, zpos);
        curPanel.SetControlPoint(cp, xpos, ypos, zpos);
    }
}
function JSPanelSetParticlesName(name, particleName) {
    for (const curPanel of $.GetContextPanel().FindChildrenWithClassTraverse(name)) {
        curPanel.SetParticleNameAndRefresh(particleName);
    }
}
function ShowHideWinPanel(bshow, teamOverride = 2, mode = 'casual') {
    let elPanel = $.GetContextPanel().FindChildInLayoutFile('ZooWinPanel');
    elPanel.RemoveClass('WinPanelRoot--Win--T');
    elPanel.Data().teamOverride = teamOverride;
    elPanel.Data().gameModeOverride = mode;
    elPanel.SetHasClass('winpanel-basic-round-result-visible', bshow);
    elPanel.SetHasClass('WinPanelRoot--Win', bshow);
    elPanel.SetHasClass('winpanel-mvp--show', bshow);
    elPanel.SetHasClass('MVP__MusicKit--show', bshow);
    elPanel.SetHasClass('winpanel-funfacts--show', bshow);
    elPanel.SetDialogVariable('winpanel-funfact', $.Localize('#GameUI_Stat_LastMatch_MaxPlayers'));
    elPanel.SetDialogVariable('winpanel-title', $.Localize('#WinPanel_RoundWon'));
    let elAvatar = elPanel.FindChildInLayoutFile('MVPAvatar');
    elAvatar.PopulateFromSteamID(MyPersonaAPI.GetXuid());
    let musicKitId = LoadoutAPI.GetItemID('noteam', 'musickit');
    let elKitName = elPanel.FindChildInLayoutFile('MVPMusicKitName');
    elKitName.text = InventoryAPI.GetItemName(musicKitId);
    let elKitLabel = elPanel.FindChildInLayoutFile('MVPMusicKitStatTrak');
    elKitLabel.text = '1000';
}
function CtrlLib_RandomColorString() {
    return "rgba("
        + Math.random() * 255 + ","
        + Math.random() * 255 + ","
        + Math.random() * 255 + ","
        + Number(0.3 + Math.random() * 0.6)
        + ")";
}
function CtrlLib_CreateSpiderGraph() {
    const spiderGraph = $('#SpiderGraph');
    spiderGraph.ClearJS('rgba(0,0,0,0)');
    const elGuidelines = $('#SpiderGraphNumGuidelines');
    const numGuidelines = Number(elGuidelines.text);
    const options = {
        bkg_color: "#44444444",
        spoke_length_scale: 1.0,
        guideline_count: numGuidelines,
        deadzone_percent: .2
    };
    spiderGraph.SetGraphOptions(options);
    const elSpokes = $('#SpiderGraphSpokes');
    const spokesCount = Number(elSpokes.text);
    spiderGraph.DrawGraphBackground(spokesCount);
    const elNumPolys = $('#SpiderGraphNumPolys');
    const polyCount = Number(elNumPolys.text);
    for (let p = 0; p < polyCount; p++) {
        let values = Array.from({ length: spokesCount }, () => Math.random());
        const options = {
            line_color: CtrlLib_RandomColorString(),
            fill_color_inner: CtrlLib_RandomColorString(),
            fill_color_outer: CtrlLib_RandomColorString(),
        };
        spiderGraph.DrawGraphPoly(values, options);
    }
    for (let s = 0; s < spokesCount; s++) {
        let vPos = spiderGraph.GraphPositionToUIPosition(s, 1.0);
    }
}
function gen_graph_data(i, max) {
    return Math.random() * max;
}
function CtrlLib_CreateLineGraph() {
    const lineGraph = $('#LineGraph');
    const elNumVals = $('#num_points');
    const numPoints = Math.floor(Number(4 + elNumVals.value * (15)));
    const xvals = [...Array(numPoints).keys()];
    const yvals = xvals.map(x => gen_graph_data(x, numPoints));
    const options = {
        draw_guidelines: true,
        guideline_color: "#88888888",
        guideline_thick: 4,
        guideline_soft: .5,
        line_color: "#aaffffaa",
        line_thickness: 6,
        line_softness: .5,
        draw_points: true,
        point_size: 8.5,
        point_color: "#ff3344ff",
        gradient_color: "#344d7333",
    };
    lineGraph.SetGraphOptions(options);
    lineGraph.SetData(xvals, yvals);
    lineGraph.Show();
    const guidelineYPositions = lineGraph.GetGuidelinePositions();
    const pointPositions = lineGraph.GetDataPointPositions();
}
(function () {
    OpenControlsLib();
    ControlsLibNavigateToTab('ControlLibStyleGuide', 'init');
    const spiderGraph = $('#SpiderGraph');
    if (spiderGraph) {
        $.RegisterEventHandler("CanvasReady", spiderGraph, CtrlLib_CreateSpiderGraph);
        if (spiderGraph.BCanvasReady()) {
            CtrlLib_CreateSpiderGraph();
        }
    }
    var elTime = $("#TimeZoo");
    if (elTime) {
        elTime.SetDialogVariableTime("time", 1605560584);
    }
    jsPopupCallbackHandle = UiToolkitAPI.RegisterJSCallback(OnControlsLibPopupEvent);
    jsContextMenuCallbackHandle = UiToolkitAPI.RegisterJSCallback(OnControlsLibContextMenuEvent);
    jsPopupLoadingBarCallbackHandle = UiToolkitAPI.RegisterJSCallback(OnControlsLibPopupLoadingBarEvent);
    $.RegisterForUnhandledEvent("PanoramaComponent_Blog_RSSFeedReceived", OnRssFeedReceived);
})();
