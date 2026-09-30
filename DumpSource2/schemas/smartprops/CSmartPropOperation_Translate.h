// MPropertyFriendlyName = "Transform: Translate"
// MPropertyDescription = "Apply a position offset to the current transform."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_Translate : public CSmartPropTransformOperation
{
	// MPropertyDescription = "Local space position translation to apply to the current transform"
	CSmartPropAttributeVector m_vPosition;
	// MPropertyDescription = "Specifies the coordinate space of the specified position value."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpace; // = "ELEMENT"
};
