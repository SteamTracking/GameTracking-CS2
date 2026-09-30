class FootPinningPoseOpFixedData_t
{
	CUtlVector< FootFixedData_t > m_footInfo;
	float32 m_flBlendTime;
	float32 m_flLockBreakDistance;
	float32 m_flMaxLegTwist; // = 25
	int32 m_nHipBoneIndex; // = -1
	bool m_bApplyLegTwistLimits;
	bool m_bApplyFootRotationLimits;
};
