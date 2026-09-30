// MPropertyFriendlyName = "Transform: Reset Rotation"
// MPropertyDescription = "Reset the current rotation such the element only inherits the object level rotation, but does not inherit the rotation applied to its parent."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ResetRotation : public CSmartPropTransformOperation
{
	// MPropertyDescription = "If enabled, the rotation will be reset to a world space instead of object space, meaning any rotation applied to the object in Hammer will be ignored."
	CSmartPropAttributeBool m_bIgnoreObjectRotation;
	// MPropertyDescription = "Should the pitch (rotation around left vector) value be reset."
	CSmartPropAttributeBool m_bResetPitch; // = true
	// MPropertyDescription = "Should the yaw (roation around the up vector) value be reset."
	CSmartPropAttributeBool m_bResetYaw; // = true
	// MPropertyDescription = "Should the roll (rotation around forward vector) value be reset."
	CSmartPropAttributeBool m_bResetRoll; // = true
};
