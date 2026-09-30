// MPropertyFriendlyName = "Time Condition"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_TimeCondition : public CAnimGraphDoc_Condition
{
	Comparison_t m_comparisonOp; // = "COMPARISON_GREATER_OR_EQUAL"
	CUtlString m_comparisonString;
};
