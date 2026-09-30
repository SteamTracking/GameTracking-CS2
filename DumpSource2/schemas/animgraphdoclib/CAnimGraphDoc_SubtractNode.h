// MPropertyFriendlyName = "Subtract"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SubtractNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_baseInputConnection;
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_subtractInputConnection;
	// MPropertyFriendlyName = "Timing Control"
	// MPropertyAutoRebuildOnChange
	BinaryNodeTiming m_timingBehavior; // = "UseChild1"
	// MPropertyFriendlyName = "Timing Blend"
	// MPropertyAttributeRange = "0 1"
	// MPropertyAttrStateCallback
	float32 m_flTimingBlend; // = 0.5
	// MPropertyFriendlyName = "Foot Motion Timing"
	BinaryNodeChildOption m_footMotionTiming; // = "Child1"
	// MPropertyFriendlyName = "Subtract Foot Motion"
	bool m_bApplyToFootMotion; // = true
	// MPropertyFriendlyName = "Reset Base Child"
	bool m_bResetBase; // = true
	// MPropertyFriendlyName = "Reset Subtracted Child"
	bool m_bResetSubtract; // = true
	// MPropertyFriendlyName = "Treat Translation Separately"
	bool m_bApplyChannelsSeparately; // = true
	// MPropertyFriendlyName = "Use Model Space"
	bool m_bUseModelSpace;
};
