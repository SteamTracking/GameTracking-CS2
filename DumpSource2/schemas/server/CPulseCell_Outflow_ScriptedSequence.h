// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_ScriptedSequence : public CPulseCell_BaseYieldingInflow
{
	CUtlString m_szSyncGroup;
	int32 m_nExpectedNumSequencesInSyncGroup;
	bool m_bEnsureOnNavmeshOnFinish; // = true
	bool m_bDontTeleportAtEnd; // = true
	bool m_bDisallowInterrupts; // = true
	PulseScriptedSequenceData_t m_scriptedSequenceDataMain;
	CUtlVector< PulseScriptedSequenceData_t > m_vecAdditionalActors;
	CPulse_ResumePoint m_OnFinished; // = { "m_nDestChunk": -1, "m_nInstruction": -1 }
	CUtlVector< CPulse_OutflowConnection > m_Triggers;
};
