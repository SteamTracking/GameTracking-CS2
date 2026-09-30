class CVoxelVisibility
{
	uint32 m_nBaseClusterCount;
	uint32 m_nPVSBytesPerCluster;
	Vector m_vMinBounds;
	Vector m_vMaxBounds;
	float32 m_flGridSize;
	uint32 m_nSkyVisibilityCluster;
	uint32 m_nSunVisibilityCluster;
	VoxelVisBlockOffset_t m_NodeBlock;
	VoxelVisBlockOffset_t m_RegionBlock;
	VoxelVisBlockOffset_t m_EnclosedClusterListBlock;
	VoxelVisBlockOffset_t m_EnclosedClustersBlock;
	VoxelVisBlockOffset_t m_MasksBlock;
	VoxelVisBlockOffset_t m_nVisBlocks;
};
