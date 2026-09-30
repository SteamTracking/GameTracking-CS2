// MPropertyFriendlyName = "LoopTriggerWithRandomPanner"
// MPropertyDescription = "Continuously retriggers a sound and optionally fades to the new instance. Sends a new Random panning value to a control input on each retrigger"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerLoopTriggerWithRandomPanner : public CVoiceContainerLoopTrigger
{
	// MPropertyFriendlyName = "Random Panner Control"
	CRandomPannerControls m_randomPannerControls; // = { "m_flMaxVolume": 0, "m_flMinVolume": -12, "m_panningControlInputName": "random_pan", "m_strVectorStackParam": "ListenerForwardVector", "m_volumeControlInputName": "random_volume" }
};
