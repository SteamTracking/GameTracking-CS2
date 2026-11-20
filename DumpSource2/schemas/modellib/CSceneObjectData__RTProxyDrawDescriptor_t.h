class CSceneObjectData::RTProxyDrawDescriptor_t
{
	uint32 m_materialGroupToken;
	int32 m_nSrcDrawIndex; // = -1
	CMaterialDrawDescriptor m_drawDesc;
	matrix3x4_t m_mWorldFromLocal;
	VertexAlbedoFormat_t m_nVertexAlbedoFormat; // = "VERTEX_ALBEDO_NONE"
	int8 m_nVertexAlbedoVB; // = -1
	uint16 m_nVertexAlbedoOffset;
	uint16 m_nVertexAlbedoStride;
	VertexAlbedoFormat_t m_nVertexEmissiveFormat; // = "VERTEX_ALBEDO_NONE"
	int8 m_nVertexEmissiveVB; // = -1
	uint16 m_nVertexEmissiveOffset;
	uint16 m_nVertexEmissiveStride;
	float32 m_fEmissiveFactor;
};
