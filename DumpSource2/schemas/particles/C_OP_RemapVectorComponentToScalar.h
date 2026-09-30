// MHasKV3TransferPolymorphicClassname
class C_OP_RemapVectorComponentToScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "Input Vector"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "Output Scalar"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "Vector Component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nComponent;
};
