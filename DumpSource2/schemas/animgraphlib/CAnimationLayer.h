class CAnimationLayer
{
	CAnimNetVar< int32 > m_hSequence;
	float32 m_flPrevCycle;
	CAnimNetVar< float32 > m_flCycle;
	CAnimNetVar< float32 > m_flWeight;
	CAnimNetVar< int32 > m_nOrder; // = 12
	bool m_bLooping;
	int32 m_nFlags;
	bool m_bSequenceFinished;
	float32 m_flKillRate; // = 100
	float32 m_flKillDelay;
	int32 m_nPriority;
};
