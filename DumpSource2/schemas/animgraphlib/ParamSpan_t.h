class ParamSpan_t
{
	CUtlVector< ParamSpanSample_t > m_samples;
	CAnimParamHandle m_hParam;
	AnimParamType_t m_eParamType; // = "ANIMPARAM_UNKNOWN"
	float32 m_flStartCycle;
	float32 m_flEndCycle;
};
