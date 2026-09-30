// MHasKV3TransferPolymorphicClassname
class CMixPropertyBase
{
	// MPropertyDescription = "Node name"
	// MPropertyFriendlyName = "Name"
	// MPropertySortPriority = 1
	CUtlString m_name;
	// MPropertyDescription = "Description of how this is used  the graph for people reading the graph"
	// MPropertySortPriority = -2
	CUtlString m_Comment;
	// MPropertySortPriority = -1
	// MPropertyHideField
	bool m_bActive; // = true
	// MPropertySortPriority = -1
	// MPropertyHideField
	bool m_bSolo;
	// MPropertySortPriority = -1
	// MPropertyHideField
	bool m_bEditProperties;
	// MPropertySortPriority = -1
	// MPropertyHideField
	int32 m_nGenerationId;
};
