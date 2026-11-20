// MHasKV3TransferPolymorphicClassname
class C_INIT_DistanceToNeighborCull : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "cull distance"
	CPerParticleFloatInput m_flDistance;
	// MPropertyFriendlyName = "include particle radius"
	bool m_bIncludeRadii;
	// MPropertyFriendlyName = "lifespan overlap percentage"
	CPerParticleFloatInput m_flLifespanOverlap;
	// MPropertyFriendlyName = "attribute to modify"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldModify; // = 19
	// MPropertyFriendlyName = "modify amount"
	// MPropertySuppressExpr = "m_nFieldOutput == PARTICLE_ATTRIBUTE_UNUSED"
	CPerParticleFloatInput m_flModify;
	// MPropertyFriendlyName = "set value method"
	// MPropertySuppressExpr = "m_nFieldOutput == PARTICLE_ATTRIBUTE_UNUSED"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "use neighbor value for modify base"
	// MPropertySuppressExpr = "m_nFieldOutput == PARTICLE_ATTRIBUTE_UNUSED"
	bool m_bUseNeighbor;
};
