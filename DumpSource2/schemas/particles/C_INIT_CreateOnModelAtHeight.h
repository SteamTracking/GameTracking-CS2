// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateOnModelAtHeight : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "force creation height to desired height"
	bool m_bForceZ;
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "height override control point number"
	int32 m_nHeightCP; // = -1
	// MPropertyFriendlyName = "desired height is relative to water"
	bool m_bUseWaterHeight;
	// MPropertyFriendlyName = "relative desired height"
	CParticleCollectionFloatInput m_flDesiredHeight;
	// MPropertyFriendlyName = "model hitbox scale"
	CParticleCollectionVecInput m_vecHitBoxScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "direction bias"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecDirectionBias;
	// MPropertyFriendlyName = "bias type"
	ParticleHitboxBiasType_t m_nBiasType; // = "PARTICLE_HITBOX_BIAS_ENTITY"
	// MPropertyFriendlyName = "bias in local space"
	bool m_bLocalCoords;
	// MPropertyFriendlyName = "bias prefers moving hitboxes"
	bool m_bPreferMovingBoxes;
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "hitbox velocity inherited scale"
	CParticleCollectionFloatInput m_flHitboxVelocityScale;
	// MPropertyFriendlyName = "max hitbox velocity"
	CParticleCollectionFloatInput m_flMaxBoneVelocity;
};
