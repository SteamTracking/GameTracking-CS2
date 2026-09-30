// MPropertyFriendlyName = "Save Current Color"
// MPropertyDescription = "Save the current color tint value to a specified variable"
// MVDataClassGroup = "State"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SaveColor : public CSmartPropOperation
{
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Color )"
	CUtlString m_VariableName;
};
