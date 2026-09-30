// MHasKV3TransferPolymorphicClassname
class C_OP_RemapVectortoCP : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber; // = -1
	// MPropertyFriendlyName = "input field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "particle number to read"
	int32 m_nParticleNumber;
};
