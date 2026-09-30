class FeVertexMapBuild_t
{
	CUtlString m_VertexMapName;
	uint32 m_nNameHash;
	Color m_Color; // = [ 255, 255, 255 ]
	float32 m_flVolumetricSolveStrength;
	int32 m_nScaleSourceNode; // = -1
	CUtlVector< float32 > m_Weights;
};
