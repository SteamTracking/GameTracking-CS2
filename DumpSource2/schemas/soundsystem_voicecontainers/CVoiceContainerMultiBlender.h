// MPropertyFriendlyName = "Multi Blender"
// MPropertyDescription = "Blends any number of containers"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerMultiBlender : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Sounds To Blend"
	CSoundContainerReferenceArray m_soundsToPlay; // = { "m_bUseReference": true, "m_pSounds": [  ], "m_sounds": [  ] }
	// MPropertyFriendlyName = "Blend Amount (0.0 = 100% first sound, 1.0 = 100% last sound)"
	float32 m_flBlendFactor;
	// MPropertyFriendlyName = "Crossfade Amount (0.0 = no crossfade, 1.0 = constant crossfading)"
	float32 m_flCrossover; // = 1
};
