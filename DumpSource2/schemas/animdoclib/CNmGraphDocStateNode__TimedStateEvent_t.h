// MPropertyAutoExpandSelf
class CNmGraphDocStateNode::TimedStateEvent_t
{
	// MPropertyAttributeEditor = "AnimGraphID()"
	CGlobalSymbol m_ID;
	CNmGraphDocStateNode::TimedStateEventType_t m_type; // = "TimeElapsed"
	CNmStateNode::TimedEvent_t::Comparison_t m_comparisonOperator; // = "LessThanEqual"
	float32 m_flTimeValueSeconds; // = 0.2
};
