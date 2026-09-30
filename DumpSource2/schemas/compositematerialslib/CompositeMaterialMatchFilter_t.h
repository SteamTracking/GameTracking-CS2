// MPropertyElementNameFn
class CompositeMaterialMatchFilter_t
{
	// MPropertyFriendlyName = "Match Type"
	CompositeMaterialMatchFilterType_t m_nCompositeMaterialMatchFilterType; // = "MATCH_FILTER_MATERIAL_ATTRIBUTE_EXISTS"
	// MPropertyFriendlyName = "Name"
	CUtlString m_strMatchFilter; // = "composite_inputs"
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	CUtlString m_strMatchValue;
	// MPropertyFriendlyName = "Pass when True"
	bool m_bPassWhenTrue; // = true
};
