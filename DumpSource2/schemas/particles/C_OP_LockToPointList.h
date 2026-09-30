// MHasKV3TransferPolymorphicClassname
class C_OP_LockToPointList : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "point list"
	CUtlVector< PointDefinition_t > m_pointList;
	// MPropertyFriendlyName = "space points along path"
	bool m_bPlaceAlongPath;
	// MPropertyFriendlyName = "Treat path as a loop"
	bool m_bClosedLoop;
	// MPropertyFriendlyName = "Numer of points along path"
	int32 m_nNumPointsAlongPath; // = 20
};
