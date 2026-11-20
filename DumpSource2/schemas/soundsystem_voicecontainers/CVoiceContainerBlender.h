// MPropertyFriendlyName = "Blender"
// MPropertyDescription = "Blends two containers."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerBlender : public CVoiceContainerBase
{
	CSoundContainerReference m_firstSound;
	CSoundContainerReference m_secondSound;
	float32 m_flBlendFactor;
};
