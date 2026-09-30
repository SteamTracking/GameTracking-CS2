// MPropertyFriendlyName = "Container Switch"
// MPropertyDescription = "An array of containers"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerSwitch : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Container List"
	CUtlVector< CSoundContainerReference > m_soundsToPlay;
};
