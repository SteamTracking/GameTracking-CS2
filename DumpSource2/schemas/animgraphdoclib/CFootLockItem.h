// MPropertyFriendlyName = "Item"
// MPropertyElementNameFn
class CFootLockItem
{
	// MPropertyFriendlyName = "Foot"
	// MPropertyAttributeChoiceName = "Foot"
	CUtlString m_footName;
	// MPropertyFriendlyName = "Target Bone"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_targetBoneName;
	// MPropertyFriendlyName = "IK Chain"
	// MPropertyAttributeChoiceName = "IKChain"
	CUtlString m_ikChainName;
	// MPropertySuppressField
	CGlobalSymbol m_disableTagName;
	// MPropertyFriendlyName = "Disable Tag"
	// MPropertyAttributeChoiceName = "Tag"
	AnimTagID m_disableTagID;
	// MPropertyFriendlyName = "Max Left Rotation"
	// MPropertyAttributeRange = "0 180"
	float32 m_flMaxRotationLeft; // = 90
	// MPropertyFriendlyName = "Max Right Rotation"
	// MPropertyAttributeRange = "0 180"
	float32 m_flMaxRotationRight; // = 90
	// MPropertySuppressField
	CGlobalSymbol m_footstepLandedTagName;
	// MPropertyFriendlyName = "Footstep Landed Tag"
	// MPropertyAttributeChoiceName = "Tag"
	AnimTagID m_footstepLandedTag;
};
