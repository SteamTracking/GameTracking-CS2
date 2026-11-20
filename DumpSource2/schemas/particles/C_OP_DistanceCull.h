// MHasKV3TransferPolymorphicClassname
class C_OP_DistanceCull : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point"
	int32 m_nControlPoint;
	// MPropertyFriendlyName = "control point offset"
	// MVectorIsCoordinate
	Vector m_vecPointOffset;
	// MPropertyFriendlyName = "cull distance"
	CParticleCollectionFloatInput m_flDistance;
	// MPropertyFriendlyName = "cull inside instead of outside"
	bool m_bCullInside;
	// MPropertyFriendlyName = "Attribute to Test"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nAttribute;
};
