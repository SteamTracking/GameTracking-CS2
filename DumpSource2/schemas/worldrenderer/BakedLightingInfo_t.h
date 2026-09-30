class BakedLightingInfo_t
{
	uint32 m_nLightmapVersionNumber;
	uint32 m_nLightmapGameVersionNumber;
	Vector2D m_vLightmapUvScale; // = [ 1, 1 ]
	bool m_bHasLightmaps;
	bool m_bBakedShadowsGamma20;
	bool m_bCompressionEnabled;
	int8 m_nLPVEncoding; // = -1
	int8 m_nLightmapEncoding; // = -1
	uint8 m_nChartPackIterations;
	uint8 m_nVradQuality;
	CUtlVector< CStrongHandle< InfoForResourceTypeCTextureBase > > m_lightMaps;
	CUtlVector< BakedLightingInfo_t::BakedShadowAssignment_t > m_bakedShadows;
};
