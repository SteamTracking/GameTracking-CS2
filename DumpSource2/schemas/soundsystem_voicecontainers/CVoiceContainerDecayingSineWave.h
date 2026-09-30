// MPropertyFriendlyName = "TESTBED: Decaying Sine Wave Container"
// MPropertyDescription = "Only text params, renders in real time"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerDecayingSineWave : public CVoiceContainerGenerator
{
	// MPropertyFriendlyName = "Frequency (Hz)"
	// MPropertyDescription = "The frequency of this sine tone."
	float32 m_flFrequency;
	// MPropertyFriendlyName = "Decay Time (Seconds)"
	// MPropertyDescription = "The frequency of this sine tone."
	float32 m_flDecayTime;
};
