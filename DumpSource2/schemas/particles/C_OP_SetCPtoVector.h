// MHasKV3TransferPolymorphicClassname
class C_OP_SetCPtoVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "input control point number"
	int32 m_nCPInput;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
};
