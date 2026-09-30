// MHasKV3TransferPolymorphicClassname
class CAnimParameterBase
{
	// MPropertyFriendlyName = "Name"
	// MPropertySortPriority = 100
	CGlobalSymbol m_name;
	// MPropertyFriendlyName = "Comment"
	// MPropertyAttributeEditor = "TextBlock()"
	// MPropertySortPriority = -100
	CUtlString m_sComment;
	// MPropertyReadOnly
	// MPropertySortPriority = -90
	CUtlString m_group;
	// MPropertyReadOnly
	// MPropertySortPriority = -90
	AnimParamID m_id;
	// MPropertySuppressField
	// MPropertyAutoRebuildOnChange
	CUtlString m_componentName;
	// MPropertySuppressField
	bool m_bNetworkingRequested;
	// MPropertySuppressField
	bool m_bIsReferenced;
};
