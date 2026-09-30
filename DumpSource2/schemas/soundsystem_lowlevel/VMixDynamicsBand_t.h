class VMixDynamicsBand_t
{
	// MPropertyFriendlyName = "Input Gain (dB)"
	float32 m_fldbGainInput;
	// MPropertyFriendlyName = "Output Gain (dB)"
	float32 m_fldbGainOutput;
	// MPropertyFriendlyName = "Below Threshold(dB)"
	float32 m_fldbThresholdBelow; // = -40
	// MPropertyFriendlyName = "Above Threshold(dB)"
	float32 m_fldbThresholdAbove; // = -30
	// MPropertyFriendlyName = "Upward Ratio"
	float32 m_flRatioBelow; // = 12
	// MPropertyFriendlyName = "Downward Ratio"
	float32 m_flRatioAbove; // = 4
	// MPropertyFriendlyName = "Attack time (ms)"
	float32 m_flAttackTimeMS; // = 50
	// MPropertyFriendlyName = "Release time (ms)"
	float32 m_flReleaseTimeMS; // = 200
	// MPropertyFriendlyName = "Enabled"
	bool m_bEnable;
	// MPropertyFriendlyName = "Solo"
	bool m_bSolo;
};
