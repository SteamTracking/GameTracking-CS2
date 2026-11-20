// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_InitialVelocityNoise : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "absolute value"
	// MVectorIsCoordinate
	Vector m_vecAbsVal;
	// MPropertyFriendlyName = "invert abs value"
	// MVectorIsCoordinate
	Vector m_vecAbsValInv;
	// MPropertyFriendlyName = "spatial coordinate offset"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecOffsetLoc;
	// MPropertyFriendlyName = "time coordinate offset"
	CPerParticleFloatInput m_flOffset;
	// MPropertyFriendlyName = "output minimum"
	CPerParticleVecInput m_vecOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CPerParticleVecInput m_vecOutputMax; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "time noise coordinate scale"
	CPerParticleFloatInput m_flNoiseScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "spatial noise coordinate scale"
	CPerParticleFloatInput m_flNoiseScaleLoc; // = { "m_flLiteralValue": 0.01 }
	// MPropertyFriendlyName = "input local space velocity (optional)"
	// MParticleInputOptional
	CParticleTransformInput m_TransformInput; // = { "m_nType": "PT_TYPE_INVALID" }
	// MPropertyFriendlyName = "ignore delta time"
	bool m_bIgnoreDt;
};
