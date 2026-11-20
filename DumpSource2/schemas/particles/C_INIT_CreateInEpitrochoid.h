// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateInEpitrochoid : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "first dimension 0-2 (-1 disables)"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nComponent1;
	// MPropertyFriendlyName = "second dimension 0-2 (-1 disables)"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nComponent2; // = 1
	// MPropertyFriendlyName = "input transform"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "particle density"
	CPerParticleFloatInput m_flParticleDensity; // = { "m_flLiteralValue": 10 }
	// MPropertyFriendlyName = "point offset"
	CPerParticleFloatInput m_flOffset; // = { "m_flLiteralValue": 4 }
	// MPropertyFriendlyName = "radius 1"
	CPerParticleFloatInput m_flRadius1; // = { "m_flLiteralValue": 40 }
	// MPropertyFriendlyName = "radius 2"
	CPerParticleFloatInput m_flRadius2; // = { "m_flLiteralValue": 24 }
	// MPropertyFriendlyName = "use particle count instead of creation time"
	bool m_bUseCount;
	// MPropertyFriendlyName = "local space"
	bool m_bUseLocalCoords;
	// MPropertyFriendlyName = "offset from existing position"
	bool m_bOffsetExistingPos;
};
