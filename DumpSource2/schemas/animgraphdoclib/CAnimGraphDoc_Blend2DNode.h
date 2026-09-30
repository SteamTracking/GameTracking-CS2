// MPropertyFriendlyName = "Blend 2D"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_Blend2DNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_Blend2DItem > > m_items;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_TagSpan > > m_tagSpans;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_ParamSpan > > m_paramSpans;
	// MPropertyFriendlyName = "Horizontal Axis"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_blendSourceX; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramNameX;
	// MPropertyFriendlyName = "Horizontal Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_paramX;
	// MPropertyFriendlyName = "Vertical Axis"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_blendSourceY; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramNameY;
	// MPropertyFriendlyName = "Vertical Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_paramY;
	// MPropertyFriendlyName = "Blend Mode"
	Blend2DMode m_eBlendMode; // = "Blend2DMode_General"
	// MPropertyFriendlyName = "Loop"
	bool m_bLoop; // = true
	// MPropertyFriendlyName = "Lock Blend on Reset"
	bool m_bLockBlendOnReset;
	// MPropertyFriendlyName = "Lock Blend When Waning"
	bool m_bLockWhenWaning; // = true
	// MPropertyFriendlyName = "Playback Speed"
	float32 m_playbackSpeed; // = 1
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	// MPropertyFriendlyName = "AnimEvents and Tags Exclusive To Most Weighted"
	bool m_bAnimEventsAndTagsOnMostWeightedOnly;
};
