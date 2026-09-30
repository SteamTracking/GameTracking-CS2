// MHasKV3TransferPolymorphicClassname
class CStateMachineUpdateNode : public CAnimUpdateNodeBase
{
	CAnimStateMachineUpdater m_stateMachine; // = { "_class": "CAnimStateMachineUpdater", "m_startStateIndex": -1, "m_states": [  ], "m_transitions": [  ] }
	CUtlVector< CStateNodeStateData > m_stateData;
	CUtlVector< CStateNodeTransitionData > m_transitionData;
	bool m_bBlockWaningTags;
	bool m_bLockStateWhenWaning;
	bool m_bResetWhenActivated;
};
