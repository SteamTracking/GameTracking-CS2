// MHasKV3TransferPolymorphicClassname
class CNmGraphDocIDEventPercentageThroughNode : public CNmGraphDocFlowNode
{
	// MPropertyGroupName = "+Advanced Search Rules"
	NmEventPriorityRule_t m_priorityRule; // = "HighestWeight"
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bLimitSearchToSourceState;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bIgnoreInactiveBranchEvents;
	// MPropertyAttributeEditor = "AnimGraphID()"
	CGlobalSymbol m_eventID;
};
