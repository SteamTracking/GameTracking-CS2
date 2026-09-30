// MPropertyFriendlyName = "Random Sampler Container"
// MPropertyDescription = "Trash Synth"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerRandomSampler : public CVoiceContainerAsyncGenerator
{
	float32 m_flAmplitude; // = 0.8
	float32 m_flAmplitudeJitter; // = 0.1
	float32 m_flTimeJitter; // = 0.2
	float32 m_flMaxLength; // = -1
	int32 m_nNumDelayVariations;
	CUtlVector< CStrongHandle< InfoForResourceTypeCVoiceContainerBase > > m_grainResources;
};
