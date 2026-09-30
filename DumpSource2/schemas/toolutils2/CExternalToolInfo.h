class CExternalToolInfo : public CBaseToolInfo
{
	CUtlString m_Executable;
	CUtlString m_Args;
	CUtlString m_ArgsWithLineColumn;
	CUtlString m_WorkingDir;
	CUtlString m_MatchSystemExecutable;
	CUtlVector< CUtlString > m_SupportedExts;
	CUtlVector< CUtlString > m_PriorityExts;
	bool m_bDebugCommandline;
};
