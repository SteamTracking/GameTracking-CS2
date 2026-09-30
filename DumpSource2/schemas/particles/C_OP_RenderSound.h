// MHasKV3TransferPolymorphicClassname
class C_OP_RenderSound : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "duration scale"
	float32 m_flDurationScale; // = 1
	// MPropertyFriendlyName = "decibel level scale"
	float32 m_flSndLvlScale; // = 75
	// MPropertyFriendlyName = "pitch scale"
	float32 m_flPitchScale; // = 100
	// MPropertyFriendlyName = "volume scale"
	float32 m_flVolumeScale; // = 1
	// MPropertyFriendlyName = "decibel level field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nSndLvlField; // = 19
	// MPropertyFriendlyName = "duration field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nDurationField; // = 1
	// MPropertyFriendlyName = "pitch field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nPitchField; // = 16
	// MPropertyFriendlyName = "volume field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nVolumeField; // = 7
	// MPropertyFriendlyName = "sound channel"
	// MPropertyAttributeChoiceName = "sound_channel"
	int32 m_nChannel;
	// MPropertyFriendlyName = "sound control point number"
	int32 m_nCPReference; // = -1
	// MPropertyFriendlyName = "sound"
	// MPropertyAttributeEditor = "SoundPicker()"
	char[256] m_pszSoundName;
	// MPropertyFriendlyName = "suppress stop event"
	bool m_bSuppressStopSoundEvent;
};
