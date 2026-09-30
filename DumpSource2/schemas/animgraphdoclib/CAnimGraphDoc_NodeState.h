// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_NodeState : public CAnimGraphDoc_State
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Exclusive Root Motion"
	// MPropertySortPriority = 0
	bool m_bIsRootMotionExclusive;
	// MPropertyFriendlyName = "Exclusive Root Motion On First Frame"
	// MPropertySortPriority = 0
	bool m_bIsRootMotionExclusiveFirstFrame;
};
