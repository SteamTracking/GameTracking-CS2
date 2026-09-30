class RTProxyBLAS_t
{
	uint32 m_nFirstIndex;
	uint32 m_nIndexCount;
	uint32 m_nVBByteOffset;
	uint32 m_nBaseVertex;
	uint16 m_nVertexCount;
	VertexAlbedoFormat_t m_albedoFormat; // = "VERTEX_ALBEDO_NONE"
	AABB_t m_boundLs;
	Vector m_vVertexOriginLs;
	Vector m_vVertexExtentLs;
};
