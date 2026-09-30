// MHasKV3TransferPolymorphicClassname
class CNmFollowBoneNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	CGlobalSymbol m_bone;
	CGlobalSymbol m_followTargetBone;
	int16 m_nEnabledNodeIdx; // = -1
	NmFollowBoneMode_t m_mode; // = "RotationAndTranslation"
};
