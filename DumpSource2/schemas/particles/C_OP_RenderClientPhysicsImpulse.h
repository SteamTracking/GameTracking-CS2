// MHasKV3TransferPolymorphicClassname
class C_OP_RenderClientPhysicsImpulse : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "radius"
	CPerParticleFloatInput m_flRadius; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "magnitude"
	CPerParticleFloatInput m_flMagnitude; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "filter explosion to single simulation id"
	int32 m_nSimIdFilter; // = -1
};
