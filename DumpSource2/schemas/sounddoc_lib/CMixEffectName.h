// MPropertyFriendlyName = "VMix Effect Name Node"
// MPropertyDescription = "Define an effect name variable that can be controlled by code/operator stack and used to drive processor/effectchain/subgraphswitch nodes."
// MHasKV3TransferPolymorphicClassname
class CMixEffectName : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Default Value"
	// MPropertyAttributeChoiceName = "dsp_preset"
	CUtlString m_defaultValue; // = "core.null"
};
