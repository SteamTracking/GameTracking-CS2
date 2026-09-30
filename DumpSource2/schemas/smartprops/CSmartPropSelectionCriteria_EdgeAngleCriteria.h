// MVDataComponentValidGrandParents = "CSmartPropElement_PlaceOnMesh"
// MPropertyFriendlyName = "Filter Edges by Angle"
// MPropertyDescription = ""
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_EdgeAngleCriteria : public CSmartPropSelectionCriteria
{
	// MPropertyFriendlyName = "Min Angle"
	// MPropertyDescription = "Angle at closed edge of face."
	CSmartPropAttributeFloat m_flMinAngle;
	// MPropertyFriendlyName = "Max Angle"
	// MPropertyDescription = "Angle at closed edge of face."
	CSmartPropAttributeFloat m_flMaxAngle;
	// MPropertyFriendlyName = "Invert"
	// MPropertyDescription = "When true, discard edges within the angle threshold."
	CSmartPropAttributeBool m_bInvert;
};
