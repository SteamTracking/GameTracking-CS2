// MVDataComponentValidGrandParents = "CSmartPropElement_PlaceOnMesh"
// MPropertyFriendlyName = "Filter Faces By Vertex Count"
// MPropertyDescription = ""
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_VertexCountCriteria : public CSmartPropSelectionCriteria
{
	// MPropertyFriendlyName = "Target Vertex Count"
	// MPropertyDescription = "Iterate through faces with target vertex count."
	CSmartPropAttributeInt m_nTargetVertexCount;
};
