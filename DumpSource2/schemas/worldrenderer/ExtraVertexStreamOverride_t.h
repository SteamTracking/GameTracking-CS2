class ExtraVertexStreamOverride_t : public BaseSceneObjectOverride_t
{
	uint32 m_nSubSceneObject;
	uint32 m_nDrawCallIndex;
	MeshDrawPrimitiveFlags_t m_nAdditionalMeshDrawPrimitiveFlags; // = "MESH_DRAW_FLAGS_NONE"
	CRenderBufferBinding m_extraBufferBinding;
};
