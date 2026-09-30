// MPropertyFriendlyName = "Turn Helper"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_TurnHelperNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Turn to Face"
	AnimValueSource m_facingTarget; // = "LookHeading"
	// MPropertyFriendlyName = "Turn Start Time"
	float32 m_turnStartTime;
	// MPropertyFriendlyName = "Turn Duration"
	float32 m_turnDuration; // = 1
	// MPropertyFriendlyName = "Match Child Duration"
	bool m_bMatchChildDuration; // = true
	// MPropertyFriendlyName = "Use Manual Turn Offset"
	bool m_bUseManualTurnOffset;
	// MPropertyFriendlyName = "Manual Turn Offset"
	float32 m_manualTurnOffset;
};
