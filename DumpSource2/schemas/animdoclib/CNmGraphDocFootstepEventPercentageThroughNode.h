// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFootstepEventPercentageThroughNode : public CNmGraphDocFlowNode
{
	NmFootPhaseCondition_t m_phaseCondition; // = "LeftFootDown"
	// MPropertyGroupName = "+Advanced Search Rules"
	NmEventPriorityRule_t m_priorityRule; // = "HighestWeight"
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bLimitSearchToSourceState;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bIgnoreInactiveBranchEvents;
};
