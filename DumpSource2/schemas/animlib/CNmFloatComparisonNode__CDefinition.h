// MHasKV3TransferPolymorphicClassname
class CNmFloatComparisonNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nInputValueNodeIdx; // = -1
	int16 m_nComparandValueNodeIdx; // = -1
	CNmFloatComparisonNode::Comparison_t m_comparison; // = "GreaterThanEqual"
	float32 m_flEpsilon;
	float32 m_flComparisonValue;
};
