// MPropertyFriendlyName = "Set Variable"
// MPropertyDescription = "Set the value of a variable."
// MVDataClassGroup = "State"
// MVDataOutlinerNameExpr = "m_VariableValue.m_TargetName"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SetVariable : public CSmartPropOperation
{
	CSmartPropAttributeVariableValue m_VariableValue; // = { "m_DataType": "INVALID", "m_TargetName": "", "m_Value": null }
};
