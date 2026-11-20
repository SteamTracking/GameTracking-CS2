// MHasKV3TransferPolymorphicClassname
class C_OP_SetSingleControlPointPosition : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "only set position once"
	bool m_bSetOnce;
	// MPropertyFriendlyName = "control point number"
	int32 m_nCP1; // = 1
	// MPropertyFriendlyName = "control point location"
	CParticleCollectionVecInput m_vecCP1Pos; // = { "m_vLiteralValue": [ 128, 0, 0 ] }
	// MPropertyFriendlyName = "transform to offset positions from"
	// MParticleInputOptional
	CParticleTransformInput m_transformInput;
};
