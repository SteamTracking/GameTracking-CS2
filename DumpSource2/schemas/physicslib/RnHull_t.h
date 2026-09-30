class RnHull_t
{
	Vector m_vCentroid;
	float32 m_flMaxAngularRadius;
	float32 m_flMinCentroidRadius;
	AABB_t m_Bounds;
	Vector m_vOrthographicAreas;
	matrix3x4_t m_MassProperties; // = [ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0 ]
	float32 m_flVolume;
	float32 m_flSurfaceArea;
	CUtlVector< Vector > m_VertexPositions; // = "[BINARY BLOB]"
	CUtlVector< RnPlane_t > m_FacePlanes;
	uint32 m_nFlags;
	CRegionSVM* m_pRegionSVM;
	CUtlVector< RnVertex_t > m_Vertices; // = "[BINARY BLOB]"
	CUtlVector< RnHalfEdge_t > m_Edges; // = "[BINARY BLOB]"
	CUtlVector< RnFace_t > m_Faces; // = "[BINARY BLOB]"
};
