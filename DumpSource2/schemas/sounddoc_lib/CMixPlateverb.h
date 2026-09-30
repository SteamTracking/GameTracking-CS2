// MPropertyFriendlyName = "VMix Plateverb Audio Node"
// MPropertyDescription = "Used to create reverb effects based on a model of a reverb plate."
// MHasKV3TransferPolymorphicClassname
class CMixPlateverb : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Prefilter"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flPrefilter; // = 0.5
	// MPropertyFriendlyName = "Input Diffusion 1"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flInputDiffusion1; // = 0.5
	// MPropertyFriendlyName = "Input Diffusion 2"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flInputDiffusion2; // = 0.5
	// MPropertyFriendlyName = "Decay"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flDecay; // = 0.5
	// MPropertyFriendlyName = "Dampening Factor"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flDamp; // = 0.5
	// MPropertyFriendlyName = "Feedback Diffusion 1"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flFeedbackDiffusion1; // = 0.5
	// MPropertyFriendlyName = "Feedback Diffusion 1"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flFeedbackDiffusion2; // = 0.5
};
