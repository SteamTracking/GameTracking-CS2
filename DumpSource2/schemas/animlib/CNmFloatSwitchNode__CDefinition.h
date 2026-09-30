// MHasKV3TransferPolymorphicClassname
class CNmFloatSwitchNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	int16 m_nSwitchValueNodeIdx; // = -1
	int16 m_nTrueValueNodeIdx; // = -1
	int16 m_nFalseValueNodeIdx; // = -1
	float32 m_flFalseValue;
	float32 m_flTrueValue; // = 1
};
