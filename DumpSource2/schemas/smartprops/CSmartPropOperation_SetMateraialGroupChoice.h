// MPropertyFriendlyName = "Set Material Group Choice"
// MPropertyDescription = "Picks a material group from a set of choices and assigns that material group to a specified variable."
// MVDataClassGroup = "Material"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SetMateraialGroupChoice : public CSmartPropOperation
{
	// MPropertyDescription = "Material group variable to set to the selected choice."
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:MaterialGroup )"
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_SmartProp_Variable"
	CUtlString m_VariableName;
	// MPropertyFriendlyName = "Selection Mode"
	// MPropertyDescription = "Specifies how the material group is to be selected from the authored set of choices"
	CSmartPropAttributeChoiceSelectionMode m_SelectionMode; // = "RANDOM"
	// MPropertyFriendlyName = "Choice Index"
	// MPropertyDescription = "Specifies the index of the material group choice to pick"
	// MPropertySuppressExpr = "( m_SelectionMode != SPECIFIC )"
	CSmartPropAttributeInt m_ChoiceSelection;
	// MPropertyAutoExpandSelf
	CUtlVector< MaterialGroupChoice_t > m_MaterialGroupChoices;
};
