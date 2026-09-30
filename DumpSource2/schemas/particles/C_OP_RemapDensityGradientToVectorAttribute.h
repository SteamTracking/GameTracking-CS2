// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDensityGradientToVectorAttribute : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "Radius scale for particle influence"
	float32 m_flRadiusScale; // = 1
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 21
};
