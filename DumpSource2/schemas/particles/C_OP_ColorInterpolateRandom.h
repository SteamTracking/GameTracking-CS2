// MHasKV3TransferPolymorphicClassname
class C_OP_ColorInterpolateRandom : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "color fade min"
	Color m_ColorFadeMin; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "color fade max"
	Color m_ColorFadeMax; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "fade start time"
	float32 m_flFadeStartTime;
	// MPropertyFriendlyName = "fade end time"
	float32 m_flFadeEndTime; // = 1
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 6
	// MPropertyFriendlyName = "ease in and out"
	bool m_bEaseInOut; // = true
};
