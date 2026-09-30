class RenderSkeletonBone_t
{
	CUtlString m_boneName;
	CUtlString m_parentName;
	matrix3x4_t m_invBindPose; // = [ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0 ]
	SkeletonBoneBounds_t m_bbox;
	float32 m_flSphereRadius;
};
