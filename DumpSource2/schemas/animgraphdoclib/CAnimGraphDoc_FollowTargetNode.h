// MPropertyFriendlyName = "Follow Target"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FollowTargetNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Bone"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_boneName;
	// MPropertyFriendlyName = "Target Settings"
	// MPropertyAutoExpandSelf
	IKTargetSettings_t m_TargetSettings; // = { "m_TargetCoordSystem": "World Space", "m_TargetSource": "Bone" }
	// MPropertyFriendlyName = "Match Target Orientation"
	// MPropertyAutoRebuildOnChange
	bool m_bMatchTargetOrientation;
};
