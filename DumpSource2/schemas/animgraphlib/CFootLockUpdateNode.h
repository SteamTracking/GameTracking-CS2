// MHasKV3TransferPolymorphicClassname
class CFootLockUpdateNode : public CUnaryUpdateNode
{
	FootLockPoseOpFixedSettings m_opFixedSettings;
	CUtlVector< FootFixedSettings > m_footSettings;
	CAnimInputDamping m_hipShiftDamping;
	CAnimInputDamping m_rootHeightDamping;
	float32 m_flStrideCurveScale;
	float32 m_flStrideCurveLimitScale;
	float32 m_flStepHeightIncreaseScale;
	float32 m_flStepHeightDecreaseScale;
	float32 m_flHipShiftScale;
	float32 m_flBlendTime;
	float32 m_flMaxRootHeightOffset;
	float32 m_flMinRootHeightOffset;
	float32 m_flTiltPlanePitchSpringStrength;
	float32 m_flTiltPlaneRollSpringStrength;
	bool m_bApplyFootRotationLimits;
	bool m_bApplyHipShift;
	bool m_bModulateStepHeight;
	bool m_bResetChild;
	bool m_bEnableVerticalCurvedPaths;
	bool m_bEnableRootHeightDamping;
};
