// MPropertyFriendlyName = "Save Current Position"
// MPropertyDescription = "Save the current position to a specified variable in the requested coordinate space"
// MVDataClassGroup = "State"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SavePosition : public CSmartPropOperation
{
	// MPropertyDescription = "Specifies the coordinate space of the saved position value."
	CSmartPropAttributeCoordinateSpace m_CoordinateSpace; // = "WORLD"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_VariableName;
};
