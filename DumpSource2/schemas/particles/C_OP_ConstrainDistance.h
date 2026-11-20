// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_ConstrainDistance : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "minimum distance"
	CParticleCollectionFloatInput m_fMinDistance;
	// MPropertyFriendlyName = "maximum distance"
	CParticleCollectionFloatInput m_fMaxDistance; // = { "m_flLiteralValue": 100 }
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_nControlPointNumber;
	// MPropertyFriendlyName = "offset of center"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_CenterOffset;
	// MPropertyFriendlyName = "global center point"
	bool m_bGlobalCenter;
};
