// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDistanceToLineSegmentToVector : public C_OP_RemapDistanceToLineSegmentBase
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 7
	// MPropertyFriendlyName = "output value at min distance"
	Vector m_vMinOutputValue;
	// MPropertyFriendlyName = "output value at max distance"
	Vector m_vMaxOutputValue; // = [ 1, 1, 1 ]
};
