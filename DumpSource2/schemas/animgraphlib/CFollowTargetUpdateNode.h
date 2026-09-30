// MHasKV3TransferPolymorphicClassname
class CFollowTargetUpdateNode : public CUnaryUpdateNode
{
	FollowTargetOpFixedSettings_t m_opFixedData; // = { "m_bBoneTarget": true, "m_bMatchTargetOrientation": false, "m_bWorldCoodinateTarget": true, "m_boneIndex": -1, "m_boneTargetIndex": -1 }
	CAnimParamHandle m_hParameterPosition; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hParameterOrientation; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
};
