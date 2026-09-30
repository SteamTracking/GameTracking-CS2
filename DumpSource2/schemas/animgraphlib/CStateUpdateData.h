class CStateUpdateData
{
	CUtlString m_name;
	AnimScriptHandle m_hScript;
	CUtlVector< int32 > m_transitionIndices;
	CUtlVector< CStateActionUpdater > m_actions;
	AnimStateID m_stateID;
	bitfield:1 m_bIsStartState;
	bitfield:1 m_bIsEndState;
	bitfield:1 m_bIsPassthrough;
	bitfield:1 m_bIsPassthroughRootMotion;
	bitfield:1 m_bPreEvaluatePassthroughTransitionPath;
};
