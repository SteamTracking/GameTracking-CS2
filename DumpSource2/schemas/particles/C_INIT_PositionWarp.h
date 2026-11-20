// MHasKV3TransferPolymorphicClassname
class C_INIT_PositionWarp : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "warp min"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecWarpMin; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "warp max"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecWarpMax; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "warp scale control point number"
	int32 m_nScaleControlPointNumber; // = -1
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "radius scale component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nRadiusComponent; // = -1
	// MPropertyFriendlyName = "warp transition time (treats min/max as start/end sizes)"
	float32 m_flWarpTime;
	// MPropertyFriendlyName = "warp transition start time"
	float32 m_flWarpStartTime;
	// MPropertyFriendlyName = "previous position sacale"
	float32 m_flPrevPosScale; // = 1
	// MPropertyFriendlyName = "reverse warp (0/1)"
	bool m_bInvertWarp;
	// MPropertyFriendlyName = "use particle count instead of time"
	bool m_bUseCount;
};
