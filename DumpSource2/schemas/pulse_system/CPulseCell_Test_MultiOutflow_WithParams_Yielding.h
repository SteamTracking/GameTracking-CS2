// MHasKV3TransferPolymorphicClassname
class CPulseCell_Test_MultiOutflow_WithParams_Yielding : public CPulseCell_BaseYieldingInflow
{
	SignatureOutflow_Continue m_Out1; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	SignatureOutflow_Continue m_AsyncChild1; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	SignatureOutflow_Continue m_AsyncChild2; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	SignatureOutflow_Resume m_YieldResume1; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	SignatureOutflow_Resume m_YieldResume2; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
