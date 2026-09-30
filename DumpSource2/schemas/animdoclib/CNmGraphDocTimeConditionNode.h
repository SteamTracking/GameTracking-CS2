// MHasKV3TransferPolymorphicClassname
class CNmGraphDocTimeConditionNode : public CNmGraphDocFlowNode
{
	float32 m_flComparand;
	CNmTimeConditionNode::ComparisonType_t m_type; // = "ElapsedTime"
	CNmTimeConditionNode::Operator_t m_operator; // = "LessThan"
};
