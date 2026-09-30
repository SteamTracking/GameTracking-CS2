// MPropertyFriendlyName = "Group"
// MPropertyDescription = "A group of elements that will all be evaulated."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_Group : public CSmartPropElement
{
	// MPropertyFriendlyName = "Children"
	// MPropertyDescription = "List of child elements which will appear if this element appears"
	// MVDataPromoteField = 1
	CUtlVector< CSmartPropElement* > m_Children;
};
