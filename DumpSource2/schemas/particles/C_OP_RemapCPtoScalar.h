// MHasKV3TransferPolymorphicClassname
class C_OP_RemapCPtoScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "input control point number"
	int32 m_nCPInput;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "input field 0-2 X/Y/Z"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nField;
	// MPropertyFriendlyName = "input minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "emitter lifetime start time (seconds)"
	float32 m_flStartTime; // = -1
	// MPropertyFriendlyName = "emitter lifetime end time (seconds)"
	float32 m_flEndTime; // = -1
	// MPropertyFriendlyName = "interpolation scale"
	float32 m_flInterpRate;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
