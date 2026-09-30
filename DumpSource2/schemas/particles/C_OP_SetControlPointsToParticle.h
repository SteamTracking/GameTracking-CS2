// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointsToParticle : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "group ID to affect"
	int32 m_nChildGroupID;
	// MPropertyFriendlyName = "first control point to set"
	int32 m_nFirstControlPoint;
	// MPropertyFriendlyName = "# of control points to set"
	int32 m_nNumControlPoints; // = 1
	// MPropertyFriendlyName = "first particle to copy"
	int32 m_nFirstSourcePoint;
	// MPropertyFriendlyName = "reverse order"
	bool m_bReverse;
	// MPropertyFriendlyName = "set orientation"
	bool m_bSetOrientation;
	// MPropertyFriendlyName = "orientation style"
	ParticleOrientationSetMode_t m_nOrientationMode; // = "PARTICLE_ORIENTATION_SET_FROM_VELOCITY"
	// MPropertyFriendlyName = "set parent"
	ParticleParentSetMode_t m_nSetParent; // = "PARTICLE_SET_PARENT_NO"
};
