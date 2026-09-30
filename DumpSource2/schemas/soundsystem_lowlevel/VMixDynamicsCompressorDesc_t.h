class VMixDynamicsCompressorDesc_t
{
	// MPropertyFriendlyName = "Output Gain (dB)"
	float32 m_fldbOutputGain;
	// MPropertyFriendlyName = "Threshold (dB)"
	float32 m_fldbCompressionThreshold; // = -6
	// MPropertyFriendlyName = "Knee Width (dB)"
	float32 m_fldbKneeWidth;
	// MPropertyFriendlyName = "Compression Ratio"
	float32 m_flCompressionRatio; // = 2
	// MPropertyFriendlyName = "Attack time (ms)"
	float32 m_flAttackTimeMS; // = 100
	// MPropertyFriendlyName = "Release time (ms)"
	float32 m_flReleaseTimeMS; // = 400
	// MPropertyFriendlyName = "Threshold detection time (ms)"
	float32 m_flRMSTimeMS; // = 300
	// MPropertyFriendlyName = "Dry/Wet"
	float32 m_flWetMix; // = 1
	// MPropertyFriendlyName = "SideChain Highpass"
	float32 m_flSCHighPassFreq;
	// MPropertyFriendlyName = "Peak mode"
	bool m_bPeakMode;
	// MPropertyFriendlyName = "Auto Make-up Gain"
	bool m_bAutoMakeupGain;
};
