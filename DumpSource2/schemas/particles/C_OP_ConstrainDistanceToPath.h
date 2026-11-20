// MHasKV3TransferPolymorphicClassname
class C_OP_ConstrainDistanceToPath : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "minimum distance"
	float32 m_fMinDistance;
	// MPropertyFriendlyName = "maximum distance"
	float32 m_flMaxDistance0; // = 100
	// MPropertyFriendlyName = "maximum distance middle"
	float32 m_flMaxDistanceMid; // = -1
	// MPropertyFriendlyName = "maximum distance end"
	float32 m_flMaxDistance1; // = -1
	CPathParameters m_PathParameters;
	// MPropertyFriendlyName = "travel time"
	float32 m_flTravelTime; // = 10
	// MPropertyFriendlyName = "travel time scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldScale; // = 19
	// MPropertyFriendlyName = "manual time placement field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nManualTField; // = 19
};
