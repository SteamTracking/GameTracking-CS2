// MPropertyFriendlyName = "Foot Pinning"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FootPinningNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Feet"
	// MPropertyAutoExpandSelf
	CUtlVector< CFootPinningItem > m_items;
	// MPropertyFriendlyName = "Lock Timing Source"
	FootPinningTimingSource m_eTimingSource; // = "FootMotion"
	// MPropertyFriendlyName = "Blend Time"
	float32 m_flBlendTime; // = 0.2
	// MPropertyFriendlyName = "Lock Break Distance"
	float32 m_flLockBreakDistance; // = 24
	// MPropertyFriendlyName = "Max Leg Straight Amount"
	// MPropertyAttributeRange = "0 1"
	float32 m_flMaxLegStraightAmount; // = 0.98
	// MPropertyFriendlyName = "Limit Foot Rotation"
	// MPropertyGroupName = "Foot Rotation Limits"
	bool m_bApplyFootRotationLimits;
	// MPropertyFriendlyName = "Hip Bone"
	// MPropertyAttributeChoiceName = "Bone"
	// MPropertyGroupName = "Foot Rotation Limits"
	CUtlString m_hipBoneName;
	// MPropertyFriendlyName = "Limit Leg Twist"
	// MPropertyGroupName = "Knee Twist Limits"
	bool m_bApplyLegTwistLimits;
	// MPropertyFriendlyName = "Max Leg Twist Angle"
	// MPropertyGroupName = "Knee Twist Limits"
	float32 m_flMaxLegTwist; // = 25
	// MPropertyFriendlyName = "Reset Child"
	bool m_bResetChild; // = true
};
