class World_t
{
	WorldBuilderParams_t m_builderParams; // = { "m_bAggregateInstanceStreams": false, "m_bBuildBakedLighting": false, "m_bakedLightingInfo": { "m_bBakedShadowsGamma20": false, "m_bCompressionEnabled": false, "m_bHasLightmaps": false, "m_bakedShadows": [  ], "m_lightMaps": [  ], "m_nChartPackIterations": 0, "m_nLPVEncoding": -1, "m_nLightmapEncoding": -1, "m_nLightmapGameVersionNumber": 0, "m_nLightmapVersionNumber": 0, "m_nVradQuality": 0, "m_vLightmapUvScale": [ 1, 1 ] }, "m_flMinDrawVolumeSize": 0, "m_nCompileFingerprint": 0, "m_nCompileTimestamp": 0 }
	CUtlVector< NodeData_t > m_worldNodes;
	BakedLightingInfo_t m_worldLightingInfo; // = { "m_bBakedShadowsGamma20": false, "m_bCompressionEnabled": false, "m_bHasLightmaps": false, "m_bakedShadows": [  ], "m_lightMaps": [  ], "m_nChartPackIterations": 0, "m_nLPVEncoding": -1, "m_nLightmapEncoding": -1, "m_nLightmapGameVersionNumber": 0, "m_nLightmapVersionNumber": 0, "m_nVradQuality": 0, "m_vLightmapUvScale": [ 1, 1 ] }
	CUtlVector< CStrongHandleCopyable< InfoForResourceTypeCEntityLump > > m_entityLumps;
};
