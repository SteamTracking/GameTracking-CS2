// MHasKV3TransferPolymorphicClassname
class C_OP_MovementLoopInsideSphere : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point"
	int32 m_nCP;
	// MPropertyFriendlyName = "distance maximum"
	CParticleCollectionFloatInput m_flDistance; // = { "m_flLiteralValue": 1024 }
	// MPropertyFriendlyName = "component scale"
	CParticleCollectionVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "distance squared output attribute"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nDistSqrAttr; // = 19
};
