// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToPlayer : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nCP1; // = 1
	// MPropertyFriendlyName = "control point offset"
	// MVectorIsCoordinate
	Vector m_vecCP1Pos;
	// MPropertyFriendlyName = "use eye orientation"
	bool m_bOrientToEyes;
	// MPropertyFriendlyName = "position to get"
	ParticleEntityPos_t m_nPosition; // = "PARTICLE_WORLDSPACE_CENTER"
	// MPropertyFriendlyName = "flashlight radius CP"
	// MPropertySuppressExpr = "m_nPosition != PARTICLE_FLASHLIGHT"
	int32 m_nRadiusCP; // = 2
	// MPropertyFriendlyName = "flashlight radius control point component"
	// MPropertyAttributeChoiceName = "vector_component"
	// MPropertySuppressExpr = "m_nPosition != PARTICLE_FLASHLIGHT"
	int32 m_nRadiusCPField;
};
