// MHasKV3TransferPolymorphicClassname
class CMoverUpdateNode : public CUnaryUpdateNode
{
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	AnimValueSource m_facingTarget; // = "MoveHeading"
	CAnimParamHandle m_hMoveVecParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hMoveHeadingParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hTurnToFaceParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	float32 m_flTurnToFaceOffset;
	float32 m_flTurnToFaceLimit; // = 180
	bool m_bAdditive;
	bool m_bApplyMovement;
	bool m_bOrientMovement;
	bool m_bApplyRotation;
	bool m_bLimitOnly;
};
