// MHasKV3TransferPolymorphicClassname
class C_OP_RemapParticleCountToScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "input minimum"
	CParticleCollectionFloatInput m_nInputMin;
	// MPropertyFriendlyName = "input maximum"
	CParticleCollectionFloatInput m_nInputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "output minimum"
	CParticleCollectionFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CParticleCollectionFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = ""
	bool m_bActiveRange;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
