// MHasKV3TransferPolymorphicClassname
class CMoverUpdateNode : public CUnaryUpdateNode
{
	CAnimInputDamping m_damping;
	AnimValueSource m_facingTarget; // = "MoveHeading"
	CAnimParamHandle m_hMoveVecParam;
	CAnimParamHandle m_hMoveHeadingParam;
	CAnimParamHandle m_hTurnToFaceParam;
	float32 m_flTurnToFaceOffset;
	float32 m_flTurnToFaceLimit; // = 180
	bool m_bAdditive;
	bool m_bApplyMovement;
	bool m_bOrientMovement;
	bool m_bApplyRotation;
	bool m_bLimitOnly;
};
