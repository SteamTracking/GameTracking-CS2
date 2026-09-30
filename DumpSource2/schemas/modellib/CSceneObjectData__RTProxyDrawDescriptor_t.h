class CSceneObjectData::RTProxyDrawDescriptor_t
{
	uint32 m_materialGroupToken;
	int32 m_nSrcDrawIndex; // = -1
	CMaterialDrawDescriptor m_drawDesc; // = { "m_flAlpha": 1, "m_flUvDensity": 0, "m_indexBuffer": { "m_hBuffer": 0, "m_nBindOffsetBytes": 0 }, "m_material": "", "m_meshletPackedIVB": { "m_hBuffer": 0, "m_nBindOffsetBytes": 0 }, "m_nAppliedIndexOffset": 0, "m_nBaseVertex": 0, "m_nDepthVertexBufferIndex": 255, "m_nEmissivePrimitiveCount": -1, "m_nFirstMeshlet": 0, "m_nIndexCount": 0, "m_nMeshletPackedIVBIndex": 255, "m_nNumMeshlets": 0, "m_nPrimitiveType": "RENDER_PRIM_TRIANGLES", "m_nStartIndex": 0, "m_nVertexCount": 0, "m_rigidMeshParts": [  ], "m_rootBvhNodes": [  ], "m_vTintColor": [ 1, 1, 1 ], "m_vertexBuffers": [  ] }
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
