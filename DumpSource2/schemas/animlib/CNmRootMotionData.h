class CNmRootMotionData
{
	CUtlVector< CTransform > m_transforms;
	int32 m_nNumFrames;
	float32 m_flAverageLinearVelocity;
	float32 m_flAverageAngularVelocityRadians;
	CTransform m_totalDelta;
};
