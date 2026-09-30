// MPropertyFriendlyName = "Cycle Control Clip"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_CycleControlClipNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_TagSpan > > m_tagSpans;
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_sequenceName;
	// MPropertyFriendlyName = "Blend Source"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_valueSource; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Lock When Waning"
	bool m_bLockWhenWaning;
};
