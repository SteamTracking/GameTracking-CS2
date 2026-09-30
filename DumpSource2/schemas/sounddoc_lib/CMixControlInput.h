// MPropertyFriendlyName = "VMix Control Input Node"
// MPropertyDescription = "Define a control variable that can be set by code or an operator stack."
// MHasKV3TransferPolymorphicClassname
class CMixControlInput : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Default Value"
	float32 m_flDefaultValue; // = 1
	// MPropertyFriendlyName = "Preview Min Range"
	float32 m_flMinRange;
	// MPropertyFriendlyName = "Preview Max Range"
	float32 m_flMaxRange; // = 1
	// MPropertyFriendlyName = "Convert From dB"
	bool m_bUseDecibels;
};
