// MPropertyFriendlyName = "VMix Source Audio Node"
// MPropertyDescription = "Plays a vsnd container."
// MHasKV3TransferPolymorphicClassname
class CMixAudioSource : public CMixPropertyBase
{
	KeyValues3 m_kvContainer; // = { "_class": "CVoiceContainerLoopTrigger", "m_bCrossFade": false, "m_flFadeTime": 0.75, "m_flRetriggerTimeMax": 3, "m_flRetriggerTimeMin": 1, "m_sound": { "m_bUseReference": true, "m_sound": "sounds/_devonly/weapons/ak47/ak47_mech_04.vsnd" } }
};
