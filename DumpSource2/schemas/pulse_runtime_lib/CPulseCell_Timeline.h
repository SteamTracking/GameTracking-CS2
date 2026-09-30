// MHasKV3TransferPolymorphicClassname
class CPulseCell_Timeline : public CPulseCell_BaseYieldingInflow
{
	CUtlVector< CPulseCell_Timeline::TimelineEvent_t > m_TimelineEvents;
	bool m_bWaitForChildOutflows; // = true
	CPulse_ResumePoint m_OnFinished; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
