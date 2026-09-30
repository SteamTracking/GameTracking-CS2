// MHasKV3TransferPolymorphicClassname
class C_OP_CalculateVectorAttribute : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "start value"
	Vector m_vStartValue;
	// MPropertyFriendlyName = "input field 1"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldInput1;
	// MPropertyFriendlyName = "input scale 1"
	float32 m_flInputScale1; // = 1
	// MPropertyFriendlyName = "input field 2"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldInput2;
	// MPropertyFriendlyName = "input scale 2"
	float32 m_flInputScale2;
	// MPropertyFriendlyName = "control point input 1"
	ControlPointReference_t m_nControlPointInput1;
	// MPropertyFriendlyName = "control point scale 1"
	float32 m_flControlPointScale1; // = -1
	// MPropertyFriendlyName = "control point input 2"
	ControlPointReference_t m_nControlPointInput2;
	// MPropertyFriendlyName = "control point scale 2"
	float32 m_flControlPointScale2;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 21
	// MPropertyFriendlyName = "final per component scale"
	Vector m_vFinalOutputScale; // = [ 1, 1, 1 ]
};
