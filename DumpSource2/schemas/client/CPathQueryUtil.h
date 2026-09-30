class CPathQueryUtil
{
	CTransform m_PathToEntityTransform;
	CUtlVector< Vector > m_vecPathSamplePositions;
	CUtlVector< float32 > m_vecPathSampleParameters;
	CUtlVector< float32 > m_vecPathSampleDistances;
	bool m_bIsClosedLoop;
};
