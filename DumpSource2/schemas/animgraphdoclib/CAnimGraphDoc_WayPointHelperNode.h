// MPropertyFriendlyName = "WayPoint Helper"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_WayPointHelperNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Start Cycle"
	// MPropertyAttributeRange = "0 1"
	float32 m_flStartCycle;
	// MPropertyFriendlyName = "End Cycle"
	// MPropertyAttributeRange = "0 1"
	float32 m_flEndCycle;
	// MPropertyFriendlyName = "Only align to Goals"
	bool m_bOnlyGoals; // = true
	// MPropertyFriendlyName = "Prevent Overshoot"
	bool m_bPreventOvershoot; // = true
	// MPropertyFriendlyName = "Prevent Undershoot"
	bool m_bPreventUndershoot;
};
