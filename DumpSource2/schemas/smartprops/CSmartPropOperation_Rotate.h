// MPropertyFriendlyName = "Transform: Rotate"
// MPropertyDescription = "Apply a rotation to the current transform."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_Rotate : public CSmartPropTransformOperation
{
	// MPropertyDescription = "Local space rotation (in degrees) to apply to the current transform"
	CSmartPropAttributeAngles m_vRotation;
};
