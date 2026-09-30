class MaterialGroupChoice_t
{
	// MPropertyAttributeEditor = "SmartPropAttributeEditor( MaterialGroupFromVariable )"
	// MPropertyFriendlyName = "Material Group"
	// MPropertyDescription = "Specifies the name of the material group (skin) to use when displaying the specified model."
	CSmartPropAttributeMaterialGroup m_MaterialGroupName;
	// MPropertyDescription = "Relative weight of this choice, higher weighted choices are more likely to be selected."
	CSmartPropAttributeFloat m_flWeight; // = 1
};
