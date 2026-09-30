// MPropertyFriendlyName = "LoopTrigger"
// MPropertyDescription = "Continuously retriggers a sound and optionally fades to the new instance."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerLoopTrigger : public CVoiceContainerBase
{
	float32 m_flRetriggerTimeMin; // = 1
	float32 m_flRetriggerTimeMax; // = 1
	float32 m_flFadeTime; // = 0.5
	bool m_bCrossFade;
	// MPropertyFriendlyName = "Vsnd Reference"
	CSoundContainerReference m_sound; // = { "m_bUseReference": true, "m_namespace": "", "m_pSound": null, "m_sound": "" }
};
