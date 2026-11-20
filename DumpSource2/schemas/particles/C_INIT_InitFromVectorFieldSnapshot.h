// MHasKV3TransferPolymorphicClassname
class C_INIT_InitFromVectorFieldSnapshot : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "local space control point number"
	int32 m_nLocalSpaceCP;
	// MPropertyFriendlyName = "weight update control point"
	int32 m_nWeightUpdateCP; // = 2
	// MPropertyFriendlyName = "use vertical velocity for weighting"
	bool m_bUseVerticalVelocity;
	// MPropertyFriendlyName = "Component Scale"
	CPerParticleVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
};
