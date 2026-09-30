// MPropertyFriendlyName = "Envelope Analyzer"
// MPropertyDescription = "Generates an Envelope Curve on compile"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerEnvelopeAnalyzer : public CVoiceContainerAnalysisBase
{
	// MPropertyFriendlyName = "Envelope Mode"
	EMode_t m_mode; // = "Peak"
	// MPropertyFriendlyName = "Analysis Window"
	float32 m_fAnalysisWindowMs; // = 200
	// MPropertyFriendlyName = "Threshold"
	float32 m_flThreshold;
};
