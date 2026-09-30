// MVDataComponentValidGrandParents = "CSmartPropElement_FitOnLine"
// MPropertyFriendlyName = "Linear Length"
// MPropertyDescription = "Specifies the length of this element, used when fitting an element on to a line."
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_LinearLength : public CSmartPropSelectionCriteria
{
	// MPropertyDescription = "Specifies the length of the line that will be taken up if this element is selected."
	CSmartPropAttributeFloat m_flLength; // = 1
	// MPropertyDescription = "Can this object be scaled. If enabled the minimum and maximum lengths must be set to specify the size range of allowable scale."
	CSmartPropAttributeBool m_bAllowScale;
	// MPropertyFriendlyName = "Minimum length"
	// MPropertySuppressExpr = "m_bAllowScale == false"
	// MPropertyDescription = "Minimum allowable length for the object. Must be <= length. If length is 100 and minimum length is 20, then the object may be assigned a scale in the rage [ 0.2, 1.0 ]."
	CSmartPropAttributeFloat m_flMinLength; // = 1
	// MPropertyFriendlyName = "Maximum length"
	// MPropertySuppressExpr = "m_bAllowScale == false"
	// MPropertyDescription = "Maximum allowable length for the object. Must be >= length. If length is 100 and maximum length is 160, then the object may be assigned a scale in the rage [ 1.0, 1.6 ]."
	CSmartPropAttributeFloat m_flMaxLength; // = 1
};
