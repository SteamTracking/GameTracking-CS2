// MPropertyFriendlyName = "Selector"
// MPropertyDescription = "Plays a selected vsnd on playback."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerSelector : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Playback Mode"
	PlayBackMode_t m_mode; // = "Random"
	// MPropertyFriendlyName = "Sounds To play"
	CSoundContainerReferenceArray m_soundsToPlay;
	// MPropertyFriendlyName = "Relative Weights"
	CUtlVector< float32 > m_fProbabilityWeights;
};
