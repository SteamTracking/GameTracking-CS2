class EMaterialLayer_t
{
	CUtlVector< CUtlString > m_VariableNames;
	CUtlVector< std::pair< CUtlString, CUtlString > > m_HiddenVariableUiNames;
	int32 m_ReferenceVariableIndex; // = -1
	CUtlString m_RefType;
	CUtlString m_RefFileEnding;
	bool m_bActive; // = true
	KeyValues3 inheritedVariableValues;
	KeyValues3 inheritedVariableSources;
};
