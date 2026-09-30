// MPropertyFriendlyName = "Float Parameter"
// MHasKV3TransferPolymorphicClassname
class CFloatAnimParameter : public CConcreteAnimParameter
{
	// MPropertyFriendlyName = "Default Value"
	float32 m_fDefaultValue;
	// MPropertyFriendlyName = "Min Value"
	float32 m_fMinValue;
	// MPropertyFriendlyName = "Max Value"
	float32 m_fMaxValue; // = 1
	// MPropertyFriendlyName = "Interpolate"
	bool m_bInterpolate;
};
