class ModelSkeletonData_t
{
	CUtlVector< CUtlString > m_boneName;
	CUtlVector< int16 > m_nParent;
	CUtlVector< float32 > m_boneSphere;
	CUtlVector< uint32 > m_nFlag;
	CUtlVector< Vector > m_bonePosParent;
	CUtlVector< QuaternionStorage > m_boneRotParent;
	CUtlVector< float32 > m_boneScaleParent;
};
