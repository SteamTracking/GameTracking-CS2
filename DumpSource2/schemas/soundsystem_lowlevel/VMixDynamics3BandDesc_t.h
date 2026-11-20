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
	VMixDynamicsBand_t[3] m_bandDesc;
};
