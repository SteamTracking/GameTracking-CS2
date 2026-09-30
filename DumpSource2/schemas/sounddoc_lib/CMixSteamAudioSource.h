// MPropertyFriendlyName = "VMix Steam Audio Source Node"
// MPropertyDescription = "Applies steam audio model for a 3d audio source.  This includes panning and HRTF (head-related transfer function)."
// MHasKV3TransferPolymorphicClassname
class CMixSteamAudioSource : public CMixPropertyBase
{
	// MPropertyFriendlyName = "HRTF Interpolation"
	SteamAudioHRTFInterpolationType_t m_nInterpolation; // = "SA_HRTFINTEROP_BILINEAR"
	// MPropertyFriendlyName = "Direct Mix Level"
	// MPropertyAttributeRange = "0 1"
	float32 m_flDirectMixLevel; // = 1
	// MPropertyFriendlyName = "Enable Perspective Correction"
	// MPropertyDescription = "If checked, enables perspective correction for spatialized sound sources. When perspective correction is enabled, instead of spatializing sounds from their world - space position relative to the listener, sounds are spatialized from their on - screen position relative to the user. This can improve perceived localization accuracy in 3D non - VR applications."
	bool m_bEnablePerspectiveCorrection;
	// MPropertyFriendlyName = "Relative Input Position"
	// MPropertyDescription = "<b>Check</b> this if the input position is relative to the listener.<br /> <b>Don't check</b> this if the input position is aboslute world space coordinates."
	bool m_bRelativePosition;
};
