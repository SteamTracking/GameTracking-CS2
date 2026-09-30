// MPropertyFriendlyName = "VMix Envelope Trigger Control Node"
// MPropertyDescription = "Used to create reverb effects based on a model of a reverb plate."
// MHasKV3TransferPolymorphicClassname
class CMixEnvelopeTrigger : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Base Value"
	float32 m_flBaseValue;
	// MPropertyFriendlyName = "Destination Value"
	float32 m_flDestinationValue; // = 1
	// MPropertyFriendlyName = "Attack Time (seconds)"
	float32 m_flAttackTime; // = 0.4
	// MPropertyFriendlyName = "Hold Time (seconds)"
	float32 m_flHoldTime; // = 0.2
	// MPropertyFriendlyName = "Release Time (seconds)"
	float32 m_flReleaseTime; // = 0.4
};
