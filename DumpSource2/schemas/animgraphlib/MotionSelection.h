class MotionSelection
{
	NetVarConfigIndex m_nConfigIndex;
	CAnimNetVar< float32 > m_flCycleZeroTime;
	CAnimNetVar< float32 > m_flPlaybackSpeed; // = 1
	CAnimNetVar< float32 > m_flStartTime;
	int32 m_nSample; // = -1
};
