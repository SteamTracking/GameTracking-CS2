class AggregateMeshInfo_t
{
	uint32 m_nVisClusterMemberOffset;
	uint8 m_nVisClusterMemberCount;
	bool m_bHasTransform;
	uint8 m_nLODGroupMask;
	int16 m_nDrawCallIndex; // = -1
	int16 m_nLODSetupIndex; // = -1
	Color m_vTintColor; // = [ 255, 255, 255 ]
	ObjectTypeFlags_t m_objectFlags; // = "OBJECT_TYPE_MODEL"
	int32 m_nLightProbeVolumePrecomputedHandshake;
	uint32 m_nInstanceStreamOffset;
	uint32 m_nVertexAlbedoStreamOffset;
	uint32 m_nVertexEmissiveStreamOffset;
	AggregateInstanceStream_t m_instanceStreams; // = "AGGREGATE_INSTANCE_STREAM_NONE"
	float32 m_fEmissiveFactor;
};
