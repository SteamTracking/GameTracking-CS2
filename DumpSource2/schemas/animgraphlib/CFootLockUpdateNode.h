// MHasKV3TransferPolymorphicClassname
class CFootLockUpdateNode : public CUnaryUpdateNode
{
	FootLockPoseOpFixedSettings m_opFixedSettings; // = { "m_bAlwaysUseFallbackHinge": false, "m_bApplyFootRotationLimits": false, "m_bApplyHipDrop": false, "m_bApplyLegTwistLimits": false, "m_bApplyTilt": false, "m_bEnableLockBreaking": false, "m_bEnableStretching": false, "m_flExtensionScale": 0.7, "m_flLockBlendTime": 0.2, "m_flLockBreakTolerance": 0.2, "m_flMaxFootHeight": -12, "m_flMaxLegTwist": 180, "m_flMaxStretchAmount": 2, "m_flStretchExtensionScale": 0.998, "m_footInfo": [  ], "m_hipDampingSettings": { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }, "m_ikSolverType": "IKSOLVER_TwoBone", "m_nHipBoneIndex": -1 }
	CUtlVector< FootFixedSettings > m_footSettings;
	CAnimInputDamping m_hipShiftDamping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	CAnimInputDamping m_rootHeightDamping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
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
