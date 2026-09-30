// MPropertyFriendlyName = "Selector"
// MPropertyDescription = "Plays a selected vsnd on playback."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerSelector : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Playback Mode"
	PlayBackMode_t m_mode; // = "Random"
	// MPropertyFriendlyName = "Sounds To play"
	CSoundContainerReferenceArray m_soundsToPlay; // = { "m_bUseReference": true, "m_pSounds": [  ], "m_sounds": [  ] }
	// MPropertyFriendlyName = "Relative Weights"
	CUtlVector< float32 > m_fProbabilityWeights;
};
