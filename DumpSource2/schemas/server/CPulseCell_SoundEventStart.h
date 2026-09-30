// MPropertyFriendlyName = "Start Sound Event"
// MPropertyDescription = "Starts a sound event, returns a handle that can be used to stop it. Keywords: create, sound, event, audio"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_SoundEventStart : public CPulseCell_BaseFlow
{
	SoundEventStartType_t m_Type; // = "SOUNDEVENT_START_PLAYER"
};
