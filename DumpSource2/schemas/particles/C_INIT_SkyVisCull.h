// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_SkyVisCull : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "test direction"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecTestDir; // = { "m_vLiteralValue": [ 0, 0, 1 ] }
	// MPropertyFriendlyName = "Trace Set"
	// MPropertySuppressExpr = "!is_gpu_particle_system"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_STATIC"
	// MPropertyFriendlyName = "cull on sky"
	bool m_bCullOnSky;
};
