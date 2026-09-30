// MPropertyFriendlyName = "VMix Control Output Node"
// MPropertyDescription = "Save the results of a control value (e.g. envelope level) so that code/stack can query it by name."
// MHasKV3TransferPolymorphicClassname
class CMixControlOutput : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Default Value"
	float32 m_flDefaultValue; // = 1
};
