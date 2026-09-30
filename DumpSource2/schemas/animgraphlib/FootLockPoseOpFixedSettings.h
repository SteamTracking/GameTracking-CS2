class FootLockPoseOpFixedSettings
{
	CUtlVector< FootFixedData_t > m_footInfo;
	CAnimInputDamping m_hipDampingSettings; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	int32 m_nHipBoneIndex; // = -1
	IKSolverType m_ikSolverType; // = "IKSOLVER_TwoBone"
	bool m_bApplyTilt;
	bool m_bApplyHipDrop;
	bool m_bAlwaysUseFallbackHinge;
	bool m_bApplyFootRotationLimits;
	bool m_bApplyLegTwistLimits;
	float32 m_flMaxFootHeight; // = -12
	float32 m_flExtensionScale; // = 0.7
	float32 m_flMaxLegTwist; // = 180
	bool m_bEnableLockBreaking;
	float32 m_flLockBreakTolerance; // = 0.2
	float32 m_flLockBlendTime; // = 0.2
	bool m_bEnableStretching;
	float32 m_flMaxStretchAmount; // = 2
	float32 m_flStretchExtensionScale; // = 0.998
};
