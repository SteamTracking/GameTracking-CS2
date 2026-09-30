// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDirectionToCPToVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point"
	int32 m_nCP;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "scale factor"
	float32 m_flScale; // = 1
	// MPropertyFriendlyName = "offset rotation"
	float32 m_flOffsetRot;
	// MPropertyFriendlyName = "offset axis"
	// MVectorIsCoordinate
	Vector m_vecOffsetAxis;
	// MPropertyFriendlyName = "normalize"
	bool m_bNormalize;
	// MPropertyFriendlyName = "strength field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldStrength; // = 19
};
