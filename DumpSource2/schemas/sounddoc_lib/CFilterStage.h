class CFilterStage
{
	// MPropertyFriendlyName = "Filter Type"
	// MPropertyAttributeChoiceName = "filter_type"
	CUtlString m_filterType; // = "FILTER_LOWPASS"
	// MPropertyFriendlyName = "Center Frequency (Hz)"
	// MPropertyAttributeRange = "biased 20 22000"
	float32 m_flFrequency; // = 11025
	// MPropertyFriendlyName = "Q"
	// MPropertyAttributeRange = "0.1 12"
	float32 m_flQ; // = 0.707
	// MPropertyFriendlyName = "Gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbGain; // = 1
	// MPropertyFriendlyName = "Slope"
	VMixFilterSlope_t m_nFilterSlope; // = "FILTER_SLOPE_12dB"
	// MPropertyFriendlyName = "Channel Set"
	VMixFilterChannelSet_t m_nChannelSet; // = "FILTER_ALL_CHANNELS"
	// MPropertyFriendlyName = "Enabled"
	bool m_bEnable; // = true
};
