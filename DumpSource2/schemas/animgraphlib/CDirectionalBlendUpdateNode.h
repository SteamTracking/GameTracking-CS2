// MHasKV3TransferPolymorphicClassname
class CDirectionalBlendUpdateNode : public CLeafUpdateNode
{
	HSequence[8] m_hSequences; // = [ -1, -1, -1, -1, -1, -1, -1, -1 ]
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	AnimValueSource m_blendValueSource; // = "MoveHeading"
	CAnimParamHandle m_paramIndex; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	float32 m_playbackSpeed;
	float32 m_duration;
	bool m_bLoop;
	bool m_bLockBlendOnReset;
};
