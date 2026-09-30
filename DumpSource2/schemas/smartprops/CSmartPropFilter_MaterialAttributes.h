// MPropertyFriendlyName = "Filter: Material Attributes"
// MPropertyDescription = "Allows the parent element to be conditionally evaluated based on attributes assigned to the surface material."
// MVDataClassGroup = "Filter"
// MHasKV3TransferPolymorphicClassname
class CSmartPropFilter_MaterialAttributes : public CSmartPropFilter
{
	// MPropertyDescription = "List of material attributes on which this element is valid. If empty, the element is not restricted to any specific surfaces."
	CUtlVector< CUtlString > m_AllowedMaterialAttributes;
	// MPropertyDescription = "List of material attributes on which this element is not valid. If empty, the element is not restricted to any specific surfaces."
	CUtlVector< CUtlString > m_DisallowedMaterialAttributes;
};
