// MHasKV3TransferPolymorphicClassname
class C_OP_ConstrainDistanceToUserSpecifiedPath : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "minimum distance"
	float32 m_fMinDistance;
	// MPropertyFriendlyName = "maximum distance"
	float32 m_flMaxDistance; // = 100
	// MPropertyFriendlyName = "Time scale"
	float32 m_flTimeScale; // = 1
	// MPropertyFriendlyName = "Treat path as a loop"
	bool m_bLoopedPath;
	// MPropertyFriendlyName = "path points"
	CUtlVector< PointDefinitionWithTimeValues_t > m_pointList;
};
