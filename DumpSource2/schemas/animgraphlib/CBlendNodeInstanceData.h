class CBlendNodeInstanceData
{
	float32 m_dampedValue;
	float32 m_flCycle;
	float32 m_flCycleZeroTime;
	float32 m_flPlaybackRate; // = 1
	CAnimNetVar< float32 > m_flBlendValue;
	float32 m_flDuration; // = 1
	CAnimNetVar< uint8 > m_resetCount;
};
