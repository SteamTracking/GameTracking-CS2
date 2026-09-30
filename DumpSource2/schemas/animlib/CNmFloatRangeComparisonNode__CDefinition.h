// MHasKV3TransferPolymorphicClassname
class CNmFloatRangeComparisonNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	Range_t m_range; // = { "m_flMax": -340282346638528859811704183484516925440, "m_flMin": 340282346638528859811704183484516925440 }
	int16 m_nInputValueNodeIdx; // = -1
	bool m_bIsInclusiveCheck; // = true
};
