// MPropertyFriendlyName = "Distance"
// MPropertyDescription = "Compute the distance between two 3D points"
// MVDataClassGroup = "Compute"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ComputeDistance3D : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Output Variable"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableName;
	// MPropertyDescription = "Specifies the coordinate space the distance should be computed in. The scale of the coordinate space may affect the distance value."
	CSmartPropAttributeCoordinateSpace m_OutputCoordinateSpace; // = "WORLD"
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
