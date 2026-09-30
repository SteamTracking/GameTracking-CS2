// MHasKV3TransferPolymorphicClassname
class CNmTransitionEventConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	CGlobalSymbol m_requireRuleID;
	CNmBitFlags m_eventConditionRules;
	int16 m_nSourceStateNodeIdx; // = -1
	NmTransitionRuleCondition_t m_ruleCondition; // = "AnyAllowed"
};
