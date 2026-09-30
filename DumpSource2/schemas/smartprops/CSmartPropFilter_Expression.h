// MPropertyFriendlyName = "Filter: Expression"
// MPropertyDescription = "Evaluates the specified expression, if the result of the expression is false evaluation of the element is stopped."
// MVDataClassGroup = "Filter"
// MHasKV3TransferPolymorphicClassname
class CSmartPropFilter_Expression : public CSmartPropFilter
{
	// MPropertyAttributeEditor = "SmartPropAttributeEditor(expression)"
	CUtlString m_Expression;
};
