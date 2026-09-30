// MHasKV3TransferPolymorphicClassname
class C_OP_RenderFlattenGrass : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "flattening strength"
	float32 m_flFlattenStrength; // = 30
	// MPropertyFriendlyName = "strength field override"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nStrengthFieldOverride; // = 19
	// MPropertyFriendlyName = "radius scale"
	float32 m_flRadiusScale; // = 1
};
