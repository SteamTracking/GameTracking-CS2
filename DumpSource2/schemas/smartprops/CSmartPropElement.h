// MVDataBase
// MVDataNodeType = 1
// MVDataAnonymousNode
// MPropertyFriendlyName = "Smart Prop Element"
// MVDataOutlinerLabelExpr = "m_sLabel"
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement
{
	// MPropertySuppressField
	// MVDataUniqueMonotonicInt = "_editor/next_element_id"
	int32 m_nElementID; // = -1
	// MVDataEnableKey
	// MPropertyDescription = "Is this element enabled? If not enabled, this element will not be evaluted and will have no effect on the result."
	// MPropertySortPriority = 10
	CSmartPropAttributeBool m_bEnabled; // = true
	// MPropertyFriendlyName = "Label"
	// MPropertyDescription = "Optional text that will appear in the outliner to help organize Smart Prop elements and communicate their purpose to other users."
	CUtlString m_sLabel;
	// MPropertyFriendlyName = "Selection Criteria"
	// MVDataPromoteField = 2
	CUtlVector< CSmartPropSelectionCriteria* > m_SelectionCriteria;
	// MPropertyFriendlyName = "Modifiers"
	// MVDataPromoteField = 2
	CUtlVector< CSmartPropModifier* > m_Modifiers;
};
