// MPropertyFriendlyName = "LoopTriggerWithRandomPanner"
// MPropertyDescription = "Continuously retriggers a sound and optionally fades to the new instance. Sends a new Random panning value to a control input on each retrigger"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerLoopTriggerWithRandomPanner : public CVoiceContainerLoopTrigger
{
	// MPropertyFriendlyName = "Random Panner Control"
	CRandomPannerControls m_randomPannerControls;
};
