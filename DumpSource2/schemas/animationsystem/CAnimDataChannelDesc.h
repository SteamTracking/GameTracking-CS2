class CAnimDataChannelDesc
{
	CBufferString m_szChannelClass;
	CBufferString m_szVariableName;
	int32 m_nFlags;
	int32 m_nType;
	CBufferString m_szGrouping;
	CBufferString m_szDescription;
	CUtlVector< CBufferString > m_szElementNameArray;
	CUtlVector< int32 > m_nElementIndexArray;
	CUtlVector< uint32 > m_nElementMaskArray;
};
