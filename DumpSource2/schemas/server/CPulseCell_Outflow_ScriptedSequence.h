// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_ScriptedSequence : public CPulseCell_BaseYieldingInflow
{
	CUtlString m_szSyncGroup;
	int32 m_nExpectedNumSequencesInSyncGroup;
	bool m_bEnsureOnNavmeshOnFinish; // = true
	bool m_bDontTeleportAtEnd; // = true
	bool m_bDisallowInterrupts; // = true
	PulseScriptedSequenceData_t m_scriptedSequenceDataMain; // = { "m_bIgnoreLookAt": false, "m_bLoopActionSequence": false, "m_bLoopPostIdleSequence": false, "m_bLoopPreIdleSequence": false, "m_nActorID": 0, "m_nHeldWeaponBehavior": "eInvalid", "m_nMoveTo": "eWaitFacing", "m_nMoveToGait": "eInvalid", "m_szEntrySequence": "", "m_szExitSequence": "", "m_szPreIdleSequence": "", "m_szSequence": "" }
	CUtlVector< PulseScriptedSequenceData_t > m_vecAdditionalActors;
	CPulse_ResumePoint m_OnFinished; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	CUtlVector< CPulse_OutflowConnection > m_Triggers;
};
