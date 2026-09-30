class AggregateRTProxySceneObject_t
{
	int16 m_nLayer;
	CUtlVector< RTProxyBLAS_t > m_BLASes;
	CUtlVector< RTProxyInstanceInfo_t > m_Instances;
	CUtlBinaryBlock m_VBData; // = "[BINARY BLOB]"
	CUtlBinaryBlock m_IBData; // = "[BINARY BLOB]"
	CUtlBinaryBlock m_InstanceAlbedoData; // = "[BINARY BLOB]"
	CUtlBinaryBlock m_InstanceEmissiveData; // = "[BINARY BLOB]"
};
