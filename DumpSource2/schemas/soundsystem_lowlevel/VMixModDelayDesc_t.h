class VMixModDelayDesc_t
{
	VMixFilterDesc_t m_feedbackFilter;
	bool m_bPhaseInvert;
	float32 m_flGlideTime;
	float32 m_flDelay;
	float32 m_flOutputGain;
	float32 m_flFeedbackGain;
	float32 m_flModRate;
	float32 m_flModDepth;
	bool m_bApplyAntialiasing;
};
