"use strict";
/// <reference path="../csgo.d.ts" />
// Bump version when you want the entire array below to appear new or if the viewed setting bookkeeping changes enough to warrant it.
var g_PromotedSettingsVersion = 1;
var g_PromotedSettings = [
    /*
        // Data about settings to show in the promoted settings menu.
        // Will make panels with a link to take user to the new setting.
        // These entries are in the order they will appear in the menu.
        // New entries can be put anywhere in the array.
        //
        // Required keys to populate snippets:
        id: ID of element in a settings menu to promote to the front tab for easier visibility.
        loc_name: Loc string to show in the new settings tab.
        loc_desc: Description of the settings being promoted.
        section: ID of Settings section panel where the 'id' above is a child panel.
        start_date: Date when this setting is added to the promoted setting menu (approx). Will show main menu indicator to users
                    whose local timestamp is before this date.
        end_date: Will no longer populate in the new setting menu after this date. Entries with a end_date in the past
                    are safe to remove from the array.
    */
    {
        id: "BuyMenuDonationKey",
        loc_name: "#SFUI_Settings_BuyWheelDonateKey",
        loc_desc: "#SFUI_Settings_BuyWheelDonateKey_Info",
        section: "GameSettings",
        start_date: new Date('December 17, 2020'),
        end_date: new Date('April 31, 2021'),
    },
    {
        id: "SettingsChatWheel",
        loc_name: "#settings_ui_chatwheel_section",
        loc_desc: "#Chatwheel_description",
        section: "KeybdMouseSettings",
        start_date: new Date('November 25, 2020'),
        end_date: new Date('April 30, 2021'),
    },
    {
        id: "SettingsCommunicationSettings",
        //loc_name: "#settings_comm_binds_section",
        //loc_desc: "#settings_comm_binds_info",
        loc_name: "#SFUI_Settings_FilterText_Title",
        loc_desc: "#SFUI_Settings_FilterText_Title_Tooltip",
        section: "GameSettings",
        start_date: new Date('June 11, 2020'),
        end_date: new Date('June 30, 2020')
    },
    {
        id: "MainMenuMovieSceneSelector",
        loc_name: "#GameUI_MainMenuMovieScene",
        loc_desc: "#GameUI_MainMenuMovieScene_Tooltip",
        section: "VideoSettings",
        subsection: "SimpleVideoSettingsRadio",
        start_date: new Date('May 26, 2020'),
        end_date: new Date('June 15, 2020')
    },
    {
        id: "XhairShowObserverCrosshair",
        loc_name: "#GameUI_ShowObserverCrosshair",
        loc_desc: "#GameUI_ShowObserverCrosshair_Tooltip",
        section: "GameSettings",
        start_date: new Date('April 15, 2020'),
        end_date: new Date('May 1, 2020')
    },
    {
        id: "SettingsCrosshair",
        loc_name: "#settings_crosshair",
        loc_desc: "#settings_crosshair_info",
        section: "GameSettings",
        start_date: new Date('February 24, 2019'),
        end_date: new Date('March 28, 2020')
    },
    {
        id: "ClutchKey",
        loc_name: "#GameUI_Clutch_Key",
        loc_desc: "#GameUI_Clutch_Key_Tooltip",
        section: "KeybdMouseSettings",
        start_date: new Date('September 21, 2019'),
        end_date: new Date('January 30, 2020')
    },
    {
        id: "id-friendlyfirecrosshair",
        loc_name: "#GameUI_FriendlyWarning",
        loc_desc: "#GameUI_FriendlyWarning_desc",
        section: "GameSettings",
        start_date: new Date('October 7, 2019'),
        end_date: new Date('February 30, 2020')
    },
    {
        id: "SettingsCommunicationSettings",
        loc_name: "#settings_comm_binds_section",
        loc_desc: "#settings_comm_binds_info",
        section: "GameSettings",
        start_date: new Date('September 13, 2019'),
        end_date: new Date('January 30, 2020')
    },
    {
        id: "RadialWepMenuBinder",
        loc_name: "#SFUI_RadialWeaponMenu",
        loc_desc: "#SFUI_RadialWeaponMenu_Desc",
        section: "KeybdMouseSettings",
        start_date: new Date('September 18, 2019'),
        end_date: new Date('January 30, 2020')
    },
    {
        id: "XhairRecoil",
        loc_name: "#GameUI_CrosshairRecoil",
        loc_desc: "#GameUI_CrosshairRecoil_Desc",
        section: "GameSettings",
        start_date: new Date('August 21, 2023'),
        end_date: new Date('January 30, 2024')
    },
    {
        id: "ZoomButtonHold",
        loc_name: "#ZoomButtonHold",
        loc_desc: "#ZoomButtonHold_Desc",
        section: "KeybdMouseSettings",
        start_date: new Date('August 21, 2023'),
        end_date: new Date('January 30, 2024')
    },
    {
        id: "FiddleWithSilencers",
        loc_name: "#Cstrike_Fiddle_With_Silencers",
        loc_desc: "#Cstrike_Fiddle_With_Silencers_Desc",
        section: "GameSettings",
        start_date: new Date('August 21, 2023'),
        end_date: new Date('January 30, 2024')
    },
    {
        id: "AllowAnimatedAvatars",
        loc_name: "#Settings_AllowAnimatedAvatars_Title",
        loc_desc: "#Settings_AllowAnimatedAvatars_Title_Tooltip",
        section: "GameSettings",
        start_date: new Date('September 12, 2023'),
        end_date: new Date('January 30, 2024')
    },
    {
        id: "ReplaceAvatarsWithPlayerCount",
        loc_name: "#SFUI_Settings_MiniScoreboardPlayerCount",
        loc_desc: "#SFUI_Settings_MiniScoreboardPlayerCount_Tooltip",
        section: "GameSettings",
        start_date: new Date('October 11, 2023'),
        end_date: new Date('January 30, 2024')
    },
    {
        id: "FirstPersonTracers",
        loc_name: "#Cstrike_FirstPersonTracers",
        loc_desc: "#Cstrike_FirstPersonTracers_Desc",
        section: "GameSettings",
        start_date: new Date('January 19, 2024'),
        end_date: new Date('February 28, 2024')
    },
    {
        id: "ExtraBufffering",
        loc_name: "#SFUI_Settings_Network_ExtraBuffering",
        loc_desc: "#SFUI_Settings_Network_ExtraBuffering_Info",
        section: "GameSettings",
        start_date: new Date('February 6, 2024'),
        end_date: new Date('April 22, 2024')
    },
    {
        id: "SettingsTelemetry",
        loc_name: "#settings_telemetry_section",
        loc_desc: "#settings_telemetry_section_info",
        section: "GameSettings",
        start_date: new Date('February 6, 2024'),
        end_date: new Date('April 22, 2024')
    },
    {
        id: "PreferredHandedness",
        loc_name: "#Cstrike_PreferredHandedness",
        loc_desc: "#Cstrike_PreferredHandedness_Desc",
        section: "GameSettings",
        start_date: new Date('April 22, 2024'),
        end_date: new Date('June 1, 2024')
    },
    {
        id: "RadarScaleToggle",
        loc_name: "#SFUI_Settings_Radar_Scale_Alternate",
        loc_desc: "#SFUI_Settings_Radar_Scale_Alternate_Info",
        section: "GameSettings",
        start_date: new Date('April 22, 2024'),
        end_date: new Date('June 1, 2024')
    },
    {
        id: "SettingsGrenadeCrosshair",
        loc_name: "#settings_grenadecrosshair",
        loc_desc: "#settings_grenadecrosshair_info",
        section: "GameSettings",
        start_date: new Date('April 22, 2024'),
        end_date: new Date('June 1, 2024')
    },
    {
        id: "DynamicShadowsContainer",
        loc_name: "#SFUI_Settings_DynamicShadows",
        loc_desc: "#SFUI_Settings_DynamicShadows_Info",
        section: "VideoSettings",
        subsection: "AdvancedVideoSettingsRadio",
        start_date: new Date('June 1, 2024'),
        end_date: new Date('July 1, 2024')
    },
    {
        id: "RadarBackgroundOpacity",
        loc_name: "#SFUI_Settings_HUD_Radar_Background_Alpha",
        loc_desc: "#SFUI_Settings_HUD_Radar_Background_Alpha_Info",
        section: "GameSettings",
        start_date: new Date('November 1, 2024'),
        end_date: new Date('January 1, 2025')
    },
    {
        id: "RadarMapBlend",
        loc_name: "#SFUI_Settings_HUD_Radar_Map_Additive",
        loc_desc: "#SFUI_Settings_HUD_Radar_Map_Additive_Info",
        section: "GameSettings",
        start_date: new Date('November 1, 2024'),
        end_date: new Date('January 1, 2025')
    },
    {
        id: "SettingsDamagePrediction",
        loc_name: "#settings_damage_prediction",
        loc_desc: "#settings_damage_prediction_info",
        section: "GameSettings",
        start_date: new Date('November 1, 2024'),
        end_date: new Date('January 1, 2025')
    },
    {
        id: "RadarScaleDynamic",
        loc_name: "#SFUI_Settings_Radar_Scale_Dynamic",
        loc_desc: "#SFUI_Settings_Radar_Scale_Dynamic_Info",
        section: "GameSettings",
        start_date: new Date('January 27, 2025'),
        end_date: new Date('March 1, 2025')
    },
    {
        id: "RadarShapeSquare",
        loc_name: "#SFUI_Settings_Radar_Shape_Square",
        loc_desc: "#SFUI_Settings_Radar_Shape_Square_Info",
        section: "GameSettings",
        start_date: new Date('January 27, 2025'),
        end_date: new Date('March 1, 2025')
    },
    {
        id: "RadarBlurBackground",
        loc_name: "#SFUI_Settings_Radar_Blur_Background",
        loc_desc: "#SFUI_Settings_Radar_Blur_Background_Info",
        section: "GameSettings",
        start_date: new Date('January 27, 2025'),
        end_date: new Date('March 1, 2025')
    },
    {
        id: "WeaponRarityColor",
        loc_name: "#SFUI_HUDWeaponRarityColor",
        loc_desc: "#SFUI_HUDWeaponRarityColor_desc",
        section: "GameSettings",
        start_date: new Date('January 27, 2025'),
        end_date: new Date('June 1, 2025')
    },
    {
        id: "XhairStyle",
        loc_name: "#settings_crosshair",
        loc_desc: "#settings_crosshair_info",
        section: "CrosshairSettings",
        start_date: new Date('September 21, 2026'),
        end_date: new Date('December 1, 2026')
    },
]
    .reverse();
var PromotedSettingsUtil;
(function (PromotedSettingsUtil) {
    function GetUnacknowledgedPromotedSettings() {
        // const settingsInfo = GameInterfaceAPI.GetSettingString( "cl_promoted_settings_acknowledged" ).split( ':' );
        // const version = parseInt( settingsInfo.shift()! );
        // // Dont do any acknowledging for initial CS2 launch
        // if ( version === g_PromotedSettingsVersion )
        // {
        // 	const arrNewSettings: PromotedSetting_t[] = [];
        // 	// Second value is date last viewed a new setting
        // 	const timeLastViewed = new Date( parseInt( settingsInfo.shift()! ) );
        // 	for ( const setting of g_PromotedSettings )
        // 	{
        // 		const now = new Date();
        // 		if ( setting.start_date > timeLastViewed && setting.start_date <= now )
        // 			arrNewSettings.push( setting );
        // 	}
        // 	return arrNewSettings;
        // }
        // else
        {
            // Convar not up to date with code. Fix up old version if possible, otherwise
            // just show every setting in a valid date range.
            const now = new Date();
            return g_PromotedSettings.filter(setting => setting.start_date <= now && setting.end_date > now);
        }
    }
    PromotedSettingsUtil.GetUnacknowledgedPromotedSettings = GetUnacknowledgedPromotedSettings;
    // Update notification on main menu settings button when settings are viewed, then unregister.
    const hPromotedSettingsViewedEvt = $.RegisterForUnhandledEvent("MainMenu_PromotedSettingsViewed", () => {
        // Save dismissal
        GameInterfaceAPI.SetSettingString("cl_promoted_settings_acknowledged", "" + g_PromotedSettingsVersion + ":" + Date.now());
        $.UnregisterForUnhandledEvent("MainMenu_PromotedSettingsViewed", hPromotedSettingsViewedEvt);
    });
})(PromotedSettingsUtil || (PromotedSettingsUtil = {}));
