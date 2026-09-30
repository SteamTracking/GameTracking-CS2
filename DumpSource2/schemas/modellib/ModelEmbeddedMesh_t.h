class ModelEmbeddedMesh_t
{
	CUtlString m_Name;
	int32 m_nMeshIndex; // = -1
	int32 m_nDataBlock; // = -1
	int32 m_nMorphBlock; // = -1
	CUtlVector< ModelMeshBufferData_t > m_vertexBuffers;
	CUtlVector< ModelMeshBufferData_t > m_indexBuffers;
	CUtlVector< ModelMeshBufferData_t > m_toolsBuffers;
	int32 m_nVBIBBlock; // = -1
	int32 m_nToolsVBBlock; // = -1
};
