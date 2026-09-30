// MHasKV3TransferPolymorphicClassname
class CPulseCell_FireCursors : public CPulseCell_BaseYieldingInflow
{
	CUtlVector< CPulse_OutflowConnection > m_Outflows;
	bool m_bWaitForChildOutflows; // = true
	CPulse_ResumePoint m_OnFinished; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
