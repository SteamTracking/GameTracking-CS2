class VMixDualCompressorDesc_t
{
	float32 m_flRMSTimeMS; // = 300
	float32 m_fldbKneeWidth;
	float32 m_flWetMix; // = 1
	bool m_bPeakMode;
	VMixDynamicsBand_t m_bandDesc; // = { "m_bEnable": false, "m_bSolo": false, "m_flAttackTimeMS": 50, "m_flRatioAbove": 4, "m_flRatioBelow": 12, "m_flReleaseTimeMS": 200, "m_fldbGainInput": 0, "m_fldbGainOutput": 0, "m_fldbThresholdAbove": -30, "m_fldbThresholdBelow": -40 }
};
