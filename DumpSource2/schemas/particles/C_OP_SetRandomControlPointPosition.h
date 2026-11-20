// MHasKV3TransferPolymorphicClassname
class C_OP_SetRandomControlPointPosition : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "set positions in world space"
	bool m_bUseWorldLocation;
	// MPropertyFriendlyName = "inherit CP orientation"
	bool m_bOrient;
	// MPropertyFriendlyName = "control point number"
	int32 m_nCP1; // = 1
	// MPropertyFriendlyName = "control point to offset positions from"
	int32 m_nHeadLocation;
	// MPropertyFriendlyName = "re-randomize rate (-1 for once only)"
	CParticleCollectionFloatInput m_flReRandomRate; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "control point min"
	Vector m_vecCPMinPos;
	// MPropertyFriendlyName = "control point max"
	Vector m_vecCPMaxPos;
	// MPropertyFriendlyName = "Interpolation"
	CParticleCollectionFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
