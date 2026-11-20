// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_AttractToControlPoint : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "component scale"
	// MVectorIsCoordinate
	Vector m_vecComponentScale; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "amount of force (or Max Force)"
	CPerParticleFloatInput m_fForceAmount; // = { "m_flLiteralValue": 100 }
	// MPropertyFriendlyName = "event horizon threshold distance for max force"
	CPerParticleFloatInput m_fMinimumDistance;
	// MPropertyFriendlyName = "falloff power"
	float32 m_fFalloffPower; // = 2
	// MPropertyFriendlyName = "input position transform"
	CParticleTransformInput m_TransformInput; // = { "m_bUseOrientation": false }
	// MPropertyFriendlyName = "Min Pullforce"
	CPerParticleFloatInput m_fForceAmountMin;
	// MPropertyFriendlyName = "Apply Min Pullforce"
	bool m_bApplyMinForce;
};
