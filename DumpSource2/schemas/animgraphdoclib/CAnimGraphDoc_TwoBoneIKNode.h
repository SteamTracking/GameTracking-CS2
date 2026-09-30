// MPropertyFriendlyName = "Two-Bone IK"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_TwoBoneIKNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "IK Chain"
	// MPropertyAttributeChoiceName = "IKChain"
	CUtlString m_ikChainName;
	// MPropertyFriendlyName = "Auto-Detect Hinge Axis"
	bool m_bAutoDetectHingeAxis; // = true
	// MPropertyGroupName = "End Effector"
	// MPropertyFriendlyName = "End Effector Type"
	// MPropertyAutoRebuildOnChange
	IkEndEffectorType m_endEffectorType; // = "IkEndEffector_Bone"
	// MPropertyGroupName = "End Effector"
	// MPropertyFriendlyName = "Attachment"
	// MPropertyAttributeChoiceName = "Attachment"
	// MPropertyAttrStateCallback
	CUtlString m_endEffectorAttachmentName;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Target Type"
	// MPropertyAutoRebuildOnChange
	IkTargetType m_targetType; // = "IkTarget_Attachment"
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Attachment"
	// MPropertyAttributeChoiceName = "Attachment"
	// MPropertyAttrStateCallback
	CUtlString m_attachmentName;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Bone"
	// MPropertyAttributeChoiceName = "Bone"
	// MPropertyAttrStateCallback
	CUtlString m_targetBoneName;
	// MPropertySuppressField
	CUtlString m_targetParamName;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Position Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_targetParam;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Match Target Orientation"
	// MPropertyAutoRebuildOnChange
	bool m_bMatchTargetOrientation;
	// MPropertySuppressField
	CUtlString m_rotationParamName;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Rotation Parameter"
	// MPropertyAttributeChoiceName = "QuaternionParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_rotationParam;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Constrain Twist"
	// MPropertyAttrStateCallback
	bool m_bConstrainTwist;
	// MPropertyGroupName = "Target"
	// MPropertyFriendlyName = "Max Twist"
	// MPropertyAttrStateCallback
	float32 m_flMaxTwist; // = 15
};
