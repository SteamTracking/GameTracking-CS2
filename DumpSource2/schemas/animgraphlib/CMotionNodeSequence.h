// MHasKV3TransferPolymorphicClassname
class CMotionNodeSequence : public CMotionNode
{
	CUtlVector< TagSpan_t > m_tags;
	HSequence m_hSequence; // = -1
	float32 m_flPlaybackSpeed; // = 1
};
