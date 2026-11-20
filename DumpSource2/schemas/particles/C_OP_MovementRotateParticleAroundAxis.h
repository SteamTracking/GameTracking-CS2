// MHasKV3TransferPolymorphicClassname
class C_OP_MovementRotateParticleAroundAxis : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "rotation axis"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecRotAxis; // = { "m_vLiteralValue": [ 0, 0, 1 ] }
	// MPropertyFriendlyName = "rotation rate"
	CParticleCollectionFloatInput m_flRotRate; // = { "m_flLiteralValue": 180 }
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "use local space"
	bool m_bLocalSpace;
};
