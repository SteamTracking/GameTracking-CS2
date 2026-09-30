class ScriptInfo_t
{
	CUtlString m_code;
	CUtlVector< CAnimParamHandle > m_paramsModified;
	CUtlVector< int32 > m_proxyReadParams;
	CUtlVector< int32 > m_proxyWriteParams;
	AnimScriptType m_eScriptType; // = "ANIMSCRIPT_TYPE_INVALID"
};
