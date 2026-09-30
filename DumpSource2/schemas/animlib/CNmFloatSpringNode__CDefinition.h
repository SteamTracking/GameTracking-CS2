// MHasKV3TransferPolymorphicClassname
class CNmFloatSpringNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	float32 m_flStartValue;
	float32 m_flHertz; // = 4
	float32 m_flDampingRatio; // = 0.7
	int16 m_nInputValueNodeIdx; // = -1
	bool m_bUseStartValue;
};
