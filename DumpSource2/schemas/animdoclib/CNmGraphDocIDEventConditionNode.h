// MHasKV3TransferPolymorphicClassname
class CNmGraphDocIDEventConditionNode : public CNmGraphDocFlowNode
{
	NmEventConditionOperator_t m_operator; // = "Or"
	CNmGraphDocIDEventConditionNode::SearchRule_t m_searchRule; // = "SearchAll"
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bLimitSearchToSourceState;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bIgnoreInactiveBranchEvents;
	// MPropertyGroupName = "+Conditions"
	// MPropertyAttributeEditor = "AnimGraphID()"
	// MPropertyAutoExpandSelf
	CUtlVector< CGlobalSymbol > m_eventIDs;
};
