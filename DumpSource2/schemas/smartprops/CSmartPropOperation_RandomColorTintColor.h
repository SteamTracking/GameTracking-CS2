// MPropertyFriendlyName = "Tint Color Gradient"
// MPropertyDescription = "Set the color tint to a selection from within the defined gradient."
// MVDataClassGroup = "Color"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_RandomColorTintColor : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Selection Mode"
	// MPropertyDescription = "Specifies how the color is to be selected from the authored set of choices"
	CSmartPropAttributeChoiceSelectionMode m_SelectionMode; // = "RANDOM"
	// MPropertyFriendlyName = "Color Position"
	// MPropertyDescription = "[ 0, 1 ] Value specifying the location on the gradient to pick the color from."
	// MPropertySuppressExpr = "( m_SelectionMode != SPECIFIC )"
	CSmartPropAttributeFloat m_ColorPosition;
	// MPropertyFriendlyName = "Application Mode"
	// MPropertyDescription = "Specifies how the selected color should be applied to the current color."
	ApplyColorMode_t m_Mode; // = "MULTIPLY_OBJECT"
	// MPropertyDescription = "Defines a color gradient from which a random color will be piked."
	CColorGradient m_Gradient;
};
