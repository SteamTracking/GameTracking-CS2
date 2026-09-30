class RnCompound_t
{
	RnCompoundTree_t m_Tree;
	int32 m_nHullBaseIndex;
	int32 m_nMeshBaseIndex;
	int32 m_nShapeCount;
	CUtlLeanVectorFixedGrowable< RnMesh_t, 1 > m_Meshes;
	CUtlLeanVector< RnHull_t > m_Hulls;
	CUtlLeanVector< RnCapsule_t > m_Capsules;
	CUtlLeanVector< RnSphere_t > m_Spheres;
	CUtlLeanVector< uint8 > m_CompoundMaterialIndices;
	AABB_t m_Bounds;
	Vector m_vOrthographicAreas;
	float32 m_flSurfaceArea;
	float32 m_flVolume;
};
