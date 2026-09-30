class CSteamAudioProbeGrid
{
	AABB_t m_aabb;
	float32 m_flSpacing;
	int32 m_nx;
	int32 m_ny;
	int32 m_nz;
	CUtlVector< CSteamAudioProbeLineSegment > m_vecLineSegments;
	CUtlVector< Vector > m_vecProbes;
};
