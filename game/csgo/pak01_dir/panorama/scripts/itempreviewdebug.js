"use strict";

function OnReload()
{
    $.Msg( 'OnReload button pressed' );
}

function TestJS()
{
    $.Msg('TESTJS...');
    var parent = $.GetContextPanel().GetParent();

    //$.Msg(parent.manifest);

    // Set manifest manually
    //parent.manifest = '';

    // Set item manually
    //parent.item = '';

    // Set scene manifest and item manually, and initialize scene
    //parent.SetScene( string manifestFilename, string itemID_or_MDLname );

    // Set which model to display for player/character
    // resets scene, so all items that were equipped/added are no longer visibe other than those in the manifest
    // use EquipPlayerFromLoadout or EquipPlayerWithItem after calling this to re-add items
    //parent.SetPlayerModel( string playerMDL ); 

    // Equip the player model with the item defines by the team and loadout slot
    // valid team strings - 't', 'ct', 'noteam'
    // valid loadout_position strings - from g_szLoadoutStringsSubPositions in cstrike15_item_schema.cpp,
    // i.e. 'smg0', 'rifle3', 'heavy2', etc  
    //parent.EquipPlayerFromLoadout( string team, string loadout_position );

    // Equip the player with this item id
    //parent.EquipPlayerWithItem( string itemID );

    // Set scene rotation, rotation around scene X, Y, Z, ~ radians/second
    //parent.SetSceneRotation( float rotX, float rotY, float RotZ );

    // Set scene orientation in x, y, Z, optionally reset (dynamic) item rotation
    //parent.SetSceneAngles( float rotX, float rotY, float RotZ, bool bResetItemRotation );

    // Set intensity of Flashlight (shadow casting light), 0 = off, 1 = full intensity (color from manifest)
    //parent.SetFlashlightAmount( float amount );

    // Set Flashlight pulse and flicker settings
    // Can combine both pulse and flicker or have one or the other
    // argument (a, b, c, d), where
    // pulseTime - seconds per pule
    // pulseAmount - pulse amount, 0 - off 1 - full, > 1 allows intensity values > 1
    // flickerRate - flicker rate, higher => slower flicker
    // flickerAmount - flicker amount, same control as pulse amount   
    // examples: 
    // flicker[2 0.5 0 0] – pulsing light, no flicker, taking 2 seconds to pulse in and out, and the light intensity will pulse between 0.5 and 1.5
    // flicker[0 0 1 1] – flickering light, no pulsing, fast flicker (1 second perlin noise sweep), flickers light intensity between 0 and 2 
    // flicker[0 0 1 2] – flickering light, no pulsing, fast flicker (1 second perlin noise sweep), flickers light intensity between -1 (clamped at 0) and +3.
    // flicker[3 2 0.1 2] – 3 second pulse that turns light off when less than 0 intensity, light also flickers rapidly and intensely.
    // flicker[3 0.2 0.1 0.4] – much less extreme version of above (but still flickers and pulses at the same speed)
    // flicker[7 0.2 2 0.4] – much slower pulse and slower flicker than above.
    //parent.SetFlashlightPulseFlicker( float pulseTime, float pulseAmount, float flickerRate, float flickerAmount );

    // Set rotation speed for flashlight, rotation around world X, y, Z
    // rotates flashlight position as well as orientation so it's pointing at the same location as when
    // initialized from the manifest
    //parent.SetFlashlightRotation( float rotX, float rotY, float rotZ );

    // Set which directional light to modify with calls to SetDirectionalLightPulseFlicker and SetDirectionalLightRotation
    // directionalLightIndex - corresponds to order of light_directional_add in manifest
    //parent.SetDirectionalLightModify( int directionalLightIndex );

    // same control as SetFlashlightPulseFlicker above
    //parent.SetDirectionalLightPulseFlicker( float pulseTime, float pulseAmount, float flickerRate, float flickerAmount );

    // same control as SetFlashlightRotation above, but just rotates light direction
    //parent.SetDirectionalLightRotation( float rotX, float rotY, float rotZ );

    // Reset panel/player animation state and sequences - clears all queued and layered sequences
    // if reset is true, resets to manifest animation
    // parent.ResetAnimation( true );

    // Queue an animation sequence on the panel. 
    // Queued sequences play in order from start to finish, then switch immediately to playing the next one in the queue
    // sequenceName can be name of sequence or one of 'randomspawn', 'randomidle'
    // playImmediately true sets sequence to head of queue and plays immediately, otherwise added to the end of queued sequences
    // parent.PlaySequence( string sequenceName, bool playImmediately );

    // Add an animation sequence layer to the panel. (current max is 8 layers).
    // Layered sequences are accumulated on top of the current queued sequence.
    // They are blended in and out.
    // loop - if true sequence will loop, otherwise will play once and be removed from the layers list.
    // transitionFromPrevious - if true will wait until previously layered sequence is finishing, and blend in while previous is blending out. A string of sequences can be added this way, all blending into each other.
    // parent.PlaySequence( string sequenceName, bool playImmediately );

    // Set the world space position for the next particle effect to be added, XYZ.
    // Position is used as an offset if particle effect is added to an attach point 
    // parent.SetParticleSystemOffsetPosition( X, Y, Z );

    // Add a particle effect to the panel, 
    // particleEffectName - name of particle effect
    // attachName - name of attach point in scene if present, or '' to just use the particleOffsetPosition above
    //              if attach point exists, particleOffsetPosition is added to the attach position
    // parent.AddParticleSystem( string particleEffectName, string attachName, bool bLoop );

    // testing

    //parent.SetSceneRotation( 0, 1, 0 );
    //parent.SetFlashlightPulseFlicker( 2, 0, 1, 1 );
    //parent.SetDirectionalLightModify(1);
    //parent.SetDirectionalLightPulseFlicker( 2, 0.5, 1, 1 );
    //parent.EquipPlayerWithItem('img://inventory_18446744069414584384');
    parent.EquipPlayerFromLoadout( 'ct', 'rifle3' );

}

function ParticleTest()
{
    $.Msg('ParticleTest...');
    var parent = $.GetContextPanel().GetParent();
    
    parent.SetParticleSystemOffsetPosition( 0.0, 0.0, 0.0 );

    parent.AddParticleSystem( 'weapon_confetti_omni', 'weapon_hand_R', true );

    //parent.AddParticleSystem( 'copter_land_loop_1', '', true );
    //parent.AddParticleSystem( 'burning_character', '', true );

    //parent.AddParticleSystem( 'moneycrate_impact_burst', '', false );
    //parent.AddParticleSystem( 'moneycrate_burst_confetti', '', false );

    //parent.AddParticleSystem( 'weapon_confetti', false );
 }
 