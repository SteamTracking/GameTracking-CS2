// MHasKV3TransferPolymorphicClassname
class CNmIDEventNode::CDefinition : public CNmIDValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	CNmBitFlags m_eventConditionRules;
	CGlobalSymbol m_defaultValue;
};
