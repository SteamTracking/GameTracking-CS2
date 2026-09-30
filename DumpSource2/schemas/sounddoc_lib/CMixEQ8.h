// MPropertyFriendlyName = "VMix EQ8 Audio Node"
// MPropertyDescription = "Up to 8 bands of EQ.  Boost/cut up to 8 bands with adjustable Q.  Filters can also be configured as low/high pass or low/high shelf."
// MHasKV3TransferPolymorphicClassname
class CMixEQ8 : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "EQ Stages"
	CFilterStage[8] m_stages; // = [ { "m_bEnable": true, "m_filterType": "FILTER_LOW_SHELF", "m_flFrequency": 80, "m_flQ": 1, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": true, "m_filterType": "FILTER_PEAKING_EQ", "m_flFrequency": 500, "m_flQ": 3, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": false, "m_filterType": "FILTER_PEAKING_EQ", "m_flFrequency": 750, "m_flQ": 3, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": true, "m_filterType": "FILTER_PEAKING_EQ", "m_flFrequency": 1200, "m_flQ": 3, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": false, "m_filterType": "FILTER_PEAKING_EQ", "m_flFrequency": 2000, "m_flQ": 3, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": true, "m_filterType": "FILTER_PEAKING_EQ", "m_flFrequency": 3000, "m_flQ": 3, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": false, "m_filterType": "FILTER_PEAKING_EQ", "m_flFrequency": 5000, "m_flQ": 3, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" }, { "m_bEnable": true, "m_filterType": "FILTER_HIGH_SHELF", "m_flFrequency": 12000, "m_flQ": 1, "m_fldbGain": 0, "m_nChannelSet": "FILTER_ALL_CHANNELS", "m_nFilterSlope": "FILTER_SLOPE_12dB" } ]
};
