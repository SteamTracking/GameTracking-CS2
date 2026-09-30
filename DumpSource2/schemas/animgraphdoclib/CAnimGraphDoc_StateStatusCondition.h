// MPropertyFriendlyName = "State Status Condition"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_StateStatusCondition : public CAnimGraphDoc_Condition
{
	StateValue m_sourceValue; // = "SourceStateBlendWeight"
	StateComparisonValueType m_comparisonValueType; // = "StateComparisonValue_FixedValue"
	float32 m_comparisonFixedValue;
	StateValue m_comparisonStateValue; // = "SourceStateBlendWeight"
	CUtlString m_comparisonParamName;
	AnimParamID m_comparisonParamID;
	Comparison_t m_comparisonOp; // = "COMPARISON_EQUALS"
};
