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
	CNmSyncTrack m_syncTrack; // = { "m_nStartEventOffset": 0, "m_syncEvents": [ { "m_ID": "", "m_duration": { "m_flValue": 1 }, "m_startTime": { "m_flValue": 0 } } ] }
	CNmRootMotionData m_rootMotion;
	bool m_bIsAdditive;
	CUtlVector< CNmClip::ModelSpaceSamplingChainLink_t > m_modelSpaceSamplingChain;
	CUtlVector< int32 > m_modelSpaceBoneSamplingIndices;
};
