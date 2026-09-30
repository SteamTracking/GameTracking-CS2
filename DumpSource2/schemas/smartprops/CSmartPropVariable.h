// MVDataRoot
// MVDataNodeType = 1
// MVDataAnonymousNode
// MVDataOutlinerNameExpr = "m_VariableName"
// MHasKV3TransferPolymorphicClassname
class CSmartPropVariable : public CSmartPropParameter
{
	CUtlString m_VariableName;
	// MPropertySortPriority = -1
	// MPropertyDescription = "If enabled, this value will be exposed as a parameter that can be set on the smart prop object in hammer."
	bool m_bExposeAsParameter;
	// MPropertySortPriority = -1
	// MPropertyReadonlyExpr = "m_bExposeAsParameter == false"
	// MPropertyFriendlyName = "Parameter Display Name"
	// MPropertyDescription = "Name of the parameter which will appear as a property in the Hammer object properties ui when selecting an object using this smart prop."
	CUtlString m_DisplayName;
	// MPropertySortPriority = -1
	// MPropertyReadonlyExpr = "m_bExposeAsParameter == false"
	// MPropertyDescription = "Expression to evaluate to determine if this parameter should be hidden. Can be used to hide this parameter based on the state of other parameters."
	CUtlString m_HideExpression;
	// MPropertySortPriority = -1
	// MPropertyReadonlyExpr = "m_bExposeAsParameter == false"
	// MPropertyDescription = "Expression to evaluate to detemrine if this parameter should be read-only. Can be used to make this parameter read-only based on the state of other parameters."
	CUtlString m_ReadOnlyExpression;
};
