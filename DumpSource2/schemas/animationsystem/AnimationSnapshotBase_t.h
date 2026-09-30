class AnimationSnapshotBase_t
{
	float32 m_flRealTime;
	matrix3x4a_t m_rootToWorld;
	bool m_bBonesInWorldSpace;
	CUtlVector< uint32 > m_boneSetupMask;
	CUtlVector< matrix3x4a_t > m_boneTransforms;
	CUtlVector< float32 > m_flexControllers;
	AnimationSnapshotType_t m_SnapshotType; // = "ANIMATION_SNAPSHOT_SERVER_SIMULATION"
	bool m_bHasDecodeDump;
	AnimationDecodeDebugDumpElement_t m_DecodeDump;
};
