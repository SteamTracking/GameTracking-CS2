// MPropertyFriendlyName = "Add"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_AddNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_baseInput;
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_additiveInput;
	// MPropertyFriendlyName = "Timing Control"
	// MPropertyAutoRebuildOnChange
	BinaryNodeTiming m_timingBehavior; // = "UseChild2"
	// MPropertyFriendlyName = "Timing Blend"
	// MPropertyAttributeRange = "0 1"
	// MPropertyAttrStateCallback
	float32 m_flTimingBlend; // = 0.5
	// MPropertyFriendlyName = "Foot Motion Timing"
	BinaryNodeChildOption m_footMotionTiming; // = "Child1"
	// MPropertyFriendlyName = "Add Foot Motion"
	bool m_bApplyToFootMotion; // = true
	// MPropertyFriendlyName = "Reset Base Child"
	bool m_bResetBase; // = true
	// MPropertyFriendlyName = "Reset Additive Child"
	bool m_bResetAdditive; // = true
	// MPropertyFriendlyName = "Treat Translation Separately"
	bool m_bApplyChannelsSeparately; // = true
	// MPropertyFriendlyName = "Use Model Space"
	bool m_bUseModelSpace;
	// MPropertyFriendlyName = "Apply Scale"
	// MPropertyDescription = "Apply Scale Channels During Add.  Requires Treat Translation Separately."
	bool m_bApplyScale;
};
