class CNmSyncTrack
{
	CUtlLeanVectorFixedGrowable< CNmSyncTrack::Event_t, 10 > m_syncEvents; // = [ { "m_ID": "", "m_duration": { "m_flValue": 1 }, "m_startTime": { "m_flValue": 0 } } ]
	int32 m_nStartEventOffset;
};
