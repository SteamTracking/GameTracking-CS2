// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFloatCurveEventNode : public CNmGraphDocFlowNode
{
	CGlobalSymbol m_matchID;
	float32 m_flDefaultValue;
	// MPropertyGroupName = "+Advanced Search Rules"
	NmEventPriorityRule_t m_priorityRule; // = "HighestWeight"
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bLimitSearchToSourceState;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bIgnoreInactiveBranchEvents;
};
