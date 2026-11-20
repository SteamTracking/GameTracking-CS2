// MHasKV3TransferPolymorphicClassname
class C_OP_SetChildControlPoints : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "group ID to affect"
	int32 m_nChildGroupID;
	// MPropertyFriendlyName = "first control point to set"
	int32 m_nFirstControlPoint;
	// MPropertyFriendlyName = "# of control points to set"
	int32 m_nNumControlPoints; // = 1
	// MPropertyFriendlyName = "first particle to copy"
	CParticleCollectionFloatInput m_nFirstSourcePoint;
	// MPropertyFriendlyName = "start as last particle"
	bool m_bReverse;
	// MPropertyFriendlyName = "set orientation"
	bool m_bSetOrientation;
	// MPropertyFriendlyName = "orientation set method"
	// MPropertySuppressExpr = "m_bSetOrientation == false"
	ParticleOrientationType_t m_nOrientation; // = "PARTICLE_ORIENTATION_VELOCITY"
};
