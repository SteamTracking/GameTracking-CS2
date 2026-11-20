// MHasKV3TransferPolymorphicClassname
class C_INIT_DistanceCull : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "control point"
	int32 m_nControlPoint;
	// MPropertyFriendlyName = "cull distance"
	CParticleCollectionFloatInput m_flDistance;
	// MPropertyFriendlyName = "cull inside instead of outside"
	bool m_bCullInside;
};
