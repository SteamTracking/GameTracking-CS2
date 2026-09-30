// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDotProductToScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "first input control point"
	int32 m_nInputCP1;
	// MPropertyFriendlyName = "second input control point"
	int32 m_nInputCP2;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "input minimum (-1 to 1)"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input maximum (-1 to 1)"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "use particle velocity for first input"
	bool m_bUseParticleVelocity;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "only active within specified input range"
	bool m_bActiveRange;
	// MPropertyFriendlyName = "use particle normal for first input"
	bool m_bUseParticleNormal;
};
