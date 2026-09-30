class AimCameraOpFixedSettings_t
{
	int32 m_nChainIndex; // = -1
	int32 m_nCameraJointIndex; // = -1
	int32 m_nPelvisJointIndex; // = -1
	int32 m_nClavicleLeftJointIndex; // = -1
	int32 m_nClavicleRightJointIndex; // = -1
	int32 m_nDepenetrationJointIndex; // = -1
	CUtlVector< int32 > m_propJoints;
};
