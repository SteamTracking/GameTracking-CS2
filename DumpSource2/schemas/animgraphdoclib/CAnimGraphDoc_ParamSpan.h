// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_ParamSpan
{
	CUtlVector< CAnimGraphDoc_ParamSpanSample > m_samples;
	// MPropertyHideField
	CUtlString m_paramName;
	AnimParamID m_id;
	float32 m_flStartCycle;
	float32 m_flEndCycle; // = 1
};
