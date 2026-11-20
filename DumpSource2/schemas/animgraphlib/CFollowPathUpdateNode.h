// MHasKV3TransferPolymorphicClassname
class CFollowPathUpdateNode : public CUnaryUpdateNode
{
	float32 m_flBlendOutTime; // = 0.3
	bool m_bBlockNonPathMovement;
	bool m_bStopFeetAtGoal;
	bool m_bScaleSpeed;
	float32 m_flScale;
	float32 m_flMinAngle;
	float32 m_flMaxAngle;
	float32 m_flSpeedScaleBlending;
	CAnimInputDamping m_turnDamping;
	AnimValueSource m_facingTarget; // = "MoveHeading"
	CAnimParamHandle m_hParam;
	float32 m_flTurnToFaceOffset;
	bool m_bTurnToFace;
};
