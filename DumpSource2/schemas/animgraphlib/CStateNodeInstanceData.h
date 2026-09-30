class CStateNodeInstanceData
{
	CRelativeArray< float32 > m_stateWeights;
	Vector m_vTransitionVelocityDeltaWS;
	CAnimNetVar< float32 > m_currentStateStartTime;
	CAnimNetVar< uint8 > m_resetCount;
};
