// MHasKV3TransferPolymorphicClassname
class C_OP_RenderTreeShake : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "peak strength"
	float32 m_flPeakStrength; // = 9
	// MPropertyFriendlyName = "peak strength field override"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nPeakStrengthFieldOverride; // = 19
	// MPropertyFriendlyName = "radius"
	float32 m_flRadius; // = 256
	// MPropertyFriendlyName = "strength field override"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nRadiusFieldOverride; // = 19
	// MPropertyFriendlyName = "shake duration after end"
	float32 m_flShakeDuration; // = 3
	// MPropertyFriendlyName = "amount of time taken to smooth between different shake parameters"
	float32 m_flTransitionTime; // = 0.5
	// MPropertyFriendlyName = "Twist amount (-1..1)"
	float32 m_flTwistAmount;
	// MPropertyFriendlyName = "Radial Amount (-1..1)"
	float32 m_flRadialAmount; // = 1
	// MPropertyFriendlyName = "Control Point Orientation Amount (-1..1)"
	float32 m_flControlPointOrientationAmount;
	// MPropertyFriendlyName = "Control Point for Orientation Amount"
	int32 m_nControlPointForLinearDirection; // = -1
};
