// MPropertyFriendlyName = "Place Multiple"
// MPropertyDescription = "An element which places multiple instances of its child elements."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_PlaceMultiple : public CSmartPropElement_Group
{
	// MPropertyDescription = "Number of instances of this object and its children to be placed."
	CSmartPropAttributeInt m_nCount; // = 1
	// MPropertyFriendlyName = "Stop When"
	// MPropertyDescription = "Stop placing copies of the children when this expression evaluates to true."
	// MPropertyAttributeEditor = "SmartPropAttributeEditor(expression)"
	CUtlString m_Expression;
};
