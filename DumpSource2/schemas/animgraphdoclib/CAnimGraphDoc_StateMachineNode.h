// MPropertyFriendlyName = "State Machine"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_StateMachineNode : public CAnimGraphDoc_Node, public CAnimGraphDoc_StateMachine
{
	// MPropertyFriendlyName = "Block Tags from Waning States"
	bool m_bBlockWaningTags;
	// MPropertyFriendlyName = "Lock When Waning"
	bool m_bLockStateWhenWaning;
	// MPropertyFriendlyName = "Reset When Activated"
	bool m_bResetWhenActivated;
};
