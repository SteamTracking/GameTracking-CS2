// MPropertyFriendlyName = "VMix Control Stack Input Node"
// MPropertyDescription = "This will copy a control value from this soundevent's operator stack.  Works with any stack/variable without modifying the stack itself."
// MHasKV3TransferPolymorphicClassname
class CMixControlStackInput : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Default Value"
	float32 m_flDefaultValue; // = 1
	// MPropertyFriendlyName = "Preview Min Range"
	float32 m_flMinRange;
	// MPropertyFriendlyName = "Preview Max Range"
	float32 m_flMaxRange; // = 1
};
