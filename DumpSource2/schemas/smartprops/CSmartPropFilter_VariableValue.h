// MPropertyFriendlyName = "Filter: Variable Value"
// MPropertyDescription = "Compares the current value of a variable to the specified value. If the comparison is false the element evaluation is stopped."
// MVDataClassGroup = "Filter"
// MHasKV3TransferPolymorphicClassname
class CSmartPropFilter_VariableValue : public CSmartPropFilter
{
	CSmartPropVariableComparison m_VariableComparison; // = { "m_Comparison": "EQUAL", "m_Name": "", "m_Value": null }
};
