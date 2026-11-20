// MHasKV3TransferPolymorphicClassname
class C_INIT_VelocityRadialRandom : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "per-particle center point"
	bool m_bPerParticleCenter;
	// MPropertyFriendlyName = "control point number"
	// MPropertySuppressExpr = "m_bPerParticleCenter == true"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "radial center point"
	// MPropertySuppressExpr = "m_bPerParticleCenter == false"
	CPerParticleVecInput m_vecPosition;
	// MPropertyFriendlyName = "radial center forward"
	// MPropertySuppressExpr = "m_bPerParticleCenter == false"
	CPerParticleVecInput m_vecFwd; // = { "m_vLiteralValue": [ 1, 0, 0 ] }
	// MPropertyFriendlyName = "random speed min"
	CPerParticleFloatInput m_fSpeedMin;
	// MPropertyFriendlyName = "random speed max"
	CPerParticleFloatInput m_fSpeedMax;
	// MPropertyFriendlyName = "local space scale"
	Vector m_vecLocalCoordinateSystemSpeedScale; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "ignore delta time"
	bool m_bIgnoreDelta;
};
