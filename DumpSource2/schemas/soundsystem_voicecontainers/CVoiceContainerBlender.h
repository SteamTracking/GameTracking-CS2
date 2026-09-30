// MPropertyFriendlyName = "Blender"
// MPropertyDescription = "Blends two containers."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerBlender : public CVoiceContainerBase
{
	CSoundContainerReference m_firstSound; // = { "m_bUseReference": true, "m_namespace": "", "m_pSound": null, "m_sound": "" }
	CSoundContainerReference m_secondSound; // = { "m_bUseReference": true, "m_namespace": "", "m_pSound": null, "m_sound": "" }
	float32 m_flBlendFactor;
};
