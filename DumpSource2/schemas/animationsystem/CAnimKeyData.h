class CAnimKeyData
{
	CBufferString m_name;
	CUtlVector< CAnimBone > m_boneArray;
	CUtlVector< CAnimUser > m_userArray;
	CUtlVector< CBufferString > m_morphArray;
	int32 m_nChannelElements;
	CUtlVector< CAnimDataChannelDesc > m_dataChannelArray;
};
