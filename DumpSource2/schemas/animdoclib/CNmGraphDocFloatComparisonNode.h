// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFloatComparisonNode : public CNmGraphDocFlowNode
{
	CNmFloatComparisonNode::Comparison_t m_comparison; // = "GreaterThanEqual"
	float32 m_flComparisonValue;
	float32 m_flEpsilon;
};
