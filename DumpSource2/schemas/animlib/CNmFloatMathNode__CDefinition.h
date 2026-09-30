// MHasKV3TransferPolymorphicClassname
class CNmFloatMathNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	int16 m_nInputValueNodeIdxA; // = -1
	int16 m_nInputValueNodeIdxB; // = -1
	bool m_bReturnAbsoluteResult;
	bool m_bReturnNegatedResult;
	CNmFloatMathNode::Operator_t m_operator; // = "Add"
	float32 m_flValueB;
};
