// MVDataExperimentalNodeSet = "smartprops"
// MPropertyFriendlyName = "Place on Mesh"
// MPropertyDescription = "Place Children on Mesh Components."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_PlaceOnMesh : public CSmartPropElement_Deformer
{
	// MPropertyStartGroup = ""
	// MPropertyFriendlyName = "Orientation Mode"
	// MPropertyDescription = "Determine how child elements are oriented when mapped to face."
	CSmartPropAttributeOrientationMode m_nPickMode; // = "FIRST_CLOSED_EDGE"
	// MPropertyDescription = ""
	CUtlString m_MeshName;
};
