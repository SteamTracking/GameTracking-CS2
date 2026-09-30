// MPropertyFriendlyName = "Filter: Surface Properties"
// MPropertyDescription = "Allows the parent element to be conditionally evaluated based on surface properties."
// MVDataClassGroup = "Filter"
// MHasKV3TransferPolymorphicClassname
class CSmartPropFilter_SurfaceProperties : public CSmartPropFilter
{
	// MPropertyDescription = "List of surface properties on which this element is valid. If empty element is not restricted to any specific surfaces."
	CUtlVector< CUtlString > m_AllowedSurfaceProperties;
	// MPropertyDescription = "List of surface properties on which this element is not valid. If empty element is not restricted to any specific surfaces."
	CUtlVector< CUtlString > m_DisallowedSurfaceProperties;
};
