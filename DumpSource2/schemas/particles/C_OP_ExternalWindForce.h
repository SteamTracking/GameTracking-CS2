// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_ExternalWindForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "sample position"
	CPerParticleVecInput m_vecSamplePosition; // = { "m_nType": "PVEC_TYPE_CP_VALUE" }
	// MPropertyFriendlyName = "force scale"
	CPerParticleVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "sample wind"
	bool m_bSampleWind; // = true
	// MPropertyFriendlyName = "sample water current"
	bool m_bSampleWater;
	// MPropertyFriendlyName = "dampen gravity/buoyancy near water plane"
	// MPropertySuppressExpr = "!m_bSampleWater"
	bool m_bDampenNearWaterPlane;
	// MPropertyFriendlyName = "sample local gravity"
	bool m_bSampleGravity;
	// MPropertyFriendlyName = "gravity force"
	// MPropertySuppressExpr = "m_bSampleGravity"
	CPerParticleVecInput m_vecGravityForce;
	// MPropertyFriendlyName = "use Movement Basic for Local Gravity & Buoyancy Scale"
	// MPropertySuppressExpr = "!m_bSampleGravity"
	bool m_bUseBasicMovementGravity;
	// MPropertyFriendlyName = "local gravity scale"
	// MPropertySuppressExpr = "!m_bSampleGravity"
	CPerParticleFloatInput m_flLocalGravityScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "local gravity buoyancy scale"
	// MPropertySuppressExpr = "!m_bSampleGravity"
	CPerParticleFloatInput m_flLocalBuoyancyScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "buoyancy force"
	// MPropertySuppressExpr = "!m_bSampleWater || m_bSampleGravity"
	CPerParticleVecInput m_vecBuoyancyForce;
};
