// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointRotation : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "rotation axis"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecRotAxis; // = { "m_vLiteralValue": [ 0, 0, 1 ] }
	// MPropertyFriendlyName = "rotation rate"
	CParticleCollectionFloatInput m_flRotRate; // = { "m_flLiteralValue": 180 }
	// MPropertyFriendlyName = "control point"
	int32 m_nCP;
	// MPropertyFriendlyName = "local space control point"
	int32 m_nLocalCP; // = -1
};
