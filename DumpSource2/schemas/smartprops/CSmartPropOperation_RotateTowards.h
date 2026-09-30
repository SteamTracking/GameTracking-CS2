// MPropertyFriendlyName = "Transform: Rotate Towards"
// MPropertyDescription = "Apply a rotation to the current transform according to the alignment of two points."
// MVDataClassGroup = "Transform"
// MVDataExperimentalNodeSet = "smartprops"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_RotateTowards : public CSmartPropTransformOperation
{
	// MPropertyDescription = "Position of origin point."
	CSmartPropAttributeVector m_vOriginPos;
	// MPropertyDescription = "position of target point."
	CSmartPropAttributeVector m_vTargetPos; // = [ 1, 0, 0 ]
	// MPropertyDescription = "position of up point."
	CSmartPropAttributeVector m_vUpPos; // = [ 0, 0, 1 ]
	// MPropertyDescription = "Coefficient to modulate the rotation"
	CSmartPropAttributeFloat m_flWeight; // = 1
	// MPropertyGroupName = "Input Coordinate Space"
	// MPropertyDescription = "Space in which the origin position is defined."
	CSmartPropAttributeCoordinateSpace m_OriginSpace; // = "WORLD"
	// MPropertyGroupName = "Input Coordinate Space"
	// MPropertyDescription = "Space in which the target position is defined."
	CSmartPropAttributeCoordinateSpace m_TargetSpace; // = "WORLD"
	// MPropertyGroupName = "Input Coordinate Space"
	// MPropertyDescription = "Space in which the up target is defined."
	CSmartPropAttributeCoordinateSpace m_UpSpace; // = "WORLD"
};
