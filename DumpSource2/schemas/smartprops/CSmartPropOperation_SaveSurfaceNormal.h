// MPropertyFriendlyName = "Save Current Surface Normal"
// MPropertyDescription = "Save the current surface normal to a specified variable in the requested coordinate space"
// MVDataClassGroup = "State"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SaveSurfaceNormal : public CSmartPropOperation
{
	// MPropertyDescription = "Specifies the coordinate space of the saved position value."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpace; // = "WORLD"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_VariableName;
};
