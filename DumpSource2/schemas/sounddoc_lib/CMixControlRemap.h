// MPropertyFriendlyName = "VMix Control Remap Node"
// MPropertyDescription = "Remap a control value using a clamped linear range or clamped power curve.  Allows you to stretch and clip a control signal."
// MHasKV3TransferPolymorphicClassname
class CMixControlRemap : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Input Min"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "Input Max"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "Output Start"
	float32 m_flOutputStart;
	// MPropertyFriendlyName = "Output End"
	float32 m_flOutputEnd; // = 1
	// MPropertyFriendlyName = "Nonlinear power (1.0 = linear)"
	// MPropertyAttributeRange = "biased 0.02 20"
	float32 m_flPower; // = 1
};
