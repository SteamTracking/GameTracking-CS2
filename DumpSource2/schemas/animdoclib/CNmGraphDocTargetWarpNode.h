// MHasKV3TransferPolymorphicClassname
class CNmGraphDocTargetWarpNode : public CNmGraphDocVariationDataNode
{
	CNmTargetWarpNode::TargetUpdateRule_t m_targetUpdateRule; // = "None"
	// MPropertySuppressField
	bool m_bAllowTargetUpdate;
	bool m_bAlignWithTargetAtLastWarpEvent;
	CNmRootMotionData::SamplingMode_t m_samplingMode; // = "WorldSpace"
	float32 m_flSamplingPositionErrorThreshold; // = 2
	float32 m_flMaxTangentLength; // = 49
	float32 m_flLerpFallbackDistanceThreshold; // = 4
	float32 m_flTargetUpdateDistanceThresholdDegrees; // = 4
	float32 m_flTargetUpdateAngleThresholdDegrees; // = 5
};
