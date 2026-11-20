// MHasKV3TransferPolymorphicClassname
class C_OP_RemapCrossProductOfTwoVectorsToVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "input vector 1"
	CPerParticleVecInput m_InputVec1;
	// MPropertyFriendlyName = "input vector 2"
	CPerParticleVecInput m_InputVec2;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "normalize output"
	bool m_bNormalize;
};
