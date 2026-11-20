// MHasKV3TransferPolymorphicClassname
class CDirectionalBlendUpdateNode : public CLeafUpdateNode
{
	HSequence[8] m_hSequences; // = [ -1, -1, -1, -1, -1, -1, -1, -1 ]
	CAnimInputDamping m_damping;
	AnimValueSource m_blendValueSource; // = "MoveHeading"
	CAnimParamHandle m_paramIndex;
	float32 m_playbackSpeed;
	float32 m_duration;
	bool m_bLoop;
	bool m_bLockBlendOnReset;
};
