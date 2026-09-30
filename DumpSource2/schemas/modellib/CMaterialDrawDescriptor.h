class CMaterialDrawDescriptor
{
	float32 m_flUvDensity;
	Vector m_vTintColor; // = [ 1, 1, 1 ]
	float32 m_flAlpha; // = 1
	uint32 m_nNumMeshlets;
	uint32 m_nFirstMeshlet;
	uint32 m_nAppliedIndexOffset;
	int32 m_nEmissivePrimitiveCount; // = -1
	uint8 m_nDepthVertexBufferIndex; // = 255
	uint8 m_nMeshletPackedIVBIndex; // = 255
	CUtlLeanVector< CMaterialDrawDescriptor::RigidMeshPart_t > m_rigidMeshParts;
	CUtlLeanVector< uint16 > m_rootBvhNodes;
	RenderPrimitiveType_t m_nPrimitiveType; // = "RENDER_PRIM_TRIANGLES"
	int32 m_nBaseVertex;
	int32 m_nVertexCount;
	int32 m_nStartIndex;
	int32 m_nIndexCount;
	CRenderBufferBinding m_indexBuffer;
	CRenderBufferBinding m_meshletPackedIVB;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_material;
};
