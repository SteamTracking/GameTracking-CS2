// MVDataComponentValidGrandParents = "CSmartPropElement_PlaceOnMesh"
// MPropertyFriendlyName = "Filter Faces By Material"
// MPropertyDescription = ""
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_MaterialCriteria : public CSmartPropSelectionCriteria
{
	// MPropertyFriendlyName = "Material"
	// MPropertyDescription = "Target material name."
	CSmartPropAttributeMaterialName m_material;
	// MPropertyFriendlyName = "Invert"
	// MPropertyDescription = "When true, discard faces with matching material."
	CSmartPropAttributeBool m_bInvert;
};
