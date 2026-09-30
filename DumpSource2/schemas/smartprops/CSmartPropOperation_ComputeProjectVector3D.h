// MPropertyFriendlyName = "Project Vector"
// MPropertyDescription = "Project Vector A onto Vector B"
// MVDataClassGroup = "Compute"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ComputeProjectVector3D : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Output Variable"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_OutputVariableName;
	// MPropertyDescription = "Specifies the coordinate space that vector should be returned in."
	CSmartPropAttributeCoordinateSpace m_OutputCoordinateSpace; // = "WORLD"
	// MPropertyGroupName = "+Vector A"
	// MPropertyFriendlyName = "Vector A"
	CSmartPropAttributeVector m_InputVectorA;
	// MPropertyGroupName = "+Vector A"
	// MPropertyDescription = "Specifies the coordinate space of vector A."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpaceA; // = "WORLD"
	// MPropertyGroupName = "+Vector B"
	// MPropertyFriendlyName = "Vector B"
	CSmartPropAttributeVector m_InputVectorB;
	// MPropertyGroupName = "+Vector B"
	// MPropertyDescription = "Specifies the coordinate space of posivectortion B."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpaceB; // = "WORLD"
	// MPropertyFriendlyName = "Projection to plane"
	// MPropertyDescription = "Interpret Vector B as plane normal."
	CSmartPropAttributeBool m_bPlane;
};
