// MPropertyFriendlyName = "Wait and Trace"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_TestWaitWithAutoTracepoints : public CPulseCell_BaseYieldingInflow
{
	CUtlString m_TracePrefix;
	CPulse_ResumePoint m_WakeResume; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
