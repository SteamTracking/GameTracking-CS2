class VariableInfo_t
{
	CUtlString m_name;
	CUtlStringToken m_nameToken;
	FuseVariableIndex_t m_nIndex; // = 65535
	uint8 m_nNumComponents; // = 1
	FuseVariableType_t m_eVarType; // = "INVALID"
	FuseVariableAccess_t m_eAccess; // = "WRITABLE"
};
