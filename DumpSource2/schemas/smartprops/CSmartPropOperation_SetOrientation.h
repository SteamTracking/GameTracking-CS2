// MPropertyFriendlyName = "Transform: Set Orientation"
// MPropertyDescription = "Set the current orientation from a specified forward and up vector."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SetOrientation : public CSmartPropTransformOperation
{
	// MPropertyGroupName = "+Forward"
	CSmartPropAttributeVector m_vForwardVector; // = [ 1, 0, 0 ]
	// MPropertyGroupName = "+Forward"
	// MPropertyDescription = "Specifies the coordinate space the forward direction is being specified in"
	CSmartPropAttributeCoordinateSpace m_ForwardDirectionSpace; // = "WORLD"
	// MPropertyGroupName = "+Up"
	CSmartPropAttributeVector m_vUpVector; // = [ 0, 0, 1 ]
	// MPropertyGroupName = "+Up"
	// MPropertyDescription = "Specifies the coordinate space the up direction is being specified in"
	CSmartPropAttributeCoordinateSpace m_UpDirectionSpace; // = "WORLD"
	// MPropertyDescription = "If the specified vectors are not orthogonal, normally the up vector will be adjusted to make it orthogonal to the forward vector. If prioritize up is true, then the forward vector will be adjusted to be orthogonal to the specified up vector instead."
	CSmartPropAttributeBool m_bPrioritizeUp;
};
