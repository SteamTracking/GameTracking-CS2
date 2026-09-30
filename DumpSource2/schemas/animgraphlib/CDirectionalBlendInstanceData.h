class CDirectionalBlendInstanceData
{
	float32 m_dampedValue;
	float32 m_flCycle;
	float32 m_flPrevCycle;
	CAnimNetVar< float32 > m_flPlaybackRate; // = 1
	CAnimNetVar< float32 > m_flCycleZeroTime;
	CAnimNetVar< float32 > m_resetCycleValue;
	CAnimNetVar< float32 > m_resetCount;
};
