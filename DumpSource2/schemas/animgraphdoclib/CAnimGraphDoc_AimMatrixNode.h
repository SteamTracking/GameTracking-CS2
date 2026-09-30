// MPropertyFriendlyName = "Aim Matrix"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_AimMatrixNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_sequenceName;
	// MPropertyFriendlyName = "Max Yaw Angle"
	float32 m_flMaxYawAngle; // = 45
	// MPropertyFriendlyName = "Max Pitch Angle"
	float32 m_flMaxPitchAngle; // = 45
	// MPropertyFriendlyName = "Target"
	// MPropertyAutoRebuildOnChange
	AnimVectorSource m_target; // = "LookTarget"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_param;
	// MPropertyFriendlyName = "Parameter is a Position"
	// MPropertyAttrStateCallback
	bool m_bIsPosition;
	// MPropertyFriendlyName = "Aim Attachment"
	// MPropertyAttributeChoiceName = "Attachment"
	CUtlString m_attachmentName;
	// MPropertyFriendlyName = "Blend Mode"
	// MPropertyAutoRebuildOnChange
	AimMatrixBlendMode m_blendMode; // = "AimMatrixBlendMode_Additive"
	// MPropertyFriendlyName = "Bone Mask"
	// MPropertyAttributeChoiceName = "BoneMask"
	// MPropertyAttrStateCallback
	CUtlString m_boneMaskName;
	// MPropertyFriendlyName = "Reset Child"
	bool m_bResetBase; // = true
	// MPropertyFriendlyName = "Lock Blend When Waning"
	bool m_bLockWhenWaning; // = true
	// MPropertyFriendlyName = "Use Bias + Clamp"
	// MPropertyAutoRebuildOnChange
	bool m_bUseBiasAndClamp;
	// MPropertyFriendlyName = "Yaw Offset Angle"
	// MPropertyAttrStateCallback
	float32 m_flBiasAndClampYawOffset; // = 1
	// MPropertyFriendlyName = "Pitch Offset Angle"
	// MPropertyAttrStateCallback
	float32 m_flBiasAndClampPitchOffset; // = 1
	// MPropertyFriendlyName = "Clamp Blend Curve"
	// MPropertyAttributeEditor = "AnimGraphBlendCurve()"
	// MPropertyAttrStateCallback
	CBlendCurve m_biasAndClampBlendCurve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
