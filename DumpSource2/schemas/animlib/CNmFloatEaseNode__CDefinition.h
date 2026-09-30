// MHasKV3TransferPolymorphicClassname
class CNmFloatEaseNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	float32 m_flEaseTime; // = 1
	float32 m_flStartValue;
	int16 m_nInputValueNodeIdx; // = -1
	NmEasingOperation_t m_easingOp; // = "Linear"
	bool m_bUseStartValue;
};
