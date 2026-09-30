// MPropertyFriendlyName = "Create Rotator"
// MPropertyDescription = "Create a rotator that will be displayed at the current location, allowing the user to manipulate a rotation around an axis. The rotation value can be applied to the current transform as well as saved to a variable."
// MVDataClassGroup = "Manipulators"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_CreateRotator : public CSmartPropTransformOperation
{
	// MPropertyFriendlyName = "Name"
	// MPropertyDescription = "Name used to identify the rotator. Must be unique within the parent element."
	CUtlString m_Name;
	// MPropertyDescription = "Offset of the rotator relative to the current transform. This allows the rotator to be created at an offset location without applying that offset to the current transform."
	CSmartPropAttributeVector m_vOffset;
	// MPropertyDescription = "Axis around which the rotation will occur"
	CSmartPropAttributeVector m_vRotationAxis; // = [ 0, 0, 1 ]
	// MPropertyDescription = "Coordinate space the axis of rotation is specified in."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpace; // = "ELEMENT"
	// MPropertyDescription = "Radius at which the rotator handle should be displayed."
	CSmartPropAttributeFloat m_flDisplayRadius; // = 16
	// MPropertyDescription = "Color to display the rotator handle with."
	CSmartPropAttributeColor m_DisplayColor; // = [ 170, 170, 110 ]
	// MPropertyDescription = "Should the rotation be applied to the current transform."
	CSmartPropAttributeBool m_bApplyToCurrentTransform; // = true
	// MPropertyDescription = "Specifies the number of degrees the rotation should snap to. If set to 0, then the rotation snapping will be controlled by the rotation snapping in Hammer."
	CSmartPropAttributeFloat m_flSnappingIncrement;
	// MPropertyDescription = "Specifies the angle the rotator should be set to initially."
	CSmartPropAttributeFloat m_flInitialAngle;
	// MPropertyFriendlyName = "Enforce Limits"
	// MPropertyDescription = "If enabled, the minimum and maximum rotation angles will be used to limit the range of the rotation."
	CSmartPropAttributeBool m_bEnforceLimits;
	// MPropertyReadonlyExpr = "m_bEnforceLimits == false"
	// MPropertyFriendlyName = "Minimum Angle"
	// MPropertyDescription = "Specifies the minimum angle limit in degrees"
	CSmartPropAttributeFloat m_flMinAngle;
	// MPropertyReadonlyExpr = "m_bEnforceLimits == false"
	// MPropertyFriendlyName = "Maximum Angle"
	// MPropertyDescription = "Specifies the minimum angle limit in degrees"
	CSmartPropAttributeFloat m_flMaxAngle;
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	// MPropertyDescription = "Specifies a float variable to which the rotation value should be output. The variable only receives the rotation around the axis, the axis of rotation does not affect this output."
	CUtlString m_OutputVariable;
};
