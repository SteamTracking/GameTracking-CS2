class CSmartPropChoiceOption
{
	// MPropertyFriendlyName = "Option Value Name"
	CUtlString m_Name;
	// MPropertyFriendlyName = "Option Display Name"
	CUtlString m_DisplayName;
	// MPropertyAutoExpandSelf
	// MPropertyAttributeEditor = "SmartPropAttributeEditor(VariableValue)"
	CUtlVector< CSmartPropAttributeVariableValue > m_VariableValues;
};
