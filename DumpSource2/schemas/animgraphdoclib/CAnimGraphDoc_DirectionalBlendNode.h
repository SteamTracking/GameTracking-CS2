// MPropertyFriendlyName = "Directional Blend"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_DirectionalBlendNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Sequence Names Prefix"
	CUtlString m_animNamePrefix;
	// MPropertyFriendlyName = "Blend Source"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_blendValueSource; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Loop"
	bool m_bLoop; // = true
	// MPropertyFriendlyName = "Lock Blend on Reset"
	bool m_bLockBlendOnReset;
	// MPropertyFriendlyName = "Playback Speed"
	float32 m_playbackSpeed; // = 1
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
