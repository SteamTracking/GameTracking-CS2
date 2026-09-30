import { Instance } from "cs_script/point_script";

let ConvDir = false;
let ConvPow = false;

Instance.OnBeforeReload(() =>
{
    return { dir: ConvDir, pow: ConvPow };
} );
Instance.OnReload(conv =>
{
    ConvDir = conv?.dir || false;
    ConvPow = conv?.pow || false;
} );

function SetConveyorSpeed ( name, speed, transitionDuration = 10 )
{
	Instance.EntFireAtName( name, "SetTransitionDuration", transitionDuration.toString() );
	Instance.EntFireAtName( name, "SetSpeed", speed.toString() );
}

function ConveyorReset ()
{
	Instance.EntFireAtName( "conveyor_power_switch_mover", "Close" );
	Instance.EntFireAtName( "conveyor_power_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "conveyor_power_indicator", "Skin", "0" );
	Instance.EntFireAtName( "button_stop_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "button_stop_indicator", "Skin", "0" );
	                                                             
	Instance.EntFireAtName( "button_stop", "Lock" );
	Instance.EntFireAtName( "conveyor_control_sign", "SetSpeed", "0" );
	SetConveyorSpeed( "conveyor_a2_upper_mid", 0 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_06", 0 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_05", 0 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_04", 0 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_03", 0 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_02", 0 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_01", 0 );
	SetConveyorSpeed( "conveyor_a2_lower_02", 0 );
	SetConveyorSpeed( "conveyor_a2_lower_01", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_mid", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_06", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_05", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_04", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_03", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_02", 0 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_01", 0 );
	SetConveyorSpeed( "conveyor_a1_lower_03", 0 );
	SetConveyorSpeed( "conveyor_a1_lower_02", 0 );
	SetConveyorSpeed( "conveyor_a1_lower_01", 0 );
}

function ConveyorStop ()
{
	Instance.EntFireAtName( "conveyor_power_switch_mover", "Close" );
	Instance.EntFireAtName( "conveyor_power_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "conveyor_power_indicator", "Skin", "0" );
	Instance.EntFireAtName( "button_stop_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "button_stop_indicator", "Skin", "0" );
	                                                             
	Instance.EntFireAtName( "button_stop", "Lock" );
	Instance.EntFireAtName( "conveyor_control_sign", "SetSpeed", "0" );
	SetConveyorSpeed( "conveyor_a2_upper_mid", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_06", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_05", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_04", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_03", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_02", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_01", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_lower_02", 0, 1 );
	SetConveyorSpeed( "conveyor_a2_lower_01", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_mid", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_06", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_05", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_04", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_03", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_02", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_01", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_lower_03", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_lower_02", 0, 1 );
	SetConveyorSpeed( "conveyor_a1_lower_01", 0, 1 );
	Instance.EntFireAtName( "snd.conveyor_winddown", "PlaySound" );
}

function ConveyorPlane ()
{
	Instance.EntFireAtName( "conveyor_dir_switch_mover", "Close" );
	Instance.EntFireAtName( "button_stop", "Lock" );
	Instance.EntFireAtName( "button_stop_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "button_stop_indicator", "Skin", "0" );
	                                                             
	SetConveyorSpeed( "conveyor_a2_upper_mid", -5 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_06", -190 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_05", -190 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_04", -190 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_03", -20 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_02", -20 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_01", -20 );
	SetConveyorSpeed( "conveyor_a2_lower_02", -190 );
	SetConveyorSpeed( "conveyor_a2_lower_01", -190 );
	SetConveyorSpeed( "conveyor_a1_upper_mid", -5 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_06", -190 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_05", -190 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_04", -190 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_03", -20 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_02", -20 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_01", -20 );
	SetConveyorSpeed( "conveyor_a1_lower_03", -190 );
	SetConveyorSpeed( "conveyor_a1_lower_02", -190 );
	SetConveyorSpeed( "conveyor_a1_lower_01", -190 );
	Instance.EntFireAtName( "conveyor_control_sign", "SetSpeed", "-190" );
	Instance.EntFireAtName( "conveyor_direction_button", "Lock" );
	Instance.EntFireAtName( "conveyor_dir_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "conveyor_dir_indicator", "Skin", "0" );
	Instance.EntFireAtName( "button_stop", "Unlock", "", 11 );                    
	Instance.EntFireAtName( "button_stop_indicator", "Color", "255 0 0", 11 );                 
	Instance.EntFireAtName( "button_stop_indicator", "Skin", "1", 11 );
	Instance.EntFireAtName( "conveyor_dir_indicator", "Color", "0 255 0", 11 );                 
	Instance.EntFireAtName( "conveyor_dir_indicator", "Skin", "1", 11 );
	Instance.EntFireAtName( "conveyor_direction_button", "Unlock", "", 11 );                 
}

function ConveyorBaggage ()
{
	Instance.EntFireAtName( "button_stop_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "button_stop_indicator", "Skin", "0" );
	                                                             
	Instance.EntFireAtName( "button_stop", "Lock" );
	Instance.EntFireAtName( "conveyor_dir_switch_mover", "Open" );
	Instance.EntFireAtName( "relay.snd.direction_change", "Trigger" );
	SetConveyorSpeed( "conveyor_a2_upper_mid", 5 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_06", 20 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_05", 20 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_04", 20 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_03", 190 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_02", 190 );
	SetConveyorSpeed( "conveyor_a2_upper_cross_01", 190 );
	SetConveyorSpeed( "conveyor_a2_lower_02", 190 );
	SetConveyorSpeed( "conveyor_a2_lower_01", 190 );
	SetConveyorSpeed( "conveyor_a1_upper_mid", 5 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_06", 20 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_05", 20 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_04", 20 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_03", 190 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_02", 190 );
	SetConveyorSpeed( "conveyor_a1_upper_cross_01", 190 );
	SetConveyorSpeed( "conveyor_a1_lower_03", 190 );
	SetConveyorSpeed( "conveyor_a1_lower_02", 190 );
	SetConveyorSpeed( "conveyor_a1_lower_01", 190 );
	Instance.EntFireAtName( "conveyor_control_sign", "SetSpeed", "190" );
	Instance.EntFireAtName( "conveyor_dir_indicator", "Color", "255 255 255" );
	Instance.EntFireAtName( "conveyor_dir_indicator", "Skin", "0" );
	Instance.EntFireAtName( "conveyor_direction_button", "Lock" );
	Instance.EntFireAtName( "button_stop", "Unlock", "", 11 );                    
	Instance.EntFireAtName( "button_stop_indicator", "Color", "255 0 0", 11 );                 
	Instance.EntFireAtName( "button_stop_indicator", "Skin", "1", 11 );
	Instance.EntFireAtName( "conveyor_dir_indicator", "Color", "0 255 0", 11 );                 
	Instance.EntFireAtName( "conveyor_dir_indicator", "Skin", "1", 11 );
	Instance.EntFireAtName( "conveyor_direction_button", "Unlock", "", 11 );                 
}

Instance.OnScriptInput( "ToggleDir", () =>
{

	ConvDir = !ConvDir;

	if ( ConvDir == false && ConvPow == true )
	{
		ConveyorPlane();
		Instance.EntFireAtName( "snd.conveyor_reverse", "PlaySound" );
	}

	if ( ConvDir == true && ConvPow == true )
	{
		ConveyorBaggage();
		Instance.EntFireAtName( "snd.conveyor_reverse", "PlaySound" );
	}

	if ( ConvDir == true && ConvPow == false )
	{
		Instance.EntFireAtName( "conveyor_dir_switch_mover", "Open" );
	}

	if ( ConvDir == false && ConvPow == false )
	{
		Instance.EntFireAtName( "conveyor_dir_switch_mover", "Close" );
	}

} );


Instance.OnScriptInput( "TogglePow", () =>
{

	ConvPow = !ConvPow;

	if ( ConvPow == true && ConvDir == false )
	{
		Instance.EntFireAtName( "conveyor_power_switch_mover", "Open" );
		Instance.EntFireAtName( "conveyor_power_indicator", "Color", "0 255 0" );
		Instance.EntFireAtName( "conveyor_power_indicator", "Skin", "1" );
		Instance.EntFireAtName( "button_stop_indicator", "Color", "255 0 0" );
		Instance.EntFireAtName( "button_stop_indicator", "Skin", "1" );
		Instance.EntFireAtName( "snd.conveyor_loop", "PlaySound" );
		Instance.EntFireAtName( "snd.conveyor_windup_loop", "PlaySound" );
		StopStopLightLoop();
		ConveyorPlane();
	}

	if ( ConvPow == true && ConvDir == true )
	{
		Instance.EntFireAtName( "conveyor_power_switch_mover", "Open" );
		Instance.EntFireAtName( "conveyor_power_indicator", "Color", "0 255 0" );
		Instance.EntFireAtName( "conveyor_power_indicator", "Skin", "1" );
		Instance.EntFireAtName( "button_stop_indicator", "Color", "255 0 0" );
		Instance.EntFireAtName( "button_stop_indicator", "Skin", "1" );
		Instance.EntFireAtName( "snd.conveyor_loop", "PlaySound" );
		Instance.EntFireAtName( "snd.conveyor_windup_loop", "PlaySound" )
		StopStopLightLoop();
		ConveyorBaggage();
	}

	if ( ConvPow == false )
	{
		Instance.EntFireAtName( "snd.conveyor_loop", "StopSound" );
		Instance.EntFireAtName( "snd.conveyor_windup_loop", "StopSound" );
		ConveyorReset();
	}
} );

Instance.OnScriptInput( "PowOff", () =>
{
	if ( ConvPow == true )
	{
		ConvPow = !ConvPow;
		ConveyorStop();
		Instance.EntFireAtName( "snd.conveyor_winddown", "PlaySound" );
		Instance.EntFireAtName( "snd.conveyor_loop", "StopSound" );
		Instance.EntFireAtName( "snd.conveyor_windup_loop", "StopSound" );
		StartStopLightLoop();
		Instance.EntFireAtName( "button_stop", "Lock" );
	}
} );

let bLooping = false;

function StartStopLightLoop ()
{
	bLooping = true;
	Instance.EntFireAtName( "button_stop_light_loop", "Trigger", "" );
}

Instance.OnScriptInput( "StopLightLoop", () =>
{
	if ( bLooping == false )
		return;

	Instance.EntFireAtName( "button_stop_light", "Skin", "1", 0 );
	Instance.EntFireAtName( "button_stop_light", "Skin", "0", 0.15 );
	Instance.EntFireAtName( "button_stop_light", "Skin", "1", .3 );
	Instance.EntFireAtName( "button_stop_light", "Skin", "0", .45 );

	Instance.EntFireAtName( "button_stop_light_loop", "Trigger", "", 1.5 );
} );

function StopStopLightLoop () 
{
	bLooping = false;
}