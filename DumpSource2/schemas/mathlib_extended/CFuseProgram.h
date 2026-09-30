class CFuseProgram
{
	CUtlVector< uint8 > m_programBuffer;
	CUtlVector< FuseVariableIndex_t > m_variablesRead;
	CUtlVector< FuseVariableIndex_t > m_variablesWritten;
	int32 m_nMaxTempVarsUsed;
};
