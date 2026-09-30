class SAVE_HEADER
{
	int32 m_saveId;
	int32 m_version;
	int32 m_nConnectionCount;
	int32 m_nMapVersion;
	CUtlString m_sSpawnGroupName;
	matrix3x4a_t m_vecWorldOffset;
	float32 m_flSaveTime;
};
