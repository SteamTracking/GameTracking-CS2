// MHasKV3TransferPolymorphicClassname
class CMotionGraph
{
	CParamSpanUpdater m_paramSpans;
	CUtlVector< TagSpan_t > m_tags;
	CSmartPtr< CMotionNode > m_pRootNode;
	int32 m_nParameterCount;
	int32 m_nConfigStartIndex; // = -1
	int32 m_nConfigCount; // = -1
	bool m_bLoop;
};
