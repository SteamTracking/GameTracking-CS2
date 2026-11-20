class CNmClip
{
	CStrongHandle< InfoForResourceTypeCNmSkeleton > m_skeleton;
	uint32 m_nNumFrames;
	float32 m_flDuration;
	CUtlBinaryBlock m_compressedPoseData; // = "[BINARY BLOB]"
	CUtlVector< NmCompressionSettings_t > m_trackCompressionSettings;
	CUtlVector< uint32 > m_compressedPoseOffsets;
	CUtlVectorFixedGrowable< CNmClip*, 1 > m_secondaryAnimations;
	CUtlVectorFixedGrowable< CNmFloatChannelData*, 2 > m_floatChannelData;
	CNmSyncTrack m_syncTrack;
	CNmRootMotionData m_rootMotion;
	bool m_bIsAdditive;
	CUtlVector< CNmClip::ModelSpaceSamplingChainLink_t > m_modelSpaceSamplingChain;
	CUtlVector< int32 > m_modelSpaceBoneSamplingIndices;
};
