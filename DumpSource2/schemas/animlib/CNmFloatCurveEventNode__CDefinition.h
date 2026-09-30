// MHasKV3TransferPolymorphicClassname
class CNmFloatCurveEventNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	CGlobalSymbol m_eventID;
	int16 m_nDefaultNodeIdx; // = -1
	float32 m_flDefaultValue;
	CNmBitFlags m_eventConditionRules;
};
