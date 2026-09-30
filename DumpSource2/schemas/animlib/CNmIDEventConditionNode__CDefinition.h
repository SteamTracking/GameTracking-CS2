// MHasKV3TransferPolymorphicClassname
class CNmIDEventConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	CNmBitFlags m_eventConditionRules;
	CUtlVectorFixedGrowable< CGlobalSymbol, 5 > m_eventIDs;
};
