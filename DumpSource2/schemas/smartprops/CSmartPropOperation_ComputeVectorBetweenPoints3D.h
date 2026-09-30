// MPropertyFriendlyName = "Vector Between Points"
// MPropertyDescription = "Compute the vector between two 3D points"
// MVDataClassGroup = "Compute"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ComputeVectorBetweenPoints3D : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Output Variable"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_OutputVariableName;
	// MPropertyDescription = "Specifies the coordinate space that vector should be returned in."
	CSmartPropAttributeCoordinateSpace m_OutputCoordinateSpace; // = "WORLD"
	// MPropertyFriendlyName = "Normalized (Direction Vector)"
	// MPropertyDescription = "Should the return value be normalized to unit length (direction vector)."
	CSmartPropAttributeBool m_bNormalized;
	// MPropertyGroupName = "+Position A"
	// MPropertyFriendlyName = "Position A"
	CSmartPropAttributeVector m_InputPositionA;
	// MPropertyGroupName = "+Position A"
	// MPropertyDescription = "Specifies the coordinate space of position A."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpaceA; // = "WORLD"
	// MPropertyGroupName = "+Position B"
	// MPropertyFriendlyName = "Position B"
	CSmartPropAttributeVector m_InputPositionB;
	// MPropertyGroupName = "+Position B"
	// MPropertyDescription = "Specifies the coordinate space of position B."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpaceB; // = "WORLD"
};
