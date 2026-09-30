class CStateMachineInstanceData
{
	float32 m_flTimeInState;
	CAnimNetVar< int32 > m_currentTransitionIndex; // = -1
	int32 m_prevStateIndex; // = -1
	int32 m_scheduledTransitionIndex; // = -1
};
