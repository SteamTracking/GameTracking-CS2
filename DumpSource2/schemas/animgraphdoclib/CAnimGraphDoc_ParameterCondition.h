// MPropertyFriendlyName = "Parameter Condition"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_ParameterCondition : public CAnimGraphDoc_Condition
{
	CUtlString m_paramName;
	AnimParamID m_paramID;
	Comparison_t m_comparisonOp; // = "COMPARISON_EQUALS"
	CAnimVariant m_comparisonValue;
	CUtlString m_comparisonString;
};
