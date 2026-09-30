// MSmartPropClassVersion = 0
// MVDataRoot
// MVDataSingleton
// MVDataFileExtension = "vsmart"
// MVDataPreviewWidget = "smart_prop"
// MVDataGroupNodeClass = "CSmartPropElement_Group"
// MVDataUsesComponentEditor
// MPropertyFriendlyName = "Smart Prop Root"
// MPropertyDescription = "Root of a smart prop, contains a list of elements to evaluate."
class CSmartPropRoot
{
	// MPropertyDescription = "Specifies the current version of this smart prop. Any existing references to this smart prop with an older version number will not automatically update."
	int32 m_nContentVersion;
	// MPropertyDescription = "Maximum depth of smart prop evaluation stack during evaluation."
	CSmartPropAttributeInt m_nMaxDepth; // = 32
	// MPropertyFriendlyName = "Variables"
	// MVDataPromoteField = 2
	CUtlVector< CSmartPropVariable* > m_Variables;
	// MPropertyFriendlyName = "Choices"
	// MVDataPromoteField = 2
	CUtlVector< CSmartPropChoice* > m_Choices;
	// MPropertyDescription = "List of the root level elements making up the smart prop definition, each element may be an entire tree."
	// MVDataPromoteField = 1
	CUtlVector< CSmartPropElement* > m_Children;
	// MPropertyFriendlyName = "Modifiers"
	// MVDataPromoteField = 2
	CUtlVector< CSmartPropModifier* > m_Modifiers;
};
