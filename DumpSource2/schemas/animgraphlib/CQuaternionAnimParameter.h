// MPropertyFriendlyName = "Quaternion Parameter"
// MHasKV3TransferPolymorphicClassname
class CQuaternionAnimParameter : public CConcreteAnimParameter
{
	// MPropertySuppressField
	Quaternion m_defaultValue; // = [ 0, 0, 0, 1 ]
	// MPropertyFriendlyName = "Interpolate"
	bool m_bInterpolate;
};
