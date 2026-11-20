// MHasKV3TransferPolymorphicClassname
class C_INIT_SetHitboxToModel : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "force to be inside model"
	int32 m_nForceInModel;
	// MPropertyFriendlyName = "even distribution"
	bool m_bEvenDistribution;
	// MPropertyFriendlyName = "desired hitbox"
	int32 m_nDesiredHitbox; // = -1
	// MPropertyFriendlyName = "model hitbox scale"
	CParticleCollectionVecInput m_vecHitBoxScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "direction bias"
	// MVectorIsCoordinate
	Vector m_vecDirectionBias;
	// MPropertyFriendlyName = "maintain existing hitbox"
	bool m_bMaintainHitbox;
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "hitbox shell thickness"
	CParticleCollectionFloatInput m_flShellSize; // = { "m_flLiteralValue": 1 }
};
