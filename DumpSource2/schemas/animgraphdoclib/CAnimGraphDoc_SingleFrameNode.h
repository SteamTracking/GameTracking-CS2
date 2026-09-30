// MPropertyFriendlyName = "Single Frame"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SingleFrameNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_sequenceName;
	// MPropertyFriendlyName = "Frame Selection"
	// MPropertyAutoRebuildOnChange
	SingleFrameSelection m_eFrameSelection; // = "SpecificFrame"
	// MPropertyFriendlyName = "Frame Index"
	// MPropertyAttrStateCallback
	int32 m_nFrameIndex;
	CUtlVector< CSmartPtr< CAnimGraphDoc_Action > > m_actions;
};
