// MHasKV3TransferPolymorphicClassname
class C_INIT_SetHitboxToClosest : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "desired hitbox"
	int32 m_nDesiredHitbox; // = -1
	// MPropertyFriendlyName = "model hitbox scale"
	CParticleCollectionVecInput m_vecHitBoxScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "get closest point on closest hitbox"
	bool m_bUseClosestPointOnHitbox;
	// MPropertyFriendlyName = "closest point test type"
	ClosestPointTestType_t m_nTestType; // = "PARTICLE_CLOSEST_TYPE_BOX"
	// MPropertyFriendlyName = "hybrid ratio"
	CParticleCollectionFloatInput m_flHybridRatio; // = { "m_flLiteralValue": 0.5 }
	// MPropertyFriendlyName = "set initial position"
	bool m_bUpdatePosition;
};
