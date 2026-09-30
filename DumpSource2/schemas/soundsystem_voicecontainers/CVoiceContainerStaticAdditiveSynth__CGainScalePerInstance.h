class CVoiceContainerStaticAdditiveSynth::CGainScalePerInstance
{
	// MPropertyFriendlyName = "Quietest Volume"
	float32 m_flMinVolume; // = 1
	// MPropertyFriendlyName = "# Instances Playing Until We Get Louder Than Quietest Volume"
	int32 m_nInstancesAtMinVolume; // = 1
	// MPropertyFriendlyName = "Loudest Volume"
	float32 m_flMaxVolume; // = 1
	// MPropertyFriendlyName = "# Instances Playing Required To Reach Loudest Volume"
	int32 m_nInstancesAtMaxVolume; // = 1
};
