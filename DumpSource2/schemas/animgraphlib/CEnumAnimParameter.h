// MPropertyFriendlyName = "Enum Parameter"
// MHasKV3TransferPolymorphicClassname
class CEnumAnimParameter : public CConcreteAnimParameter
{
	// MPropertyFriendlyName = "Default Value"
	uint8 m_defaultValue;
	// MPropertyFriendlyName = "Values"
	CUtlVector< CUtlString > m_enumOptions;
	// MPropertySuppressField
	CUtlVector< uint64 > m_vecEnumReferenced;
};
