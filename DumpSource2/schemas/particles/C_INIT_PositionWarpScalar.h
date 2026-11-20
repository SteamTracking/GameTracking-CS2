// MHasKV3TransferPolymorphicClassname
class C_INIT_PositionWarpScalar : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "warp min"
	// MVectorIsCoordinate
	Vector m_vecWarpMin; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "warp max"
	// MVectorIsCoordinate
	Vector m_vecWarpMax; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "warp amount"
	CPerParticleFloatInput m_InputValue;
	// MPropertyFriendlyName = "previous position scale"
	float32 m_flPrevPosScale; // = 1
	// MPropertyFriendlyName = "warp scale control point number"
	int32 m_nScaleControlPointNumber; // = -1
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
};
