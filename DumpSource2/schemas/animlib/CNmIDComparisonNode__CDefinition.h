// MHasKV3TransferPolymorphicClassname
class CNmIDComparisonNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nInputValueNodeIdx; // = -1
	CNmIDComparisonNode::Comparison_t m_comparison; // = "Matches"
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 4 > m_comparisionIDs;
};
