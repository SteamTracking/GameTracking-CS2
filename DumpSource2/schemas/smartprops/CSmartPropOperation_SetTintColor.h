// MPropertyFriendlyName = "Tint Color Choice"
// MPropertyDescription = "Set the color tint to one color out of a pre-selected set of colors."
// MVDataClassGroup = "Color"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SetTintColor : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Selection Mode"
	// MPropertyDescription = "Specifies how the color is to be selected from the authored set of choices"
	CSmartPropAttributeChoiceSelectionMode m_SelectionMode; // = "RANDOM"
	// MPropertyFriendlyName = "Color Selection"
	// MPropertyDescription = "Specifies the index of the color to pick"
	// MPropertySuppressExpr = "( m_SelectionMode != SPECIFIC )"
	CSmartPropAttributeInt m_ColorSelection;
	// MPropertyFriendlyName = "Application Mode"
	// MPropertyDescription = "Specifies how the selected color should be applied to the current color."
	CSmartPropAttributeApplyColorMode m_Mode; // = "MULTIPLY_OBJECT"
	// MPropertyDescription = "List of possible colors which may be selected"
	CUtlVector< ColorChoice_t > m_ColorChoices;
};
