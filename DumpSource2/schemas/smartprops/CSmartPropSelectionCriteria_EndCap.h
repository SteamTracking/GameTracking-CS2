// MVDataComponentValidGrandParents = "CSmartPropElement_FitOnLine"
// MPropertyFriendlyName = "End Cap Settings"
// MPropertyDescription = "Specifies that this is a special part that should be used at the start or end of the line."
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_EndCap : public CSmartPropSelectionCriteria
{
	// MPropertyDescription = "Is this an element which should be placed at the start of the line."
	CSmartPropAttributeBool m_bStart; // = true
	// MPropertyDescription = "Is this an element which should be placed at the end of the line."
	CSmartPropAttributeBool m_bEnd; // = true
};
