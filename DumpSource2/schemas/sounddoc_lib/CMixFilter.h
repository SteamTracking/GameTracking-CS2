// MPropertyFriendlyName = "VMix Filter Audio Node"
// MPropertyDescription = "Resonant filter with adjustable slope. NOTE: This is a clean filter, not an analog model with distortion."
// MHasKV3TransferPolymorphicClassname
class CMixFilter : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Filter Type"
	// MPropertyAttributeChoiceName = "filter_type"
	CUtlString m_filterType; // = "FILTER_LOWPASS"
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Center Frequency (Hz)"
	// MPropertyAttributeRange = "biased 20 22000"
	float32 m_flFrequency; // = 2000
	// MPropertyFriendlyName = "Q"
	// MPropertyAttributeRange = "0.1 12"
	float32 m_flQ; // = 0.707
	// MPropertyFriendlyName = "Gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbGain;
	// MPropertyFriendlyName = "Filter slope"
	VMixFilterSlope_t m_nFilterSlope; // = "FILTER_SLOPE_12dB"
};
