class PGDInstruction_t
{
	PulseInstructionCode_t m_nCode; // = "INVALID"
	PulseRuntimeVarIndex_t m_nVar; // = -1
	PulseRuntimeRegisterIndex_t m_nReg0; // = -1
	PulseRuntimeRegisterIndex_t m_nReg1; // = -1
	PulseRuntimeRegisterIndex_t m_nReg2; // = -1
	PulseRuntimeInvokeIndex_t m_nInvokeBindingIndex; // = -1
	PulseRuntimeChunkIndex_t m_nChunk; // = -1
	int32 m_nDestInstruction;
	PulseRuntimeCallInfoIndex_t m_nCallInfoIndex; // = -1
	PulseRuntimeConstantIndex_t m_nConstIdx; // = -1
	PulseRuntimeDomainValueIndex_t m_nDomainValueIdx; // = -1
	PulseRuntimeBlackboardReferenceIndex_t m_nBlackboardReferenceIdx; // = -1
	PulseRuntimeTempVarIndex_t m_nTempVarIdx; // = -1
};
