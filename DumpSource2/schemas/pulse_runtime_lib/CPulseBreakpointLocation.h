class CPulseBreakpointLocation
{
	PulseDocNodeID_t m_NodeID; // = -1
	PulseSymbol_t m_SequencePoint;
	PulseSymbol_t m_PortName;
	bool m_bDeferBreak;
};
