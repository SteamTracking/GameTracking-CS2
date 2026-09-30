class RTProxyInstanceInfo_t
{
	RTProxyInstanceFlags_t m_nFlags;
	VertexAlbedoFormat_t m_albedoFormat; // = "VERTEX_ALBEDO_NONE"
	VertexAlbedoFormat_t m_emissiveFormat; // = "VERTEX_ALBEDO_NONE"
	uint16 m_nBLASCount;
	uint32 m_nBLASIndex;
	uint32 m_nVertexAlbedoByteOffset;
	uint32 m_nVertexEmissiveByteOffset;
	float32 m_fEmissiveFactor;
	matrix3x4_t m_mWorldFromLocal;
	Color m_vTintColorSRGB; // = [ 255, 255, 255 ]
};
