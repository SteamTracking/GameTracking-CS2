class CMotionGraphGroup
{
	CMotionSearchDB m_searchDB;
	CUtlVector< CSmartPtr< CMotionGraph > > m_motionGraphs;
	CUtlVector< CMotionGraphConfig > m_motionGraphConfigs;
	CUtlVector< int32 > m_sampleToConfig;
	AnimScriptHandle m_hIsActiveScript;
};
