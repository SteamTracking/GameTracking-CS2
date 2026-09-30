class CFollowPathInstanceData
{
	CRelativeArray< CMotionTransform > m_xLastPredictedTransformsDeltas;
	float32 m_dampedTurnValue;
	float32 m_flTurnAmount;
	CAnimNetVar< float32 > m_flPredictionScale; // = 1
	float32 m_flLastPathTime;
};
