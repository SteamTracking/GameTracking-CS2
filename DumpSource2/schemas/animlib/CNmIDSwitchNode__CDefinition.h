// MHasKV3TransferPolymorphicClassname
class CNmIDSwitchNode::CDefinition : public CNmIDValueNode::CDefinition
{
	int16 m_nSwitchValueNodeIdx; // = -1
	int16 m_nTrueValueNodeIdx; // = -1
	int16 m_nFalseValueNodeIdx; // = -1
	CGlobalSymbol m_falseValue;
	CGlobalSymbol m_trueValue;
};
