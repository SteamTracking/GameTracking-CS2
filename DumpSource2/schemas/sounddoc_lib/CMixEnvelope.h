// MPropertyFriendlyName = "VMix Envelope Audio Node"
// MPropertyDescription = "Generate a control signal that represents the envelope/level of an audio track.  Think of this as behaving like a meter but driving some graph logic."
// MHasKV3TransferPolymorphicClassname
class CMixEnvelope : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Attack time (ms)"
	float32 m_flAttackTime; // = 300
	// MPropertyFriendlyName = "Hold time (ms)"
	float32 m_flHoldTime; // = 500
	// MPropertyFriendlyName = "Release time (ms)"
	float32 m_flReleaseTime; // = 300
};
