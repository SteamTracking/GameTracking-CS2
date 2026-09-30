"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/iteminfo.ts" />
var CharacterButtons;
(function (CharacterButtons) {
    function _PopulateWeaponDropdownForCharacter(elDropdown, modelPanelSettings) {
        const list = ItemInfo.GetLoadoutWeapons(modelPanelSettings.team);
        if (!list || list.length == 0) {
            return;
        }
        elDropdown.RemoveAllOptions();
        for (let entry of list) {
            const newEntry = $.CreatePanel('Panel', elDropdown, entry[1], {
                'class': 'DropDownMenu'
            });
            newEntry.SetAcceptsFocus(true);
            const elRarity = $.CreatePanel('Label', newEntry, 'rarity');
            elRarity.style.width = '100%';
            elRarity.style.height = '100%';
            elRarity.style.padding = '0px 0px';
            const rarityColor = InventoryAPI.GetItemRarityColor(entry[1]);
            elRarity.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from(" + rarityColor + " ),  color-stop( 0.0125, #00000000 ), to( #00000000 ) );";
            const elLabel = $.CreatePanel('Label', newEntry, 'label', {
                'text': InventoryAPI.GetItemName(entry[1])
            });
            elDropdown.AddOption(newEntry);
        }
        elDropdown.SetPanelEvent('oninputsubmit', () => _OnUpdateWeaponSelection(elDropdown, modelPanelSettings));
        elDropdown.SetSelected(modelPanelSettings.weaponItemId);
    }
    function _OnUpdateWeaponSelection(elDropdown, modelPanelSettings) {
        modelPanelSettings.weaponItemId = elDropdown.GetSelected() ? elDropdown.GetSelected().id : "";
        modelPanelSettings.panel.SetActiveCharacter(5);
        CharacterAnims.PlayAnimsOnPanel(modelPanelSettings);
    }
    ;
    function ZoomCamera() {
        const data = $.GetContextPanel().Data();
        const elZoomButton = $.GetContextPanel().FindChildInLayoutFile('LoadoutSingleItemModelZoom');
        if (elZoomButton.checked) {
            data.m_modelPanelSettings.panel.TransitionToCamera('cam_char_inspect_closeup', 0.5);
        }
        else {
            data.m_modelPanelSettings.panel.TransitionToCamera('cam_char_inspect_wide', 0.5);
        }
    }
    CharacterButtons.ZoomCamera = ZoomCamera;
    function PlayCheer() {
        const elZoomButton = $.GetContextPanel().FindChildInLayoutFile('LoadoutSingleItemModelZoom');
        if (elZoomButton.checked)
            elZoomButton.checked = false;
        const data = $.GetContextPanel().Data();
        data.m_modelPanelSettings.cameraPreset = data.m_characterToolbarButtonSettings.cameraPresetUnzoomed;
        const modelRenderSettingsOneOffTempCopy = ItemInfo.DeepCopyVanityCharacterSettings(data.m_modelPanelSettings);
        modelRenderSettingsOneOffTempCopy.cheer = InventoryAPI.GetCharacterDefaultCheerByItemId(modelRenderSettingsOneOffTempCopy.charItemId);
        CharacterAnims.PlayAnimsOnPanel(modelRenderSettingsOneOffTempCopy);
    }
    CharacterButtons.PlayCheer = PlayCheer;
    function PlayDefeat() {
        const elZoomButton = $.GetContextPanel().FindChildInLayoutFile('LoadoutSingleItemModelZoom');
        if (elZoomButton.checked)
            elZoomButton.checked = false;
        const data = $.GetContextPanel().Data();
        data.m_modelPanelSettings.cameraPreset = data.m_characterToolbarButtonSettings.cameraPresetUnzoomed;
        const modelRenderSettingsOneOffTempCopy = ItemInfo.DeepCopyVanityCharacterSettings(data.m_modelPanelSettings);
        modelRenderSettingsOneOffTempCopy.cheer = InventoryAPI.GetCharacterDefaultDefeatByItemId(modelRenderSettingsOneOffTempCopy.charItemId);
        CharacterAnims.PlayAnimsOnPanel(modelRenderSettingsOneOffTempCopy);
    }
    CharacterButtons.PlayDefeat = PlayDefeat;
    function UpdateScenery() {
        UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent('id-inspect-contextmenu-maps', '', 'file://{resources}/layout/context_menus/context_menu_mainmenu_vanity.xml', 'type=maps' +
            '&' + 'inspect-map=true', () => $.DispatchEvent('ContextMenuEvent', ''));
    }
    CharacterButtons.UpdateScenery = UpdateScenery;
    function PreviewModelVoice() {
        const data = $.GetContextPanel().Data();
        InventoryAPI.PreviewModelVoice(data.m_modelPanelSettings.charItemId);
    }
    CharacterButtons.PreviewModelVoice = PreviewModelVoice;
    function InitCharacterButtons(elButtons, elPreviewpanel, characterButtonSettings) {
        if (!elButtons)
            return;
        elButtons.Children().forEach(el => el.enabled = true);
        if (!elPreviewpanel)
            return;
        const elZoomButton = elButtons.FindChildInLayoutFile('LoadoutSingleItemModelZoom');
        const modelPanelSettings = ItemInfo.GetOrUpdateVanityCharacterSettings(characterButtonSettings.charItemId);
        modelPanelSettings.panel = elPreviewpanel;
        modelPanelSettings.cameraPreset = elZoomButton.checked ? characterButtonSettings.cameraPresetZoomed : characterButtonSettings.cameraPresetUnzoomed;
        const elDropdown = elButtons.FindChildInLayoutFile('LoadoutSingleItemModelWeaponChoice');
        _PopulateWeaponDropdownForCharacter(elDropdown, modelPanelSettings);
        const cheer = ItemInfo.GetDefaultCheer(modelPanelSettings.charItemId);
        const elCheer = elButtons.FindChildInLayoutFile('PlayCheer');
        elCheer.enabled = cheer != undefined && cheer != "";
        const defeat = ItemInfo.GetDefaultDefeat(modelPanelSettings.charItemId);
        const elDefeat = elButtons.FindChildInLayoutFile('PlayDefeat');
        elDefeat.enabled = defeat != undefined && defeat != "";
        elButtons.Data().m_characterToolbarButtonSettings = characterButtonSettings;
        elButtons.Data().m_modelPanelSettings = modelPanelSettings;
    }
    CharacterButtons.InitCharacterButtons = InitCharacterButtons;
})(CharacterButtons || (CharacterButtons = {}));
