// MHasKV3TransferPolymorphicClassname
class C_OP_ScreenSpacePositionOfTarget : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "target position"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecTargetPosition;
	// MPropertyFriendlyName = "output behindness"
	bool m_bOututBehindness;
	// MPropertyFriendlyName = "behindness output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "m_bOututBehindness == false"
	ParticleAttributeIndex_t m_nBehindFieldOutput; // = 7
	// MPropertyFriendlyName = "behindness output remap"
	// MPropertySuppressExpr = "m_bOututBehindness == false"
	CParticleRemapFloatInput m_flBehindOutputRemap;
	// MPropertyFriendlyName = "behindness set value method"
	// MPropertySuppressExpr = "m_bOututBehindness == false"
	ParticleSetMethod_t m_nBehindSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
