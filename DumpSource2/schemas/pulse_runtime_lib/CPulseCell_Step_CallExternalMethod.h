// MHasKV3TransferPolymorphicClassname
class CPulseCell_Step_CallExternalMethod : public CPulseCell_BaseYieldingInflow
{
	PulseSymbol_t m_MethodName;
	PulseRuntimeBlackboardReferenceIndex_t m_nBlackboardIndex; // = -1
	CUtlLeanVector< CPulseRuntimeMethodArg > m_ExpectedArgs;
	PulseMethodCallMode_t m_nAsyncCallMode; // = "ASYNC_FIRE_AND_FORGET"
	CPulse_ResumePoint m_OnFinished; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
