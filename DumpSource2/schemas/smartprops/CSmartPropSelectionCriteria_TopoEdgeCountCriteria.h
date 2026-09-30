// MVDataComponentValidGrandParents = "CSmartPropElement_PlaceOnMesh"
// MPropertyFriendlyName = "Filter Faces By Open Edges"
// MPropertyDescription = ""
// MHasKV3TransferPolymorphicClassname
class CSmartPropSelectionCriteria_TopoEdgeCountCriteria : public CSmartPropSelectionCriteria
{
	// MPropertyFriendlyName = "Edge Count"
	// MPropertyDescription = "Iterate through faces with 'n' open edges (edges with only one neighboring face)."
	CSmartPropAttributeInt m_nTargetOpenEdgeCount;
	// MPropertyFriendlyName = "Use Closed Edges"
	// MPropertyDescription = "When true, we only consider closed edges (edges with exactly two neighboring faces)."
	CSmartPropAttributeBool m_bInvert;
	// MPropertyFriendlyName = "Enforce Shared Vert"
	// MPropertyDescription = "When true, only consider open/closed edges that share a vert with another open/closed edge."
	CSmartPropAttributeBool m_bSharedVert;
};
