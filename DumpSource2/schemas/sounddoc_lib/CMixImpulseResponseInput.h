// MPropertyFriendlyName = "VMix Control Impulse Response Node"
// MPropertyDescription = "Define a control input that outputs a dynamic impulse response, which can be used by the Steam Audio hybrid reverb processor."
// MHasKV3TransferPolymorphicClassname
class CMixImpulseResponseInput : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Default Value"
	// MPropertyAttributeEditor = "AssetBrowse( vsnd )"
	CUtlString m_defaultValue; // = "sounds/ir/default.vsnd"
};
