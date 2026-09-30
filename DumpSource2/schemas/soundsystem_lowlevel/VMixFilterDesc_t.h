class VMixFilterDesc_t
{
	float32 m_fldbGain;
	float32 m_flCutoffFreq; // = 1000
	float32 m_flQ; // = 0.707107
	VMixFilterType_t m_nFilterType; // = "FILTER_UNKNOWN"
	VMixFilterSlope_t m_nFilterSlope; // = "FILTER_SLOPE_12dB"
	bool m_bEnabled; // = true
};
