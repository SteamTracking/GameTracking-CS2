// MHasKV3TransferPolymorphicClassname
class CAnimTagBase
{
	// MPropertyFriendlyName = "Name"
	// MPropertySortPriority = 100
	CGlobalSymbol m_name; // = "Unnamed Tag"
	// MPropertyFriendlyName = "Comment"
	// MPropertyAttributeEditor = "TextBlock()"
	// MPropertySortPriority = -100
	CUtlString m_sComment;
	// MPropertySuppressField
	CGlobalSymbol m_group;
	// MPropertySuppressField
	AnimTagID m_tagID;
	// MPropertySuppressField
	bool m_bIsReferenced;
};
