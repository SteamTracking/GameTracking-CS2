// MHasKV3TransferPolymorphicClassname
class CNmFootEventConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	NmFootPhaseCondition_t m_phaseCondition; // = "LeftFootDown"
	CNmBitFlags m_eventConditionRules;
};
