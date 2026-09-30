class VMixAutoFilterDesc_t
{
	float32 m_flEnvelopeAmount;
	float32 m_flAttackTimeMS; // = 5
	float32 m_flReleaseTimeMS; // = 200
	VMixFilterDesc_t m_filter; // = { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }
	float32 m_flLFOAmount;
	float32 m_flLFORate;
	float32 m_flPhase;
	VMixLFOShape_t m_nLFOShape; // = "LFO_SHAPE_SINE"
};
