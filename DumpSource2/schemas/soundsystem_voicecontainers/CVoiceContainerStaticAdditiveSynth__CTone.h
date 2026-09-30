class CVoiceContainerStaticAdditiveSynth::CTone
{
	// MPropertyFriendlyName = "Harmonics"
	CUtlVector< CVoiceContainerStaticAdditiveSynth::CHarmonic > m_harmonics;
	// MPropertyFriendlyName = "Envelope"
	CPiecewiseCurve m_curve;
	// MPropertyFriendlyName = "Play All Instances In Sync"
	bool m_bSyncInstances;
};
