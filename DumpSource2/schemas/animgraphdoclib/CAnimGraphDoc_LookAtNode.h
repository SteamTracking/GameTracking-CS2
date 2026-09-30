// MPropertyFriendlyName = "Look At"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_LookAtNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Target"
	// MPropertyAutoRebuildOnChange
	AnimVectorSource m_target; // = "VectorParameter"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Target Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_param;
	// MPropertyFriendlyName = "Parameter is a Position"
	// MPropertyAttrStateCallback
	bool m_bIsPosition;
	// MPropertySuppressField
	CUtlString m_weightParamName;
	// MPropertyFriendlyName = "Weight Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_weightParam;
	// MPropertyFriendlyName = "LookAt Chain"
	// MPropertyAttributeChoiceName = "LookAtChain"
	CUtlString m_lookatChainName;
	// MPropertyFriendlyName = "Aim Attachment"
	// MPropertyAttributeChoiceName = "Attachment"
	CUtlString m_attachmentName;
	// MPropertyFriendlyName = "Rotate Through Forward"
	// MPropertyGroupName = "Rotation Limits"
	// MPropertyAutoRebuildOnChange
	bool m_bRotateYawForward; // = true
	// MPropertyFriendlyName = "Yaw Limit"
	// MPropertyAttributeRange = "0 180"
	// MPropertyGroupName = "Rotation Limits"
	// MPropertyAttrStateCallback
	float32 m_flYawLimit; // = 45
	// MPropertyFriendlyName = "Pitch Limit"
	// MPropertyAttributeRange = "0 90"
	// MPropertyGroupName = "Rotation Limits"
	float32 m_flPitchLimit; // = 45
	// MPropertyFriendlyName = "Maintain Up Direction"
	bool m_bMaintainUpDirection;
	// MPropertyFriendlyName = "Reset Child"
	bool m_bResetBase; // = true
	// MPropertyFriendlyName = "Lock Blend When Waning"
	bool m_bLockWhenWaning; // = true
	// MPropertyFriendlyName = "Use Hysteresis"
	// MPropertyGroupName = "Hysteresis"
	bool m_bUseHysteresis;
	// MPropertyFriendlyName = "Inner Angle"
	// MPropertyGroupName = "Hysteresis"
	float32 m_flHysteresisInnerAngle; // = 1
	// MPropertyFriendlyName = "Outer Angle"
	// MPropertyGroupName = "Hysteresis"
	float32 m_flHysteresisOuterAngle; // = 20
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
