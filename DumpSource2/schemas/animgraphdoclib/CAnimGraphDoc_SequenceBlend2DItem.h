// MPropertyFriendlyName = "Sequence Blend Item"
// MPropertyElementNameFn
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SequenceBlend2DItem : public CAnimGraphDoc_Blend2DItem
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_TagSpan > > m_tagSpans;
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_sequenceName;
};
