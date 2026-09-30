// MHasKV3TransferPolymorphicClassname
class CNmGraphDocTransitionEventConditionNode : public CNmGraphDocFlowNode
{
	NmTransitionRuleCondition_t m_ruleCondition; // = "AnyAllowed"
	bool m_bMatchOnlySpecificMarkerID;
	// MPropertyAttributeEditor = "AnimGraphID()"
	CGlobalSymbol m_markerIDToMatch;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bLimitSearchToSourceState;
	// MPropertyGroupName = "+Advanced Search Rules"
	bool m_bIgnoreInactiveBranchEvents;
};
