// MPropertyFriendlyName = "VMix Dynamics Audio Node"
// MPropertyDescription = "A dynamics multiprocessor.  This is a single unit that switches between being a noise gate, compressor, or limiter as the signal moves through its dynamic range.  Useful in some specific cases, e.g. gate+compress or gate+limit usually.  Other cases may be more suited to using multiple compressors in series."
// MHasKV3TransferPolymorphicClassname
class CMixDynamics : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Noise Gate Threshold(dB)"
	float32 m_fldbNoiseGateThreshold; // = -90
	// MPropertyFriendlyName = "Gain (dB)"
	float32 m_fldbGain;
	// MPropertyFriendlyName = "Compression Threshold(dB)"
	float32 m_fldbCompressionThreshold; // = -6
	// MPropertyFriendlyName = "Limiter Threshold(dB)"
	float32 m_fldbLimiterThreshold;
	// MPropertyFriendlyName = "Knee width (dB) 0 = hard knee"
	float32 m_fldbKneeWidth;
	// MPropertyFriendlyName = "Compression Ratio"
	float32 m_flRatio; // = 2
	// MPropertyFriendlyName = "Limiter Ratio"
	float32 m_flLimiterRatio; // = 40
	// MPropertyFriendlyName = "Attack time (ms)"
	float32 m_flAttackTime; // = 100
	// MPropertyFriendlyName = "Release time (ms)"
	float32 m_flReleaseTime; // = 200
	// MPropertyFriendlyName = "Threshold detection time (ms)"
	float32 m_flRMSTime; // = 200
	// MPropertyFriendlyName = "Dry/Wet"
	float32 m_flWetMix; // = 1
	// MPropertyFriendlyName = "Peak Mode"
	bool m_bPeakMode;
	int32 m_nUIPage;
};
