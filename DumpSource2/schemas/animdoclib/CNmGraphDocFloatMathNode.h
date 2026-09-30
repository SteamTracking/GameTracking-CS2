// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFloatMathNode : public CNmGraphDocFlowNode
{
	// MPropertyDescription = "Should we apply an abs to the result (is performed before we take into account the negate option)"
	bool m_bReturnAbsoluteResult;
	// MPropertyDescription = "Should we negate the result (absolute value will be performed before negation)"
	bool m_bReturnNegatedResult;
	CNmFloatMathNode::Operator_t m_operator; // = "Add"
	float32 m_flValueB;
};
