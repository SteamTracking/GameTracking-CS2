// MPropertyFriendlyName = "SubGraph"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SubGraphNode : public CAnimGraphDoc_ContainerNodeBase
{
	// MPropertyFriendlyName = "SubGraph File"
	// MPropertyAttributeEditor = "AssetBrowse( vsubgrph, *requiredoubleclick  )"
	CUtlString m_subGraphFilename;
	// MPropertySuppressField
	CUtlHashtable< CUtlString, CUtlString > m_animNameMap;
};
