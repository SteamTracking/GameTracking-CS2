// MPropertyFriendlyName = "VMix Steam Audio Pathing Node"
// MPropertyDescription = "Applies steam audio model for pathing audio through space.  This pans the audio based on the openings that the audio is audible through by traversing a path through space from the source to the listener."
// MHasKV3TransferPolymorphicClassname
class CMixSteamAudioPathing : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Pathing Mix Level"
	// MPropertyAttributeRange = "0 1"
	float32 m_flPathingMixLevel; // = 1
	// MPropertyFriendlyName = "Pathing EQ"
	// MPropertyAttributeRange = "0 1"
	float32[3] m_vPathingEQ; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "Pathing Coefficients"
	// MPropertyAttributeRange = "-1 1"
	CUtlVector< float32 > m_vPathingCoeffs;
	// MPropertyFriendlyName = "Pathing EQ (N-band)"
	// MPropertyAttributeRange = "0.0 1.0"
	CUtlVector< float32 > m_vecPathingEQ;
};
