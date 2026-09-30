class VMixBoxverbDesc_t
{
	float32 m_flSizeMax;
	float32 m_flSizeMin;
	float32 m_flComplexity;
	float32 m_flDiffusion;
	float32 m_flModDepth;
	float32 m_flModRate;
	bool m_bParallel;
	VMixFilterDesc_t m_filterType; // = { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }
	float32 m_flWidth;
	float32 m_flHeight;
	float32 m_flDepth;
	float32 m_flFeedbackScale;
	float32 m_flFeedbackWidth;
	float32 m_flFeedbackHeight;
	float32 m_flFeedbackDepth;
	float32 m_flOutputGain;
	float32 m_flTaps;
};
