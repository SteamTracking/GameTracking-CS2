// MHasKV3TransferPolymorphicClassname
class C_OP_LerpToInitialPosition : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "position cache attribute"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nCacheField; // = 15
	// MPropertyFriendlyName = "scale"
	CParticleCollectionFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "component scale"
	CParticleCollectionVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
};
