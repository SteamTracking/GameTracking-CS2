// MHasKV3TransferPolymorphicClassname
class C_INIT_MoveBetweenPoints : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "minimum speed"
	CPerParticleFloatInput m_flSpeedMin; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "maximum speed"
	CPerParticleFloatInput m_flSpeedMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "end spread"
	CPerParticleFloatInput m_flEndSpread;
	// MPropertyFriendlyName = "start offset"
	CPerParticleFloatInput m_flStartOffset;
	// MPropertyFriendlyName = "end offset"
	CPerParticleFloatInput m_flEndOffset;
	// MPropertyFriendlyName = "end control point"
	int32 m_nEndControlPointNumber; // = 1
	// MPropertyFriendlyName = "bias lifetime by trail length"
	bool m_bTrailBias;
};
