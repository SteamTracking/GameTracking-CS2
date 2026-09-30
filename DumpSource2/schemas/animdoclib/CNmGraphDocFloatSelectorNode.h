// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFloatSelectorNode : public CNmGraphDocFlowNode
{
	// MPropertyAutoExpandSelf
	// MPropertyResizable = 0
	CUtlVector< CNmGraphDocFloatSelectorNode::Option_t > m_options; // = [ { "m_flValue": 0, "m_name": "Option" }, { "m_flValue": 0, "m_name": "Option" } ]
	float32 m_flDefaultValue;
	// MPropertyGroupName = "+Easing"
	NmEasingOperation_t m_easing; // = "None"
	// MPropertyGroupName = "+Easing"
	float32 m_easeTime; // = 0.3
};
