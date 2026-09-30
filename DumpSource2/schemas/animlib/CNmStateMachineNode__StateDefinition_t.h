class CNmStateMachineNode::StateDefinition_t
{
	int16 m_nStateNodeIdx; // = -1
	int16 m_nEntryConditionNodeIdx; // = -1
	CUtlLeanVectorFixedGrowable< CNmStateMachineNode::TransitionDefinition_t, 5 > m_transitionDefinitions;
};
