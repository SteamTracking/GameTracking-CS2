class CNmStateMachineNode::TransitionDefinition_t
{
	int16 m_nTargetStateIdx; // = -1
	int16 m_nConditionNodeIdx; // = -1
	int16 m_nTransitionNodeIdx; // = -1
	bool m_bCanBeForced;
};
