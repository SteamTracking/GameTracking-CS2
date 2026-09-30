// MPropertyFriendlyName = "Save Direction Vector"
// MPropertyDescription = "Save the specified direction vector to a specified variable, in the requested coordinate space"
// MVDataClassGroup = "State"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SaveDirection : public CSmartPropOperation
{
	// MPropertyDescription = "Specifies which direction vector to save."
	CSmartPropAttributeDirection m_DirectionVector; // = "FORWARD"
	// MPropertyDescription = "Specifies the coordinate space of the saved position value."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpace; // = "WORLD"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_VariableName;
};
