// MHasKV3TransferPolymorphicClassname
class C_OP_GameLiquidSpill : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "Liquid Contents ( negative for water, positive for oil, zero for noop )"
	CParticleCollectionFloatInput m_flLiquidContentsField; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "Expiration Time (seconds)"
	CParticleCollectionFloatInput m_flExpirationTime; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "Radius"
	CParticleCollectionFloatInput m_flRadius; // = { "m_flLiteralValue": 0.1 }
	// MPropertyFriendlyName = "Radially splashed points require exposure to sky"
	bool m_bCheckExposedToSky;
	// MPropertyFriendlyName = "Attribute for Contribution Amount"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nAmountAttribute; // = 3
};
