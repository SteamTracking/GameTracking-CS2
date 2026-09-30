// MPropertyFriendlyName = "Cycle Condition"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_CycleCondition : public CAnimGraphDoc_Condition
{
	Comparison_t m_comparisonOp; // = "COMPARISON_EQUALS"
	CUtlString m_comparisonString;
	float32 m_comparisonValue;
	ComparisonValueType m_comparisonValueType; // = "COMPARISONVALUETYPE_FIXEDVALUE"
	CUtlString m_comparisonParamName;
	AnimParamID m_comparisonParamID;
};
