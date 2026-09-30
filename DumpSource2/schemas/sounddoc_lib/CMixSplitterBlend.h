// MPropertyFriendlyName = "VMix Splitter Blend Audio Node"
// MPropertyDescription = "Blends a single track to multiple outputs based on a single control input.  This works similarly to the blend node, but in reverse.  It will always be blending to a contiguous set of outputs.  The control value will move the signal along the list of outputs."
// MHasKV3TransferPolymorphicClassname
class CMixSplitterBlend : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Lock to output (0-1)"
	float32 m_flLockAmount;
};
