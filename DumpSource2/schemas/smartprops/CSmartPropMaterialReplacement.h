class CSmartPropMaterialReplacement
{
	// MPropertyAttributeEditor = "SmartPropAttributeEditor(MaterialInSmartProp)"
	// MPropertyFriendlyName = "Original Material"
	// MPropertyDescription = "Original material to replace. This is the material specified in the model, including any material group asignment within the model. Does not consider any existing material overrides specified within the smart prop."
	CSmartPropAttributeMaterialName m_OriginalMaterial;
	// MPropertyFriendlyName = "New Material"
	// MPropertyDescription = "New material to replace the original material with."
	CSmartPropAttributeMaterialName m_ReplacementMaterial;
};
