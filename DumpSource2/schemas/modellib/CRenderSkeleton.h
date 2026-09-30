class CRenderSkeleton
{
	CUtlVector< RenderSkeletonBone_t > m_bones;
	CUtlVector< int32 > m_boneParents;
	int32 m_nBoneWeightCount; // = 4
};
