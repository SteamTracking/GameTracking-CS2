class CPulse_Chunk
{
	CUtlLeanVector< PGDInstruction_t > m_Instructions;
	CUtlLeanVector< CPulse_RegisterInfo > m_Registers;
	CUtlLeanVector< CPulse_InstructionDebug > m_InstructionDebugInfos;
	PulseRuntimeTempVarBankIndex_t m_nTempVarBank; // = -1
};
