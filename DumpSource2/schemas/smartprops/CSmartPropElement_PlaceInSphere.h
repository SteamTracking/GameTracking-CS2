// MPropertyFriendlyName = "Place In Radius"
// MPropertyDescription = "An element which places multiple instances of its child elements within a radius."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_PlaceInSphere : public CSmartPropElement_Group
{
	// MPropertyDescription = "Specifies how the positions are computed based on the radius."
	CSmartPropAttributeRadiusPlacementMode m_PlacementMode; // = "SPHERE"
	// MPropertyDescription = "Specifies the method to be used to distribute."
	CSmartPropAttributeDistributionMode m_DistributionMode; // = "RANDOM"
	// MPropertySuppressExpr = "m_DistributionMode == RANDOM"
	// MPropertyDescription = "0 to 1 value indicating the amout of random offset that should be applied to the reguluarly spaced positions"
	CSmartPropAttributeFloat m_flRandomness;
	// MPropertySuppressExpr = "m_PlacementMode == SPHERE"
	// MPropertyDescription = "Vector up direction of the plane of the circle. This in the local space of the current element."
	CSmartPropAttributeVector m_vPlaneUpDirection; // = [ 0, 0, 1 ]
	// MPropertyDescription = "Minimum number of instances of this object and its children to be placed."
	CSmartPropAttributeInt m_nCountMin; // = 1
	// MPropertyDescription = "Maximum number of instances of this object and its children to be placed."
	CSmartPropAttributeInt m_nCountMax; // = 1
	// MPropertyDescription = "Inner radius from the placement position where the model can appear."
	CSmartPropAttributeFloat m_flPositionRadiusInner;
	// MPropertyDescription = "Outer radius from the placement position where the model can appear."
	CSmartPropAttributeFloat m_flPositionRadiusOuter;
	// MPropertyDescription = "Align the initial orientation of each placed object based on it position on the sphere or circle."
	CSmartPropAttributeBool m_bAlignOrientation;
	// MPropertyReadonlyExpr = "m_bAlignOrientation == false"
	// MPropertyDescription = "Vector in the local space of the child element to be aligned with sphere or circle"
	CSmartPropAttributeVector m_vAlignDirection; // = [ 0, 0, 1 ]
};
