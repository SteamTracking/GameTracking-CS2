// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_MotionItem
{
	// MPropertySuppressField
	CAnimGraphDoc_MotionParameterManager m_paramManager;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_TagSpan > > m_blockSpans;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_TagSpan > > m_tagSpans;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_ParamSpan > > m_paramSpans;
	// MPropertyFriendlyName = "Loop"
	bool m_bLoop;
};
