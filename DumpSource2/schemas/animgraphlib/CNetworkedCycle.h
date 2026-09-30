class CNetworkedCycle
{
	float32 m_flCycleUnclamped;
	float32 m_flPrevCycleUnclamped;
	CAnimNetVar< float32 > m_flCyclesPerSecond; // = 1
	CAnimNetVar< float32 > m_flCycleZeroTime;
	CAnimNetVar< uint8 > m_resetCount;
};
