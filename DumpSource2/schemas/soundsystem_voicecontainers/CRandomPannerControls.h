// MPropertyFriendlyName = "Random Panner Control"
// MPropertyDescription = "Sets a control input every time it's instantiated"
class CRandomPannerControls
{
	// MPropertyFriendlyName = "Panning Control Input Name"
	CUtlString m_panningControlInputName; // = "random_pan"
	// MPropertyFriendlyName = "Volume Control Input Name"
	CUtlString m_volumeControlInputName; // = "random_volume"
	// MPropertyFriendlyName = "Minimum Random Volume DB"
	float32 m_flMinVolume; // = -12
	// MPropertyFriendlyName = "Maximum Random Volume DB"
	float32 m_flMaxVolume;
	// MPropertyFriendlyName = "Forward Vector Stack Parameter Name"
	CUtlString m_strVectorStackParam; // = "ListenerForwardVector"
};
