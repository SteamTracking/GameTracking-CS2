// MHasKV3TransferPolymorphicClassname
class C_OP_ModelDampenMovement : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "use only bounding box"
	bool m_bBoundBox;
	// MPropertyFriendlyName = "dampen outside instead of inside"
	bool m_bOutside;
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "test position offset"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecPosOffset;
	// MPropertyFriendlyName = "drag"
	// MPropertyAttributeRange = "-1 1"
	float32 m_fDrag;
};
