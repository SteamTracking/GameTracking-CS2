class CPulse_Variable
{
	PulseSymbol_t m_Name;
	CUtlString m_Description;
	CPulseValueFullType m_Type; // = "PVAL_VOID"
	KeyValues3 m_DefaultValue;
	PulseVariableKeysSource_t m_nKeysSource; // = "PRIVATE"
	bool m_bIsPublicBlackboardVariable;
	bool m_bIsObservable;
	PulseDocNodeID_t m_nEditorNodeID; // = -1
	KeyValues3 m_Metadata;
};
