// MHasKV3TransferPolymorphicClassname
class CNmTargetWarpNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nClipReferenceNodeIdx; // = -1
	int16 m_nTargetValueNodeIdx; // = -1
	CNmRootMotionData::SamplingMode_t m_samplingMode; // = "Delta"
	CNmTargetWarpNode::TargetUpdateRule_t m_targetUpdateRule; // = "None"
	bool m_bAlignWithTargetAtLastWarpEvent;
	float32 m_flSamplingPositionErrorThresholdSq;
	float32 m_flMaxTangentLength; // = 1.25
	float32 m_flLerpFallbackDistanceThreshold; // = 0.1
	float32 m_flTargetUpdateDistanceThreshold; // = 0.1
	float32 m_flTargetUpdateAngleThresholdRadians; // = 0.087266
	CGlobalSymbol m_alignmentBoneID;
};
