// MPropertyFriendlyName = "Transform: Random Rotation"
// MPropertyDescription = "Apply a random rotation to the current transform."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_RandomRotation : public CSmartPropTransformOperation
{
	// MPropertyDescription = "Minimum rotation range"
	CSmartPropAttributeAngles m_vRandomRotationMin;
	// MPropertyDescription = "Maximum rotation range"
	CSmartPropAttributeAngles m_vRandomRotationMax;
	// MPropertyDescription = "If non-zero, specifies the angle increment to which the randomly selected value will be snapped. Note that the snap value is absolute, not relative to the min or max, but if the if the min or max are not multiples of the snap value they can still be selected."
	CSmartPropAttributeAngles m_vSnapIncrement;
};
