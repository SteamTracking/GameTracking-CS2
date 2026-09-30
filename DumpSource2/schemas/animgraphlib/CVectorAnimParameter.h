// MPropertyFriendlyName = "Vector Parameter"
// MHasKV3TransferPolymorphicClassname
class CVectorAnimParameter : public CConcreteAnimParameter
{
	// MPropertyFriendlyName = "Default Value"
	Vector m_defaultValue;
	// MPropertyFriendlyName = "Interpolate"
	bool m_bInterpolate;
	// MPropertyFriendlyName = "Vector Type"
	AnimParamVectorType_t m_vectorType; // = "ANIMPARAM_VECTOR_TYPE_NONE"
};
