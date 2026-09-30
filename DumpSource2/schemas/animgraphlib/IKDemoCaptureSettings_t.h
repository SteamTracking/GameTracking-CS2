class IKDemoCaptureSettings_t
{
	// MPropertyFriendlyName = "Target Parent"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_parentBoneName;
	// MPropertyFriendlyName = "Solver Mode"
	// MPropertyAutoRebuildOnChange
	IKChannelMode m_eMode; // = "TwoBone"
	// MPropertyFriendlyName = "IK Chain"
	// MPropertyAttributeChoiceName = "IKChain"
	// MPropertyAttrStateCallback
	CUtlString m_ikChainName;
	// MPropertyFriendlyName = "Start Bone"
	// MPropertyAttributeChoiceName = "Bone"
	// MPropertyAttrStateCallback
	CUtlString m_oneBoneStart;
	// MPropertyFriendlyName = "End Bone"
	// MPropertyAttributeChoiceName = "Bone"
	// MPropertyAttrStateCallback
	CUtlString m_oneBoneEnd;
};
