// MPropertyFriendlyName = "Animation Clip"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SequenceNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_TagSpan > > m_tagSpans;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_ParamSpan > > m_paramSpans;
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_sequenceName;
	// MPropertyFriendlyName = "Playback Speed"
	float32 m_playbackSpeed; // = 1
	// MPropertyFriendlyName = "Loop"
	bool m_bLoop;
};
