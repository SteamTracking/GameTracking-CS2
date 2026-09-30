// MHasKV3TransferPolymorphicClassname
class C_OP_Diffusion : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "Radius scale for particle influence"
	float32 m_flRadiusScale; // = 2
	// MPropertyFriendlyName = "Output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 6
	// MPropertyFriendlyName = "Resolution to use for creating a voxel grid"
	int32 m_nVoxelGridResolution; // = 16
};
