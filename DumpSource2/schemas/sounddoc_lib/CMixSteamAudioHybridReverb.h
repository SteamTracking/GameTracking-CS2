// MPropertyFriendlyName = "VMix Steam Audio Hybrid Reverb Node"
// MPropertyDescription = "Applies Steam Audio Hybrid Reverb."
// MHasKV3TransferPolymorphicClassname
class CMixSteamAudioHybridReverb : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Reverb Time (RT60), Low Frequency"
	// MPropertyAttributeRange = "0.1 10.0"
	float32 m_flReverbTimeLow; // = 0.1
	// MPropertyFriendlyName = "Reverb Time (RT60), Mid Frequency"
	// MPropertyAttributeRange = "0.1 10.0"
	float32 m_flReverbTimeMid; // = 0.1
	// MPropertyFriendlyName = "Reverb Time (RT60), High Frequency"
	// MPropertyAttributeRange = "0.1 10.0"
	float32 m_flReverbTimeHigh; // = 0.1
	// MPropertyFriendlyName = "Reverb Time"
	// MPropertyAttributeRange = "0.1 10.0"
	CUtlVector< float32 > m_vecReverbTime;
};
