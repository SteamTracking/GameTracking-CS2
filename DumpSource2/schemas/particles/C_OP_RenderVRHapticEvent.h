// MHasKV3TransferPolymorphicClassname
class C_OP_RenderVRHapticEvent : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "haptic hand"
	ParticleVRHandChoiceList_t m_nHand; // = "PARTICLE_VRHAND_LEFT"
	// MPropertyFriendlyName = "hand control point number"
	int32 m_nOutputHandCP; // = -1
	// MPropertyFriendlyName = "cp field"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutputField;
	// MPropertyFriendlyName = "amplitude"
	CPerParticleFloatInput m_flAmplitude; // = { "m_flLiteralValue": 1 }
};
