// MHasKV3TransferPolymorphicClassname
class C_OP_DirectionBetweenVecsToVec : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 21
	// MPropertyFriendlyName = "first vector"
	CPerParticleVecInput m_vecPoint1;
	// MPropertyFriendlyName = "second vector"
	CPerParticleVecInput m_vecPoint2;
};
