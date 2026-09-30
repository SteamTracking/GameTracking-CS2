// MPropertyFriendlyName = "Model"
// MPropertyDescription = "Model Asset Variable"
// MHasKV3TransferPolymorphicClassname
class CSmartPropVariable_Model : public CSmartPropVariable
{
	// MPropertyFriendlyName = "Default Model"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_DefaultValue;
};
