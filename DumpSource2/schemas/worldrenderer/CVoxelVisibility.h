class CVoxelVisibility
{
	uint32 m_nBaseClusterCount;
	uint32 m_nPVSBytesPerCluster;
	Vector m_vMinBounds;
	Vector m_vMaxBounds;
	float32 m_flGridSize;
	uint32 m_nSkyVisibilityCluster;
	uint32 m_nSunVisibilityCluster;
	VoxelVisBlockOffset_t m_NodeBlock; // = { "m_nElementCount": 0, "m_nOffset": 0 }
	VoxelVisBlockOffset_t m_RegionBlock; // = { "m_nElementCount": 0, "m_nOffset": 0 }
	VoxelVisBlockOffset_t m_EnclosedClusterListBlock; // = { "m_nElementCount": 0, "m_nOffset": 0 }
	VoxelVisBlockOffset_t m_EnclosedClustersBlock; // = { "m_nElementCount": 0, "m_nOffset": 0 }
	VoxelVisBlockOffset_t m_MasksBlock; // = { "m_nElementCount": 0, "m_nOffset": 0 }
	VoxelVisBlockOffset_t m_nVisBlocks; // = { "m_nElementCount": 0, "m_nOffset": 0 }
};
