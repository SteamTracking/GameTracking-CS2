// MHasKV3TransferPolymorphicClassname
class C_OP_PinParticleToCP : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "offset"
	CParticleCollectionVecInput m_vecOffset;
	// MPropertyFriendlyName = "offset in local space"
	bool m_bOffsetLocal; // = true
	// MPropertyFriendlyName = "particle to use"
	ParticleSelection_t m_nParticleSelection; // = "PARTICLE_SELECTION_FIRST"
	// MPropertyFriendlyName = "particle number/offset"
	CParticleCollectionFloatInput m_nParticleNumber;
	// MPropertyFriendlyName = "pin break type"
	ParticlePinDistance_t m_nPinBreakType; // = "PARTICLE_PIN_DISTANCE_NONE"
	// MPropertyFriendlyName = "break length %"
	CParticleCollectionFloatInput m_flBreakDistance; // = { "m_flLiteralValue": 1.75 }
	// MPropertyFriendlyName = "break speed"
	CParticleCollectionFloatInput m_flBreakSpeed;
	// MPropertyFriendlyName = "break age"
	CParticleCollectionFloatInput m_flAge;
	// MPropertyFriendlyName = "break comparison control point 1"
	int32 m_nBreakControlPointNumber; // = -1
	// MPropertyFriendlyName = "break comparison control point 2"
	int32 m_nBreakControlPointNumber2; // = -1
	// MPropertyFriendlyName = "break value"
	CParticleCollectionFloatInput m_flBreakValue;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Retain Initial Velocity "
	// MPropertySuppressExpr = "m_nParticleSelection != PARTICLE_SELECTION_LAST"
	bool m_bRetainInitialVelocity;
};
