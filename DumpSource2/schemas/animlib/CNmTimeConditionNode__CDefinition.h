// MHasKV3TransferPolymorphicClassname
class CNmTimeConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_sourceStateNodeIdx; // = -1
	int16 m_nInputValueNodeIdx; // = -1
	float32 m_flComparand;
	CNmTimeConditionNode::ComparisonType_t m_type; // = "ElapsedTime"
	CNmTimeConditionNode::Operator_t m_operator; // = "LessThan"
};
