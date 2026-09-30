class VMixDelayDesc_t
{
	VMixFilterDesc_t m_feedbackFilter; // = { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }
	bool m_bEnableFilter;
	float32 m_flDelay;
	float32 m_flDirectGain;
	float32 m_flDelayGain;
	float32 m_flFeedbackGain;
	float32 m_flWidth;
};
