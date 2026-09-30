class AggregateSceneObject_t
{
	ObjectTypeFlags_t m_allFlags; // = "OBJECT_TYPE_NONE"
	ObjectTypeFlags_t m_anyFlags; // = "OBJECT_TYPE_NONE"
	int16 m_nLayer;
	int16 m_instanceStream; // = -1
	int16 m_vertexAlbedoStream; // = -1
	int16 m_vertexEmissiveStream; // = -1
	CUtlVector< AggregateMeshInfo_t > m_aggregateMeshes;
	CUtlVector< AggregateLODSetup_t > m_lodSetups;
	CUtlVector< uint16 > m_visClusterMembership;
	CUtlVector< matrix3x4_t > m_fragmentTransforms;
	CStrongHandle< InfoForResourceTypeCModel > m_renderableModel;
};
