class CPulseGraphDef
{
	PulseSymbol_t m_DomainIdentifier;
	CPulseValueFullType m_DomainSubType; // = "PVAL_VOID"
	PulseSymbol_t m_ParentMapName;
	PulseSymbol_t m_ParentXmlName;
	CUtlVector< CPulse_Chunk* > m_Chunks;
	CUtlVector< CPulseCell_Base* > m_Cells;
	CUtlVector< CPulse_Variable > m_Vars;
	CUtlVector< CPulse_TempVarBankDefinition* > m_TempVarBanks;
	CUtlVector< CPulse_PublicOutput > m_PublicOutputs;
	CUtlVector< CPulse_InvokeBinding* > m_InvokeBindings;
	CUtlVector< CPulse_CallInfo* > m_CallInfos;
	CUtlVector< CPulse_Constant > m_Constants;
	CUtlVector< CPulse_DomainValue > m_DomainValues;
	CUtlVector< CPulse_BlackboardReference > m_BlackboardReferences;
	CUtlVector< CPulse_OutputConnection* > m_OutputConnections;
};
