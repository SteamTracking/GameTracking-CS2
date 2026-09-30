// MHasKV3TransferPolymorphicClassname
class CNmGraphDocIDComparisonNode : public CNmGraphDocFlowNode
{
	CNmIDComparisonNode::Comparison_t m_comparison; // = "Matches"
	// MPropertyAttributeEditor = "AnimGraphID()"
	// MPropertyAutoExpandSelf
	CUtlVector< CGlobalSymbol > m_values;
};
