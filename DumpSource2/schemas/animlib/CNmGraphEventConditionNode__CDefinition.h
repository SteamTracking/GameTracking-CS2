// MHasKV3TransferPolymorphicClassname
class CNmGraphEventConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	CNmBitFlags m_eventConditionRules;
	CUtlVectorFixedGrowable< CNmGraphEventConditionNode::Condition_t, 5 > m_conditions;
};
