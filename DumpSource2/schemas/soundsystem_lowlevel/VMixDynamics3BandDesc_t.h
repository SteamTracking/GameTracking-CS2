class VMixDynamics3BandDesc_t
{
	float32 m_fldbGainOutput;
	float32 m_flRMSTimeMS;
	float32 m_fldbKneeWidth;
	float32 m_flDepth;
	float32 m_flWetMix;
	float32 m_flTimeScale;
	float32 m_flLowCutoffFreq;
	float32 m_flHighCutoffFreq;
	bool m_bPeakMode;
	VMixDynamicsBand_t[3] m_bandDesc; // = [ { "m_bEnable": false, "m_bSolo": false, "m_flAttackTimeMS": 50, "m_flRatioAbove": 4, "m_flRatioBelow": 12, "m_flReleaseTimeMS": 200, "m_fldbGainInput": 0, "m_fldbGainOutput": 0, "m_fldbThresholdAbove": -30, "m_fldbThresholdBelow": -40 }, { "m_bEnable": false, "m_bSolo": false, "m_flAttackTimeMS": 50, "m_flRatioAbove": 4, "m_flRatioBelow": 12, "m_flReleaseTimeMS": 200, "m_fldbGainInput": 0, "m_fldbGainOutput": 0, "m_fldbThresholdAbove": -30, "m_fldbThresholdBelow": -40 }, { "m_bEnable": false, "m_bSolo": false, "m_flAttackTimeMS": 50, "m_flRatioAbove": 4, "m_flRatioBelow": 12, "m_flReleaseTimeMS": 200, "m_fldbGainInput": 0, "m_fldbGainOutput": 0, "m_fldbThresholdAbove": -30, "m_fldbThresholdBelow": -40 } ]
};
