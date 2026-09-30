// MHasKV3TransferPolymorphicClassname
class CJumpHelperUpdateNode : public CSequenceUpdateNode
{
	CAnimParamHandle m_hTargetParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	Vector m_flOriginalJumpMovement;
	float32 m_flOriginalJumpDuration;
	float32 m_flJumpStartCycle;
	float32 m_flJumpEndCycle;
	JumpCorrectionMethod m_eCorrectionMethod; // = "ScaleMotion"
	bool[3] m_bTranslationAxis;
	bool m_bScaleSpeed;
};
