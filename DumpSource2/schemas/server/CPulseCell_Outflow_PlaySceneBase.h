// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_PlaySceneBase : public CPulseCell_BaseYieldingInflow
{
	CPulse_ResumePoint m_OnFinished; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	CUtlVector< CPulse_OutflowConnection > m_Triggers;
};
