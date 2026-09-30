class CDebugDrawHistoryData
{
	CHandle< C_BaseEntity > m_hEntity;
	ESceneViewDebugOverlaysListenerDataType_t m_etype; // = "k_ESceneViewDebugOverlaysListenerDataType_Unknown"
	CUtlLeanVector< Vector4D > m_vectors;
	CUtlLeanVector< Color > m_colors;
	CUtlLeanVector< float32 > m_dimensions;
	CUtlLeanVector< float64 > m_times;
	CUtlLeanVector< uint64 > m_uint64s;
	CUtlLeanVector< bool > m_bools;
	CUtlLeanVector< CUtlString > m_strings;
};
