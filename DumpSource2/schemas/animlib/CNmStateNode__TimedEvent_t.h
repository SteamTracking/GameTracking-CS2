class CNmStateNode::TimedEvent_t
{
	CGlobalSymbol m_ID;
	float32 m_flTimeValueSeconds;
	CNmStateNode::TimedEvent_t::Comparison_t m_comparisionOperator; // = "LessThanEqual"
};
