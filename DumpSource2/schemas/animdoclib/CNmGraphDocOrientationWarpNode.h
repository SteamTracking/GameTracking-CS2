// MHasKV3TransferPolymorphicClassname
class CNmGraphDocOrientationWarpNode : public CNmGraphDocFlowNode
{
	CNmGraphDocOrientationWarpNode::OffsetType_t m_offsetType; // = "RelativeToCharacter"
	CNmRootMotionData::SamplingMode_t m_samplingMode; // = "WorldSpace"
	CNmOrientationWarpNode::AlignmentMode_t m_alignmentMode; // = "MovementDirection"
	// MPropertyGroupName = "Experimental"
	// MPropertyDescription = "Should the translation curve change as the orientation is being warped?"
	bool m_bWarpTranslation;
};
