class WorldNode_t
{
	CUtlVector< SceneObject_t > m_sceneObjects;
	CUtlVector< uint16 > m_visClusterMembership;
	CUtlVector< AggregateSceneObject_t > m_aggregateSceneObjects;
	CUtlVector< ClutterSceneObject_t > m_clutterSceneObjects;
	CUtlVector< AggregateRTProxySceneObject_t > m_rtProxies;
	CUtlVector< ExtraVertexStreamOverride_t > m_extraVertexStreamOverrides;
	CUtlVector< MaterialOverride_t > m_materialOverrides;
	CUtlVector< WorldNodeOnDiskBufferData_t > m_extraVertexStreams;
	CUtlVector< AggregateInstanceStreamOnDiskData_t > m_aggregateInstanceStreams;
	CUtlVector< AggregateVertexAlbedoStreamOnDiskData_t > m_vertexAlbedoStreams;
	CUtlVector< AggregateVertexEmissiveStreamOnDiskData_t > m_vertexEmissiveStreams;
	CUtlVector< CUtlString > m_layerNames;
	CUtlVector< uint8 > m_sceneObjectLayerIndices;
	CUtlString m_grassFileName;
	BakedLightingInfo_t m_nodeLightingInfo; // = { "m_bBakedShadowsGamma20": false, "m_bCompressionEnabled": false, "m_bHasLightmaps": false, "m_bakedShadows": [  ], "m_lightMaps": [  ], "m_nChartPackIterations": 0, "m_nLPVEncoding": -1, "m_nLightmapEncoding": -1, "m_nLightmapGameVersionNumber": 0, "m_nLightmapVersionNumber": 0, "m_nVradQuality": 0, "m_vLightmapUvScale": [ 1, 1 ] }
	bool m_bHasBakedGeometryFlag;
};
