// MHasKV3TransferPolymorphicClassname
class CSequenceUpdateNode : public CSequenceUpdateNodeBase
{
	HSequence m_hSequence; // = -1
	float32 m_duration;
	CParamSpanUpdater m_paramSpans;
	CUtlVector< TagSpan_t > m_tags;
};
