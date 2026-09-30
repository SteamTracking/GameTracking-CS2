// MPropertyFriendlyName = "VMix Freeverb Audio Node"
// MPropertyDescription = "Used to create reverb effects based on a symmetrical room."
// MHasKV3TransferPolymorphicClassname
class CMixFreeverb : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Size"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flRoomSize; // = 0.5
	// MPropertyFriendlyName = "Dampening Factor"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flDamp; // = 0.5
	// MPropertyFriendlyName = "Width"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flWidth; // = 0.5
	// MPropertyFriendlyName = "Late Reflections"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flLateReflections; // = 1
};
