class CParticleMassCalculationParameters
{
	// MPropertyFriendlyName = "Radius calculation mode"
	ParticleMassMode_t m_nMassMode; // = "PARTICLE_MASSMODE_RADIUS_CUBED"
	// MPropertyFriendlyName = "Radius input"
	CPerParticleFloatInput m_flRadius; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Nominal radius value"
	CPerParticleFloatInput m_flNominalRadius; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Scale to apply to result"
	CPerParticleFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
};
