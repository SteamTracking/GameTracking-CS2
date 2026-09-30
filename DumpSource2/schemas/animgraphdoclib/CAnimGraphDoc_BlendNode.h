// MPropertyFriendlyName = "Blend 1D"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_BlendNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Blend Items"
	// MPropertyAutoExpandSelf
	CUtlVector< CBlendNodeChild > m_children;
	// MPropertyFriendlyName = "Blend Source"
	// MPropertyAttrStateCallback
	AnimValueSource m_blendValueSource; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Blend Key Values"
	BlendKeyType m_blendKeyType; // = "BlendKey_UserValue"
	// MPropertyFriendlyName = "Lock Blend on Reset"
	bool m_bLockBlendOnReset;
	// MPropertyFriendlyName = "Sync Cycles"
	bool m_bSyncCycles; // = true
	// MPropertyFriendlyName = "Loop"
	bool m_bLoop; // = true
	// MPropertyFriendlyName = "Lock Blend When Waning"
	bool m_bLockWhenWaning; // = true
	// MPropertyFriendlyName = "Is Angle"
	bool m_bIsAngle;
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	// MPropertyFriendlyName = "Linear Root Motion Blend Mode"
	LinearRootMotionBlendMode_t m_eLinearRootMotionBlendMode; // = "LERP"
};
