// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointOrientation : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "set orientation in world space"
	bool m_bUseWorldLocation;
	// MPropertyFriendlyName = "randomize"
	bool m_bRandomize;
	// MPropertyFriendlyName = "only set orientation once"
	bool m_bSetOnce;
	// MPropertyFriendlyName = "control point number"
	int32 m_nCP; // = 1
	// MPropertyFriendlyName = "control point to offset orientation from"
	int32 m_nHeadLocation;
	// MPropertyFriendlyName = "pitch yaw roll"
	QAngle m_vecRotation;
	// MPropertyFriendlyName = "pitch yaw roll max"
	QAngle m_vecRotationB;
	// MPropertyFriendlyName = "interpolation"
	CParticleCollectionFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
