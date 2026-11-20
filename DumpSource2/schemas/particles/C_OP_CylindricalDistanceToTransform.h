// MHasKV3TransferPolymorphicClassname
class C_OP_CylindricalDistanceToTransform : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "cylinder inner radius"
	CPerParticleFloatInput m_flInputMin;
	// MPropertyFriendlyName = "cylinder outer radius"
	CPerParticleFloatInput m_flInputMax; // = { "m_flLiteralValue": 64 }
	// MPropertyFriendlyName = "cylinder inner output"
	CPerParticleFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "cylinder outer output"
	CPerParticleFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "cylindrical top transform"
	CParticleTransformInput m_TransformStart;
	// MPropertyFriendlyName = "cylindrical bottom transform"
	CParticleTransformInput m_TransformEnd;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "only active within specified distance"
	bool m_bActiveRange;
	// MPropertyFriendlyName = "output is additive"
	bool m_bAdditive;
	// MPropertyFriendlyName = "apply radius to ends (capsule)"
	bool m_bCapsule;
};
