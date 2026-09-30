// MPropertyFriendlyName = "FootstepLanded Tag"
// MHasKV3TransferPolymorphicClassname
class CFootstepLandedAnimTag : public CAnimTagBase
{
	// MPropertyFriendlyName = "Footstep Type"
	FootstepLandedFootSoundType_t m_FootstepType; // = "FOOTSOUND_Left"
	// MPropertyFriendlyName = "Override Sound"
	// MPropertyAttributeChoiceName = "Sound"
	CUtlString m_OverrideSoundName;
	// MPropertyFriendlyName = "Debug Name"
	CUtlString m_DebugAnimSourceString;
	// MPropertyFriendlyName = "Bone Name"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_BoneName;
	// MPropertyFriendlyName = "Jump Phase"
	FootstepJumpPhase_t m_footstepJumpPhase; // = "Unknown"
};
