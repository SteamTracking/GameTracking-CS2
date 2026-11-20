// MHasKV3TransferPolymorphicClassname
class CStateMachineUpdateNode : public CAnimUpdateNodeBase
{
	CAnimStateMachineUpdater m_stateMachine;
	CUtlVector< CStateNodeStateData > m_stateData;
	CUtlVector< CStateNodeTransitionData > m_transitionData;
	bool m_bBlockWaningTags;
	bool m_bLockStateWhenWaning;
	bool m_bResetWhenActivated;
};
