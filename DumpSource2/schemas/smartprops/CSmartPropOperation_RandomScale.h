// MPropertyFriendlyName = "Transform: Random Scale"
// MPropertyDescription = "Apply a random scale to the current transform."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_RandomScale : public CSmartPropTransformOperation
{
	// MPropertyDescription = "Minimum scale range"
	CSmartPropAttributeFloat m_flRandomScaleMin; // = 1
	// MPropertyDescription = "Maximum scale range"
	CSmartPropAttributeFloat m_flRandomScaleMax; // = 1
	// MPropertyDescription = "If non-zero, specifies the increment to which the randomly selected scale value will be snapped. Note that the snap value is absolute, not relative to the min or max, but if the min or max are not multiples of the snap value they can still be selected."
	CSmartPropAttributeFloat m_flSnapIncrement;
};
