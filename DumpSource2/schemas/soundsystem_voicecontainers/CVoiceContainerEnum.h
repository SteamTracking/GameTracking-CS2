// MPropertyFriendlyName = "VSND Enum"
// MPropertyDescription = "Switches between a selection of vsnds based on a provided index."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerEnum : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Sounds To Play"
	CSoundContainerReferenceArray m_soundsToPlay; // = { "m_bUseReference": true, "m_pSounds": [  ], "m_sounds": [  ] }
	// MPropertyFriendlyName = "Index"
	int32 m_iSelection;
	// MPropertyFriendlyName = "Crossfade Time"
	float32 m_flCrossfadeTime; // = 0.1
};
