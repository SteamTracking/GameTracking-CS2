// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_PlaneCull : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "control point of plane"
	int32 m_nControlPoint;
	// MPropertyFriendlyName = "cull offset"
	CParticleCollectionFloatInput m_flDistance;
	// MPropertyFriendlyName = "flip cull normal"
	bool m_bCullInside;
};
