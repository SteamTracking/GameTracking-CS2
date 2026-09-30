class VMixModDelayDesc_t
{
	VMixFilterDesc_t m_feedbackFilter; // = { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }
	bool m_bPhaseInvert;
	float32 m_flGlideTime;
	float32 m_flDelay;
	float32 m_flOutputGain;
	float32 m_flFeedbackGain;
	float32 m_flModRate;
	float32 m_flModDepth;
	bool m_bApplyAntialiasing;
};
