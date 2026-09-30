// MHasKV3TransferPolymorphicClassname
class CNmIDEventPercentageThroughNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	CNmBitFlags m_eventConditionRules;
	CGlobalSymbol m_eventID;
};
