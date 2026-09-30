// MPropertyFriendlyName = "Item"
// MPropertyElementNameFn
class CFootPinningItem
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
	// MPropertyFriendlyName = "Tag"
	// MPropertyAttributeChoiceName = "Tag"
	AnimTagID m_tag;
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "BoolParameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Max Left Rotation"
	// MPropertyAttributeRange = "0 180"
	float32 m_flMaxRotationLeft; // = 90
	// MPropertyFriendlyName = "Max Right Rotation"
	// MPropertyAttributeRange = "0 180"
	float32 m_flMaxRotationRight; // = 90
};
