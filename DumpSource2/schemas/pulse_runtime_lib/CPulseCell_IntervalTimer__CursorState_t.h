class CPulseCell_IntervalTimer::CursorState_t
{
	GameTime_t m_StartTime;
	GameTime_t m_EndTime;
	float32 m_flWaitInterval;
	float32 m_flWaitIntervalHigh;
	bool m_bCompleteOnNextWake;
};
