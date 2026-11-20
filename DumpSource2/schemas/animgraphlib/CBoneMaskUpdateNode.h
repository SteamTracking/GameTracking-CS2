// MHasKV3TransferPolymorphicClassname
class CBoneMaskUpdateNode : public CBinaryUpdateNode
{
	int32 m_nWeightListIndex;
	float32 m_flRootMotionBlend;
	BoneMaskBlendSpace m_blendSpace; // = "BlendSpace_Parent"
	BinaryNodeChildOption m_footMotionTiming; // = "Child1"
	bool m_bUseBlendScale;
	AnimValueSource m_blendValueSource; // = "MoveHeading"
	CAnimParamHandle m_hBlendParameter;
};
