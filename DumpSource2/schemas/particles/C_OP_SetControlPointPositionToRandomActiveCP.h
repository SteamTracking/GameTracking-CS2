// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointPositionToRandomActiveCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nCP1; // = 1
	// MPropertyFriendlyName = "min active CP"
	int32 m_nHeadLocationMin;
	// MPropertyFriendlyName = "max active CP"
	int32 m_nHeadLocationMax;
	// MPropertyFriendlyName = "reset rate"
	CParticleCollectionFloatInput m_flResetRate;
};
