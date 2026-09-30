// MVDataComponentValidGrandParents = "CSmartPropElement_PickOne"
// MPropertyFriendlyName = "Is Valid"
// MPropertyDescription = "Specifies if this element is currently valid choice."
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_IsValid : public CSmartPropSelectionCriteria
{
	// MPropertyFriendlyName = "Valid When"
	// MPropertyDescription = "Expression to evaluate to determine if this choice is currently valid."
	// MPropertyAttributeEditor = "SmartPropAttributeEditor(expression)"
	CUtlString m_Expression;
};
