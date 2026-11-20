// MHasKV3TransferPolymorphicClassname
class C_OP_ColorAdjustHSL : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "hue adjust"
	CPerParticleFloatInput m_flHueAdjust;
	// MPropertyFriendlyName = "saturation adjust"
	CPerParticleFloatInput m_flSaturationAdjust;
	// MPropertyFriendlyName = "lightness adjust"
	CPerParticleFloatInput m_flLightnessAdjust;
};
