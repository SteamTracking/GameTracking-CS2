// MHasKV3TransferPolymorphicClassname
class C_OP_RemapAverageHitboxSpeedtoCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "input control point"
	int32 m_nInControlPointNumber;
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber; // = -1
	// MPropertyFriendlyName = "Output component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nField;
	// MPropertyFriendlyName = "hitbox data"
	ParticleHitboxDataSelection_t m_nHitboxDataType; // = "PARTICLE_HITBOX_AVERAGE_SPEED"
	// MPropertyFriendlyName = "input minimum"
	CParticleCollectionFloatInput m_flInputMin;
	// MPropertyFriendlyName = "input maximum"
	CParticleCollectionFloatInput m_flInputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "output minimum"
	CParticleCollectionFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CParticleCollectionFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "intersection height CP"
	// MPropertySuppressExpr = "m_nHitboxDataType != PARTICLE_HITBOX_AVERAGE_SPEED"
	int32 m_nHeightControlPointNumber; // = -1
	// MPropertyFriendlyName = "comparison velocity"
	// MPropertySuppressExpr = "m_nHitboxDataType != PARTICLE_HITBOX_AVERAGE_SPEED"
	CParticleCollectionVecInput m_vecComparisonVelocity;
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
};
