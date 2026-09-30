// MPropertyFriendlyName = "Transform: Reset Scale"
// MPropertyDescription = "Reset the current scale such the element only inherits the object level scale, but does not inherit the scale applied to its parent."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ResetScale : public CSmartPropTransformOperation
{
	// MPropertyDescription = "If enabled, the object level scale will be ignored, meaning any scale applied in Hammer will have no effect on the element or its children."
	CSmartPropAttributeBool m_bIgnoreObjectScale;
};
