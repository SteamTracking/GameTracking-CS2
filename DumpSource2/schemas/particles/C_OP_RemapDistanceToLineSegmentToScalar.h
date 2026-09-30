// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDistanceToLineSegmentToScalar : public C_OP_RemapDistanceToLineSegmentBase
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 7
	// MPropertyFriendlyName = "output value at min distance"
	float32 m_flMinOutputValue;
	// MPropertyFriendlyName = "output value at max distance"
	float32 m_flMaxOutputValue; // = 1
};
