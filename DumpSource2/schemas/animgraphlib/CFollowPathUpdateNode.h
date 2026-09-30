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
	CAnimInputDamping m_turnDamping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	AnimValueSource m_facingTarget; // = "MoveHeading"
	CAnimParamHandle m_hParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	float32 m_flTurnToFaceOffset;
	bool m_bTurnToFace;
};
