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
	BakedLightingInfo_t m_nodeLightingInfo;
	bool m_bHasBakedGeometryFlag;
};
