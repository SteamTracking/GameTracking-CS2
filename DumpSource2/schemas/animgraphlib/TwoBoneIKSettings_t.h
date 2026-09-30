class TwoBoneIKSettings_t
{
	IkEndEffectorType m_endEffectorType; // = "IkEndEffector_Bone"
	CAnimAttachment m_endEffectorAttachment;
	IkTargetType m_targetType; // = "IkTarget_Bone"
	CAnimAttachment m_targetAttachment;
	int32 m_targetBoneIndex; // = -1
	CAnimParamHandle m_hPositionParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hRotationParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	bool m_bAlwaysUseFallbackHinge;
	VectorAligned m_vLsFallbackHingeAxis; // = [ 0, 1, 0 ]
	int32 m_nFixedBoneIndex; // = -1
	int32 m_nMiddleBoneIndex; // = -1
	int32 m_nEndBoneIndex; // = -1
	bool m_bMatchTargetOrientation;
	bool m_bConstrainTwist;
	float32 m_flMaxTwist; // = 15
};
