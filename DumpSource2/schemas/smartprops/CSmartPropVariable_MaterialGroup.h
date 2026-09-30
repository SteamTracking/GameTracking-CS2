// MPropertyFriendlyName = "Material Group"
// MHasKV3TransferPolymorphicClassname
class CSmartPropVariable_MaterialGroup : public CSmartPropVariable
{
	// MPropertyDescription = "Model containing the set of material groups to select."
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sModelName;
	// MPropertyFriendlyName = "Default Material Group"
	// MPropertyDescription = "Default material group (skin) to assign to the variable value."
	CModelMaterialGroupName m_DefaultValue;
};
