// MPropertyFriendlyName = "Material"
// MPropertyDescription = "Material Asset Variable"
// MHasKV3TransferPolymorphicClassname
class CSmartPropVariable_Material : public CSmartPropVariable
{
	// MPropertyFriendlyName = "Default Material"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIMaterial2 > > m_DefaultValue;
};
