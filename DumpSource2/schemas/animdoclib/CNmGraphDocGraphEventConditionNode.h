// MHasKV3TransferPolymorphicClassname
class CNmGraphDocGraphEventConditionNode : public CNmGraphDocFlowNode
{
	NmEventConditionOperator_t m_operator; // = "Or"
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bLimitSearchToSourceState;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bIgnoreInactiveBranchEvents;
	// MPropertyGroupName = "+Conditions"
	// MPropertyAutoExpandSelf
	CUtlVector< CNmGraphDocGraphEventConditionNode::Condition_t > m_conditions; // = [ { "m_eventID": "", "m_type": "Any" } ]
};
