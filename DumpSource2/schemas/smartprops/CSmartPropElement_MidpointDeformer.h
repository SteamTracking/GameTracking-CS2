// MPropertyFriendlyName = "Midpoint Deformer"
// MPropertyDescription = "Soft deform the center of a volume defined by two endpoints."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_MidpointDeformer : public CSmartPropElement_Deformer
{
	// MPropertyFriendlyName = "Deformation Enabled"
	// MPropertyDescription = "Should the deformation be applied. If disabled the children will still be placed, but will not be deformed. Esentially making the element behave as a group."
	CSmartPropAttributeBool m_bDeformationEnabled; // = true
	// MPropertyFriendlyName = "Start Point"
	// MPropertyDescription = "Endpoint of deformation region."
	CSmartPropAttributeVector m_vStart;
	// MPropertyFriendlyName = "End Point"
	// MPropertyDescription = "Endpoint of deformation region."
	CSmartPropAttributeVector m_vEnd;
	// MPropertyFriendlyName = "Effect Size"
	// MPropertyDescription = "The distance from the line formed by the endpoints that encapsulated the deformation region."
	CSmartPropAttributeFloat m_fRadius; // = 64
	// MPropertyFriendlyName = "Continuous Interpolation"
	// MPropertyDescription = "Enables an alternate interpolation method that doesnt deform endpoint tangents."
	CSmartPropAttributeBool m_bContinuousSpline;
	// MPropertyFriendlyName = "Midpoint Offset"
	// MPropertyDescription = "Offsets the center of the deformation region."
	CSmartPropAttributeVector m_vOffset;
	// MPropertyFriendlyName = "Midpoint Rotation"
	// MPropertyDescription = "Rotate the center of the deformation region."
	CSmartPropAttributeAngles m_vAngles;
	// MPropertyFriendlyName = "Midpoint Scale"
	// MPropertyDescription = "Scale the center of the deformation region."
	CSmartPropAttributeVector2D m_vScale; // = [ 1, 1 ]
	// MPropertyFriendlyName = "Falloff"
	// MPropertyDescription = "Adjust deformation falloff from the center of the region to the endpoints."
	CSmartPropAttributeFloat m_fFalloff; // = 1
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector )"
	// MPropertyDescription = "Outputs the absolute position of the midpoint post deformation."
	CUtlString m_OutputVariable;
};
