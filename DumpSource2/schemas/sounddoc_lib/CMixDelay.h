// MPropertyFriendlyName = "VMix Delay Audio Node"
// MPropertyDescription = "Stereo delay with resonant filter on feedback."
// MHasKV3TransferPolymorphicClassname
class CMixDelay : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Delay (ms)"
	// MPropertyGroupName = "+Delay"
	// MPropertyAttributeRange = "0 2000"
	float32 m_flDelay; // = 500
	// MPropertyFriendlyName = "DirectGain (dB)"
	// MPropertyGroupName = "Delay"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbDirectGain;
	// MPropertyFriendlyName = "DelayGain (dB)"
	// MPropertyGroupName = "Delay"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbDelayGain; // = -3
	// MPropertyFriendlyName = "FeedbackGain (dB)"
	// MPropertyGroupName = "Delay"
	// MPropertyAttributeRange = "-60 12"
	float32 m_fldbFeedbackGain; // = -3
	// MPropertyFriendlyName = "Width"
	// MPropertyAttributeRange = "0 1.0"
	float32 m_flWidth;
	// MPropertyFriendlyName = "EnableFilter"
	// MPropertyGroupName = "+Filter"
	bool m_bEnableFilter;
	// MPropertyFriendlyName = "Filter Type"
	// MPropertyGroupName = "Filter"
	// MPropertyAttributeChoiceName = "filter_type"
	CUtlString m_filterType; // = "FILTER_LOWPASS"
	// MPropertyFriendlyName = "Center Frequency (Hz)"
	// MPropertyGroupName = "Filter"
	// MPropertyAttributeRange = "biased 20 22000"
	float32 m_flFrequency; // = 2000
	// MPropertyFriendlyName = "Q"
	// MPropertyGroupName = "Filter"
	// MPropertyAttributeRange = "0.1 12"
	float32 m_flQ; // = 0.707
	// MPropertyFriendlyName = "Filter Gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbGain;
};
