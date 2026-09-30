// MPropertyFriendlyName = "Container Set"
// MPropertyDescription = "An array of containers that are played all at once."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerSet : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Container List"
	CUtlVector< CVoiceContainerSetElement > m_soundsToPlay;
};
