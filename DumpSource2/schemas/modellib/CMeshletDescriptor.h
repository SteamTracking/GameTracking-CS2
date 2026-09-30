class CMeshletDescriptor
{
	PackedAABB_t m_PackedAABB;
	CDrawCullingData m_CullingData;
	uint32 m_nVertexOffset;
	uint32 m_nTriangleOffset;
	uint8 m_nVertexCount;
	uint8 m_nTriangleCount;
	uint16 m_nBoneIndex; // = 65534
};
