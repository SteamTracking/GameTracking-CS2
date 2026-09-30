// MHasKV3TransferPolymorphicClassname
class CNmBoneMaskSwitchNode::CDefinition : public CNmBoneMaskValueNode::CDefinition
{
	int16 m_nSwitchValueNodeIdx; // = -1
	int16 m_nTrueValueNodeIdx; // = -1
	int16 m_nFalseValueNodeIdx; // = -1
	float32 m_flBlendTimeSeconds; // = 0.1
	bool m_bSwitchDynamically;
};
