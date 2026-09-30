// MVDataRoot
// MVDataOutlinerLeafNameFn
class CollisionDetailLayerInfo_t
{
	// MPropertyFriendlyName = "Description"
	// MPropertyDescription = "How the detail layer is meant to be used"
	CUtlString m_sDescription;
	// MPropertyFriendlyName = "Friendly Name"
	// MPropertyDescription = "How name is displayed in tools"
	CUtlString m_sFriendlyName;
	// MPropertyDescription = "Only query can use this layer, not collision"
	bool m_bIsQueryOnly;
	// MPropertyDescription = "Parent detail layers automatically include the child layer"
	CUtlString m_sParentDetailLayer;
	// MPropertySuppressField
	CUtlVector< CollisionDetailLayerInfo_t::Name_t > m_vecSubtreeDetailLayers;
	// MPropertySuppressField
	bool m_bNotPickable;
};
