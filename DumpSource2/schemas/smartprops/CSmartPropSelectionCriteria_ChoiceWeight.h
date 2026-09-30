// MVDataComponentValidGrandParents = "CSmartPropElement_PickOne"
// MPropertyFriendlyName = "Choice Weight"
// MPropertyDescription = "Specifies a weighting value which affects that likelyhood of selecting this element which picking a choice."
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_ChoiceWeight : public CSmartPropSelectionCriteria
{
	// MPropertyDescription = "Relative weight of this choice, higher weighted choices are more likely to be selected."
	CSmartPropAttributeFloat m_flWeight; // = 1
};
