// MPropertyFriendlyName = "Bone Mask"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_BoneMaskNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Bone Mask"
	// MPropertyAttributeChoiceName = "BoneMask"
	CUtlString m_weightListName;
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection1;
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection2;
	// MPropertyFriendlyName = "Blend Space"
	BoneMaskBlendSpace m_blendSpace; // = "BlendSpace_Parent"
	// MPropertyFriendlyName = "Use Blend Source"
	// MPropertyAutoRebuildOnChange
	bool m_bUseBlendScale;
	// MPropertyFriendlyName = "Blend Source"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_blendValueSource; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_blendParameterName;
	// MPropertyFriendlyName = "Blend Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_blendParameter;
	// MPropertyFriendlyName = "Timing Control"
	// MPropertyAutoRebuildOnChange
	BinaryNodeTiming m_timingBehavior; // = "UseChild2"
	// MPropertyFriendlyName = "Timing Blend"
	// MPropertyAttributeRange = "0 1"
	// MPropertyAttrStateCallback
	float32 m_flTimingBlend; // = 0.5
	// MPropertyFriendlyName = "Root Motion Blend"
	// MPropertyAttributeRange = "0 1"
	float32 m_flRootMotionBlend;
	// MPropertyFriendlyName = "Foot Motion Timing"
	BinaryNodeChildOption m_footMotionTiming; // = "Child1"
	// MPropertyFriendlyName = "Reset Child1"
	bool m_bResetChild1; // = true
	// MPropertyFriendlyName = "Reset Child2"
	bool m_bResetChild2; // = true
};
