// MHasKV3TransferPolymorphicClassname
class C_OP_RemapControlPointOrientationToRotation : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point"
	int32 m_nCP;
	// MPropertyFriendlyName = "rotation field"
	// MPropertyAttributeChoiceName = "particlefield_rotation"
	ParticleAttributeIndex_t m_nFieldOutput; // = 4
	// MPropertyFriendlyName = "offset rotation"
	float32 m_flOffsetRot;
	// MPropertyFriendlyName = "control point axis"
	// MPropertyAttributeChoiceName = "vector_component"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	int32 m_nComponent; // = 1
};
