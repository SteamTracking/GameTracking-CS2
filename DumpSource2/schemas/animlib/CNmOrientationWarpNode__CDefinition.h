// MHasKV3TransferPolymorphicClassname
class CNmOrientationWarpNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nClipReferenceNodeIdx; // = -1
	int16 m_nTargetValueNodeIdx; // = -1
	bool m_bIsOffsetNode;
	bool m_bIsOffsetRelativeToCharacter; // = true
	bool m_bWarpTranslation;
	CNmOrientationWarpNode::AlignmentMode_t m_alignmentMode; // = "MovementDirection"
	CNmRootMotionData::SamplingMode_t m_samplingMode; // = "WorldSpace"
};
