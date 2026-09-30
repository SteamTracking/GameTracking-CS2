// MHasKV3TransferPolymorphicClassname
class CFootPinningUpdateNode : public CUnaryUpdateNode
{
	FootPinningPoseOpFixedData_t m_poseOpFixedData; // = { "m_bApplyFootRotationLimits": false, "m_bApplyLegTwistLimits": false, "m_flBlendTime": 0, "m_flLockBreakDistance": 0, "m_flMaxLegTwist": 25, "m_footInfo": [  ], "m_nHipBoneIndex": -1 }
	FootPinningTimingSource m_eTimingSource; // = "FootMotion"
	CUtlVector< CAnimParamHandle > m_params;
	bool m_bResetChild;
};
