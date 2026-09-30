// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFloatSpringNode : public CNmGraphDocFlowNode
{
	// MPropertyDescription = "Valid Range [0.1 : 30]"
	float32 m_flHertz; // = 4
	// MPropertyDescription = "Valid Range [0 : 10], 1 = Critically Damped"
	float32 m_flDampingRatio; // = 0.7
	// MPropertyDescription = "Should we initialize this node to the input value or to the specified start value"
	bool m_bUseStartValue; // = true
	// MPropertyDescription = "Optional initialization value for this node"
	float32 m_flStartValue;
};
