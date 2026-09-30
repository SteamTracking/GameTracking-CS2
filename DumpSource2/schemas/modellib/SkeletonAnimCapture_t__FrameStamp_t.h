class SkeletonAnimCapture_t::FrameStamp_t
{
	float32 m_flTime;
	float32 m_flEntitySimTime;
	bool m_bTeleportTick;
	bool m_bPredicted;
	float32 m_flCurTime;
	float32 m_flRealTime;
	int32 m_nFrameCount;
	int32 m_nTickCount;
};
