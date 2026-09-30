// MPropertyFriendlyName = "VMix 3 Band Dynamics Node"
// MPropertyDescription = "This is a multi-band dynamics processor.  First the signal is split into low/mid/high bands, then each band is routed through two compressors providing upward and downward compression to each band.  Input & Output gain can also be adjusted."
// MHasKV3TransferPolymorphicClassname
class CMixDynamics3Band : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Output Gain (dB)"
	// MPropertyAttributeRange = "-18 18"
	float32 m_fldbOutputGain;
	// MPropertyFriendlyName = "Threshold detection time (ms)"
	float32 m_flRMSTime; // = 500
	// MPropertyFriendlyName = "Depth [0.0 - 1.0]"
	// MPropertyAttributeRange = "0 1"
	float32 m_flDepth; // = 1
	// MPropertyFriendlyName = "Wet [0.0 - 1.0]"
	// MPropertyAttributeRange = "0 1"
	float32 m_flWetMix; // = 1
	// MPropertyFriendlyName = "Time Scale [0.0 - 10.0]"
	// MPropertyAttributeRange = "0 10"
	float32 m_flTimeScale; // = 1
	// MPropertyFriendlyName = "Knee width (dB) 0 = hard knee"
	float32 m_fldbKneeWidth; // = 5
	// MPropertyFriendlyName = "Low Cutoff Freq (Hz)"
	float32 m_flLowCutoffFreq; // = 88.300003
	// MPropertyFriendlyName = "High Cutoff Freq (Hz)"
	float32 m_flHighCutoffFreq; // = 2500
	// MPropertyFriendlyName = "Peak Mode"
	bool m_bPeakMode;
	// MPropertyHideField
	int32 m_nSelectedPage;
	VMixDynamicsBand_t[3] m_bands; // = [ { "m_bEnable": true, "m_bSolo": false, "m_flAttackTimeMS": 47.799999, "m_flRatioAbove": 39, "m_flRatioBelow": 4.17, "m_flReleaseTimeMS": 282, "m_fldbGainInput": 5.2, "m_fldbGainOutput": 8, "m_fldbThresholdAbove": -33.799999, "m_fldbThresholdBelow": -40.799999 }, { "m_bEnable": true, "m_bSolo": false, "m_flAttackTimeMS": 22.4, "m_flRatioAbove": 39, "m_flRatioBelow": 4.17, "m_flReleaseTimeMS": 282, "m_fldbGainInput": 5.2, "m_fldbGainOutput": 4.42, "m_fldbThresholdAbove": -30.200001, "m_fldbThresholdBelow": -41.799999 }, { "m_bEnable": true, "m_bSolo": false, "m_flAttackTimeMS": 13.5, "m_flRatioAbove": 80, "m_flRatioBelow": 4.17, "m_flReleaseTimeMS": 132, "m_fldbGainInput": 5.2, "m_fldbGainOutput": 8, "m_fldbThresholdAbove": -35.5, "m_fldbThresholdBelow": -40.799999 } ]
};
